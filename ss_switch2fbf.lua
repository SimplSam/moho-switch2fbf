-- -------------------------------
-- Intro
-- -------------------------------

ScriptName = "SS_Switch2FBF"

-- SS_Switch2FBF - Convert/translate a set of layers in a Switch group, into a series of Frame-by-Frame frames.
-- version:	MH12/13 001.2 #5101 - by Sam Cogheil (SimplSam)

--[[ ***** Licence & Warranty *****

	This work is licensed under a GNU General Public License v3.0 license
	Please see: https://www.gnu.org/licenses/gpl-3.0.en.html

	You can:
		Usage - Use/Reuse Freely
		Adapt — remix, transform, and build upon the material for any purpose, even commercially
		Share — copy and redistribute the material in any medium or format

	Adapt / Share under the following terms:
		Attribution — You must give appropriate credit, provide a link to the GPL-3.0 license, and
		indicate if changes were made. You may do so in any reasonable manner, but not in any way
		that suggests the licensor endorses you or your use.

        ShareAlike — If you remix, transform, or build upon the material, you must distribute your
        contributions under the same license as this original.

	Warranty:

		Your use of this software material is at your own risk.

		By accepting to use this material you acknowledge that Sam Cogheil / SimplSam
		("The Developer") make no warranties whatsoever - expressed or implied for the
		merchantability or fitness for a particular purpose of the software provided.

		The Developer will not be liable for any direct, indirect or consequential loss
		of actual or anticipated - data, revenue, profits, business, trade or goodwill
		that is suffered as a result of the use of the software provided.

--]]


--[[
	***** SPECIAL THANKS to:
	*    Stan (and team) @ MOHO Scripting -- http://mohoscripting.com
	*    The friendly faces @ Lost Marble Moho forum -- https://www.lostmarble.com/forum
	*****
]]


-- -------------------------------
-- Script config
-- -------------------------------

SS_Switch2FBF = {}

function SS_Switch2FBF:Name()
    return 'SS Switch to FBF'
end

function SS_Switch2FBF:Version()
    return '1.2'
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

SS_Switch2FBF.fbfInterval = 1         -- Frame by Frame interval
SS_Switch2FBF.sortByToptobot = true   -- If false Bottom to Top
SS_Switch2FBF.sortBy = SS_Switch2FBF_Dialog.SORTTOP
SS_Switch2FBF.startFrame  = 1         -- 1st animation frame

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
        l:Pop() --V
    l:Pop() --H
    return d
end

function SS_Switch2FBF_Dialog:UpdateWidgets()
    self.interval:SetValue(SS_Switch2FBF.fbfInterval)
    self.sortbymode:SetChecked(SS_Switch2FBF.sortBy, true)
    -- self:HandleMessage(self.UPDATE)
end

function SS_Switch2FBF_Dialog:OnValidate()
	if (not self:Validate(self.interval, 1, 999)) then
		return false
	end
	return true
end

function SS_Switch2FBF_Dialog:OnOK()
    SS_Switch2FBF.fbfInterval = self.interval:IntValue()
    SS_Switch2FBF.sortBy = self.sortbymode:FirstCheckedMsg()
    SS_Switch2FBF.sortByToptobot = (SS_Switch2FBF.sortBy == SS_Switch2FBF_Dialog.SORTTOP)
end


-- -------------------------------
-- Main
-- -------------------------------

function SS_Switch2FBF:Run(moho)

    local switchLayer, switchFrame, sublayerCount
    SS_Switch2FBF.startFrame = moho.document:StartFrame()

	local dlog = SS_Switch2FBF_Dialog:new(moho)
    if (dlog:DoModal() ~= LM.GUI.MSG_OK) then
		return false  -- Cancelled so Quit
    end

    switchLayer = moho:LayerAsSwitch(moho.layer)
    switchLayer:SetFBFLayer(true)
    sublayerCount = switchLayer:CountLayers() -1
    for iSublayer = 0, sublayerCount do
        switchFrame = SS_Switch2FBF.startFrame + (iSublayer * SS_Switch2FBF.fbfInterval)
        if (SS_Switch2FBF.sortByToptobot) then
            switchLayer:SetValue(switchFrame, switchLayer:Layer(sublayerCount - iSublayer):Name()) -- top to bottom
        else
            switchLayer:SetValue(switchFrame, switchLayer:Layer(iSublayer):Name()) -- bottom to top
        end
    end

end