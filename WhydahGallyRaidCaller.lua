function WhydahGallyRaidCaller_Load()
	wgrc_version = "0.1"
	DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller v"..wgrc_version.." by Ildyria loaded.", 0, 1, 0)
	if not wgrc then
		WhydahGallyRaidCaller_Reset()
	else
		if wgrc.self == nil then wgrc.self = false end
		if wgrc.debug == nil then wgrc.debug = false end
		if wgrc.append == nil then wgrc.append = "" end
		if wgrc.always == nil then wgrc.always = false end
		if wgrc.ignore == nil then wgrc.ignore = {} end
		if wgrc.debug == nil then WhydahGallyRaidCaller_Debug() end
		if wgrc.prefix == nil then wgrc.prefix = "(WhydahGallyRaidCaller) " end
		if wgrc.nospam == nil then wgrc.nospam = true end
		if wgrc.public == nil then wgrc.public = false end
	end
	linked = {}
end

function WhydahGallyRaidCaller_DebugChat(chat_msg)
	local f = LibConsoleFrame
	local COLOUR = {
	RED     = "|cffff0000",
	GREEN   = "|cff10ff10",
	BLUE    = "|cff0000ff",
	MAGENTA = "|cffff00ff",
	YELLOW  = "|cffffff00",
	ORANGE  = "|cffff9c00",
	CYAN    = "|cff00ffff",
	WHITE   = "|cffffffff",
	SILVER  = "|ca0a0a0a0",
	}
	if wgrc.debug then 
		f:AddMessage(COLOUR.CYAN .. "[" .. COLOUR.GREEN .. date("%H:%M:%S") .. COLOUR.CYAN .. "] ".. COLOUR.SILVER .."WhydahGallyRaidCaller DEBUG: "..chat_msg, 0, 1, 0);
	end
end

-- function WhydahGallyRaidCaller_RespondChat(chat_msg, chat_requestor)
-- 	WhydahGallyRaidCaller_DebugChat("DEBUG: requestor: "..chat_requestor)
-- 	WhydahGallyRaidCaller_DebugChat("DEBUG: chat msg: "..chat_msg)
-- 	SendChatMessage(chat_msg, "WHISPER", nil, chat_requestor)
-- 	return
-- end

function WhydahGallyRaidCaller_Reset()
	DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller v"..wgrc_version.." by Ildyria reseted.", 0, 1, 0)
	wgrc = {
		enabled = true,
		self = false,
		always = false,
		debug = false,
		ignore = {},
		prefix = "(WhydahGallyRaidCaller) ",
		nospam = true,
		append = "Pour 10 po tres certainement.",
	}
end

function WhydahGallyRaidCaller_Debug()
	WhydahGallyRaidCaller_DebugChat("------- DEBUG -------")
	WhydahGallyRaidCaller_DebugChat("value of self: " .. tostring(wgrc.self))
	WhydahGallyRaidCaller_DebugChat("value of nospam: " .. tostring(wgrc.nospam))
	WhydahGallyRaidCaller_DebugChat("prefix: " .. tostring( wgrc.prefix))
	WhydahGallyRaidCaller_DebugChat("message: " .. tostring( wgrc.append))
	for name,status in pairs(wgrc.ignore) do
		WhydahGallyRaidCaller_DebugChat("Ignore list entry: " .. tostring( name))
	end
end

