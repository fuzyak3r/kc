local skelbones = {
	["ValveBiped.Bip01_Pelvis"] = true,
	["ValveBiped.Bip01_L_Thigh"] = true,
	["ValveBiped.Bip01_L_Calf"] = true,
	["ValveBiped.Bip01_L_Foot"] = true,
	["ValveBiped.Bip01_L_Toe0"] = true,
	["ValveBiped.Bip01_R_Thigh"] = true,
	["ValveBiped.Bip01_R_Calf"] = true,
	["ValveBiped.Bip01_R_Foot"] = true,
	["ValveBiped.Bip01_R_Toe0"] = true,
	["ValveBiped.Bip01_Spine"] = true,
	["ValveBiped.Bip01_Spine1"] = true,
	["ValveBiped.Bip01_Spine2"] = true,
	["ValveBiped.Bip01_Spine4"] = true,
	["ValveBiped.Bip01_Neck1"] = true,
	["ValveBiped.Bip01_Head1"] = true,
	["ValveBiped.Bip01_L_Clavicle"] = true,
	["ValveBiped.Bip01_L_UpperArm"] = true,
	["ValveBiped.Bip01_L_Forearm"] = true,
	["ValveBiped.Bip01_L_Hand"] = true,
	["ValveBiped.Bip01_R_Clavicle"] = true,
	["ValveBiped.Bip01_R_UpperArm"] = true,
	["ValveBiped.Bip01_R_Forearm"] = true,
	["ValveBiped.Bip01_R_Hand"] = true,
}

list.Set("DesktopWindows", "XRayKillCam", {
	width		=	ScrW()*0.6,
	height		=	ScrH()*0.6,
	icon		=	"icon64/playermodel.png",
	init		=	(function( but, frame )
		local ps = vgui.Create( "DPropertySheet", frame )
		ps:Dock( FILL )
		ps:InvalidateParent(true)
		
		local panel = vgui.Create("DPanel", ps)
		panel:Dock( FILL )
		panel:DockMargin( 8, 0, 8, 8 )
		panel:InvalidateParent(true)
		ps:AddSheet("Kill Cams", panel, "icon16/television.png", false, false, "Kill cams")
		
		local DermaListView = vgui.Create("DListView", panel)
		DermaListView:SetPos(0, 0)
		DermaListView:SetSize(panel:GetWide(), panel:GetTall() - 45)
		DermaListView:SetMultiSelect(false)
		DermaListView:AddColumn("Map")
		DermaListView:AddColumn("ID")
		
		DermaListView.DoDoubleClick = function(parent, index, line)
			XKCLoadFromFile( line:GetValue(1), line:GetValue(2) )
			frame:Close()
		end
		
		DermaListView.OnRowRightClick = function(parent, id, line)
			local opt = DermaMenu()
			
			opt:AddOption("Play", function()
				XKCLoadFromFile( line:GetValue(1), line:GetValue(2) )
				frame:Close()
			end):SetIcon( "icon16/eye.png" )
			
			opt:AddOption("Copy", function()
				SetClipboardText( "garrysmod/data/xkc/"..line:GetValue(1).."/"..line:GetValue(2)..".txt" )
			end):SetIcon( "icon16/textfield.png" )
			
			opt:AddSpacer()
			
			opt:AddOption("Delete", function()
				if file.Exists("xkc/"..line:GetValue(1).."/"..line:GetValue(2)..".txt", "DATA") then
					file.Delete("xkc/"..line:GetValue(1).."/"..line:GetValue(2)..".txt")
					parent:RemoveLine( id )
				end
			end):SetIcon( "icon16/bin.png" )
			
			opt:Open()
		end
		 
		local _, folders = file.Find( "xkc/*", "DATA" )
		for _,dir in pairs( folders ) do
			local files = file.Find( "xkc/"..dir.."/*.txt", "DATA" )
			for _,f in pairs( files ) do
				DermaListView:AddLine(dir, string.sub(f,1,string.len(f)-4))
			end
		end
		
		local Load = vgui.Create( "DButton", panel )
		Load:SetText("Load")
		Load:SetSize( panel:GetWide()/2, 40 )
		Load:SetPos( 0, panel:GetTall() - 45 )
		Load.DoClick = function()
			local linenum = DermaListView:GetSelectedLine()
			local line = DermaListView:GetLine( linenum )
			if line and IsValid(line) then
				XKCLoadFromFile( line:GetValue(1), line:GetValue(2) )
				frame:Close()
			end
		end
		
		local Delete = vgui.Create( "DButton", panel )
		Delete:SetText("Delete")
		Delete:SetSize( panel:GetWide()/2, 40 )
		Delete:SetPos( panel:GetWide()/2, panel:GetTall() - 45 )
		Delete.DoClick = function()
			local linenum = DermaListView:GetSelectedLine()
			local line = DermaListView:GetLine( linenum )
			if line and IsValid(line) then
				if file.Exists("xkc/"..line:GetValue(1).."/"..line:GetValue(2)..".txt", "DATA") then
					file.Delete("xkc/"..line:GetValue(1).."/"..line:GetValue(2)..".txt")
					DermaListView:RemoveLine( linenum )
				end
			end
		end
		
		
		
		local records = vgui.Create("DPanel", ps)
		records:Dock( FILL )
		records:DockMargin( 8, 0, 8, 8 )
		records:InvalidateParent(true)
		ps:AddSheet("Recordings", records, "icon16/film.png", false, false, "Recordings")
		
		local DermaListView = vgui.Create("DListView", records)
		DermaListView:SetPos(0, 0)
		DermaListView:SetSize(records:GetWide(), records:GetTall() - 45)
		DermaListView:SetMultiSelect(false)
		DermaListView:AddColumn("ID")
		
		DermaListView.DoDoubleClick = function(parent, index, line)
			XKCVideo( line:GetValue(1), frame )
		end
		
		DermaListView.OnRowRightClick = function(parent, id, line)
			local opt = DermaMenu()
			
			opt:AddOption("Play", function()
				XKCVideo( line:GetValue(1), frame )
			end):SetIcon( "icon16/eye.png" )
			
			opt:AddOption("Copy", function()
				SetClipboardText( "garrysmod/videos/"..line:GetValue(1)..".webm" )
			end):SetIcon( "icon16/textfield.png" )
			
			opt:Open()
		end
		 
		local files = file.Find( "videos/*", "GAME" )
		for _,f in pairs( files ) do
			DermaListView:AddLine(string.sub(f,1,string.len(f)-5))
		end
		
		local Load = vgui.Create( "DButton", records )
		Load:SetText("Load")
		Load:SetSize( records:GetWide(), 40 )
		Load:SetPos( 0, records:GetTall() - 45 )
		Load.DoClick = function()
			local linenum = DermaListView:GetSelectedLine()
			local line = DermaListView:GetLine( linenum )
			if line and IsValid(line) then
				XKCVideo( line:GetValue(1), frame )
			end
		end
	end),
	onewindow	=	true,
	title		=	"Kill Cam"
})

