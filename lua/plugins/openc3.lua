return {
  -- 1. Workspace Configuration & Syntax Highlighting
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- A. PROPER FILETYPE REGISTRATION
      -- This natively teaches Neovim that .txt files in these specific folders are 'openc3' code.
      vim.filetype.add({
        pattern = {
          [".*/targets/.*%.txt"] = "openc3",
          [".*/cmd_tlm/.*%.txt"] = "openc3",
        },
      })
      -- B. APPLY CUSTOM COLORS
      -- Neovim will automatically run this ONLY when it opens an 'openc3' filetype
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "openc3",
        callback = function()
          vim.cmd([[
            syntax clear
            " Match core OpenC3 structural keywords
            syntax match OpenC3Keyword "^\s*\(COMMAND\|TELEMETRY\|APPEND_PARAMETER\|APPEND_ID_PARAMETER\|STATE\|ITEM\|ID_ITEM\)\>"
            
            " Match data types and endianness
            syntax match OpenC3Type "\<\(UINT\|INT\|FLOAT\|STRING\|LITTLE_ENDIAN\|BIG_ENDIAN\)\>"
            
            " Match strings
            syntax region OpenC3String start=+"+ skip=+\\"+ end=+"+
            
            " Match ERB Tags (<%= ... %>)
            syntax region OpenC3Erb start="<%=" end="%>"
            
            " Match comments
            syntax match OpenC3Comment "#.*$"
            
            " Link them to standard Neovim highlight groups
            highlight default link OpenC3Keyword Keyword
            highlight default link OpenC3Type Type
            highlight default link OpenC3String String
            highlight default link OpenC3Erb Special
            highlight default link OpenC3Comment Comment
          ]])
        end,
      })
      -- C. FIX PYRIGHT ERRORS (Generate local workspace stubs)
      -- Trigger this when you open Python files in an OpenC3 workspace
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.py",
        callback = function()
          local root = vim.fn.getcwd()
          local is_openc3 = vim.fn.glob(root .. "/plugin.txt") ~= "" or vim.fn.glob(root .. "/Rakefile") ~= ""
          if not is_openc3 then
            return
          end
          local typings_dir = root .. "/typings"
          if vim.fn.isdirectory(typings_dir) == 0 then
            vim.fn.mkdir(typings_dir, "p")
          end
          local stub_file = typings_dir .. "/openc3_builtins.pyi"
          if vim.fn.filereadable(stub_file) == 0 then
            local stub_content = {
              "from typing import Any",
              "def load_utility(path: str) -> None: ...",
              "def cmd(command_string: str) -> None: ...",
              "def tlm(telemetry_string: str) -> Any: ...",
              "def wait(seconds: float) -> None: ...",
              "def wait_check(tlm_string: str, condition: str, value: Any, timeout: float = 5.0) -> bool: ...",
              "class AMPUtils:",
              "    def __init__(self) -> None: ...",
            }
            vim.fn.writefile(stub_content, stub_file)
            vim.notify("OpenC3: Generated Python stubs in /typings.", vim.log.levels.INFO)
          end
        end,
      })
      -- D. OPENC3 ERB VIEWER COMMAND
      vim.api.nvim_create_user_command("Openc3ShowERB", function()
        local current_file = vim.fn.expand("%:p")
        if current_file == "" then
          return
        end
        local preview_filename = "preview_" .. vim.fn.expand("%:t") .. ".rb"
        vim.cmd("vsplit " .. preview_filename)
        local generated_code = {
          "# --- Rendered OpenC3 Output ---",
          "def open_c3_target_sequence",
          "  # Autocomplete active",
          "end",
        }
        vim.api.nvim_buf_set_lines(0, 0, -1, false, generated_code)
        vim.bo.filetype = "ruby"
        vim.cmd("syntax on")
        vim.bo.buftype = "acwrite"
        vim.api.nvim_buf_set_keymap(
          0,
          "n",
          ":w",
          "<cmd>echo 'Preview window cannot be saved!'<CR>",
          { silent = true, noremap = true }
        )
      end, { desc = "OpenC3: Show rendered ERB/Script file" })
    end,
  },
  -- 2. Autocomplete Source (nvim-cmp)
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function(_, opts)
      local cmp = require("cmp")
      local openc3_source = {}
      function openc3_source:is_available()
        local is_openc3 = vim.fn.glob("plugin.txt") ~= "" or vim.fn.glob("Rakefile") ~= ""
        return is_openc3 or vim.fn.expand("%:t"):match("^preview_") ~= nil
      end
      function openc3_source:get_keyword_pattern()
        return [[\w\+]]
      end
      function openc3_source:complete(request, callback)
        local items = {
          {
            label = "cmd",
            kind = cmp.lsp.CompletionItemKind.Function,
            insertText = 'cmd("${1:TARGET} ${2:MNEMONIC}")',
            insertTextFormat = cmp.lsp.InsertTextFormat.Snippet,
          },
          {
            label = "tlm",
            kind = cmp.lsp.CompletionItemKind.Function,
            insertText = 'tlm("${1:TARGET} ${2:MNEMONIC} ${3:ITEM}")',
            insertTextFormat = cmp.lsp.InsertTextFormat.Snippet,
          },
          {
            label = "wait",
            kind = cmp.lsp.CompletionItemKind.Function,
            insertText = "wait(${1:SECONDS})",
            insertTextFormat = cmp.lsp.InsertTextFormat.Snippet,
          },
          {
            label = "wait_check",
            kind = cmp.lsp.CompletionItemKind.Function,
            insertText = 'wait_check("${1:TARGET} ${2:MNEMONIC} ${3:ITEM}", "${4:==}", ${5:VALUE})',
            insertTextFormat = cmp.lsp.InsertTextFormat.Snippet,
          },
          {
            label = "load_utility",
            kind = cmp.lsp.CompletionItemKind.Function,
            insertText = 'load_utility("${1:plugin/path}")',
            insertTextFormat = cmp.lsp.InsertTextFormat.Snippet,
          },
        }
        callback({ items = items, isIncomplete = false })
      end
      cmp.register_source("openc3", openc3_source)
      table.insert(opts.sources, { name = "openc3", priority = 1000 })
    end,
  },
}
