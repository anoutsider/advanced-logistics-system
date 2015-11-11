require "defines"
require "gui"
require "interface"

---  Enable/Disable Debugging
local DEV = false

--- on_init event
script.on_init(function()
    init()
    -- init player specific globals
    initPlayers()
end)

--- on_load event
script.on_load(function()
    init()
end)

--- on_configuration_changed event
script.on_configuration_changed(function()
    on_configuration_changed()
end)

--- Player Related Events
script.on_event(defines.events.on_player_created, function(event)
    playerCreated(event)
end)

--- Entity Related Events
script.on_event(defines.events.on_built_entity, function(event)
    entityBuilt(event, event.created_entity)
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
    entityBuilt(event, event.created_entity)
end)

script.on_event(defines.events.on_preplayer_mined_item, function(event)
    entityMined(event, event.entity)
end)

script.on_event(defines.events.on_robot_pre_mined, function(event)
    entityMined(event, event.entity)
end)

script.on_event(defines.events.on_entity_died, function(event)
    entityMined(event, event.entity)
end)

--- Handles items search
script.on_event(defines.events.on_tick, function(event)
        if event.tick % 60 == 0  then
            for i,p in ipairs(game.players) do
                local hasSystem = playerHasSystem(p)
                if hasSystem then
                    if (not p.gui.top["logistics-view-button"]) then
                        initGUI(p)
                    end
                    local refresh = global.settings[i].refreshInterval * 60
                    if event.tick % refresh == 0  then
                        if global.guiVisible[i] == 1 then
                            updateGUI(p, i)
                        end
                    end

                    -- check search field tick
                    if global.searchTick[i]["logistics"] ~= nil then onLogisticsSearchTick(event, i) end
                    if global.searchTick[i]["normal"] ~= nil then onNormalSearchTick(event, i) end
                elseif global.settings[i] then
                    destroyGUI(p, i)
                end
            end
        end
end)

--- Initiate default and global values
function init()
    global.guiLoaded = global.guiLoaded or {}
    global.guiVisible = global.guiVisible or {}
    global.guiReset = global.guiReset or {}
    global.currentTab = global.currentTab or {}
    global.hasSystem = global.hasSystem or {}

    global.itemsPage = global.itemsPage or {}
    global.searchText = global.searchText or {}
    global.searchTick = global.searchTick or {}
    global.sort = global.sort or {}

    global.settings = global.settings or {}
    global.settings.guiPos = global.settings.guiPos or {}
    global.settings.itemsPerPage = global.settings.itemsPerPage or {}
    global.settings.refreshInterval = global.settings.refreshInterval or {}
    global.settings.exTools = global.settings.exTools or {}
    global.settings.autoFilter = global.settings.autoFilter or {}
    global.settings.excludeReq = global.settings.excludeReq or {}

    global.roboports =  {} -- Deprecated

    global.networks = global.networks or {}
    global.networksCount = global.networksCount or {}
    global.networkEdit = global.networkEdit or {}
    global.networksNames = global.networksNames or {}
    global.networksFilter = global.networksFilter or {}
    global.currentNetwork = global.currentNetwork or {}
   

    global.logisticsChests = global.logisticsChests or {}
    global.logisticsChestsNames = global.logisticsChestsNames or getLogisticsChestNames()
    global.disconnectedChests = global.disconnectedChests or {}

    global.normalChests = global.normalChests or {}
    global.normalChestsNames = global.normalChestsNames or getNormalChestNames()

    global.logisticsItems = global.logisticsItems or {}
    global.logisticsItemsTotal = global.logisticsItemsTotal or {}

    global.normalItems = global.normalItems or {}
    global.normalItemsTotal = global.normalItemsTotal or {}

    global.currentItem = global.currentItem or {}
    global.currentItemInfo = global.currentItemInfo or  {}
    global.itemInfoFilters = global.itemInfoFilters or {}

    global.chestsUpgrade = global.chestsUpgrade or {}

    global.codeToName = {
        logistics = {
            name = "name",
            total = "total",
            ppc = "logistic-chest-passive-provider",
            sc = "logistic-chest-storage",
            rc = "logistic-chest-requester",
            apc = "logistic-chest-active-provider",
        },
        normal = {
            name = "name",
            total = "total",
            woc = "wooden-chest",
            irc = "iron-chest",
            stc = "steel-chest",
            smc = "smart-chest",
        }
    }
    
    global.compNames = {}
    -- 5dim trains
    global.compNames["logistic-chest-passive-provider-trans"] = "cargo-wagon-passive"
    global.compNames["logistic-chest-active-provider-trans"] = "cargo-wagon-active"
    global.compNames["logistic-chest-storage-provider-trans"] = "cargo-wagon-storage"
    global.compNames["logistic-chest-storage-provider-trans"] = "cargo-wagon-storage"
    global.compNames["logistic-chest-requester-trans"] = "cargo-wagon-requester"   
    global.compNames["roboport-trans"] = "cargo-wagon-roboport"   

    global.guiTabs = {"logistics", "normal", "itemInfo"}
    global.character = global.character or {}

