return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}

    opts.formatters_by_ft.javascript = { "prettier" }
    opts.formatters_by_ft.typescript = { "prettier" }
    opts.formatters_by_ft.javascriptreact = { "prettier" }
    opts.formatters_by_ft.typescriptreact = { "prettier" }

    return opts
  end,
}
