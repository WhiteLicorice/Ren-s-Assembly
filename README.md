# CMSC-131-Laboratory
This is a repository for lab work in CMSC 131 (Machine-Level Programming) with NASM. Paul Carter's [book](https://pacman128.github.io/pcasm/) is used extensively as a reference. It contains a `guide` on how to setup an environment for writing assembly programs in NASM. To follow along with the contents of this repository, it is advised to have a copy of the book.

## Lab 00

1. Declare two variables `jack` and `jill` to store an integer each.
2. Prompt the user to input the value of `jack` and store it in the `jack` variable.
3. Prompt the user to input the value of `jill` and store it in the `jill` variable.
4. Print the initial values of `jack` and `jill` to identify their values.
5. Swap the values of the variables `jack` and `jill`.
6. Print the updated values of the variables `jack` and `jill`.

## Lab 01
1. Solve for an `integer` using basic opcodes.
2. The first two digits add up to 8.
3. The difference of the second and fifth digits is equal to the fourth digit. 
4. The middle digit is the quotient when the product of the first and last digits is divided by 6.

## Lab 02

1. Identify whether a `year` is a leap year.
2. The user should input an integer that represents the `year`.
3. Use control structures such as `cmp` and `jmp` to accomplish the task.

## Lab 03

1. Identify the Least Common Multiple (LCM) of two integers.
2. The user should input the two integers.
3. Use control structures such as `cmp` and `jmp` to accomplish the task.

## Lab 04

1. Implement right-shift and left-shift operations using native opcodes.
2. The user should input an integer to be `shifted` and another integer to denote the `number of places to shift`.

## Lab 05

1. Implement bitwise `OR`, `AND`, and `XOR` operations.
2. The user should input two integers to be operated on.

## Lab 06

1. Calculate the `factorial` of an integer.
2. The user should input the integer.
3. Use `call` and `ret` in accomplishing the task.

##  Lab 07

1. Take the program you wrote in `Lab 6` and implement it as a multi-module program.
2. Create a module named `factorial.asm` that contains the subprograms `get_int` and `factorial`.
3. Another file `main.asm` should consist of the external subprograms `get_int` and `factorial`.

## Lab 08

1. Print out a `multiplication table` from `1 up to N`.
2. `N` should be an integer input taken from the user.
3. A module named `mult.asm` should exist that interfaces with `main.c`.

## Lab 09

1. Print out the `Fibonacci series` up to the `Kth` number.
2. `K` should be an integer input from the user.
3.  A module named `fibo.asm` should interface with `main.c`.
4. The program `main.c` should call a subprogram `fibonacci` from `fibo.asm` that solves for the Fibonacci numbers.

## Lab 10

1. Attempt to `sort` the values in an `array`.
2. A program named `sortArray.asm` should sort the values in an array from user input.
3. `sortArray.asm` should interface with `array1c.c`.
4. The sorting algorithm is `abstracted`, which means that you may implement whatever sorting algorithm you prefer.

## Lab 11
1. Find the the `modal character(s)` in a `string` and their `frequency`.
2. The `string` should be from a user input.
3. `Spaces` should not be included as characters.
4. Assume that the user input is a `string` in `ASCII` character encoding.
5. You may use whatever algorithm you prefer.
