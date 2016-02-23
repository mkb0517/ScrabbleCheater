#!/bin/bash
# scrabble cheating program
# feed it your tiles and get the list of words you can use

# Declare local variables for the question mark check
local i
local j
local k
local l
local c
local d

cheat() {
  # assign variables to the local working directory of the user to speed up calculations significantly
  local tiles="$1"        # variable to store the user input
  local combs="$2"        # variable to store the permutations of letters from the user input
  local slen="$3"         # length of substring for tiles on the board
  local sub="$4"          # value of substring of tiles on the board
  local i                 # local index i to speed up loops
  local offset            # local offset variable to change the length of the permutations with substrings
  if test $slen -gt 0     # check if the user has input substrings of tiles from the board
  then
    offset=1              
  else
    offset=0
  fi
  
  # main loop of cheat that checks the tiles remaining for the permutations
  [[ "$tiles" == "" ]] && echo "$combs" && return
  # goes through each letter provided by the user to make permutations
  for (( i=0; i<${#tiles}+$offset; i++ ))
    do
    if test ${#combs} -ne 1    # test to make sure we are only getting combinations of 2 or greater
    then
      echo $combs              # write the combination to a file
    fi
    if test $slen -eq 0
    then
      cheat "${tiles:0:i}${tiles:i+1}" "$combs${tiles:i:1}" "$slen" "$sub"
    else
      if test $i -eq ${#tiles}
      then
        cheat "${tiles:0:i-1}${tiles:i}" "$combs$sub" "0" ""
      else
        cheat "${tiles:0:i}${tiles:i+1}" "$combs${tiles:i:1}" "$slen" "$sub"
        cheat "${tiles:0:i}${tiles:i+1}" "$sub$combs${tiles:i:1}" "0" ""
      fi
    fi
    done
}

# clear the Scrabble.txt file
echo "" > Scrabble.txt

# Tell the user to input their tiles
echo "Please enter the tiles you have. Use \? for blank tiles"
# Get the tile input from the user
read line
while [ ${#line} -gt 7 ]
do
    echo "You may only have 7 tiles. Enter your rack:"
    read line
done

echo "Enter up to three tiles that are in sequence on the board:"
read sub
while [ ${#sub} -gt 3 ]
do
    echo "Only up to three:"
    read sub
done

#Get length of substring that needs shifting
slen="${#sub}"

# create a variable to check if there are question marks in the string
local hasQ=0
local has2Q=0
# look through the string to find question marks
for (( i=0; i<${#line}; i++ ))
do
  # check the string at index i for it's character value. 
  # Translates to: Take the value of line at position i for 1 character and see if it's equal to ?
  if [ "${line:i:1}" = \? ]
  then
    # set the boolean to true if it has a ?
    hasQ=1
    # Replace the ? with a character value from a to z. 97 is decimal of 'a', 123 is decimal of 'z'.
    for (( j=97; j<123; j++ ))
    do
      # Take the value of the index and convert it to hex, then convert it to a character. printf uses hex.
      c=`printf "\x$(printf %x $j)"`
      # temporarily replace the ? with the converted character and store it in rack for a second check.
      rack=${line/\?/$c}
      # Repeat the check for a ? in the string. If there is a second ?, repeat the replacement for the second ?.
      for (( k=0; k<${#rack}; k++ ))
      do
        # check the string for a ? at the index 
        if [ "${rack:k:1}" = \? ]
        then
          has2Q=1
          # Repeat the character replacement for a ?
          for (( l=97; l<123; l++ ))
          do
            d=`printf "\x$(printf %x $l)"`
            # call the cheat function for our modified rack of tiles that had 2 ?. Append the permutations to Scrabble.txt
            cheat "${rack/\?/$d}" "" "$slen" "$sub" >> Scrabble.txt
          done
        fi
      done
      if [ $has2Q -eq 0 ]
      then
        # Call the cheat function for our modified rack of tiles that had 1 ?. Append the permutations to Scrabble.txt
        cheat "${line/\?/$c}" "" "$slen" "$sub" >> Scrabble.txt
      fi
    done
  fi
done
# If there were no ? in the string, call the permutation function normally.
if [ $hasQ -eq 0 ]
then
  cheat $line "" $slen $sub >> Scrabble.txt
fi

cat Scrabble.txt | tr ' ' '\n' | sort | uniq > checkrack.txt
echo The legal words you can make are:
comm -12 checkrack.txt scrabble.dict
