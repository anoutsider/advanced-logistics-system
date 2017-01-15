--- Add items search frame
function addSearchWidget(player, index)
    local guiPos = global.settings[index].guiPos
    local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame
	local searchFlow = contentFrame["searchFlow"]
    local currentTab = global.currentTab[index]
    local searchText = global.searchText[index][currentTab]	
	searchText = searchText and searchText or ""
	
	if searchFlow == nil then
		searchFlow = contentFrame.add({type = "flow", name = "searchFlow", style = "als_info_flow", direction = "horizontal"})
		-- remove old search frame
		local oldSearchFrame = contentFrame[currentTab .. "SearchFrame"]
		if oldSearchFrame ~= nil then
			oldSearchFrame.destroy()
		end
	end
	
    for _,tab in pairs(global.guiTabs) do	
        if tab ~= currentTab and searchFlow[tab .. "SearchFrame"] ~= nil then
			searchFlow[tab .. "SearchFrame"].style = "als_search_frame_hidden"
				
			-- remove old search frame
			local oldSearchFrame = contentFrame[tab .. "SearchFrame"]
			if oldSearchFrame ~= nil then
				oldSearchFrame.destroy()
			end		   
        end
    end

    --add search frame
    local searchFrame = searchFlow[currentTab .. "SearchFrame"]
    if searchFrame == nil then
        searchFrame = searchFlow.add({type = "frame", name = currentTab .. "SearchFrame", style = "als_search_frame", direction = "horizontal"})
        searchFrame.add({type = "label", name = currentTab .. "SearchFrameLabel", style = "als_search_label", caption = {"search-label"}})
    end
    searchFrame.style = "als_search_frame"

    --add search field
    local searchField = searchFlow[currentTab .. "SearchFrame"][currentTab .. "-search-field"]
    if searchField == nil then
        searchField = searchFrame.add({type = "textfield", name = currentTab .. "-search-field", style = "als_searchfield_style", text = searchText })
    end
end

--- Add networks search frame
function addNetworkSearchWidget(player, index)
    local guiPos = global.settings[index].guiPos
    local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame
	local searchFlow = contentFrame["searchFlow"]
    local searchText = global.searchText[index]["networks"]	
	searchText = searchText and searchText or ""
	
	if searchFlow == nil then
		searchFlow = contentFrame.add({type = "flow", name = "searchFlow", style = "als_info_flow", direction = "horizontal"})
	end

    --add search frame
    local searchFrame = searchFlow["networksSearchFrame"]
    if searchFrame == nil then
        searchFrame = searchFlow.add({type = "frame", name = "networksSearchFrame", style = "als_search_frame", direction = "horizontal"})
        searchFrame.add({type = "label", name = "networksSearchFrameLabel", style = "als_search_label", caption = {"search-label"}})
    end

    --add search field
    local searchField = searchFlow["networksSearchFrame"]["networks-search-field"]
    if searchField == nil then
        searchField = searchFrame.add({type = "textfield", name = "networks-search-field", style = "als_searchfield_style", text = searchText })
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
        infoFlow = contentFrame.add({type = "flow", name = "infoFlow", style = "als_info_flow", direction = "horizontal"})
    end

    for _,tab in pairs(global.guiTabs) do
        if tab ~= currentTab and infoFlow[tab .. "InfoFrame"] ~= nil then
            infoFlow[tab .. "InfoFrame"].style = "als_frame_hidden"
        end
    end

    --add info frame
    local infoFrame = infoFlow[currentTab .. "InfoFrame"]
    if infoFrame ~= nil then
        infoFrame.destroy()
    end

    infoFrame = infoFlow.add({type = "frame", name = currentTab .. "InfoFrame", style = "als_info_frame", direction = "horizontal"})
    infoFrame.add({type = "label", name = currentTab .. "InfoFrameTotalLabel", style = "als_info_label", caption = {"info-total"}})
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
        infoFlow = contentFrame.add({type = "flow", name = "infoFlow", style = "als_info_flow", direction = "horizontal"})
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
    if currentTab == "logistics" or currentTab == "disconnected" and disconnectedCount > 0 then
        disconnectedFrame = infoFlow.add({type = "frame", name = "disconnectedFrame", style = "als_info_frame", direction = "horizontal"})
        disconnectedFrame.add({type = "label", name = "disconnectedFrameLabel", style = "als_info_label", caption = {"disconnected-chests"}})
        disconnectedFrame.add({type = "label", name = "disconnectedFrameTotal", style = "label_style", caption = ": " .. disconnectedCount})
		if currentTab == "logistics" then
			disconnectedFrame.add({type = "button", name = "disconnectedFrameView", caption = {"view"}, style = "als_button_small"})
		end
    end
