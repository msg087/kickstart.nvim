local M = {}

local state = {
  search = '',
  replacement = '',
  matches = {},
  sections = {},
  excluded = {},
  row_to_key = {},
  navigable_rows = {},
  nav_index_by_row = {},
  nav_rows = {},
  diff_mode = 'word', -- 'word' or 'char'
  buf = nil,
  win = nil,
}

local ns = vim.api.nvim_create_namespace 'global-find-replace'
local nav_ns = vim.api.nvim_create_namespace 'global-find-replace-navigation'

local render_preview

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, {
    title = 'Global Find/Replace',
  })
end

local function setup_highlights()
  vim.api.nvim_set_hl(0, 'GlobalReplaceDeleteLine', { link = 'DiffDelete' })
  vim.api.nvim_set_hl(0, 'GlobalReplaceAddLine', { link = 'DiffAdd' })
  vim.api.nvim_set_hl(0, 'GlobalReplaceDeleteText', {
    bg = '#7f1d1d',
    bold = true,
    strikethrough = true,
  })
  vim.api.nvim_set_hl(0, 'GlobalReplaceAddText', {
    bg = '#14532d',
    bold = true,
  })
  vim.api.nvim_set_hl(0, 'GlobalReplaceDeleteSign', {
    fg = '#f87171',
    bold = true,
  })
  vim.api.nvim_set_hl(0, 'GlobalReplaceAddSign', {
    fg = '#4ade80',
    bold = true,
  })
  vim.api.nvim_set_hl(0, 'GlobalReplaceExcludedSign', {
    fg = '#ff4d4d',
    bold = true,
  })
  vim.api.nvim_set_hl(0, 'GlobalReplaceExcludedLine', {
    link = 'Comment',
  })
  vim.api.nvim_set_hl(0, 'GlobalReplaceCount', {
    link = 'Number',
  })
  vim.api.nvim_set_hl(0, 'GlobalReplaceRelativeNumber', {
    link = 'LineNr',
  })
  vim.api.nvim_set_hl(0, 'GlobalReplaceCurrentNumber', {
    link = 'CursorLineNr',
  })
end

local markdown_language_aliases = {
  javascriptreact = 'jsx',
  typescriptreact = 'tsx',
  sh = 'bash',
  zsh = 'bash',
  dosbatch = 'bat',
  ps1 = 'powershell',
  cs = 'csharp',
}

local function markdown_language_for_file(filename)
  local filetype = vim.filetype.match { filename = filename } or ''
  return markdown_language_aliases[filetype] or filetype
end

local function replace_literal(line, search, replacement)
  if search == '' then
    return line, 0
  end

  local result = {}
  local start_index = 1
  local count = 0

  while true do
    local match_start, match_end = line:find(search, start_index, true)
    if not match_start then
      table.insert(result, line:sub(start_index))
      break
    end

    table.insert(result, line:sub(start_index, match_start - 1))
    table.insert(result, replacement)
    count = count + 1
    start_index = match_end + 1
  end

  return table.concat(result), count
end

local function parse_rg_output(output)
  local matches = {}

  for line in output:gmatch '[^\r\n]+' do
    local filename, line_number, column_number, text = line:match '^(.-):(%d+):(%d+):(.*)$'
    if filename then
      table.insert(matches, {
        filename = filename,
        line_number = tonumber(line_number),
        column_number = tonumber(column_number),
        text = text,
      })
    end
  end

  return matches
end

local function run_rg(search, callback)
  if vim.fn.executable 'rg' ~= 1 then
    notify('ripgrep (`rg`) was not found in PATH.', vim.log.levels.ERROR)
    return
  end

  vim.system({
    'rg',
    '--vimgrep',
    '--fixed-strings',
    '--color=never',
    '--',
    search,
    '.',
  }, {
    cwd = vim.fn.getcwd(),
    text = true,
  }, function(result)
    vim.schedule(function()
      if result.code ~= 0 and result.code ~= 1 then
        notify('ripgrep failed:\n' .. (result.stderr or 'Unknown error'), vim.log.levels.ERROR)
        return
      end

      callback(parse_rg_output(result.stdout or ''))
    end)
  end)
