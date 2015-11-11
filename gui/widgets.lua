--- Show search frame
function addSearchWidget(player, index)
    local guiPos = global.settings[index].guiPos
    local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame
    local currentTab = global.currentTab[index]
    local searchText = global.searchText[index][currentTab]

    for _,tab in pairs(global.guiTabs) do
        if tab ~= currentTab and contentFrame[tab .. "SearchFrame"] ~= nil then
           contentFrame[tab .. "SearchFrame"].style = "lv_search_frame_hidden"
        end
    end

    --add search frame
    local searchFrame = contentFrame[currentTab .. "SearchFrame"]
    if searchFrame == nil then
        searchFrame = contentFrame.add({type = "frame", name = currentTab .. "SearchFrame", style = "lv_search_frame", direction = "horizontal"})
        searchFrame.add({type = "label", name = currentTab .. "SearchFrameLabel", style = "lv_search_label", caption = {"search-label"}})
    end
    searchFrame.style = "lv_search_frame"

    --add search field
    local searchField = contentFrame[currentTab .. "SearchFrame"][currentTab .. "-search-field"]
    if searchField == nil then
        searchField = searchFrame.add({type = "textfield", name = currentTab .. "-search-field", style = "lv_searchfield_style", text = searchText })
    end

end

--- Show items info frame
function addItemsInfoWidget(player, index)
    local guiPos = global.settings[index].guiPos
    local force = player.force.name
    local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame
    local infoFlow = contentFrame["infoFlow"]
    local currentTab = global.currentTab[index]
    local total = currentTab == "logistics" and global.logisticsItemsTotal[force] or global.normalItemsTotal[force]

    if infoFlow == nil then
        infoFlow = contentFrame.add({type = "flow", name = "infoFlow", style = "lv_info_flow", direction = "horizontal"})
    end

    for _,tab in pairs(global.guiTabs) do
        if tab ~= currentTab and infoFlow[tab .. "InfoFrame"] ~= nil then
            infoFlow[tab .. "InfoFrame"].style = "lv_frame_hidden"
        end
    end

    --add info frame
    local infoFrame = infoFlow[currentTab .. "InfoFrame"]
    if infoFrame ~= nil then
        infoFrame.destroy()
    end

    infoFrame = infoFlow.add({type = "frame", name = currentTab .. "InfoFrame", style = "lv_info_frame", direction = "horizontal"})
    infoFrame.add({type = "label", name = currentTab .. "InfoFrameTotalLabel", style = "lv_info_label", caption = {"info-total"}})
    infoFrame.add({type = "label", name = currentTab .. "InfoFrameTotal", style = "label_style", caption = ": " .. number_format(total)})
end

--- Show disconnected chests info frame
function addDisconnectedInfoWidget(player, index)
    local guiPos = global.settings[index].guiPos
    local force = player.force.name
    local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame
    local infoFlow = contentFrame["infoFlow"]
    local currentTab = global.currentTab[index]
    local disconnected = global.disconnectedChests[force]
    local disconnectedCount = count(disconnected)

    if infoFlow == nil then
        infoFlow = contentFrame.add({type = "flow", name = "infoFlow", style = "lv_info_flow", direction = "horizontal"})
    end

    -- remove old disconnected frames
    for _,tab in pairs(global.guiTabs) do
        if tab ~= currentTab and infoFlow[tab .. "DisconnectedFrame"] ~= nil then
            infoFlow[tab .. "DisconnectedFrame"].destroy()
        end
    end

    -- remove disconnected chests info frame
    local disconnectedFrame = infoFlow["disconnectedFrame"]
    if disconnectedFrame ~= nil then
        disconnectedFrame.destroy()
    end

    -- add disconnected chests info frame
    if currentTab == "logistics" and disconnectedCount > 0 then
        disconnectedFrame = infoFlow.add({type = "frame", name = "disconnectedFrame", style = "lv_info_frame", direction = "horizontal"})
        disconnectedFrame.add({type = "label", name = "disconnectedFrameLabel", style = "lv_info_label", caption = {"disconnected-chests"}})
        disconnectedFrame.add({type = "label", name = "disconnectedFrameTotal", style = "label_style", caption = ": " .. disconnectedCount})
        disconnectedFrame.add({type = "button", name = "disconnectedFrameView", caption = {"view"}, style = "lv_button"})
    end