function XKCVideo( id, frame )
	if !file.Exists("videos/"..id..".webm", "GAME") then return false end
	local rf = file.Read("videos/"..id..".webm", true)
	local data = util.Base64Encode( rf )
	
	if IsValid(frame) then
		frame:SetBackgroundBlur( true )
		
		local back = vgui.Create( "DButton", frame )
		back:SetText("<")
		back:SetPos( 0, 0 )
		back:SetSize( 28, 28 )
		function back:Paint()
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
		end
		
		function back:DoClick()
			if IsValid(frame.VideoPanel) then
				frame.VideoPanel:Remove()
				frame:SetBackgroundBlur( false )
				self:Remove()
			else
				self:GetParent():Remove()
			end
		end
	else
		frame = vgui.Create( "DFrame" )
		frame:SetTitle( "Kill Recording" )
		frame:SetSize( ScrW() * 0.6, ScrH() * 0.6 )
		frame:SetSizable(true)
		frame:SetBackgroundBlur( true )
		frame:SetDraggable( true )
		frame:Center()
		frame:MakePopup()
		frame:SetKeyBoardInputEnabled(false)
	end
	
	local panel = vgui.Create( "DPanel", frame )
	panel:SetPos(0, 28)
	panel:SetSize(frame:GetWide(), frame:GetTall()-28)
	function panel:Paint()
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
	end
	frame.VideoPanel = panel

	local html = vgui.Create( "DHTML", panel )
	html:SetPos(0, 0)
	html:SetSize(panel:GetWide(), panel:GetTall()-10)
	
	html:AddFunction( "gmod", "initTime", function( c, t )
		if c and t then
			html.CurTime = tonumber(c) or 0
			html.StartTime = CurTime()
			html.Duration = tonumber(t) or GetConVar("xkc_slowmotion"):GetFloat()
		end
	end)
	
	html:SetHTML( [[<!DOCTYPE html>
	<html>
	<body style="overflow:hidden">
	
	<video id="player" width="100%" height="100%" loop autoplay>
	  <source src="data:video/webm;base64,]] .. data .. [[" type="video/webm">
	  Your browser does not support the video tag.
	</video>
	
	<script type="text/javascript">
		var vid = document.getElementById("player");
		
		vid.addEventListener("canplay", function() {
			vid.volume = 1;
			
			id = setInterval(sendData, 100);
			function sendData() {
				gmod.initTime( vid.currentTime, vid.duration );
			}
		});
	</script>
	
	</body>
	</html>]] )
	
	local pauseplay = vgui.Create( "DButton", panel )
	pauseplay:SetText("")
	pauseplay:SetPos( 0, 0 )
	pauseplay:SetSize( panel:GetWide(), panel:GetTall() )
	
	function pauseplay:DoClick()
		self.Paused = !self.Paused
		html:RunJavascript( [[
			var vid = document.getElementById("player");
			
			if (vid.paused) {
				vid.play();
			} else {
				vid.pause();
			}
		]] )
	end
	
	function pauseplay:Paint()
		if html.CurTime and html.Duration then
			local t = (CurTime() + html.CurTime) - html.StartTime
			if self.Paused then
				t = html.CurTime
			end
			local p = math.Clamp(t/html.Duration, 0, 1)
			draw.RoundedBox( 0, 0, self:GetTall()-8, self:GetWide()*p, 4, Color( 0, 200, 255, 255 ) )
			
			draw.RoundedBox( 0, 0, self:GetTall()-12, 2, 12, Color( 0, 200, 255, 255 ) )
			draw.RoundedBox( 0, self:GetWide()-2, self:GetTall()-12, 2, 12, Color( 0, 200, 255, 255 ) )
			
			draw.RoundedBox( 0, self:GetWide()*0.85, self:GetTall()-12, 2, 12, Color( 0, 200, 255, 255 ) )
			draw.RoundedBox( 0, self:GetWide()*p-1, self:GetTall()-12, 2, 12, Color( 0, 200, 255, 255 ) )
			
			draw.SimpleText("0", "TargetID", 0, self:GetTall()-30, Color(255,255,255), TEXT_ALIGN_LEFT)
			draw.SimpleText(math.Round(html.Duration), "TargetID", self:GetWide(), self:GetTall()-30, Color(255,255,255), TEXT_ALIGN_RIGHT)
			
			draw.SimpleText(math.Round(html.Duration*0.85), "TargetID", self:GetWide()*0.85, self:GetTall()-30, Color(255,255,255), TEXT_ALIGN_CENTER)
			draw.SimpleText(math.Round(t), "TargetID", self:GetWide()*p, self:GetTall()-30, Color(255,255,255), TEXT_ALIGN_CENTER)
		end
		
		if self.Paused then
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 100 ) )
			
			draw.RoundedBox( 0, panel:GetWide()/2 - 45, panel:GetTall()/2 - 45, 30, 90, Color( 255, 255, 255, 150 ) )
			draw.RoundedBox( 0, panel:GetWide()/2 + 15, panel:GetTall()/2 - 45, 30, 90, Color( 255, 255, 255, 150 ) )
		end
	end