end

local function close_window()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  state.win = nil
  state.buf = nil
end

local function section_key(filename, line_number)
  return string.format('%s:%d', filename, line_number)
end

local function rebuild_sections()
  local by_key = {}
  local sections = {}

  for _, match in ipairs(state.matches) do
    local key = section_key(match.filename, match.line_number)
    local section = by_key[key]

    if not section then
      section = {
        key = key,
        filename = match.filename,
        line_number = match.line_number,
        first_column = match.column_number,
        text = match.text,
        match_count = 0,
      }
      by_key[key] = section
      table.insert(sections, section)
    end

    section.match_count = section.match_count + 1
    section.first_column = math.min(section.first_column, match.column_number)
  end

  table.sort(sections, function(a, b)
    if a.filename == b.filename then
      return a.line_number < b.line_number
    end
    return a.filename < b.filename
  end)

  state.sections = sections
end

local function replacement_counts()
  local total = 0
  local targeted = 0

  for _, section in ipairs(state.sections) do
    total = total + section.match_count
    if not state.excluded[section.key] then
      targeted = targeted + section.match_count
    end
  end

  return total, targeted, total - targeted
end

local function targeted_file_count()
  local files = {}
  for _, section in ipairs(state.sections) do
    if not state.excluded[section.key] then
      files[section.filename] = true
    end
  end
  return vim.tbl_count(files)
end

local function add_fenced_code(lines, language, text)
  local fence = text:find('```', 1, true) and '~~~~' or '```'
  table.insert(lines, fence .. language)
  table.insert(lines, text)
  local code_row = #lines - 1
  table.insert(lines, fence)
  return code_row
end

local function utf8_tokens(text)
  local tokens = {}
  local byte_index = 1
  local char_count = vim.fn.strchars(text)

  for i = 0, char_count - 1 do
    local value = vim.fn.strcharpart(text, i, 1)
    local start_col = byte_index - 1
    byte_index = byte_index + #value
    table.insert(tokens, {
      value = value,
      start_col = start_col,
      end_col = byte_index - 1,
    })
  end

  return tokens
end

local function word_tokens(text)
  local tokens = {}
  local i = 1

  while i <= #text do
    local start_i = i
    local ch = text:sub(i, i)
    local kind

    if ch:match '[%w_]' then
      kind = 'word'
      i = i + 1
      while i <= #text and text:sub(i, i):match '[%w_]' do
        i = i + 1
      end
    elseif ch:match '%s' then
      kind = 'space'
      i = i + 1
      while i <= #text and text:sub(i, i):match '%s' do
        i = i + 1
      end
    else
      kind = 'punct'
      local first = vim.fn.strcharpart(text:sub(i), 0, 1)
      i = i + #first
      while i <= #text do
        local next_char = vim.fn.strcharpart(text:sub(i), 0, 1)
        if next_char:match '[%w_]' or next_char:match '%s' then
          break
        end
        i = i + #next_char
      end
    end

    table.insert(tokens, {
      value = text:sub(start_i, i - 1),
      start_col = start_i - 1,
      end_col = i - 1,
      kind = kind,
    })
  end

  return tokens
end

local function tokenize(text, mode)
  return mode == 'char' and utf8_tokens(text) or word_tokens(text)
end

local function token_text(tokens)
  local values = {}
  for _, token in ipairs(tokens) do
    table.insert(values, token.value)
  end
  return table.concat(values, '\n') .. '\n'
end

local function token_range(tokens, start_index, count)
  if count <= 0 or #tokens == 0 then
    return nil
  end

  local first = tokens[start_index]
  local last = tokens[start_index + count - 1]
  if not first or not last then
    return nil
  end

  return first.start_col, last.end_col
end