function WhydahGallyRaidCaller_List()
	WhydahGallyRaidCaller_DebugChat("WhydahGallyRaidCaller DEBUG: Compiling monitored/ignored channel lists.")
	DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller v"..ap_version.." by Ildyria.", 0, 1, 0)
	DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller channel monitoring status:", 0, 1, 0)
	channels_monitored = ""
	channels_ignored = ""
	if wgrc.self then
		channels_monitored = channels_monitored .. "|cFFFFFFFFself|r "
	else
		channels_ignored = channels_ignored .. "|cFFFFFFFFself|r "
	end
	if not wgrc.always then
		channels_monitored = channels_monitored .. "|cFFFFFFFFafk/dnd_status|r "
	else
		channels_ignored = channels_ignored .. "|cFFFFFFFFafk/dns_status|r "
	end
	if channels_monitored == "" then
		channels_monitored = "|cFFFFFFFFNone|r"
	end
	if channels_ignored == "" then
		channels_ignored = "|cFFFFFFFFNone|r"
	end
	DEFAULT_CHAT_FRAME:AddMessage("  |cFF0000FFMonitoring|r: " .. channels_monitored, 0, 1, 0)
	DEFAULT_CHAT_FRAME:AddMessage("  |cFFFF0000Ignoring|r: " .. channels_ignored, 0, 1, 0)
	if wgrc.prefix ~= "" then
		DEFAULT_CHAT_FRAME:AddMessage("  |cFFFFFF00Prefix|r: " .."|cFFFFFFFF".. wgrc.prefix .. "|r", 0, 1, 0)
	end
	if wgrc.append ~= "" then
		DEFAULT_CHAT_FRAME:AddMessage("  |cFFFFFF00Message|r: " .."|cFFFFFFFF".. wgrc.append.."|r", 0, 1, 0)
	end
	if wgrc.nospam then
		DEFAULT_CHAT_FRAME:AddMessage("  |cFFFFFF00Anti-Spam|r: " .."|cFFFFFFFFOn|r", 0, 1, 0)
	else
		DEFAULT_CHAT_FRAME:AddMessage("  |cFFFFFF00Anti-Spam|r: " .."|cFFFFFFFFOff|r", 0, 1, 0)
	end
end

function WhydahGallyRaidCaller_GetCmd(msg)
 	if msg then
 		local a,b,c=strfind(msg, "(%S+)"); 
 		if a then
 			return c, strsub(msg, b+2)
 		else	
 			return ""
 		end
 	end
end

function WhydahGallyRaidCaller_GetArgument(msg)
 	if msg then
 		local a,b=strfind(msg, "=")
 		if a then
 			return strsub(msg,1,a-1), strsub(msg, b+1)
 		else	
 			return ""
 		end
 	end
end

function WhydahGallyRaidCaller_SlashCmdHandler(slashcmd)
	local maincmd, subcmd = WhydahGallyRaidCaller_GetCmd(slashcmd)
	cmd = strlower(maincmd)														-- passe maincmd en small case
	WhydahGallyRaidCaller_DebugChat("WhydahGallyRaidCaller DEBUG: Processing commands: ["..cmd.. "], ["..subcmd.."]")
	if InCombatLockdown() then  -- InCombatLockdown() fctn de l'API WOW
		DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller - Not operable during combat.", 0, 1, 0)
		return
	elseif (cmd == "enable" or cmd == "on") then
		if wgrc.enabled then
			DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller is already enabled.", 0, 1, 0)
		else
			DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller is now enabled.", 0, 1, 0)
			wgrc.enabled = true
		end
	elseif not wgrc.enabled then
		DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller is disabled, no other commands are possible.", 0, 1, 0)
		return
	elseif (cmd == "disable" or cmd == "off") then
		if not wgrc.enabled then
			DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller is already disabled.", 0, 1, 0)
		else
			DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller is now disabled.", 0, 1, 0)
			wgrc.enabled = false
		end
	elseif (cmd == "self" or cmd == "me") then
		if wgrc.self then
			DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller will now ignore your own chat.", 0, 1, 0)
			wgrc.self = false
		else
			DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller will now respond to your own chat.", 0, 1, 0)
			wgrc.self = true
		end
	elseif cmd == "nospam" then
		if wgrc.nospam then
			DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller now doesn't care about spamming, use at your own risk :)", 0, 1, 0)
			wgrc.nospam = false
		else
			DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller will now ban people for 1 minute to prevent spamming, and only send tells for Trade/Generwgrc.", 0, 1, 0)
			wgrc.nospam = true
		end
	elseif cmd == "always" then
		if wgrc.always then
			DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller will now only work if you are not AFK/DND.", 0, 1, 0)
			wgrc.always = false
		else
			DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller will now continue to work even if you are AFK/DND.", 0, 1, 0)
			wgrc.always = true
		end
	elseif cmd == "list" then
		WhydahGallyRaidCaller_List()
	elseif cmd == "send" then
		SendChatMessage("BANDES DE LAVETTES ! (don't take it personnaly babe. :P", "WHISPER", nil, "titi6666")
		-- SendChatMessage("BANDES DE LAVETTES ! (don't take it personnaly babe. :P", "WHISPER", nil, "NAME-SERVEUR")