end

local camerapaths = {
	["leftcurve"] = function(pos,ang,delta,tbl)
		pos = pos + ang:Forward()*tbl.Length*delta - ang:Forward()*(4+12*delta) + ang:Up()*0.5 - ang:Right()*32*delta
		ang:RotateAroundAxis(ang:Up(), -50*delta)
		return pos,ang
	end,
	["rightcurve"] = function(pos,ang,delta,tbl)
		pos = pos + ang:Forward()*tbl.Length*delta - ang:Forward()*(4+12*delta) + ang:Up()*0.5 + ang:Right()*32*delta
		ang:RotateAroundAxis(ang:Up(), 50*delta)
		return pos,ang
	end,
	["backview"] = function(pos,ang,delta,tbl)
		pos = pos + ang:Forward()*tbl.Length + ang:Forward()*(32+16*delta) + ang:Up()*1
		ang:RotateAroundAxis(ang:Up(), 180)
		return pos,ang
	end,
	["topview"] = function(pos,ang,delta,tbl)
		pos = pos + ang:Forward()*(tbl.Length-32+32*delta) + ang:Up()*(32+16*delta)
		ang:RotateAroundAxis(ang:Right(), -90)
		return pos,ang
	end,
	["leftview"] = function(pos,ang,delta,tbl)
		pos = pos + ang:Forward()*tbl.Length - ang:Right()*(32+16*delta)
		ang:RotateAroundAxis(ang:Up(), -(75+15*delta))
		return pos,ang
	end,
	["rightview"] = function(pos,ang,delta,tbl)
		pos = pos + ang:Forward()*tbl.Length + ang:Right()*(32+16*delta)
		ang:RotateAroundAxis(ang:Up(), 75+15*delta)
		return pos,ang
	end
}

local xkc_video_recorder = nil
local xkc_video_started = nil

local function Record()
	xkc_video_recorder:AddFrame( FrameTime(), true )
end

function StartRecording()
	if !GetConVar("xkc_record"):GetBool() then return end
	
	local files = file.Find("videos/*.webm", "GAME")
	local filenum = 0
	for k,v in pairs(files) do
		local num = string.gsub(v, ".webm", "")
		if (tonumber(num) or 0) > filenum then
			filenum = tonumber(num)
		end
	end
	
	local config = {
		container = "webm",
		video = "vp8",
		audio = "vorbis",
		quality = 50,
		bitrate = 1,
		fps = 30,
		lockfps = 30,
		name = tostring(filenum + 1),
		width = ScrW(),
		height = ScrH()
	}
	
	xkc_video_recorder = video.Record( config )
	if xkc_video_recorder then
		xkc_video_recorder:SetRecordSound( true )
		
		hook.Add("DrawOverlay", "RecordTest", Record)
		xkc_video_started = true
		
		if GetConVar("xkc_debug"):GetBool() then
			print("Recording started successfully")
		end
	else
		xkc_video_recorder = nil -- Recording couldn't start...
		xkc_video_started = nil
		
		if GetConVar("xkc_debug"):GetBool() then
			print("Recording couldn't start")
		end
	end
end

