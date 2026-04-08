if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

set autoread

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

set number
set relativenumber
set wildmode=longest,list,full
set ignorecase
autocmd BufWritePre * %s/\s\+$//e
" autocmd BufWritePost ~/.bash* !source
map <F6> :setlocal spell! spelllang=en_us<CR>

" NerdTREE
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeShowHidden=1

" NERDTree Git indicators - disable unicode
let g:NERDTreeGitStatusUseNerdFonts = 0
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ 'Modified'  :'M',
    \ 'Staged'    :'S',
    \ 'Untracked' :'+',
    \ 'Renamed'   :'R',
    \ 'Unmerged'  :'U',
    \ 'Deleted'   :'D',
    \ 'Dirty'     :'*',
    \ 'Ignored'   :'I',
    \ 'Clean'     :'C',
    \ 'Unknown'   :'?',
    \ }


let mapleader = ','

" ============================================================================
" GitGutter Settings
" ============================================================================
let g:gitgutter_signs = 1
let g:gitgutter_highlight_lines = 1
set updatetime=100
set signcolumn=yes

" Custom colors for git changes
highlight GitGutterAdd    guifg=#00ff00 ctermfg=2
highlight GitGutterChange guifg=#0000ff ctermfg=4
highlight GitGutterDelete guifg=#ff0000 ctermfg=1

" Highlight entire lines
highlight GitGutterAddLine    ctermbg=22 guibg=#003300
highlight GitGutterChangeLine ctermbg=17 guibg=#000033
highlight GitGutterDeleteLine ctermbg=52 guibg=#330000

" Use custom symbols for better visibility
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '≃'

" ============================================================================
" Floaterm (Terminal) Settings
" ============================================================================
let g:floaterm_width = 1.0
let g:floaterm_height = 0.4
let g:floaterm_position = 'bottom'

" Toggle terminal with F12 or Ctrl+T
nnoremap <F12> :FloatermToggle<CR>
tnoremap <F12> <C-\><C-n>:FloatermToggle<CR>
nnoremap <C-t> :FloatermToggle<CR>
tnoremap <C-t> <C-\><C-n>:FloatermToggle<CR>

" Create new terminal
nnoremap <leader>tn :FloatermNew<CR>
tnoremap <Esc> <C-\><C-n>

" ============================================================================
" Plugin Management with vim-plug
" ============================================================================
call plug#begin('~/.vim/plugged')

" GitHub Copilot - AI pair programming
Plug 'github/copilot.vim'

" Vimspector - Debugger
Plug 'puremourning/vimspector'

Plug 'luizribeiro/vim-cooklang', { 'for': 'cook' }

call plug#end()

" Load plugins from system installation
" NERDTree, GitGutter, Floaterm, Fugitive, Airline, EasyMotion, and NERDTree-git
" are already loaded from /usr/share/vim/vimfiles/plugin/
packadd! coc.nvim

" ============================================================================
" Copilot Settings
" ============================================================================
" Accept suggestion with Tab
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

" ============================================================================
" Vimspector Settings
" ============================================================================
let g:vimspector_enable_mappings = 'HUMAN'
nmap <leader>dd :call vimspector#Launch()<CR>
nmap <leader>dx :VimspectorReset<CR>
nmap <leader>de :VimspectorEval
nmap <leader>dw :VimspectorWatch
nmap <leader>do :VimspectorShowOutput
nmap <F9> :call vimspector#ToggleBreakpoint()<CR>
nmap <F5> :call vimspector#Continue()<CR>
nmap <F10> :call vimspector#StepOver()<CR>
nmap <F11> :call vimspector#StepInto()<CR>
nmap <F12> :call vimspector#StepOut()<CR>

" ============================================================================
" Python pdb Integration (Alternative simple debugger)
" ============================================================================
" Insert breakpoint: import pdb; pdb.set_trace()
autocmd FileType python nnoremap <leader>b Oimport pdb; pdb.set_trace()<Esc>
autocmd FileType python nnoremap <leader>B :g/import pdb; pdb.set_trace()/d<CR>

" ============================================================================
" CoC (Conquer of Completion) - IntelliSense Settings
" ============================================================================
" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>

" Navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
