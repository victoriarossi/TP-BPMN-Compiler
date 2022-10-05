#ifndef BISON_ACTIONS_HEADER
#define BISON_ACTIONS_HEADER

#include "../../backend/support/shared.h"
#include "../../backend/semantic-analysis/abstract-syntax-tree.h"

/**
 * Se definen las acciones a ejecutar sobre cada regla de producción de la
 * gramática. El objetivo de cada acción debe ser el de construir el nodo
 * adecuado que almacene la información requerida en el árbol de sintaxis
 * abstracta (i.e., el AST).
 */

// Programa.
Program * ProgramGrammarAction( Graph * value);

// Expresión.
Graph * CreateGraphActionPool(char* title,  Pool * pool);
Graph * CreateGraphAction( char* title,  Create * value);
Pool * CreatePoolAction( char* poolName,  Lane * lane,  CreateP * create);
Lane * CreateLaneAction( char* title,  Create * expression);
Expression * CreateEventAction(char* type, char* title, char* var);
Expression * CreateActivityAction(char* title, char* var);
Expression * CreateArtifactAction(char* type, char* title, char* var);
Gateway * CreateGatewayAction(char* title,  Set * set,  char* var );
Set * CreateSetGetwayAction(char* title, char* var);
Connect * CreateConnectionAction( char* leftVar, char* rightVar);

#endif