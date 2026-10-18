-- Vesper, matching Ghostty and Starship. Italics only on comments.
return {
  {
    "datsfilipe/vesper.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      italics = { comments = true, keywords = false, functions = false, strings = false, variables = false },
    },
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "vesper" } },
}
