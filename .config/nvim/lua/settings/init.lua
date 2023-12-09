local set = vim.opt

set.expandtab = true
set.smarttab = true
set.shiftwidth = 4
set.tabstop = 4
set.mouse = "a"
set.wrap = true

set.hlsearch = true
set.incsearch = true
set.ignorecase = true
set.smartcase = true

set.splitbelow = true
set.splitright = true
set.wrap = true
-- set.linebreak = true
-- set.breakindent = true
-- set.breakindentopt = "shift:4"
set.scrolloff = 5
set.fileencoding = "utf-8"
set.termguicolors = true

set.relativenumber = true
set.number = true
set.cursorline = true

set.hidden = true
set.completeopt = "menuone,noselect,preview"

set.foldcolumn = "3"
set.foldlevel = 20
set.foldmethod = "expr"
set.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.fillchars = [[eob:~,fold:+,foldopen:,foldsep:|,foldclose:]]

vim.cmd([[
    " inoremap <Left>  <NOP>
    " inoremap <Right> <NOP>
    " inoremap <Up>    <NOP>
    " inoremap <Down>  <NOP>
    " nnoremap <Left>  <NOP>
    " nnoremap <Right> <NOP>
    " nnoremap <Up>    <NOP>
    " nnoremap <Down>  <NOP>
    nnoremap <Left>  :echoe "Use h instead"<CR>
    nnoremap <Right> :echoe "Use l instead"<CR>
    nnoremap <Up>    :echoe "Use k instead"<CR>
    nnoremap <Down>  :echoe "Use j instead"<CR>
    " inoremap <Left>  <NOP>
    " inoremap <Right> <NOP>
    " inoremap <Up>    <NOP>
    " inoremap <Down>  <NOP>
    xnoremap <C-c>   "+y
    xnoremap <C-p>   "+p
    nnoremap <C-c>   "+y
    nnoremap <C-p>   "+p
    inoremap <C-c>   <C-o>"+y
    inoremap <C-p>   <C-o>"+p
    nnoremap d       "_d
    xnoremap d       "_d

    nnoremap <C-z>   u
    xnoremap <C-z>   u
    inoremap <C-z>   <C-o>u
    nnoremap <C-y>   <C-r>
    xnoremap <C-y>   <C-r>
    inoremap <C-y>   <C-o><C-r>
    
]])

if vim.g.vscode then
    vim.cmd('source /home/makaze/.config/nvim/lua/settings/vscode.vim')
end