end

--- init all players
function initPlayers()
    for i,p in ipairs(game.players) do
        initPlayer(p)
    end
end

--- init new players
function playerCreated(event)
    local player = game.players[event.player_index]
    initPlayer(player)
end

--- init player specific global values
function initPlayer(player)
    local force = player.force
    local name = force.name
    local i = player.index

    -- gui visibility
    if not global.guiVisible[i] or global.guiVisible[i] == nil then
        global.guiVisible[i] = 0
    end
    -- init settings
    if not global.settings[i] then
        global.settings[i] = {}
    end
    -- gui position settings
    if not global.settings[i].guiPos then
        global.settings[i].guiPos = "center"
    end
    -- gui items per page settings
    if not global.settings[i].itemsPerPage then
        global.settings[i].itemsPerPage = 10
    end
    -- gui refresh interval
    if not global.settings[i].refreshInterval then
        global.settings[i].refreshInterval = 1
    end
    -- experimental tools - teleport, upgrade chests / too powerfull or not fully tested
    if not global.settings[i].exTools then
        global.settings[i].exTools = false
    end    
    -- auto filter settings, automatically filters chest list based on the  previous tab logistics/normal
    if not global.settings[i].autoFilter then
        global.settings[i].autoFilter = true
    end    
    -- exclude requesters settings, excludes items in requesters from the totals calculations
    if not global.settings[i].excludeReq then
        global.settings[i].excludeReq = true
    end
    -- hasSystem
    if not global.hasSystem[name] then
        global.hasSystem[name] = nil
    end
    -- gui loaded
    if not global.guiLoaded[i] and playerHasSystem(player) and not player.gui.top["logistics-view-button"] then
        initGUI(player)
    end    
    -- gui reset
    if global.guiReset[i] == nil then
        global.guiReset[i] = true
    end
    -- networks data table
    if not global.networks[name] then
        global.networks[name] = getLogisticNetworks(force, true)
    end    
    -- networks count table
    if not global.networksCount[name] then
        global.networksCount[name] = 0
    end    
    -- networks edit table
    if not global.networkEdit[i] then
        global.networkEdit[i] = false
    end   
    -- networks names table
    if not global.networksNames[name] then
        global.networksNames[name] = {}
    end
    -- networks filter table
    if not global.networksFilter[i] then
        global.networksFilter[i] = {}
    end    
    -- out of coverage logistic containers
    if not global.disconnectedChests[name] then
        global.disconnectedChests[name] = getDisconnectedChests(force)
    end
    -- normal and smart containers
    if not global.normalChests[name] then
        global.normalChests[name] = getNormalChests(force)
    end
    -- items in logistic containers
    if not global.logisticsItems[name] then
        global.logisticsItems[name] = getLogisticsItems(force, i)
    end
    -- total number of items in logistic containers
    if not global.logisticsItemsTotal[name] then
        global.logisticsItemsTotal[name] = 0
    end
    -- items in normal and smart containers
    if not global.normalItems[name] then
        global.normalItems[name] = getNormalItems(force)
    end
    -- items in normal and smart containers
    if not global.normalItemsTotal[name] then
        global.normalItemsTotal[name] = 0
    end

    -- current active menu tab
    if not global.currentTab[i] then
        global.currentTab[i] = "logistics"
    end
    -- current active page per view type
    if not global.itemsPage[i] then
        global.itemsPage[i] = {}
        global.itemsPage[i]["logistics"] = 1
        global.itemsPage[i]["normal"] = 1
        global.itemsPage[i]["disconnected"] = 1
        global.itemsPage[i]["itemInfo"] = 1
        global.itemsPage[i]["networks"] = 1
        global.itemsPage[i]["networkInfo"] = 1
    end
    if not global.itemsPage[i]["networks"] then
        global.itemsPage[i]["networks"] = 1
    end       
    if not global.itemsPage[i]["networkInfo"] then
        global.itemsPage[i]["networkInfo"] = 1
    end    
    -- current active sort per view type
    if not global.sort[i] then
        global.sort[i] = {}
        global.sort[i]["logistics"] = {by = "total", dir = "desc"}
        global.sort[i]["normal"] = {by = "total", dir = "desc"}
        global.sort[i]["disconnected"] = {by = "count", dir = "desc"}
        global.sort[i]["itemInfo"] = {by = "count", dir = "desc"}
        global.sort[i]["networks"] = {by = "waiting", dir = "desc"}
        global.sort[i]["networkInfo"] = {by = "pos", dir = "desc"}
    end
    if not global.sort[i]["networks"] then
        global.sort[i]["networks"] = {by = "waiting", dir = "desc"}
    end    
    if not global.sort[i]["networkInfo"] then
        global.sort[i]["networkInfo"] = {by = "pos", dir = "desc"}
    end
    -- current search text per table type
    if not global.searchText[i] then
        global.searchText[i] = {}
        global.searchText[i]["logistics"] = ""
        global.searchText[i]["normal"] = ""
    end
    -- used to check the current search text
    if not global.searchTick[i] then
        global.searchTick[i] = {}
        global.searchTick[i]["logistics"] = nil
        global.searchTick[i]["normal"] = nil
    end
    -- filters used in item info view
    if not global.itemInfoFilters[i] then
        global.itemInfoFilters[i] = {}
        global.itemInfoFilters[i]["group"] = {logistics = true, normal = true}
        global.itemInfoFilters[i]["chests"] = {all = true}
    end