local function native_diff_ranges(original, replacement, mode)
  local original_tokens = tokenize(original, mode)
  local replacement_tokens = tokenize(replacement, mode)
  local removed = {}
  local added = {}

  local ok, hunks = pcall(vim.diff, token_text(original_tokens), token_text(replacement_tokens), {
    result_type = 'indices',
    algorithm = 'histogram',
  })

  if not ok then
    return removed, added
  end

  for _, hunk in ipairs(hunks) do
    local original_start, original_count = hunk[1], hunk[2]
    local replacement_start, replacement_count = hunk[3], hunk[4]

    local start_col, end_col = token_range(original_tokens, original_start, original_count)
    if start_col then
      table.insert(removed, { start_col = start_col, end_col = end_col })
    end

    start_col, end_col = token_range(replacement_tokens, replacement_start, replacement_count)
    if start_col then
      table.insert(added, { start_col = start_col, end_col = end_col })
    end
  end

  return removed, added
end

local function set_range_highlights(buf, row, ranges, hl_group)
  for _, range in ipairs(ranges) do
    vim.api.nvim_buf_set_extmark(buf, ns, row, range.start_col, {
      end_col = range.end_col,
      hl_group = hl_group,
      priority = 220,
    })
  end
end

local function create_preview_lines()
  local total, targeted, excluded = replacement_counts()

  local lines = {
    '# Global Find/Replace',
    '',
    'Directory:             ' .. vim.fn.getcwd(),
    'Search:                ' .. state.search,
    'Replacement:           ' .. state.replacement,
    'Diff detail:           ' .. state.diff_mode,
    '',
    'Total matches:         ' .. total,
    'Targeted replacements: ' .. targeted,
    'Excluded replacements: ' .. excluded,
    '',
    'Keys:',
    '  s         Change search text',
    '  r         Change replacement text',
    '  d         Toggle word/character diff detail',
    '  x         Include/exclude source line (works with Visual Line mode)',
    '  R         Refresh preview',
    '  <Enter>   Apply targeted replacements',
    '  q / <Esc> Cancel',
    '',
    string.rep('─', 72),
    '',
  }

  local decorations = {}
  local items = 0
  state.row_to_key = {}
  state.navigable_rows = {}
  state.nav_index_by_row = {}
  state.nav_rows = {}

  if #state.sections == 0 then
    table.insert(lines, 'No matches found.')
    return lines, decorations
  end

  for _, section in ipairs(state.sections) do
    items = items + 1
    local replaced_text = replace_literal(section.text, state.search, state.replacement)
    local language = markdown_language_for_file(section.filename)
    local excluded_section = state.excluded[section.key] == true

    table.insert(
      lines,
      string.format(
        '    %d - %s:%d:%d  (%d replacement%s)',
        items,
        section.filename,
        section.line_number,
        section.first_column,
        section.match_count,
        section.match_count == 1 and '' or 's'
      )
    )
    local header_row = #lines - 1

    local delete_row = add_fenced_code(lines, language, section.text)
    local add_row = add_fenced_code(lines, language, replaced_text)
    table.insert(lines, '')
    local blank_row = #lines - 1

    for row = header_row, blank_row do
      state.row_to_key[row] = section.key
      -- state.navigable_rows[header_row] = true
    end

    state.navigable_rows[header_row] = true
    table.insert(state.nav_rows, header_row)
    state.nav_index_by_row[header_row] = #state.nav_rows

    local removed_ranges, added_ranges = native_diff_ranges(section.text, replaced_text, state.diff_mode)

    table.insert(decorations, {
      section = section,
      excluded = excluded_section,
      header_row = header_row,
      delete_row = delete_row,
      add_row = add_row,
      removed_ranges = removed_ranges,
      added_ranges = added_ranges,
    })
  end

  return lines, decorations
end

local function current_nav_index()
  if not state.win or not vim.api.nvim_win_is_valid(state.win) then
    return nil
  end

  local cursor_row = vim.api.nvim_win_get_cursor(state.win)[1] - 1
  return state.nav_index_by_row[cursor_row]
