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
    return 'SimplSam'
end

function SS_Switch2FBF:Description()
    return 'Convert the layers in a Switch group to Frame-by-Frame'
end

------------------------------------------

function SS_Switch2FBF:IsEnabled(moho)
    return (moho.layer:LayerType() == MOHO.LT_SWITCH)
end

function SS_Switch2FBF:Run(moho)

    local fbf_interval = 1         --< Set Frame by Frame interval
    local sort_by_toptobot = true  --< Set false for Bottom to Top

    local switch_layer, switch_frame, sublayer_count
    switch_layer = moho:LayerAsSwitch(moho.layer)
    switch_layer:SetFBFLayer(true)
    sublayer_count = switch_layer:CountLayers() -1
    for i_sublayer = 0, sublayer_count do
        switch_frame = 1 + (i_sublayer * fbf_interval)
        if (sort_by_toptobot) then
            switch_layer:SetValue(switch_frame, switch_layer:Layer(sublayer_count - i_sublayer):Name()) -- top to bottom
        else
            switch_layer:SetValue(switch_frame, switch_layer:Layer(i_sublayer):Name()) -- bottom to top
        end
    end
end