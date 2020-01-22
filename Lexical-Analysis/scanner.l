%{
	#include <stdio.h>
	#include <string.h>
	

	struct symboltable
	{
		char name[100];
		char type[100];
		int length;
	}ST[1001];

	struct constanttable
	{
		char name[100];
		char type[100];
		int length;
	}CT[1001];

	int hash(char *str)
	{
		int value = 0;
		for(int i = 0 ; i < strlen(str) ; i++)
		{
			value = 10*value + (str[i] - 'A');
			value = value % 1001;
			while(value < 0)
				value = value + 1001;
		}
		return value;
	}

	int lookupST(char *str)
	{
		int value = hash(str);
		if(ST[value].length == 0)
		{
			return 0;
		}
		else if(strcmp(ST[value].name,str)==0)
		{
			return 1;
		}
		else
		{
			for(int i = value + 1 ; i!=value ; i = (i+1)%1001)
	    	{
	    		if(strcmp(ST[i].name,str)==0)
	    		{
	    			return 1;
	    		}
	    	}
	    	return 0;
	    }
	}

	int lookupCT(char *str)
	{
		int value = hash(str);
		if(CT[value].length == 0)
			return 0;
		else if(strcmp(CT[value].name,str)==0)
			return 1;
		else
		{
			for(int i = value + 1 ; i!=value ; i = (i+1)%1001)
			{
				if(strcmp(CT[i].name,str)==0)
				{
					return 1;
				}
			}
			return 0;
		}
	}

	void insertST(char *str1, char *str2)
	{
		if(lookupST(str1))
		{
		    return;
	    }
		else
		{
			int value = hash(str1);
			if(ST[value].length == 0)
			{
				strcpy(ST[value].name,str1);
				strcpy(ST[value].type,str2);
				ST[value].length = strlen(str1);
				return;
			}

			int pos = 0;

			for (int i = value + 1 ; i!=value ; i = (i+1)%1001)
			{
				if(ST[i].length == 0)
				{
					pos = i;
					break;
				}
			}

			strcpy(ST[pos].name,str1);
			strcpy(ST[pos].type,str2);
			ST[pos].length = strlen(str1);
		}
	}

	void insertCT(char *str1, char *str2)
	{
		if(lookupCT(str1))
			return;
		else
		{
			int value = hash(str1);
			if(CT[value].length == 0)
			{
				strcpy(CT[value].name,str1);
				strcpy(CT[value].type,str2);
				CT[value].length = strlen(str1);
				return;
			}

			int pos = 0;

			for (int i = value + 1 ; i!=value ; i = (i+1)%1001)
			{
				if(CT[i].length == 0)
				{
					pos = i;
					break;
				}
			}

			strcpy(CT[pos].name,str1);
			strcpy(CT[pos].type,str2);
			CT[pos].length = strlen(str1);
		}
	}

	void printST()
	{
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(ST[i].length == 0)
			{
				continue;
			}
			printf("  %s\t|\t%s\n",ST[i].name, ST[i].type);
		}
	}

	void printCT()
	{
		for(int i = 0 ; i < 1001 ; i++)
		{
			if(CT[i].length == 0)
				continue;

			printf("  %s\t|\t%s\n",CT[i].name, CT[i].type);
		}
	}

%}

DE "define"
IN "include"

operator [[<][=]|[>][=]|[=][=]|[!][=]|[>]|[<]|[\|][\|]|[&][&]|[\!]|[=]|[\^]|[\+][=]|[\-][=]|[\*][=]|[\/][=]|[\%][=]|[\+][\+]|[\-][\-]|[\+]|[\-]|[\*]|[\/]|[\%]|[&]|[\|]|[~]|[<][<]|[>][>]]


