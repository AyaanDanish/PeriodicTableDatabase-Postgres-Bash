#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ ! $1 ]] 
then
  echo Please provide an element as an argument.
else
  if [[ $1 =~ [0-9]+ ]] 
  then
    ATOMIC_NUM=$($PSQL "select atomic_number from elements where atomic_number = $1")
  else
    ATOMIC_NUM=$($PSQL "select atomic_number from elements where symbol = '$1' or name = '$1';")
  fi
  if [[ -z $ATOMIC_NUM ]]
  then
    echo "I could not find that element in the database."
  else
    ELEMENT_PROPS="$($PSQL "select atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) where atomic_number = $ATOMIC_NUM")"
    echo $ELEMENT_PROPS | while IFS="|" read ATOMIC_NUM SYMBOL NAME TYPE MASS MELTING BOILING
    do
      echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
fi
