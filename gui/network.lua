---- Show networks info
function showNetworksInfo(player, index, page, sort_by, sort_dir)
    local networks = getLogisticNetworks(player.force)
    local names = global.networksNames[player.force.name]
    local networksCount = global.networksCount[player.force.name]
    global.networkEdit[index] = false

    if networksCount > 0 then

        local guiPos = global.settings[index].guiPos
        local currentTab = "networks"
        global.currentTab[index] = currentTab

        if player.gui[guiPos].logisticsFrame ~= nil and player.gui[guiPos].logisticsFrame.contentFrame ~= nil then

            local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame

            -- add info
            addNetwroksInfoWidget(player, index)

            -- add search widget
                addNetworkSearchWidget(player, index)

            -- create networks frame
            if player.gui[guiPos].logisticsFrame.contentFrame.networksFrame ~= nil then
                player.gui[guiPos].logisticsFrame.contentFrame.networksFrame.destroy()
            end

            local networksFrame = contentFrame.add({type = "frame", name = "networksFrame", style = "als_items_frame", direction = "vertical"})

            -- add network search
            local searchText = global.searchText[index]["networks"]
            searchText = searchText and searchText or ""
            searchText = escapePattern(searchText)

            if searchText ~= "" then
                -- filter networks based on search string
                networks = table.filter(networks, function(v, k, t)
                    return string.find(string.lower(v.name), searchText) ~= nil
                end)
            else
                networks = networks
            end

            -- sort settings
            local sort_by = sort_by or global.sort[index][currentTab]["by"]
            local sort_dir = sort_dir or global.sort[index][currentTab]["dir"]

            local orderfunc = function(t,a,b) return t[b][sort_by] < t[a][sort_by] end
            if sort_dir == "asc" then
                orderfunc = function(t,a,b) return t[b][sort_by] > t[a][sort_by] end
            end

            -- get page settings
            local page = page or global.itemsPage[index][currentTab]
            local current = 0
            local itemsPerPage = global.settings[index].itemsPerPage
            local maxPages = math.ceil(networksCount/itemsPerPage)
            page = math.min(page, maxPages)
            local start = (page-1) * itemsPerPage + 1
            local max = start + itemsPerPage - 1


            -- generate items table
            if player.gui[guiPos].logisticsFrame.contentFrame.networksFrame.networksTable ~= nil then
                player.gui[guiPos].logisticsFrame.contentFrame.networksFrame.networksTable.destroy()
            end

            networksTable = networksFrame.add({type ="table", name = "networksTable", colspan = 7, style = "als_items_table"})

            -- network name column
            local isSelected = sort_by == 'name'
            local buttonStyle = isSelected and "_selected" or ""
            local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

            local nameFlow = networksTable.add({type = "flow", name = "nameFlow", direction = "horizontal", style = "als_name_flow"})
            nameFlow.add({type = "button", name = "networkInfo_name", caption = {"network-name"}, style = "als_button_name" .. buttonStyle})
            local nameSortFlow = nameFlow.add({type = "flow", name = "nameSortFlow", direction = "vertical", style = "als_sort_flow"})
            nameSortFlow.add({type = "frame", name = "nameSortHolder", style = "als_sort_holder"})
            nameSortFlow.add({type = "frame", name = "name_sort", style = "als_sort" .. sortDirStyle})

            -- roboports count column
            local isSelected = sort_by == 'port'
            local buttonStyle = isSelected and "_selected" or ""
            local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

            local portFlow = networksTable.add({type = "flow", name = "portFlow", direction = "horizontal", style = "als_total_flow"})
            portFlow.add({type = "button", name = "networkInfo_port", style = "als_button_port" .. buttonStyle, tooltip = {"tooltips.net-roboports"}})
            local portSortFlow = portFlow.add({type = "flow", name = "portSortFlow", direction = "vertical", style = "als_sort_flow"})
            portSortFlow.add({type = "frame", name = "portSortHolder", style = "als_sort_holder"})
            portSortFlow.add({type = "frame", name = "port_sort", style = "als_sort" .. sortDirStyle})

            -- logistics robots count column
            local isSelected = sort_by == 'log'
            local buttonStyle = isSelected and "_selected" or ""
            local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

            local logFlow = networksTable.add({type = "flow", name = "logFlow", direction = "horizontal", style = "als_total_flow"})
            logFlow.add({type = "button", name = "networkInfo_log", style = "als_button_log" .. buttonStyle, tooltip = {"tooltips.net-log-total"}})
            local logSortFlow = logFlow.add({type = "flow", name = "logSortFlow", direction = "vertical", style = "als_sort_flow"})
            logSortFlow.add({type = "frame", name = "logSortHolder", style = "als_sort_holder"})
            logSortFlow.add({type = "frame", name = "log_sort", style = "als_sort" .. sortDirStyle})

            -- construction robots count column
            local isSelected = sort_by == 'con'
            local buttonStyle = isSelected and "_selected" or ""
            local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

            local conFlow = networksTable.add({type = "flow", name = "conFlow", direction = "horizontal", style = "als_total_flow"})
            conFlow.add({type = "button", name = "networkInfo_con", style = "als_button_con" .. buttonStyle, tooltip = {"tooltips.net-con-total"}})
            local conSortFlow = conFlow.add({type = "flow", name = "conSortFlow", direction = "vertical", style = "als_sort_flow"})
            conSortFlow.add({type = "frame", name = "conSortHolder", style = "als_sort_holder"})
            conSortFlow.add({type = "frame", name = "con_sort", style = "als_sort" .. sortDirStyle})

            -- waiting count column
            local isSelected = sort_by == 'waiting'
            local buttonStyle = isSelected and "_selected" or ""
            local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

            local waitingFlow = networksTable.add({type = "flow", name = "waitingFlow", direction = "horizontal", style = "als_total_w_flow"})
            waitingFlow.add({type = "button", name = "networkInfo_waiting", caption = {"network-waiting"}, style = "als_button_waiting" .. buttonStyle, tooltip = {"tooltips.net-waiting-total"}})
            local waitingSortFlow = waitingFlow.add({type = "flow", name = "waitingSortFlow", direction = "vertical", style = "als_sort_flow"})
            waitingSortFlow.add({type = "frame", name = "waitingSortHolder", style = "als_sort_holder"})
            waitingSortFlow.add({type = "frame", name = "waiting_sort", style = "als_sort" .. sortDirStyle})

            -- network items count column
            local isSelected = sort_by == 'items'
            local buttonStyle = isSelected and "_selected" or ""
            local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

            local itemsFlow = networksTable.add({type = "flow", name = "itemsFlow", direction = "horizontal", style = "als_total_w_flow"})
            itemsFlow.add({type = "button", name = "networkInfo_items", caption = {"network-items"}, style = "als_button_items" .. buttonStyle, tooltip = {"tooltips.net-items"}})
            local itemsSortFlow = itemsFlow.add({type = "flow", name = "itemsSortFlow", direction = "vertical", style = "als_sort_flow"})
            itemsSortFlow.add({type = "frame", name = "itemsSortHolder", style = "als_sort_holder"})
            itemsSortFlow.add({type = "frame", name = "items_sort", style = "als_sort" .. sortDirStyle})

            -- info column            
            -- local networksInfoWrapper = networksTable.add({type = "flow", name = "networksInfoWrapper", direction = "horizontal", style = "als_items_info_flow"})	
            -- networksInfoWrapper.add({type = "label", name = "networkInfo_tools", caption = {"item-info"}})		
            networksTable.add({type = "label", name = "networkInfo_tools", caption = {"item-info"}})		

            -- get filtered/sorted items
            for key,network in spairs(networks, orderfunc) do
                local items = number_format(network.items)
                local port_count = number_format(network.port)
                local log_count = number_format(network.bots.log.available) .. "/" .. number_format(network.bots.log.total)
                local con_count = number_format(network.bots.con.available) .. "/" .. number_format(network.bots.con.total)
                local name = names[key] and names[key] or network.name
                local waiting = number_format(network.waiting)

                current= current + 1
                if current >= start and current <= max then
                    local nameFlow = networksTable["networkInfoName_" .. key]

                    if nameFlow == nil then
                        nameFlow = networksTable.add({type = "flow", name = "networkInfoName_" .. key, direction = "horizontal", style = "als_name_flow"})
                    end

                    local nameFlowValue = nameFlow.add({type = "flow", name = "networkInfoNameValueFL_" .. key, direction = "horizontal", style = "als_network_value_flow"})
                    local nameFlowEdit = nameFlow.add({type = "flow", name = "networkInfoNameEditFL_" .. key, direction = "horizontal"})

                    nameFlowValue.add({type = "label", name = "networkInfoNameLabel_" .. key, caption = name, style = "label_style"})
                    nameFlowEdit.add({type = "button", name = "networkInfoNameEdit_" .. key, style = "als_button_edit", tooltip = {"tooltips.net-rename"}})
                    nameFlowEdit.add({type = "button", name = "networkInfoNameConfirm_" .. key, style = "als_button_hidden", tooltip = {"tooltips.net-save"}})

                    networksTable.add({type = "label", name = "networkInfoPort_" .. key, caption = port_count})
                    networksTable.add({type = "label", name = "networkInfoLog_" .. key, caption = log_count})
                    networksTable.add({type = "label", name = "networkInfoCon_" .. key, caption = con_count})
                    networksTable.add({type = "label", name = "networkInfoWaiting_" .. key, caption = waiting})
                    networksTable.add({type = "label", name = "networkInfoItems_" .. key, caption = items})
                    networksTable.add({type = "button", name = "networkInfoView_" .. key, style = "als_button_info", tooltip = {"tooltips.view-info-net"}})
                end
            end

            -- add pager
            if player.gui[guiPos].logisticsFrame.contentFrame.pagerFlow ~= nil then
                player.gui[guiPos].logisticsFrame.contentFrame.pagerFlow.destroy()
            end
            local nextPage = math.min((page+1), maxPages)
            local prevPage = page-1
            pager = contentFrame.add({type = "flow", name = "pagerFlow", direction="horizontal"})
            pager.add({type = "label", name = "pagerLabel", caption = "Page:"})
            pager.add({type = "button", name = "prevPage_" .. prevPage , caption = "<", style = "als_button"})
            pager.add({type = "label", name = "pageTotal", caption = page.."/"..maxPages})
            pager.add({type = "button", name = "nextPage_" .. nextPage , caption = ">", style = "als_button"})
        end
    end