function StopRecording()
	hook.Remove("DrawOverlay", "RecordTest")
	if xkc_video_recorder then
		xkc_video_recorder:Finish()
		xkc_video_recorder = nil
		xkc_video_started = nil
		if GetConVar("xkc_debug"):GetBool() then
			print("Recording ended")
		end
	end
end

local XRayOrgans = {}
XRayOrgans["lung_left"] = {
	bone = "ValveBiped.Bip01_Spine2",
	pos = Vector(2.4,0,-1.2),
	ang = Angle(180,185,0),
	scale = 0.75,
	mdl = "models/props_wasteland/prison_toiletchunk01e.mdl",
	mat = "models/flesh",
	draw = function(ent, pos, ang, data, delta)
		ent:SetModelScale( 0.75 + math.sin(CurTime()*data.Slowmotion*4)*0.02 )
	end
}
XRayOrgans["lung_right"] = {
	bone = "ValveBiped.Bip01_Spine2",
	pos = Vector(8,1.4,1.2),
	ang = Angle(0,140,0),
	scale = 0.75,
	mdl = "models/props_wasteland/prison_toiletchunk01e.mdl",
	mat = "models/flesh",
	draw = function(ent, pos, ang, data, delta)
		ent:SetModelScale( 0.75 + math.sin(CurTime()*data.Slowmotion*4)*0.02 )
	end
}
XRayOrgans["liver"] = {
	bone = "ValveBiped.Bip01_Spine2",
	pos = Vector(0,-1,-4),
	ang = Angle(90,80,90),
	scale = 0.6,
	mdl = "models/props_wasteland/prison_toiletchunk01e.mdl",
	mat = "models/flesh"
}
XRayOrgans["ball_left"] = {
	bone = "ValveBiped.Bip01_Spine2",
	pos = Vector(-12,-6,1.75),
	ang = Angle(90,0,0),
	scale = 0.1,
	mdl = "models/Combine_Helicopter/helicopter_bomb01.mdl",
	mat = "models/flesh"
}
XRayOrgans["ball_right"] = {
	bone = "ValveBiped.Bip01_Spine2",
	pos = Vector(-12,-6,-1.75),
	ang = Angle(90,0,0),
	scale = 0.1,
	mdl = "models/Combine_Helicopter/helicopter_bomb01.mdl",
	mat = "models/flesh"
}
XRayOrgans["brain"] = {
	bone = "ValveBiped.Bip01_Head1",
	pos = Vector(3,0,-9),
	scale = 0.76,
	ang = Angle(0,0,0),
	mdl = "models/props_combine/breenbust_chunk03.mdl",
	mat = "models/flesh"
}

function XKCLoadFromFile( map, f )
	local ply = LocalPlayer()
	
	if file.Exists("xkc/"..map.."/"..f..".txt", "DATA") then
		if KillTable and type(KillTable) == "table" then
			if KillTable.Organs then
				for k,ent in pairs(KillTable.Organs) do
					if IsValid(ent) then
						ent:Remove()
					end
				end
			end
			
			if KillTable.Entities then
				for k,ent in pairs(KillTable.Entities) do
					if IsValid(ent) then
						ent:Remove()
					end
				end
			end
		end
		
		local r = file.Read("xkc/"..map.."/"..f..".txt", "DATA")
		KillTable = util.JSONToTable(r)
		KillTable.Slowmotion = GetConVar("xkc_slowmotion"):GetFloat()
		KillTable.StartTime = CurTime()
		KillTable.Entities = {}
		KillTable.Organs = {}
		KillTable.WorldSlow = nil
		
		if !KillTable.ShootPos then
			print("Failed to load KillCam, might be outdated")
			KillTable = nil
			return false
		end
		
		KillView = ply
		
		if GetConVar("xkc_sound"):GetBool() then
			ply:EmitSound("XKC_Bullet", 75, math.min(500*GetConVar("xkc_slowmotion"):GetFloat(), 255))
		end
		
		local bullet = ClientsideModel("models/weapons/w_bullet.mdl", RENDERGROUP_OPAQUE)
		bullet:SetNoDraw(true)
		bullet:SetModelScale(0.4)
		
		KillTable.Entities.Bullet = bullet
		
		local main = ClientsideModel(KillTable.Model, RENDERGROUP_OPAQUE)
		main:SetNoDraw(true)
		main:ResetSequence(main:LookupSequence(KillTable.Seq))
		main:SetPlaybackRate(KillTable.Slowmotion)
		main:SetCycle(0)
		main:SetIK(false)
		
		KillTable.Entities.Main = main
		
		local wep = KillTable.Wep
		
		if wep and wep != "models/error.mdl" then
			local swep = ClientsideModel(wep, RENDERGROUP_OPAQUE)
			swep:SetNoDraw(true)
			swep:SetParent(main)
			swep:AddEffects(EF_BONEMERGE)
			
			KillTable.Entities.Weapon = swep
		end
		
		if KillTable.UseSkeleton then
			local xray = ClientsideModel("models/player/skeleton.mdl", RENDERGROUP_OPAQUE)
			xray:SetNoDraw( true )
			xray:SetParent(main)
			xray:AddEffects(EF_BONEMERGE)
			
			KillTable.Entities.XRay = xray
		else
			local xray = ClientsideModel(KillTable.Model, RENDERGROUP_OPAQUE)
			xray:SetNoDraw(true)
			xray:SetModelScale(0.99, 0)
			xray:SetMaterial("models/debug/debugwhite")
			xray:ResetSequence(xray:LookupSequence(KillTable.Seq))
			xray:SetPlaybackRate(KillTable.Slowmotion)
			xray:SetCycle(0)
			xray:SetIK(false)
			
			KillTable.Entities.XRay = xray
		end
	end
