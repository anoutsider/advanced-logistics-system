--- Custom Input Events
script.on_event("ls-toggle-gui", function(event)

    local index = event.player_index
    local player = game.players[index]
    local visible = global.guiVisible[index]

    --- reset player position if in location view mode
    local locationFlow = player.gui.center.locationFlow
    if locationFlow ~= nil then
        resetPosition(player, index)
    end

    if visible == 0 then
        getLogisticNetworks(player.force)
        getNetworkAtPlayerLocation(player)
        showGUI(player, index)
    else
        hideGUI(player, index)
    end
end)

script.on_event("ls-close-gui", function(event)

    local index = event.player_index
    local player = game.players[index]
    local visible = global.guiVisible[index]

    if visible ~= 0 then
        --- reset player position if in location view mode
        local locationFlow = player.gui.center.locationFlow
        if locationFlow ~= nil then
            resetPosition(player, index)
        end
        hideGUI(player, index)
    end
end)

--- GUI Events

-- Search Events
script.on_event(defines.events.on_gui_text_changed, function(event)

        local index = event.player_index
        local player = game.players[index]
        local visible = global.guiVisible[index]
        local element = event.element
        local search_fields = {
                ["logistics-search-field"]       = { name = "logistics",      update = updateGUI },
                ["normal-search-field"]          = { name = "normal",         update = updateGUI },
                ["networks-filter-search-field"] = { name = "networksFilter", update = updateNetworkFiltersTable },
                ["networks-search-field"]        = { name = "networks",       update = showNetworksInfo }
        }

        if not element or not element.valid then
                return
        end

        local elementName = element.name
        local searchText = element.text or ""
        local field = search_fields[elementName]

        if not field then
                return
        end

        global.searchText[index][field.name] = string.lower(searchText)

        if searchText == "" or string.len(searchText) >= 3 then
                field.update(player, index)
        end
end)

-- network filter events
-- Search Events
script.on_event(defines.events.on_gui_checked_state_changed, function(event)

        local index = event.player_index
        local player = game.players[index]
        local guiPos = global.settings[index].guiPos
        local element = event.element

        handleNetworksFilterListEvent(player, index, element, true)
end)