end

---- Show a specific network info
function showNetworkInfo(net, player, index, page, sort_by, sort_dir)
    local networks = getLogisticNetworks(player.force)
    local network = networks[net]

    if network then
        local portsCount = network.port
        if portsCount > 0 then
            local cells = network.cells
            local guiPos = global.settings[index].guiPos
            local exTools = global.settings[index].exTools
            local currentTab = "networkInfo"
            global.currentTab[index] = currentTab

            if player.gui[guiPos].logisticsFrame ~= nil and player.gui[guiPos].logisticsFrame.contentFrame ~= nil then

                local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame

                -- add info
                addNetwroksInfoWidget(player, index, network)

                -- create network frame
                if player.gui[guiPos].logisticsFrame.contentFrame.networkFrame ~= nil then
                    player.gui[guiPos].logisticsFrame.contentFrame.networkFrame.destroy()
                end

                local networkFrame = contentFrame.add({type = "frame", name = "networkFrame", style = "als_items_frame", direction = "vertical"})

                -- sort settings
                local sort_by = sort_by or global.sort[index][currentTab]["by"]
                local sort_dir = sort_dir or global.sort[index][currentTab]["dir"]

                local orderfunc = function(t,a,b) return t[b][sort_by] < t[a][sort_by] end
                if sort_dir == "asc" then
                    orderfunc = function(t,a,b) return t[b][sort_by] > t[a][sort_by] end
                end

                if sort_by == "pos" then
                    orderfunc = function(t,a,b) if t[a][sort_by].x  == t[b][sort_by].x then return t[a][sort_by].y > t[b][sort_by].y end return t[a][sort_by].x > t[b][sort_by].x end
                    if sort_dir == "asc" then
                        orderfunc = function(t,a,b) if t[a][sort_by].x  == t[b][sort_by].x then return t[a][sort_by].y < t[b][sort_by].y end return t[a][sort_by].x < t[b][sort_by].x end
                    end
                end

                if sort_by == "charging" or sort_by == "waiting" then
                    orderfunc = function(t,a,b) return t[b]["bots"][sort_by] < t[a]["bots"][sort_by] end
                    if sort_dir == "asc" then
                        orderfunc = function(t,a,b) return t[b]["bots"][sort_by] > t[a]["bots"][sort_by] end
                    end
                end

                if sort_by == "log" or sort_by == "con" then
                    orderfunc = function(t,a,b) return t[b]["bots"]["idle_" .. sort_by] < t[a]["bots"]["idle_" .. sort_by] end
                    if sort_dir == "asc" then
                        orderfunc = function(t,a,b) return t[b]["bots"]["idle_" .. sort_by] > t[a]["bots"]["idle_" .. sort_by] end
                    end
                end

                -- get page settings
                local page = page or global.itemsPage[index][currentTab]
                local current = 0
                local itemsPerPage = global.settings[index].itemsPerPage
                local maxPages = math.ceil(portsCount/itemsPerPage)
                page = math.min(page, maxPages)
                local start = (page-1) * itemsPerPage + 1
                local max = start + itemsPerPage - 1


                -- generate items table
                if player.gui[guiPos].logisticsFrame.contentFrame.networkFrame.networkTable ~= nil then
                    player.gui[guiPos].logisticsFrame.contentFrame.networkFrame.networkTable.destroy()
                end

                networkTable = networkFrame.add({type = "table", name = "networkTable", colspan = 8, style = "als_items_table"})

                -- set items table dynamic height
                networkTable.style.minimal_height = itemsPerPage * 49

                -- port image column
                networkTable.add({type = "label", name = "networkInfo_icon", caption = " "})

                -- port name column
                local isSelected = sort_by == 'name'
                local buttonStyle = isSelected and "_selected" or ""
                local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                local nameFlow = networkTable.add({type = "flow", name = "nameFlow", direction = "horizontal", style = "als_name_flow"})
                nameFlow.add({type = "button", name = "networkInfo_name", caption = {"chest-type"}, style = "als_button_name" .. buttonStyle})
                local nameSortFlow = nameFlow.add({type = "flow", name = "nameSortFlow", direction = "vertical", style = "als_sort_flow"})
                nameSortFlow.add({type = "frame", name = "nameSortHolder", style = "als_sort_holder"})
                nameSortFlow.add({type = "frame", name = "name_sort", style = "als_sort" .. sortDirStyle})

                -- port position column
                local isSelected = sort_by == 'pos'
                local buttonStyle = isSelected and "_selected" or ""
                local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                local posFlow = networkTable.add({type = "flow", name = "posFlow", direction = "horizontal", style = "als_total_w_flow"})
                posFlow.add({type = "button", name = "networkInfo_pos", caption = {"chest-pos"}, style = "als_button_pos" .. buttonStyle})
                local posSortFlow = posFlow.add({type = "flow", name = "posSortFlow", direction = "vertical", style = "als_sort_flow"})
                posSortFlow.add({type = "frame", name = "posSortHolder", style = "als_sort_holder"})
                posSortFlow.add({type = "frame", name = "pos_sort", style = "als_sort" .. sortDirStyle})

                -- charging count column
                local isSelected = sort_by == 'charging'
                local buttonStyle = isSelected and "_selected" or ""
                local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                local chargingFlow = networkTable.add({type = "flow", name = "chargingFlow", direction = "horizontal", style = "als_total_w_flow"})
                chargingFlow.add({type = "button", name = "networkInfo_charging", caption = {"network-charging"}, style = "als_button_charging" .. buttonStyle, tooltip = {"tooltips.net-charging-total"}})
                local chargingSortFlow = chargingFlow.add({type = "flow", name = "chargingSortFlow", direction = "vertical", style = "als_sort_flow"})
                chargingSortFlow.add({type = "frame", name = "chargingSortHolder", style = "als_sort_holder"})
                chargingSortFlow.add({type = "frame", name = "charging_sort", style = "als_sort" .. sortDirStyle})

                -- waiting count column
                local isSelected = sort_by == 'waiting'
                local buttonStyle = isSelected and "_selected" or ""
                local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                local waitingFlow = networkTable.add({type = "flow", name = "waitingFlow", direction = "horizontal", style = "als_total_w_flow"})
                waitingFlow.add({type = "button", name = "networkInfo_waiting", caption = {"network-waiting"}, style = "als_button_waiting" .. buttonStyle, tooltip = {"tooltips.net-waiting-total"}})
                local waitingSortFlow = waitingFlow.add({type = "flow", name = "waitingSortFlow", direction = "vertical", style = "als_sort_flow"})
                waitingSortFlow.add({type = "frame", name = "waitingSortHolder", style = "als_sort_holder"})
                waitingSortFlow.add({type = "frame", name = "waiting_sort", style = "als_sort" .. sortDirStyle})

                -- logistics robots count column
                local isSelected = sort_by == 'log'
                local buttonStyle = isSelected and "_selected" or ""
                local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                local logFlow = networkTable.add({type = "flow", name = "logFlow", direction = "horizontal", style = "als_total_flow"})
                logFlow.add({type = "button", name = "networkInfo_log", style = "als_button_log" .. buttonStyle, tooltip={"tooltips.net-log"}})
                local logSortFlow = logFlow.add({type = "flow", name = "logSortFlow", direction = "vertical", style = "als_sort_flow"})
                logSortFlow.add({type = "frame", name = "logSortHolder", style = "als_sort_holder"})
                logSortFlow.add({type = "frame", name = "log_sort", style = "als_sort" .. sortDirStyle})

                -- construction robots count column
                local isSelected = sort_by == 'con'
                local buttonStyle = isSelected and "_selected" or ""
                local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                local conFlow = networkTable.add({type = "flow", name = "conFlow", direction = "horizontal", style = "als_total_flow"})
                conFlow.add({type = "button", name = "networkInfo_con", style = "als_button_con" .. buttonStyle, tooltip={"tooltips.net-con"}})
                local conSortFlow = conFlow.add({type = "flow", name = "conSortFlow", direction = "vertical", style = "als_sort_flow"})
                conSortFlow.add({type = "frame", name = "conSortHolder", style = "als_sort_holder"})
                conSortFlow.add({type = "frame", name = "con_sort", style = "als_sort" .. sortDirStyle})

                -- tools column
                networkTable.add({type = "label", name = "networkInfo_tools", caption = {"chest-tools"}})

                -- get filtered/sorted items
                for key,cell in spairs(cells, orderfunc) do
                    local name = getCompName(cell.name)
                    name = name and name or cell.name
                    local pos = cell.pos
                    local charging = number_format(cell.bots.charging)
                    local waiting = number_format(cell.bots.waiting)
                    local log_idle = number_format(cell.bots.idle_log)
                    local con_idle = number_format(cell.bots.idle_con)

                    current= current + 1
                    if current >= start and current <= max then
						local spritePath = getItemSprite(player, name)
						if spritePath then
							networkTable.add({type = "sprite-button", name = "networkInfoIcon_" .. key, style = "als_item_icon", sprite = spritePath})	
						else
							networkTable.add({type = "sprite-button", name = "networkInfoIcon_" .. key, style = "als_item_icon"})	
						end
                        networkTable.add({type = "label", name = "networkInfoType_" .. key, caption = getLocalisedName(name)})
                        networkTable.add({type = "label", name = "networkInfoPos_" .. key, caption = pos.x .. " : " .. pos.y})
                        networkTable.add({type = "label", name = "networkInfoCharging_" .. key, caption = charging})
                        networkTable.add({type = "label", name = "networkInfoWaiting_" .. key, caption = waiting})
                        networkTable.add({type = "label", name = "networkInfoLog_" .. key, caption = log_idle})
                        networkTable.add({type = "label", name = "networkInfoCon_" .. key, caption = con_idle})

                        local toolsFlow = networkTable["networkInfoTools_" .. key]
                        if toolsFlow == nil then
                            toolsFlow = networkTable.add({type = "flow", name = "networkInfoTools_" .. key, direction = "horizontal", style = "flow_style"})
                        end
                        toolsFlow.add({type = "button", name = "networkAction_location_" .. key, style = "als_button_location", tooltip = {"tooltips.tools-location"}})
                        if exTools then toolsFlow.add({type = "button", name = "networkAction_teleport_" .. key, style = "als_button_teleport", tooltip = {"tooltips.tools-teleport"}}) end
                    end
                end

                -- add pager
                if player.gui[guiPos].logisticsFrame.contentFrame.pagerFlow ~= nil then
                    player.gui[guiPos].logisticsFrame.contentFrame.pagerFlow.destroy()
                end
                local nextPage = math.min((page+1), maxPages)
                local prevPage = page-1
                pager = contentFrame.add({type = "flow", name = "pagerFlow", direction="horizontal"})
                pager.add({type = "label", name = "pagerLabel", caption = "Page:"})
                pager.add({type = "button", name = "prevPage_" .. prevPage , caption = "<", style = "als_button"})
                pager.add({type = "label", name = "pageTotal", caption = page.."/"..maxPages})
                pager.add({type = "button", name = "nextPage_" .. nextPage , caption = ">", style = "als_button"})
            end
        end
    end