end

concommand.Add("xkc_load", function(ply, command, args)
	if args[1] and args[2] then
		XKCLoadFromFile( args[1], args[2] )
	end
end)

net.Receive("XKC_Send", function(len)
	if !GetConVar("xkc_enable"):GetBool() then return end
	local npc = net.ReadEntity()
	local ply = net.ReadEntity()
	local pos = net.ReadVector()
	local wep = net.ReadString()
	local doslowmo = net.ReadBool()
	if IsValid(npc) and IsValid(ply) then
		npc.m_killer = ply
		
		if KillTable and type(KillTable) == "table" then
			if KillTable.Organs then
				for k,ent in pairs(KillTable.Organs) do
					if IsValid(ent) then
						ent:Remove()
					end
				end
			end
			
			if KillTable.Entities then
				for k,ent in pairs(KillTable.Entities) do
					if IsValid(ent) then
						ent:Remove()
					end
				end
			end
		end
		
		KillTable = {
			Pos = npc:GetPos(),
			Ang = npc:EyeAngles(),
			Seq = npc:GetSequenceName(npc:GetSequence()),
			Model = npc:GetModel(),
			Skin = npc:GetSkin(),
			ShootPos = ply:GetShootPos(),
			Wep = wep,
			HitPos = pos,
			Entities = {},
			Organs = {}
		}
		
		KillTable.WorldSlow = !doslowmo
		KillTable.Slowmotion = doslowmo and GetConVar("xkc_slowmotion"):GetFloat() or 1
		KillTable.StartTime = CurTime()
		KillTable.Dir = (KillTable.HitPos-KillTable.ShootPos):GetNormalized()
		KillTable.Length = (KillTable.HitPos-KillTable.ShootPos):Length()
		
		KillTable.ViewPath = {}
		
		local cams = table.Copy(camerapaths)
		local maxi = math.Round(math.Clamp((KillTable.Length/150), 1, 4))
		local last = math.min(maxi, table.Count(cams))
		for i = 1, last do
			local _,id = table.Random(cams)
			cams[id] = nil
			KillTable.ViewPath[i] = id
		end
		
		KillView = ply
		
		local rbones = {}
		
		for i = 0, npc:GetBoneCount() - 1 do
			local bone = npc:GetBoneName(i)
			if string.upper(bone) == "__INVALIDBONE__" then continue end
			if skelbones[bone] then
				rbones[bone] = true
			end
		end
		
		local ibc,cbc = table.Count(skelbones),table.Count(rbones)
		local useskeleton = ibc == cbc
		
		if GetConVar("xkc_debug"):GetBool() then
			print("--Bone checking--")
			print("Ideal bones: "..ibc)
			print("Current bones: "..cbc)
			
			if ibc != cbc then
				print("Required bones are not present")
				print("--Missing bones--")
				for k,v in pairs(skelbones) do
					if !rbones[k] then
						print(k)
					end
				end
				print("Skeleton not available")
			else
				print("Required bones are present")
				print("Skeleton available")
			end
		end
		
		KillTable.UseSkeleton = useskeleton
		
		local CopyTable = table.Copy(KillTable)
		local override = hook.Run("PreXRayStart", CopyTable) -- If anyone wants to alter the data
		if override then
			KillTable = CopyTable
		end
		
		if GetConVar("xkc_sound"):GetBool() then
			ply:EmitSound("XKC_Bullet", 75, math.min(500*GetConVar("xkc_slowmotion"):GetFloat(), 255))
		end
		
		if GetConVar("xkc_save"):GetBool() then
			local tbl = table.Copy(KillTable)
			tbl.Slowmotion = nil
			tbl.StartTime = nil
			tbl.Entities = nil
			tbl.Organs = nil
			tbl.WorldSlow = nil
			
			file.CreateDir("xkc/"..game.GetMap())
			
			local files = file.Find("xkc/"..game.GetMap().."/*.txt", "DATA")
			local filenum = 0
			for k,v in pairs(files) do
				local num = string.gsub(v, ".txt", "")
				if (tonumber(num) or 0) > filenum then
					filenum = tonumber(num)
				end
			end
			
			local done = file.Write("xkc/"..game.GetMap().."/"..(filenum + 1)..".txt", util.TableToJSON(tbl))
			
			if GetConVar("xkc_debug"):GetBool() then
				if done then
					print("Saved Killcam as "..(filenum + 1)..".txt")
				else
					print("Could not save Killcam")
				end
			end
		end
		
		local bullet = ClientsideModel("models/weapons/w_bullet.mdl", RENDERGROUP_OPAQUE)
		bullet:SetNoDraw(true)
		bullet:SetModelScale(0.4)
		
		KillTable.Entities.Bullet = bullet
		
		local main = ClientsideModel(npc:GetModel(), RENDERGROUP_OPAQUE)
		main:SetNoDraw(true)
		main:ResetSequence(main:LookupSequence(KillTable.Seq))
		main:SetPlaybackRate(KillTable.Slowmotion)
		main:SetCycle(0)
		main:SetIK(false)
		
		KillTable.Entities.Main = main
		
		if wep and wep != "models/error.mdl" then
			local swep = ClientsideModel(wep, RENDERGROUP_OPAQUE)
			swep:SetNoDraw(true)
			swep:SetParent(main)
			swep:AddEffects(EF_BONEMERGE)
			
			KillTable.Entities.Weapon = swep
		end
		
		if useskeleton then
			if npc:IsPlayer() then
				local xray = ClientsideModel("models/player/skeleton.mdl", RENDERGROUP_OPAQUE)
				xray:SetNoDraw(true)
				xray:ResetSequence(xray:LookupSequence(KillTable.Seq))
				
				KillTable.Entities.XRay = xray
			else
				local xray = ClientsideModel("models/player/skeleton.mdl", RENDERGROUP_OPAQUE)
				xray:SetNoDraw(true)
				xray:SetParent(main)
				xray:AddEffects(EF_BONEMERGE)
				
				KillTable.Entities.XRay = xray
			end
		else
			local xray = ClientsideModel(npc:GetModel(), RENDERGROUP_OPAQUE)
			xray:SetNoDraw(true)
			xray:SetModelScale(0.99, 0)
			xray:SetMaterial("models/debug/debugwhite")
			xray:ResetSequence(xray:LookupSequence(KillTable.Seq))
			xray:SetPlaybackRate(KillTable.Slowmotion)
			xray:SetCycle(0)
			xray:SetIK(false)
			
			KillTable.Entities.XRay = xray
		end
		
		hook.Run("PostXRayStart", table.Copy(KillTable)) -- Send a copy of the data. If you want to mess with it use the Pre hook instead
		
		StartRecording()
	end
end)

