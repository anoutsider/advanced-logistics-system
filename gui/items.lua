--- Show search frame
function showSearch(player, index)
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
function updateItemsInfo(player, index)
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
function updateDisconnectedInfo(player, index)
    local guiPos = global.settings[index].guiPos
    local force = player.force.name
    local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame
    local infoFlow = contentFrame["infoFlow"]
    local currentTab = global.currentTab[index]
    local disconnected = global.disconnectedChests[force]
    local count = count(disconnected)
    
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
    if currentTab == "logistics" and count > 0 then
        disconnectedFrame = infoFlow.add({type = "frame", name = "disconnectedFrame", style = "lv_info_frame", direction = "horizontal"})
        disconnectedFrame.add({type = "label", name = "disconnectedFrameLabel", style = "lv_info_label", caption = {"disconnected-chests"}})
        disconnectedFrame.add({type = "label", name = "disconnectedFrameTotal", style = "label_style", caption = ": " .. count})
        disconnectedFrame.add({type = "button", name = "disconnectedFrameView", caption = {"view"}, style = "lv_button"})
    end
end

---- Update/Show items table
function updateItemsTable(items, player, index, page, search, sort_by, sort_dir)
    if items then
        local guiPos = global.settings[index].guiPos
        local currentTab = global.currentTab[index]

        if player.gui[guiPos].logisticsFrame ~= nil and player.gui[guiPos].logisticsFrame.contentFrame ~= nil then

            local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame

            -- add info
                updateItemsInfo(player, index)
                updateDisconnectedInfo(player, index)

            -- add search
                showSearch(player, index)

            -- create items frame
            if player.gui[guiPos].logisticsFrame.contentFrame.itemsFrame ~= nil then
                player.gui[guiPos].logisticsFrame.contentFrame.itemsFrame.destroy()
            end

            local itemsFrame = contentFrame.add({type = "frame", name = "itemsFrame", style = "lv_items_frame", direction = "vertical"})

            -- sort settings
            local sort_by = sort_by or global.sort[index][currentTab]["by"]
            local sort_by_code = global.codeToName[currentTab][sort_by]
            local sort_dir = sort_dir or global.sort[index][currentTab]["dir"]

            local orderfunc = function(t,a,b) if t[b][sort_by_code] ~= nil and t[a][sort_by_code] ~= nil then return t[b][sort_by_code] < t[a][sort_by_code] end end
            if sort_dir == "asc" then
                orderfunc = function(t,a,b) if t[b][sort_by_code] ~= nil and t[a][sort_by_code] ~= nil then return t[b][sort_by_code] > t[a][sort_by_code] end end
            end

            if sort_by == "name" then
                orderfunc = function(t,a,b) return b < a end
                if sort_dir == "asc" then
                    orderfunc = function(t,a,b) return b > a end
                end
            end

            -- search settings
            local searchText = search or global.searchText[index][currentTab]
            if searchText then
                -- filter items based on search string
                items = table.filter(items, function(v, k, t) return string.find(k, searchText) ~= nil end)
            else
                items = items
            end

            local itemsCount = count(items)
            -- get page settings
            local page = page or global.itemsPage[index][currentTab]
            local current = 0
            local itemsPerPage = global.settings[index].itemsPerPage
            local maxPages = math.ceil(itemsCount/itemsPerPage)
            page = math.min(page, maxPages)
            local start = (page-1) * itemsPerPage + 1
            local max = start + itemsPerPage - 1


            -- generate items table
            if player.gui[guiPos].logisticsFrame.contentFrame.itemsFrame.itemsTable ~= nil then
                player.gui[guiPos].logisticsFrame.contentFrame.itemsFrame.itemsTable.destroy()
            end
            itemsTable = itemsFrame.add({type ="table", name = "itemsTable", colspan = 8, style = "lv_items_table"})
            
            -- set items table dynamic height
            itemsTable.style.minimal_height = itemsPerPage * 42

            -- item image column
            itemsTable.add({type = "label", name = "itemImage", caption = " "})

            -- item name column
            local isSelected = sort_by == 'name'
            local buttonStyle = isSelected and "_selected" or ""
            local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

            local nameFlow = itemsTable.add({type = "flow", name = "nameFlow", direction = "horizontal", style = "lv_name_flow"})
            nameFlow.add({type = "button", name = "itemSort_name", caption = {"name"}, style = "lv_button_name" .. buttonStyle})
            local nameSortFlow = nameFlow.add({type = "flow", name = "nameSortFlow", direction = "vertical", style = "lv_sort_flow"})
            nameSortFlow.add({type = "frame", name = "nameSortHolder", style = "lv_sort_holder"})
            nameSortFlow.add({type = "frame", name = "name_sort", style = "lv_sort" .. sortDirStyle})

            -- add generated table headers
            for code,field in pairs(global.codeToName[currentTab]) do
                if code ~= "name" and code ~= "total" then
                    local isSelected = sort_by == code
                    local buttonStyle = isSelected and "_selected" or ""
                    local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                    local codeFlow = itemsTable.add({type = "flow", name = code .. "Flow", direction = "horizontal", style = "lv_table_flow"})
                    codeFlow.add({type = "button", name = "itemSort_" .. code, style = "lv_button_" .. code .. buttonStyle})
                    local codeSortFlow = codeFlow.add({type = "flow", name = code .. "SortFlow", direction = "vertical", style = "lv_sort_flow"})
                    codeSortFlow.add({type = "frame", name = code .. "SortHolder", style = "lv_sort_holder"})
                    codeSortFlow.add({type = "frame", name = code .. "_sort", style = "lv_sort" .. sortDirStyle})
                end
            end

            -- totals column
            local isSelected = sort_by == 'total'
            local buttonStyle = isSelected and "_selected" or ""
            local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

            local totalFlow = itemsTable.add({type = "flow", name = "totalFlow", direction = "horizontal", style = "lv_total_flow"})
            totalFlow.add({type = "button", name = "itemSort_total", caption = {"item-count"}, style = "lv_button_total" .. buttonStyle})
            local totalSortFlow = totalFlow.add({type = "flow", name = "totalSortFlow", direction = "vertical", style = "lv_sort_flow"})
            totalSortFlow.add({type = "frame", name = "totalSortHolder", style = "lv_sort_holder"})
            totalSortFlow.add({type = "frame", name = "total_sort", style = "lv_sort" .. sortDirStyle})

            -- info column
            itemsTable.add({type = "label", name = "itemInfo", caption = {"item-info"}, syle = "lv_items_info_flow"})

            -- get filtered/sorted items
            for name,item in spairs(items, orderfunc) do
                current= current + 1
                if current >= start and current <= max then
                    itemsTable.add({type = "button", name = "itemIcon_" .. name, style = "item-icon-".. name})
                    itemsTable.add({type = "label", name = "itemName_" .. name, caption = game.get_localised_item_name(name)})
                    for code,field in pairs(global.codeToName[currentTab]) do
                        if code ~= "name" and code ~= "total" then
                            itemsTable.add({type = "label", name = "itemCount" .. string.upper(code) .. "_" .. name, caption = number_format(item[field])})
                        end
                    end
                    itemsTable.add({type = "label", name = "itemTotal_" .. name, caption = number_format(item["total"])})
                    itemsTable.add({type = "button", name = "viewItemInfo_" .. name, style = "lv_button_info"})
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