end

--- Show networks filter list
function showNetworksFilter(player, index)
    local guiPos = global.settings[index].guiPos
    local currentTab = global.currentTab[index] or "logistics"

    if global.guiVisible[index] == 0 and player.gui[guiPos].logisticsFrame ~= nil then

        local networks = global.networks[player.force.name]
        local networksCount = global.networksCount[player.force.name]
        local networksFilter = global.networksFilter[index]
        local filtersCount = count(networksFilter)
        local filtersTitle = filtersCount == 0 and "All" or filtersCount

        -- add networks filter frame
        if player.gui[guiPos].networksFilterFrame ~= nil then
            player.gui[guiPos].networksFilterFrame.destroy()
        end

        local networksFilterFrame = player.gui[guiPos].add({type = "frame", name = "networksFilterFrame", direction = "vertical", style = "als_networks_frame"})
        networksFilterFrame.add({type = "label", name = "networksFilterTitle", caption = {"network-filter-by", filtersTitle} , style = "als_info_label"})       

        -- add networks table
        if player.gui[guiPos].networksFilterFrame.networksTable ~= nil then
            player.gui[guiPos].networksFilterFrame.networksTable.destroy()
        end

        -- add network search
        local searchText = ""
        global.searchText[index]["networksFilter"] = searchText

        local searchFrame = networksFilterFrame.add({type = "frame", name =  "networksSearchFrame", style = "als_search_frame", direction = "horizontal"})
        searchFrame.add({type = "label", name = "networksSearchFrameLabel", style = "als_search_label", caption = {"search-label"}})
        local searchField = searchFrame.add({type = "textfield", name = "networks-filter-search-field", style = "als_searchfield_style", text = searchText })

        -- add all networks option
        local networksAllTable = networksFilterFrame.add({type = "table", name = "networksAllTable", colspan = 2, style = "als_networks_table"})
        local allFilter = filtersCount > 0 and "false" or "true"
        local allFilterFlow = networksAllTable.add({type = "flow", name = "allFilterFlow", direction = "horizontal", style = "als_network_filter_flow"})
        allFilterFlow.add({type = "checkbox", name = "networksFilter_all", style = "checkbox_style", caption = " ", state = allFilter})
        local allFilterNameFlow = networksAllTable.add({type = "flow", name = "allFilterNameFlow", direction = "horizontal", style = "als_network_name_flow"})
        allFilterNameFlow.add({type = "label", name = "networksName_all", caption = {"network-all"}, style = "als_info_label"})

        -- add networks options
        local networksTableWrapper = networksFilterFrame.add({type = "scroll-pane", name = "networksTableWrapper", style="als_networks_table_wrapper", vertical_scroll_policy = "always"})
        local networksTable = networksTableWrapper.add({type = "table", name = "networksTable", colspan = 2, style = "als_networks_table"})

        local networksFilterFlow = networksTable.add({type = "flow", name = "networkFilterFlow", direction = "horizontal", style = "als_network_filter_flow"})
        networksFilterFlow.add({type = "label", name = "networksFilterLabel", caption = {"filter"}, style = "label_style"})
        local networksFilterNameFlow = networksTable.add({type = "flow", name = "allFilterNameFlow", direction = "horizontal", style = "als_network_name_flow"})
        networksFilterNameFlow.add({type = "label", name = "networksNameLabel", caption = {"network-name"}, style = "label_style"})

        for key,network in pairs(networks) do
            local name = network.name
            local isFilter = networksFilter[key] and "true" or "false"
            networksTable.add({type = "checkbox", name = "networksFilter_" .. key, style = "checkbox_style", caption = " ", state = isFilter})
            networksTable.add({type = "label", name = "networksName_" .. key, caption = name, style = "als_info_label"})
        end

        -- buttons flow
        local buttonsFlow = networksFilterFrame.add({type = "flow", name = "buttonsFlow", direction="horizontal"})
        buttonsFlow.add({type = "button", name = "applyFiltersBtn", caption = {"network-apply"}, style = "als_button"})
        buttonsFlow.add({type = "button", name = "cancelFiltersBtn", caption = {"settings.cancel"}, style = "als_button"})
    end
