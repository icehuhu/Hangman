# 1.How to Play
* Run Hangman.rb to start the game, the program will play the game automatically.
* Keep all the rb file and dictionary.txt in the same path
* After every words has been guessed or all 80 words has been finished, the system will ask you if you want to sumbit your score.
* Submit your score if you want.
* After submit, you can also continue playing the game.
* After all 80 words has been finished, the program will be finished.
* You can add any words in dictionary.txt if you want

# 2.Basic Info.
* Used ruby as language.
* Used 'unirest' package to make HTTP Connect more convinient.

# 3.Preparations of Dictionary
* Downlaod some thesaurus and do ETL with a java program

# 4.Guessing Strategy（Algorithm）
1. Sort the words in dictionary.txt by length and put it into different arrays(2-dimensional array)
2. For all the words which meet the required, calculate the number of occurrences of each letter( For a letter in a word, whether the letter appears how many times, we are counted it as 1
3. If the max number is not 0, guess the max one. letter. Else, skip this word
4. Filter the dictionary words According to the response:
  - If the letter is wrong, then delete all the words which contains this letter from array
  - If the letter is true, then delete all the words which cannot match the response(which convert to regular expression). And delete all the words which contains this letter in any other unknown position( For example, if the response is \*\*\*P\*, the word HAPPY should be filtered.)

# 5.About Others Ideas
1. Run many times and correct the weight of words according to the appreared time
2. When it remain many possible words, and the number of occurrences is scattered, skip this word according to the remaining guessable times?
