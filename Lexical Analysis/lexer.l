%{
int lineno = 1;
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

// keywords
#define CHAR 1
#define DOUBLE 2
#define ELSE 3
#define FLOAT 4
#define FOR 5
#define IF 6
#define INT 7
#define RETURN 8
#define SIZEOF 9
#define VOID 10
#define WHILE 11

#define IDENTIFIER 12 // identifier
#define SLC 13 // single line comments
#define MLCS 14 // multi line comments start
#define MLCE 15 // multi line comments end
#define LEQ 16 // less than or equal
#define GEQ 17 // greater than or equal
#define LESSER 18 // less than operator
#define GREATER 19 // greater than operator
#define OR 20 // OR
#define AND 21 // AND
#define EQ 22 // Equal
#define PLUS 23 // Add operator
#define SUB 24 // Subtraction operator
#define MULT 25 // multiplication operator
#define DIV 26 // divison operator
#define MOD 27 // modulus operator
#define EQEQ 28 // equal to equal to
#define NEQ 29 // not equal to
#define INCR 30 // increment operator
#define DECR 31 // decrement operator

#define COMMA 32 // comma
#define SEMI 33 // semicolon

#define HEADER 34 // header
#define MAIN 35 // main function

#define PRINTF 36 // printf function
#define SCANF 39 // scanf function
#define DEFINE 40 // define keyword
 
#define INT_CONST 41 // int constant
#define FLOAT_CONST 42 // float constant

#define TYPE_SPEC 43 // type specifier
 
#define DQ 44 // double quotes

#define PO 45 // parentheses open
#define PC 46 // parentheses close
#define CBO 47 // curly braces open
#define CBC 48 // curly braces close
#define HASH 49 // #

#define ARR 50 // array
#define FUNC 51 // function

#define NUM_ERR 52 // number error
#define UNKNOWN 53 // unknown error
#define CHAR_CONST 54 // char constant
%}

alpha [A-Za-z]
digit [0-9]
und [_]
space [ ]
tab [	]
line [\n]
char \'.\'
at [@]
string \"(.^([%d]|[%f]|[%s]|[%c]))\"

%%
{space}* {}
{tab}* {}
{char} return CHAR_CONST;
{line} {lineno++;}
char return CHAR;
double return DOUBLE;
else return ELSE;
float return FLOAT;
for return FOR;
if return IF;
int return INT;
return return RETURN;
sizeof return SIZEOF;
void return VOID;
while return WHILE;

printf return PRINTF;
scanf return SCANF;

{alpha}({alpha}|{digit}|{und})* return IDENTIFIER;

"//" return SLC;
"/*" return MLCS;
"*/" return MLCE;

"<=" return LEQ;
">=" return GEQ;
"==" return EQEQ;
"!=" return NEQ;
"||" return OR;
"&&" return AND;
"=" return EQ;
"+" return PLUS;
"-" return SUB;
"*" return MULT;
"/" return DIV;
"%" return MOD;
"<" return LESSER;
">" return GREATER;
"++" return INCR;
"--" return DECR;

"," return COMMA;
";" return SEMI;

"#include<stdio.h>" return HEADER;
"#include <stdio.h>" return HEADER;
"main()" return MAIN;

{digit}+ return INT_CONST;
({digit}+)\.({digit}+) return FLOAT_CONST;

"%d"|"%f"|"%u"|"%s" return TYPE_SPEC;
"\"" return DQ;
"(" return PO;
")" return PC;
"{" return CBO;
"}" return CBC;
"#" return HASH;

{alpha}({alpha}|{digit}|{und})*\[{digit}*\] return ARR;
{alpha}({alpha}|{digit}|{und})*\(({alpha}|{digit}|{und}|{space})*\) return FUNC;
({digit}+)\.({digit}+)\.({digit}|\.)* return NUM_ERR;
({digit}|{at})+({alpha}|{digit}|{und}|{at})* return UNKNOWN;
%%

struct node
{
	char token[100];
    char attr[100];
	struct node *next;
};

struct hash
{
	struct node *head;
	int count;
};

struct hash hashTable[1000];
int eleCount = 1000;

struct node * createNode(char *token, char *attr)
{
	struct node *newnode;
	newnode = (struct node *) malloc(sizeof(struct node));
	strcpy(newnode->token, token);
	strcpy(newnode->attr, attr);
	newnode->next = NULL;
	return newnode;
}

int hashIndex(char *token)
{
	int hi=0;
	int l,i;
	for(i=0;token[i]!='\0';i++)
	{
		hi = hi + (int)token[i];
	}
	hi = hi%eleCount;
	return hi;
}

void insertToHash(char *token, char *attr)
{
	int flag=0;
	int hi;
	hi = hashIndex(token);
	struct node *newnode = createNode(token, attr);
	/* head of list for the bucket with index "hashIndex" */
	if (hashTable[hi].head==NULL)
	{
		hashTable[hi].head = newnode;
	        hashTable[hi].count = 1;
	        return;
	}
	struct node *myNode;
    	myNode = hashTable[hi].head;
	while (myNode != NULL)
    	{
        	if (strcmp(myNode->token, token)==0)
        	{
            		flag = 1;
            		break;
        	}
        	myNode = myNode->next;
    	}
	if(!flag)
	{
		//adding new node to the list
		newnode->next = (hashTable[hi].head);
		//update the head of the list and no of nodes in the current bucket
		hashTable[hi].head = newnode;
		hashTable[hi].count++;
	}
	return;
}

