PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ "$1" =~ ^[0-9]+$ ]]
  then
    GET_ELEMENT=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius 
                  FROM properties 
                  INNER JOIN elements USING (atomic_number)
                  INNER JOIN types ON properties.type_id=types.type_id
                  WHERE atomic_number=$1")
  else
    GET_ELEMENT=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius 
                  FROM properties 
                  INNER JOIN elements USING (atomic_number)
                  INNER JOIN types ON properties.type_id=types.type_id
                  WHERE symbol='$1' OR name='$1'")
  fi
  if [[ -z $GET_ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$GET_ELEMENT" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi