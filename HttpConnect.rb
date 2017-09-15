require 'unirest'

class HttpConnect
   ACTION = "action"
   GUESS = "guess"

   STARTGAME = "startGame"
   NEXTWORD = "nextWord"
   GUESSWORD = "guessWord"
   GETRESULT = "getResult"
   SUBMITRESULT = "submitResult"

   def initialize(url, playerId)
      @httpurl=url
      @httpplayerId=playerId
   end
   def startgame
      response = Unirest.post @httpurl,headers:{ "Accept" => "application/json" },parameters:{ :"playerId" => @httpplayerId, :ACTION => STARTGAME }.to_json
      @sessionID = response.body["sessionId"]
      return response.body
   end
   def getaword
      response = Unirest.post @httpurl,headers:{ "Accept" => "application/json" },parameters:{ :"sessionId" => @sessionID, :ACTION => NEXTWORD }.to_json
      return response.body
   end
   def makeaguess(theletter)
      response = Unirest.post @httpurl,headers:{ "Accept" => "application/json" },parameters:{ :"sessionId" => @sessionID, :ACTION => GUESSWORD, :GUESS => theletter }.to_json
      return response.body
   end
   def getresult
      response = Unirest.post @httpurl,headers:{ "Accept" => "application/json" },parameters:{ :"sessionId" => @sessionID, :ACTION => GETRESULT }.to_json
      return response.body
   end
   def submitresult
      response = Unirest.post @httpurl,headers:{ "Accept" => "application/json" },parameters:{ :"sessionId" => @sessionID, :ACTION => SUBMITRESULT }.to_json
      return response.body
   end
end