end

--- Update network filters table
function updateNetworkFiltersTable(player, index)
    local networks = global.networks[player.force.name]
    local networksFilter = global.networksFilter[index]
    local guiPos = global.settings[index].guiPos
    local networksFilterFrame = player.gui[guiPos].networksFilterFrame
    local networksTableWrapper = networksFilterFrame.networksTableWrapper
    local networksTable = networksTableWrapper.networksTable

    if networksTableWrapper ~= nil and networksTable ~= nil and networksTable.children_names ~= nil then
        -- search settings
        local searchText = global.searchText[index]["networksFilter"] or ""
        searchText = escapePattern(searchText)
        if searchText ~= "" then
            -- filter networks based on search string
            networks = table.filter(networks, function(v, k, t)
                return string.find(string.lower(v.name), searchText) ~= nil
            end)
        else
            networks = networks
        end

        for _,childName in pairs(networksTable.children_names) do
            if networksTable[childName] ~= nil and networksTable[childName].name:find("networksFilter_") ~= nil then
                local key = string.gsub(childName, "networksFilter_", "")
                if not networks[key] then
                    networksTable[childName].style = "als_network_filter_hidden"
                    networksTable["networksName_" .. key].style = "als_network_name_hidden"
                else
                    networksTable[childName].style = "checkbox_style"
                    networksTable["networksName_" .. key].style = "als_info_label"
                end
            end
        end
    end
