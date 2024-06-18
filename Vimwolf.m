(*  Author: Uladzimir Khasianevich
    License: MIT License*)

BeginPackage@"Vimwolf`";
{SetVersion, Symbols, Functions};
Begin@"`Private`";

removeMissing[{names_, data_}] := Module[
   {missingPositions},
   WriteString["stdout"~OutputStream~1, "   Removing missing entries ..."];
   missingPositions = Position[data, Missing[__]];
   WriteString["stdout"~OutputStream~1, " done.\n"];
   {Delete[names, missingPositions], Delete[data, missingPositions]}
];

getKnownSymbols[knownNames_] := Module[
   {usageStrings, namesWithUsage},
   WriteString["stdout"~OutputStream~1, "Downloading usage information:\n"];
   Block[{WriteString},
      usageStrings = WolframLanguageData[knownNames, "PlaintextUsage"];
   ];
   {namesWithUsage, usageStrings} = removeMissing@{knownNames, usageStrings};
   Extract[namesWithUsage, Position[usageStrings, el_String /; StringFreeQ[el, "["]]]
];

getUndesiredSymbols[knownSymbols_] := Module[
   {shortNotations, undesiredSymbols},
   WriteString["stdout"~OutputStream~1, "Getting undesired symbols:\n"];
   Block[{WriteString},
      shortNotations = WolframLanguageData[knownSymbols, "ShortNotations"];
   ];
   {undesiredSymbols, shortNotations} = removeMissing@{knownSymbols, shortNotations};
   DeleteCases[undesiredSymbols, "Degree" | "E" | "I" | "Infinity" | "Pi"]
];

Module[{names, data, newStr, symStr, funStr, fileList, dir, part, noHL, short},

dir = DirectoryName@FindFile@$Input;
names = DeleteCases[Names@"System`*","Module"|"With"|"Block"];
names = Select[names, StringMatchQ[#, RegularExpression@"[A-Z].*"] &];

WriteString["stdout"~OutputStream~1, "Downloading data ..."];
Block[{WriteString},
   data = WolframLanguageData[names, "FullVersionIntroduced"];
];
WriteString["stdout"~OutputStream~1, " done.\n"];
{names, data} = removeMissing@{names, data};

part[e:_, n:_Integer:1] := Partition[e, UpTo@n];

SetVersion[v:_Real|_Integer, hl:True|False] := Module[
   {knownPos, knownNames, newerNames, knownSymbols, undesiredSymbols, knownFunctions},
   noHL = hl;
   knownPos = Position[data, el_String /; ToExpression@el <= v];
   knownNames = Extract[names, knownPos];
   newerNames = Complement[names, knownNames];

   knownSymbols = getKnownSymbols[knownNames];
   undesiredSymbols = getUndesiredSymbols[knownSymbols];
   knownSymbols = Complement[knownSymbols, undesiredSymbols];
   knownFunctions = Complement[knownNames, knownSymbols];

   newStr = StringJoin[StringJoin[
      "sy keyword wolfSysNew ",
      Riffle[#, " "],
      "\n"
   ] &/@ part@newerNames] <> "\n";

   symStr = StringJoin[StringJoin[
      "sy keyword wolfSysWordOld ",
      Riffle[#, " "],
      "\n"
   ] &/@ part@knownSymbols] <> "\n";

   funStr = StringJoin[StringJoin[
      "sy keyword wolfSysFuncOld ",
      Riffle[#, " "],
      " nextgroup=@wolfCluSysFunc\n"
   ] &/@ part@knownFunctions];

   GetSyntax@FileNameJoin@{dir, "syntax", "wolf.vim"};
   SetSyntax@"~/.vim/syntax/wolf.vim";

];

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