end

--- Hard reset all settings
function reset()
    for k,v in pairs(global) do
        global[k] = nil
    end
end

--- handles mod updates
function on_configuration_changed(data)
    local modName = "advanced-logistics-systems"
    
    if data and data.mod_changes[modName] then
        local currentVersion = data.mod_changes[modName].new_version
        local oldVersion = data.mod_changes[modName].old_version

        -- reset network names for version 0.2.10
        if newVersion == "0.2.10" and (oldVersion and oldVersion > "0.2.5") then
            global.networksNames = {}
        end
    end
end

--- Checks if the player has the system enabled
function playerHasSystem(player)
    local force = player.force.name
    local hasSystem = global.hasSystem[force]
    if hasSystem == nil then
        hasSystem = player.force and player.force.technologies["advanced-logistics-systems"].researched
    end
    return hasSystem
end

--- Entity built event handler for players & robots constructions
-- Checks if a logistics container has been built and updates the local chests table accordingly
-- Checks if a roboport has been built and updates the local roboports table accordingly
-- If a roboport is built a check will run on the logistics chests table for logistics network coverage
function entityBuilt(event, entity)
    local force = entity.force.name

    if entity.type == "logistic-container" then
        local chests = global.logisticsChests[force]
        local disconnected = global.disconnectedChests[force]
        local key = string.gsub(entity.position.x.."A"..entity.position.y, "-", "_")
        local upgrades = global.chestsUpgrade[key]
        local networks = entity.force.logistic_networks
        local network = inLogisticsNetwork(entity, entity.force, true)
        
        if network ~= nil then
            if not chests[key] then
                -- find the container network
                for i,net in pairs(networks) do
                    if net == network then
                        debugLog("Added Chest # " .. key .. "To Logistics Chests List")
                        chests[key] = {}
                        chests[key]["entity"] = entity                    
                        chests[key]["network"] = i
                        break
                    end
                end            
                
                global.logisticsChests[force] = chests
            end
        else
            if not disconnected[key] then
                debugLog("Added Chest # " .. key .. "To Disconnected Chests List")
                disconnected[key] = entity
                global.disconnectedChests[force] = disconnected
            end
        end

        -- exTools - handle upgraded chests, restore inventory
        if upgrades and upgrades.inventory then
            for n,v in pairs(upgrades.inventory) do
                local stack = {name = n, count = v}
                entity.insert(stack)
            end
            global.chestsUpgrade[key] = nil
        end

    elseif entity.type == "container" or entity.type == "smart-container" then
        local chests = global.normalChests[force]
        local key = string.gsub(entity.position.x.."A"..entity.position.y, "-", "_")
        if not chests[key] then
            debugLog("Added Chest # " .. key .. "To Normal Chests List")
            chests[key] = entity
            global.normalChests[force] = chests
        end

    elseif entity.type == "roboport" then
        getLogisticNetworks(entity.force, true)
        checkDisconnectedChests(entity.force)
    end
