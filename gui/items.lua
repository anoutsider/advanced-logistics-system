---- Update/Show items table
function updateItemsTable(items, player, index, page, search, sort_by, sort_dir)
    if items then
        local guiPos = global.settings[index].guiPos
        local currentTab = global.currentTab[index]	
		local iconsCount = count(global.codeToName[currentTab])
        local column_count =  iconsCount + 2
		
        if player.gui[guiPos].logisticsFrame ~= nil and player.gui[guiPos].logisticsFrame.contentFrame ~= nil then

            local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame

            -- add info widget
                addItemsInfoWidget(player, index)
                addDisconnectedInfoWidget(player, index)
                addNetwroksInfoWidget(player, index)

            -- add search widget
                addSearchWidget(player, index)
                
            -- add network filters widget    
                addNetworkFiltersWidget(player, index)

            -- create items frame
            if player.gui[guiPos].logisticsFrame.contentFrame.itemsFrame ~= nil then
                player.gui[guiPos].logisticsFrame.contentFrame.itemsFrame.destroy()
            end

            local itemsFrame = contentFrame.add({type = "frame", name = "itemsFrame", style = "als_items_frame", direction = "vertical"})

            -- sort settings
            local sort_by = sort_by or global.sort[index][currentTab]["by"]
            local sort_by_code = global.codeToName[currentTab][sort_by]
            local sort_dir = sort_dir or global.sort[index][currentTab]["dir"]

            local orderfunc = function(t,a,b) if t[b][sort_by_code] == nil then t[b][sort_by_code] = 0 end if t[a][sort_by_code] == nil then t[a][sort_by_code] = 0 end return t[b][sort_by_code] < t[a][sort_by_code] end
            if sort_dir == "asc" then
                orderfunc = function(t,a,b) if t[b][sort_by_code] == nil then t[b][sort_by_code] = 0 end if t[a][sort_by_code] == nil then t[a][sort_by_code] = 0 end return t[b][sort_by_code] > t[a][sort_by_code] end
            end

            if sort_by == "name" then
                orderfunc = function(t,a,b) return b < a end
                if sort_dir == "asc" then
                    orderfunc = function(t,a,b) return b > a end
                end
            end

            -- search settings
            local searchText = search or global.searchText[index][currentTab] or ""
            searchText = escapePattern(searchText)
            if searchText ~= "" then
                -- filter items based on search string
                items = table.filter(items, function(v, k, t)
                    return string.find(k, searchText) ~= nil
                end)
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
            itemsTable = itemsFrame.add({type = "table", name = "itemsTable", column_count = column_count, style = "als_items_table"})
            
            -- set items table dynamic height
            --itemsTable.style.minimal_height = itemsPerPage * 49

            -- item image column
            itemsTable.add({type = "flow", name = "itemIcon", caption = " ", style = "als_icon_flow"})

            -- item name column
            local isSelected = sort_by == 'name'
            local buttonStyle = isSelected and "_selected" or ""
            local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

            local nameFlow = itemsTable.add({type = "flow", name = "nameFlow", direction = "horizontal", style = "als_name_flow"})
            nameFlow.add({type = "button", name = "itemSort_name", caption = {"name"}, style = "als_button_name" .. buttonStyle})
            local nameSortFlow = nameFlow.add({type = "flow", name = "nameSortFlow", direction = "vertical", style = "als_sort_flow"})
            nameSortFlow.add({type = "frame", name = "nameSortHolder", style = "als_sort_holder"})
            nameSortFlow.add({type = "frame", name = "name_sort", style = "als_sort" .. sortDirStyle})

            -- add generated table headers
            for code,name in pairs(global.codeToName[currentTab]) do
                if code ~= "name" and code ~= "total" then
					local spritePath = getItemSprite(player, name)
					if spritePath then
						local isSelected = sort_by == code
						local buttonStyle = isSelected and "_selected" or ""
						local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

						local codeFlow = itemsTable.add({type = "flow", name = code .. "Flow", direction = "horizontal", style = "als_table_flow"})                    
						codeFlow.add({type = "sprite-button", name = "itemSort_" .. code, style = "als_item_icon_small" .. buttonStyle, sprite = spritePath, tooltip = getLocalisedName(name)})
						local codeSortFlow = codeFlow.add({type = "flow", name = code .. "SortFlow", direction = "vertical", style = "als_sort_flow"})
						codeSortFlow.add({type = "frame", name = code .. "SortHolder", style = "als_sort_holder"})
						codeSortFlow.add({type = "frame", name = code .. "_sort", style = "als_sort" .. sortDirStyle})
					end
                end
            end

            -- totals column
            local isSelected = sort_by == 'total'
            local buttonStyle = isSelected and "_selected" or ""
            local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

            local totalFlow = itemsTable.add({type = "flow", name = "totalFlow", direction = "horizontal", style = "als_total_flow"})
            totalFlow.add({type = "button", name = "itemSort_total", caption = {"item-count"}, style = "als_button_total" .. buttonStyle})
            local totalSortFlow = totalFlow.add({type = "flow", name = "totalSortFlow", direction = "vertical", style = "als_sort_flow"})
            totalSortFlow.add({type = "frame", name = "totalSortHolder", style = "als_sort_holder"})
            totalSortFlow.add({type = "frame", name = "total_sort", style = "als_sort" .. sortDirStyle})

            -- info column
            local itemsInfoWrapper = itemsTable.add({type = "flow", name = "itemsInfoWrapper", direction = "horizontal", style = "als_items_info_flow"})	
            itemsInfoWrapper.add({type = "label", name = "itemInfo", caption = {"item-info"}})

            -- get filtered/sorted items
            for name,item in spairs(items, orderfunc) do
                current= current + 1
                if current >= start and current <= max then
					local spritePath = getItemSprite(player, name)
					if spritePath then
						itemsTable.add({type = "sprite-button", name = "itemIcon_" .. name, style = "als_item_icon", sprite = spritePath})
					else
						itemsTable.add({type = "sprite-button", name = "itemIcon_" .. name, style = "als_item_icon"})
					end
                    itemsTable.add({type = "label", name = "itemName_" .. name, caption = getLocalisedName(name)})
                    for code,field in pairs(global.codeToName[currentTab]) do
                        if code ~= "name" and code ~= "total" then
                            itemsTable.add({type = "label", name = "itemCount" .. string.upper(code) .. "_" .. name, caption = number_format(item[field])})
                        end
                    end
                    itemsTable.add({type = "label", name = "itemTotal_" .. name, caption = number_format(item["total"])})
                    itemsTable.add({type = "button", name = "viewItemInfo_" .. name, style = "als_button_info", tooltip = {"tooltips.view-info-item"}})
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

