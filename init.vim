" vim-plug {{{
call plug#begin('~/.config/nvim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'bling/vim-airline'
Plug 'vim-latex/vim-latex', { 'for': 'tex' }
Plug 'eagletmt/neco-ghc', { 'for' : 'haskell' }
Plug 'eagletmt/ghcmod-vim', { 'for' : 'haskell' }
Plug 'pbrisbin/vim-syntax-shakespeare', { 'for' : 'haskell' }
Plug 'bitc/vim-hdevtools', { 'for' : 'haskell' }
Plug 'urso/haskell_syntax.vim', { 'for' : 'haskell' }
Plug 'benekastah/neomake'
Plug 'Rip-Rip/clang_complete', { 'for' : 'cpp' }
Plug 'zchee/deoplete-jedi', { 'for' : 'python' }
Plug 'atweiden/vim-dragvisuals'
Plug 'tpope/vim-fugitive'
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/vimproc.vim'
Plug 'SirVer/ultisnips'
Plug 'morhetz/gruvbox'
Plug 'tmux-plugins/vim-tmux'
Plug 'jpalardy/vim-slime'
call plug#end()
"}}}

" color scheme related {{{
set background=dark
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let g:gruvbox_italic=1
colorscheme gruvbox
syntax on
"}}}

" general settings {{{
set mouse=
set fileencodings=utf8,cp936,gb18030,big5
filetype plugin indent on
set tabstop=8
set softtabstop=8
set shiftwidth=8
"}}}

" reset cursor to last location {{{
augroup resCur
  autocmd!
  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup END
"}}}

" some auto commands {{{
augroup neomake_enable
	autocmd! BufWritePost *.c,*.cpp,*.hs,*.py Neomake
augroup end

autocmd CompleteDone * pclose

augroup filetype_html
	autocmd Filetype html,xhtml setlocal shiftwidth=2 tabstop=2
	autocmd Filetype html,xhtml nnoremap <buffer> <localleader>ft Vatzf
augroup end

augroup filetye_python
	autocmd FileType python setlocal shiftwidth=4 tabstop=4
augroup end

augroup filetype_haskell
	autocmd FileType haskell setlocal tabstop=8 expandtab softtabstop=4 shiftwidth=4 shiftround
	autocmd FileType cabal setlocal ts=2 expandtab sw=2 sts=2
	autocmd FileType hamlet setlocal expandtab softtabstop=4 shiftwidth=4 shiftround
augroup end

augroup filetye_vim
	autocmd FileType vim setlocal foldmethod=marker
augroup end
"}}}

" NerdTree {{{
noremap <C-n> :NERDTreeToggle<CR>
noremap <F5> :tabp<CR>
noremap <F5> :tabn<CR>
"}}}

" airline {{{
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
"}}}

" vim-latex {{{
set grepprg=grep\ -nH\ $*
let g:tex_flavor='tex'
let g:Tex_CompileRule_pdf='xelatex -interaction=nonstopmode $*'
let g:Tex_DefaultTargetFormat='pdf'
"}}}

" neco-ghc {{{
let g:haskellmode_completion_ghc = 0
"autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc " this seems unnecessary
"}}}

" from Damian Conway, More Instantly Better Vim - OSCON 2013 {{{
" ColorColumn
call matchadd('ColorColumn', '\%>81v', 100)
autocmd Filetype xhtml,html call clearmatches() " html is special

" jump to next
nnoremap <silent> n   n:call HLNext(0.01)<cr>
nnoremap <silent> N   N:call HLNext(0.01)<cr>

highlight WhiteOnBlack ctermbg=black ctermfg=white
function! _HLNext (blinktime)
	let [bufnum, lnum, col, off] = getpos('.')
	let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
	let target_pat = '\c\%#\%('.@/.'\)'
	let ring = matchadd('WhiteOnBlack', target_pat, 101)
	redraw
	exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
	call matchdelete(ring)
	redraw
endfunction

function! HLNext (blinktime)
	call _HLNext(a:blinktime)
	call _HLNext(a:blinktime)
	call _HLNext(a:blinktime)
endfunction

" tab/spaces
set listchars=tab:\ \ ,trail:·
set list

" colon commands
nnoremap  ;  :
nnoremap  :  ;

" visual mode
nnoremap    v   <C-V>
nnoremap <C-V>     v

vnoremap    v   <C-V>
vnoremap <C-V>     v

" dragvisual
vmap  <expr>  <LEFT>   DVB_Drag('left')
vmap  <expr>  <RIGHT>  DVB_Drag('right')
vmap  <expr>  <DOWN>   DVB_Drag('down')
vmap  <expr>  <UP>     DVB_Drag('up')
vmap  <expr>  D        DVB_Duplicate()
"}}}

" deoplete {{{
let g:deoplete#enable_at_startup = 1
let g:deoplete#disable_auto_complete = 1
inoremap <silent><expr> <Tab>
		\ pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr><C-k> deoplete#mappings#manual_complete()
augroup deoplete_special
	au FileType haskell let g:deoplete#disable_auto_complete = 0
augroup end
"}}}

" ghc-mod {{{
noremap <leader>tw :GhcModTypeInsert<CR>
noremap <leader>ts :GhcModSplitFunCase<CR>
noremap <leader>tq :GhcModType<CR>
noremap <leader>te :GhcModTypeClear<CR>
"}}}

" vim-hdevtools {{{
augroup filetype_haskell
	au FileType haskell nnoremap <buffer> <F1> :HdevtoolsType<CR>
	au FileType haskell nnoremap <buffer> <silent> <F2> :HdevtoolsClear<CR>
	au FileType haskell nnoremap <buffer> <silent> <F3> :HdevtoolsInfo<CR>
augroup end
"}}}

" clang_complete {{{
let g:clang_complete_auto = 0
let g:clang_auto_select = 0
let g:clang_omnicppcomplete_compliance = 0
let g:clang_make_default_keymappings = 0
"let g:clang_use_library = 1
"}}}

" Ultisnips {{{
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsListSnippets="<c-l>"
"}}}

" vim-slime {{{
let g:slime_target = "tmux"
"}}}

" enable this to start writing nvim-hs plugin for nvim {{{
let g:nvimhsmode = 0
if nvimhsmode
	call rpcrequest(rpcstart(expand('$HOME/bin/nvim-hs-devel.sh')), "PingNvimhs")
	augroup neomake_enable
		au!
	augroup end
endif
"}}}

" learn vimscript the hard way {{{
inoremap <c-u> <esc>viwUea
nnoremap <c-u> viwUe

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

nnoremap <leader>" viw<esc>a"<esc>bi"<esc>ee
nnoremap <leader>( viw<esc>a)<esc>bi(<esc>ee
vnoremap <leader>" viw<esc>`>a"<esc>`<i"<esc>`>2l
vnoremap <leader>( viw<esc>`>a)<esc>`<i(<esc>`>2l

nnoremap H 0
nnoremap L $

inoremap jk <esc>
inoremap <esc> <nop>

onoremap in( :<c-u>normal! f(vi(<CR>
onoremap il( :<c-u>normal! F)vi)<CR>
onoremap an( :<c-u>normal! f(va(<CR>
onoremap al( :<c-u>normal! F)va)<CR>

onoremap in{ :<c-u>execute "normal! /{\r:noh\rvi{"<CR>
onoremap il{ :<c-u>execute "normal! /}\rN:noh\rvi}"<CR>
onoremap an{ :<c-u>execute "normal! /{\r:noh\rva{"<CR>
onoremap al{ :<c-u>execute "normal! /}\rN:noh\rva}"<CR>

"}}}
