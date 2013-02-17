"指定英文逗号作为<leader>键
let mapleader=","

"avoiding annoying CSApprox warning message
let g:CSApprox_verbose_level = 0

" 定义交换文件(*.swp)的存放路径
let $CACHEDIR = $HOME . "/.vcache"
if !isdirectory($CACHEDIR) && exists("*mkdir")
    call mkdir($CACHEDIR)
endif

"necessary on some Linux distros for pathogen to properly load bundles
filetype on
filetype off

"load pathogen managed plugins
call pathogen#infect()

"Use Vim settings, rather then Vi settings (much better!).
"This must be first, because it changes other options as a side effect.
set nocompatible

" 文件编码设置
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fileencoding=utf-8 " 新建文件使用的编码

"allow backspacing over everything in insert mode
set backspace=indent,eol,start

set autochdir  " 自动切换当前目录为当前文件所在的目录

"store lots of :cmdline history
set history=1000

set showcmd     "show incomplete cmds down the bottom
set showmode    "show current mode down the bottom

set incsearch   "find the next match as we type the search
set hlsearch    "hilight searches by default

set number      "add line numbers
set showbreak=...
set wrap linebreak nolist

"add some line space for easy reading
set linespace=4

"statusline setup
set statusline=%f       "tail of the filename

set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2

set dir=$CACHEDIR// " 设置交换文件(*.swp)路径

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction


"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")
        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)

    let long_line_lens = []

    let i = 1
    while i <= line("$")
        let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
        if len > threshold
            call add(long_line_lens, len)
        endif
        let i += 1
    endwhile

    return long_line_lens
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction

setlocal noswapfile " don't generation swap file

"indent settings
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

set wildmode=list:longest   "make cmdline tab completion similar to bash
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing

set whichwrap+=<,>,[,]

"display tabs and trailing spaces
"set listchars=tab:\ \ ,extends:>,precedes:<
set listchars=eol:¶,tab:>-,trail:·,extends:»,precedes:« " 182, , 187, 171
" disabling list because it interferes with soft wrap

set formatoptions-=o "dont continue comments when pushing o/O

"vertical/horizontal scroll off settings
set scrolloff=3
set sidescrolloff=7
set sidescroll=1

"load ftplugins and indent files
filetype plugin on
filetype indent on

"turn on syntax highlighting
syntax on

"some stuff to get the mouse going in term
set mouse=a
set ttymouse=xterm2

"hide buffers when not displayed
set hidden

"Activate smartcase
set ic
set smartcase
set iskeyword+=_,$,@,%,#,-

set cursorline
if has("gui_running")
    "tell the term has 256 colors
    set t_Co=256
    set lines=30                " Vim window size
    set columns=100

    set guioptions-=T           " hide tool bar
    set guioptions-=m           " hide menu bar

    "turn off the scroll bar
    set guioptions-=L
    set guioptions-=r

    colorscheme molokai
    set guitablabel=%M%t
    set lines=40
    set columns=115

    if has("gui_gnome")
        set term=gnome-256color
        set guifont=Monospace\ Bold\ 12
    endif

    if has("gui_mac") || has("gui_macvim")
        set guifont=Menlo:h12
        set transparency=7
    endif

    if has("gui_win32") || has("gui_win32s")
        "set guifont=Consolas:h12
        set guifont=Courier_New:h14:cANSI
        set enc=utf-8

        "实现windows下的快捷键方式
        source $VIMRUNTIME/vimrc_example.vim
        source $VIMRUNTIME/mswin.vim
        behave mswin

        au GUIENTER * simalt ~x "窗口自动最大化(仅windows下有效)

    endif

    " 解决菜单乱码
    set langmenu=zh_CN
    let $LANG = 'zh_CN.UTF-8'
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    " Toggle Menu and Toolbar
    set guioptions-=m
    set guioptions-=T
    map <silent> <F2> :if &guioptions =~# 'T' <Bar>
            \set guioptions-=T <Bar>
            \set guioptions-=m <bar>
        \else <Bar>
            \set guioptions+=T <Bar>
            \set guioptions+=m <Bar>
        \endif<CR>

else
    "dont load csapprox if there is no gui support - silences an annoying warning
    let g:CSApprox_loaded = 1

    "set railscasts colorscheme when running vim in gnome terminal
    if $COLORTERM == 'gnome-terminal'
        colorscheme molokai
        "set background=dark
        "colorscheme solarized
    else
        if $TERM == 'xterm'
            set term=xterm-256color
            colorscheme molokai
        else
            colorscheme default
        endif
    endif
    hi CursorLine cterm=NONE ctermbg=0
endif
set nobackup "cancel backup file

silent! nmap <silent> wm :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.swp$']

"make double <ESC> clear the highlight as well as redraw
nmap <ESC><ESC> :nohl<CR>
imap <ESC><ESC> <ESC>:nohl<CR>

"map to bufexplorer
nnoremap <leader>b :BufExplorer<cr>

"key mapping for vimgrep result navigation
map <A-o> :copen<CR>
map <A-q> :cclose<CR>
map <A-j> :cnext<CR>
map <A-k> :cprevious<CR>

"visual search mappings
function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    end
endfunction

"define :HighlightLongLines command to highlight the offending parts of
"lines that are longer than the specified length (defaulting to 80)
command! -nargs=? HighlightLongLines call s:HighlightLongLines('<args>')
function! s:HighlightLongLines(width)
    let targetWidth = a:width != '' ? a:width : 79
    if targetWidth > 0
        exec 'match Todo /\%>' . (targetWidth) . 'v/'
    else
        echomsg "Usage: HighlightLongLines [natural number]"
    endif