function XKCRemove()
	hook.Run("PreXRayEnd", table.Copy(KillTable))
	
	if KillTable and type(KillTable) == "table" and KillTable.Entities then
		if IsValid(KillTable.Entities.Main) then
			KillTable.Entities.Main:Remove()
		end
		if IsValid(KillTable.Entities.XRay) then
			KillTable.Entities.XRay:Remove()
		end
		if IsValid(KillTable.Entities.Bullet) then
			KillTable.Entities.Bullet:Remove()
		end
		if IsValid(KillTable.Entities.Weapon) then
			KillTable.Entities.Weapon:Remove()
		end
	end
	KillTable = nil
	KillView = nil
	
	hook.Run("PostXRayEnd")
	
	StopRecording()
end

net.Receive("XKC_Remove", function(len)
	XKCRemove()
end)

hook.Add("PlayerBindPress", "XKCButtonPress", function(ply, key, press)
	if press and KillTable and !KillTable.Saved then
		if key == "+jump" then
			KillTable.Saved = true
			
			local tbl = table.Copy(KillTable)
			tbl.Slowmotion = nil
			tbl.StartTime = nil
			tbl.Entities = nil
			tbl.Organs = nil
			tbl.WorldSlow = nil
			tbl.Hit = nil
			
			file.CreateDir("xkc/"..game.GetMap())
			
			local files = file.Find("xkc/"..game.GetMap().."/*.txt", "DATA")
			local filenum = 0
			for k,v in pairs(files) do
				local num = string.gsub(v, ".txt", "")
				if (tonumber(num) or 0) > filenum then
					filenum = tonumber(num)
				end
			end
			
			file.Write("xkc/"..game.GetMap().."/"..(filenum + 1)..".txt", util.TableToJSON(tbl))
			
			return true
		end
	end
end)

surface.CreateFont( "XKCFont", {
	font = "Impact",
	extended = true,
	size = 30,
	weight = 250,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false
} )

hook.Add("HUDPaint", "XKCHUD", function()
	if !xkc_video_started and KillTable and !KillTable.Saved then
		local space = input.LookupBinding( "+jump" )
		local text = "Press "..space.." to save"
		local ml = string.len(text)
		surface.SetFont("XKCFont")
		local w = surface.GetTextSize(text) + 32
		for i = 1, ml do
			draw.SimpleText(string.sub(text, i, i), "XKCFont", ScrW()/2 + (i/ml)*w - w/2, ScrH() - 80 + 10*math.sin(SysTime()*6 + i/2), Color(255,255,255), TEXT_ALIGN_CENTER)
		end
	end
end)