end

--- Show networks info frame
function addNetworksInfoWidget(player, index, network)
    local guiPos = global.settings[index].guiPos
    local force = player.force.name
    local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame
    local infoFlow = contentFrame["infoFlow"]
    local currentTab = global.currentTab[index]
    local networks = global.networks[force]
    local networksCount = global.networksCount[force]

    if infoFlow == nil then
        infoFlow = contentFrame.add({type = "flow", name = "infoFlow", style = "als_info_flow", direction = "horizontal"})
    end

    -- remove networks info frame
    local networksFrame = infoFlow["networksFrame"]
    if networksFrame ~= nil then
        networksFrame.destroy()
    end

    -- add networks info frame - logistics
    if currentTab == "logistics" and networksCount > 0 then
        networksFrame = infoFlow.add({type = "frame", name = "networksFrame", style = "als_info_frame", direction = "horizontal"})
        networksFrame.add({type = "label", name = "networksFrameLabel", style = "als_info_label", caption = {"networks"}})
        networksFrame.add({type = "label", name = "networksFrameTotal", style = "label_style", caption = ": " .. networksCount})
        networksFrame.add({type = "button", name = "networksFrameView", caption = {"view"}, style = "als_button_small"})
    end

    -- add networks info frame - networks
    if (currentTab == "networks" or currentTab == "networkInfo") and networksCount > 0 then

        networksFrame = infoFlow.add({type = "frame", name = "networksFrame", style = "als_info_frame", direction = "horizontal"})
        if currentTab == "networks" then
            networksFrame.add({type = "label", name = "networksFrameLabel", style = "als_info_label", caption = {"networks"}})
            networksFrame.add({type = "label", name = "networksFrameTotal", style = "label_style", caption = ": " .. networksCount})
        elseif currentTab == "networkInfo" and network then
            networksFrame.add({type = "label", name = "networksFrameLabel", style = "als_info_label", caption = {"network-name"}})
            networksFrame.add({type = "label", name = "networksFrameTotal", style = "label_style", caption = ": " .. network.name})
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

        logFrame = infoFlow.add({type = "frame", name = "logFrame", style = "als_info_frame", direction = "horizontal"})
        logFrame.add({type = "label", name = "robotsFrameLabelLog", style = "als_info_label", caption = {"network-log"}, tooltip = {"tooltips.net-log-total"}})
        logFrame.add({type = "label", name = "robotsFrameTotalLog", style = "label_style", caption = ": " .. log_av .. "/" .. log_total})

        conFrame = infoFlow.add({type = "frame", name = "conFrame", style = "als_info_frame", direction = "horizontal"})
        conFrame.add({type = "label", name = "robotsFrameLabelCon", style = "als_info_label", caption = {"network-con"}, tooltip = {"tooltips.net-con-total"}})
        conFrame.add({type = "label", name = "robotsFrameTotalCon", style = "label_style", caption = ": " .. con_av .. "/" .. con_total})

        chargingFrame = infoFlow.add({type = "frame", name = "chargingFrame", style = "als_info_frame", direction = "horizontal"})
        chargingFrame.add({type = "label", name = "robotsFrameLabelCharging", style = "als_info_label", caption = {"network-charging"}, tooltip = {"tooltips.net-charging-total"}})
        chargingFrame.add({type = "label", name = "robotsFrameTotalCharging", style = "label_style", caption = ": " .. charging})

        waitingFrame = infoFlow.add({type = "frame", name = "waitingFrame", style = "als_info_frame", direction = "horizontal"})
        waitingFrame.add({type = "label", name = "robotsFrameLabelWaiting", style = "als_info_label", caption = {"network-waiting"}, tooltip = {"tooltips.net-waiting-total"}})
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
        infoFlow = contentFrame.add({type = "flow", name = "infoFlow", style = "als_info_flow", direction = "horizontal"})
    end
	
    --add item name info frame
    local infoFrameName = infoFlow[currentTab .. "infoFrameName"]
    if infoFrameName ~= nil then
        infoFrameName.destroy()
    end

    -- name
    infoFrameName = infoFlow.add({type = "frame", name = currentTab .. "infoFrameName", style = "als_info_frame", direction = "horizontal"})
    infoFrameName.add({type = "label", name = currentTab .. "infoFrameNameLabel", style = "als_info_label", caption = {"name"}})
    infoFrameName.add({type = "label", name = currentTab .. "infoFrameNameValue", style = "label_style", caption = getLocalisedName(currentItem)})


    --add "all" total info frame
    local infoFrameAll = infoFlow[currentTab .. "InfoFrameAll"]
    if infoFrameAll ~= nil then
        infoFrameAll.destroy()
    end

    -- all
    infoFrameAll = infoFlow.add({type = "frame", name = currentTab .. "InfoFrameAll", style = "als_info_frame", direction = "horizontal"})
    infoFrameAll.add({type = "label", name = currentTab .. "InfoFrameTotalLabel", style = "als_info_label", caption = {"info-total"}})
    infoFrameAll.add({type = "label", name = currentTab .. "InfoFrameTotalValue", style = "label_style", caption = ": " .. number_format(total.all)})

    for k,v in spairs(total, orderfunc) do
		if k ~= "all" then
            local key = k:gsub("^%l", string.upper)
            local infoFrame = infoFlow[currentTab .. "InfoFrame" .. key]
            if infoFrame ~= nil then
                infoFrame.destroy()
            end
			
			if v > 0 then
				infoFrame = infoFlow.add({type = "frame", name = currentTab .. "InfoFrame" .. key, style = "als_info_frame", direction = "horizontal"})
				infoFrame.add({type = "label", name = currentTab .. "InfoFrameTotalLabel" .. key, style = "als_info_label", caption = {"info-" .. k}})
				infoFrame.add({type = "label", name = currentTab .. "InfoFrameValue" .. key, style = "label_style", caption = ": " .. number_format(v)})
			end
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
        filtersFlow = contentFrame.add({type = "flow", name = "filtersFlow", style = "als_info_flow", direction = "horizontal"})
    end

    local typeFilterFrame = filtersFlow["typeFilterFrame"]
    if typeFilterFrame ~= nil then
        typeFilterFrame.destroy()
    end

    local logisticsState = filters["group"]["logistics"] ~= nil
    local normalState = filters["group"]["normal"] ~= nil
    typeFilterFrame = filtersFlow.add({type = "frame", name = "typeFilterFrame", style = "als_filters_frame", direction = "horizontal"})
    typeFilterFrame.add({type = "label", name = "typeFilterFrameLabel", style = "als_info_label", caption = {"filters"}})
    typeFilterFrame.add({type = "checkbox", name = "itemInfoFilter_logistics", style = "checkbox_style", caption = {"info-logistics"}, state = logisticsState, tooltip = {"tooltips.filter-by-log"}})
    typeFilterFrame.add({type = "checkbox", name = "itemInfoFilter_normal", style = "checkbox_style", caption = {"info-normal"}, state = normalState, tooltip = {"tooltips.filter-by-norm"}})


    local chestsFilterFrame = filtersFlow["chestsFilterFrame"]
    if chestsFilterFrame ~= nil then
        chestsFilterFrame.destroy()
    end

    local buttonStyle = filters["chests"]["all"] ~= nil and "_selected" or ""
    chestsFilterFrame = filtersFlow.add({type = "frame", name = "chestsFilterFrame", style = "als_filters_frame", direction = "horizontal"})
    chestsFilterFrame.add({type = "button", name = "itemInfoFilter_all", caption = {"all"}, style = "als_button_all" .. buttonStyle})
	
    for type,codes in pairs(global.codeToName) do
        for code,name in pairs(codes) do
            if code ~= "name" and code ~= "total" then
				local spritePath = getItemSprite(player, name)
				if spritePath then
					local buttonStyle = filters["chests"][code] ~= nil and "_selected" or ""
					chestsFilterFrame.add({type = "sprite-button", name = "itemInfoFilter_" .. code, style = "als_item_icon_small" .. buttonStyle, sprite = spritePath, tooltip = {"tooltips.filter-by", getLocalisedName(name)}})                
				end
            end
        end
    end