--- Show item totals info frame
function updateItemTotalsInfo(info, player, index)
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

    -- all
    infoFrameName = infoFlow.add({type = "frame", name = currentTab .. "infoFrameName", style = "lv_info_frame", direction = "horizontal"})
    infoFrameName.add({type = "label", name = currentTab .. "infoFrameNameIcon", style = "lv_info_label", caption = {"name"}})
    infoFrameName.add({type = "label", name = currentTab .. "infoFrameNameName", style = "label_style", caption = game.get_localised_item_name(currentItem)})


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
function updateItemFilters(player, index)
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
    typeFilterFrame.add({type = "checkbox", name = "itemInfoFilter_logistics", style = "checkbox_style", caption = "Logistics", state = logisticsState})
    typeFilterFrame.add({type = "checkbox", name = "itemInfoFilter_normal", style = "checkbox_style", caption = "Normal", state = normalState})


    local chestsFilterFrame = filtersFlow["chestsFilterFrame"]
    if chestsFilterFrame ~= nil then
        chestsFilterFrame.destroy()
    end

    local buttonStyle = filters["chests"]["all"] ~= nil and "_selected" or ""
    chestsFilterFrame = filtersFlow.add({type = "frame", name = "chestsFilterFrame", style = "lv_filters_frame", direction = "horizontal"})
    chestsFilterFrame.add({type = "button", name = "itemInfoFilter_all", caption = "All", style = "lv_button_all" .. buttonStyle})
    for type,codes in pairs(global.codeToName) do
        for code,name in pairs(codes) do
            if code ~= "name" and code ~= "total" then
                local buttonStyle = filters["chests"][code] ~= nil and "_selected" or ""
                chestsFilterFrame.add({type = "button", name = "itemInfoFilter_" .. code, style = "lv_button_" .. code .. buttonStyle})
            end
        end
    end

