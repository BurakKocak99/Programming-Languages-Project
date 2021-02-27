%{
	#include <stdio.h>
	#include <iostream>
	#include <string>
	#include<map>
	#include<vector>
	using namespace std;
	#include "y.tab.h"
	extern FILE *yyin;
	extern int yylex();
	void yyerror(string s);
	extern int linenum;// use variable linenum from the lex file
	string main_str;
	string Var_str;
	string func_name;
	struct Paramaters{
		vector<string> params;
		string func_str;
	};
	vector<string> giv_params;
	map<string , Paramaters> mp; //First string contains the name of the function second string contains the program in the function.
	map<string , Paramaters>::iterator it;
	
	
%}
%token INT_DEC Main_s VOID  EQ IF WHILE SEMICOLON OP CP OCB CCB Coma
%token<str> INTEGER IDENTIFIER COMP  ANDOR Operations 
%type<str> Func_Ident PH
%union
{
int number;
char *str;
}
%%



statement: //Main recursion
	Main_Function 
	|
	Function statement
	;
		
	
	
	
Main_Function:
	VOID Main_s OPA CPA OCBA Func_Statments  CCBA {main_str = "void main" + main_str;}
	;
	
	
	
Function:
	VOID Func_Ident Func_Params OCBA Func_Statments CCBA { mp[func_name].func_str = main_str ;func_name="";main_str = "";} //Storing the name of the function in the map.
	;
Func_Statments://Recursion to obtain all statemnets inside { }.
	STS Func_Statments
	|
	;

Func_Params:
	OP CP {mp[func_name];}
	|
	OP Params CP
	;

	
Params: //Parameters to call a function
	INT_DEC IDENTIFIER {mp[func_name];mp[func_name].params.push_back(string("int "+string($2)));  }
	|
	Params Coma INT_DEC IDENTIFIER {mp[func_name].params.push_back(string("int "+string($4)));}
	;
	
	
	
	
	
STS:	//ALL Posible statements.
	condition_op condition_block OCBA Func_Statments CCBA 
	|
	INT_DEC Variables SEMICOLON { main_str =main_str + "int " +Var_str+ ";\n" ;Var_str = "";}
	|
	IDENTIFIER EQ Calc SEMICOLON {main_str += string($1)+"="+Var_str+";\n";Var_str = "";} 
	|
	IDENTIFIER Func_Call SEMICOLON {it = mp.find(string($1));
								  if(it == mp.end()) {cout<<"error: function "<<$1<<" does not exists \n"; exit(1);}
								  else {  
									  string tmp="";
									  for(int i=0;i<it->second.params.size() && i<giv_params.size();i++){
										  tmp += it->second.params.at(i) + " = " + giv_params.at(i) + ";\n";
									  }
									  tmp += it->second.func_str.substr(2);
									  tmp = "{\n"+tmp;
									  main_str += tmp +"\n";
									  giv_params.clear();	
								  }		

								}//Function call and if function does not exist exit.
	;
	

Func_Ident:	//Function Name
	IDENTIFIER {func_name = string($1);} 
	;		


Func_Call:
	OP CP
	|
	OP GV_PR CP
	;
GV_PR://Given Parameters
	PH {giv_params.push_back(string($1));}
	|
	GV_PR Coma PH {giv_params.push_back(string($3));}
	;	
	
	

condition_block:
	OPA comparison_block CPA
	;


Variables: //Decleration Part
	IDENTIFIER {Var_str += string($1);}
	|
	Variables Coma IDENTIFIER {Var_str += +","+string($3);}



comparison_block:
	comparison_block ANDORA comparison
	|
	comparison
	;
	
Calc://Assignment Part
	PH {Var_str += string($1);}
	|
	Calc Operations PH {Var_str += string($2) + string($3);}
	;

PH:
	IDENTIFIER 
	|
	INTEGER 
	
	;
	
comparison:
	operand compa operand;
;

ANDORA:
	ANDOR {main_str += string($1);}
compa:
	COMP {main_str += string($1);}
	;


condition_op:
		IF {main_str += "if";}
		|
		WHILE {main_str += "while";}
		;
		
operand:
	IDENTIFIER {main_str += string($1);}
	|
	INTEGER {main_str += string($1);}
	;
OPA:
	OP {main_str += "(";}
;
CPA:
	CP {main_str += ")\n";}
;
OCBA:
	OCB {main_str+="{\n"; }
;
CCBA:
	CCB {main_str += "}\n";}
;
	
	
	
%%
void yyerror(string s){
	cerr<<"Error at line: "<<linenum<<endl;
}
int yywrap(){
	return 1;
}
int main(int argc, char *argv[])
{
    yyin=fopen(argv[1],"r");
    yyparse();
    fclose(yyin);
	cout<<main_str<<endl;
    return 0;
}	
	
	
	
	
	