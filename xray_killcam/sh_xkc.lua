if CLIENT then
	if GetConVar("xkc_enable") == nil then
		CreateClientConVar("xkc_enable", "1", true, true)
	end
	if GetConVar("xkc_debug") == nil then
		CreateClientConVar("xkc_debug", "0", true, true)
	end
	if GetConVar("xkc_sound") == nil then
		CreateClientConVar("xkc_sound", "1", true, true)
	end
	if GetConVar("xkc_gibs") == nil then
		CreateClientConVar("xkc_gibs", "1", true, true)
	end
	if GetConVar("xkc_organs") == nil then
		CreateClientConVar("xkc_organs", "1", true, true)
	end
	if GetConVar("xkc_world_slowmotion") == nil then
		CreateClientConVar("xkc_world_slowmotion", "1", true, true)
	end
	if GetConVar("xkc_save") == nil then
		CreateClientConVar("xkc_save", "1", true, true)
	end
	if GetConVar("xkc_record") == nil then
		CreateClientConVar("xkc_record", "0", true, true)
	end
	if GetConVar("xkc_fov") == nil then
		CreateClientConVar("xkc_fov", "90", true, true)
	end
	if GetConVar("xkc_chance") == nil then
		CreateClientConVar("xkc_chance", "1", true, true)
	end
	if GetConVar("xkc_slowmotion") == nil then
		CreateClientConVar("xkc_slowmotion", "0.2", true, true)
	end
end


sound.Add( {
	name = "XKC_Bullet",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = 100,
	sound = "xraykc/slowmo.wav"
} )


local function XKCSettingsPanel(panel)
    panel:ClearControls()
	
	panel:AddControl("CheckBox", {
	    Label = "Enable Killcam",
	    Command = "xkc_enable"
	})
	
	panel:AddControl("CheckBox", {
	    Label = "Enable Debug-Mode",
	    Command = "xkc_debug"
	})
	
	panel:AddControl("CheckBox", {
	    Label = "Enable bullet sound",
	    Command = "xkc_sound"
	})
	
	panel:AddControl("CheckBox", {
	    Label = "Enable bone gibs",
	    Command = "xkc_gibs"
	})
	
	panel:AddControl("CheckBox", {
	    Label = "Enable organs",
	    Command = "xkc_organs"
	})
	
	panel:AddControl("CheckBox", {
	    Label = "Enable World-slowmotion",
	    Command = "xkc_world_slowmotion"
	})
	
	panel:AddControl("CheckBox", {
	    Label = "Save Killcams for later use",
	    Command = "xkc_save"
	})
	
	panel:AddControl("CheckBox", {
	    Label = "Record Killcams (Intensive)",
	    Command = "xkc_record"
	})
	
	panel:AddControl( "Slider", {
		Label = "Field of view",
		Command = "xkc_fov",
		Min = 40,
		Max = 110
	})
	
	panel:AddControl( "Slider", {
		Label = "Killcam chance",
		Command = "xkc_chance",
		Type = "Float",
		Min = 0.1,
		Max = 1
	})
	
	panel:AddControl( "Slider", {
		Label = "Slowmotion",
		Command = "xkc_slowmotion",
		Type = "Float",
		Min = 0.01,
		Max = 1
	})
    
end

local function PopulateXKCMenu()
    spawnmenu.AddToolMenuOption("Options", "XRay KillCam", "XRay KillCam", "Settings", "", "", XKCSettingsPanel)
end
hook.Add("PopulateToolMenu", "XKC ConVars", PopulateXKCMenu)