--		SendChatMessage("BANDES DE LAVETTES ! (don't take it personnaly. :P", "GUILD", nil, "Suirilen")
	elseif (cmd == "reset" or cmd == "default") then
		WhydahGallyRaidCaller_Reset()
		DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller settings have been reset to defaults.", 0, 1, 0)
	elseif cmd == "prefix" then
		if (subcmd == "" or subcmd == nil) then
			DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller has cleared any prefix message.", 0, 1, 0)
			wgrc.prefix = "(WhydahGallyRaidCaller) "
			return
		end
		wgrc.prefix = subcmd
		DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller will now prefix your messages with: ".. wgrc.prefix, 0, 1, 0)
	elseif (cmd == "message" or cmd == "append") then
		if (subcmd == "" or subcmd == nil) then
			DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller has cleared any custom message.", 0, 1, 0)
			wgrc.append = "Pour 10 po tres certainement."
			return
		end
		wgrc.append = subcmd
		DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller will now append your custom message: ".. wgrc.append, 0, 1, 0)
	elseif cmd == "ignore" then
		if (subcmd == "" or subcmd == nil) then
			DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller Ignore list:", 0, 1, 0)
			for name,status in pairs(wgrc.ignore) do
				DEFAULT_CHAT_FRAME:AddMessage("    "..name, 0, 1, 0)
			end
			return
		end
		local name = strtrim(subcmd)
		name = string.lower(subcmd)
		name = string.gsub(name, "^%l", string.upper)
		if wgrc.ignore[name] == nil then
			DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller will now ignore '"..name.."'.", 0, 1, 0)
			wgrc.ignore[name] = true
		else
			DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller will stopping ignoring '"..name.."'.", 0, 1, 0)
			wgrc.ignore[name] = nil
		end
	elseif cmd == "debug" then
		if wgrc.debug then
			DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller will no longer show debugging messages.", 0, 1, 0)
			wgrc.debug = false
		else
			DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller will now show debugging messages. (libconsole requis et ouvert)", 0, 1, 0)
			wgrc.debug = true
			WhydahGallyRaidCaller_Debug()
		end
	else
		WhydahGallyRaidCaller_SlashCmdList()
	end
end