end

--- Entity mined event handler for players & robots deconstructions
-- Checks if a logistics container has been removed and updates the local chests table accordingly
-- Checks if a roboport has been removed and updates the local roboports table accordingly
-- If a roboport is removed a check will run on the logistics chests table for logistics network coverage
function entityMined(event, entity)
    local force = entity.force.name

    if entity.type == "logistic-container" then
        local chests = global.logisticsChests[force]
        local disconnected = global.disconnectedChests[force]
        local key = string.gsub(entity.position.x.."A"..entity.position.y, "-", "_")

        if chests[key] then
            debugLog("Removed Chest # " .. key .. "From Logistics Chests List")
            chests[key] = nil
            global.logisticsChests[force] = chests
        end

        if disconnected[key] then
            debugLog("Removed Chest # " .. key .. "From Disconnected Chests List")
            disconnected[key] = nil
            global.disconnectedChests[force] = disconnected
        end

    elseif entity.type == "container" or entity.type == "smart-container" then

        local chests = global.normalChests[force]
        local key = string.gsub(entity.position.x.."A"..entity.position.y, "-", "_")

        if chests[key] then
            debugLog("Removed Chest # " .. key .. "From Normal Chests List")
            chests[key] = nil
            global.normalChests[force] = chests
        end

    elseif entity.type == "roboport" then
        local pos = entity.position
        local net = entity.logistic_network
        local cell = entity.logistic_cell
        local radius = cell.logistic_radius        

        updateNetworksData(entity, cell)
        getLogisticNetworks(entity.force, true)
        findDisconnectedChests(pos, radius, entity.force)
    end
end

--- Updates network names and indexes when a roboport/logistic_cell is removed
-- takes an entity and logistic_cell as parameters
function updateNetworksData(entity, cell)
    local pos = entity.position
    local force = entity.force.name
    local networksData = global.networks[force]
    local names = global.networksNames[force]            
    local index = string.gsub(pos.x .. "A" .. pos.y, "-", "_")    

    -- if the removed cell has no neighbours, remove it from the names list
    if #cell.neighbours == 0 then
        if names[index] then
            names[index] = nil
            global.networksNames[force] = names
        end
    -- if the removed cell has neighbours, check if it's owner position was being used as an index for it's network 
     -- and select a new one if it was, will also update the network name index
    else              
        if networksData[index] then
            for _,netCell in pairs(cell.neighbours) do
                local cellPos = netCell.owner.position
                local newIndex = string.gsub(cellPos.x .. "A" .. cellPos.y, "-", "_")

                networksData[newIndex] = networksData[index]
                networksData[index] = nil                
                
                -- update the names index if found
                if names[index] and not names[newIndex] then
                    names[newIndex] = names[index]
                    names[index] = nil
                    global.networksNames[force] = names
                end  
                
                global.networks[force] = networksData                
            end 
        end     
    end                 
end

--- Check if a network is a player personal network
-- takes a logistic network as a parameter
function isPlayerNetwork(network)
    for _,cell in pairs(network.cells) do
        if not cell.mobile then
            return false
        else
            return true
        end
    end
end

