#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games,teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != year && $ROUND != round && $WINNER != winner && $OPPONENT != opponent && $WINNER_GOALS != winner_goals && $OPPONENT_GOALS != opponent_goals ]]
then
#GET WINNER TEAM ID
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
#IF NOT FOUND
if [[ -z $WINNER_ID ]]
then
  #INSERT TEAM
  INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
  if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
then
  echo "Inserted into teams, $WINNER"
fi
  #GET NEW TEAM 
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
fi
#GET OPPONENT TEAM ID
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
#IF NOT FOUND
if [[ -z $OPPONENT_ID ]]
then
  #INSERT TEAM
  INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
  if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
then
  echo "Inserted into teams, $OPPONENT"
fi
  #GET NEW TEAM 
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi
  #insert games
  INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
then
  echo "Inserted into teams, $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS"
fi
  
fi
done