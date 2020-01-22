#include<stdbool.h>

#ifndef _SYMBOL_TABLE
#define _SYMBOL_TABLE
typedef struct symbol_node_struct symbol_node_t;

struct symbol_node_struct {
  char *symbol;
  char *type;
  int line_number;

  // symbol_node_t* left; // For binary tree based symbol table 
  symbol_node_t *next;
};

#define MAX_SYMBOL_TABLE_SIZE 10
// const int MAX_SYMBOL_TABLE_SIZE = 10;

// Function Prototypes
void symbol_table_initialize(symbol_node_t **symbol_table);

// int symbol_table_hash(const char *symbol);

void symbol_table_insert(symbol_node_t **symbol_table, const char* symbol, const char *type, const int line_number);

bool symbol_table_lookup(symbol_node_t **symbol_table, const char* symbol);

void symbol_table_free(symbol_node_t **symbol_table);

void symbol_table_print(symbol_node_t **symbol_table, const char *table_name);

#endif
