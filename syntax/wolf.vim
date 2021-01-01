" Vim syntax file
" Language: Mathematica
" Copyright (C) 2020 Uladzimir Khasianevich
"
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.
if exists("b:current_syntax")
  finish
endif
" Coloring start
hi String ctermfg=Magenta

hi Identifier cterm=italic ctermfg=DarkGreen
hi Function ctermfg=Blue

hi Keyword cterm=bold

hi Structure cterm=bold ctermfg=DarkGreen
hi Typedef cterm=italic ctermfg=Gray

hi Special ctermfg=DarkCyan
hi Tag cterm=underline ctermfg=Magenta
hi Debug ctermfg=214

hi Error ctermfg=242
" Coloring end
" System start
" System end
hi def link wolfSysWordOld Keyword
hi def link wolfSysFuncOld Keyword
hi def link wolfSysNew Debug
sy region wolfSysBrackets
        \ matchgroup=wolfSysBrackets_
        \ start='\[\([^\[]\|$\)'rs=s+1,me=s
        \ end='\]'re=e-1
        \ contained
        \ contains=TOP
        \ nextgroup=wolfSysBrackets
sy match wolfSysCandy_
       \ '\s*\(@\{1,3\}\|/@\)'
       \ contained
hi def link wolfSysBrackets_ Keyword
hi def link wolfSysCandy_ Keyword
" Errors
sy match wolfSlotSequenceError '#\{1,2\}0'
hi def link wolfSlotSequenceError Error
" Pattern
sy match wolfBlank
       \ '_\{1,3\}'
       \ nextgroup=wolfPatternContextPrepend,
                 \ wolfPatternContext,
                 \ wolfPatternVar
hi def link wolfBlank Operator
" Pattern variable
sy match wolfPatternVar
       \ '[A-Za-z0-9]\+'
       \ contained
hi def link wolfPatternVar Operator
sy match wolfPatternContext
       \ '[A-Za-z0-9]\+`'
       \ nextgroup=wolfPatternContext,
                 \ wolfPatternVar
hi def link wolfPatternContext Typedef
sy match wolfPatternContextPrepend
       \ '`[A-Za-z0-9]\+`'
       \ nextgroup=wolfPatternContext,
                 \ wolfPatternVar
hi def link wolfPatternContextPrepend Typedef
" Simple brackets
sy region wolfSimpleParentheses
        \ start='('rs=s+1
        \ end=')'re=e-1
        \ contains=TOP
sy region wolfSimpleBrackets
        \ start='\['rs=s+1
        \ end='\]'re=e-1
        \ contains=TOP
sy region wolfSimpleBraces
        \ start='{'rs=s+1
        \ end='}'re=e-1
        \ contains=TOP
" Pure function arguments
sy match wolfSlotSequence '#\{1,2\}'
sy match wolfSlotSequence '#\{1,2\}[1-9][0-9]*'
sy match wolfPureEnd '&'
hi def link wolfSlotSequence Special
hi def link wolfPureEnd Special
" Operators
sy match wolfOperator '+\|-\|\*\*\|\*\|/\|^\|=\|:=\|/:'
sy match wolfOperator '/;\|;;\|=\.\|->\|:>\|/\.\|//\.\|{\|}'
sy match wolfOperator '@@@\|@@\|@\|/@\|//\|\~\|\.\.\.\|\.\.\|,'
sy match wolfOperator '\~\~\|?\|<>\||\|:'
sy match wolfOperator '<\|<=\|>\|>=\|!=\|==\|&&\|||\|===\|=!=\|!'
sy match wolfOperator '+=\|-=\|*=\|/=\|--\|++'
hi def link wolfOperator Operator
sy region wolfPart
        \ matchgroup=wolfPart_
        \ start='\[\['rs=s+2
        \ end='\]\]'re=e-2
        \ contains=TOP
hi def link wolfPart_ Operator
" String todo check
sy region wolfString
        \ start='"'
        \ skip='\(\\\)\@<!\\"'
        \ end='"'
        \ contains=wolfTag
hi def link wolfString String
" Tag
sy match wolfTag
       \ '@\w\+@\?'
       \ contained
hi def link wolfTag Tag
" Local variable
sy match wolfLocalVar
       \ '[A-Za-z0-9]\+'
hi def link wolfLocalVar Identifier
sy match wolfContext
       \ '[A-Za-z0-9]\+`'
       \ nextgroup=wolfContext,
                 \ wolfLocalVar,
                 \ wolfFunction
hi def link wolfContext Typedef
sy match wolfContextPrepend
       \ '`[A-Za-z0-9]\+`'
       \ nextgroup=wolfContext,
                 \ wolfLocalVar,
                 \ wolfFunction,
hi def link wolfContextPrepend Typedef
" Greek
sy region wolfGreek
        \ start='\\\['
        \ end='\]'
hi def link wolfGreek Character
" Messages
sy match wolfMessage_
       \ '[A-Za-z0-9]\+'
       \ contained
hi def link wolfMessage_ String
sy match wolfMessage
       \ '::[A-Za-z0-9]\+'hs=s+2
hi def link wolfMessage String
" Function
sy match wolfFunction
       \ '[A-Za-z0-9]\+\s*/@'
sy match wolfFunction
       \ '[A-Za-z0-9]\+::'
       \ nextgroup=wolfMessage_
sy match wolfFunction
       \ '[A-Za-z0-9]\+\s*@'me=e-1,he=e-1
       \ nextgroup=wolfFunctionCandy_
sy match wolfFunctionCandy_
       \ '@\{1,3\}'
       \ contained
sy match wolfFunction
       \ '[A-Za-z0-9]\+\s*\['me=e-1,he=e-1
       \ nextgroup=wolfFunctionBody_
sy region wolfFunctionBody_
        \ matchgroup=wolfFunctionBrackets_
        \ start='\[\([^\[]\|$\)'rs=s+1,me=s
        \ end='\]'re=e-1
        \ contained
        \ contains=TOP
        \ nextgroup=wolfFunctionBody_
hi def link wolfFunction Function
hi def link wolfFunctionCandy_ Function
hi def link wolfFunctionBrackets_ Function
" Module
sy match wolfModule
       \ '\(Module\|With\|Block\)\['me=e-1
       \ nextgroup=wolfModuleBody
sy region wolfModuleBody
        \ matchgroup=wolfStructBrackets
        \ start='\[\([^\[]\|$\)'rs=s+1,me=s
        \ end='\]'re=e-1
        \ contained
        \ contains=TOP
        \ nextgroup=wolfFunctionBody_,
                  \ wolfPart
hi def link wolfModule Structure
hi def link wolfStructBrackets Structure
" Float and integer number
sy match wolfNumber '\d\+\.\?\d*'
hi def link wolfNumber Number
" Global variable
sy match wolfGlobalVar
       \ '^?\$[A-Za-z0-9]\+'
hi def link wolfGlobalVar Keyword
" Comments
sy region wolfComment start='(\*'
                    \ skip='@'
                    \ end='\*)'
hi def link wolfComment Comment
let b:current_syntax = "wolf"
