
%{

#include "bison-actions.h"
#include "../../backend/support/shared.h"
#include "../../backend/semantic-analysis/abstract-syntax-tree.h"

%}

// Tipos de dato utilizados en las variables semánticas ($$, $1, $2, etc.).
%union{
	
	Program * program;
	Expression * expression;
	Create * create;
	CreateP * createp;
	Graph * graph;
	Pool * pool;
	Gateway * gateway;
	Set * set;
	Lane * lane;
	Connect * connect;

	char * string;
	int token;
	int integer;
}

// IDs y tipos de los tokens terminales generados desde Flex.
%token <token> START
%token <token> END
%token <token> GRAPH_ID
%token <token> POOL
%token <token> LANE
%token <token> CREATE
%token <token> EVENT
%token <token> ACTIVITY
%token <token> GATEWAY
%token <token> CONNECT
%token <token> CONNECT_TO
%token <token> CURLY_BRACES_OPEN
%token <token> CURLY_BRACES_CLOSE
%token <token> ARTIFACT
%token <token> AS
%token <token> TO
%token <token> SET

%token <string> NAME
%token <string> EVENT_TYPE
%token <string> ARTIFACT_TYPE
%token <string> VAR

// Tipos de dato para los no-terminales generados desde Bison.
%type <program> program 
%type <expression> expression
%type <create> create
%type <createp> createp
%type <graph> graph
%type <pool> pool
%type <gateway> gateway
%type <set> set
%type <lane> lane
%type <connect> connect
 
// El símbolo inicial de la gramatica.
%start program

%%

program: graph											{ $$ = ProgramGrammarAction($1); }
	;

graph: START GRAPH_ID NAME pool END GRAPH_ID				{ $$ = CreateGraphActionPool($3,$4); }
	| START GRAPH_ID NAME create END GRAPH_ID				{ $$ = CreateGraphAction($3,$4); } 
	;

pool: START POOL NAME lane createp END POOL					{ $$ = CreatePoolAction($3,$4, $5); }
	| START POOL NAME lane createp END POOL pool			{ $$ = CreateAppendPoolAction($3,$4, $5, $8); } 
	;

lane: START LANE NAME create END LANE lane				{ $$ = CreateLaneAction($3,$4,$7); } 
	| START LANE create END LANE lane					{ $$ = CreateLaneAction("",$3,$6); } 
	| START LANE lane END LANE lane						{ $$ = CreateLaneWithLaneAction("",$3,$6); } 
	| START LANE NAME lane END LANE lane				{ $$ = CreateLaneWithLaneAction($3,$4,$7); } 
	| /*lambda*/  										{ $$ = NULL; }
	;

create: expression  										{ $$ = CreateExpressionIntoCreate($1); }
		| expression create 								{ $$ = CreateAppendExpresionIntoCreate($1,$2); }            

createp: create 	  										{ $$ = CreateIntoCreatep($1); }
		| /*lambda*/  										{ $$ = NULL; }
		;

expression:  CREATE EVENT EVENT_TYPE NAME AS VAR 		{ $$ = CreateEventAction($3, $4, $6); }
		| CREATE ACTIVITY NAME AS VAR 					{ $$ = CreateActivityAction($3, $5); } 
		| CREATE ARTIFACT ARTIFACT_TYPE NAME AS VAR  	{ $$ = CreateArtifactAction($3, $4, $6); } 
		| gateway										{ $$ = CreateGatewayIntoExpressionAction($1); }
		| connect										{ $$ = CreateConnectIntoExpressionAction($1); }
		;

gateway: CREATE GATEWAY NAME CURLY_BRACES_OPEN
			set
		 CURLY_BRACES_CLOSE AS VAR 						{ $$ = CreateGatewayAction($3, $5, $8); } 
	;

set: SET NAME CONNECT TO VAR  						{ $$ = CreateSetGatewayAction($2, $5); } 
	|SET NAME CONNECT TO VAR set					{ $$ = CreateAppendSetGatewayAction($2, $5, $6); } 
	;

connect: CONNECT VAR TO VAR 						{$$ = CreateConnectionAction($2, $4); }
	;

%%