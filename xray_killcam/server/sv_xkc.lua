util.AddNetworkString( "XKC_Send" )
util.AddNetworkString( "XKC_Remove" )

local i_oldTimeScale = nil

hook.Add("OnNPCKilled", "XKCNPCKilled", function( npc, attacker, inflictor )
	local data = npc.m_LastHitData
	if IsValid(npc) and IsValid(attacker) and attacker:IsPlayer() and data then
		if attacker:GetInfo("xkc_enable") != "1" then return end
		local num = tonumber(attacker:GetInfo("xkc_chance"))
		if !num or num == 0 then return end -- No math required
		local chance = math.Rand(0,1)
		if chance > num then return end
		if attacker != data.Ply then return end
		
		local doslowmo = true
		if game.SinglePlayer() and attacker:GetInfo("xkc_world_slowmotion") == "1" then
			local t = tonumber(attacker:GetInfo("xkc_slowmotion")) or 1
			doslowmo = false
			i_oldTimeScale = i_oldTimeScale or game.GetTimeScale()
			game.SetTimeScale(t)
			timer.Create("XKC_SlowmoReset", 1.2, 1, function()
				game.SetTimeScale(i_oldTimeScale or 1)
				i_oldTimeScale = nil
			end)
		end
		
		local wep = npc.GetActiveWeapon and npc:GetActiveWeapon()
		
		net.Start("XKC_Send")
			net.WriteEntity(npc)
			net.WriteEntity(attacker)
			net.WriteVector(data.Pos)
			if IsValid(wep) then
				wep:SetNoDraw(true)
				wep:SetRenderMode( RENDERMODE_TRANSALPHA )
				wep:SetColor(Color(0,0,0,0))
				
				if attacker:GetInfo("xkc_world_slowmotion") == "1" then
					timer.Simple(1.2, function()
						if IsValid(wep) then
							wep:SetRenderMode( RENDERMODE_NORMAL )
							wep:SetColor(Color(255,255,255,255))
						end
					end)
				else
					local t = tonumber(attacker:GetInfo("xkc_slowmotion")) or 1
					timer.Simple((1/t)*1.2, function()
						if IsValid(wep) then
							wep:SetRenderMode( RENDERMODE_NORMAL )
							wep:SetColor(Color(255,255,255,255))
						end
					end)
				end
				
				local mdl = wep:GetModel()
				net.WriteString(util.IsValidModel(mdl) and mdl or "models/error.mdl")
			else
				net.WriteString("models/error.mdl")
			end
			net.WriteBool(doslowmo)
		net.Send(attacker)
		
		npc.m_LastHitData = nil
	end
end)

hook.Add("PlayerDeath", "XKCNPCKilled", function( ply, inflictor, attacker )
	local data = ply.m_LastHitData
	if IsValid(ply) and IsValid(attacker) and attacker:IsPlayer() and data then
		if attacker:GetInfo("xkc_enable") != "1" then return end
		local num = tonumber(attacker:GetInfo("xkc_chance"))
		if !num or num == 0 then return end -- No math required
		local chance = math.Rand(0,1)
		if chance > num then return end
		if attacker != data.Ply then return end
		
		local doslowmo = true
		if game.SinglePlayer() and attacker:GetInfo("xkc_world_slowmotion") == "1" then
			local t = tonumber(attacker:GetInfo("xkc_slowmotion")) or 1
			doslowmo = false
			i_oldTimeScale = i_oldTimeScale or game.GetTimeScale()
			game.SetTimeScale(t)
			timer.Create("XKC_SlowmoReset", 1.2, 1, function()
				game.SetTimeScale(i_oldTimeScale or 1)
				i_oldTimeScale = nil
			end)
		end
		
		local wep = ply.GetActiveWeapon and ply:GetActiveWeapon()
		
		net.Start("XKC_Send")
			net.WriteEntity(ply)
			net.WriteEntity(attacker)
			net.WriteVector(data.Pos)
			if IsValid(wep) then
				wep:SetNoDraw(true)
				wep:SetRenderMode( RENDERMODE_TRANSALPHA )
				wep:SetColor(Color(0,0,0,0))
				
				if attacker:GetInfo("xkc_world_slowmotion") == "1" then
					timer.Simple(1.2, function()
						if IsValid(wep) then
							wep:SetRenderMode( RENDERMODE_NORMAL )
							wep:SetColor(Color(255,255,255,255))
						end
					end)
				else
					local t = tonumber(attacker:GetInfo("xkc_slowmotion")) or 1
					timer.Simple((1/t)*1.2, function()
						if IsValid(wep) then
							wep:SetRenderMode( RENDERMODE_NORMAL )
							wep:SetColor(Color(255,255,255,255))
						end
					end)
				end
				
				local mdl = wep:GetModel()
				net.WriteString(util.IsValidModel(mdl) and mdl or "models/error.mdl")
			else
				net.WriteString("models/error.mdl")
			end
			net.WriteBool(doslowmo)
		net.Send(attacker)
		
		ply.m_LastHitData = nil
	end
end)

hook.Add("EntityTakeDamage", "XKCEntityTakeDamage", function(npc, dmginfo)
	if IsValid(npc) and (npc:IsNPC() or npc:IsPlayer())  and dmginfo:IsBulletDamage() then
		local attacker = dmginfo:GetAttacker()
		if IsValid(attacker) and attacker:IsPlayer() then
			if attacker:GetInfo("xkc_enable") == "1" then
				npc.m_LastHitData = {
					Ply = attacker,
					Pos = dmginfo:GetDamagePosition()
				}
			end
		end
	elseif npc.m_LastHitData then
		npc.m_LastHitData = nil
	end
end)