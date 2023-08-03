#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ ! $1 ]] 
then
  echo Please provide an element as an argument.
else
  ATOMIC_NUM=$($PSQL "select atomic_number from elements where atomic_number = $1 or symbol = '$1' or name = '$1';")
  if [[ -z $ATOMIC_NUM ]]
  then
    echo "I could not find that element in the database."
  else
    ELEMENT_PROPS=$($PSQL "select atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) where atomic_number=1;")
    echo $ELEMENT_PROPS | while read ATOMIC_NUM BAR SYMBOL BAR NAME BAR TYPE BAR MASS BAR MELTING BAR BOILING
    do
      echo $ATOMIC_NUM $SYMBOL $NAME $TYPE $MASS $MELTING $BOILING 
    done
  fi
fi
