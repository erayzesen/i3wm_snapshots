
colorscheme gruvbox
let mapleader=","

" Window Shortcuts
noremap <silent> <C-S-Left> :vertical resize +3<CR>
noremap <silent> <C-S-Right> :vertical resize -3<CR>
noremap <silent> <C-S-Up> :resize +3<CR>
noremap <silent> <C-S-Down> :resize -3<CR>

"QUICKFIX SETTINGS
"Single line messages
set errorformat+=%-G%.%#,%f:%l:\ %m

"autocmd FileType qf call setpos('.', [0, 1, 1, 0]) | execute 'silent! 1,' . (line('$')-1) . 'g/error:/move 0' | redraw!

"Sorting error messages to top of the list
function! SortQuickfix()
    let lines = getqflist()
    let errors = filter(copy(lines), 'v:val.text =~ "error:"')
    let warnings = filter(copy(lines), 'v:val.text =~ "warning:"')
    let infos = filter(copy(lines), 'v:val.text !~ "error:" && v:val.text !~ "warning:"')

    call setqflist(errors + warnings + infos)
    call setpos('.', [0, 1, 1, 0])
    redraw!
endfunction
autocmd FileType qf call SortQuickfix()

"Coloring error and warning messages
autocmd FileType qf highlight QuickFixWarning ctermbg=yellow ctermfg=black
autocmd FileType qf call matchadd('QuickFixWarning', '\v(warning:)')

autocmd FileType qf highlight QuickFixError ctermbg=red ctermfg=white
autocmd FileType qf call matchadd('QuickFixError', '\v(error:)')




call plug#begin()
	Plug 'ryanoasis/vim-devicons'
	" File Browsing and Tree
	Plug 'lambdalisue/fern.vim'
	Plug 'lambdalisue/fern-renderer-devicons.vim'
	" Code Autocompletion, Clang, Language Support...etc	
	Plug 'neoclide/coc.nvim', {'branch': 'release'} "W: required NodeJS
	" Multi Cursor Select Support
	Plug 'mg979/vim-visual-multi', {'branch': 'master'}
	"Code Highlighting
	Plug 'octol/vim-cpp-enhanced-highlight'
	" Code Map Scroll Bar
	Plug 'karb94/neoscroll.nvim'
	Plug 'dstein64/nvim-scrollview', { 'branch': 'main' }
	" Quickfix Window
	Plug 'kevinhwang91/nvim-bqf'
	"Status Bar 
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	" Bash Shell Script Needs
	Plug 'rantasub/vim-bash-completion'
	Plug 'itspriddle/vim-shellcheck'
	Plug 'WolfgangMehner/bash-support'
call plug#end()

"NEO SCROLL SETTINGS
lua require('neoscroll').setup()

" COC SETTINGS
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Opening Coc Explorer (Required :CocInstall coc-explorer )
:nmap <space>e <Cmd>CocCommand explorer<CR>
" Diagnostics Shortcut
nnoremap <silent><nowait> <leader>d :CocDiagnostics<CR>


" FERN SETTINGS
let g:fern#renderer = "devicons"
nnoremap <leader><leader> :Fern . -drawer -toggle <cr>
"nnoremap <C-m> :Fern . -reveal=% -toggle <cr>
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" AIRSTATUS SETTINGS
let g:airline_theme='base16_gruvbox_dark_hard'

"GENERAL SETTINGS
"No Swap Files
set noswapfile
"Mouse Input 
set mouse=a
" Global Copy to Clipboard Operations
set clipboard=unnamedplus
" Show Line Numbers
set number
" Cursor highlight
setlocal cursorline