end

--- Show networks info frame
function addNetwroksInfoWidget(player, index, network)
    local guiPos = global.settings[index].guiPos
    local force = player.force.name
    local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame
    local infoFlow = contentFrame["infoFlow"]
    local currentTab = global.currentTab[index]
    local networks = global.networks[force]
    local networksCount = global.networksCount[force]

    if infoFlow == nil then
        infoFlow = contentFrame.add({type = "flow", name = "infoFlow", style = "lv_info_flow", direction = "horizontal"})
    end

    -- remove networks info frame
    local netwroksFrame = infoFlow["netwroksFrame"]
    if netwroksFrame ~= nil then
        netwroksFrame.destroy()
    end

    -- add networks info frame - logistics
    if currentTab == "logistics" and networksCount > 0 then
        netwroksFrame = infoFlow.add({type = "frame", name = "netwroksFrame", style = "lv_info_frame", direction = "horizontal"})
        netwroksFrame.add({type = "label", name = "netwroksFrameLabel", style = "lv_info_label", caption = {"networks"}})
        netwroksFrame.add({type = "label", name = "netwroksFrameTotal", style = "label_style", caption = ": " .. networksCount})
        netwroksFrame.add({type = "button", name = "netwroksFrameView", caption = {"view"}, style = "lv_button"})
    end

    -- add networks info frame - networks
    if (currentTab == "networks" or currentTab == "networkInfo") and networksCount > 0 then

        netwroksFrame = infoFlow.add({type = "frame", name = "netwroksFrame", style = "lv_info_frame", direction = "horizontal"})
        if currentTab == "networks" then
            netwroksFrame.add({type = "label", name = "netwroksFrameLabel", style = "lv_info_label", caption = {"networks"}})
            netwroksFrame.add({type = "label", name = "netwroksFrameTotal", style = "label_style", caption = ": " .. networksCount})
        elseif currentTab == "networkInfo" and network then
            netwroksFrame.add({type = "label", name = "netwroksFrameLabel", style = "lv_info_label", caption = {"network-name"}})
            netwroksFrame.add({type = "label", name = "netwroksFrameTotal", style = "label_style", caption = ": " .. network.name})
        end

        local logFrame = infoFlow["logFrame"]
        if logFrame ~= nil then
            logFrame.destroy()
        end

        local conFrame = infoFlow["conFrame"]
        if conFrame ~= nil then
            conFrame.destroy()
        end

        local chargingFrame = infoFlow["chargingFrame"]
        if chargingFrame ~= nil then
            chargingFrame.destroy()
        end

        local waitingFrame = infoFlow["waitingFrame"]
        if waitingFrame ~= nil then
            waitingFrame.destroy()
        end

        local log_total = 0
        local log_av = 0
        local con_total = 0
        local con_av = 0
        local charging = 0
        local waiting = 0
        if currentTab == "networks" then
            for key,network in pairs(networks) do
                log_total = log_total + network.bots.log.total
                log_av = log_av + network.bots.log.available
                con_total = con_total + network.bots.con.total
                con_av = con_av + network.bots.con.available
                charging = charging + network.charging
                waiting = waiting + network.waiting
            end
        else
            if network then
                log_total = network.bots.log.total
                log_av = network.bots.log.available
                con_total = network.bots.con.total
                con_av = network.bots.con.available
                charging = network.charging
                waiting = network.waiting
            end
        end

        log_total = number_format(log_total)
        log_av = number_format(log_av)
        con_total = number_format(con_total)
        con_av = number_format(con_av)
        charging = number_format(charging)
        waiting = number_format(waiting)

        logFrame = infoFlow.add({type = "frame", name = "logFrame", style = "lv_info_frame", direction = "horizontal"})
        logFrame.add({type = "label", name = "robotsFrameLabelLog", style = "lv_info_label", caption = {"network-log"}})
        logFrame.add({type = "label", name = "robotsFrameTotalLog", style = "label_style", caption = ": " .. log_av .. "/" .. log_total})

        conFrame = infoFlow.add({type = "frame", name = "conFrame", style = "lv_info_frame", direction = "horizontal"})
        conFrame.add({type = "label", name = "robotsFrameLabelCon", style = "lv_info_label", caption = {"network-con"}})
        conFrame.add({type = "label", name = "robotsFrameTotalCon", style = "label_style", caption = ": " .. con_av .. "/" .. con_total})

        chargingFrame = infoFlow.add({type = "frame", name = "chargingFrame", style = "lv_info_frame", direction = "horizontal"})
        chargingFrame.add({type = "label", name = "robotsFrameLabelCharging", style = "lv_info_label", caption = {"network-charging"}})
        chargingFrame.add({type = "label", name = "robotsFrameTotalCharging", style = "label_style", caption = ": " .. charging})

        waitingFrame = infoFlow.add({type = "frame", name = "waitingFrame", style = "lv_info_frame", direction = "horizontal"})
        waitingFrame.add({type = "label", name = "robotsFrameLabelWaiting", style = "lv_info_label", caption = {"network-waiting"}})
        waitingFrame.add({type = "label", name = "robotsFrameTotalWaiting", style = "label_style", caption = ": " .. waiting})
    end
