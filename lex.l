%{
/*
* GRUPO DE LABORATORIO GL104: 
*
* -MARIO GARCÍA BENITO
* -ROGER DANIEL GONZÁLEZ NIEBLA
* -MARCOS MARTÍNEZ ANTÓN 
* -BELID MEJÍA LARGO
*
*/
 #include <stdlib.h>
 #include "y.tab.h"
%}
  // Estructura
 typedef struct {
    char ip[20]; // String para guardar la direcciones ip
    int cantidadSolicitudes; // Contador solicitudes.
  }RegistroIP;


 int buscarIP(char *ip, RegistroIP *listaip, int tam);

 // variables de control 
 int contadorBarra=0; // contador del caracter '|'
 int campoAnalizar=0; // bandera que se activa en caso de estar en el campo a evaluar su expresión 
 int numSolicitud = -1;  // Numero de solicitud que nos servirá para reconocer el tipo de solicitud dentro de la matriz.
 int tam = 0; // Tamaño actual de la lista de ip.
 int numConsultas=0;
 int variableEntrada=0;
 RegistroIP *listaip = NULL; // arreglo de ips

esp \x20
condicionNull IS{esp}NULL|IS{esp}NOT{esp}NULL
agrupar GROUP{esp}BY
ordenar ORDER{esp}BY
barra \|
%%
[a-zA-Z]+= { variableEntrada++; if(variableEntrada>1) REJECT; }//printf("query"); return Query; }
[0-9]+      {  if(campoAnalizar) return INTEGER; }
SELECT      { if(campoAnalizar) return SELECT; }
FROM        {  if(campoAnalizar) return FROM; }
WHERE       {  if(campoAnalizar) return WHERE; }
usuarios    {  if(campoAnalizar) return TABLA; }
nombre|contrasena { strcpy(yylval.cadena, yytext); if(campoAnalizar)  return colString; } // Se declara colString para determinar que se trata de una columna de tipo String
id          { if(campoAnalizar) return colInt; } // Se declara colInt para determinar que se trata de una columnas de tipo Int
LIKE 	    {  if(campoAnalizar) return LIKE; }
BETWEEN     {  if(campoAnalizar) return BETWEEN; }
IN          {  if(campoAnalizar) return IN; }
AND 	    {  if(campoAnalizar) return AND; }
OR          { if(campoAnalizar) return OR; }
OFFSET|LIMIT { strcpy(yylval.cadena, yytext); if(campoAnalizar) return FINAL; } // Se retorna FINAL para aquellas palabras claves que cierran la consulta.
DESC|ASC {  if(campoAnalizar) return ORDEN; } // Orden para especificar el de que forma se ordena.
INSERT      { if(campoAnalizar) return INSERT; }
DELETE      {  if(campoAnalizar) return DELETE; }
UPDATE      {  if(campoAnalizar) return UPDATE; }
SET         { if(campoAnalizar) return SET; }
INTO        { if(campoAnalizar) return INTO; }
VALUES      { if(campoAnalizar) return VALUES; }
{condicionNull} { if(campoAnalizar) return CNULL; } // CNULL para las palabraas clavves que utilizan null: IS NULL y IS NOT NULL
{agrupar} { if(campoAnalizar) return AGRUPAR; } // Agrupar para cuando se utiliza GROUP BY
{ordenar} {  if(campoAnalizar) return ORDENAR; } // Ordenar para cuando se utiliza ORDER BY
=|<>|!=|<=|>= { strcpy(yylval.cadena, yytext); if(campoAnalizar) return operadorSimple; }
'([^']+)'   { if(campoAnalizar) return TEXTO; } // Para encontrar texto
[,()]         { if(campoAnalizar) return *yytext; }
[ \t]       {}


; {
		numConsultas++;
	 if(campoAnalizar) return *yytext;

}

^GET { 
    numSolicitud =0;
}
^PUT {
    numSolicitud=1;

}
^POST {
    numSolicitud=1;

}

{barra} {
	 contadorBarra++;
    if(numSolicitud==0 && contadorBarra==2) {
        campoAnalizar=1; 
	}
    //si si es put o post, esperamos a estar en body
    if(numSolicitud!=0 && contadorBarra==3) {
        campoAnalizar=1; 
	}
 }

((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?) {
		char dir[20];
	    // buscamos si la ip ya se encuentra en la lista
	    strncpy(dir, yytext, sizeof(dir));
	    int posicion = buscarIP(dir, listaip, tam);
	   // caso de que no este en la lista
	   if (posicion == -1) {  // Comprobamos si la ip se encuentra ya en la lista.
		//ampliamos el array
		listaip = realloc(listaip, (tam + 1) * sizeof(RegistroIP));
		if (listaip == NULL) {
		    fprintf(stderr, "Error: No se pudo asignar memoria \n");
		    exit(1);
		}
		//guardamos la ip y actualizamos valores
		strcpy(listaip[tam].ip, dir);
		posicion = tam;
		listaip[posicion].cantidadSolicitudes=0;
		tam++;
		}	    
		listaip[posicion].cantidadSolicitudes+=numConsultas;
}

\n  {	//al encontrar el salto de linea, significa que hemos terminado de analizar una petición, actualizaremos los valores
	//si hay riesgo, entonces agregamos al contador del metodo correspondiente

	
	contadorBarra=0;
	campoAnalizar=0;
	numConsultas=-1;
	variableEntrada=0;
	return *yytext;
        }

.          {}

%%

/**
 * Busca una dirección IP dada dentro de una matriz de estructuras RegistroIP.
 *
 * @param ip      Puntero a una cadena de caracteres que representa la dirección IP que se busca.
 * @param listaip Puntero a una estructura de tipo RegistroIP, que representa una matriz de estructuras.
 * @param tam     Tamaño de la matriz listaip.
 * @return        La posición de la dirección IP en la matriz si se encuentra, o -1 si no se encuentra.
 */
int buscarIP(char *ip, RegistroIP *listaip, int tam) {
    // Recorre la matriz listaip
    for (int i = 0; i < tam; i++) {
        // Comprueba si la dirección IP en la posición i de la matriz listaip es igual a la dirección IP dada
        if (strcmp(listaip[i].ip, ip) == 0) {
            return i;   // Devuelve la posición donde se encuentra la IP
        }
    }
    // Devuelve -1 si la IP no se encuentra en la matriz
    return -1;
}


int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s archivo_entrada\n", argv[0]);
        return 1;
    }
    yyin = fopen(argv[1], "r");
    yyparse();
    fclose(yyin);
    for (int i = 0; i < tam; i++) 
        printf("IP: %s ha enviado %d solicitudes \n", listaip[i].ip, listaip[i].cantidadSolicitudes);
    return 0;

}



int yywrap() {
    return 1;
}

