#!/bin/bash
# scrabble cheating program
# feed it your tiles and get the list of words you can use
cheat() {
# declares variables tiles and combs and i
# local, I would assume part of the function cheat()
  local tiles="$1"
  local combs="$2"
  local i
  [[ "$tiles" == "" ]] && echo "$combs" && return
# index i iterates through a list until it reaches number of tiles, in this case $1
  for (( i=0; i<${#tiles}; i++ ))
    do
# checks if number of combinations are true, in this case $2
    if test ${#combs} -ne 1
    then
# output combination
      echo $combs
    fi
    cheat "${tiles:0:i}${tiles:i+1}" "$combs${tiles:i:1}"
    done
}

# checks if file Scrabble.txt is an ordinary file 
if [ ! -f Scrabble.txt ]
then
# writes to Scrabble.txt
  echo "" > Scrabble.txt
fi

# start of program, asks user to input tiles
echo Please enter the tiles you have

# reads user input
read line

# runs while loop to check if user entered more than 7 tiles
while [ ${#line} -gt 7 ]
do
# output of error message
    echo "You may only have 7 tiles. Enter your rack:"
# read user input again
    read line
done

hasQ=0
for (( i=0; i<${#line}; i++ ))
do
# condition:
  if [ "${line:i:1}" = \? ]
  then
    hasQ=1
# condition:
    if [ "${line:i:1}" = \? ]
    then
      for (( j=97; j<123; j++ ))
      do
        c=`printf "\x$(printf %x $j)"`
        cheat ${line/\?/$c} >> Scrabble.txt
      done

# condition:
    else
    for (( j=97; j<123; j++ ))
    do
      c=`printf "\x$(printf %x $j)"`
      cheat ${line/\?/$c} >> Scrabble.txt
    done
    fi
  fi
done

# reads variable $line of function cheat to Scrabble.txt file if $hasQ == 0 
if [ $hasQ -eq 0 ]
then
  cheat $line >> Scrabble.txt
fi

cat Scrabble.txt | tr ' ' '\n' | sort | uniq > checkrack.txt
echo The legal words you can make are:
comm -12 checkrack.txt scrabble.dict
