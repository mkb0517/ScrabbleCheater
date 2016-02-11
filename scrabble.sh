#!/bin/bash
# scrabble cheating program!
# feed it your tiles and get a list of words you can use!
cheat() {
  local tiles="$1"    # The string of tiles you want to permute.
  local combs="$2"    # Every single permutation. Every. One.
  local i             # index of the tiles to include in permutation.
  [[ "$tiles" == "" ]] && echo "$combs" && return
  for (( i=0; i<${#tiles}; i++ ))
    do
      cheat "${tiles:0:i}${tiles:i+1}" "$combs${tiles:i:1}"
    done
}
echo Please enter your tiles all at once
read line
cheat $line

# Currently only generates permutations equal to the number of tiles you enter
