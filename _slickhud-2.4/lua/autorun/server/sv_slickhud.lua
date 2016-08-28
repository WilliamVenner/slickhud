resource.AddWorkshop("687820249")
resource.AddFile("materials/slickhud/hud.png")
resource.AddFile("materials/slickhud/bullet.png")
resource.AddFile("materials/slickhud/magazine.png")
resource.AddFile("materials/slickhud/police.png")
resource.AddFile("materials/slickhud/wanted.png")

local function logBroadcast(txt)
	local compressed = util.Compress(string.sub(txt,1,1024))
	net.Start("slickhud_log")
	net.WriteString(tostring(string.len(compressed)))
	net.WriteData(compressed,string.len(compressed))
	net.Broadcast()
end
util.AddNetworkString("slickhud_log")
hook.Remove("PlayerConnect","slickhud_log_connected")
hook.Add("PlayerConnect","slickhud_log_connected",function(ply)
	logBroadcast(ply .. " connected")
end)
hook.Remove("PlayerDisconnected","slickhud_log_disconnected")
hook.Add("PlayerDisconnected","slickhud_log_disconnected",function(ply)
	logBroadcast(ply:Nick() .. " disconnected")
end)
hook.Remove("PlayerInitialSpawn","slickhud_log_inispawn")
hook.Add("PlayerInitialSpawn","slickhud_log_inispawn",function(ply)
	logBroadcast(ply:Nick() .. " spawned for the first time")
end)
hook.Remove("PlayerDeath","slickhud_log_death")
hook.Add("PlayerDeath","slickhud_log_death",function(ply,wep,attacker)
	if (!IsValid(ply) or !IsValid(attacker)) then return nil end
	if (!ply:IsPlayer() or !attacker:IsPlayer()) then return nil end
	if (ply == attacker) then
		logBroadcast(ply:Nick() .. " committed suicide")
	else
		logBroadcast(ply:Nick() .. " was killed by " .. attacker:Nick())
	end
end)
