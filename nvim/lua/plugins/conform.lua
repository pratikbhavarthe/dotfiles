-- yamlfmt with indentless arrays (Kubernetes style) instead of prettier for YAML.
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = { yaml = { "yamlfmt" } },
    formatters = {
      yamlfmt = { prepend_args = { "-formatter", "basic", "-indentless_arrays=true" } },
    },
  },
}
