
%lex

ID_START  [!@#$%^&*+=<>\-_a-z]
ID_REST   [!@#$%^&*+=<>\-_a-z0-9]*
%%

\s+                 /* skip */
";"[^\n\r]*         /* skip */
0x[0-9a-fA-F]+      return 'INT_HEX';
0b[0-1]+            return 'INT_BIN';
[0-9]+"."[0-9]*     return 'FLOAT';
"."[0-9]+           return 'FLOAT';
[0-9]+              return 'INT';
"\"".*"\""          return 'STRING';

'('     return '(';
')'     return ')';
'['     return '[';
']'     return ']';
"'"     return "'";

{ID_START}{ID_REST} return 'IDENTIFIER';

<<EOF>> return 'EOF';

/lex

%start compilationUnit

%%

compilationUnit
    : program EOF   {return $$;}
    ;

program
    : sexpr         {$$ = [$1];}
    | program sexpr {$$ = $1.concat($2);}
    ;

sexpr
    : list      {$$ = {type: 'sexpr', body: $1};}
    | "'" list  {$$ = {type: 'list', body: $2};}
    ;

list
    : '(' exprList ')'  {$$ = $2;}
    | '(' ')'           {$$ = [];}
    ;

vector
    : '[' exprList ']'  {$$ = {type: 'vector', body: $2};}
    | '[' ']'           {$$ = {type: 'vector', body: []};}
    ;

exprList
    : expr          {$$ = [$1];}
    | exprList expr {$$ = $1.concat($2);}
    ;

expr
    : IDENTIFIER    {$$ = {type: 'identifier', value: $1};}
    | constant
    | sexpr
    | vector
    ;

constant
    : INT       {$$ = {type: 'int', value: parseInt($1), raw: $1};}
    | INT_HEX   {$$ = {type: 'int', value: parseInt($1.substr(2), 16), raw: $1};}
    | INT_BIN   {$$ = {type: 'int', value: parseInt($1.substr(2), 2), raw: $1};}
    | FLOAT     {$$ = {type: 'float', value: parseFloat($1), raw: $1};}
    | STRING    {$$ = {type: 'string', value: $1.slice(1,-1)};}
    ;

