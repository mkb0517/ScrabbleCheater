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
echo Please enter the tiles you have
read line
cheat $line > Scrabble.txt

cat Scrabble.txt | tr ' ' '\n' | sort | uniq > checkrack.txt
echo The legal words you can make are:
comm -12 checkrack.txt scrabble.dict
