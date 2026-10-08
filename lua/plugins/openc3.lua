return {
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