--- Get all logistics networks that belong to a force
-- takes a player force as a parameter
-- takes a second optional parameter to exclude/include containers data
function getLogisticNetworks(force, full)
    local networksData = {}
    local chests = {}
    local networks =  force.logistic_networks
    local names = global.networksNames[force.name] or {}
    local networksCount = 0
    local i = 0

    for surface,nets in pairs(networks) do
        for x,net in pairs(nets) do 
            if not isPlayerNetwork(net) then                
                i = i + 1
                local pos = net.cells[1].owner.position
                local index = string.gsub(pos.x .. "A" .. pos.y, "-", "_")             
                local name = names[index] and names[index] or "Network " .. i                
                networksData[index] = {}
                networksData[index]["name"] = name
                networksData[index]["key"] = index
                networksData[index]["items"] = net.get_item_count()

                networksData[index]["bots"] = {}
                networksData[index]["bots"]["log"] = {}
                networksData[index]["bots"]["log"]["total"] = net.all_logistic_robots
                networksData[index]["bots"]["log"]["available"] = net.available_logistic_robots
                networksData[index]["log"] = net.all_logistic_robots

                networksData[index]["bots"]["con"] = {}
                networksData[index]["bots"]["con"]["total"] = net.all_construction_robots
                networksData[index]["bots"]["con"]["available"] = net.available_construction_robots
                networksData[index]["con"] = net.all_construction_robots

                networksData[index]["cells"] = {}            
                local size = 0
                local port = 0
                local charging = 0
                local waiting = 0            
                for cei,cell in pairs(net.cells) do
                    networksData[index]["cells"][cei] = {}
                    networksData[index]["cells"][cei]["name"] = cell.owner.name
                    networksData[index]["cells"][cei]["pos"] = cell.owner.position
                    networksData[index]["cells"][cei]["radius"] = cell.logistic_radius

                    networksData[index]["cells"][cei]["bots"] = {}
                    networksData[index]["cells"][cei]["bots"]["idle_log"] = cell.stationed_logistic_robot_count
                    networksData[index]["cells"][cei]["bots"]["idle_con"] = cell.stationed_construction_robot_count
                    networksData[index]["cells"][cei]["bots"]["charging"] = cell.charging_robot_count
                    networksData[index]["cells"][cei]["bots"]["waiting"] = cell.to_charge_robot_count
                    size = size + cell.logistic_radius
                    port = port + 1
                    charging = charging + cell.charging_robot_count
                    waiting = waiting + cell.to_charge_robot_count
                end
                networksData[index]["size"] = size * 2
                networksData[index]["port"] = port
                networksData[index]["charging"] = charging
                networksData[index]["waiting"] = waiting

                -- check if full data is required
                if full then
                    for x,chest in pairs(net.providers) do
                        local key = string.gsub(chest.position.x.."A"..chest.position.y, "-", "_")
                        if not chests[key] and chest.type == "logistic-container" then
                            chests[key] = {}
                            chests[key]["entity"] = chest
                            chests[key]["network"] = index
                            chests[key]["type"] = "provider"
                        end
                    end

                    for x,chest in pairs(net.empty_providers) do
                        local key = string.gsub(chest.position.x.."A"..chest.position.y, "-", "_")
                        if not chests[key] and chest.type == "logistic-container" then
                            chests[key] = {}
                            chests[key]["entity"] = chest
                            chests[key]["network"] = index
                            chests[key]["type"] = "provider"
                        end
                    end

                    for x,chest in pairs(net.storages) do
                        local key = string.gsub(chest.position.x.."A"..chest.position.y, "-", "_")
                        if not chests[key] and chest.type == "logistic-container" then
                            chests[key] = {}
                            chests[key]["entity"] = chest
                            chests[key]["network"] = index
                            chests[key]["type"] = "storage"
                        end
                    end

                    for x,chest in pairs(net.requesters) do
                        local key = string.gsub(chest.position.x.."A"..chest.position.y, "-", "_")
                        if not chests[key] and chest.type == "logistic-container" then
                            chests[key] = {}
                            chests[key]["entity"] = chest
                            chests[key]["network"] = index
                            chests[key]["type"] = "requester"
                        end
                    end

                    for x,chest in pairs(net.full_or_satisfied_requesters) do
                        local key = string.gsub(chest.position.x.."A"..chest.position.y, "-", "_")
                        if not chests[key] and chest.type == "logistic-container" then
                            chests[key] = {}
                            chests[key]["entity"] = chest
                            chests[key]["network"] = index
                            chests[key]["type"] = "requester"
                        end
                    end
                end    
                networksCount = networksCount + 1
            end
        end
    end   
    
    if full then
        global.logisticsChests[force.name] = chests
    end 
    
    global.networks[force.name] = networksData
    global.networksCount[force.name] = networksCount    
    return networksData
end

--- Get all logistics containers that are not within a logistics network
-- takes a force as a parameter
function getDisconnectedChests(force)
    local type = "logistic-container"
    local disconnected = {}
    local surface = game.get_surface(1)

    for coord in surface.get_chunks() do
        local X,Y = coord.x, coord.y

        if surface.is_chunk_generated{X,Y} then
            local area = {{X*32, Y*32}, {X*32 + 32, Y*32 + 32}}
            for _,chest in pairs(surface.find_entities_filtered{area=area, type=type, force=force.name}) do
                local key = string.gsub(chest.position.x.."A"..chest.position.y, "-", "_")
                if not inLogisticsNetwork(chest, force) then
                    disconnected[key] = chest
                end
            end
        end
    end
    global.disconnectedChests[force.name] = disconnected
    return disconnected
end