end

---- Show item info
function showItemInfo(item, player, index, page, sort_by, sort_dir)
    if item then
        local guiPos = global.settings[index].guiPos
        local exTools = global.settings[index].exTools
        local currentTab = "itemInfo"
        global.currentTab[index] = currentTab
        local filters = global.itemInfoFilters[index]
        local info = getItemInfo(item, player, index, filters)
        local chests = info["chests"]
        local total = info["total"]

        if player.gui[guiPos].logisticsFrame ~= nil and player.gui[guiPos].logisticsFrame.contentFrame ~= nil then

            local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame

            -- show item totals info
                updateItemTotalsInfo(info, player, index)
                updateItemFilters(player, index)

            -- create chests frame
            if player.gui[guiPos].logisticsFrame.contentFrame.itemInfoFrame ~= nil then
                player.gui[guiPos].logisticsFrame.contentFrame.itemInfoFrame.destroy()
            end

            local itemInfoFrame = contentFrame.add({type = "frame", name = "itemInfoFrame", style = "lv_items_frame", direction = "vertical"})

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

            local chestsCount = count(chests)
            -- get page settings
            local page = page or global.itemsPage[index][currentTab]
            local current = 0
            local itemsPerPage = global.settings[index].itemsPerPage
            local maxPages = math.ceil(chestsCount/itemsPerPage)
            page = math.min(page, maxPages)
            local start = (page-1) * itemsPerPage + 1
            local max = start + itemsPerPage - 1


            -- generate items table
            if player.gui[guiPos].logisticsFrame.contentFrame.itemInfoFrame.itemInfoTable ~= nil then
                player.gui[guiPos].logisticsFrame.contentFrame.itemInfoFrame.itemInfoTable.destroy()
            end

            if chestsCount > 0 then
                itemInfoTable = itemInfoFrame.add({type ="table", name = "itemInfoTable", colspan = 5, style = "lv_items_table"})


                -- chest image column

                itemInfoTable.add({type = "label", name = "itemInfo_icon", caption = " "})

                -- chest name column
                local isSelected = sort_by == 'name'
                local buttonStyle = isSelected and "_selected" or ""
                local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                local nameFlow = itemInfoTable.add({type = "flow", name = "nameFlow", direction = "horizontal", style = "lv_name_flow"})
                nameFlow.add({type = "button", name = "itemInfo_name", caption = {"chest-type"}, style = "lv_button_name" .. buttonStyle})
                local nameSortFlow = nameFlow.add({type = "flow", name = "nameSortFlow", direction = "vertical", style = "lv_sort_flow"})
                nameSortFlow.add({type = "frame", name = "nameSortHolder", style = "lv_sort_holder"})
                nameSortFlow.add({type = "frame", name = "name_sort", style = "lv_sort" .. sortDirStyle})

                -- chest position column
                local isSelected = sort_by == 'pos'
                local buttonStyle = isSelected and "_selected" or ""
                local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                local posFlow = itemInfoTable.add({type = "flow", name = "posFlow", direction = "horizontal", style = "lv_pos_flow"})
                posFlow.add({type = "button", name = "itemInfo_pos", caption = {"chest-pos"}, style = "lv_button_pos" .. buttonStyle})
                local posSortFlow = posFlow.add({type = "flow", name = "posSortFlow", direction = "vertical", style = "lv_sort_flow"})
                posSortFlow.add({type = "frame", name = "posSortHolder", style = "lv_sort_holder"})
                posSortFlow.add({type = "frame", name = "pos_sort", style = "lv_sort" .. sortDirStyle})

                -- chest count column
                local isSelected = sort_by == 'count'
                local buttonStyle = isSelected and "_selected" or ""
                local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                local countFlow = itemInfoTable.add({type = "flow", name = "countFlow", direction = "horizontal", style = "lv_total_flow"})
                countFlow.add({type = "button", name = "itemInfo_count", caption = {"chest-count"}, style = "lv_button_total" .. buttonStyle})
                local countSortFlow = countFlow.add({type = "flow", name = "countSortFlow", direction = "vertical", style = "lv_sort_flow"})
                countSortFlow.add({type = "frame", name = "countSortHolder", style = "lv_sort_holder"})
                countSortFlow.add({type = "frame", name = "count_sort", style = "lv_sort" .. sortDirStyle})

                -- tools column
                itemInfoTable.add({type = "label", name = "itemInfo_tools", caption = {"chest-tools"}})

                -- get filtered/sorted items
                for key,chest in spairs(chests, orderfunc) do
                    local count = chest.count
                    local name = chest.name
                    local pos = chest.pos
                    local code = nameToCode(name)

                    local deconstructed = chest.entity.to_be_deconstructed(player.force)
                    local deleteBtnStyle = deconstructed and "_selected" or ""

                    current= current + 1
                    if current >= start and current <= max then
                        itemInfoTable.add({type = "button", name = "itemInfoIcon_" .. key, style = "item-icon-".. name})
                        itemInfoTable.add({type = "label", name = "itemInfoType_" .. key, caption = game.get_localised_item_name(name)})
                        itemInfoTable.add({type = "label", name = "itemInfoPos_" .. key, caption = pos.x .. " : " .. pos.y})
                        itemInfoTable.add({type = "label", name = "itemInfoCount_" .. key, caption = number_format(count)})
                        local toolsFlow = itemInfoTable["itemInfoTools_" .. key]
                        if toolsFlow == nil then
                            toolsFlow = itemInfoTable.add({type = "flow", name = "itemInfoTools_" .. key, direction = "horizontal", style = "lv_tools_flow"})
                        end
                        toolsFlow.add({type = "button", name = "itemAction_location_" .. key, style = "lv_button_location"})
                        if exTools then toolsFlow.add({type = "button", name = "itemAction_teleport_" .. key, style = "lv_button_teleport"}) end
                        toolsFlow.add({type = "button", name = "itemAction_delete_" .. key, style = "lv_button_delete" .. deleteBtnStyle})
                        if exTools then
                            if code ~= "apc" then toolsFlow.add({type = "button", name = "itemAction_apc_" .. key, style = "lv_button_up_apc"}) end
                            if code ~= "ppc" then toolsFlow.add({type = "button", name = "itemAction_ppc_" .. key, style = "lv_button_up_ppc"}) end
                            if code ~= "sc" then toolsFlow.add({type = "button", name = "itemAction_sc_" .. key, style = "lv_button_up_sc"}) end
                            if code ~= "rc" then toolsFlow.add({type = "button", name = "itemAction_rc_" .. key, style = "lv_button_up_rc"}) end
                        end
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


