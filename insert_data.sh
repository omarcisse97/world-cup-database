#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE games, teams" )"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
    then
     WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'" )
     if [[ -z $WINNER_ID ]]
      then
        WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        if [[ $WINNER_RESULT == "INSERT 0 1" ]]
          then
            echo Successfully added team $WINNER to the database
        fi
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'" )
     fi
     OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
     if [[ -z $OPPONENT_ID ]]
      then
        OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ $OPPONENT_RESULT == "INSERT 0 1" ]]
          then
            echo Successfully added team $OPPONENT to the database
        fi
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
     fi
     GAMES_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
     if [[ $GAMES_RESULT == "INSERT 0 1" ]]
      then
        echo  "Successfully added game  occured in $YEAR round $ROUND against $WINNER VS $OPPONENT"
    fi
  fi
done
