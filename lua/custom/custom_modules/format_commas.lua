local M = {}

local function get_range()
  local mode = vim.fn.mode(1)

  if mode:match '^[vV\22]' then
    local line1 = vim.fn.getpos('v')[2]
    local line2 = vim.fn.getpos('.')[2]

    if line1 > line2 then
      line1, line2 = line2, line1
    end

    return line1, line2
  end

  local line = vim.fn.line '.'
  return line, line
end

local function split_commas(text)
  local trailing_comma = text:match ',%s*$' ~= nil

  local parts = vim.split(text, ',', {
    plain = true,
    trimempty = true,
  })

  local result = {}

  for i, part in ipairs(parts) do
    part = vim.trim(part)

    if part ~= '' then
      if i < #parts or trailing_comma then
        part = part .. ','
      end

      table.insert(result, part)
    end
  end

  return result
end

function M.format_sql_columns()
  local buf = vim.api.nvim_get_current_buf()
  local line1, line2 = get_range()

  local lines = vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, false)

  local result = {}

  for _, line in ipairs(lines) do
    local indent = line:match '^%s*' or ''
    local body = line:match '^%s*(.*)$' or line

    local keyword
    local rest

    keyword, rest = body:match '^(SELECT)%s+(.+)$'

    if not keyword then
      keyword, rest = body:match '^(RETURNING)%s+(.+)$'
    end

    if keyword then
      local parts = split_commas(rest)

      table.insert(result, indent .. keyword)

      for _, part in ipairs(parts) do
        table.insert(result, indent .. '  ' .. part)
      end
    else
      local parts = split_commas(body)

      for _, part in ipairs(parts) do
        table.insert(result, indent .. part)
      end
    end
  end

  vim.api.nvim_buf_set_lines(buf, line1 - 1, line2, false, result)

  -- exit to normal
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
end

return M

-- local M = {}

-- local function get_range()
--   local mode = vim.fn.mode(1)

--   if mode:match '^[vV\22]' then
--     local start_line = vim.fn.getpos('v')[2]
--     local end_line = vim.fn.getpos('.')[2]

--     if start_line > end_line then
--       start_line, end_line = end_line, start_line
--     end

--     return start_line, end_line
--   end

--   local line = vim.fn.line '.'
--   return line, line
-- end

-- local function split_commas(text)
--   local parts = vim.split(text, ',', {
--     plain = true,
--     trimempty = false,
--   })

--   for i, part in ipairs(parts) do
--     part = vim.trim(part)

--     if i < #parts then
--       part = part .. ','
--     end

--     parts[i] = part
--   end

--   return parts
-- end

-- function M.format_sql_columns()
--   local buf = vim.api.nvim_get_current_buf()
--   local line1, line2 = get_range()

--   local lines = vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, false)

--   local result = {}

--   for _, line in ipairs(lines) do
--     local indent = line:match '^%s*' or ''
--     local body = line:match '^%s*(.*)$' or line

--     local keyword
--     local rest

--     keyword, rest = body:match '^(SELECT)%s+(.+)$'

--     if not keyword then
--       keyword, rest = body:match '^(RETURNING)%s+(.+)$'
--     end

--     if keyword then
--       local parts = split_commas(rest)

--       -- If the line already ends in a comma, it is clearly part of an
--       -- existing multiline list. Keep the first item beside SELECT.
--       if body:match ',%s*$' then
--         table.insert(result, indent .. keyword .. ' ' .. parts[1])

--         for i = 2, #parts do
--           table.insert(result, indent .. '  ' .. parts[i])
--         end
--       else
--         -- A completely inline SELECT/RETURNING gets the keyword on
--         -- its own line.
--         table.insert(result, indent .. keyword)

--         for _, part in ipairs(parts) do
--           table.insert(result, indent .. '  ' .. part)
--         end
--       end
--     else
--       local parts = split_commas(body)

--       for _, part in ipairs(parts) do
--         table.insert(result, indent .. part)
--       end
--     end
--   end

--   vim.api.nvim_buf_set_lines(buf, line1 - 1, line2, false, result)
-- end

-- return M

-- local M = {}

-- local function split_parts(text)
--   local parts = vim.split(text, ',', {
--     plain = true,
--     trimempty = false,
--   })

--   for i, part in ipairs(parts) do
--     part = vim.trim(part)

--     if i < #parts then
--       part = part .. ','
--     end

--     parts[i] = part
--   end