end

--- Show item totals info frame
function addItemTotalsInfoWidget(info, player, index)
    local guiPos = global.settings[index].guiPos
    local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame
    local infoFlow = contentFrame["infoFlow"]
    local currentTab = global.currentTab[index]
    local currentItem = global.currentItem[index]
    local total = info["total"]
    local orderfunc = function(t,a,b) return t[b] < t[a] end

    if infoFlow == nil then
        infoFlow = contentFrame.add({type = "flow", name = "infoFlow", style = "lv_info_flow", direction = "horizontal"})
    end

    --add item name info frame
    local infoFrameName = infoFlow[currentTab .. "infoFrameName"]
    if infoFrameName ~= nil then
        infoFrameName.destroy()
    end

    -- name
    infoFrameName = infoFlow.add({type = "frame", name = currentTab .. "infoFrameName", style = "lv_info_frame", direction = "horizontal"})
    infoFrameName.add({type = "label", name = currentTab .. "infoFrameNameIcon", style = "lv_info_label", caption = {"name"}})
    infoFrameName.add({type = "label", name = currentTab .. "infoFrameNameName", style = "label_style", caption = getLocalisedName(currentItem)})


    --add "all" total info frame
    local infoFrameAll = infoFlow[currentTab .. "InfoFrameAll"]
    if infoFrameAll ~= nil then
        infoFrameAll.destroy()
    end

    -- all
    infoFrameAll = infoFlow.add({type = "frame", name = currentTab .. "InfoFrameAll", style = "lv_info_frame", direction = "horizontal"})
    infoFrameAll.add({type = "label", name = currentTab .. "InfoFrameTotalLabel", style = "lv_info_label", caption = {"info-total"}})
    infoFrameAll.add({type = "label", name = currentTab .. "InfoFrameTotal", style = "label_style", caption = ": " .. number_format(total.all)})

    for k,v in spairs(total, orderfunc) do
        if v > 0 and k ~= "all" then
            local key = k:gsub("^%l", string.upper)
            local infoFrame = infoFlow[currentTab .. "InfoFrame" .. key]
            if infoFrame ~= nil then
                infoFrame.destroy()
            end
            infoFrame = infoFlow.add({type = "frame", name = currentTab .. "InfoFrame" .. key, style = "lv_info_frame", direction = "horizontal"})
            infoFrame.add({type = "label", name = currentTab .. "InfoFrameTotalLabel", style = "lv_info_label", caption = {"info-" .. k}})
            infoFrame.add({type = "label", name = currentTab .. "InfoFrameTotal", style = "label_style", caption = ": " .. number_format(v)})
        end
    end
end

