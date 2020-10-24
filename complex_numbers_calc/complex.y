
%{
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "complex_number.h"
#include <vector>
#include <iostream>

int yylex(void);
void yyerror(char *);
//int yydebug=0;   /*  set to 1 if using with yacc's debug/verbose flags   */
std::vector<struct ComplexNumber*> numbers; // need to be freed

int  printComplexNumber(struct ComplexNumber c);
struct ComplexNumber*  newComplexNumber(double w, double x);
void free_numbers(std::vector<struct ComplexNumber*>& numbersLocal);
struct ComplexNumber*  realPart(struct ComplexNumber qArg);
struct ComplexNumber*  imaginaryPart(struct ComplexNumber qArg);
double  normSquared(struct ComplexNumber q);
double  norm(struct ComplexNumber q);
struct ComplexNumber  conjugate(struct ComplexNumber q);
struct ComplexNumber  negate(struct ComplexNumber q);
struct ComplexNumber*  scalarTimesComplexNumber(double s, struct ComplexNumber q);
struct ComplexNumber*  sum(struct ComplexNumber* q1_ptr, struct ComplexNumber* q2_ptr);
struct ComplexNumber*  diff(struct ComplexNumber* q1_ptr, struct ComplexNumber* q2_ptr);
struct ComplexNumber*  product( struct ComplexNumber* q1_ptr, struct ComplexNumber* q2_ptr);
struct ComplexNumber*  quotient(struct ComplexNumber* q1_ptr, struct ComplexNumber* q2_ptr);
struct ComplexNumber*  inverse(struct ComplexNumber q);

%}

%union {
    int  iValue;
    char *str;
    struct ComplexNumber *cmplxnmbr;
    float num;
};

%token  <num>  NUMBER
%token  <str>  I

%left '+'
%left '*'
%left '-'
%left '/'
%nonassoc UMINUS

%type  <iValue>  start
%type  <iValue>  line
%type  <num>  real_number;

%type <cmplxnmbr> i_part
%type <cmplxnmbr> complex_number

%start  start

%%       /*   rules section   */

start    :    line  '\n'       {  }
         |    start  line  '\n'          {  }
         ;

line     :    complex_number   { printComplexNumber(*($1)); /*printf("about to free\n");*/ free_numbers(numbers);  }
         |        /*  allow "empty" expression  */           {     }

complex_number : '(' complex_number ')' { $$ = $2; }
         | real_number { $$ = newComplexNumber($1, 0); }
         | i_part        { $$ = $1; }
         | complex_number '*' complex_number { $$ = product($1, $3); }
         | complex_number '/' complex_number { $$ = quotient($1, $3); }
         | complex_number '+' complex_number { $$ = sum($1, $3); }
         | complex_number '-' complex_number { $$ = diff($1, $3); }
         | '-' complex_number %prec UMINUS { $$ = negate($2); }

i_part :  real_number I { $$ = newComplexNumber(0, $1); }
       |  I { $$ = newComplexNumber(0, 1); }

real_number      :    NUMBER             {  $$ = $1;   }
 
// rules ended 

;

%%      /*   programs   */

int  printComplexNumber(struct ComplexNumber c)
/*  print in the standard form  w + x i  */
{
  return  printf("%f + %f i\n", c.w, c.x);
}

struct ComplexNumber*  newComplexNumber(double w, double x)
{
  struct ComplexNumber* q = (struct ComplexNumber*) malloc(sizeof(struct ComplexNumber));
  numbers.push_back(q);

  q->w = w;
  q->x = x;
  return  q;
}

void free_numbers(std::vector<struct ComplexNumber*>& numbersLocal) {
  std::vector<struct ComplexNumber*>::iterator it;
  for (it=numbersLocal.begin(); it != numbersLocal.end(); it++) {
     free(*it);
  }
  std::cout << "freed " << numbersLocal.size() << " pointers" << std::endl ;
  numbersLocal.clear();
}

struct ComplexNumber*  realPart(struct ComplexNumber qArg)
{
  struct ComplexNumber* q = (struct ComplexNumber*) malloc(sizeof(struct ComplexNumber));
  numbers.push_back(q);

  q->w = qArg.w;
  q->x = 0;

  return q;
}

struct ComplexNumber*  imaginaryPart(struct ComplexNumber qArg)
{
  struct ComplexNumber* q = (struct ComplexNumber*) malloc(sizeof(struct ComplexNumber));
  numbers.push_back(q);

  q->w = 0;
  q->x = qArg.x;

  return q;
}

double  normSquared(struct ComplexNumber q)
{
  return  q.w*q.w + q.x*q.x;
}

double  norm(struct ComplexNumber q)
{
  return  sqrt(normSquared(q));
}

struct ComplexNumber  conjugate(struct ComplexNumber q)
{
  struct ComplexNumber* qt = newComplexNumber(q.w, -q.x);
  return *qt;
}

struct ComplexNumber*  negate(struct ComplexNumber* q)
{
  struct ComplexNumber* qt = newComplexNumber(-q->w, -q->x);
  return qt;
}

struct ComplexNumber*  scalarTimesComplexNumber(double s, struct ComplexNumber q)
{
  struct ComplexNumber* qt = newComplexNumber(s*q.w, s*q.x);
  return qt;
}

struct ComplexNumber*  sum(struct ComplexNumber* q1_ptr, struct ComplexNumber* q2_ptr)
{

  struct ComplexNumber q1 = *q1_ptr;
  struct ComplexNumber q2 = *q2_ptr;

  struct ComplexNumber* qsum = (struct ComplexNumber*) malloc(sizeof(struct ComplexNumber));
  numbers.push_back(qsum);

  qsum->w = q1.w + q2.w;
  qsum->x = q1.x + q2.x;

  return  qsum;
}

struct ComplexNumber*  diff(struct ComplexNumber* q1_ptr, struct ComplexNumber* q2_ptr)
{
  struct ComplexNumber q1 = *q1_ptr;
  struct ComplexNumber q2 = *q2_ptr;

  struct ComplexNumber* qdiff = (struct ComplexNumber*) malloc(sizeof(struct ComplexNumber));

  qdiff->w = q1.w - q2.w;
  qdiff->x = q1.x - q2.x;

  return  qdiff;
}

struct ComplexNumber*  product( struct ComplexNumber* q1_ptr, struct ComplexNumber* q2_ptr)
{
  struct ComplexNumber q1 = *q1_ptr;
  struct ComplexNumber q2 = *q2_ptr;

  struct ComplexNumber* qprod = (struct ComplexNumber*) malloc(sizeof(struct ComplexNumber));

  qprod->w = q1.w*q2.w - q1.x*q2.x;
  qprod->x = q1.w*q2.x + q1.x*q2.w;

  return  qprod;
}

struct ComplexNumber*  quotient(struct ComplexNumber* q1_ptr, struct ComplexNumber* q2_ptr)
/*  returns the quotient  q1 / q2 
    calculated as  q1 * (1/q2).
*/
{
  struct ComplexNumber q2 = *q2_ptr;

  return  product(q1_ptr, inverse(q2) ); 
}

struct ComplexNumber*  inverse(struct ComplexNumber q)
/*  returns the multiplicative inverse  1/q  of the ComplexNumber  q.  */
{
  struct ComplexNumber* qt = scalarTimesComplexNumber(1.0/normSquared(q), conjugate(q));
  return qt;
}

int main(void) {
    yyparse();

    //free_numbers(numbers); // no memory leak!
    return 0;
}