--   return parts
-- end

-- function M.format_sql_columns()
--   local buf = vim.api.nvim_get_current_buf()
--   local mode = vim.fn.mode()

--   local line1
--   local line2

--   if mode == 'v' or mode == 'V' or mode == '\22' then
--     line1 = vim.fn.line "'<"
--     line2 = vim.fn.line "'>"
--   else
--     line1 = vim.fn.line '.'
--     line2 = line1
--   end

--   if line1 > line2 then
--     line1, line2 = line2, line1
--   end

--   local lines = vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, false)
--   local result = {}

--   for index, line in ipairs(lines) do
--     local indent = line:match '^%s*' or ''
--     local body = line:match '^%s*(.*)$' or line

--     local keyword
--     local rest

--     keyword, rest = body:match '^(SELECT)%s+(.+)$'

--     if not keyword then
--       keyword, rest = body:match '^(RETURNING)%s+(.+)$'
--     end

--     if keyword then
--       local next_line = lines[index + 1]

--       local has_continuation = next_line ~= nil
--         and next_line:match '^%s+'
--         and not next_line:match '^%s*(FROM|WHERE|JOIN|LEFT|RIGHT|INNER|OUTER|GROUP|ORDER|HAVING|LIMIT|RETURNING)%f[%W]'

--       local parts = split_parts(rest)

--       if keyword == 'SELECT' and has_continuation then
--         -- The SELECT list is already spread across multiple lines.
--         -- Keep the first column on the SELECT line.
--         table.insert(result, indent .. keyword .. ' ' .. parts[1])

--         for i = 2, #parts do
--           table.insert(result, indent .. '  ' .. parts[i])
--         end
--       else
--         -- Single-line SELECT/RETURNING: place keyword on its own line.
--         table.insert(result, indent .. keyword)

--         for _, part in ipairs(parts) do
--           table.insert(result, indent .. '  ' .. part)
--         end
--       end
--     else
--       local parts = split_parts(body)

--       for _, part in ipairs(parts) do
--         table.insert(result, indent .. part)
--       end
--     end
--   end

--   vim.api.nvim_buf_set_lines(buf, line1 - 1, line2, false, result)
-- end

-- return M

-- local M = {}

-- -- function M.split_commas(line1, line2)
-- --   local buf = vim.api.nvim_get_current_buf()
-- --   local lines = vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, false)

-- --   local result = {}

-- --   for _, line in ipairs(lines) do
-- --     local indent = line:match '^%s*' or ''
-- --     local body = line:match '^%s*(.*)$' or line

-- --     local keyword, rest = body:match '^(SELECT)%s+(.+)$'

-- --     if not keyword then
-- --       keyword, rest = body:match '^(RETURNING)%s+(.+)$'
-- --     end

-- --     if keyword then
-- --       table.insert(result, indent .. keyword)

-- --       local parts = vim.split(rest, ',', {
-- --         plain = true,
-- --         trimempty = false,
-- --       })

-- --       for i, part in ipairs(parts) do
-- --         part = part:gsub('^%s+', '')

-- --         if i < #parts then
-- --           part = part .. ','
-- --         end

-- --         table.insert(result, indent .. '  ' .. part)
-- --       end
-- --     else
-- --       local parts = vim.split(line, ',', {
-- --         plain = true,
-- --         trimempty = false,
-- --       })

-- --       for i, part in ipairs(parts) do
-- --         part = part:gsub('^%s+', '')

-- --         if i == 1 then
-- --           part = indent .. part
-- --         else
-- --           part = indent .. '  ' .. part
-- --         end

-- --         if i < #parts then
-- --           part = part .. ','
-- --         end

-- --         table.insert(result, part)
-- --       end
-- --     end
-- --   end

-- --   vim.api.nvim_buf_set_lines(buf, line1 - 1, line2, false, result)
-- -- end
-- --

-- function M.format_sql_columns()
--   local buf = vim.api.nvim_get_current_buf()
--   local mode = vim.fn.mode()

--   local line1
--   local line2

--   if mode == 'v' or mode == 'V' or mode == '\22' then
--     line1 = vim.fn.line "'<"
--     line2 = vim.fn.line "'>"
--   else
--     line1 = vim.fn.line '.'
--     line2 = line1
--   end

--   if line1 > line2 then
--     line1, line2 = line2, line1
--   end

--   local lines = vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, false)
--   local result = {}

