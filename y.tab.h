/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    AND = 258,                     /* AND  */
    OR = 259,                      /* OR  */
    INTEGER = 260,                 /* INTEGER  */
    SELECT = 261,                  /* SELECT  */
    FROM = 262,                    /* FROM  */
    WHERE = 263,                   /* WHERE  */
    colInt = 264,                  /* colInt  */
    TABLA = 265,                   /* TABLA  */
    TEXTO = 266,                   /* TEXTO  */
    BETWEEN = 267,                 /* BETWEEN  */
    IN = 268,                      /* IN  */
    LIKE = 269,                    /* LIKE  */
    CNULL = 270,                   /* CNULL  */
    ORDEN = 271,                   /* ORDEN  */
    ORDENAR = 272,                 /* ORDENAR  */
    AGRUPAR = 273,                 /* AGRUPAR  */
    INSERT = 274,                  /* INSERT  */
    INTO = 275,                    /* INTO  */
    VALUES = 276,                  /* VALUES  */
    DELETE = 277,                  /* DELETE  */
    UPDATE = 278,                  /* UPDATE  */
    SET = 279,                     /* SET  */
    colString = 280,               /* colString  */
    FINAL = 281,                   /* FINAL  */
    operadorSimple = 282           /* operadorSimple  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define AND 258
#define OR 259
#define INTEGER 260
#define SELECT 261
#define FROM 262
#define WHERE 263
#define colInt 264
#define TABLA 265
#define TEXTO 266
#define BETWEEN 267
#define IN 268
#define LIKE 269
#define CNULL 270
#define ORDEN 271
#define ORDENAR 272
#define AGRUPAR 273
#define INSERT 274
#define INTO 275
#define VALUES 276
#define DELETE 277
#define UPDATE 278
#define SET 279
#define colString 280
#define FINAL 281
#define operadorSimple 282

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 15 "yacc.y"
 char cadena[20]; 

#line 124 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