hook.Add("CreateClientsideRagdoll", "XKCRagdollCreation", function(npc, rag)
	if !GetConVar("xkc_enable"):GetBool() then return end
	if !IsValid(rag) or (!npc:IsNPC() and !npc:IsPlayer()) then return end
	if npc.m_killer and npc.m_killer == LocalPlayer() then
		rag:SetNoDraw(true)
		if game.SinglePlayer() and GetConVar("xkc_world_slowmotion"):GetBool() then
			timer.Create("RagdollInvis_"..rag:EntIndex(), 1.2, 1, function()
				if IsValid(rag) then
					rag:SetNoDraw(false)
				end
			end)
		else
			timer.Create("RagdollInvis_"..rag:EntIndex(), (1/GetConVar("xkc_slowmotion"):GetFloat())*1.2, 1, function()
				if IsValid(rag) then
					rag:SetNoDraw(false)
				end
			end)
		end
	end
end)

hook.Add("CalcView", "XKCCalcView", function( ply, pos, angle, fov, zn, zfar )
    if ( !ply:IsValid() or ply:GetViewEntity() != ply ) then return end
	
	local main = KillTable and KillTable.Entities and KillTable.Entities.Main
	
	if IsValid(main) then
		local percent = (CurTime()-KillTable.StartTime)*KillTable.Slowmotion
		
		local cams = KillTable.ViewPath or {}
		local num = math.Clamp(math.Round(percent*table.Count(cams))+1, 1, table.Count(cams))
		local camfunc = camerapaths[cams[num]]
		
		if !camfunc then
			XKCRemove()
			return
		end
		
		if percent < 1 then -- Follow the bullet
			angle = KillTable.Dir:Angle()
			pos, angle = camfunc(KillTable.ShootPos, angle, percent, KillTable)
		elseif percent < 1.2 then -- Stop following right when the bullet hits
			angle = KillTable.Dir:Angle()
			pos, angle = camfunc(KillTable.ShootPos, angle, 1, KillTable)
			
			if !KillTable.Hit then -- Blood effects and the like
				KillTable.Hit = true
				
				if GetConVar("xkc_gibs"):GetBool() then
					local effectdata = EffectData()
					effectdata:SetOrigin( KillTable.HitPos + KillTable.Dir*3.5 - angle:Up() )
					effectdata:SetNormal( -KillTable.Dir )
					for i = 1, math.random(6,9) do
						util.Effect( "xray_bone", effectdata, true, true )
					end
				end
				
				local effectdata = EffectData()
				effectdata:SetOrigin( KillTable.HitPos )
				util.Effect( "xray_blood", effectdata, true, true )
				
				ply:EmitSound("physics/body/body_medium_break"..math.random(2,4)..".wav", 75, 90, 1, CHAN_WEAPON)
			end
		else -- Reset killcam
			XKCRemove()
		end
		
		local view	= {}
		view.origin	= pos
		view.angles	= angle
		view.fov	= GetConVar("xkc_fov"):GetInt() - 10*percent
		view.znear	= 1
		view.zfar	= zfar
		
		return view
	end
end)

hook.Add("ShouldDrawLocalPlayer", "GMKDrawPlayer", function()
	if KillTable then return true end -- If you're viewing a kill
end)

local heatmat = Material("trails/tube")