function WhydahGallyRaidCaller_SlashCmdList()
	if wgrc.enabled then
		DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller is |cFF0000FFenabled|r.  Supported commands:", 0, 1, 0)
	else
		DEFAULT_CHAT_FRAME:AddMessage("WhydahGallyRaidCaller is |cFFFF0000disabled|r.  Supported commands:", 0, 1, 0)
		DEFAULT_CHAT_FRAME:AddMessage("  |cFFFFFFFFenable|r - enable WhydahGallyRaidCaller", 0, 1, 0)
		return
	end
	DEFAULT_CHAT_FRAME:AddMessage("  |cFFFFFFFFdisable|r - disable WhydahGallyRaidCaller", 0, 1, 0)
	DEFAULT_CHAT_FRAME:AddMessage("  |cFFFFFFFFlist|r - list status of channel monitoring, linking, and other options.", 0, 1, 0)
	DEFAULT_CHAT_FRAME:AddMessage("  |cFFFFFFFFself|r - toggle responding to your own messages.", 0, 1, 0)
	DEFAULT_CHAT_FRAME:AddMessage("  |cFFFFFFFFprefix <message>|r - Prefix message to all wisp (Default: (WhydahGallyRaidCaller).", 0, 1, 0)
	DEFAULT_CHAT_FRAME:AddMessage("  |cFFFFFFFFmessage <message>|r - Append a custom message to all wisp.", 0, 1, 0)
	DEFAULT_CHAT_FRAME:AddMessage("  |cFFFFFFFFalways|r - toggle responding during AFK/DND.", 0, 1, 0)
	DEFAULT_CHAT_FRAME:AddMessage("  |cFFFFFFFFignore <name>|r - add/remove a name from the WhydahGallyRaidCaller ignore list.", 0, 1, 0)
	DEFAULT_CHAT_FRAME:AddMessage("  |cFFFFFFFFnospam|r - toggle  anti-spam (1 min ban to each person) or allowing people to trigger you endlessles (careful)", 0, 1, 0)
	DEFAULT_CHAT_FRAME:AddMessage("  |cFFFFFFFFreset|r - reset all settings to default.", 0, 1, 0)
end

SLASH_WhydahGallyRaidCaller1 = "/WGRC"
SLASH_WhydahGallyRaidCaller2 = "/wgrc"
SLASH_WhydahGallyRaidCaller3 = "/wg"
SlashCmdList["WhydahGallyRaidCaller"] = WhydahGallyRaidCaller_SlashCmdHandler

-- function WhydahGallyRaidCaller_ClearRecent()
-- 	local hour,min = GetGameTime()	-- Check if author has asked this minute
-- 	for name,min_sent in pairs(linked) do
-- 		if not min_sent == min then
-- 			name = nil
-- 		end
-- 	end
-- end