---- Show item info
function showItemInfo(item, player, index, page, sort_by, sort_dir)
    if item then
        local guiPos = global.settings[index].guiPos
        local exTools = global.settings[index].exTools
        local autoFilter = global.settings[index].autoFilter
        local currentTab = "itemInfo"
        local prevTab = global.currentTab[index]
        global.currentTab[index] = currentTab
        local filters = global.itemInfoFilters[index]
        
        -- check for default filters based on previous table
        if autoFilter and prevTab ~= currentTab then
            if prevTab == "logistics" then
                filters["group"]["normal"] = nil
                filters["group"]["logistics"] = true
            elseif prevTab == "normal" then
                filters["group"]["logistics"] = nil
                filters["group"]["normal"] = true
            end   
            global.itemInfoFilters[index] = filters
        end
        
        local info = getItemInfo(item, player, index, filters)
        local chests = info["chests"]
        local total = info["total"]
        


        if player.gui[guiPos].logisticsFrame ~= nil and player.gui[guiPos].logisticsFrame.contentFrame ~= nil then

            local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame
           
            -- show item totals info
                addItemTotalsInfoWidget(info, player, index)                            
                addItemFiltersWidget(player, index)
                
            -- add network filters widget    
                addNetworkFiltersWidget(player, index)                    

            -- create chests frame
            if player.gui[guiPos].logisticsFrame.contentFrame.itemInfoFrame ~= nil then
                player.gui[guiPos].logisticsFrame.contentFrame.itemInfoFrame.destroy()
            end

            local itemInfoFrame = contentFrame.add({type = "frame", name = "itemInfoFrame", style = "als_items_frame", direction = "vertical"})

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
                itemInfoTable = itemInfoFrame.add({type ="table", name = "itemInfoTable", column_count = 5, style = "als_items_table"})
				
                -- chest image column
                itemInfoTable.add({type = "flow", name = "itemInfo_icon", caption = " ", style = "als_icon_flow"})

                -- chest name column
                local isSelected = sort_by == 'name'
                local buttonStyle = isSelected and "_selected" or ""
                local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                local nameFlow = itemInfoTable.add({type = "flow", name = "nameFlow", direction = "horizontal", style = "als_name_flow"})
                nameFlow.add({type = "button", name = "itemInfo_name", caption = {"chest-type"}, style = "als_button_name" .. buttonStyle})
                local nameSortFlow = nameFlow.add({type = "flow", name = "nameSortFlow", direction = "vertical", style = "als_sort_flow"})
                nameSortFlow.add({type = "frame", name = "nameSortHolder", style = "als_sort_holder"})
                nameSortFlow.add({type = "frame", name = "name_sort", style = "als_sort" .. sortDirStyle})

                -- chest position column
                local isSelected = sort_by == 'pos'
                local buttonStyle = isSelected and "_selected" or ""
                local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                local posFlow = itemInfoTable.add({type = "flow", name = "posFlow", direction = "horizontal", style = "als_pos_flow"})
                posFlow.add({type = "button", name = "itemInfo_pos", caption = {"chest-pos"}, style = "als_button_pos" .. buttonStyle})
                local posSortFlow = posFlow.add({type = "flow", name = "posSortFlow", direction = "vertical", style = "als_sort_flow"})
                posSortFlow.add({type = "frame", name = "posSortHolder", style = "als_sort_holder"})
                posSortFlow.add({type = "frame", name = "pos_sort", style = "als_sort" .. sortDirStyle})

                -- chest count column
                local isSelected = sort_by == 'count'
                local buttonStyle = isSelected and "_selected" or ""
                local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

                local countFlow = itemInfoTable.add({type = "flow", name = "countFlow", direction = "horizontal", style = "als_total_flow"})
                countFlow.add({type = "button", name = "itemInfo_count", caption = {"chest-count"}, style = "als_button_total" .. buttonStyle})
                local countSortFlow = countFlow.add({type = "flow", name = "countSortFlow", direction = "vertical", style = "als_sort_flow"})
                countSortFlow.add({type = "frame", name = "countSortHolder", style = "als_sort_holder"})
                countSortFlow.add({type = "frame", name = "count_sort", style = "als_sort" .. sortDirStyle})

                -- tools column                
				local itemInfoToolsWrapper = itemInfoTable.add({type = "flow", name = "itemInfoToolsWrapper", direction = "horizontal", style = "als_tools_flow"})	
				itemInfoToolsWrapper.add({type = "label", name = "itemInfo_tools", caption = {"chest-tools"}})				
				
                -- get filtered/sorted items
				if exTools then
					tooltip_upgrade_apc = {"tooltips.tools-upgrade", getLocalisedName(codeToName("apc"))}
					tooltip_upgrade_ppc = {"tooltips.tools-upgrade", getLocalisedName(codeToName("ppc"))}
					tooltip_upgrade_sc = {"tooltips.tools-upgrade", getLocalisedName(codeToName("sc"))}
					tooltip_upgrade_rc = {"tooltips.tools-upgrade", getLocalisedName(codeToName("rc"))}
				end
                for key,chest in spairs(chests, orderfunc) do
                    local itemsCount = chest.count
                    local name = getCompName(chest.name)
                    name = name and name or chest.name
                    local pos = chest.pos
                    local code = nameToCode(name)

                    local deconstructed = chest.entity.to_be_deconstructed(player.force)
                    local deleteBtnStyle = deconstructed and "_selected" or ""

                    current= current + 1
                    if current >= start and current <= max then
						local spritePath = getItemSprite(player, name)
						if spritePath then
							itemInfoTable.add({type = "sprite-button", name = "itemInfoIcon_" .. key, style = "als_item_icon", sprite = spritePath})		
						else
							itemInfoTable.add({type = "sprite-button", name = "itemInfoIcon_" .. key, style = "als_item_icon"})
						end
                        itemInfoTable.add({type = "label", name = "itemInfoType_" .. key, caption = getLocalisedName(name)})
                        itemInfoTable.add({type = "label", name = "itemInfoPos_" .. key, caption = pos.x .. " : " .. pos.y})
                        itemInfoTable.add({type = "label", name = "itemInfoCount_" .. key, caption = number_format(itemsCount)})
                        local toolsFlow = itemInfoTable["itemInfoTools_" .. key]
                        if toolsFlow == nil then
                            toolsFlow = itemInfoTable.add({type = "flow", name = "itemInfoTools_" .. key, direction = "horizontal", style = "als_tools_flow"})
                        end
						
                        toolsFlow.add({type = "button", name = "itemAction_location_" .. key, style = "als_button_location", tooltip = {"tooltips.tools-location"}})
                        if exTools then toolsFlow.add({type = "button", name = "itemAction_teleport_" .. key, style = "als_button_teleport", tooltip = {"tooltips.tools-teleport"}}) end
                        toolsFlow.add({type = "button", name = "itemAction_delete_" .. key, style = "als_button_delete" .. deleteBtnStyle, tooltip={"tooltips.tools-delete"}})
                        if exTools then
                            if code ~= "apc" then toolsFlow.add({type = "button", name = "itemAction_apc_" .. key, style = "als_button_up_apc", tooltip = tooltip_upgrade_apc}) end
                            if code ~= "ppc" then toolsFlow.add({type = "button", name = "itemAction_ppc_" .. key, style = "als_button_up_ppc", tooltip = tooltip_upgrade_ppc}) end
                            if code ~= "sc" then toolsFlow.add({type = "button", name = "itemAction_sc_" .. key, style = "als_button_up_sc", tooltip = tooltip_upgrade_sc}) end
                            if code ~= "rc" then toolsFlow.add({type = "button", name = "itemAction_rc_" .. key, style = "als_button_up_rc", tooltip = tooltip_upgrade_rc}) end
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
                pager.add({type = "button", name = "prevPage_" .. prevPage , caption = "<", style = "als_button"})
                pager.add({type = "label", name = "pageTotal", caption = page.."/"..maxPages})
                pager.add({type = "button", name = "nextPage_" .. nextPage , caption = ">", style = "als_button"})
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
		local filters = global.disconnectedFilters[index]
		
        if player.gui[guiPos].logisticsFrame ~= nil and player.gui[guiPos].logisticsFrame.contentFrame ~= nil then

            local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame

			-- add info widgets
			addDisconnectedInfoWidget(player, index)
			
			-- add filters widget
			addDisconnectedFiltersWidget(player, index)		
			
            -- create chests frame
            if player.gui[guiPos].logisticsFrame.contentFrame.disconnectedFrame ~= nil then
                player.gui[guiPos].logisticsFrame.contentFrame.disconnectedFrame.destroy()
            end

            local disconnectedFrame = contentFrame.add({type = "frame", name = "disconnectedFrame", style = "als_items_frame", direction = "vertical"})

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

            disconnectedTable = disconnectedFrame.add({type ="table", name = "disconnectedTable", column_count = 5, style = "als_items_table"})

            -- chest image column
            disconnectedTable.add({type = "flow", name = "disconnectedInfo_icon", caption = " ", style = "als_icon_flow"})

            -- chest name column
            local isSelected = sort_by == 'name'
            local buttonStyle = isSelected and "_selected" or ""
            local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

            local nameFlow = disconnectedTable.add({type = "flow", name = "nameFlow", direction = "horizontal", style = "als_name_flow"})
            nameFlow.add({type = "button", name = "disconnectedInfo_name", caption = {"chest-type"}, style = "als_button_name" .. buttonStyle})
            local nameSortFlow = nameFlow.add({type = "flow", name = "nameSortFlow", direction = "vertical", style = "als_sort_flow"})
            nameSortFlow.add({type = "frame", name = "nameSortHolder", style = "als_sort_holder"})
            nameSortFlow.add({type = "frame", name = "name_sort", style = "als_sort" .. sortDirStyle})

            -- chest position column
            local isSelected = sort_by == 'position'
            local buttonStyle = isSelected and "_selected" or ""
            local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

            local posFlow = disconnectedTable.add({type = "flow", name = "positionFlow", direction = "horizontal", style = "als_pos_flow"})
            posFlow.add({type = "button", name = "disconnectedInfo_position", caption = {"chest-pos"}, style = "als_button_position" .. buttonStyle})
            local posSortFlow = posFlow.add({type = "flow", name = "positionSortFlow", direction = "vertical", style = "als_sort_flow"})
            posSortFlow.add({type = "frame", name = "positionSortHolder", style = "als_sort_holder"})
            posSortFlow.add({type = "frame", name = "position_sort", style = "als_sort" .. sortDirStyle})

            -- chest count column
            local isSelected = sort_by == 'count'
            local buttonStyle = isSelected and "_selected" or ""
            local sortDirStyle = (isSelected and sort_dir) and "_" .. sort_dir or ""

            local countFlow = disconnectedTable.add({type = "flow", name = "countFlow", direction = "horizontal", style = "als_total_flow"})
            countFlow.add({type = "button", name = "disconnectedInfo_count", caption = {"chest-count"}, style = "als_button_total" .. buttonStyle})
            local countSortFlow = countFlow.add({type = "flow", name = "countSortFlow", direction = "vertical", style = "als_sort_flow"})
            countSortFlow.add({type = "frame", name = "countSortHolder", style = "als_sort_holder"})
            countSortFlow.add({type = "frame", name = "count_sort", style = "als_sort" .. sortDirStyle})

            -- tools column
			local disconnectedInfoToolsWrapper = disconnectedTable.add({type = "flow", name = "disconnectedInfoToolsWrapper", direction = "horizontal", style = "als_tools_flow"})				
            disconnectedInfoToolsWrapper.add({type = "label", name = "disconnectedInfo_tools", caption = {"chest-tools"}})
			
            -- get filtered/sorted items
			if exTools then
				tooltip_upgrade_apc = {"tooltips.tools-upgrade", getLocalisedName(codeToName("apc"))}
				tooltip_upgrade_ppc = {"tooltips.tools-upgrade", getLocalisedName(codeToName("ppc"))}
				tooltip_upgrade_sc = {"tooltips.tools-upgrade", getLocalisedName(codeToName("sc"))}
				tooltip_upgrade_rc = {"tooltips.tools-upgrade", getLocalisedName(codeToName("rc"))}
			end			
            for key,chest in spairs(chests, orderfunc) do				                
                local name = getCompName(chest.name)
				name = name and name or chest.name
				
				if (filters and (filters["chests"][name] or filters["chests"]["all"])) or filters == nil then
					local itemsCount = chest.get_item_count()						
					local pos = chest.position
					local code = nameToCode(name)
					local deconstructed = chest.to_be_deconstructed(player.force)
					local deleteBtnStyle = deconstructed and "_selected" or ""

					current= current + 1
					if current >= start and current <= max then     
						local spritePath = getItemSprite(player, name)
						if spritePath then
							disconnectedTable.add({type = "sprite-button", name = "disconnectedInfoIcon_" .. key, style = "als_item_icon", sprite = spritePath})
						else
							disconnectedTable.add({type = "sprite-button", name = "disconnectedInfoIcon_" .. key, style = "als_item_icon"})
						end
						disconnectedTable.add({type = "label", name = "disconnectedInfoType_" .. key, caption = getLocalisedName(name)})
						disconnectedTable.add({type = "label", name = "disconnectedInfoPos_" .. key, caption = pos.x .. " : " .. pos.y})
						disconnectedTable.add({type = "label", name = "disconnectedInfoCount_" .. key, caption = number_format(itemsCount)})
						local toolsFlow = disconnectedTable["disconnectedInfoTools_" .. key]
						if toolsFlow == nil then
							toolsFlow = disconnectedTable.add({type = "flow", name = "disconnectedInfoTools_" .. key, direction = "horizontal", style = "als_tools_flow"})
						end
						toolsFlow.add({type = "button", name = "disconnectedAction_location_" .. key, style = "als_button_location", tooltip = {"tooltips.tools-location"}})
						if exTools then toolsFlow.add({type = "button", name = "disconnectedAction_teleport_" .. key, style = "als_button_teleport", tooltip = {"tooltips.tools-teleport"}}) end
						toolsFlow.add({type = "button", name = "disconnectedAction_delete_" .. key, style = "als_button_delete" .. deleteBtnStyle, tooltip = {"tooltips.tools-delete"}})
						if exTools then
							if code ~= "apc" then toolsFlow.add({type = "button", name = "disconnectedAction_apc_" .. key, style = "als_button_up_apc", tooltip = tooltip_upgrade_apc}) end
							if code ~= "ppc" then toolsFlow.add({type = "button", name = "disconnectedAction_ppc_" .. key, style = "als_button_up_ppc", tooltip = tooltip_upgrade_ppc}) end
							if code ~= "sc" then toolsFlow.add({type = "button", name = "disconnectedAction_sc_" .. key, style = "als_button_up_sc", tooltip = tooltip_upgrade_sc}) end
							if code ~= "rc" then toolsFlow.add({type = "button", name = "disconnectedAction_rc_" .. key, style = "als_button_up_rc", tooltip = tooltip_upgrade_rc}) end
						end
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
            pager.add({type = "button", name = "prevPage_" .. prevPage , caption = "<", style = "als_button"})
            pager.add({type = "label", name = "pageTotal", caption = page.."/"..maxPages})
            pager.add({type = "button", name = "nextPage_" .. nextPage , caption = ">", style = "als_button"})

        end
    end

end