end

--- Apply networks filter
function applyNetworkFilters(player, index)
    local networksFilter = {}
    local guiPos = global.settings[index].guiPos
    local networksFilterFrame = player.gui[guiPos].networksFilterFrame
    local networksAllTable = networksFilterFrame.networksAllTable
    local networksTable = networksFilterFrame.networksTableWrapper.networksTable

    if networksTable ~= nil then
        if networksTable.children_names ~= nil then
            for _,childName in pairs(networksTable.children_names) do
                if networksTable[childName] ~= nil and networksTable[childName].name:find("networksFilter_") ~= nil then
                    local state = networksTable[childName].state
                    if state then
                        local key = string.gsub(childName, "networksFilter_", "")

                        --if key ~= "all" then
                            networksFilter[key] = true
                        --end
                    end
                end
            end
        end

        global.networksFilter[index] = networksFilter
        networksFilterFrame.destroy()
        showGUI(player, index)
    end
end

--- Handle networks filter list event
function handleNetworksFilterListEvent(player, index, element, updateElement)
	if element and element.valid then
		local guiPos = global.settings[index].guiPos
		local elementName = element.name	
		
		-- network filters list
		if elementName:find("networksFilter_") then			
			local networksFilterFrame = player.gui[guiPos].networksFilterFrame
			local networksTable = networksFilterFrame.networksTableWrapper.networksTable
			local networksAllCheck = networksFilterFrame.networksAllTable.allFilterFlow["networksFilter_all"]
			local key = string.gsub(elementName, "networksFilter_", "")
			local state = element.state	and element.state or "false"		
			local checkAll = false			
			
			if updateElement then
				if state == "false" then
					element.state = true
				elseif state == "true" then
					element.state = false
				end				
			end
			
			if key == "all" and state then
				checkAll = true
			end

			if networksTable and networksTable.children_names ~= nil then
				-- if filter is checked
				if key ~= "all" and state then
					checkAll = true
					for _,childName in pairs(networksTable.children_names) do
						if networksTable[childName] ~= nil and networksTable[childName].name:find("networksFilter_") ~= nil then							
							if not networksTable[childName].state then                        
								checkAll = false
							end
						end
					end 
				-- if filter is unchecked
				elseif not state then
					checkAll = true
					for _,childName in pairs(networksTable.children_names) do
						if networksTable[childName] ~= nil and networksTable[childName].name:find("networksFilter_") ~= nil then
							if networksTable[childName].state then                        
								checkAll = false
							end
						end
					end 				
				end
				
				-- if filter by all is selected or all options are selected, unselect all other options or if not all options are selected, unselect filter by all
				if checkAll then
					for _,childName in pairs(networksTable.children_names) do
						if networksTable[childName] ~= nil and networksTable[childName].name:find("networksFilter_") ~= nil then                     
							networksTable[childName].state = false
						end
					end	
					networksAllCheck.state = true
				else		
					networksAllCheck.state = false
				end
			
			end
						
		end
	end
end