--- Updates the list of all logistics containers that are not within a logistics network
-- takes a force as a parameter
function checkDisconnectedChests(force)
    local disconnected = global.disconnectedChests[force.name]

    for key,chest in pairs(disconnected) do
        if chest.valid and inLogisticsNetwork(chest, force) then
            disconnected[key] = nil
        end
    end
    global.disconnectedChests[force.name] = disconnected    
end

--- Checks all logistics containers that are not within a logistics network within a given radius
-- takes an entity position, an int radius and force as parameters
function findDisconnectedChests(pos, radius, force)
    local type = "logistic-container"
    local surface = game.get_surface(1)
    local disconnected = global.disconnectedChests[force.name]

    local area = {{pos.x-radius, pos.y-radius}, {pos.x+radius, pos.y+radius}}
    for _,chest in pairs(surface.find_entities_filtered{area=area, type=type, force=force.name}) do
        local key = string.gsub(chest.position.x.."A"..chest.position.y, "-", "_")
        if not disconnected[key] and not inLogisticsNetwork(chest, force) then
            disconnected[key] = chest
        end
    end
    global.disconnectedChests[force.name] = disconnected    
end

--- Get all items in logistics containers
-- We also record the individual totals for each logistics container type
-- takes a force and a player index as parameters
function getLogisticsItems(force, index)
    local items = {}
    local chests = global.logisticsChests[force.name]
    local names = global.logisticsChestsNames
    local networksFilter = global.networksFilter[index]
    local networksFilterCount = count(networksFilter)
    local excludeReq = global.settings[index].excludeReq
    local total = 0

    for _,chest in pairs(chests) do
        local network = chest.network
        local type = chest.type
        local chest = chest.entity
        -- check if chest is valid and check for network filters
        if chest and chest.valid and chest.name ~= nil and (networksFilter[network] or networksFilterCount == 0) then
            
            local inventory = chest.get_inventory(1)
            for n,v in pairs(inventory.get_contents()) do
                if not items[n] then
                    items[n] = {}
                    items[n]["total"] = 0
                    for _,name in pairs(names) do
                        if not items[n][name] then
                            items[n][name] = 0
                        end
                    end
                end

                if not items[n][chest.name] then
                    items[n][chest.name] = 0
                end
                
                -- check exclude requesters
                if (excludeReq and type ~= "requester") or not excludeReq then                
                    items[n]["total"] = items[n]["total"] + v
                    total = total + v
                end
                
                items[n][chest.name] = items[n][chest.name] + v
                
            end
        end
    end
    global.logisticsItems[force.name] = items
    global.logisticsItemsTotal[force.name] = total
    return items
end

--- Check if an entity is within the logistics network coverage
-- Only actively powered roboports are considered
-- takes entity and force name as parameters
function inLogisticsNetwork(entity, force, ret)
    local pos = entity.position
    local surface = entity.surface and entity.surface or game.get_surface(1)
    local network = surface.find_logistic_network_by_position(pos, force)

    return not ret and network ~= nil or ret and network
end

--- Get all normal containers
-- takes a force as a parameter
function getNormalChests(force)
    local types = {"container", "smart-container"}
    local chests = {}
    local surface = game.get_surface(1)

    for coord in surface.get_chunks() do
        local X,Y = coord.x, coord.y

        if surface.is_chunk_generated{X,Y} then
            local area = {{X*32, Y*32}, {X*32 + 32, Y*32 + 32}}
            for _,type in pairs(types) do
                for _,chest in pairs(surface.find_entities_filtered{area=area, type=type, force=force.name}) do
                    local key = string.gsub(chest.position.x.."A"..chest.position.y, "-", "_")
                    chests[key] = chest
                end
            end
        end
    end
    global.normalChests[force.name] = chests
    return chests
end

--- Get all items in containers
-- We also record the individual totals for each container type
-- takes a force as a parameter
function getNormalItems(force)
    local items = {}
    local chests = global.normalChests[force.name]
    local names = global.normalChestsNames
    local total = 0

    for _,chest in pairs(chests) do
        if chest and chest.valid and chest.name ~= nil then
            local inventory = chest.get_inventory(1)
            for n,v in pairs(inventory.get_contents()) do
                if not items[n] then
                    items[n] = {}
                    items[n]["total"] = 0
                    for _,name in pairs(names) do
                        if not items[n][name] then
                            items[n][name] = 0
                        end
                    end
                end

                if not items[n][chest.name] then
                    items[n][chest.name] = 0
                end

                items[n]["total"] = items[n]["total"] + v
                items[n][chest.name] = items[n][chest.name] + v
                total = total + v
            end
        end
    end
    global.normalItems[force.name] = items
    global.normalItemsTotal[force.name] = total
    return items
