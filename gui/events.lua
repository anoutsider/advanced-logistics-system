--- GUI Events
game.onevent(defines.events.onguiclick, function(event)

    local index = event.playerindex
    local player = game.players[index]

    -- main button click event - show/hide gui
    if event.element.name == "logistics-view-button" then

        local visible = glob.guiVisible[index]
        
        --- reset player position if in location view mode
        local locationFlow = player.gui.center.locationFlow
        if locationFlow ~= nil and player.character.name == "ls-controller" then
            resetPosition(player, index)
        end

        if visible == 0 then
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
        local currentTab = glob.currentTab[index]
        local newTab = string.gsub(name, "MenuBtn", "")

        if event.element.style.name == "lv_button_selected" and newTab == currentTab then
            return
        else
            local menuFlow = player.gui[glob.settings[index].guiPos].logisticsFrame.menuFlow
            for _,btnName in pairs(menuFlow.childrennames) do
                if btnName:find("MenuBtn") ~= nil then
                    local btnTab = string.gsub(btnName, "MenuBtn", "")
                    local btn = menuFlow[btnName]

                    if newTab ~= "settings" then
                        if btnTab == newTab then
                            btn.style = "lv_button_selected"
                        else
                            btn.style = "lv_button"
                        end
                    end
                end
            end
        end

        if newTab ~= "settings" then
            glob.currentTab[index] = newTab
        end

        if (newTab == "logistics" or newTab == "normal") and (currentTab == "logistics" or currentTab == "normal") then
            updateGUI(player, index, newTab)
        elseif (currentTab == "itemInfo" or currentTab == "disconnected") and (newTab == "logistics" or newTab == "normal") then
            clearGUI(player, index)
            updateGUI(player, index, newTab)

            local searchFrame = player.gui[glob.settings[index].guiPos].logisticsFrame.contentFrame[newTab .. "SearchFrame"]
            local name = newTab == "logistics" and "logistics-search-field" or "normal-search-field"
            local searchTextField = searchFrame[name]
            local searchText = glob.searchText[index][newTab]
            if searchText and searchText ~= ""  then
                searchTextField.text = searchText
            end
        elseif newTab == "settings" then
            hideGUI(player, index)
            showSettings(player, index)
        end

    -- save settings
    elseif event.element.name == "saveSettingsBtn" then

        saveSettings(player, index)

    -- cancel/hide settings
    elseif event.element.name == "cancelSettingsBtn" then

        showGUI(player, index)

    -- guiPos settings checkboxes flow
    elseif event.element.name:find("guiPos_") ~= nil then

        local guiPos = glob.settings[index].guiPos
        local name = event.element.name
        local state = event.element.state
        if state then
            local settingsFrame = player.gui[guiPos].settingsFrame
            local settingsTable = settingsFrame.settingsTable
            local guiPosFlow = settingsTable["guiPosFlow"]

            for _,childName in pairs(guiPosFlow.childrennames) do
                if guiPosFlow[childName] ~= nil then
                    if childName ~= name then
                        guiPosFlow[childName].state = false
                    end
                end
            end
        end

    -- search field ticking event
    elseif event.element.name == "logistics-search-field" then

        local name = event.element.name

        glob.searchTick[index]["logistics"] = event.tick

        onLogisticsSearchTick = function(event)
            local searchTick = glob.searchTick[index]["logistics"]
            local currentTab = glob.currentTab[index]

            if currentTab == "logistics" then
                if searchTick <= event.tick and glob.guiVisible[index] == 1 then
                    local searchFrame = player.gui[glob.settings[index].guiPos].logisticsFrame.contentFrame["logisticsSearchFrame"]
                    local searchText = searchFrame[name].text

                    glob.searchTick[index]["logistics"] = event.tick + 60
                    if searchText ~= nil then
                        if type(searchText) == "string" and searchText ~= "" and string.len(searchText) >= 3 then
                            glob.searchText[index]["logistics"] = searchText
                            updateGUI(player, index)
                        elseif searchText == "" then
                            glob.searchText[index]["logistics"] = false
                            updateGUI(player, index)
                        end
                    end
                end
            end
        end

    -- search field ticking event
    elseif event.element.name == "normal-search-field" then

        local name = event.element.name
        glob.searchTick[index]["normal"] = event.tick

        onNormalSearchTick = function(event)
            local searchTick = glob.searchTick[index]["normal"]
            local currentTab = glob.currentTab[index]

            if currentTab == "normal" then
                if searchTick <= event.tick and glob.guiVisible[index] == 1 then
                    local searchFrame = player.gui[glob.settings[index].guiPos].logisticsFrame.contentFrame["normalSearchFrame"]
                    local searchText = searchFrame[name].text

                    glob.searchTick[index]["normal"] = event.tick + 60
                    if searchText ~= nil then
                        if type(searchText) == "string" and searchText ~= "" and string.len(searchText) >= 3 then
                            glob.searchText[index]["normal"] = searchText
                            updateGUI(player, index)
                        elseif searchText == "" then
                            glob.searchText[index]["normal"] = false
                            updateGUI(player, index)
                        end
                    end
                end
            end
        end
    -- items table columns sorting event
    elseif event.element.name:find("itemSort_") ~= nil  then

        local currentTab = glob.currentTab[index]

        local name = event.element.name
        local style = event.element.style
        local sort_by = string.gsub(name, "itemSort_", "")
        local itemsTable = player.gui[glob.settings[index].guiPos].logisticsFrame.contentFrame.itemsFrame.itemsTable
        local sortFlow = itemsTable[sort_by .. "Flow"][sort_by .. "SortFlow"]
        local sort_dir = sortFlow[sort_by .. "_sort"].style.name
        sort_dir = string.gsub(sort_dir, "lv_sort_", "")

        local isSelected = string.gsub(style.name, "lv_button_" .. sort_by, "")
        local new_sort_by = sort_by
        local new_sort_dir = sort_dir == 'asc' and 'desc' or 'asc'

        if isSelected ~= "_selected" then
            for _,flowName in pairs(itemsTable.childrennames) do
                if flowName:find("Flow") ~= nil then
                    local sortBy = string.gsub(flowName, "Flow", "")
                    local flow = itemsTable[flowName]
                    local sortFlow = itemsTable[flowName][sortBy .. "SortFlow"]

                    if sortBy == sort_by then
                        new_sort_by = sortBy
                        flow["itemSort_" .. sortBy].style = "lv_button_" .. sortBy .. "_selected"
                        sortFlow[sortBy .. "_sort"].style = "lv_sort_" .. new_sort_dir
                    else
                        flow["itemSort_" .. sortBy].style = "lv_button_" .. sortBy
                        sortFlow[sortBy .. "_sort"].style = "lv_sort"
                    end
                end
            end

        end

        glob.sort[index][currentTab] = {by = new_sort_by, dir = new_sort_dir}

        updateGUI(player, index)

    -- items table view info event
    elseif event.element.name:find("viewItemInfo_") ~= nil  then

        local info = {}

        local name = event.element.name
        local item = string.gsub(name, "viewItemInfo_", "")
        glob.currentItem[index] = item

        if item then
            clearMenu(player, index)
            clearGUI(player, index)
            showItemInfo(item, player, index)
        end

    -- item info table columns sorting event
    elseif event.element.name:find("itemInfo_") ~= nil  then

        local currentTab = glob.currentTab[index]
        local currentItem = glob.currentItem[index]
        if currentItem then

            local name = event.element.name
            local style = event.element.style
            local sort_by = string.gsub(name, "itemInfo_", "")
            local itemInfoTable = player.gui[glob.settings[index].guiPos].logisticsFrame.contentFrame.itemInfoFrame.itemInfoTable
            local sortFlow = itemInfoTable[sort_by .. "Flow"][sort_by .. "SortFlow"]
            local sort_dir = sortFlow[sort_by .. "_sort"].style.name
            sort_dir = string.gsub(sort_dir, "lv_sort_", "")

            local isSelected = string.gsub(style.name, "lv_button_" .. sort_by, "")
            local new_sort_by = sort_by
            local new_sort_dir = sort_dir == 'asc' and 'desc' or 'asc'

            if isSelected ~= "_selected" then
                for _,flowName in pairs(itemInfoTable.childrennames) do
                    if flowName:find("Flow") ~= nil then
                        local sortBy = string.gsub(flowName, "Flow", "")
                        local flow = itemInfoTable[flowName]
                        local sortFlow = flow[sortBy .. "SortFlow"]

                        if sortBy == sort_by then
                            new_sort_by = sortBy
                            flow["itemInfo_" .. sortBy].style = "lv_button_" .. sortBy .. "_selected"
                            sortFlow[sortBy .. "_sort"].style = "lv_sort_" .. new_sort_dir
                        else
                            flow["itemInfo_" .. sortBy].style = "lv_button_" .. sortBy
                            sortFlow[sortBy .. "_sort"].style = "lv_sort"
                        end
                    end
                end

            end

            glob.sort[index][currentTab] = {by = new_sort_by, dir = new_sort_dir}

            showItemInfo(currentItem, player, index)
        end

    -- item info table filters event
    elseif event.element.name:find("itemInfoFilter_") ~= nil  then

        local guiPos = glob.settings[index].guiPos
        local currentTab = glob.currentTab[index]
        local currentItem = glob.currentItem[index]
        local filters = glob.itemInfoFilters[index]

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
                        isSelected = string.gsub(style.name, "lv_button_" .. filter_by, "") == "_selected"
                    end

                    if not isSelected then
                        if type == "chests" then
                            if filter_by ~= "all" then
                                if filters[type]["all"] then
                                    filters[type]["all"] = nil
                                end
                                filterFrame["itemInfoFilter_all"].style = "lv_button_all"
                            else
                                for _,frameName in pairs(filterFrame.childrennames) do
                                    if filterFrame[frameName] ~= nil then
                                        local frameFilter = string.gsub(frameName, "itemInfoFilter_", "")
                                        if frameFilter ~= "all" then
                                            filterFrame[frameName].style = "lv_button_" .. frameFilter
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
                            filterFrame["itemInfoFilter_" .. filter_by].style = "lv_button_" .. filter_by
                            if count(filters[type]) == 0 then
                                if not filters[type]["all"] then
                                    filters[type]["all"] = true
                                end
                                filterFrame["itemInfoFilter_all"].style = "lv_button_all_selected"
                            end
                        else
                            if not filters[type][filter_by] then
                                filters[type][filter_by] = true
                            end
                        end
                    end

                    glob.itemInfoFilters[index] = filters
                    showItemInfo(currentItem, player, index)

                end
            end
        end

    -- item info table tools/action events
    elseif event.element.name:find("itemAction_") ~= nil  then

        local force = player.force
        local itemInfo = glob.currentItemInfo[index]
        local style = event.element.style

        local action, key = event.element.name:match("itemAction_([%w%s]*)_([%w_.%s]*)")

        if itemInfo["chests"][key] then
            if action == "teleport" then
                local pos = itemInfo["chests"][key].pos
                local new_pos = game.findnoncollidingposition("player", {pos.x, pos.y}, 10, 1)
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
                    local isSelected = string.gsub(style.name, "lv_button_" .. action, "") == "_selected"

                    if entity.tobedeconstructed(force) and isSelected then
                        entity.canceldeconstruction(force)
                        event.element.style = "lv_button_delete"
                    else
                        entity.orderdeconstruction(force)
                        event.element.style = "lv_button_delete_selected"
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
        showDisconnectedInfo(player, index)

    -- disconnected table columns sorting event
    elseif event.element.name:find("disconnectedInfo_") ~= nil  then

        local currentTab = glob.currentTab[index]
        local name = event.element.name
        local style = event.element.style
        local sort_by = string.gsub(name, "disconnectedInfo_", "")
        local disconnectedTable = player.gui[glob.settings[index].guiPos].logisticsFrame.contentFrame.disconnectedFrame.disconnectedTable
        local sortFlow = disconnectedTable[sort_by .. "Flow"][sort_by .. "SortFlow"]
        local sort_dir = sortFlow[sort_by .. "_sort"].style.name
        sort_dir = string.gsub(sort_dir, "lv_sort_", "")       

        local isSelected = string.gsub(style.name, "lv_button_" .. sort_by, "")
        local new_sort_by = sort_by
        local new_sort_dir = sort_dir == 'asc' and 'desc' or 'asc'      

        if isSelected ~= "_selected" then
            for _,flowName in pairs(disconnectedTable.childrennames) do
                if flowName:find("Flow") ~= nil then
                    local sortBy = string.gsub(flowName, "Flow", "")
                    local flow = disconnectedTable[flowName]
                    local sortFlow = flow[sortBy .. "SortFlow"]

                    if sortBy == sort_by then
                        new_sort_by = sortBy
                        flow["disconnectedInfo_" .. sortBy].style = "lv_button_" .. sortBy .. "_selected"
                        sortFlow[sortBy .. "_sort"].style = "lv_sort_" .. new_sort_dir
                    else
                        flow["disconnectedInfo_" .. sortBy].style = "lv_button_" .. sortBy
                        sortFlow[sortBy .. "_sort"].style = "lv_sort"
                    end
                end
            end

        end

        glob.sort[index][currentTab] = {by = new_sort_by, dir = new_sort_dir}

        showDisconnectedInfo(player, index)
        
    -- disconnected table tools/action events
    elseif event.element.name:find("disconnectedAction_") ~= nil  then

        local force = player.force
        local chests = glob.disconnectedChests[force.name]
        local style = event.element.style

        local action, key = event.element.name:match("disconnectedAction_([%w%s]*)_([%w_.%s]*)")

        if chests[key] then
            if action == "teleport" then
                local pos = chests[key].position
                local new_pos = game.findnoncollidingposition("player", {pos.x, pos.y}, 10, 1)
                if new_pos then
                    player.teleport(new_pos)
                    hideGUI(player, index)
                end
                
            elseif action == "location" then
            
                local pos = chests[key].position
                viewPosition(player, index, pos)
                
            elseif action == "delete" then
                local entity = chests[key]
                local isSelected = string.gsub(style.name, "lv_button_" .. action, "") == "_selected"

                if entity.tobedeconstructed(force) and isSelected then
                    entity.canceldeconstruction(force)
                    event.element.style = "lv_button_delete"
                else
                    entity.orderdeconstruction(force)
                    event.element.style = "lv_button_delete_selected"
                end
                
            elseif action == "apc" or action == "ppc" or action == "sc" or action == "rc" then
                local entity = chests[key]
                local name = codeToName(action)
                upgradeChest(entity, name, player)
            end
        end        
        
    -- location view back button event
    elseif event.element.name == "locationViewBack" then
        
        resetPosition(player, index)
        
    -- pagination event
    else

        local name, page = event.element.name:match("(%w+)_([%w%s]*)")
        local currentTab = glob.currentTab[index]
        name = name or ""
        page = tonumber(page) or ""
        if name == "nextPage" or name == "prevPage" then
            if page >= 1 then
                glob.itemsPage[index][currentTab] = page
                if currentTab == "itemInfo" then
                    local currentItem = glob.currentItem[index]
                    if currentItem then
                        showItemInfo(currentItem, player, index, page)
                    end
                else
                    updateGUI(player, index)
                end
            end
        end
    end

end)
