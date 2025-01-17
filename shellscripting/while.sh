#!/bin/bash

i=1
while [ $i -le 5 ]  # Condition: loop while i <= 5
do
    echo "Counting: $i"
    ((i++))  # Increment i
done