end

local function decorate_navigation_numbers()
  local cursor_index = current_nav_index()

  for index, row in ipairs(state.nav_rows) do
    local text_value
    local hl_group

    if cursor_index and index == cursor_index then
      text_value = string.format('%3d ', index)
      hl_group = 'GlobalReplaceCurrentNumber'
    elseif cursor_index then
      text_value = string.format('%3d ', math.abs(index - cursor_index))
      hl_group = 'GlobalReplaceRelativeNumber'
    else
      text_value = string.format('%3d ', index)
      hl_group = 'GlobalReplaceRelativeNumber'
    end

    vim.api.nvim_buf_set_extmark(state.buf, nav_ns, row, 0, {
      virt_text = { { text_value, hl_group } },
      virt_text_win_col = 0,
      priority = 300,
    })
  end
end

local function refresh_navigation_numbers()
  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    return
  end

  vim.api.nvim_buf_clear_namespace(state.buf, nav_ns, 0, -1)
  decorate_navigation_numbers()
end

local function move_to_navigable_row(direction)
  if not state.win or not vim.api.nvim_win_is_valid(state.win) then
    return
  end

  local remaining = vim.v.count1
  local current_row = vim.api.nvim_win_get_cursor(state.win)[1] - 1
  local line_count = vim.api.nvim_buf_line_count(state.buf)
  local row = current_row

  while remaining > 0 do
    row = row + direction

    while row >= 0 and row < line_count and not state.navigable_rows[row] do
      row = row + direction
    end

    if row < 0 or row >= line_count then
      return
    end

    remaining = remaining - 1
  end

  -- vim.api.nvim_win_set_cursor(state.win, { row + 1, 0 })
  -- vim.cmd.redrawstatus()

  vim.api.nvim_win_set_cursor(state.win, { row + 1, 0 })
  refresh_navigation_numbers()
end

-- local function move_to_navigable_row(direction)
--   if not state.win or not vim.api.nvim_win_is_valid(state.win) then
--     return
--   end

--   local current_row = vim.api.nvim_win_get_cursor(state.win)[1] - 1
--   local line_count = vim.api.nvim_buf_line_count(state.buf)
--   local row = current_row + direction

--   while row >= 0 and row < line_count do
--     if state.navigable_rows[row] then
--       vim.api.nvim_win_set_cursor(state.win, { row + 1, 0 })
--       return
--     end

--     row = row + direction
--   end
-- end

local function highlight_metadata()
  local lines = vim.api.nvim_buf_get_lines(state.buf, 0, -1, false)

  for index, line in ipairs(lines) do
    local row = index - 1
    if line:match '^# ' then
      vim.api.nvim_buf_add_highlight(state.buf, ns, 'Title', row, 0, -1)
    elseif line:match '^Directory:' then
      vim.api.nvim_buf_add_highlight(state.buf, ns, 'Directory', row, 0, -1)
    elseif line:match '^Search:' then
      vim.api.nvim_buf_add_highlight(state.buf, ns, 'Search', row, 0, -1)
    elseif line:match '^Replacement:' then
      vim.api.nvim_buf_add_highlight(state.buf, ns, 'String', row, 0, -1)
    elseif line:match '^Diff detail:' then
      vim.api.nvim_buf_add_highlight(state.buf, ns, 'Keyword', row, 0, -1)
    elseif line:match '^Total matches:' or line:match '^Targeted replacements:' or line:match '^Excluded replacements:' then
      vim.api.nvim_buf_add_highlight(state.buf, ns, 'GlobalReplaceCount', row, 0, -1)
    elseif line:match '^%S+:%d+:%d+' then
      vim.api.nvim_buf_add_highlight(state.buf, ns, 'Underlined', row, 0, -1)
    end
  end
end