end

--- Get a specific item info
-- lists the containers this item is stored in along with other info
-- takes an item/entity name and a filters table as parameters
function getItemInfo(item, player, index, filters)
    local force = player.force.name
    local types = {logistics = global.logisticsChests[force], normal = global.normalChests[force], disconnected = global.disconnectedChests[force]}
    local total = {logistics = 0, normal = 0, disconnected = 0, all = 0}
    local info = {chests = {}, total = total}
    local networksFilter = global.networksFilter[index]
    local networksFilterCount = count(networksFilter)    

    -- get item info
    for type,chests in pairs(types) do
        if filters["group"][type] then
            for key,chest in pairs(chests) do
                local network = false
                if type == "logistics" then
                    network = chest.network
                    chest = chest.entity
                end
                
                if chest and chest.valid and chest.name ~= nil and ((type == "logistics" and (networksFilter[network] or networksFilterCount == 0)) or type ~= "logistics") then
                    
                    if filters["chests"][nameToCode(chest.name)] or filters["chests"]["all"] then
                        local itemCount = chest.get_item_count(item)                   

                        total[type] = total[type] + itemCount
                        total["all"] = total["all"] + itemCount

                        if itemCount > 0 then
                            if not info["chests"][key] then
                                info["chests"][key] = {}
                            end

                            info["chests"][key]["entity"] = chest
                            info["chests"][key]["name"] = chest.name
                            info["chests"][key]["pos"] = chest.position
                            info["chests"][key]["count"] = itemCount
                            info["chests"][key]["type"] = type
                        end
                    end
                end

            end
        end
    end

    info["total"] = total
    global.currentItemInfo[index] = info
    return info

end

--- Search update functions
function onLogisticsSearchTick(event, index)
    local player = game.players[index]
    local searchTick = global.searchTick[index]["logistics"]
    local currentTab = global.currentTab[index]

    if currentTab == "logistics" then
        if searchTick <= event.tick and global.guiVisible[index] == 1 then
            local searchFrame = player.gui[global.settings[index].guiPos].logisticsFrame.contentFrame["logisticsSearchFrame"]
            local searchText = searchFrame["logistics-search-field"].text

            global.searchTick[index]["logistics"] = event.tick + 60
            if searchText ~= nil then
                if type(searchText) == "string" and searchText ~= "" and string.len(searchText) >= 3 then
                    global.searchText[index]["logistics"] = searchText
                    updateGUI(player, index)
                elseif searchText == "" then
                    global.searchText[index]["logistics"] = false
                    updateGUI(player, index)
                end
            end
        end
    end
end

function onNormalSearchTick(event, index)
    local player = game.players[index]
    local searchTick = global.searchTick[index]["normal"]
    local currentTab = global.currentTab[index]

    if currentTab == "normal" then
        if searchTick <= event.tick and global.guiVisible[index] == 1 then
            local searchFrame = player.gui[global.settings[index].guiPos].logisticsFrame.contentFrame["normalSearchFrame"]
            local searchText = searchFrame["normal-search-field"].text

            global.searchTick[index]["normal"] = event.tick + 60
            if searchText ~= nil then
                if type(searchText) == "string" and searchText ~= "" and string.len(searchText) >= 3 then
                    global.searchText[index]["normal"] = searchText
                    updateGUI(player, index)
                elseif searchText == "" then
                    global.searchText[index]["normal"] = false
                    updateGUI(player, index)
                end
            end
        end
    end
end

--- Convert chest names to gui codes
function nameToCode(name)
    for type,codes in pairs(global.codeToName) do
        for c,n in pairs(codes) do
            if name == n then return c end
        end
    end
end

--- Convert gui codes to chest names
function codeToName(code)
    for type,codes in pairs(global.codeToName) do
        for c,n in pairs(codes) do
            if code == c then return n end
        end
    end
end

--- Gets compatible names for mod entities that use invisible proxy containers
function getCompName(name)
    local compNames = global.compNames
    for k,n in pairs(compNames) do 
        if name == k then
            return n
        end
    end
    return false
end

--- Gets localised item/entity name
function getLocalisedName(name)
    local locName = game.item_prototypes[name].localised_name
    if not locName then
        locName = game.entity_prototypes[name].localised_name
    end 
    return locName
end

