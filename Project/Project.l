digit	[0-9]
letter	[A-Za-z]
%{
  #include <stdio.h>
  #include <string.h>
  #include "y.tab.h"
  #include <iostream>
  using namespace std;
  int linenum=1;

%}
%%

"int" return INT_DEC;
"void" return VOID;
"main" return Main_s;
"/"|"*"|"+"|"-" {yylval.str = strdup(yytext);return Operations;}
"if"	return IF;
"while"	return WHILE;
";"	return SEMICOLON;
"(" return OP;
")" return CP;
"{" return OCB;
"}" return CCB;
"=" return EQ;
"," return Coma;
"||"|"&&" {yylval.str = strdup(yytext);return ANDOR;}
"<"|">"|"<="|">="|"=="|"!=" {yylval.str = strdup(yytext);return COMP;}
{letter}({letter}|{digit})*	{yylval.str = strdup(yytext);return IDENTIFIER;}
[0-9]+	{yylval.str = strdup(yytext);return INTEGER;}
"\n"	{linenum++;}
[ \t]+
[ \t\r\n] ;
%%