local function decorate_section(item)
  local section = item.section

  if item.excluded then
    for _, row in ipairs { item.header_row, item.delete_row, item.add_row } do
      vim.api.nvim_buf_set_extmark(state.buf, ns, row, 0, {
        line_hl_group = 'GlobalReplaceExcludedLine',
        priority = 230,
      })
    end

    vim.api.nvim_buf_set_extmark(state.buf, ns, item.header_row, 0, {
      virt_text = { { 'X ', 'GlobalReplaceExcludedSign' } },
      virt_text_pos = 'inline',
      priority = 250,
    })
    return
  end

  vim.api.nvim_buf_set_extmark(state.buf, ns, item.delete_row, 0, {
    line_hl_group = 'GlobalReplaceDeleteLine',
    virt_text = { { '- ', 'GlobalReplaceDeleteSign' } },
    virt_text_pos = 'inline',
    priority = 210,
  })

  vim.api.nvim_buf_set_extmark(state.buf, ns, item.add_row, 0, {
    line_hl_group = 'GlobalReplaceAddLine',
    virt_text = { { '+ ', 'GlobalReplaceAddSign' } },
    virt_text_pos = 'inline',
    priority = 210,
  })

  set_range_highlights(state.buf, item.delete_row, item.removed_ranges, 'GlobalReplaceDeleteText')
  set_range_highlights(state.buf, item.add_row, item.added_ranges, 'GlobalReplaceAddText')
end

render_preview = function()
  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    return
  end

  local cursor_row = 1
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    cursor_row = vim.api.nvim_win_get_cursor(state.win)[1]
  end

  local lines, decorations = create_preview_lines()

  vim.bo[state.buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.bo[state.buf].modifiable = false

  vim.api.nvim_buf_clear_namespace(state.buf, ns, 0, -1)
  vim.api.nvim_buf_clear_namespace(state.buf, nav_ns, 0, -1)
  highlight_metadata()

  for _, item in ipairs(decorations) do
    decorate_section(item)
  end

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    local max_row = vim.api.nvim_buf_line_count(state.buf)
    vim.api.nvim_win_set_cursor(state.win, { math.min(cursor_row, max_row), 0 })
  end

  refresh_navigation_numbers()
end

local function refresh_preview()
  if state.search == '' then
    state.matches = {}
    state.sections = {}
    render_preview()
    return
  end

  run_rg(state.search, function(matches)
    state.matches = matches
    rebuild_sections()
    render_preview()
  end)
end

local function toggle_diff_mode()
  state.diff_mode = state.diff_mode == 'word' and 'char' or 'word'
  render_preview()
end

local function keys_in_row_range(start_row, end_row)
  local keys = {}
  for row = start_row, end_row do
    local key = state.row_to_key[row]
    if key then
      keys[key] = true
    end
  end
  return keys
end

local function toggle_keys(keys)
  local any_included = false
  for key in pairs(keys) do
    if not state.excluded[key] then
      any_included = true
      break
    end
  end

  -- Mixed selections become excluded. If all are already excluded, re-enable all.
  local new_value = any_included
  for key in pairs(keys) do
    state.excluded[key] = new_value or nil
  end

  render_preview()
end

local function toggle_current_section()
  local row = vim.api.nvim_win_get_cursor(state.win)[1] - 1
  local key = state.row_to_key[row]
  if not key then
    notify('Move the cursor onto a replacement section first.', vim.log.levels.WARN)
    return
  end

  toggle_keys { [key] = true }
end

local function toggle_visual_sections()
  local start_row = vim.fn.line 'v' - 1
  local end_row = vim.fn.line '.' - 1
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)
  if start_row > end_row then
    start_row, end_row = end_row, start_row
  end

  local keys = keys_in_row_range(start_row, end_row)
  if vim.tbl_isempty(keys) then
    notify('The selection does not contain any replacement sections.', vim.log.levels.WARN)
    return
  end

  toggle_keys(keys)
end