---- Show disconnected chests info
function showDisconnectedInfo(player, index, page, sort_by, sort_dir)
    local disconnected = global.disconnectedChests[player.force.name]
    local chestsCount = count(disconnected)

    if chestsCount > 0 then

        local guiPos = global.settings[index].guiPos
        local exTools = global.settings[index].exTools
        local currentTab = "disconnected"
        global.currentTab[index] = currentTab
        local chests = disconnected

        if player.gui[guiPos].logisticsFrame ~= nil and player.gui[guiPos].logisticsFrame.contentFrame ~= nil then

            local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame

            -- create chests frame
            if player.gui[guiPos].logisticsFrame.contentFrame.disconnectedFrame ~= nil then
                player.gui[guiPos].logisticsFrame.contentFrame.disconnectedFrame.destroy()
            end

            local disconnectedFrame = contentFrame.add({type = "frame", name = "disconnectedFrame", style = "lv_items_frame", direction = "vertical"})

            -- sort settings
            local sort_by = sort_by or global.sort[index][currentTab]["by"]
            local sort_dir = sort_dir or global.sort[index][currentTab]["dir"]

            local orderfunc = function(t,a,b) return t[b][sort_by] < t[a][sort_by] end
            if sort_dir == "asc" then
                orderfunc = function(t,a,b) return t[b][sort_by] > t[a][sort_by] end
            end

            if sort_by == "position" then
                orderfunc = function(t,a,b) if t[a][sort_by].x  == t[b][sort_by].x then return t[a][sort_by].y > t[b][sort_by].y end return t[a][sort_by].x > t[b][sort_by].x end
                if sort_dir == "asc" then
                    orderfunc = function(t,a,b) if t[a][sort_by].x  == t[b][sort_by].x then return t[a][sort_by].y < t[b][sort_by].y end return t[a][sort_by].x < t[b][sort_by].x end
                end
            end

            if sort_by == "count" then
                orderfunc = function(t,a,b) return t[b].get_item_count() < t[a].get_item_count() end
                if sort_dir == "asc" then
                    orderfunc = function(t,a,b) return t[b].get_item_count() > t[a].get_item_count() end
                end
            end

            -- get page settings
            local page = page or global.itemsPage[index][currentTab]
            local current = 0
            local itemsPerPage = global.settings[index].itemsPerPage
            local maxPages = math.ceil(chestsCount/itemsPerPage)
            page = math.min(page, maxPages)
            local start = (page-1) * itemsPerPage + 1
            local max = start + itemsPerPage - 1


            -- generate items table
            if player.gui[guiPos].logisticsFrame.contentFrame.disconnectedFrame.disconnectedTable ~= nil then
                player.gui[guiPos].logisticsFrame.contentFrame.disconnectedFrame.disconnectedTable.destroy()
            end

            if chestsCount > 0 then
                disconnectedTable = disconnectedFrame.add({type ="table", name = "disconnectedTable", colspan = 5, style = "lv_items_table"})

                -- chest image column

                disconnectedTable.add({type = "label", name = "disconnectedInfo_icon", caption = " "})

                -- chest name column
                local isSelected = sort_by == 'name'
                local buttonStyle = isSelected and "_selected" or ""
                local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                local nameFlow = disconnectedTable.add({type = "flow", name = "nameFlow", direction = "horizontal", style = "lv_name_flow"})
                nameFlow.add({type = "button", name = "disconnectedInfo_name", caption = {"chest-type"}, style = "lv_button_name" .. buttonStyle})
                local nameSortFlow = nameFlow.add({type = "flow", name = "nameSortFlow", direction = "vertical", style = "lv_sort_flow"})
                nameSortFlow.add({type = "frame", name = "nameSortHolder", style = "lv_sort_holder"})
                nameSortFlow.add({type = "frame", name = "name_sort", style = "lv_sort" .. sortDirStyle})

                -- chest position column
                local isSelected = sort_by == 'position'
                local buttonStyle = isSelected and "_selected" or ""
                local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                local posFlow = disconnectedTable.add({type = "flow", name = "positionFlow", direction = "horizontal", style = "lv_pos_flow"})
                posFlow.add({type = "button", name = "disconnectedInfo_position", caption = {"chest-pos"}, style = "lv_button_position" .. buttonStyle})
                local posSortFlow = posFlow.add({type = "flow", name = "positionSortFlow", direction = "vertical", style = "lv_sort_flow"})
                posSortFlow.add({type = "frame", name = "positionSortHolder", style = "lv_sort_holder"})
                posSortFlow.add({type = "frame", name = "position_sort", style = "lv_sort" .. sortDirStyle})

                -- chest count column
                local isSelected = sort_by == 'count'
                local buttonStyle = isSelected and "_selected" or ""
                local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                local countFlow = disconnectedTable.add({type = "flow", name = "countFlow", direction = "horizontal", style = "lv_total_flow"})
                countFlow.add({type = "button", name = "disconnectedInfo_count", caption = {"chest-count"}, style = "lv_button_total" .. buttonStyle})
                local countSortFlow = countFlow.add({type = "flow", name = "countSortFlow", direction = "vertical", style = "lv_sort_flow"})
                countSortFlow.add({type = "frame", name = "countSortHolder", style = "lv_sort_holder"})
                countSortFlow.add({type = "frame", name = "count_sort", style = "lv_sort" .. sortDirStyle})

                -- tools column
                disconnectedTable.add({type = "label", name = "disconnectedInfo_tools", caption = {"chest-tools"}})

                -- get filtered/sorted items
                for key,chest in spairs(chests, orderfunc) do
                    local count = chest.get_item_count()
                    local name = chest.name
                    local pos = chest.position
                    local code = nameToCode(name)


                    local deconstructed = chest.to_be_deconstructed(player.force)
                    local deleteBtnStyle = deconstructed and "_selected" or ""

                    current= current + 1
                    if current >= start and current <= max then
                        disconnectedTable.add({type = "button", name = "disconnectedInfoIcon_" .. key, style = "item-icon-".. name})
                        disconnectedTable.add({type = "label", name = "disconnectedInfoType_" .. key, caption = game.get_localised_item_name(name)})
                        disconnectedTable.add({type = "label", name = "disconnectedInfoPos_" .. key, caption = pos.x .. " : " .. pos.y})
                        disconnectedTable.add({type = "label", name = "disconnectedInfoCount_" .. key, caption = number_format(count)})
                        local toolsFlow = disconnectedTable["disconnectedInfoTools_" .. key]
                        if toolsFlow == nil then
                            toolsFlow = disconnectedTable.add({type = "flow", name = "disconnectedInfoTools_" .. key, direction = "horizontal", style = "lv_tools_flow"})
                        end
                        toolsFlow.add({type = "button", name = "disconnectedAction_location_" .. key, style = "lv_button_location"})
                        if exTools then toolsFlow.add({type = "button", name = "disconnectedAction_teleport_" .. key, style = "lv_button_teleport"}) end
                        toolsFlow.add({type = "button", name = "disconnectedAction_delete_" .. key, style = "lv_button_delete" .. deleteBtnStyle})
                        if exTools then
                            if code ~= "apc" then toolsFlow.add({type = "button", name = "disconnectedAction_apc_" .. key, style = "lv_button_up_apc"}) end
                            if code ~= "ppc" then toolsFlow.add({type = "button", name = "disconnectedAction_ppc_" .. key, style = "lv_button_up_ppc"}) end
                            if code ~= "sc" then toolsFlow.add({type = "button", name = "disconnectedAction_sc_" .. key, style = "lv_button_up_sc"}) end
                            if code ~= "rc" then toolsFlow.add({type = "button", name = "disconnectedAction_rc_" .. key, style = "lv_button_up_rc"}) end
                        end
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