script.on_event(defines.events.on_gui_click, function(event)

    local index = event.player_index
    local player = game.players[index]

    -- main button click event - show/hide gui
    if event.element.name == "logistics-view-button" then

        local visible = global.guiVisible[index]

        --- reset player position if in location view mode
        local locationFlow = player.gui.center.locationFlow
        if locationFlow ~= nil then
            resetPosition(player, index)
        end

        if visible == 0 then
            getLogisticNetworks(player.force)
            getNetworkAtPlayerLocation(player)
            showGUI(player, index)
        else
            hideGUI(player, index)
        end

    -- close gui button click event
    elseif event.element.name == "logistics-view-close" then

        hideGUI(player, index)

    -- menu buttons event
    elseif event.element.name:find("MenuBtn") ~= nil  then

        local name = event.element.name
        local style = event.element.style
        local currentTab = global.currentTab[index]
        local newTab = string.gsub(name, "MenuBtn", "")

        if event.element.style.name == "als_button_selected" and newTab == currentTab then
            return
        else
            local menuFlow = player.gui[global.settings[index].guiPos].logisticsFrame.menuFlow
            if menuFlow and menuFlow.children_names ~= nil then
                for _,btnName in pairs(menuFlow.children_names) do
                    if btnName:find("MenuBtn") ~= nil then
                        local btnTab = string.gsub(btnName, "MenuBtn", "")
                        local btn = menuFlow[btnName]

                        if newTab ~= "settings" then
                            if btnTab == newTab then
                                btn.style = "als_button_selected"
                            else
                                btn.style = "als_button"
                            end
                        end
                    end
                end
            end
        end

        if newTab ~= "settings" then
            global.currentTab[index] = newTab
        end

        if (newTab == "logistics" or newTab == "normal") and (currentTab == "logistics" or currentTab == "normal") then
            updateGUI(player, index, newTab)
        elseif (currentTab ~= "logistics" or currentTab ~= "normal") and (newTab == "logistics" or newTab == "normal") then
            clearGUI(player, index)
            updateGUI(player, index, newTab)

            local searchFlow = player.gui[global.settings[index].guiPos].logisticsFrame.contentFrame["searchFlow"]
            local searchFrame = searchFlow[newTab .. "SearchFrame"]
            local name = newTab == "logistics" and "logistics-search-field" or "normal-search-field"
            local searchTextField = searchFrame[name]
            local searchText = global.searchText[index][newTab]
            if searchText and searchText ~= "" then
                searchTextField.text = searchText
            end
        elseif newTab == "settings" then
            hideGUI(player, index)
            showSettings(player, index)
        elseif newTab == "networks" then
            clearGUI(player, index)
            showNetworksInfo(player, index)
        end

    -- save settings
    elseif event.element.name == "saveSettingsBtn" then

        saveSettings(player, index)

    -- cancel/hide settings
    elseif event.element.name == "cancelSettingsBtn" then

        showGUI(player, index)

    -- update logistics data button
    elseif event.element.name == "updateLogisticsData" then

        getLogisticNetworks(player.force, true)
        getNetworkAtPlayerLocation(player)
        getDisconnectedChests(player.force)

        showGUI(player, index)

    -- guiPos settings checkboxes flow
    elseif event.element.name:find("guiPos_") ~= nil then

        local guiPos = global.settings[index].guiPos
        local name = event.element.name
        local state = event.element.state
        if state then
            local settingsFrame = player.gui[guiPos].settingsFrame
            local settingsTable = settingsFrame.settingsTable
            local guiPosFlow = settingsTable["guiPosFlow"]

            if guiPosFlow and guiPosFlow.children_names ~= nil then
                for _,childName in pairs(guiPosFlow.children_names) do
                    if guiPosFlow[childName] ~= nil then
                        if childName ~= name then
                            guiPosFlow[childName].state = false
                        end
                    end
                end
            end
        end

    -- items table columns sorting event
    elseif event.element.name:find("itemSort_") ~= nil then

        local currentTab = global.currentTab[index]

        local name = event.element.name
        local style = event.element.style
        local sort_by = string.gsub(name, "itemSort_", "")
        local itemsTable = player.gui[global.settings[index].guiPos].logisticsFrame.contentFrame.itemsFrame.itemsTable
        local sortFlow = itemsTable[sort_by .. "Flow"][sort_by .. "SortFlow"]
        local sort_dir = sortFlow[sort_by .. "_sort"].style.name
        sort_dir = string.gsub(sort_dir, "als_sort_", "")

        local isSelected = string.gsub(style.name, "als_button_" .. sort_by, "")
        local new_sort_by = sort_by
        local new_sort_dir = sort_dir == 'asc' and 'desc' or 'asc'

        if isSelected ~= "_selected" then
            if itemsTable and itemsTable.children_names ~= nil then
                for _,flowName in pairs(itemsTable.children_names) do
                    if flowName:find("Flow") ~= nil then
                        local sortBy = string.gsub(flowName, "Flow", "")
                        local flow = itemsTable[flowName]
                        local sortFlow = itemsTable[flowName][sortBy .. "SortFlow"]

                        if sortBy == sort_by then
                            new_sort_by = sortBy
                            flow["itemSort_" .. sortBy].style = "als_button_" .. sortBy .. "_selected"
                            sortFlow[sortBy .. "_sort"].style = "als_sort_" .. new_sort_dir
                        else
                            flow["itemSort_" .. sortBy].style = "als_button_" .. sortBy
                            sortFlow[sortBy .. "_sort"].style = "als_sort"
                        end
                    end
                end
            end

        end

        global.sort[index][currentTab] = {by = new_sort_by, dir = new_sort_dir}

        updateGUI(player, index)

    -- items table view info event
    elseif event.element.name:find("viewItemInfo_") ~= nil  then

        local name = event.element.name
        local item = string.gsub(name, "viewItemInfo_", "")
        global.currentItem[index] = item

        if item then
            global.itemsPage[index]["itemInfo"] = 1
            clearMenu(player, index)
            clearGUI(player, index)
            showItemInfo(item, player, index)
        end

    -- item info table columns sorting event
    elseif event.element.name:find("itemInfo_") ~= nil  then
        -- disable sorting on tools/info column
        if event.element.name == "itemInfo_tools" then
            return
        end
        local currentTab = global.currentTab[index]
        local currentItem = global.currentItem[index]
        if currentItem then
            local name = event.element.name
            local style = event.element.style
            local sort_by = string.gsub(name, "itemInfo_", "")
            local itemInfoTable = player.gui[global.settings[index].guiPos].logisticsFrame.contentFrame.itemInfoFrame.itemInfoTable
            local sortFlow = itemInfoTable[sort_by .. "Flow"][sort_by .. "SortFlow"]
            local sort_dir = sortFlow[sort_by .. "_sort"].style.name
            sort_dir = string.gsub(sort_dir, "als_sort_", "")

            local isSelected = string.gsub(style.name, "als_button_" .. sort_by, "")
            local new_sort_by = sort_by
            local new_sort_dir = sort_dir == 'asc' and 'desc' or 'asc'

            if isSelected ~= "_selected" then
                if itemInfoTable and itemInfoTable.children_names ~= nil then
                    for _,flowName in pairs(itemInfoTable.children_names) do
                        if flowName:find("Flow") ~= nil then
                            local sortBy = string.gsub(flowName, "Flow", "")
                            local flow = itemInfoTable[flowName]
                            local sortFlow = flow[sortBy .. "SortFlow"]

                            if sortBy == sort_by then
                                new_sort_by = sortBy
                                flow["itemInfo_" .. sortBy].style = "als_button_" .. sortBy .. "_selected"
                                sortFlow[sortBy .. "_sort"].style = "als_sort_" .. new_sort_dir
                            else
                                flow["itemInfo_" .. sortBy].style = "als_button_" .. sortBy
                                sortFlow[sortBy .. "_sort"].style = "als_sort"
                            end
                        end
                    end
                end

            end

            global.sort[index][currentTab] = {by = new_sort_by, dir = new_sort_dir}

            showItemInfo(currentItem, player, index)
        end

    -- item info table filters event
    elseif event.element.name:find("itemInfoFilter_") ~= nil  then

        local guiPos = global.settings[index].guiPos
        local currentTab = global.currentTab[index]
        local currentItem = global.currentItem[index]
        local filters = global.itemInfoFilters[index]

        if currentItem and currentTab == "itemInfo" then

            local name = event.element.name
            local style = event.element.style
            local filter_by = string.gsub(name, "itemInfoFilter_", "")
            local isSelected = false
            local type = "chests"

            local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame
            local filtersFlow = contentFrame["filtersFlow"]

            if filtersFlow ~= nil then

                local filterFrame = type == "chests" and filtersFlow.chestsFilterFrame or filtersFlow.typeFilterFrame
                if filterFrame ~= nil then

                    if style.name == "checkbox_style" then
                        isSelected = event.element.state
                        type = "group"
                    else
                        if filter_by == "all" then
                            isSelected = style.name == "als_button_selected"
                        else
                            isSelected = style.name == "als_item_icon_small_selected"
                        end
                    end

                    if not isSelected then
                        if type == "chests" then
                            if filter_by ~= "all" then
                                if filters[type]["all"] then
                                    filters[type]["all"] = nil
                                end
                                filterFrame["itemInfoFilter_all"].style = "als_button_all"
                            else
                                for _,frameName in pairs(filterFrame.children_names) do
                                    if filterFrame[frameName] ~= nil then
                                        local frameFilter = string.gsub(frameName, "itemInfoFilter_", "")
                                        if frameFilter ~= "all" and frameFilter ~= nil then
                                            filterFrame[frameName].style = "als_item_icon_small"
                                            filters[type][frameFilter] = nil
                                        end
                                    end
                                end
                            end

                            if not filters[type][filter_by] then
                                filters[type][filter_by] = true
                            end
                            filterFrame["itemInfoFilter_" .. filter_by].style = style.name .. "_selected"
                        else
                            if filters[type][filter_by] then
                                filters[type][filter_by] = nil
                                if count(filters[type]) == 0 then
                                    if filter_by == "logistics" then
                                        filters[type]["normal"] = true
                                        if filterFrame["itemInfoFilter_normal"] ~= nil then
                                            filterFrame["itemInfoFilter_normal"].state = true
                                        end
                                    else
                                        filters[type]["logistics"] = true
                                        if filterFrame["itemInfoFilter_normal"] ~= nil then
                                            filterFrame["itemInfoFilter_logistics"].state = true
                                        end
                                    end
                                end
                            end
                        end
                    else
                        if type == "chests" then
                            if filters[type][filter_by] then
                                filters[type][filter_by] = nil
                            end
                            filterFrame["itemInfoFilter_" .. filter_by].style = "als_item_icon_small"
                            if count(filters[type]) == 0 then
                                if not filters[type]["all"] then
                                    filters[type]["all"] = true
                                end
                                filterFrame["itemInfoFilter_all"].style = "als_button_all_selected"
                            end
                        else
                            if not filters[type][filter_by] then
                                filters[type][filter_by] = true
                            end
                        end
                    end

                    global.itemInfoFilters[index] = filters
                    showItemInfo(currentItem, player, index)

                end
            end
        end

    -- item info table tools/action events
    elseif event.element.name:find("itemAction_") ~= nil  then

        local force = player.force
        local surface = player.surface
        local itemInfo = global.currentItemInfo[index]
        local style = event.element.style

        local action, key = event.element.name:match("itemAction_([%w%s]*)_([%w_.%s]*)")

        if itemInfo["chests"][key] then
            if action == "teleport" then
                local pos = itemInfo["chests"][key].pos
                local new_pos = surface.find_non_colliding_position("player", {pos.x, pos.y}, 10, 1)
                if new_pos then
                    player.teleport(new_pos)
                    hideGUI(player, index)
                end

            elseif action == "location" then

                local pos = itemInfo["chests"][key].pos
                viewPosition(player, index, pos)

            elseif action == "delete" then
                if itemInfo["chests"][key]["entity"] then
                    local entity = itemInfo["chests"][key]["entity"]
                    local isSelected = string.gsub(style.name, "als_button_" .. action, "") == "_selected"

                    if entity.to_be_deconstructed(force) and isSelected then
                        entity.cancel_deconstruction(force)
                        event.element.style = "als_button_delete"
                    else
                        entity.order_deconstruction(force)
                        event.element.style = "als_button_delete_selected"
                    end
                end
            elseif action == "apc" or action == "ppc" or action == "sc" or action == "rc" then
                if itemInfo["chests"][key]["entity"] then
                    local entity = itemInfo["chests"][key]["entity"]
                    local name = codeToName(action)
                    upgradeChest(entity, name, player)
                end
            end
        end

    -- view disconnected event
    elseif event.element.name == "disconnectedFrameView" then
        clearMenu(player, index)
        clearGUI(player, index)
        checkDisconnectedChests(player.force)
        showDisconnectedInfo(player, index)

    -- disconnected table columns sorting event
    elseif event.element.name:find("disconnectedInfo_") ~= nil  then
        -- disable sorting on tools/info column
        if event.element.name == "disconnectedInfo_tools" then
            return
        end
        local currentTab = global.currentTab[index]
        local name = event.element.name
        local style = event.element.style
        local sort_by = string.gsub(name, "disconnectedInfo_", "")
        local disconnectedTable = player.gui[global.settings[index].guiPos].logisticsFrame.contentFrame.disconnectedFrame.disconnectedTable
        local sortFlow = disconnectedTable[sort_by .. "Flow"][sort_by .. "SortFlow"]
        local sort_dir = sortFlow[sort_by .. "_sort"].style.name
        sort_dir = string.gsub(sort_dir, "als_sort_", "")

        local isSelected = string.gsub(style.name, "als_button_" .. sort_by, "")
        local new_sort_by = sort_by
        local new_sort_dir = sort_dir == 'asc' and 'desc' or 'asc'

        if isSelected ~= "_selected" then
            if disconnectedTable and disconnectedTable.children_names ~= nil then
                for _,flowName in pairs(disconnectedTable.children_names) do
                    if flowName:find("Flow") ~= nil then
                        local sortBy = string.gsub(flowName, "Flow", "")
                        local flow = disconnectedTable[flowName]
                        local sortFlow = flow[sortBy .. "SortFlow"]

                        if sortBy == sort_by then
                            new_sort_by = sortBy
                            flow["disconnectedInfo_" .. sortBy].style = "als_button_" .. sortBy .. "_selected"
                            sortFlow[sortBy .. "_sort"].style = "als_sort_" .. new_sort_dir
                        else
                            flow["disconnectedInfo_" .. sortBy].style = "als_button_" .. sortBy
                            sortFlow[sortBy .. "_sort"].style = "als_sort"
                        end
                    end
                end
            end

        end

        global.sort[index][currentTab] = {by = new_sort_by, dir = new_sort_dir}

        showDisconnectedInfo(player, index)

    -- disconnected table tools/action events
    elseif event.element.name:find("disconnectedAction_") ~= nil  then

        local force = player.force
        local surface = player.surface
        local chests = global.disconnectedChests[force.name]
        local style = event.element.style

        local action, key = event.element.name:match("disconnectedAction_([%w%s]*)_([%w_.%s]*)")

        if chests and chests[key] then
            if action == "teleport" then
                local pos = chests[key].position
                local new_pos = surface.find_non_colliding_position("player", {pos.x, pos.y}, 10, 1)
                if new_pos then
                    player.teleport(new_pos)
                    hideGUI(player, index)
                end

            elseif action == "location" then

                local pos = chests[key].position
                viewPosition(player, index, pos)

            elseif action == "delete" then
                local entity = chests[key]
                local isSelected = string.gsub(style.name, "als_button_" .. action, "") == "_selected"

                if entity.to_be_deconstructed(force) and isSelected then
                    entity.cancel_deconstruction(force)
                    event.element.style = "als_button_delete"
                else
                    entity.order_deconstruction(force)
                    event.element.style = "als_button_delete_selected"
                end

            elseif action == "apc" or action == "ppc" or action == "sc" or action == "rc" then
                local entity = chests[key]
                local name = codeToName(action)
                upgradeChest(entity, name, player)
            end
        end

    -- disconnected table filters event
    elseif event.element.name:find("disconnectedFilter_") ~= nil  then
        local guiPos = global.settings[index].guiPos
        local currentTab = global.currentTab[index]

        if currentTab == "disconnected" then
            local filters = global.disconnectedFilters[index]
            local name = event.element.name
            local style = event.element.style
            local filter_by = string.gsub(name, "disconnectedFilter_", "")
            local isSelected = false
            local type = "chests"

            local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame
            local filtersFlow = contentFrame["filtersFlow"]

            if filtersFlow ~= nil then

                local filterFrame = filtersFlow.chestsFilterFrame
                if filterFrame ~= nil then

                    if filter_by == "all" then
                        isSelected = style.name == "als_button_all_selected"
                    else
                        isSelected = style.name == "als_item_icon_small_selected"
                    end

                    if not isSelected then
                        if type == "chests" then
                            if filter_by ~= "all" then
                                if filters[type]["all"] then
                                    filters[type]["all"] = nil
                                end
                                filterFrame["disconnectedFilter_all"].style = "als_button_all"
                            else
                                for _,frameName in pairs(filterFrame.children_names) do
                                    if filterFrame[frameName] ~= nil and frameName:find("disconnectedFilter_") ~= nil then
                                        local frameFilter = string.gsub(frameName, "disconnectedFilter_", "")
                                        if frameFilter ~= "all" then
                                            filterFrame[frameName].style = "als_item_icon_small"
                                            filters[type][frameFilter] = nil
                                        end
                                    end
                                end
                            end

                            if not filters[type][filter_by] then
                                filters[type][filter_by] = true
                            end
                            filterFrame["disconnectedFilter_" .. filter_by].style = style.name .. "_selected"
                        end
                    else
                        if type == "chests" then
                            if filters[type][filter_by] then
                                filters[type][filter_by] = nil
                            end
                            filterFrame["disconnectedFilter_" .. filter_by].style = "als_item_icon_small"
                            if count(filters[type]) == 0 then
                                if not filters[type]["all"] then
                                    filters[type]["all"] = true
                                end
                                filterFrame["disconnectedFilter_all"].style = "als_button_all_selected"
                            end
                        end
                    end

                    global.disconnectedFilters[index] = filters
                    showDisconnectedInfo(player, index)

                end
            end
        end

    -- location view back button event
    elseif event.element.name == "locationViewBack" then

        resetPosition(player, index)

    -- networks view button event
    elseif event.element.name == "networksFrameView" then

        global.currentTab[index] = "networks"
        resetMenu(player, index)
        clearGUI(player, index)
        showNetworksInfo(player, index)

    -- networks filter button event
    elseif event.element.name == "networkFiltersFrameView" then

        hideGUI(player, index)
        showNetworksFilter(player, index)

    elseif event.element.name == "networkFiltersFrameViewAll" then

        global.networksFilter[index] = {}
        updateGUI(player, index)

    elseif event.element.name == "networkFiltersFrameViewCurrent" then

        local currentPlayerNetwork = global.currentPlayerNetwork[index]

        if currentPlayerNetwork ~= nil then
          global.networksFilter[index] = {[currentPlayerNetwork] = true}
          updateGUI(player, index)
        end

    -- networks table columns sorting event
    elseif event.element.name:find("networkInfo_") ~= nil  then
        -- disable sorting on tools/info column
        if event.element.name == "networkInfo_tools" then
            return
        end
        local currentTab = global.currentTab[index]
        local currentNetwork = global.currentNetwork[index]
        local name = event.element.name
        local style = event.element.style
        local sort_by = string.gsub(name, "networkInfo_", "")
        local frameName = currentTab == "networks" and "networksFrame" or "networkFrame"
        local tableName = currentTab == "networks" and "networksTable" or "networkTable"
        local networksTable = player.gui[global.settings[index].guiPos].logisticsFrame.contentFrame[frameName][tableName]
        local sortFlow = networksTable[sort_by .. "Flow"][sort_by .. "SortFlow"]
        local sort_dir = sortFlow[sort_by .. "_sort"].style.name
        sort_dir = string.gsub(sort_dir, "als_sort_", "")

        local isSelected = string.gsub(style.name, "als_button_" .. sort_by, "")
        local new_sort_by = sort_by
        local new_sort_dir = sort_dir == 'asc' and 'desc' or 'asc'

        if isSelected ~= "_selected" then
            if networksTable and networksTable.children_names ~= nil then
                for _,flowName in pairs(networksTable.children_names) do
                    if flowName:find("Flow") ~= nil then
                        local sortBy = string.gsub(flowName, "Flow", "")
                        local flow = networksTable[flowName]
                        local sortFlow = flow[sortBy .. "SortFlow"]

                        if sortBy == sort_by then
                            new_sort_by = sortBy
                            flow["networkInfo_" .. sortBy].style = "als_button_" .. sortBy .. "_selected"
                            sortFlow[sortBy .. "_sort"].style = "als_sort_" .. new_sort_dir
                        else
                            flow["networkInfo_" .. sortBy].style = "als_button_" .. sortBy
                            sortFlow[sortBy .. "_sort"].style = "als_sort"
                        end
                    end
                end
            end

        end

        global.sort[index][currentTab] = {by = new_sort_by, dir = new_sort_dir}

        if currentTab == "networks" then
            showNetworksInfo(player, index)
        else
            showNetworkInfo(currentNetwork, player, index)
        end


    -- networks table name column edit event
    elseif event.element.name:find("networkInfoNameEdit_") ~= nil  then

        global.networkEdit[index] = true
        event.element.style = "als_button_hidden"

        local name = event.element.name
        local key = string.gsub(name, "networkInfoNameEdit_", "")
        local networksTable = player.gui[global.settings[index].guiPos].logisticsFrame.contentFrame.networksFrame.networksTable
        local nameFlow = networksTable["networkInfoName_" .. key]
        local nameLabel = nameFlow["networkInfoNameValueFL_" .. key]["networkInfoNameLabel_" .. key]
        local confirmBtn = nameFlow["networkInfoNameEditFL_" .. key]["networkInfoNameConfirm_" .. key]
        local value = nameLabel.caption


        nameLabel.style = "als_network_name_hidden"
        local nameEdit = nameFlow["networkInfoNameValueFL_" .. key].add({type = "textfield", name = "networkInfoNameValue_" .. key, text = value })
        nameEdit.text = value
        confirmBtn.style = "als_button_confirm"

    -- networks table name column save event
    elseif event.element.name:find("networkInfoNameConfirm_") ~= nil  then

        local names = global.networksNames[player.force.name]
        local name = event.element.name
        local key = string.gsub(name, "networkInfoNameConfirm_", "")
        local networksTable = player.gui[global.settings[index].guiPos].logisticsFrame.contentFrame.networksFrame.networksTable
        local nameFlow = networksTable["networkInfoName_" .. key]
        local nameLabel = nameFlow["networkInfoNameValueFL_" .. key]["networkInfoNameLabel_" .. key]
        local nameEdit = nameFlow["networkInfoNameValueFL_" .. key]["networkInfoNameValue_" .. key]
        local editBtn = nameFlow["networkInfoNameEditFL_" .. key]["networkInfoNameEdit_" .. key]
        local value = nameEdit.text

        nameLabel.caption = value
        nameEdit.destroy()
        nameLabel.style = "label_style"

        event.element.style = "als_button_hidden"
        editBtn.style = "als_button_edit"
        names[key] = value
        global.networksNames[player.force.name] = names
        global.networkEdit[index] = false

    -- network info view event
    elseif event.element.name:find("networkInfoView_") ~= nil  then

        local name = event.element.name
        local network = string.gsub(name, "networkInfoView_", "")
        global.currentNetwork[index] = network

        if network then
            clearGUI(player, index)
            showNetworkInfo(network, player, index)
        end


    -- network info table tools/action events
    elseif event.element.name:find("networkAction_") ~= nil  then

        local force = player.force
        local surface = player.surface
        local networks = global.networks[force.name]
        local net = global.currentNetwork[index]
        local network = networks[net]

        if network then
            local style = event.element.style

            local action, key = event.element.name:match("networkAction_([%w%s]*)_([%w_.%s]*)")
            key = tonumber(key)
            if network["cells"][key] then
                if action == "teleport" then
                    local pos = network["cells"][key].pos
                    local new_pos = surface.find_non_colliding_position("player", {pos.x, pos.y}, 10, 1)
                    if new_pos then
                        player.teleport(new_pos)
                        hideGUI(player, index)
                    end

                elseif action == "location" then

                    local pos = network["cells"][key].pos
                    viewPosition(player, index, pos)
                end
            end
        end

    -- network filters apply
    elseif event.element.name == "applyFiltersBtn" then

        applyNetworkFilters(player, index)

    -- network filters cancel
    elseif event.element.name == "cancelFiltersBtn" then
        local guiPos = global.settings[index].guiPos
        local networksFilterFrame = player.gui[guiPos].networksFilterFrame
        if networksFilterFrame ~= nil then
            networksFilterFrame.destroy()
        end
        showGUI(player, index)

    -- network filters list name click
    elseif event.element.name:find("networksName_") ~= nil then
    local guiPos = global.settings[index].guiPos
    local name = event.element.name
    local key = string.gsub(name, "networksName_", "")
        local networksFilterFrame = player.gui[guiPos].networksFilterFrame
        local networksTable = networksFilterFrame.networksTableWrapper.networksTable
        local networksAllCheck = networksFilterFrame.networksAllTable.allFilterFlow["networksFilter_all"]
        local checkElementId = "networksFilter_" .. key
        local checkElement = false

        if key == "all" then
                checkElement = networksAllCheck
        else
                checkElement = networksTable[checkElementId]
        end


        if checkElement and checkElement ~= nil then
                handleNetworksFilterListEvent(player, index, checkElement, true)
        end

    -- pagination event
    else

        local name, page = event.element.name:match("(%w+)_([%w%s]*)")
        local currentTab = global.currentTab[index]
        name = name or ""
        page = tonumber(page) or ""
        if name == "nextPage" or name == "prevPage" then
            if page >= 1 then
                global.itemsPage[index][currentTab] = page
                if currentTab == "itemInfo" then
                    local currentItem = global.currentItem[index]
                    if currentItem then
                        showItemInfo(currentItem, player, index, page)
                    end
                elseif currentTab == "networkInfo" then
                    local currentNetwork = global.currentNetwork[index]
                    if currentNetwork then
                        showNetworkInfo(currentNetwork, player, index, page)
                    end
                else
                    updateGUI(player, index)
                end
            end
        end
    end

end)
