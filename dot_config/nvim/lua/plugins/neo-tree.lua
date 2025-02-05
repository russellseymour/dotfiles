return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>')

    require("neo-tree").setup({
      filesystem = {
        filtered = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
          use_libuv_file_watcher = false,
          follow_current_file = {
            enable = true,
            leave_dirs_open = false,
          }
        }
      }
    })
  end
}
