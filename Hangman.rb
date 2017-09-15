require './GetBestWord.rb'
require './HttpConnect.rb'
class Hangman

	def initialize(url, playerId)
		@hangmanurl=url
		@hangmanplayerId=playerId
		@getBestWord = GetBestWord.new
		@httpConnect = HttpConnect.new(url, playerId)
	end

#check if the status is success or failed
	def checktheword(wordData)
		if wordData["wrongGuessCountOfCurrentWord"] >= 10
			return false #you failed when the guess time is greater than 10
		end
		wordDataList = wordData["word"].split(//) 
		wordDataList.each do |thisletter|
			if thisletter == "*" #if contains any "*", the loop should be continue
				return true
			end 
		end
#		@getBestWord.savetheword(word["word"])
		return false # else the loop should be breaked
	end
	def playthegame
		#startgame 
		startData = @httpConnect.startgame
		if startData == nil
			puts "failed to connect server with url " + @hangmanurl + "and playerId" + @hangmanplayerId
			return #return and raise error message while connect is failed
		end
# set sumbit flag as false
		submitResult = ""
		countTime = 0
		while submitResult != "Y" and countTime < 80 # guess the words until user want to stop and submit it
			word = @httpConnect.getaword #get a new word	
			if word["sessionId"] == nil
				puts "failed to connect server while get a new word"
				return #return and raise error message while connect is failed
			end
			puts "the game is start, the word is " + word["data"]["word"] + " now"
			@getBestWord.cleanwordbuffer #clean the cache
			lastWrongWord = nil
			lastCorrectWord = nil
			myWord = true
			while checktheword(word["data"]) and myWord # stop guess current word until user failed or success or give up
				lastWordData = word["data"] #save the last word to comapare
				myWord = @getBestWord.getbest(lastWordData["word"], lastWrongWord, lastCorrectWord) # guess the word with the last wrong word(to update the cache)
				if myWord != false #make a guess except didn't map any words in the dictionary
					word = @httpConnect.makeaguess(myWord) # make the guess
					if word["sessionId"] == nil
						puts "failed to connect server while have a guess"
						return #return and raise error message while connect is failed
					end
					wordData = word["data"]
					if wordData["word"] != lastWordData["word"] and wordData["wrongGuessCountOfCurrentWord"] == lastWordData["wrongGuessCountOfCurrentWord"]
						puts "the current words is " + wordData["word"]
						#guess a word successfully
						lastCorrectWord = myWord #get the correct word
						lastWrongWord = nil # clear the wrong word
					else
						puts "the letter " + myWord + " is wrong"
						lastCorrectWord = nil# clear the correct word
						lastWrongWord = myWord #get the wrong word
					end	
				end
			end

			result = @httpConnect.getresult #get the score after have a guess
			if result["sessionId"] == nil
				puts "failed to connect server while get the result"
				return #return and raise error message while connect is failed						
			end
			score = result["data"]
			countTime = score["totalWordCount"]
			puts "your current socre is : " + score["score"].to_s + "( count times: " + countTime.to_s + ")"
			submitResult = ""

			while submitResult != "Y" and submitResult != "N"
				puts "Do you want to submit your result?(Y/N)"
				submitResult = gets.chomp # get the submitresult
			end
		end
		if submitResult != "Y"
			puts "all the words has been guessed, do you want to submit your result?(Y/N)"
			submitResult = gets.chomp # get the submitresult
		end
		if submitResult == "Y"
			submitData = @httpConnect.submitresult
			if result["sessionId"] == nil
				puts "failed to connect server while sumbit the result"
				return #return and raise error message while connect is failed						
			else
				puts "sumbit successfully"
			end		
		end
	end
end

game = Hangman.new("https://strikingly-hangman.herokuapp.com/game/on", "icehuhu@foxmail.com")
game.playthegame
