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

            -- create networks frame
            if player.gui[guiPos].logisticsFrame.contentFrame.networksFrame ~= nil then
                player.gui[guiPos].logisticsFrame.contentFrame.networksFrame.destroy()
            end

            local networksFrame = contentFrame.add({type = "frame", name = "networksFrame", style = "lv_items_frame", direction = "vertical"})

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

            networksTable = networksFrame.add({type ="table", name = "networksTable", colspan = 7, style = "lv_items_table"})

            -- network name column
            local isSelected = sort_by == 'name'
            local buttonStyle = isSelected and "_selected" or ""
            local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

            local nameFlow = networksTable.add({type = "flow", name = "nameFlow", direction = "horizontal", style = "lv_name_flow"})
            nameFlow.add({type = "button", name = "networkInfo_name", caption = {"network-name"}, style = "lv_button_name" .. buttonStyle})
            local nameSortFlow = nameFlow.add({type = "flow", name = "nameSortFlow", direction = "vertical", style = "lv_sort_flow"})
            nameSortFlow.add({type = "frame", name = "nameSortHolder", style = "lv_sort_holder"})
            nameSortFlow.add({type = "frame", name = "name_sort", style = "lv_sort" .. sortDirStyle})

            -- roboports count column
            local isSelected = sort_by == 'port'
            local buttonStyle = isSelected and "_selected" or ""
            local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

            local portFlow = networksTable.add({type = "flow", name = "portFlow", direction = "horizontal", style = "lv_total_flow"})
            portFlow.add({type = "button", name = "networkInfo_port", style = "lv_button_port" .. buttonStyle})
            local portSortFlow = portFlow.add({type = "flow", name = "portSortFlow", direction = "vertical", style = "lv_sort_flow"})
            portSortFlow.add({type = "frame", name = "portSortHolder", style = "lv_sort_holder"})
            portSortFlow.add({type = "frame", name = "port_sort", style = "lv_sort" .. sortDirStyle})

            -- logistics robots count column
            local isSelected = sort_by == 'log'
            local buttonStyle = isSelected and "_selected" or ""
            local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

            local logFlow = networksTable.add({type = "flow", name = "logFlow", direction = "horizontal", style = "lv_total_flow"})
            logFlow.add({type = "button", name = "networkInfo_log", style = "lv_button_log" .. buttonStyle})
            local logSortFlow = logFlow.add({type = "flow", name = "logSortFlow", direction = "vertical", style = "lv_sort_flow"})
            logSortFlow.add({type = "frame", name = "logSortHolder", style = "lv_sort_holder"})
            logSortFlow.add({type = "frame", name = "log_sort", style = "lv_sort" .. sortDirStyle})

            -- construction robots count column
            local isSelected = sort_by == 'con'
            local buttonStyle = isSelected and "_selected" or ""
            local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

            local conFlow = networksTable.add({type = "flow", name = "conFlow", direction = "horizontal", style = "lv_total_flow"})
            conFlow.add({type = "button", name = "networkInfo_con", style = "lv_button_con" .. buttonStyle})
            local conSortFlow = conFlow.add({type = "flow", name = "conSortFlow", direction = "vertical", style = "lv_sort_flow"})
            conSortFlow.add({type = "frame", name = "conSortHolder", style = "lv_sort_holder"})
            conSortFlow.add({type = "frame", name = "con_sort", style = "lv_sort" .. sortDirStyle})

            -- waiting count column
            local isSelected = sort_by == 'waiting'
            local buttonStyle = isSelected and "_selected" or ""
            local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

            local waitingFlow = networksTable.add({type = "flow", name = "waitingFlow", direction = "horizontal", style = "lv_total_flow"})
            waitingFlow.add({type = "button", name = "networkInfo_waiting", caption = {"network-waiting"}, style = "lv_button_waiting" .. buttonStyle})
            local waitingSortFlow = waitingFlow.add({type = "flow", name = "waitingSortFlow", direction = "vertical", style = "lv_sort_flow"})
            waitingSortFlow.add({type = "frame", name = "waitingSortHolder", style = "lv_sort_holder"})
            waitingSortFlow.add({type = "frame", name = "waiting_sort", style = "lv_sort" .. sortDirStyle})

            -- network items count column
            local isSelected = sort_by == 'items'
            local buttonStyle = isSelected and "_selected" or ""
            local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

            local itemsFlow = networksTable.add({type = "flow", name = "itemsFlow", direction = "horizontal", style = "lv_total_flow"})
            itemsFlow.add({type = "button", name = "networkInfo_items", caption = {"network-items"}, style = "lv_button_items" .. buttonStyle})
            local itemsSortFlow = itemsFlow.add({type = "flow", name = "itemsSortFlow", direction = "vertical", style = "lv_sort_flow"})
            itemsSortFlow.add({type = "frame", name = "itemsSortHolder", style = "lv_sort_holder"})
            itemsSortFlow.add({type = "frame", name = "items_sort", style = "lv_sort" .. sortDirStyle})

            -- info column
            networksTable.add({type = "label", name = "networkInfo_tools", caption = {"item-info"}})

            -- get filtered/sorted items
            for key,network in spairs(networks, orderfunc) do
                local items = number_format(network.items)
                local port_count = number_format(#network.cells)
                local log_count = number_format(network.bots.log.available) .. "/" .. number_format(network.bots.log.total)
                local con_count = number_format(network.bots.con.available) .. "/" .. number_format(network.bots.con.total)
                local name = names[key] and names[key] or network.name
                local waiting = number_format(network.waiting)

                current= current + 1
                if current >= start and current <= max then
                    local nameFlow = networksTable["networkInfoName_" .. key]

                    if nameFlow == nil then
                        nameFlow = networksTable.add({type = "flow", name = "networkInfoName_" .. key, direction = "horizontal", style = "lv_name_flow"})
                    end

                    local nameFlowValue = nameFlow.add({type = "flow", name = "networkInfoNameValueFL_" .. key, direction = "horizontal", style = "lv_network_value_flow"})
                    local nameFlowEdit = nameFlow.add({type = "flow", name = "networkInfoNameEditFL_" .. key, direction = "horizontal"})

                    nameFlowValue.add({type = "label", name = "networkInfoNameLabel_" .. key, caption = name, style = "label_style"})
                    nameFlowEdit.add({type = "button", name = "networkInfoNameEdit_" .. key, style = "lv_button_edit"})
                    nameFlowEdit.add({type = "button", name = "networkInfoNameConfirm_" .. key, style = "lv_button_hidden"})

                    networksTable.add({type = "label", name = "networkInfoPort_" .. key, caption = port_count})
                    networksTable.add({type = "label", name = "networkInfoLog_" .. key, caption = log_count})
                    networksTable.add({type = "label", name = "networkInfoCon_" .. key, caption = con_count})
                    networksTable.add({type = "label", name = "networkInfoWaiting_" .. key, caption = waiting})
                    networksTable.add({type = "label", name = "networkInfoItems_" .. key, caption = items})
                    networksTable.add({type = "button", name = "networkInfoView_" .. key, style = "lv_button_info"})
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
            pager.add({type = "button", name = "prevPage_" .. prevPage , caption = "<", style = "lv_button"})
            pager.add({type = "label", name = "pageTotal", caption = page.."/"..maxPages})
            pager.add({type = "button", name = "nextPage_" .. nextPage , caption = ">", style = "lv_button"})
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

                local networkFrame = contentFrame.add({type = "frame", name = "networkFrame", style = "lv_items_frame", direction = "vertical"})

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

                networkTable = networkFrame.add({type = "table", name = "networkTable", colspan = 8, style = "lv_items_table"})

                -- set items table dynamic height
                networkTable.style.minimal_height = itemsPerPage * 49

                -- port image column
                networkTable.add({type = "label", name = "networkInfo_icon", caption = " "})

                -- port name column
                local isSelected = sort_by == 'name'
                local buttonStyle = isSelected and "_selected" or ""
                local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                local nameFlow = networkTable.add({type = "flow", name = "nameFlow", direction = "horizontal", style = "lv_name_flow"})
                nameFlow.add({type = "button", name = "networkInfo_name", caption = {"chest-type"}, style = "lv_button_name" .. buttonStyle})
                local nameSortFlow = nameFlow.add({type = "flow", name = "nameSortFlow", direction = "vertical", style = "lv_sort_flow"})
                nameSortFlow.add({type = "frame", name = "nameSortHolder", style = "lv_sort_holder"})
                nameSortFlow.add({type = "frame", name = "name_sort", style = "lv_sort" .. sortDirStyle})

                -- port position column
                local isSelected = sort_by == 'pos'
                local buttonStyle = isSelected and "_selected" or ""
                local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                local posFlow = networkTable.add({type = "flow", name = "posFlow", direction = "horizontal", style = "lv_pos_flow"})
                posFlow.add({type = "button", name = "networkInfo_pos", caption = {"chest-pos"}, style = "lv_button_pos" .. buttonStyle})
                local posSortFlow = posFlow.add({type = "flow", name = "posSortFlow", direction = "vertical", style = "lv_sort_flow"})
                posSortFlow.add({type = "frame", name = "posSortHolder", style = "lv_sort_holder"})
                posSortFlow.add({type = "frame", name = "pos_sort", style = "lv_sort" .. sortDirStyle})

                -- charging count column
                local isSelected = sort_by == 'charging'
                local buttonStyle = isSelected and "_selected" or ""
                local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                local chargingFlow = networkTable.add({type = "flow", name = "chargingFlow", direction = "horizontal", style = "lv_total_flow"})
                chargingFlow.add({type = "button", name = "networkInfo_charging", caption = {"network-charging"}, style = "lv_button_charging" .. buttonStyle})
                local chargingSortFlow = chargingFlow.add({type = "flow", name = "chargingSortFlow", direction = "vertical", style = "lv_sort_flow"})
                chargingSortFlow.add({type = "frame", name = "chargingSortHolder", style = "lv_sort_holder"})
                chargingSortFlow.add({type = "frame", name = "charging_sort", style = "lv_sort" .. sortDirStyle})

                -- waiting count column
                local isSelected = sort_by == 'waiting'
                local buttonStyle = isSelected and "_selected" or ""
                local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                local waitingFlow = networkTable.add({type = "flow", name = "waitingFlow", direction = "horizontal", style = "lv_total_flow"})
                waitingFlow.add({type = "button", name = "networkInfo_waiting", caption = {"network-waiting"}, style = "lv_button_waiting" .. buttonStyle})
                local waitingSortFlow = waitingFlow.add({type = "flow", name = "waitingSortFlow", direction = "vertical", style = "lv_sort_flow"})
                waitingSortFlow.add({type = "frame", name = "waitingSortHolder", style = "lv_sort_holder"})
                waitingSortFlow.add({type = "frame", name = "waiting_sort", style = "lv_sort" .. sortDirStyle})

                -- logistics robots count column
                local isSelected = sort_by == 'log'
                local buttonStyle = isSelected and "_selected" or ""
                local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                local logFlow = networkTable.add({type = "flow", name = "logFlow", direction = "horizontal", style = "lv_total_flow"})
                logFlow.add({type = "button", name = "networkInfo_log", style = "lv_button_log" .. buttonStyle})
                local logSortFlow = logFlow.add({type = "flow", name = "logSortFlow", direction = "vertical", style = "lv_sort_flow"})
                logSortFlow.add({type = "frame", name = "logSortHolder", style = "lv_sort_holder"})
                logSortFlow.add({type = "frame", name = "log_sort", style = "lv_sort" .. sortDirStyle})

                -- construction robots count column
                local isSelected = sort_by == 'con'
                local buttonStyle = isSelected and "_selected" or ""
                local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                local conFlow = networkTable.add({type = "flow", name = "conFlow", direction = "horizontal", style = "lv_total_flow"})
                conFlow.add({type = "button", name = "networkInfo_con", style = "lv_button_con" .. buttonStyle})
                local conSortFlow = conFlow.add({type = "flow", name = "conSortFlow", direction = "vertical", style = "lv_sort_flow"})
                conSortFlow.add({type = "frame", name = "conSortHolder", style = "lv_sort_holder"})
                conSortFlow.add({type = "frame", name = "con_sort", style = "lv_sort" .. sortDirStyle})

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
                        local nameFlow = networkTable["networkInfoName_" .. key]

                        networkTable.add({type = "checkbox", name = "networkInfoIcon_" .. key, style = "item-icons-".. name, state = false})
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
                        toolsFlow.add({type = "button", name = "networkAction_location_" .. key, style = "lv_button_location"})
                        if exTools then toolsFlow.add({type = "button", name = "networkAction_teleport_" .. key, style = "lv_button_teleport"}) end
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
                pager.add({type = "button", name = "prevPage_" .. prevPage , caption = "<", style = "lv_button"})
                pager.add({type = "label", name = "pageTotal", caption = page.."/"..maxPages})
                pager.add({type = "button", name = "nextPage_" .. nextPage , caption = ">", style = "lv_button"})
            end
        end
    end

end

--- Show networks filter list
function showNetworksFilter(player, index)
    local guiPos = global.settings[index].guiPos
    local currentTab = global.currentTab[index] or "logistics"
    --global.currentTab[index] = "networkFilter"

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

        local networksFilterFrame = player.gui[guiPos].add({type = "frame", name = "networksFilterFrame", direction = "vertical", style = "frame_style"})
        networksFilterFrame.add({type = "label", name = "networksFilterTitle", caption = {"network-filter-by"} , style = "lv_info_label"})
        networksFilterFrame.add({type = "label", name = "networksFilterCount", caption = "(" .. filtersTitle .. ")" , style = "lv_info_label"})

        -- add networks table
        if player.gui[guiPos].networksFilterFrame.networksTable ~= nil then
            player.gui[guiPos].networksFilterFrame.networksTable.destroy()
        end

        local networksTable = networksFilterFrame.add({type = "table", name = "networksTable", colspan = 2, style = "lv_networks_table"})

        networksTable.add({type = "label", name = "networksFilterLabel", caption = {"filter"}, style = "label_style"})
        networksTable.add({type = "label", name = "networksNameLabel", caption = {"network-name"}, style = "label_style"})

        --- add all networks option
        local allFilter = filtersCount > 0 and "false" or "true"
        networksTable.add({type = "checkbox", name = "networksFilter_all", style = "checkbox_style", caption = " ", state = allFilter})
        networksTable.add({type = "label", name = "networksName_all", caption = {"network-all"}, style = "lv_info_label"})

        --- add networks options

        for key,network in pairs(networks) do
            local name = network.name
            local isFilter = networksFilter[key] and "true" or "false"
            networksTable.add({type = "checkbox", name = "networksFilter_" .. key, style = "checkbox_style", caption = " ", state = isFilter})
            networksTable.add({type = "label", name = "networksName_" .. key, caption = name, style = "lv_info_label"})
        end

        -- buttons flow
        local buttonsFlow = networksFilterFrame.add({type = "flow", name = "buttonsFlow", direction="horizontal"})
        buttonsFlow.add({type = "button", name = "applyFiltersBtn", caption = {"network-apply"}, style = "lv_button"})
        buttonsFlow.add({type = "button", name = "cancelFiltersBtn", caption = {"settings.cancel"}, style = "lv_button"})
    end
end

--- Apply networks filter
function applyNetworkFilters(player, index)
    local networksFilter = {}
    local guiPos = global.settings[index].guiPos
    local networksFilterFrame = player.gui[guiPos].networksFilterFrame
    local networksTable = networksFilterFrame.networksTable

    if networksTable ~= nil then
        if networksTable.children_names ~= nil then
            for _,childName in pairs(networksTable.children_names) do
                if networksTable[childName] ~= nil and networksTable[childName].name:find("networksFilter_") ~= nil then
                    local state = networksTable[childName].state
                    if state then
                        local key = string.gsub(childName, "networksFilter_", "")

                        if key ~= "all" then
                            networksFilter[key] = true
                        end
                    end
                end
            end
        end

        global.networksFilter[index] = networksFilter
        networksFilterFrame.destroy()
        showGUI(player, index)
    end
end