-- function WhydahGallyRaidCaller(message, author, report_on_error)
-- 	WhydahGallyRaidCaller_DebugChat("--------------------------------------")
-- 	if (author == UnitName("player") and not wgrc.self) then
-- 		WhydahGallyRaidCaller_DebugChat("WhydahGallyRaidCaller DEBUG: Ignoring messages from you by request.")
-- 		return 
-- 	end
-- 	if UnitIsAFK("player") then
-- 		if not wgrc.always then
-- 			WhydahGallyRaidCaller_DebugChat("WhydahGallyRaidCaller DEBUG: You are AFK, clear your status to enable WhydahGallyRaidCaller.")
-- 			return
-- 		end
-- 	end
-- 	if UnitIsDND("player") then
-- 		if not wgrc.always then
-- 			WhydahGallyRaidCaller_DebugChat("WhydahGallyRaidCaller DEBUG: You are in DND, clear your status to enable WhydahGallyRaidCaller.")
-- 			return
-- 		end
-- 	end
-- 	WhydahGallyRaidCaller_DebugChat("WhydahGallyRaidCaller DEBUG: Checking for ignore match on: ["..author.."].")
-- 	if wgrc.ignore[author] then
-- 		WhydahGallyRaidCaller_DebugChat("WhydahGallyRaidCaller DEBUG: Ignoring "..author.." as per settings.")
-- 		return
-- 	end
-- 	if wgrc.nospam then
-- 		WhydahGallyRaidCaller_DebugChat("DEBUG: Anti-spam measures enabled, checking last request by "..author)
-- 		local hour,min = GetGameTime()	-- Check if author has asked this minute
-- 		if linked[author] == min then
-- 			WhydahGallyRaidCaller_DebugChat("WhydahGallyRaidCaller DEBUG: ["..author.."] already responded to at minute ["..min.."].")
-- 			return
-- 		else
-- 			WhydahGallyRaidCaller_DebugChat("WhydahGallyRaidCaller DEBUG: ["..author.."] not found.")
-- 		end
-- 	end
-- 	msg = strlower(message)
-- 	local match_trigger = false
-- 	local match_request = false
-- 	local req = {}
-- 	triggers = {
-- 			"need",
-- 			"besoin",
-- 			"seek",
-- 			"svp",
-- 			"stp",
-- 			"fair",
-- 			"faire",
-- 			"pliz",
-- 			"plz",
-- 			"faire",
-- 			"peux",
-- 			"peu",
-- 			"plait",
-- 			"please",
-- 			"portail",
-- 			"portal",
-- 			"tp",
-- 		}
-- 	for request in string.gmatch(msg, "%a+") do	--Check for request matches, store in req table
-- 		for i,word in pairs(triggers) do
-- 			if request == word then 
-- 				match_trigger = true 
-- 				WhydahGallyRaidCaller_DebugChat("WhydahGallyRaidCaller DEBUG: Match 1 found: ["..request.."]")
-- 				break
-- 			end
-- 		end
-- 	end
-- 	triggers2 = {
-- 			"^tp",
-- 			"^portail",
-- 			"^portal",
-- 			"^sw",
-- 			"^Hurlevent",
-- 			"^hurlevent",
-- 			"^if",
-- 			"^exodar",
-- 			"^teramor",
-- 			"^darna",
-- 			"^ogr",
-- 			"^storm",
-- 			"^dala",
-- 			"^iron",
-- 		}
-- 	for request in string.gmatch(msg, "%a+") do	--Check for request matches, store in req table
-- 		for i,word in pairs(triggers2) do
-- 			if string.find(request,word) then 
-- 				match_request = true 
-- 				WhydahGallyRaidCaller_DebugChat("WhydahGallyRaidCaller DEBUG: Match 2 found: ["..word.."]")
-- 				break
-- 			end
-- 		end
-- 	end
-- 	if not (match_trigger and match_request) then return end
-- 	if (match_trigger and match_request) then 
-- 		linked_someone = true
-- 		WhydahGallyRaidCaller_RespondChat(wgrc.prefix .." ".. wgrc.append, author)
-- 		WhydahGallyRaidCaller_DebugChat("DEBUG: Anti-spam measures enabled, recording time of request for "..author)
-- 		WhydahGallyRaidCaller_ClearRecent()
-- 		local hour,min = GetGameTime()	-- Record time that author requested link, for minor spam prevention
-- 		WhydahGallyRaidCaller_DebugChat("WhydahGallyRaidCaller DEBUG: Recording current minute of ["..min.."] for sender: ["..author.."].")
-- 		linked[author] = min
-- 	end
-- end

function WhydahGallyRaidCaller_OnEvent(this, event, arg1, arg2, arg3, arg4, ...)
 	if(event == "ADDON_LOADED" and arg1 == "WhydahGallyRaidCaller") then
 		WhydahGallyRaidCaller_Load()
 	elseif not wgrc.enabled then
 		return
-- 	elseif event == "CHAT_MSG_WHISPER" then
-- 		WhydahGallyRaidCaller(arg1, arg2, true)
 	end
 end

 WGRCplayername, WGRCrealm = UnitName("player")

local frame = CreateFrame("Frame", "WhydahGallyRaidCallerFrame")
frame:SetScript("OnEvent", WhydahGallyRaidCaller_OnEvent)
frame:RegisterEvent("ADDON_LOADED")
--frame:RegisterEvent("CHAT_MSG_WHISPER")



------------------------------------------------------------------------
--	ReloadUI command
------------------------------------------------------------------------
SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI


-- enable lua error by command
function SlashCmdList.LUAERROR(msg, editbox)
	if (msg == 'on') then
		SetCVar("scriptErrors", 1)
		-- because sometime we need to /rl to show an error on login.
		ReloadUI()
	elseif (msg == 'off') then
		SetCVar("scriptErrors", 0)
	else
		print("/luaerror on - /luaerror off")
	end
end
SLASH_LUAERROR1 = '/luaerror'
