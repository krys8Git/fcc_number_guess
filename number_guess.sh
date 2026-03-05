#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# collect username
echo -e "Enter your username:"
read USERNAME

# query for username
USER_EXIST=$($PSQL "select username from users where username='$USERNAME'")

# check if user exists
if [[ -z $USER_EXIST ]]
then
  # create user if does not exist
  $($PSQL "insert into users(username) values('$USERNAME')")
  echo -e "Welcome, $USERNAME! It looks like this is your first time here."
else
  # query info on existing user
  GAMES_PLAYED=$($PSQL "select games_played from users where username=$USERNAME")
  BEST_GAME=$($PSQL "select best_game from users where username=$USERNAME")
  # welcome existing user
  echo -e "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# generate secret number
SECRET=

# guess number
echo -e "Guess the secret number between 1 and 1000:"
GUESS_COUNT=0
while $USER_GUESS != $SECRET
do
  # collect guess
  read USER_GUESS

  # check if guess is number
  IS_NUMBER=$(echo $USER_GUESS | grep -E "^[0-9]+$")
  if [[ -z $IS_NUMBER ]]
  then
    # increment guess count
    GUESS_COUNT=$GUESS_COUNT+1

    # evaluate guess and guide user to correct guess
    if [[ $USER_GUESS >= $SECRET ]]
    then

    else if [[ $USER_GUESS <= $SECRET ]]
      
    fi
  else
    # non integer is guessed
    echo -e "That is not an integer, guess again:"
  fi
done

# secret number was found
echo -e "You guessed it in $GUESS_COUNT tries. The secret number was $SECRET. Nice job!"

# add stats into database
ADD_STATS=$($PSQL "")