--- Show item info filters
function addItemFiltersWidget(player, index)
    local guiPos = global.settings[index].guiPos
    local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame
    local filtersFlow = contentFrame["filtersFlow"]
    local currentTab = global.currentTab[index]
    local filters = global.itemInfoFilters[index]

    if filtersFlow == nil then
        filtersFlow = contentFrame.add({type = "flow", name = "filtersFlow", style = "lv_info_flow", direction = "horizontal"})
    end

    local typeFilterFrame = filtersFlow["typeFilterFrame"]
    if typeFilterFrame ~= nil then
        typeFilterFrame.destroy()
    end

    local logisticsState = filters["group"]["logistics"] ~= nil
    local normalState = filters["group"]["normal"] ~= nil
    typeFilterFrame = filtersFlow.add({type = "frame", name = "typeFilterFrame", style = "lv_filters_frame", direction = "horizontal"})
    typeFilterFrame.add({type = "label", name = "typeFilterFrameLabel", style = "lv_info_label", caption = {"filters"}})
    typeFilterFrame.add({type = "checkbox", name = "itemInfoFilter_logistics", style = "checkbox_style", caption = {"info-logistics"}, state = logisticsState})
    typeFilterFrame.add({type = "checkbox", name = "itemInfoFilter_normal", style = "checkbox_style", caption = {"info-normal"}, state = normalState})


    local chestsFilterFrame = filtersFlow["chestsFilterFrame"]
    if chestsFilterFrame ~= nil then
        chestsFilterFrame.destroy()
    end

    local buttonStyle = filters["chests"]["all"] ~= nil and "_selected" or ""
    chestsFilterFrame = filtersFlow.add({type = "frame", name = "chestsFilterFrame", style = "lv_filters_frame", direction = "horizontal"})
    chestsFilterFrame.add({type = "button", name = "itemInfoFilter_all", caption = {"all"}, style = "lv_button_all" .. buttonStyle})
    for type,codes in pairs(global.codeToName) do
        for code,name in pairs(codes) do
            if code ~= "name" and code ~= "total" then
                local buttonStyle = filters["chests"][code] ~= nil and "_selected" or ""
                chestsFilterFrame.add({type = "button", name = "itemInfoFilter_" .. code, style = "lv_button_" .. code .. buttonStyle})
            end
        end
    end

end

--- Show network filters info
function addNetworkFiltersWidget(player, index)
    local guiPos = global.settings[index].guiPos
    local force = player.force.name
    local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame
    local filtersFlow = contentFrame["filtersFlow"]
    local networkFiltersFlow = contentFrame["networkFiltersFlow"]
    local currentTab = global.currentTab[index]
    local filters = global.networksFilter[index]
    local filtersCount = count(filters)    
    local names =  global.networksNames[force]
    local maxFiltersList = math.min(filtersCount, 2)

    -- remove network filters info frame
    local networkFiltersFrame = contentFrame["networkFiltersFrame"]
    if currentTab == "itemInfo" then
        networkFiltersFrame = filtersFlow["networkFiltersFrame"]
    end

    if networkFiltersFrame ~= nil then
        networkFiltersFrame.destroy()
    end

    -- add network filters info frame
    if currentTab == "logistics" then

        networkFiltersFrame = contentFrame.add({type = "frame", name = "networkFiltersFrame", style = "lv_info_frame", direction = "horizontal"})
        networkFiltersFrame.add({type = "label", name = "networkFiltersFrameLabel", style = "lv_info_label", caption = {"network-filters"}})

        if filtersCount == 0 then
            networkFiltersFrame.add({type = "label", name = "networkFiltersFrameValueAll", style = "label_style", caption = {"network-all"}})
            networkFiltersFrame.add({type = "button", name = "networkFiltersFrameView", caption = {"filter"}, style = "lv_button"})
        else
            networkFiltersFrame.add({type = "label", name = "networkFiltersFrameCount", style = "lv_info_label", caption = "(" .. filtersCount .. ")"})
            networkFiltersFrame.add({type = "button", name = "networkFiltersFrameView", caption = {"view-filters"}, style = "lv_button"})
        end

    elseif currentTab == "itemInfo" then
        local itemFilters = global.itemInfoFilters[index]

        if itemFilters["group"]["logistics"] ~= nil then
            networkFiltersFrame = filtersFlow.add({type = "frame", name = "networkFiltersFrame", style = "lv_info_frame", direction = "horizontal"})

            networkFiltersFrame.add({type = "label", name = "networkFiltersFrameLabel", style = "lv_info_label", caption = {"networks"}})
            if filtersCount > 0 then           
                networkFiltersFrame.add({type = "label", name = "networkFiltersFrameCount", style = "lv_info_label", caption = "(" .. filtersCount .. ")"})            
            end                
            networkFiltersFrame.add({type = "button", name = "networkFiltersFrameView", caption = {"filter"}, style = "lv_button"})
        end
    end
end