void display()
{
    	struct node *myNode;
    	int i,j, k=1;
    	printf("-------------------------------------------------------------------");
    	printf("\nSNo \t|\tToken \t\t|\tToken Type \t\n");
        printf("-------------------------------------------------------------------\n");
    	for (i = 0; i < eleCount; i++)
    	{
        	if (hashTable[i].count == 0)
            		continue;
        	myNode = hashTable[i].head;
        	if (!myNode)
            		continue;
        	while (myNode != NULL)
        	{
            		printf("%d\t\t", k++);
            		printf("%s\t\t\t", myNode->token);
            		printf("%s\t\n", myNode->attr);
            		myNode = myNode->next;
        	}
	}
   	return;
}

int main()
{
	int scan, slcline=0, mlc=0, mlcline=0, dq=0, dqline=0;
	yyin = fopen("test.c","r");
	printf("\n\n");
	scan = yylex();
	while(scan)
	{
		if(lineno == slcline)
		{
			scan = yylex();
			continue;
		}
		if(lineno!=dqline && dqline!=0)
		{
			if(dq%2!=0)
				printf("\n******** ERROR!! INCOMPLETE STRING at Line %d ********\n\n", dqline);
			dq=0;
		}
		if((scan>=1 && scan<=11) && mlc==0)
		{
			printf("%s\t\t\tKEYWORD\t\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "KEYWORD");
		}
		if(scan==12 && mlc==0)
		{
			printf("%s\t\t\tIDENTIFIER\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "IDENTIFIER");
		}
		if(scan==13)
		{
			printf("%s\t\t\tSingleline Comment\t\tLine %d\n", yytext, lineno);
			slcline = lineno;
		}
		if(scan==14 && mlc==0)
		{
			printf("%s\t\t\tMultiline Comment Start\t\tLine %d\n", yytext, lineno);
			mlcline = lineno;
			mlc = 1;
		}
		if(scan==15 && mlc==0)
		{
			printf("\n******** ERROR!! UNMATCHED MULTILINE COMMENT END %s at Line %d ********\n\n", yytext, lineno);
		}
		if(scan==15 && mlc==1)
		{
			mlc = 0;
			printf("%s\t\t\tMultiline Comment End\t\tLine %d\n", yytext, lineno);
		}
		if((scan>=16 && scan<=31) && mlc==0)
		{
			printf("%s\t\t\tOPERATOR\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "OPERATOR");
		}
		if((scan==32||scan==33||scan==44||(scan>=45 && scan<=49)) && mlc==0)
		{	
			printf("%s\t\t\tSPECIAL SYMBOL\t\t\tLine %d\n", yytext, lineno);
			if(scan==44)
			{
				dq++;
				dqline = lineno;
			}
			insertToHash(yytext, "SPECIAL SYMBOL");
		}
		if(scan==34 && mlc==0)
		{
			printf("%s\tHEADER\t\t\t\tLine %d\n",yytext, lineno);
		}
		if(scan==35 && mlc==0)
		{
			printf("%s\t\t\tMAIN FUNCTION\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "IDENTIFIER");
		}
		if((scan==36 || scan==39) && mlc==0)
		{
			printf("%s\t\t\tPRE DEFINED FUNCTION\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "PRE DEFINED FUNCTION");
		}
		if(scan==40 && mlc==0)
		{
			printf("%s\t\t\tPRE PROCESSOR DIRECTIVE\t\tLine %d\n", yytext, lineno);
		}
		if(scan==41 && mlc==0)
		{
			printf("%s\t\t\tINTEGER CONSTANT\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "INTEGER CONSTANT");
		}
		if(scan==42 && mlc==0)
		{
			printf("%s\t\t\tFLOATING POINT CONSTANT\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "FLOATING POINT CONSTANT");
		}
		if(scan==43 && mlc==0)
		{
			printf("%s\t\t\tTYPE SPECIFIER\t\t\tLine %d\n", yytext, lineno);
		}
		if(scan==50 && mlc==0)
		{
			printf("%s\t\t\tARRAY\t\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "ARRAY");
		}
		if(scan==51 && mlc==0)
		{
			printf("%s\t\t\tUSER DEFINED FUNCTION\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "USER DEFINED FUNCTION");
		}
		if(scan==52 && mlc==0)
		{
			printf("\n******** ERROR!! CONSTANT ERROR %s at Line %d ********\n\n", yytext, lineno);
		}
		if(scan==53 && mlc==0)
		{
			printf("\n******** ERROR!! UNKNOWN TOKEN %s at Line %d ********\n\n", yytext, lineno);
		}
		if(scan==54 && mlc==0)
		{
			printf("%s\t\t\tCHARACTER CONSTANT\t\t\tLine %d\n", yytext, lineno);
			insertToHash(yytext, "CHARACTER CONSTANT");
		}
		scan = yylex();
	}
	if(mlc==1)
		printf("\n******** ERROR!! UNMATCHED COMMENT STARTING at Line %d ********\n\n",mlcline);
	
	printf("\n");
	printf("\n\t******** SYMBOL TABLE ********\t\t\n");
	display();
    printf("-------------------------------------------------------------------\n\n");
}
int yywrap()
{
	return 1;
}