--   for _, line in ipairs(lines) do
--     local indent = line:match '^%s*' or ''
--     local body = line:match '^%s*(.*)$' or line

--     local keyword
--     local rest

--     keyword, rest = body:match '^(SELECT)%s+(.+)$'

--     if not keyword then
--       keyword, rest = body:match '^(RETURNING)%s+(.+)$'
--     end

--     if keyword then
--       table.insert(result, indent .. keyword)

--       local parts = vim.split(rest, ',', {
--         plain = true,
--         trimempty = false,
--       })

--       for i, part in ipairs(parts) do
--         part = vim.trim(part)

--         if i < #parts then
--           part = part .. ','
--         end

--         table.insert(result, indent .. '  ' .. part)
--       end
--     else
--       local parts = vim.split(line, ',', {
--         plain = true,
--         trimempty = false,
--       })

--       for i, part in ipairs(parts) do
--         part = vim.trim(part)

--         if i < #parts then
--           part = part .. ','
--         end

--         table.insert(result, indent .. part)
--       end
--     end
--   end

--   vim.api.nvim_buf_set_lines(buf, line1 - 1, line2, false, result)
-- end

-- -- function M.format_sql_columns()
-- --   local buf = vim.api.nvim_get_current_buf()
-- --   local mode = vim.fn.mode()

-- --   local line1
-- --   local line2

-- --   if mode == 'v' or mode == 'V' or mode == '\22' then
-- --     line1 = vim.fn.line "'<"
-- --     line2 = vim.fn.line "'>"
-- --   else
-- --     line1 = vim.fn.line '.'
-- --     line2 = line1
-- --   end

-- --   if line1 > line2 then
-- --     line1, line2 = line2, line1
-- --   end

-- --   local lines = vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, false)
-- --   local result = {}

-- --   for _, line in ipairs(lines) do
-- --     local indent = line:match '^%s*' or ''
-- --     local body = line:match '^%s*(.*)$' or line

-- --     local keyword, rest = body:match '^(SELECT)%s+(.+)$'

-- --     if not keyword then
-- --       keyword, rest = body:match '^(RETURNING)%s+(.+)$'
-- --     end

-- --     if keyword then
-- --       table.insert(result, indent .. keyword)

-- --       local parts = vim.split(rest, ',', {
-- --         plain = true,
-- --         trimempty = false,
-- --       })

-- --       for i, part in ipairs(parts) do
-- --         part = vim.trim(part)

-- --         if i < #parts then
-- --           part = part .. ','
-- --         end

-- --         table.insert(result, indent .. '  ' .. part)
-- --       end
-- --     else
-- --       local parts = vim.split(line, ',', {
-- --         plain = true,
-- --         trimempty = false,
-- --       })

-- --       for i, part in ipairs(parts) do
-- --         part = vim.trim(part)

-- --         if i < #parts then
-- --           part = part .. ','
-- --         end

-- --         if i == 1 then
-- --           table.insert(result, indent .. part)
-- --         else
-- --           -- table.insert(result, indent .. '  ' .. part)
-- --   local parts = vim.split(line, ',', {
-- --     plain = true,
-- --     trimempty = false,
-- --   })

-- --   for i, part in ipairs(parts) do
-- --     part = vim.trim(part)

-- --     if i < #parts then
-- --       part = part .. ','
-- --     end

-- --     table.insert(result, indent .. part)
-- --         end
-- --       end
-- --     end
-- --   end

-- --   vim.api.nvim_buf_set_lines(buf, line1 - 1, line2, false, result)
-- -- end

-- return M

-- -- local M = {}

-- -- function M.split_commas(line1, line2)
-- --   local buf = vim.api.nvim_get_current_buf()
-- --   local lines = vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, false)

-- --   local result = {}

-- --   for _, line in ipairs(lines) do
-- --     local indent = line:match('^%s*') or ''
-- --     local parts = vim.split(line, ',', {
-- --       plain = true,
-- --       trimempty = false,
-- --     })

-- --     for i, part in ipairs(parts) do
-- --       part = part:gsub('^%s+', '')

-- --       if i == 1 then
-- --         part = indent .. part
-- --       else
-- --         part = indent .. part
-- --       end

-- --       if i < #parts then
-- --         part = part .. ','
-- --       end

-- --       table.insert(result, part)
-- --     end
-- --   end

-- --   vim.api.nvim_buf_set_lines(buf, line1 - 1, line2, false, result)
-- -- end

-- -- return M
