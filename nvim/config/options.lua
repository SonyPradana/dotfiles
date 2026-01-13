-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Add LLVM bin directory to PATH for Treesitter compilation
local path = vim.env.PATH
local llvm_bin_path = "C:\\Program Files\\LLVM\\bin"
if not path:find(llvm_bin_path, 1, true) then
  vim.env.PATH = llvm_bin_path .. ";" .. path
end

-- Configure Treesitter to use clang compiler
vim.g.treesitter_cli_args = {
  "--quiet",
  "--cc=clang",
}

-- Specify the parser compilation directory (optional)
vim.g.treesitter_parsers_install_dir = vim.fn.stdpath("data") .. "/treesitter-parsers"

vim.g.lazyvim_php_lsp = "intelephense"
