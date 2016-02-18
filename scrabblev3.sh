#!/bin/bash
# scrabble cheating program
# feed it your tiles and get the list of words you can use
cheat() {
  local tiles="$1"
  local combs="$2"
  local slen="$3"
  local sub="$4"
  local i
  local offset
  if test $slen -gt 0
  then
    offset=1
  else
    offset=0
  fi
  [[ "$tiles" == "" ]] && echo "$combs" && return
  for (( i=0; i<${#tiles}+$offset; i++ ))
    do
    if test ${#combs} -ne 1
    then
      echo $combs
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

echo Please enter the tiles you have
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

hasQ=0
for (( i=0; i<${#line}; i++ ))
do
  if [ "${line:i:1}" = \? ]
  then
    hasQ=1
    for (( j=97; j<123; j++ ))
    do
      c=`printf "\x$(printf %x $j)"`
      rack=${line/\?/$c}
      for (( k=0; k<${#rack}; k++ ))
      do
        if [ "${rack:k:1}" = \? ]
        then
          for (( l=97; l<123; l++ ))
          do
            d=`printf "\x$(printf %x $l)"`
            cheat "${rack/\?/$d}" "" "$slen" "$sub" >> Scrabble.txt
          done
        fi
      done
      cheat "${line/\?/$c}" "" "$slen" "$sub" >> Scrabble.txt
    done
  fi
done
if [ $hasQ -eq 0 ]
then
  cheat $line "" $slen $sub >> Scrabble.txt
fi

cat Scrabble.txt | tr ' ' '\n' | sort | uniq > checkrack.txt
echo The legal words you can make are:
comm -12 checkrack.txt scrabble.dict
