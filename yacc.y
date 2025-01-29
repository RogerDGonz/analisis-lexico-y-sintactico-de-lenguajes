%{ 
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    void yyerror(char *s);
    int banderaCondicion = 0; // Declaración de banderas para controlar la sintaxis de las selects de tipo SELECT
    int banderaAux = 0;
    int banderaAux2 = 0;
    int banderaAux3 = 0;
    int banderaOrden = 0;
    int banderaOffset = 0;
    int banderaLimit = 0;
  
%}
%union { char cadena[20]; }
%left AND OR
%left ',' '(' ')' ';' '\n'
%token INTEGER SELECT FROM WHERE colInt TABLA TEXTO BETWEEN IN LIKE CNULL
%token ORDEN ORDENAR AGRUPAR INSERT INTO VALUES DELETE UPDATE SET 
%token <cadena> colString FINAL operadorSimple
%%
// Lines para leer cada línea del fichero de prueba.
lines:
        line '\n' 
        | lines line  '\n'  
        ;
// Line representa cada cosulta correcta que se espera por cada linea.
line: 
        select ';'  {  banderaCondicion = 0; banderaAux = 0; banderaAux2 = 0;  banderaAux3 = 0; banderaOrden = 0; banderaOffset = 0; banderaLimit = 0; }
	| insert ';' {  }
	| delete ';' { banderaCondicion = 0; }
	| update ';' { banderaCondicion = 0; banderaAux3 = 0; banderaAux = 0; banderaAux2 = 0;  }
	| line line {  }
	;
// Consula se encarga de realizar el analissi completo de las selects de tipo SELECT
select: 
	consultSelect 
	| select ORDENAR listaColumnas { if(banderaAux2 == 1 || banderaAux3 == 1 || banderaOrden == 1){
	        yyerror("Syntax Error");
	       	exit(1);
		}
		banderaAux2 = 1;
	}
	| select ORDENAR listaColumnas ORDEN { if(banderaOrden == 1 || banderaAux3 == 1 || banderaAux2 == 1){
		yyerror("Syntax Error");
                exit(1);
		}
		banderaOrden = 1;
	}
	| select FINAL INTEGER { 
		if((strcmp($2, "LIMIT") && banderaLimit == 1) || (strcmp($2, "OFFSET") && banderaOffset == 1)){
                 
			yyerror("Syntax Error");
               	        exit(1);
		}
		else if(strcmp($2, "LIMIT")){
			banderaLimit = 1;
			banderaAux3 = 1;
		}

		else {
			banderaOffset = 1;
			banderaAux3 = 1;
		}
	
	}
	;

consultSelect: 
       SELECT listaColumnas FROM TABLA
       | consultSelect WHERE condicion  {if(banderaCondicion == 1 || banderaAux == 1){
                                                yyerror("Syntax Error");
                                                exit(1);
                                        }
                                        banderaCondicion = 1;

                                        }
       | consultSelect AGRUPAR listaColumnas {if(banderaAux == 1){
                                                yyerror("Syntax Error");
                                                exit(1);
                                        }
                                        banderaAux = 1;
                                        }
        ;

 delete: 
 	DELETE FROM TABLA
	| delete WHERE condicion { if(banderaCondicion == 1){
                                                yyerror("Syntax Error");
                                                exit(1);
                                        }
                                        banderaCondicion = 1;

                                        }
update: 
	UPDATE TABLA SET listaValor 
	| update WHERE condicion { if(banderaCondicion == 1){
                                                yyerror("Syntax Error");
                                                exit(1);
                                        }
                                        banderaCondicion = 1;

                                        }
	;



// Insert se encarga de controlar las selects de tipo INSERT	
insert:
	INSERT INTO TABLA '(' colInt ',' colString ',' colString ')' VALUES '('INTEGER ',' TEXTO ',' TEXTO ')' {
	 
	if(strcmp($7, $9) == 0){
	 yyerror("Syntax Error");
	 exit(1);
	}
	}
	|INSERT INTO TABLA '(' colString ',' colInt ',' colString ')' VALUES '(' TEXTO ',' INTEGER ',' TEXTO ')' {

        if(strcmp($5, $9) == 0){
         yyerror("Syntax Error");
         exit(1);
        }
        }
	|INSERT INTO TABLA '(' colString ',' colString ',' colInt ')' VALUES '(' TEXTO ',' TEXTO ',' INTEGER ')' {

        if(strcmp($5, $7) == 0){
         yyerror("Syntax Error");
         exit(1);
        }
	}
	|INSERT INTO TABLA '(' colString ',' colString ')' VALUES '(' TEXTO ',' TEXTO ')' {

        if(strcmp($5, $7) == 0){
         yyerror("Syntax Error");
         exit(1);
        }
	}
        |INSERT INTO TABLA '(' colString ',' colInt ')' VALUES '(' TEXTO ',' INTEGER ')' {}
        |INSERT INTO TABLA '(' colInt ',' colString ')' VALUES '(' INTEGER ',' TEXTO ')' {}
        |INSERT INTO TABLA '(' colString ')' VALUES '(' TEXTO ')' {}
        |INSERT INTO TABLA '(' colInt ')' VALUES '(' INTEGER ')' {}


        
	;

// ListaColumnas se utilizar para permitir realizar listas de columnas de una tabla que se utilizarán en los SELECT, ORDER BY y GROUP BY ...
listaColumnas: 
       colString
       | colInt       
       | listaColumnas ',' listaColumnas 
       ;

// Condicion permite estructurar todas las condiciones que pueden venir después del WHERE
 condicion:
       colString operadorSimple TEXTO
       | colInt operadorSimple INTEGER
       | colString LIKE TEXTO
       | colInt BETWEEN INTEGER AND INTEGER
       | colString BETWEEN TEXTO AND TEXTO
       | colString IN '(' listaTexto ')'
       | colInt IN '(' listaInteger ')'
       | colString CNULL
       | colInt CNULL
       | condicion AND condicion  
       | condicion OR condicion
       ;

// listaIn permite estructurar una lista para los posibles valores que pueden venir después de IN.
 listaInteger: 
       INTEGER
       | colInt
       | listaInteger ',' listaInteger
       ;
  listaTexto:
  	TEXTO
	| colString
	| listaTexto ',' listaTexto
	;
 
 listaValor:
	colInt operadorSimple INTEGER { if(strcmp($2,"=") != 0 ||  banderaAux3 == 1){
			
			yyerror("Syntax Error\n");
			exit(1);
		}

		banderaAux3 = 1;
	 
	}
	| colString operadorSimple TEXTO {
		
		if(strcmp($2,"=") != 0 || ((strcmp($1, "nombre")) && banderaAux == 1) || (strcmp($1, "contrasena") && banderaAux2 == 1)){

                        yyerror("Syntax Error\n");
                        exit(1);
                }
		else if(strcmp($1, "nombre")){
			banderaAux = 1; 	
		}
		else{
			banderaAux2 = 1;  
		}
		}
	| listaValor ',' listaValor
	;
%% 
void yyerror(char *s) {
    fprintf (stderr, "%s\n", s);
}