endfunction

" Strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

"key mapping for tab navigation
nmap <S-Tab> gt
nmap <C-S-Tab> gT

" when press { + Enter, the {} block will expand.
imap {<CR> {}<ESC>i<CR><ESC>O

" ------------------------taglist设置Begin---------------------------
nmap <F9> <Esc>:!ctags -R *<CR>
map <F8> :silent! Tlist<CR> "按下F8就可以呼出了
let Tlist_Ctags_Cmd='ctags' "因为我们放在环境变量里，所以可以直接执行
let Tlist_Use_Right_Window=1 "让窗口显示在右边，0的话就是显示在左边
let Tlist_Show_One_File=0 "让taglist可以同时展示多个文件的函数列表
let Tlist_File_Fold_Auto_Close=1 "非当前文件，函数列表折叠隐藏
let Tlist_Exit_OnlyWindow=1 "当taglist是最后一个分割窗口时，自动推出vim
"是否一直处理tags.1:处理;0:不处理
let Tlist_Process_File_Always=0 "不是一直实时更新tags，因为没有必要
let Tlist_Inc_Winwidth=0
set tags=tags;
" ------------------------taglist设置End---------------------------

" ------------------------doxygenToolkit设置Begin---------------------------
let g:DoxygenToolkit_authorName="joe, joenali@163.com"
let s:licenseTag = "Copyright(C)\<enter>"
let s:licenseTag = s:licenseTag . "For free\<enter>"
let s:licenseTag = s:licenseTag . "All right reserved\<enter>"
let g:DoxygenToolkit_licenseTag = s:licenseTag
let g:DoxygenToolkit_briefTag_funcName="yes"
let g:doxygen_enhanced_color=1
" ------------------------doxygenToolkit设置End---------------------------

" ------------------------lookupfile设置Begin---------------------------
let g:LookupFile_MinPatLength = 2 "最少输入2个字符才开始查找
let g:LookupFile_PreserveLastPattern = 0 "不保存上次查找的字符串
let g:LookupFile_PreservePatternHistory = 1 "保存查找历史
let g:LookupFile_AlwaysAcceptFirst = 1 "回车打开第一个匹配项目
let g:LookupFile_AllowNewFiles = 0 "不允许创建不存在的文件
let g:LookupFile_UsingSpecializedTags = 1
let g:LookupFile_Bufs_LikeBufCmd = 0
let g:LookupFile_ignorecase = 1
let g:LookupFile_smartcase = 1

" lookup file with ignore case
function! LookupFile_IgnoreCaseFunc(pattern)
    let _tags = &tags
    try
        let &tags = eval(g:LookupFile_TagExpr)
        let newpattern = '\c' . a:pattern
        let tags = taglist(newpattern)
    catch
        echohl ErrorMsg | echo "Exception: " . v:exception | echohl NONE
        return ""
    finally
        let &tags = _tags
    endtry
    " Show the matches for what is typed so far.
    let files = map(tags, 'v:val["filename"]')
    return files
endfunction
let g:LookupFile_LookupFunc = 'LookupFile_IgnoreCaseFunc'

" 在指定目录生成filenametags，并使lookupfile将这个文件作为查找源
function! SetRootOfTheProject(path)
    " 进入指定目录
    exe 'cd '.a:path
    " 生成文件标签
    exe '!tags'
    " 获取标签文件的路径
    let tagFilePath = genutils#CleanupFileName(a:path.'/filenametags')
    " 设置LookupFile插件的全局变量，使之以上面生成的标签文件作为查找源
    exe "let g:LookupFile_TagExpr='\"".tagFilePath."\"'"
endfunction
" 设置当前位置为工程的根目录
function! SetHereTheRoot()
    call SetRootOfTheProject('c:\wamp\www')
endfunction
nmap <leader>root :call SetHereTheRoot()<CR>
" 从用户的输入获取指定路径，并设置为工程的根目录
function! SetSpecifiedPathTheRoot()
    call SetRootOfTheProject(input('Enter a Path：'))
endfunction
nmap <leader>xroot :call SetSpecifiedPathTheRoot()<CR>

" 使用LookupFile打开文件
nmap <leader>o :LookupFile<CR>
let g:LookupFile_TagExpr = '"./filenametags"'
" ------------------------lookupfile设置end---------------------------

if has("gui_win32")
    " open cmd/explorer
    command! Cmd :!start cmd
    command! -nargs=? OpenDir call Win32_openDir(<f-args>)
    function! Win32_openDir(...)
        if exists("a:1")
            let s:cmd = ":!start explorer " . a:1
            execute s:cmd
        else
            let s:cmd = ":!start explorer " . getcwd()
            execute s:cmd
        endif
    endfunction
    nmap <leader>dir :OpenDir<CR>
    nmap <leader>cmd :Cmd<CR>
endif

"fuzzyfinder
map <leader>F :FufFile<CR>
map <leader>f :FufTaggedFile<CR>
map <leader>g :FufTag<CR>
map <leader>b :FufBuffer<CR>

" 在命令模式或者插入模式下，使用Ctrl+t能够新建标签
map <C-T> :tabnew<CR>
imap <C-T> <ESC>:tabnew<CR>i

map <C-K> :tabnew %<CR>
imap <C-K> <ESC>:tabnew %<CR>i

nmap <silent> on :only<CR> "取消分屏
map <C-H> ,c<space>
:abbr epe echo '<pre>';print_r();exit;<ESC>F(