hook.Add("PostDrawOpaqueRenderables", "XKCDrawKillModel", function()
	local ply = KillView
	
	if KillTable and KillTable.Entities and IsValid(ply) then
		if IsValid(KillTable.Entities.Main) and IsValid(KillTable.Entities.XRay) and IsValid(KillTable.Entities.Bullet) then
			local percent = (CurTime() - KillTable.StartTime)*KillTable.Slowmotion		
			
			local main = KillTable.Entities.Main
			local xray = KillTable.Entities.XRay
			local bullet = KillTable.Entities.Bullet
			local wep = KillTable.Entities.Weapon
			
			
			local pos = KillTable.Pos
			local hitpos = KillTable.HitPos
			local eyeang = Angle(0, KillTable.Ang.y, 0)
			local dir = KillTable.Dir
			
			
			-- NPC information
			
			main:SetSkin( KillTable.Skin )
			
			main:SetPoseParameter("head_pitch", KillTable.Ang.p)
			main:SetPoseParameter("aim_pitch", KillTable.Ang.p)
			
			
			-- XRay information
			
			xray:SetPoseParameter("head_pitch", KillTable.Ang.p)
			xray:SetPoseParameter("aim_pitch", KillTable.Ang.p)
			
			
			-- Bullet information
			
			local bulletpos = KillTable.ShootPos + (dir*KillTable.Length*percent)
			local xraydist = (bulletpos-hitpos):Length() - 64
			if percent >= 1 then
				xraydist = -64
			end
			
			
			hook.Run("PreXRayDraw", percent)
			
			
			render.EnableClipping( true )
			
			----//Draw NPC model\\----
			
			local normal = dir
			local origin = hitpos - dir*xraydist
			local distance = normal:Dot( origin )
			
			render.PushCustomClipPlane( normal, distance )
			
			main:SetRenderOrigin(pos)
			main:SetRenderAngles(eyeang)
			main:SetupBones()
			main:DrawModel()
			main:SetRenderOrigin()
			main:SetRenderAngles()
			
			if IsValid(wep) then
				wep:SetRenderOrigin(pos)
				wep:SetRenderAngles(eyeang)
				wep:SetupBones()
				wep:DrawModel()
				wep:SetRenderOrigin()
				wep:SetRenderAngles()
			end
			
			render.PopCustomClipPlane()
			
			----//Setup for black-model\\----
			
			render.SuppressEngineLighting( true )
			
			render.MaterialOverride( Material("models/debug/debugwhite") )
			
			render.SetColorModulation( 0, 0, 0 )
			
			render.SetBlend(0.999999)
			
			----//Black model around NPC (Makes a nice XRay-effect)\\----
			
			local normal = -dir
			local origin = hitpos - dir*xraydist
			local distance = normal:Dot( origin )
			
			render.PushCustomClipPlane( normal, distance )
			
			main:SetRenderOrigin(pos)
			main:SetRenderAngles(eyeang)
			main:SetupBones()
			main:DrawModel()
			main:SetRenderOrigin()
			main:SetRenderAngles()
			
			if IsValid(wep) then
				wep:SetRenderOrigin(pos)
				wep:SetRenderAngles(eyeang)
				wep:SetupBones()
				wep:DrawModel()
				wep:SetRenderOrigin()
				wep:SetRenderAngles()
			end
			
			render.PopCustomClipPlane()
			
			----//Setup for XRay\\----
			
			render.SetColorModulation( 1, 1, 1 )
			
			render.MaterialOverride( 0 )
			
			render.SetBlend(1)
			
			render.SuppressEngineLighting( false )
			
			--cam.IgnoreZ( true ) -- Makes the skeleton draw on top of everything else
			
			----//Draw XRaymodel\\----
			
			local normal = -dir
			local origin = hitpos - dir*xraydist
			local distance = normal:Dot( origin )
			
			render.PushCustomClipPlane( normal, distance )
			
			xray:SetRenderOrigin(pos)
			xray:SetRenderAngles(eyeang)
			xray:SetupBones()
			xray:DrawModel()
			xray:SetRenderOrigin()
			xray:SetRenderAngles()
			
			if KillTable.UseSkeleton and GetConVar("xkc_organs"):GetBool() then
				for name,data in pairs(XRayOrgans) do
					if !IsValid(XKCOrganModel) then
						XKCOrganModel = ClientsideModel(data.mdl, RENDERGROUP_OPAQUE)
						XKCOrganModel:SetNoDraw(true)
					else
						XKCOrganModel:SetModel(data.mdl)
						XKCOrganModel:SetModelScale(data.scale or 1)
						
						local orgpos,organg = Vector(),Angle()
						
						local bone_id = main:LookupBone(data.bone)
						if !bone_id then continue end
						
						main:SetRenderOrigin(pos)
						main:SetRenderAngles(eyeang)
						main:SetupBones()
						orgpos,organg = main:GetBonePosition(bone_id)
						main:SetRenderOrigin()
						main:SetRenderAngles()
						
						orgpos = orgpos + organg:Forward() * data.pos.x + organg:Right() * data.pos.y + organg:Up() * data.pos.z
						
						organg:RotateAroundAxis(organg:Up(), data.ang.y)
						organg:RotateAroundAxis(organg:Right(), data.ang.p)
						organg:RotateAroundAxis(organg:Forward(), data.ang.r)
						
						render.MaterialOverride( data.mat and Material(data.mat) or 0 )
						
						if data.draw then
							local dpos,dang = data.draw( XKCOrganModel, orgpos, organg, KillTable, percent )
							
							if type(dpos) == "vector" then
								orgpos = dpos
							end
							if type(dang) == "angle" then
								organg = dang
							end
						end
						
						XKCOrganModel:SetRenderOrigin( orgpos )
						XKCOrganModel:SetRenderAngles( organg )
						XKCOrganModel:SetupBones()
						XKCOrganModel:DrawModel()
						XKCOrganModel:SetRenderOrigin()
						XKCOrganModel:SetRenderAngles()
					end
				end
			end
			
			render.PopCustomClipPlane()
			
			render.EnableClipping( false )
			
			----//Draw Bullet\\----
			
			render.MaterialOverride( 0 )
			
			local ang = dir:Angle()
			ang.r = ang.r + CurTime() * 180*KillTable.Slowmotion % 360
			
			bullet:SetRenderOrigin( bulletpos )
			bullet:SetRenderAngles( ang )
			bullet:SetupBones()
			bullet:DrawModel()
			bullet:SetRenderOrigin()
			bullet:SetRenderAngles()
			
			render.SetMaterial( heatmat )
			
			render.StartBeam(3)
			
			render.AddBeam( bulletpos - ang:Forward()*0.35, 0.4, 0, Color(255, 255, 255, 255) )
			render.AddBeam( bulletpos - ang:Forward()*48, 0.3, 0.5, Color(255, 255, 255, 255) )
			render.AddBeam( bulletpos - ang:Forward()*64, 0, 1, Color(255, 255, 255, 255) )
			
			render.EndBeam()
			
			----//Camera end\\----
			
			hook.Run("PostXRayDraw", percent)
			
			--cam.IgnoreZ( false )
		end
	end
end)