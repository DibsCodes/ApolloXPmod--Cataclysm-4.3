-- function to change xp mod via sending a chat message
function xpmodder(x)
	if x == 1 then
		SendChatMessage(".mod xp 1")
	elseif x == 2 then
		SendChatMessage(".mod xp 2")
	else
		SendChatMessage(".mod xp 3")
	end
end



--slash command stuff
SLASH_PHRASE1 = "/xpmod";
SLASH_PHRASE2 = "/xp";

SlashCmdList["PHRASE"] = function(change)
	if change == "" then
		print("/xpmod xp [1-3] --selects xp rate. Persistent on login/logout")
		print("/xpmod level [x] -- sets level cap for xp rate. will revert to x3 after this level. If this is 0, this feature will be turned off. It is set to 0 by default")
		print("current xpmod is ",DibsApolloXPmod_rate," and your level cap is ",DibsApolloXPmod_lvl)
	elseif change.sub(change,1,2) == "xp" then
		local newxp = tonumber(change.sub(change,4,4 ))
		print("xp rate is updated to",newxp, ". It will remain at this rate by default, or until you reach your /xpmod level cap")
		DibsApolloXPmod_rate = newxp
		xpmodder(newxp)
	elseif change.sub(change,1,5) == "level" then
		print("level cap has been changed. Set to 0 to not use the level cap. This will update on /reload or relogging")
		local newlevel =  tonumber(change.sub(change,7,8 ))
		DibsApolloXPmod_lvl = newlevel
	else
		print("please enter a valid command. Type /xpmod to see the available commands")
	end
end


-- frame creation and event registration
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_LEVEL_UP")

--event handler...sloppy as fuck...I have no clue what I'm doing
f:SetScript("OnEvent", function(self,event,...) 
	
	
	if event == "PLAYER_LEVEL_UP" then
		if UnitLevel("player") >= DibsApolloXPmod_lvl - 1 then
			xpmodder(3)
		end
	end
	
	
	
	if event == "PLAYER_LOGIN" then
		-- this is just setting defaults upon logging in the first time with this addon enabled
		if DibsApolloXPmod_rate == nil then
			DibsApolloXPmod_rate = 3
		end
		
		if DibsApolloXPmod_lvl == nil then
			DibsApolloXPmod_lvl = 0
		end
		
		if DibsApolloXPmod_lvl == 0 then
			xpmodder(DibsApolloXPmod_rate)
		else
			if UnitLevel("player") >= DibsApolloXPmod_lvl then
				xpmodder(3)
			else
				xpmodder(DibsApolloXPmod_rate)
			end
		end

		
		
	end
end)
