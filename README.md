# Programming Praxis in OCaml

This project is my attempt at solving Programming Praxis problems
using Ocaml.

### Running

To compile all problems:

	make

To compile and test all problems:

	make test

To test one problem:

	make <problem-name>

## RPN Calculator (rpn-calculator)

This problem is solved. To solve it I've created a module
RpnCalculator, parameterized on another module which defines the type
of operands.