local function targeted_sections_by_file()
  local files = {}

  for _, section in ipairs(state.sections) do
    if not state.excluded[section.key] then
      files[section.filename] = files[section.filename] or {}
      files[section.filename][section.line_number] = section
    end
  end

  return files
end

local function find_modified_buffers(files)
  local modified = {}

  for filename in pairs(files) do
    local absolute_path = vim.fs.abspath(filename)
    local bufnr = vim.fn.bufnr(absolute_path)
    if bufnr ~= -1 and vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].modified then
      table.insert(modified, filename)
    end
  end

  table.sort(modified)
  return modified
end

local function replace_targeted_lines(lines, targeted_lines)
  local changed = false
  local replacement_count = 0

  for line_number in pairs(targeted_lines) do
    local index = line_number
    local line = lines[index]
    if line ~= nil then
      local replaced, count = replace_literal(line, state.search, state.replacement)
      if count > 0 then
        lines[index] = replaced
        changed = true
        replacement_count = replacement_count + count
      end
    end
  end

  return changed, replacement_count
end

local function replace_in_loaded_buffer(bufnr, targeted_lines)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local changed, count = replace_targeted_lines(lines, targeted_lines)

  if changed then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd 'silent write'
    end)
  end

  return count
end

local function replace_in_file(filename, targeted_lines)
  local absolute_path = vim.fs.abspath(filename)
  local bufnr = vim.fn.bufnr(absolute_path)

  if bufnr ~= -1 and vim.api.nvim_buf_is_loaded(bufnr) then
    return replace_in_loaded_buffer(bufnr, targeted_lines)
  end

  local ok, lines = pcall(vim.fn.readfile, absolute_path)
  if not ok then
    return nil, 'Could not read ' .. filename
  end

  local changed, count = replace_targeted_lines(lines, targeted_lines)
  if changed then
    local write_ok, error_message = pcall(vim.fn.writefile, lines, absolute_path)
    if not write_ok then
      return nil, string.format('Could not write %s: %s', filename, error_message)
    end
  end

  return count
end

local function show_confirmation(on_confirm)
  local total, targeted, excluded = replacement_counts()
  local file_count = targeted_file_count()

  local lines = {
    'Apply global replacements?',
    '',
    string.format('Targeted replacements: %d', targeted),
    string.format('Excluded replacements: %d', excluded),
    string.format('Total matches:         %d', total),
    string.format('Files affected:        %d', file_count),
    '',
    'Press y or <Enter> to apply.',
    'Press n, q, or <Esc> to cancel.',
  }

  local width = 46
  local height = #lines
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    border = 'rounded',
    style = 'minimal',
    title = ' Confirm Replace ',
    title_pos = 'center',
  })

  local function finish(confirmed)
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if confirmed then
      on_confirm()
    end
  end

  local opts = { buffer = buf, silent = true, nowait = true }
  vim.keymap.set('n', 'y', function()
    finish(true)
  end, opts)
  vim.keymap.set('n', '<CR>', function()
    finish(true)
  end, opts)
  vim.keymap.set('n', 'n', function()
    finish(false)
  end, opts)
  vim.keymap.set('n', 'q', function()
    finish(false)
  end, opts)
  vim.keymap.set('n', '<Esc>', function()
    finish(false)
  end, opts)
end

local function apply_replacements()
  local _, targeted = replacement_counts()
  if targeted == 0 then
    notify('There are no targeted replacements to apply.', vim.log.levels.WARN)
    return
  end

  local files = targeted_sections_by_file()
  local modified_buffers = find_modified_buffers(files)

  if #modified_buffers > 0 then
    notify('Replacement cancelled. These targeted buffers have unsaved changes:\n' .. table.concat(modified_buffers, '\n'), vim.log.levels.ERROR)
    return
  end

  show_confirmation(function()
    local files_changed = 0
    local replacements_made = 0
    local errors = {}

    for filename, targeted_lines in pairs(files) do
      local count, error_message = replace_in_file(filename, targeted_lines)
      if count == nil then
        table.insert(errors, error_message)
      elseif count > 0 then
        files_changed = files_changed + 1
        replacements_made = replacements_made + count
      end
    end

    if #errors > 0 then
      notify(table.concat(errors, '\n'), vim.log.levels.ERROR)
    end

    close_window()
    vim.cmd 'checktime'
    notify(string.format('Made %d replacement(s) in %d file(s).', replacements_made, files_changed))
  end)
