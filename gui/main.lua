--- Init GUI and add Logistics View main button
function initGUI(player)
    if not player.gui.top["logistics-view-button"] then
        player.gui.top.add({type = "button", name = "logistics-view-button", style = "lv_button_main_icon"})        
    end
end

--- Create the GUI
function createGUI(player, index)
    
    local guiPos = global.settings[index].guiPos
    if player.gui[guiPos].logisticsFrame ~= nil then
        player.gui[guiPos].logisticsFrame.destroy()
    end
    if global.guiVisible[index] == 0 and player.gui[guiPos].logisticsFrame == nil then
        local currentTab = global.currentTab[index] or "logistics"
        local buttonStyle = currentTab == 'logistics' and "_selected" or ""

        -- main frame
        local logisticsFrame = player.gui[guiPos].add({type = "frame", name = "logisticsFrame", direction = "vertical", style = "lv_frame"})
        local titleFlow = logisticsFrame.add({type = "flow", name = "titleFlow", direction = "horizontal"})
        titleFlow.add({type = "button", name = "logistics-view-close", caption = {"logistics-view-close"}, style = "lv_button_close"})
        titleFlow.add({type = "label", name="titleLabel", style = "lv_title_label", caption = {"logistics-view"}})        

        -- menu flow
        local menuFlow = logisticsFrame.add({type = "flow", name = "menuFlow", direction = "horizontal"})
        menuFlow.add({type = "button", name = "logisticsMenuBtn", caption = {"logistics-items-button"}, style = "lv_button" .. buttonStyle})
        buttonStyle = currentTab == 'normal' and "_selected" or ""
        menuFlow.add({type = "button", name = "normalMenuBtn", caption = {"normal-items-button"}, style = "lv_button" .. buttonStyle})
        buttonStyle = (currentTab == 'networks' or currentTab == 'networkInfo') and "_selected" or ""
        menuFlow.add({type = "button", name = "networksMenuBtn", caption = {"networks"}, style = "lv_button" .. buttonStyle})        
        buttonStyle = currentTab == 'settings' and "_selected" or ""
        menuFlow.add({type = "button", name = "settingsMenuBtn", caption = {"settings-button"}, style = "lv_button" .. buttonStyle})

        -- content frame
        local contentFrame = logisticsFrame.add({type = "frame", name = "contentFrame", style = "lv_items_frame", direction = "vertical"})
        local infoFlow = contentFrame.add({type = "flow", name = "infoFlow", style = "lv_info_flow", direction = "horizontal"})
        updateGUI(player, index, currentTab)
    end
end

--- Show the GUI
function showGUI(player, index)
    if global.guiVisible[index] == 0 then
        local currentTab = (global.currentTab[index] == "settings") and "logistics" or global.currentTab[index]
        global.currentTab[index] = currentTab
        
        createGUI(player, index)

        -- hide settings gui
        hideSettings(player, index)

        global.guiVisible[index] = 1
    end
end

--- Hide the GUI
function hideGUI(player, index)
    local guiPos = global.settings[index].guiPos
    if player.gui[guiPos].logisticsFrame ~= nil then
        player.gui[guiPos].logisticsFrame.style = "lv_frame_hidden"
        global.guiVisible[index] = 0
    end
end

--- Destroy the GUI
function destroyGUI(player, index)
    local guiPos = global.settings[index].guiPos
    if player.gui.top["logistics-view-button"] ~= nil then
        player.gui.top["logistics-view-button"].destroy()
    end
end

--- Update main gui content
function updateGUI(player, index, tab)
    local currentTab = tab or global.currentTab[index]
    local force = player.force 
    
    if currentTab == "logistics" then
        local items = getLogisticsItems(force, index)
        updateItemsTable(items, player, index)
    elseif currentTab == "normal" then
        local items = getNormalItems(force)
        updateItemsTable(items, player, index)
    elseif currentTab == "disconnected" then
        showDisconnectedInfo(player, index) 
    elseif currentTab == "itemInfo" then
        local item = global.currentItem[index]
        if item then
            showItemInfo(item, player, index)
        end        
    elseif currentTab == "networks" then
        if not global.networkEdit[index] then
            showNetworksInfo(player, index)
        end    
    elseif currentTab == "networkInfo" then
        local network = global.currentNetwork[index]
        if network then
            showNetworkInfo(network, player, index)
        end
    end
end

--- Clear main content gui
function clearGUI(player, index)
    local guiPos = global.settings[index].guiPos
    local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame

    if contentFrame and contentFrame.children_names ~= nil then
        for _,child in pairs(contentFrame.children_names) do
            if contentFrame[child] ~= nil then
                contentFrame[child].destroy()
            end
        end
    end

end

--- Clear menu selection
function clearMenu(player, index)
    local guiPos = global.settings[index].guiPos
    local menuFlow = player.gui[guiPos].logisticsFrame.menuFlow
    if menuFlow and menuFlow.children_names ~= nil then
        for _,btnName in pairs(menuFlow.children_names) do
            if menuFlow[btnName] ~= nil then
                local btn = menuFlow[btnName]
                btn.style = "lv_button"
            end
        end
    end
end

--- Reset menu selection to the specified tab or the current globalal tab
function resetMenu(player, index, tab)
    local tab = tab or global.currentTab[index]
    local guiPos = global.settings[index].guiPos
    local menuFlow = player.gui[guiPos].logisticsFrame.menuFlow
    if menuFlow and menuFlow.children_names ~= nil then
        for _,btnName in pairs(menuFlow.children_names) do
            if menuFlow[btnName] ~= nil then
                local btn = menuFlow[btnName]
                local btnTab = string.gsub(btnName, "MenuBtn", "")
                if btnTab == tab then
                    btn.style = "lv_button_selected"
                else
                    btn.style = "lv_button"
                end
            end
        end
    end
end