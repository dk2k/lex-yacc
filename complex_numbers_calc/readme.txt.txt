
Here https://github.com/chpoon92/complex-number-calculator-flex-bison you can see how you DON'T use lex/yacc to process complex number.
complexnum {ws}*[-]*{ws}*{number}{ws}*[+|-]{ws}*{number}{ws}*{im}{ws}* - this rule means the author has no understanding of the topic.

For now there are just 2 combinations: real part can be before and after imaginary part. But what if you want to process quaternions (I have a working solution for them as well)? They have 3 types of imaginary parts. The number of combinations in the rule becomes overwhelming ;)

Commands to build a binary:

lex complex.l
yacc -d complex.y
g++  lex.yy.c y.tab.c -lm

Sample tests:

/home/user/complex/a.out
i + i
Token: I;  Lexeme: i
Token and Lexeme: +
Token: I;  Lexeme: i
Token and Lexeme: <newline>
0.000000 + 2.000000 i
freed 3 pointers

1 + i
Token: NUMBER;  Lexeme: 1
Token and Lexeme: +
Token: I;  Lexeme: i
Token and Lexeme: <newline>
1.000000 + 1.000000 i
freed 3 pointers

(1+i)/(1+i)
Token and Lexeme: (
Token: NUMBER;  Lexeme: 1
Token and Lexeme: +
Token: I;  Lexeme: i
Token and Lexeme: )
Token and Lexeme: /
Token and Lexeme: (
Token: NUMBER;  Lexeme: 1
Token and Lexeme: +
Token: I;  Lexeme: i
Token and Lexeme: )
Token and Lexeme: <newline>
1.000000 + 0.000000 i
freed 8 pointers

(1+i)*(1+i)
Token and Lexeme: (
Token: NUMBER;  Lexeme: 1
Token and Lexeme: +
Token: I;  Lexeme: i
Token and Lexeme: )
Token and Lexeme: *
Token and Lexeme: (
Token: NUMBER;  Lexeme: 1
Token and Lexeme: +
Token: I;  Lexeme: i
Token and Lexeme: )
Token and Lexeme: <newline>
0.000000 + 2.000000 i
freed 6 pointers

-i
Token and Lexeme: -
Token: I;  Lexeme: i
Token and Lexeme: <newline>
-0.000000 + -1.000000 i
freed 2 pointers

-2i + 1
Token: NUMBER;  Lexeme: -2
Token: I;  Lexeme: i
Token and Lexeme: +
Token: NUMBER;  Lexeme: 1
Token and Lexeme: <newline>
1.000000 + -2.000000 i
freed 3 pointers

-3i - 1
Token: NUMBER;  Lexeme: -3
Token: I;  Lexeme: i
Token and Lexeme: -
Token: NUMBER;  Lexeme: 1
Token and Lexeme: <newline>
-1.000000 + -3.000000 i
freed 2 pointers

1/i
Token: NUMBER;  Lexeme: 1
Token and Lexeme: /
Token: I;  Lexeme: i
Token and Lexeme: <newline>
0.000000 + -1.000000 i
freed 4 pointers

-i -i
Token and Lexeme: -
Token: I;  Lexeme: i
Token and Lexeme: -
Token: I;  Lexeme: i
Token and Lexeme: <newline>
-0.000000 + -2.000000 i
freed 3 pointers

2i/(6+i)
Token: NUMBER;  Lexeme: 2
Token: I;  Lexeme: i
Token and Lexeme: /
Token and Lexeme: (
Token: NUMBER;  Lexeme: 6
Token and Lexeme: +
Token: I;  Lexeme: i
Token and Lexeme: )
Token and Lexeme: <newline>
0.054054 + 0.324324 i
freed 6 pointers


Lines like "freed 4 pointers" remind you about prevented memory leaks. The result of calculation is just above.

Feel free to donate, if you find this code useful - Paypal account krjukov@gmail.com