"----------------------------------------------------------------------
"- Global Settings
"----------------------------------------------------------------------
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let &tags .= ',.tags,' . expand('~/.vim/tags/standard.tags')

filetype plugin indent on

command! -nargs=1 OptScript exec 'so '.s:home.'/'.'<args>'


"----------------------------------------------------------------------
"- Quickfix Chinese Convertion
"----------------------------------------------------------------------
function! QuickfixChineseConvert()
   let qflist = getqflist()
   for i in qflist
	  let i.text = iconv(i.text, "gbk", "utf-8")
   endfor
   call setqflist(qflist)
endfunction


"----------------------------------------------------------------------
"- GUI Setting
"----------------------------------------------------------------------
if has('gui_running') 
	set guioptions-=L
	set mouse=a
	set showtabline=2
	set laststatus=2
	set number
	if has('win32') || has('win64') || has('win16') || has('win95')
		language messages en
		set langmenu=en_US
		set guifont=inconsolata:h11
		au QuickfixCmdPost make call QuickfixChineseConvert()
		let g:config_vim_gui_label = 3
		color desert256
	elseif has('gui_macvim')

	endif
	highlight Pmenu guibg=darkgrey guifg=black
endif

highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE 
	\ gui=NONE guifg=DarkGrey guibg=NONE


"----------------------------------------------------------------------
"- Return last position
"----------------------------------------------------------------------
autocmd BufReadPost *
	\ if line("'\"") > 1 && line("'\"") <= line("$") |
	\	 exe "normal! g`\"" |
	\ endif


"----------------------------------------------------------------------
"- Vimmake
"----------------------------------------------------------------------
let g:vimmake_cwd = 1

if has('win32') || has('win64') || has('win16') || has('win95')
	let g:vimmake_cflags = ['-lwinmm', '-lstdc++', '-lgdi32', '-lws2_32', '-msse3']
else
	let g:vimmake_cflags = ['-lstdc++']
endif

if v:version >= 800 || has('patch-7.4.1831')
	if has('job') && has('channel') && has('timers') && has('reltime') 
		let g:vimmake_build_mode = 2
	endif
endif


"----------------------------------------------------------------------
"- Misc
"----------------------------------------------------------------------
let g:calendar_navi = 'top'


"----------------------------------------------------------------------
"- OptScript
"----------------------------------------------------------------------
OptScript opt/echofunc.vim
OptScript opt/calendar.vim


"----------------------------------------------------------------------
"- YCM config
"----------------------------------------------------------------------
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_server_log_level = 'info'
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings=1


"----------------------------------------------------------------------
"- OmniCpp
"----------------------------------------------------------------------
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1 
let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_MayCompleteDot = 1  
let OmniCpp_MayCompleteArrow = 1 
let OmniCpp_MayCompleteScope = 1
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]


"----------------------------------------------------------------------
"- VimPress
"----------------------------------------------------------------------
noremap <space>bp :BlogPreview local<cr>
noremap <space>bb :BlogPreview publish<cr>
noremap <space>bs :BlogSave<cr>
noremap <space>bd :BlogSave draft<cr>
noremap <space>bn :BlogNew post<cr>
noremap <space>bl :BlogList<cr>


"----------------------------------------------------------------------
"- netrw / winmanager
"----------------------------------------------------------------------
let s:enter = 0
let g:netrw_winsize = 25
let g:netrw_list_hide= '.*\.swp$,.*\.pyc,*\.o,*\.bak,\.git,\.svn'

let g:bufExplorerWidth=26
let g:winManagerWindowLayout = "FileExplorer|TagList"
"let g:winManagerWindowLayout = "FileExplorer|Tagbar"
let g:winManagerWidth=26

"let g:bufferhint_KeepWindow = 1
set completeopt=menu

let g:Tagbar_title = "[Tagbar]"
let g:tagbar_vertical = 28
" let g:tagbar_left = 1
function! Tagbar_Start()
    exe 'TagbarOpen'
    exe 'q' 
endfunction
 
function! Tagbar_IsValid()
    return 1
endfunction

function! WMResize()
	FirstExplorerWindow
	vertical resize 28
	set winfixwidth
	wincmd l
endfunc

