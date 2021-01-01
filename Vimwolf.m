(*
    Copyright (C) 2020 Uladzimir Khasianevich

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*)

BeginPackage@"Vimwolf`";
{SetVersion, Symbols, Functions};
Begin@"`Private`";

Module[{names, data, pos, all, usage, sym, fun, newStr, symStr, funStr,
   fileList, new, dir, part, noHL, short
},

dir = DirectoryName@FindFile@$Input;
names = DeleteCases[Names@"System`*","Module"|"With"|"Block"];
names = Select[names, StringMatchQ[#, RegularExpression@"[A-Z].*"] &];

WriteString["stdout"~OutputStream~1, "Downloading data ..."];
data = WolframLanguageData[names, "FullVersionIntroduced"];
WriteString["stdout"~OutputStream~1, " done.\n"];

part[e:_, n:_Integer:5] := Partition[e, UpTo@n];

SetVersion[v:_Real|_Integer, hl:True|False] := (
   noHL = hl;
   pos = Position[data, el_String /; ToExpression@el <= v];
   all = Extract[names, pos];
   new = Complement[names, all];
   WriteString["stdout"~OutputStream~1, "Downloading usage information ..."];
   usage = WolframLanguageData[all, "PlaintextUsage"];
   sym = Extract[all, Position[usage, el_String /; StringFreeQ[el, "["]]];
   WriteString["stdout"~OutputStream~1, " done.\n"];
   short = WolframLanguageData[sym, "ShortNotations"];
   short = DeleteCases[Extract[sym, Position[short, el:{__String}]],
      "Degree"|"E"|"I"|"Infinity"|"Pi"
   ];
   sym = Complement[sym, short];
   fun = Complement[all, sym];

   newStr = StringJoin[StringJoin[
      "sy keyword wolfSysNew ",
      Riffle[#, " "],
      "\n"
   ] &/@ part@new] <> "\n";
   symStr = StringJoin[StringJoin[
      "sy keyword wolfSysWordOld ",
      Riffle[#, " "],
      "\n"
   ] &/@ part@sym] <> "\n";
   funStr = StringJoin[StringJoin[
      "sy keyword wolfSysFuncOld ",
      Riffle[#, " "],
      " nextgroup=wolfSysBrackets,wolfSysCandy_,wolfMessage\n"
   ] &/@ part@fun];

   GetSyntax@FileNameJoin@{dir, "syntax", "wolf.vim"};
   SetSyntax@"~/.vim/syntax/wolf.vim";

);

GetSyntax[file_] := Module[{keep = True},
   fileList = {};
   While[(line = ReadLine[file]) =!= EndOfFile,
      If[noHL,
         If[MatchQ[line, "\" Coloring start"], keep = False;];
         If[MatchQ[line, "\" Coloring end"], keep = True; line="";];
      ];
      If[MatchQ[line, "\" System start"],
         keep = False;
         AppendTo[fileList, line <> "\n" <> newStr <> symStr <> funStr]
      ];
      If[MatchQ[line, "\" System end"],
         keep = True;
      ];
      If[keep, AppendTo[fileList, line]]
   ];
   Close@file;
];

SetSyntax[file_] := Module[{obj},
   If[FileExistsQ@file, DeleteFile@file];
   obj = OpenWrite@file;
   WriteLine[obj, StringJoin@Riffle[fileList, "\n"]];
   Close@obj;
   Quit[0];
];

];

End[];
EndPackage[];
$ContextPath = DeleteCases[$ContextPath, "Vimwolf`"];
