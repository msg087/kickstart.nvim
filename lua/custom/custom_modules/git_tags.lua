local M = {}

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = 'Git tags' })
end

local function repository_dir(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  if filename == '' then
    return vim.fn.getcwd()
  end

  return vim.fs.dirname(filename)
end

local function parse_tags(output)
  local tags = {}

  for line in output:gmatch '[^\r\n]+' do
    local tag, date, subject = line:match '^([^\t]+)\t([^\t]*)\t(.*)$'
    if tag then
      tags[#tags + 1] = {
        tag = tag,
        date = date,
        subject = subject,
      }
    end
  end

  return tags
end

local function select_tag(opts, callback)
  opts = opts or {}
  local bufnr = vim.api.nvim_get_current_buf()
  local cwd = repository_dir(bufnr)

  vim.system({
    'git',
    'for-each-ref',
    '--sort=-creatordate',
    '--format=%(refname:short)%09%(creatordate:short)%09%(subject)',
    'refs/tags',
  }, { cwd = cwd, text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        local error_message = vim.trim(result.stderr or '')
        notify(error_message ~= '' and error_message or 'Not inside a Git repository', vim.log.levels.ERROR)
        return
      end

      local tags = parse_tags(result.stdout or '')
      if vim.tbl_isempty(tags) then
        notify('No Git tags found in this repository', vim.log.levels.WARN)
        return
      end

      local actions = require 'telescope.actions'
      local action_state = require 'telescope.actions.state'
      local entry_display = require 'telescope.pickers.entry_display'
      local finders = require 'telescope.finders'
      local pickers = require 'telescope.pickers'
      local previewers = require 'telescope.previewers'
      local conf = require('telescope.config').values

      local displayer = entry_display.create {
        separator = '  ',
        items = {
          { width = 24 },
          { width = 10 },
          { remaining = true },
        },
      }

      pickers
        .new(opts, {
          prompt_title = opts.prompt_title or 'Git tags',
          finder = finders.new_table {
            results = tags,
            entry_maker = function(item)
              return {
                value = item,
                ordinal = table.concat({ item.tag, item.date, item.subject }, ' '),
                display = function()
                  return displayer {
                    { item.tag, 'TelescopeResultsIdentifier' },
                    { item.date, 'TelescopeResultsNumber' },
                    { item.subject, 'TelescopeResultsComment' },
                  }
                end,
              }
            end,
          },
          sorter = conf.generic_sorter(opts),
          previewer = previewers.new_termopen_previewer {
            get_command = function(entry)
              return { 'git', '-C', cwd, 'show', '--no-color', '--stat', '--summary', entry.value.tag }
            end,
          },
          attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)

              if selection and vim.api.nvim_buf_is_valid(bufnr) then
                vim.api.nvim_set_current_buf(bufnr)
                callback(selection.value.tag)
              end
            end)
            return true
          end,
        })
        :find()
    end)
  end)
end

function M.diff_against_tag()
  select_tag({ prompt_title = 'Diff against tag' }, function(tag)
    require('gitsigns').diffthis(tag)
  end)
end

function M.signs_against_tag()
  select_tag({ prompt_title = 'Set Gitsigns base to tag' }, function(tag)
    require('gitsigns').change_base(tag)
    notify('Gitsigns base changed to ' .. tag)
  end)
end

return M