function! WMFocusEdit(n)
	FirstExplorerWindow
	wincmd l
	if a:n > 0
		wincmd l
	endif
endfunc

function! WMFocusQuickfix()
	exec "FirstExplorerWindow"
	exec "wincmd l"
	exec "wincmd j"
endfunc

function! s:TbInit()
	if !filereadable(expand('~/.vim/tabbar2.vim'))
		return 0
	endif
	source ~/.vim/tabbar2.vim
	exec 'TbStart'
	exec 'wincmd j'
	return 1
endfunc


"----------------------------------------------------------------------
"- ToggleDevelop
"----------------------------------------------------------------------
function! ToggleDevelop(layout)
	if s:enter == 0
		"set showtabline=2
		set equalalways
		let s:enter = 1
	endif
	set equalalways
	if a:layout == 0
		set nonumber
		exec 'copen 6'
		wincmd j
		set winfixheight
		wincmd k
		exec 'wincmd l'
		exec 'WMToggle'
		exec 'wincmd l'
		let s:screenw = &columns
		let s:screenh = &lines
		let s:size = (s:screenw - 28) / 2
		exec 'set number'
		call WMResize()
		if s:size >= 65
			exec 'vs'
			exec 'wincmd h'
			exec 'wincmd h'
			exec 'vertical resize 28'
			set winfixwidth
			exec 'wincmd l'
			exec 'vertical resize ' . s:size
		endif
		"let s:enter = 1
	elseif a:layout == 1 || a:layout == 2
		set nonumber
		exec 'copen 6'
		wincmd j
		set winfixheight
		wincmd k
		exec 'wincmd l'
		exec 'WMToggle'
		exec 'wincmd l'
		exec 'TagbarOpen'
		call WMResize()
		exec 'wincmd l'
		exec 'wincmd l'
		exec 'vertical resize 28'
		set winfixwidth
		exec 'wincmd h'
		set number
		let s:size = (&columns - 58)
		exec 'vertical resize ' . s:size
		if a:layout == 2
			if s:TbInit()
				set showtabline=1
			endif
		endif
	elseif a:layout == 3 || a:layout == 4
		set nonumber
		copen 6
		wincmd j
		set winfixheight
		wincmd k
		TagbarOpen
		wincmd l
		vertical resize 28
		wincmd h
		set number
		if a:layout == 4
			vs
			wincmd h
			set winfixwidth
		endif
	endif
	highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
endfunc


noremap <leader>f1 :FirstExplorerWindow<cr>
noremap <leader>f2 :BottomExplorerWindow<cr>
noremap <leader>f3 :call WMFocusEdit(0)<cr>
noremap <leader>f4 :call WMFocusEdit(1)<cr>
noremap <leader>f0 :call WMFocusQuickfix()<cr>
noremap <leader>fm :call ToggleDevelop(0)<cr>
noremap <leader>fn :call ToggleDevelop(1)<cr>
noremap <leader>fs :call ToggleDevelop(3)<cr>
noremap <leader>fd :call ToggleDevelop(4)<cr>
noremap <leader>fb :call ToggleDevelop(2)<cr>
noremap <leader>fa :TagbarOpen<cr>
noremap <leader>fc :Calendar<cr>
noremap <leader>ft :NERDTree<cr>:vertical resize +3<cr>


"----------------------------------------------------------------------
"- Author info
"----------------------------------------------------------------------
let g:skywind_name = 'skywind3000 (at) google.com'
function! CopyrightSource()
	let l:filename = expand("%:t")
	let l:comment = '//'
	while strlen(l:comment) < 72
		let l:comment .= '='
	endwhile
	call append(line(".") - 1, l:comment)
	call append(line(".") - 1, '//')
	call append(line(".") - 1, '// '. l:filename . ' - '.g:skywind_name)
	call append(line(".") - 1, '// ')
	call append(line(".") - 1, '// NOTE:')
	call append(line(".") - 1, '// This file is created by skywind in '. strftime("%c"))
	call append(line(".") - 1, '// For more information, please see the readme file.')
	call append(line(".") - 1, '//')
	call append(line(".") - 1, l:comment)
endfunc


nnoremap - :call bufferhint#Popup()<CR>
nnoremap <leader>p :call bufferhint#LoadPrevious()<CR>