--- Get normal chest names
function getNormalChestNames()
    local normalChestNames = {}
    for _,entity in pairs(game.entity_prototypes) do
        if entity.type == "container" or entity.type == "smart-container" then
            local name =  entity.name
            if not normalChestNames[name] then
                normalChestNames[name] = name
            end
        end
    end
    return normalChestNames
end

--- Get logistics chest names
function getLogisticsChestNames()
    local logisticsChestNames = {}
    for _,entity in pairs(game.entity_prototypes) do
        if entity.type == "logistic-container" then
            local name =  entity.name
            if not logisticsChestNames[name] then
                logisticsChestNames[name] = name
            end
        end
    end
    return logisticsChestNames
end

--- Upgrades a chest using robots and preserves it's inventory
-- takes a chest entity and a new entity name as parameters
function upgradeChest(entity, name, player)
    if entity.name ~= name then
        local force = player.force.name
        local pos = entity.position
        local dir = entity.direction
        local key = string.gsub(pos.x .. "A" .. pos.y, "-", "_")
        local surface = player.surface
        local inventory = entity.get_inventory(1)
        local content = false
        if  inventory.get_contents() then
            content = inventory.get_contents()
        end

        if global.logisticsChests[force][key] then global.logisticsChests[force][key] = nil end
        if global.normalChests[force][key] then global.normalChests[force][key] = nil end
        if global.disconnectedChests[force][key] then global.disconnectedChests[force][key] = nil end

        entity.destroy()

        if content then
            global.chestsUpgrade[key] = {}
            global.chestsUpgrade[key]["inventory"] = content
        end

        local upgrade = {
            name = "entity-ghost",
            inner_name = name,
            position = pos,
            direction = dir,
            force = player.force,
        }

        surface.create_entity(upgrade)

    end
end

--- moves a player ghost to a position and highlights it
function viewPosition(player, index, position)
    local ghost = createGhostController(player, position)

    changeCharacter(player, ghost)
    hideGUI(player, index)

    local locationFlow = player.gui.center.locationFlow
    if locationFlow ~= nil then
        locationFlow.destroy()
    end
    locationFlow = player.gui.center.add({type = "flow", name = "locationFlow", direction = "horizontal"})
    locationFlow.add({type = "button", name = "locationViewBack", caption = {"location-back"}, style = "lv_location_view"})
end

--- moves a player back to it's original character and position
function resetPosition(player, index)
    local character = global.character[index]
    if character ~= nil and player.character.name == "ls-controller" then
        local locationFlow = player.gui.center.locationFlow
        if locationFlow ~= nil then
            locationFlow.destroy()
        end

        if changeCharacter(player, character) then
            global.character[index] = nil
        end
        showGUI(player, index)
    end
end

--- creates a new player ghost controller
function createGhostController(player, position)
    local position = position or player.position
    local surface = player.surface
    local entity = surface.create_entity({name="ls-controller", position=position, force=player.force})
    return entity
end

--- changes the player character
function changeCharacter(player, character)
    if player.character ~= nil and character ~= nil and player.character.valid and character.valid then
        if player.character.name ~= "ls-controller" then
            global.character[player.index] = player.character
        end
        player.character = character
        return true
    end
    return false
end

--- Helper function to get an area where a point intersects with a square
function triangleArea(A, B, C)
    return (C.x*B.y-B.x*C.y)-(C.x*A.y-A.x*C.y)+(B.x*A.y-A.x*B.y)
end

--- Check if a point is inside a square area
function isInsideSquare(A, B, C, D, P)
    if triangleArea(A,B,P) > 0 or triangleArea(B,C,P) > 0 or triangleArea(C,D,P) > 0 or triangleArea(D,A,P) > 0 then
        return false
    end
    return true
end

-- Sort table by value
function spairs(t, order)
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

--- Returns table count
function count(t)
    local count = 0
    if type(t) == "table" then
        for _,item in pairs(t) do
            count = count + 1
        end
    end
    return count
end

--- Filters a table by a function
table.filter = function(t, filterIter)
  local out = {}

  for k, v in pairs(t) do
    if filterIter(v, k, t) then out[k] = v end
  end

  return out
end

--- Format numbers
function number_format(n) -- credit http://richard.warburton.it
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

--- Splits a string by a separator and returns a table
function split(str, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(str, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

-- debugging tools
function debugLog(msg, force)
    if (DEV or force) and msg then
            for i,player in ipairs(game.players) do
                if player and player.valid then
                    if type(msg) == "string" then
                        player.print(msg)
                    else
                        player.print(serpent.dump(msg))
                    end
                end
            end
    end
end
