return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", -- optional, but recommended
  },
  config = function()
    vim.keymap.set('n', '<C-n>', function()
      -- Check if the focus is currently on Neo-tree
      if vim.bo.filetype == "neo-tree" then
        -- Switch focus to the previous window (bufferline)
        vim.cmd("wincmd p")
      else
        -- Focus on Neo-tree window
        vim.cmd("Neotree focus")
      end
    end, {})
  end
}