end

local function prompt_replacement()
  vim.ui.input({
    prompt = 'Replacement text: ',
    default = state.replacement,
  }, function(input)
    if input == nil then
      return
    end
    state.replacement = input
    render_preview()
  end)
end

local function prompt_search()
  vim.ui.input({
    prompt = 'Search text: ',
    default = state.search,
  }, function(input)
    if input == nil or input == '' then
      return
    end

    state.search = input
    state.excluded = {}
    refresh_preview()
  end)
end

local function set_preview_keymaps()
  local opts = {
    buffer = state.buf,
    silent = true,
    nowait = true,
  }

  vim.keymap.set('n', 'q', close_window, opts)
  vim.keymap.set('n', '<Esc>', close_window, opts)
  vim.keymap.set('n', 's', prompt_search, opts)
  vim.keymap.set('n', 'r', prompt_replacement, opts)
  vim.keymap.set('n', 'd', toggle_diff_mode, opts)
  vim.keymap.set('n', 'x', toggle_current_section, opts)
  vim.keymap.set('x', 'x', toggle_visual_sections, opts)
  vim.keymap.set('n', 'R', refresh_preview, opts)
  vim.keymap.set('n', '<CR>', apply_replacements, opts)

  vim.keymap.set('n', 'j', function()
    move_to_navigable_row(1)
  end, opts)

  vim.keymap.set('n', 'k', function()
    move_to_navigable_row(-1)
  end, opts)

  vim.keymap.set('n', '<Down>', function()
    move_to_navigable_row(1)
  end, opts)

  vim.keymap.set('n', '<Up>', function()
    move_to_navigable_row(-1)
  end, opts)
end

local function open_preview()
  close_window()
  setup_highlights()

  state.buf = vim.api.nvim_create_buf(false, true)

  local width = math.max(60, math.min(math.floor(vim.o.columns * 0.85), vim.o.columns - 4))
  local height = math.max(15, math.min(math.floor(vim.o.lines * 0.80), vim.o.lines - 4))

  state.win = vim.api.nvim_open_win(state.buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    border = 'rounded',
    style = 'minimal',
    title = ' Global Find/Replace ',
    title_pos = 'center',
  })

  vim.bo[state.buf].buftype = 'nofile'
  vim.bo[state.buf].bufhidden = 'wipe'
  vim.bo[state.buf].swapfile = false
  vim.bo[state.buf].modifiable = false
  vim.bo[state.buf].filetype = 'markdown'

  vim.wo[state.win].wrap = false
  vim.wo[state.win].cursorline = true
  vim.wo[state.win].number = false
  vim.wo[state.win].relativenumber = false
  vim.wo[state.win].conceallevel = 2
  vim.wo[state.win].concealcursor = 'nc'

  pcall(vim.treesitter.start, state.buf, 'markdown')

  set_preview_keymaps()
  render_preview()
end

local function begin_replace()
  state.search = ''
  state.replacement = ''
  state.matches = {}
  state.sections = {}
  state.excluded = {}
  state.row_to_key = {}
  state.diff_mode = 'word'

  vim.ui.input({ prompt = 'Search text: ' }, function(search)
    if search == nil or search == '' then
      return
    end

    state.search = search

    vim.ui.input({ prompt = 'Replacement text: ' }, function(replacement)
      if replacement == nil then
        return
      end

      state.replacement = replacement
      open_preview()
      refresh_preview()
    end)
  end)
end

function M.find_all_text()
  begin_replace()
end

return M
