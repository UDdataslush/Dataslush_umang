#!/bin/bash

# Prompt the user to enter two numbers
echo "Enter the first number: "
read num1

echo "Enter the second number: "
read num2

# Perform arithmetic operations
sum=$((num1 + num2))
difference=$((num1 - num2))
product=$((num1 * num2))
if [ "$num2" -ne 0 ]; then
    quotient=$((num1 / num2))
    modulus=$((num1 % num2))
else
    quotient="Undefined (division by zero)"
    modulus="Undefined (division by zero)"
fi

# Display the results
echo "Arithmetic Operations:"
echo "Addition: $num1 + $num2 = $sum"
echo "Subtraction: $num1 - $num2 = $difference"
echo "Multiplication: $num1 * $num2 = $product"
echo "Division: $num1 / $num2 = $quotient"
echo "Modulus: $num1 % $num2 = $modulus"
