return {
  "projekt0n/github-nvim-theme",
  lazy = false,
  name = "github-theme",
  priority = 1000,
  config = function()
    require("github-theme").setup({
      options = { transparent = true },
    })
    vim.cmd.colorscheme "github_dark_high_contrast"
  end
}
