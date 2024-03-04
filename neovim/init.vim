" 1. Basics (indentation, display of filetype
syntax on
filetype on
filetype indent on
filetype plugin indent on

set tabstop=4
set softtabstop=4 expandtab
set shiftwidth=4
set smartindent
set autoindent
set nowrap

set smartcase
"set noswapfile (maybe your computer deadlocks in the middle of saving and you
"lose your work, can be handy to leave the swap files on
set nobackup

set noerrorbells
set number
set relativenumber
set scrolloff=10 " good for ctrl+d and ctrl+u half screen scrolling

" undo directory (TODO: forgot what this does)
set undodir=~/.config/nvim/undodir
set undofile

set hidden
set history=100
set noshowmode
set clipboard=unnamedplus
set nocompatible

" Vimtex
let g:vimtex_view_method = 'zathura'
let g:tex_flavor = 'latex'

"autocmd FileType vimwiki setlocal wrap linebreak | nnoremap <buffer> j gj | nnoremap <buffer> k gk
"autocmd BufRead,BufNewFile *.tex,*.md call SetTexOptions()

" fzf (Fuzzy search)
nnoremap <C-p> :Files<CR>

" CoC
let g:coc_user_config = {'diagnostic.enable': v:false}

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use `gd` to go to definition
nmap <silent> gd <Plug>(coc-definition)

" Use `gy` to go to type definition
nmap <silent> gy <Plug>(coc-type-definition)

" Use `gi` to go to implementation
nmap <silent> gi <Plug>(coc-implementation)
" Use `K` to show documentation in preview window
nmap <silent> K <Plug>(coc-show-doc)

" Use `<leader>r` to rename a symbol
nmap <silent> <leader>r <Plug>(coc-rename)
imap <C-b> `

" Copilot
" disable for md files
let g:copilot_filetypes = {
      \ 'markdown': v:false,
      \ 'vimwiki': v:false,
      \ }

let mapleader = ","
let maplocalleader = ","

nmap <leader>f :NERDTreeToggle<CR>
map <F5> :<C-U>!g++ -O2 -DLOCAL -std=c++14 -Wall -Wextra -Wno-unused-result -static %:r.cpp -o %:r<CR>

" vim plug
call plug#begin('~/.vim/plugged')

Plug 'vimwiki/vimwiki'
let g:vimwiki_list = [{'path': '~/owncloud/vimwiki',
                       \ 'syntax': 'markdown', 'ext': '.md'}]

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" do :TSInstall <language> name

" themes
Plug 'EdenEast/nightfox.nvim', {'branch': 'main'}
Plug 'morhetz/gruvbox'

Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'dhruvasagar/vim-zoom'

"Plug 'itchyny/lightline.vim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'

Plug 'lervag/vimtex'

Plug 'github/copilot.vim', {'branch': 'release'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}



call plug#end()
" Lualine
lua << EOF
require('lualine').setup {
  options = {
    theme = 'ayu_dark', -- This changes the theme. Replace 'gruvbox' with your theme.
    section_separators = {'', ''}, -- This removes the separators.
    component_separators = {'', ''}, -- This removes the separators.
    icons_enabled = true, -- This enables icons.
  },
  sections = {
    lualine_a = {'mode'}, -- This sets the component of the 'a' section.
    lualine_b = {'branch', 'diff'}, -- This sets the component of the 'b' section.
    lualine_c = {'filename'}, -- This sets the component of the 'c' section.
    lualine_x = {'encoding', 'filetype'}, -- This sets the components of the 'x' section.
    lualine_y = {'progress'}, -- This sets the component of the 'y' section.
    lualine_z = {'location'}, -- This sets the component of the 'z' section.
  },
}

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { },  -- list of languages to disable highlighting for
  },
}

require('nightfox').setup({
    -- change carbonfox theme to have black background
    palettes = {
        carbonfox = {
            bg1 = "#000000",
        },
        duskfox = {
            bg1 = "#000000",
        }
    }
})
EOF


" use <tab> to trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
