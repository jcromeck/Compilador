grammar Lang;

prog: 
    imports? functions? line+    # progLine
  ;
imports: 
    (IMPORT VAR EOL)+
  ;
functions:
    function functions
  | function
  ;

function: 
      FUNCTION VAR '('params')' '{' fnBody? (RETURN expr';')? '}'
    ; 
fnBody:
      line                      # fnBodyLine
    | line fnBody               # fnBodyLineMore
    ;

params: 
    VAR
  | VAR SEP params
  | // empty
  ;

line:
	  stmt EOL          # lineStmt
	| ifst              # lineIf
	| whilest           # lineWhile
  | forst             # lineFor
  | function          # lineFunction
	| EOL               # lineEOL
  ;

funcInvoc:
    VAR '(' params ')' # funcInvocLine
  ;

stmt: 
    atrib             # stmtAtrib
  | input             # stmtInput
  | output            # stmtOutput    
  | funcInvoc         # lineFuncInvoc
  ;
input: 
    READ VAR          # inputRead
  ;
 
output: 
    WRITE VAR? expr?  #outputWrite     
  ;

ifst:
	  IF '(' cond ')' block                  # ifstIf
	| IF '(' cond ')' b1=block ELSE b2=block # ifstIfElse
  | IF '(' cond ')' b1=block ELSE ifst     # ifstIfElseIF
  ;
forst:
    'for''('cond')'block
  | 'for''('cond';'VAR '=' expr')'block
  | 'for''('cond';'VAR '++'')'block
  ;
whilest:
    WHILE'('cond')'block
  | REPEAT block UNTIL cond
  ;
block:
    '{' line+ '}'                # blockLine
  ;

cond: 
    expr                        # condExpr
  | e1=expr RELOP=(EQ|NE|LT|GT|LE|GE) e2=expr       # condRelop
  | c1=cond AND c2=cond         # condAnd
  | c1=cond OR c2=cond          # condOr
  | NOT cond                    # condNot
  ;

atrib:
    declare VAR '=' expr        # declaracao
  | declare VAR              # declaracaoVazia
  | array_declaracao         # declaracaoArray
  ;
declare:
    STRING            # declararString
  | INT               # declararInt
  | FLOAT             # declararFloat
  | BOOLEAN           # declararBoolean
  |                   # chamarVariavel
  | 'var'             # declararVar
  ;
array_declaracao: type '[' NUM ']' VAR '=' '{' array_elements '}' ;
type: 
    STRING 
  | INT
  | BOOLEAN
  | FLOAT
  ;
array_elements: expr (',' expr)* ;
expr: 
    term '+' expr         # exprPlus
  | term '-' expr         # exprMinus
  | term                  # exprTerm
  | BOOL_TRUE             # exprTrue
  | BOOL_FALSE            # exprFalse
  | STR                   # exprString
  ;

term: 
    factor '*' term       # termMult
  | factor '/' term       # termDiv
  | factor '%' term       # termResto
  | factor                # termFactor
  ;           

factor: 
    '(' expr ')'             # factorExpr
  | VAR                      # factorVar
  | NUM                      # factorNum
  | VAR '['array_elements']' # exprArray
  ;

// Lexical rules
OE: '(';
CE: ')';
OB: '{';
CB: '}';
AT: '=';
SEP: ',';
PLUS: '+';
MINUS: '-';
MULT: '*';
DIV: '/';
AND: '&&';
OR: '||';
NOT: '!';
EQ : '==';
LT : '<';
GT : '>';
LE : '<=';
GE : '>=';
NE : '!=';
BOOL_TRUE: [tT][r][u][e];
BOOL_FALSE: [fF][a][l][s][e];
IF: [iI][fF];
FUNCTION: [fF][uU][nN][cC][tT][iI][oO][nN];
RETURN: [rR][eE][tT][uU][rR][nN];
THEN: [tT][hH][eE][nN];
ELSE: [eE][lL][sS][eE];
WRITE: [wW][rR][iI][tT][eE];
READ: [rR][eE][aA][dD];
STR: '"' ~["]* '"';
INT: [iI][nN][tT];
FLOAT: [fF][lL][oO][aA][tT];
STRING: [sS][tT][rR][iI][nN][gG];
BOOLEAN: [bB][oO][oO][lL][eE][aA][nN];
WHILE: [wW][hH][iI][lL][eE];
REPEAT: [rR][eE][pP][eE][aA][tT];
UNTIL: [uU][nN][tT][iI][lL];
IMPORT: [iI][mM][pP][oO][rR][tT];
EOL: ';';
NUM: [0-9]+ (.([0-9]+))?;
VAR: [a-zA-Z_][a-zA-Z0-9_]*;
COMMENT: '//' ~[\r\n]* -> skip;
WS: [ \t\n\r]+ -> skip;