#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# generate secret number
SECRET=500

# collect username
echo -e "Enter your username:"
read USERNAME

# query for username
USER_EXIST=$($PSQL "select username from users where username='$USERNAME'")

# check if user exists
if [[ -z $USER_EXIST ]]
then
  # create user if does not exist
  CREATE_USER=$($PSQL "insert into users(username, games_played, best_game) values('$USERNAME',0,0)")
  echo -e "Welcome, $USERNAME! It looks like this is your first time here."
  GAMES_PLAYED=$($PSQL "select games_played from users where username='$USERNAME'")
  BEST_GAME=$($PSQL "select best_game from users where username='$USERNAME'")
else
  # query info on existing user
  GAMES_PLAYED=$($PSQL "select games_played from users where username='$USERNAME'")
  BEST_GAME=$($PSQL "select best_game from users where username='$USERNAME'")
  # welcome existing user
  echo -e "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# guess number
echo -e "Guess the secret number between 1 and 1000:"
GUESS_COUNT=0
USER_GUESS=''
while [[ $USER_GUESS -ne $SECRET ]]
do
  # collect guess
  read USER_GUESS

  # increment guess count
  ((GUESS_COUNT++))

  # check if guess is number
  if [[ $USER_GUESS =~ ^-?[0-9]+$ ]]
  then
    # evaluate guess and guide user to correct guess
    if [[ $USER_GUESS -gt $SECRET ]]
    then
      echo -e "It's lower than that, guess again:"
    elif [[ $USER_GUESS -lt $SECRET ]]
    then
      echo -e "It's higher than that, guess again:"
    fi
  else
    # non integer is guessed
    echo -e "That is not an integer, guess again:"
  fi
done

# secret number was found
echo -e "You guessed it in $GUESS_COUNT tries. The secret number was $SECRET. Nice job!"

# check if old best guess is higher than current game
if [[ $BEST_GAME -eq 0 || $BEST_GAME -gt $GUESS_COUNT ]]
then
  UPDATE_BEST_GAME=$($PSQL "update users set best_game=$GUESS_COUNT where username='$USERNAME'")
fi

# update games played
((GAMES_PLAYED++))
UPDATE_GAMES_PLAYED=$($PSQL "update users set games_played=$GAMES_PLAYED where username='$USERNAME'")






