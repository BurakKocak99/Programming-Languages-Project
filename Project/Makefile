all: lex yacc 
	g++ lex.yy.c y.tab.c -ll -o Project

yacc: Project.y
	yacc -d -v Project.y

lex: Project.l
	lex Project.l

clean: lex.yy.c y.tab.c Project y.tab.h
	rm lex.yy.c y.tab.c Project y.tab.h
