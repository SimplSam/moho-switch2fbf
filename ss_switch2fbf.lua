-- -------------------------------
-- Script config
-- -------------------------------

ScriptName = "SS_Switch2FBF"

SS_Switch2FBF = {}

function SS_Switch2FBF:Name()
    return 'SS Switch to FBF'
end

function SS_Switch2FBF:Version()
    return '1.0B'
end

function SS_Switch2FBF:UILabel()
    return 'Switch to FBF'
end

function SS_Switch2FBF:Creator()
    return 'Sam Cogheil (SimplSam)'
end

function SS_Switch2FBF:Description()
    return 'Convert the layers in a Switch group to Frame-by-Frame'
end

function SS_Switch2FBF:IsEnabled(moho)
    return (moho.layer:LayerType() == MOHO.LT_SWITCH)
end


-- -------------------------------
-- Dialog & Globs
-- -------------------------------

local SS_Switch2FBF_Dialog = {}
SS_Switch2FBF_Dialog.UPDATE = MOHO.MSG_BASE
SS_Switch2FBF_Dialog.SORTTOP = MOHO.MSG_BASE+2
SS_Switch2FBF_Dialog.SORTBOT = MOHO.MSG_BASE+4

SS_Switch2FBF.fbf_interval = 1          -- Frame by Frame interval
SS_Switch2FBF.sort_by_toptobot = true   -- If false Bottom to Top
SS_Switch2FBF.SORTBy = SS_Switch2FBF_Dialog.SORTTOP

SS_Switch2FBF.start_frame  = 1          -- 1st animation frame

function SS_Switch2FBF_Dialog:new(moho)
    local d = LM.GUI.SimpleDialog("Switch to Frame-by-Frame configuration", SS_Switch2FBF_Dialog)
    local l = d:GetLayout()
    d.moho = moho
    l:PushH()
        l:PushV()
            l:AddChild(LM.GUI.StaticText("Parameters for: " .. moho.layer:Name()), LM.GUI.ALIGN_LEFT)
            l:AddChild(LM.GUI.Divider(false), LM.GUI.ALIGN_FILL)
            l:PushH()
                l:PushV()
                    l:AddChild(LM.GUI.StaticText("FBF Interval:"), LM.GUI.ALIGN_LEFT)
                    l:AddChild(LM.GUI.StaticText("Start with:"), LM.GUI.ALIGN_LEFT)
                l:Pop()
                l:PushV()
                    d.interval = LM.GUI.TextControl(32, "1", self.UPDATE, LM.GUI.FIELD_UINT)
                    l:AddChild(d.interval, LM.GUI.ALIGN_LEFT)

                    d.sortbymode = LM.GUI.Menu("FBF Sort Mode")
                    d.sortbypopup = LM.GUI.PopupMenu(100)
                    d.sortbypopup:SetMenu(d.sortbymode)
                    l:AddChild(d.sortbypopup, LM.GUI.ALIGN_LEFT)

                    d.sortbymode:AddItem("Top layer", 0, self.SORTTOP)
                    d.sortbymode:AddItem("Bottom layer", 0, self.SORTBOT)
                l:Pop()
                l:PushV()
                    l:AddChild(LM.GUI.StaticText(" - \"Interval between each FBF Frame?\""), LM.GUI.ALIGN_LEFT)
                    l:AddChild(LM.GUI.StaticText(" - \"Which layer should be the 1st frame?\""), LM.GUI.ALIGN_LEFT)
                l:Pop()
            l:Pop() --H
            -- d.currentframe = LM.GUI.CheckBox("Use current frame for start of FBF?...")
            -- d.setframezero = LM.GUI.CheckBox("Set Frame zero to Switch value of start frame?...")
        l:Pop() --V
    l:Pop() --H
    return d
end

function SS_Switch2FBF_Dialog:UpdateWidgets()
    self.interval:SetValue(SS_Switch2FBF.fbf_interval)
    self.sortbymode:SetChecked(SS_Switch2FBF.SORTBy, true)
    -- self:HandleMessage(self.UPDATE)
end

function SS_Switch2FBF_Dialog:OnValidate()
	if (not self:Validate(self.interval, 1, 999)) then
		return false
	end
	return true
end

function SS_Switch2FBF_Dialog:OnOK()
    SS_Switch2FBF.fbf_interval = self.interval:IntValue()
    SS_Switch2FBF.SORTBy = self.sortbymode:FirstCheckedMsg()
    SS_Switch2FBF.sort_by_toptobot = (SS_Switch2FBF.SORTBy == SS_Switch2FBF_Dialog.SORTTOP)
end


-- -------------------------------
-- Main
-- -------------------------------

function SS_Switch2FBF:Run(moho)

    local switch_layer, switch_frame, sublayer_count
    SS_Switch2FBF.start_frame = moho.document:StartFrame()

	local dlog = SS_Switch2FBF_Dialog:new(moho)
    if (dlog:DoModal() ~= LM.GUI.MSG_OK) then
		return false  -- Cancelled so Quit
    end

    switch_layer = moho:LayerAsSwitch(moho.layer)
    switch_layer:SetFBFLayer(true)
    sublayer_count = switch_layer:CountLayers() -1
    for i_sublayer = 0, sublayer_count do
        switch_frame = SS_Switch2FBF.start_frame + (i_sublayer * SS_Switch2FBF.fbf_interval)
        if (SS_Switch2FBF.sort_by_toptobot) then
            switch_layer:SetValue(switch_frame, switch_layer:Layer(sublayer_count - i_sublayer):Name()) -- top to bottom
        else
            switch_layer:SetValue(switch_frame, switch_layer:Layer(i_sublayer):Name()) -- bottom to top
        end
    end

end