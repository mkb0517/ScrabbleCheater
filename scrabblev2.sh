#!/bin/bash
# scrabble cheating program
# feed it your tiles and get the list of words you can use
cheat() {
  local tiles="$1"
  local combs="$2"
  local i
  [[ "$tiles" == "" ]] && echo "$combs" && return
  for (( i=0; i<${#tiles}; i++ ))
    do
    if test ${#combs} -ne 1
    then
      echo $combs
    fi
    cheat "${tiles:0:i}${tiles:i+1}" "$combs${tiles:i:1}"
    done
}

if [ ! -f Scrabble.txt ]
then
  echo "" > Scrabble.txt
fi
echo Please enter the tiles you have
read line
while [ ${#line} -gt 7 ]
do
    echo "You may only have 7 tiles. Enter your rack:"
    read line
done

hasQ=0
for (( i=0; i<${#line}; i++ ))
do
  if [ "${line:i:1}" = \? ]
  then
    hasQ=1
    if [ "${line:i:1}" = \? ]
    then
      for (( j=97; j<123; j++ ))
      do
        c=`printf "\x$(printf %x $j)"`
        cheat ${line/\?/$c} >> Scrabble.txt
      done
    else
    for (( j=97; j<123; j++ ))
    do
      c=`printf "\x$(printf %x $j)"`
      cheat ${line/\?/$c} >> Scrabble.txt
    done
    fi
  fi
done
if [ $hasQ -eq 0 ]
then
  cheat $line >> Scrabble.txt
fi

cat Scrabble.txt | tr ' ' '\n' | sort | uniq > checkrack.txt
echo The legal words you can make are:
comm -12 checkrack.txt scrabble.dict