end

--- Show disconnected info filters
function addDisconnectedFiltersWidget(player, index)
    local guiPos = global.settings[index].guiPos
    local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame
    local filtersFlow = contentFrame["filtersFlow"]
    local currentTab = global.currentTab[index]
    local filters = global.disconnectedFilters[index]

    if filtersFlow == nil then
        filtersFlow = contentFrame.add({type = "flow", name = "filtersFlow", style = "als_info_flow", direction = "horizontal"})
    end	
	
    local chestsFilterFrame = filtersFlow["chestsFilterFrame"]
    if chestsFilterFrame ~= nil then
        chestsFilterFrame.destroy()
    end

    local buttonStyle = filters["chests"]["all"] ~= nil and "_selected" or ""
    chestsFilterFrame = filtersFlow.add({type = "frame", name = "chestsFilterFrame", style = "als_filters_frame", direction = "horizontal"})	
	chestsFilterFrame.add({type = "label", name = "chestsFilterFrameLabel", style = "als_info_label", caption = {"filters"}})
    chestsFilterFrame.add({type = "button", name = "disconnectedFilter_all", caption = {"all"}, style = "als_button_all" .. buttonStyle})
    for code,name in pairs(global.codeToName.logistics) do
		if code ~= "name" and code ~= "total" then
			local spritePath = getItemSprite(player, name)
			if spritePath then
				local buttonStyle = filters["chests"][code] ~= nil and "_selected" or ""
				chestsFilterFrame.add({type = "sprite-button", name = "disconnectedFilter_" .. code, style = "als_item_icon_small" .. buttonStyle, sprite = spritePath, tooltip = {"tooltips.filter-by", getLocalisedName(name)}})                
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
    local searchFlow = contentFrame["searchFlow"]
    local currentTab = global.currentTab[index]
    local filters = global.networksFilter[index]
    local filtersCount = count(filters)
    local currentPlayerNetwork = global.currentPlayerNetwork[index]
    local names =  global.networksNames[force]
    local maxFiltersList = math.min(filtersCount, 2)

	if searchFlow == nil then
		searchFlow = contentFrame.add({type = "flow", name = "searchFlow", style = "als_info_flow", direction = "horizontal"})
	end	
	
    -- remove network filters info frame
    local networkFiltersFrame = searchFlow["networkFiltersFrame"]
    if currentTab == "itemInfo" then
        networkFiltersFrame = filtersFlow["networkFiltersFrame"]
    end

    if networkFiltersFrame ~= nil then
        networkFiltersFrame.destroy()
    end

    -- add network filters info frame
    if currentTab == "logistics" then
		
		-- remove old search frame
		local oldnetworkFiltersFrame = contentFrame["networkFiltersFrame"]
		if oldnetworkFiltersFrame ~= nil then
			oldnetworkFiltersFrame.destroy()
		end
		
        networkFiltersFrame = searchFlow.add({type = "frame", name = "networkFiltersFrame", style = "als_info_frame", direction = "horizontal"})
        networkFiltersFrame.add({type = "label", name = "networkFiltersFrameLabel", style = "als_info_label", caption = {"networks"}})

        local btnStyles = {
            ['current'] = "als_button_small",
            ['all'] = "als_button_small",
            ['filter'] = "als_button_small"
        }

        if filtersCount == 0 then
            btnStyles["all"] = "als_button_small_selected"
        elseif filtersCount == 1 and filters[currentPlayerNetwork] then
            btnStyles["current"] = "als_button_small_selected"
        else
            btnStyles["filter"] = "als_button_small_selected"
        end

        networkFiltersFrame.add({type = "button", name = "networkFiltersFrameViewAll", caption = {"network-all"}, style = btnStyles["all"]})
        if currentPlayerNetwork ~= nil then
            networkFiltersFrame.add({type = "button", name = "networkFiltersFrameViewCurrent", caption = {"network-current"}, style = btnStyles["current"]})
        end
        networkFiltersFrame.add({type = "button", name = "networkFiltersFrameView", caption = {"network-filter", filtersCount}, style = btnStyles["filter"]})

    elseif currentTab == "itemInfo" then
        local itemFilters = global.itemInfoFilters[index]

        if itemFilters["group"]["logistics"] ~= nil then
            networkFiltersFrame = filtersFlow.add({type = "frame", name = "networkFiltersFrame", style = "als_info_frame", direction = "horizontal"})

            networkFiltersFrame.add({type = "label", name = "networkFiltersFrameLabel", style = "als_info_label", caption = {"networks"}})
            if filtersCount > 0 then
                networkFiltersFrame.add({type = "label", name = "networkFiltersFrameCount", style = "als_info_label", caption = "(" .. filtersCount .. ")"})
            end
            networkFiltersFrame.add({type = "button", name = "networkFiltersFrameView", caption = {"filter"}, style = "als_button_small"})
        end
    end
end