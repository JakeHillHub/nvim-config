return {
  -- This is the conform.nvim plugin specification
  {
    "stevearc/conform.nvim",
    -- The `opts` function will be called when conform.nvim is set up.
    -- The second argument `opts` contains the default options from LazyVim.
    opts = function(_, opts)
      -- Merge Black into the formatters_by_ft table for Python files
      opts.formatters_by_ft = opts.formatters_by_ft or {}

      -- Add Black as the formatter for python files
      opts.formatters_by_ft["python"] = { "black" }

      -- You can also optionally customize the format-on-save behavior here
      -- LazyVim already enables format-on-save by default, but this ensures it.
      -- opts.format_on_save = {
      --   timeout_ms = 500,
      --   lsp_fallback = true,
      -- }
    end,
  },
}
