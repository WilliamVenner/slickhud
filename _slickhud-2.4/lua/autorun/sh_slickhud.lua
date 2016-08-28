local Version = "2.4"

MsgC("\n\n")
for i,v in pairs(string.ToTable(string.rep("#",59))) do
	MsgC(Color(i * 4.32203389831,255,0),v)
end
MsgC("\n\n")
for i,v in pairs({"   _____ _ _      _    _    _ _    _ _____  ","  / ____| (_)    | |  | |  | | |  | |  __ \\ "," | (___ | |_  ___| | _| |__| | |  | | |  | |","  \\___ \\| | |/ __| |/ /  __  | |  | | |  | |","  ____) | | | (__|   <| |  | | |__| | |__| |"," |_____/|_|_|\\___|_|\\_\\_|  |_|\\____/|_____/ ","                                            ","                                            "}) do
	MsgC(string.rep(" ",5))
	for i,_v in pairs(string.ToTable(v)) do
		MsgC(Color(i * 8.5,255,0),_v)
	end
	MsgC("\n")
end
MsgC("\n" .. string.rep(" ",13))
local spaces = ""
for i=1,math.floor(15 - (#Version / 2)),1 do
	spaces = spaces .. " "
end
for i,v in pairs(string.ToTable(spaces .. Version)) do
	MsgC(Color(i * 8.5,255,0),v)
end
MsgC("\n\n")
for i,v in pairs(string.ToTable(string.rep("#",59))) do
	MsgC(Color(i * 4.32203389831,255,0),v)
end
MsgC("\n\n")
