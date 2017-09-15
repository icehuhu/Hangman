class GetBestWord
	TXTNAME = "./dictionary.txt"
	def initialize
		@dictionary = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
		@matchedList = []
		@wrongWordList = []
		#read word dictionary
		IO.foreach(TXTNAME) do |block| 
			temp = block.chomp
			len = temp.length
			@dictionary[len].push(temp)
		end
	end
	def cleanwordbuffer
		@matchedList = []
		@wrongWordList = []		
	end
	def matchcorrectword(thisword, reg, correctword)
		i = 0
		regList = reg.split(//)
		regList.each do |thisletter|
			if thisletter == "." 
				reg[i] = correctword # add the correct word in any unknown position
				if thisword.match(reg) # match the reg again
					reg[i] = "."
					return false # if matched, which mean the word is not our required
				end	
				reg[i] = "."
			end	
			i = i + 1
		end
		return true
	end
	def getbest(word, wrongword, correctword)
		#if matched word is initial, append with word in txt
		if @matchedList == []
			@matchedList = @dictionary[word.length]
			@matchedList.uniq!
		end
		#init weight
		@weight = Hash.new 
		@weight.default = nil
		#replaced * with . to match Regexp
		reg = word.gsub("*",".")
		#collect the matched word
		@matchedNewList = []
		@matchedList.each do |thisword|
			#1. match the reg. 
			#2. doesn't include the wrongword 
			#3. exist no correctword in any unkown position(such as HAPPY to "...P.")
			if thisword.match(reg) and (wrongword == nil or !thisword.include?(wrongword)) and (correctword == nil or matchcorrectword(thisword, reg, correctword))
				#Add the matched word into new matched list
				@matchedNewList.push(thisword)
				#Get all letters exist in this word
				letterList = thisword.split(//)
				#delete duplicate one for weight calculation
				letterList.uniq!

				letterList.each do |thisletter|
					#add new or +1
					if @weight[thisletter] == nil
						@weight[thisletter] = 1
					else
						@weight[thisletter] = @weight[thisletter] + 1
					end	
				end
			end
		end
		@matchedList = @matchedNewList
		#Get all letters already guessed in this word
		@wrongWordList = word.split(//)
		##add the wrong word guessed before
		#@wrongWordList.push(wrongword)
		#delete duplicate letter
		@wrongWordList.uniq!
		#clear weight for each wrong letter
		@wrongWordList.each do |wrongletter|
			@weight[wrongletter] = 0;
		end


		max = 0
		bestLetter = ""
		i = 0
		#find the best letter and return according to the weight
		@weight.each do |thisletter, num|
			if num > 0 
				i = i + 1
			end	
			if num > max
				max = num
				bestLetter = thisletter
			end
		end

		if bestLetter == ""
			return false #failed to find any matched words, just skip and get next word
		else
			return bestLetter
		end

	end

end