%%
\n   {yylineno++;}
([#][" "]*({IN})[ ]*([<]?)([A-Za-z]+)[.]?([A-Za-z]*)([>]?))/["\n"|\/|" "|"\t"] {printf(" %s   |    Pre Processor directive                 \n",yytext);}	//Matches #include<stdio.h>
([#][" "]*({DE})[" "]*([A-Za-z]+)(" ")*[0-9]+)/["\n"|\/|" "|"\t"] {printf("%s   |    Macro                  |\n",yytext);} //Matches macro
\/\/(.*) {printf("\n%s   |    SINGLE LINE COMMENT               \n\n", yytext);}				
\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/  {printf("\n%s   |    MULTI LINE COMMENT                   |\n\n", yytext);}
[ \n\t] ;
; {printf(" %s   |    SEMICOLON DELIMITER             |\n", yytext);}
, {printf(" %s   |   COMMA DELIMITER                  |\n", yytext);}
\{ {printf(" %s   |    OPENING BRACES                  |\n", yytext);}
\} {printf(" %s   |    CLOSING BRACES                  |\n", yytext);}
\( {printf(" %s   |    OPENING BRACKETS                |\n", yytext);}
\) {printf(" %s   |    CLOSING BRACKETS	         |\n", yytext);}
\[ {printf(" %s   |    SQUARE OPENING BRACKETS            |\n", yytext);}
\] {printf(" %s   |    SQUARE CLOSING BRACKETS            |\n", yytext);}
\: {printf(" %s   |    COLON DELIMITER            |\n", yytext);}
\\ {printf(" %s   |    FSLASH					 |\n", yytext);}
\. {printf(" %s   |    DOT DELIMITER			 |\n", yytext);}
auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while|main/[\(|"  "|\{|;|: |"\n"|] {printf(" %s |   KEYWORD                          |\n", yytext); insertST(yytext,"KEYWORD");}
\"[^\n]*\"/[;|,|\)] {printf(" %s   |    STRING CONSTANT |\n", yytext); insertCT(yytext,"STRING CONSTANT");}
\'[A-Z|a-z]\'/[;|,|\)|:] {printf(" %s   |    Character CONSTANT |\n", yytext); insertCT(yytext,"Character CONSTANT");}
[a-z|A-Z]([a-z|A-Z]|[0-9])*/\[ {printf(" %s   |    ARRAY IDENTIFIER |\n", yytext); insertST(yytext, "IDENTIFIER");}

{operator}/[a-z]|[0-9]|;|" "|[A-Z]|\(|\"|\'|\)|\n|\t {printf(" %s   |    OPERATOR                        |\n", yytext);} 

[1-9][0-9]*|0/[;|,|" "|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\]|\}|:|\n|\t|\^] {printf(" %s   |    NUMBER CONSTANT                 |\n", yytext); insertCT(yytext, "   NUMBER CONSTANT");}
([0-9]*)\.([0-9]+)/[;|,|" "|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\n|\t|\^] {printf(" %s   |    Floating CONSTANT |\n", yytext); insertCT(yytext, "   Floating CONSTANT");}
[A-Za-z_][A-Za-z_0-9]*/[" "|;|,|\(|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\n|\.|\{|\^|\t] {printf(" %s  |     IDENTIFIER                      |\n", yytext); insertST(yytext, "   IDENTIFIER");}


(.?) {
		if(yytext[0]=='#')
		{
       		printf("Error in Pre-Processor directive at line no. %d\n",yylineno);
       	}
	    else if(yytext[0]=='/')
	    {
       		printf("ERR_UNMATCHED_COMMENT at line no. %d\n",yylineno);
       	}
       	else if(yytext[0]=='"')
       	{
       		printf("ERR_INCOMPLETE_STRING at line no. %d\n",yylineno);
       	}
       	else
       	{
       		printf("ERROR at line no. %d\n",yylineno);
       	}
       	printf("%s\n", yytext);
       	return 0;
}

%%

int main(int argc , char **argv){

    printf("              ====================================================================\n");
    printf("                             Lexical Analyzer for the C Language\n");
    printf("              ====================================================================\n\n");

	int i;
	for (i=0;i<1001;i++){
		ST[i].length=0;
		CT[i].length=0;
	}

	yyin = fopen(argv[1],"r");
	yylex();
	
	printf("\n\n\n  ============================\n");
	printf("         SYMBOL TABLE\n");
	printf("  ============================\n\n");
	printST();

	printf("\n\n\n  ===============================\n");
	printf("         CONSTANT TABLE\n");
	printf("  ===============================\n");
	printCT();
	printf("\n");
}

int yywrap(){
    return 1;
}