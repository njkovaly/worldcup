#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE TABLE teams CASCADE")"

while IFS=, read -r col1 col2 col3 col4 col5 col6
do
  if [[ $col1 != "year" ]]
  then
    echo "$($PSQL "INSERT INTO teams (name) VALUES ('$col3')")"
    echo "$($PSQL "INSERT INTO teams (name) VALUES ('$col4')")"  
  fi
done < games.csv

while IFS=, read -r col1 col2 col3 col4 col5 col6
do
  if [[ $col1 != "year" ]]
  then
    echo "$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES  ($col1, '$col2', \
     (SELECT team_id FROM TEAMS WHERE name = '$col3'), (SELECT team_id FROM teams WHERE name = '$col4'), $col5, $col6)")"
  fi
done < games.csv