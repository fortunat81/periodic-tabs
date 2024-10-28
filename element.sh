PSQL="psql -U freecodecamp -d periodic_table -t -c"
#check if argument is missing 
if [[ -z $1 ]] 
then
echo Please provide an element as an argument.
else
#check if argument is a number
if [[ $1 =~ ^[0-9]+$ ]]
then
#check if argument is element atomic number
ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1;")
else
#check if argument is element name
ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1';")
#check if atomic number is empty
if [[ -z $ATOMIC_NUMBER ]]
then
#check if argument is element symbol
ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1';") 
fi
fi
#check if element was found
if [[ -z $ATOMIC_NUMBER ]]
then
echo I could not find that element in the database.
else
#get element properties
NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER;")
SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER;")
TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) INNER JOIN elements USING(atomic_number) WHERE atomic_number=$ATOMIC_NUMBER;")
MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
MESSAGE="The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a nonmetal, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
echo $MESSAGE | sed 's/( /(/'
fi
fi