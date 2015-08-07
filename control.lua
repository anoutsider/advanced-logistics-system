require "defines"
require "gui"

---  Enable/Disable Debugging
local DEV = false

--- on_init event
game.on_init(function()
    init()
end)

--- on_load event
game.on_load(function()
    init()
end)

--- Initiate default and globalal values
function init()
    global.guiLoaded = global.guiLoaded or {}
    global.guiVisible = global.guiVisible or {}
    global.currentTab = global.currentTab or {}

    global.itemsPage = global.itemsPage or {}
    global.searchText = global.searchText or {}
    global.searchTick = global.searchTick or {}
    global.sort = global.sort or {}

    global.settings = global.settings or {}
    global.settings.guiPos = global.settings.guiPos or {}
    global.settings.itemsPerPage = global.settings.itemsPerPage or {}
    global.settings.refreshInterval = global.settings.refreshInterval or {}
    global.settings.exTools = global.settings.exTools or {}

    -- roboports radius, manually set because there is no way to get the data right now
    global.roboradius = {}
    global.roboradius["roboport"] = 25
        -- bobs mods
    global.roboradius["bob-roboport-2"] = 50
    global.roboradius["bob-roboport-3"] = 75
    global.roboradius["bob-roboport-4"] = 100
    global.roboradius["bob-logistic-zone-expander"] = 15
    global.roboradius["bob-logistic-zone-expander-2"] = 30
    global.roboradius["bob-logistic-zone-expander-3"] = 45
    global.roboradius["bob-logistic-zone-expander-4"] = 60
        -- Dytech mods
    global.roboradius["roboport-1"] = 50
    global.roboradius["roboport-2"] = 100
    global.roboradius["robot-charger-1"] = 10
    global.roboradius["robot-charger-2"] = 20
        -- 5dim mods
    global.roboradius["5d-roboport-2"] = 50

    global.roboports = global.roboports or {}

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

    global.guiTabs = {"logistics", "normal", "itemInfo"}
    global.character = global.character or {}

    -- init player specific globalals
    initPlayers()

end

--- init all players
function initPlayers()
    for i,p in ipairs(game.players) do
        initPlayer(p)
    end
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
    -- gui loaded
    if not global.guiLoaded[i] and playerHasSystem(player) and not player.gui.top["logistics-view-button"] then
        initGUI(player)
    end
    -- roboports table
    if not global.roboports[name] then
        global.roboports[name] = getRoboPorts(force)
    end
    -- logistic containers
    if not global.logisticsChests[name] then
        global.logisticsChests[name] = getLogisticsChests(force)
    end
    -- out of coverage logistic containers
    if not global.disconnectedChests[name] then
        global.disconnectedChests[name] = {}
    end
    -- normal and smart containers
    if not global.normalChests[name] then
        global.normalChests[name] = getNormalChests(force)
    end
    -- items in logistic containers
    if not global.logisticsItems[name] then
        global.logisticsItems[name] = getLogisticsItems(force)
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
    end
    -- current active sort per view type
    if not global.sort[i] then
        global.sort[i] = {}
        global.sort[i]["logistics"] = {by = "total", dir = "desc"}
        global.sort[i]["normal"] = {by = "total", dir = "desc"}
        global.sort[i]["disconnected"] = {by = "count", dir = "desc"}
        global.sort[i]["itemInfo"] = {by = "count", dir = "desc"}
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

--- Checks if a player has a logistics system in his inventory -- Talguy
function playerHasSystem(player)
    return not not player and (
        player.character and player.character.name == "ls-controller" or
        player.get_item_count("advanced-logistics-system") > 0
    )
end

--- Handles items search
game.on_event(defines.events.on_tick, function(event)
        for i,p in ipairs(game.players) do
            if playerHasSystem(p) then
                if (not p.gui.top["logistics-view-button"]) then
                    initGUI(p)
                end
                local refresh = global.settings[i].refreshInterval * 60
                if event.tick % refresh == 0  then
                    if global.guiVisible[i] == 1 then
                        local currentTab = global.currentTab[i]
                        if currentTab == "itemInfo" then
                            local currentItem = global.currentItem[i]
                            if currentItem then
                                clearGUI(p, i)
                                showItemInfo(currentItem, p, i)
                            end
                        else
                            updateGUI(p, i)
                        end
                    end
                end

                -- check search field tick
                if global.searchTick[i]["logistics"] ~= nil then onLogisticsSearchTick(event, i) end
                if global.searchTick[i]["normal"] ~= nil then onNormalSearchTick(event, i) end
            elseif global.settings[i] then
                destroyGUI(p, i)
            end

        end
end)

--- Player Related Events
game.on_event(defines.events.on_player_created, function(event)
    playerCreated(event)
end)

--- init new players
function playerCreated(event)
    local player = game.players[event.player_index]
    initPlayers()
end

--- Entity Related Events
game.on_event(defines.events.on_built_entity, function(event)
    entityBuilt(event, event.created_entity)
end)

game.on_event(defines.events.on_robot_built_entity, function(event)
    entityBuilt(event, event.created_entity)
end)

game.on_event(defines.events.on_preplayer_mined_item, function(event)
    entityMined(event, event.entity)
end)

game.on_event(defines.events.on_robot_pre_mined, function(event)
    entityMined(event, event.entity)
end)

game.on_event(defines.events.on_entity_died, function(event)
    entityMined(event, event.entity)
end)

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

        if inLogisticsNetwork(entity, force) then
            if not chests[key] then
                debugLog("Added Chest # " .. key .. "To Logistics Chests List")
                chests[key] = entity
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

    elseif entity.type == "roboport" and global.roboradius[entity.name] ~= nil then
        local pos = entity.position
        local roboports = global.roboports[force]
        local key = string.gsub(pos.x.."A"..pos.y, "-", "_")
        local radius = global.roboradius[entity.name]

        if not roboports[key] and radius then
            debugLog("Added Roboport # " .. key)
            roboports[key] = {}
            roboports[key]["name"] = entity.name
            roboports[key]["position"] = pos
            roboports[key]["coverage"] = {x1 = (pos.x-radius), x2 = (pos.x+radius), y1 = (pos.y-radius), y2 = (pos.y+radius)}
            roboports[key]["active"] = entity.energy > 0

            global.roboports[force] = roboports
            checkChestsCoverage(true, force, entity)
        end
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

    elseif entity.type == "roboport" and global.roboradius[entity.name] ~= nil then
        local roboports = global.roboports[force]
        local key = string.gsub(entity.position.x.."A"..entity.position.y, "-", "_")
        if roboports[key] then
            debugLog("Removed Roboport # " .. key)
            roboports[key] = nil
            global.roboports[force] = roboports
            checkChestsCoverage(false, force)
        end
    end
end

--- Get all active roboports and their logistics coverage box
-- We check if a roboport is active by checking it's energy value
function getRoboPorts(force)
    local type = "roboport"
    local roboports = {}
    local surface = game.get_surface(1)

    for coord in surface.get_chunks() do
        local X,Y = coord.x, coord.y
        if surface.is_chunk_generated{X,Y} then
            local area = {{X*32, Y*32}, {X*32 + 32, Y*32 + 32}}
            for _,roboport in pairs(surface.find_entities_filtered{area=area, type=type}) do
                if roboport.name ~= "roboport-pocket" and global.roboradius[roboport.name] then
                    local key = string.gsub(roboport.position.x.."A"..roboport.position.y, "-", "_")
                    local radius = global.roboradius[roboport.name]
                    local pos = roboport.position

                    if not roboports[key] then roboports[key] = {} end
                    roboports[key]["name"] = roboport.name
                    roboports[key]["position"] = pos
                    roboports[key]["coverage"] = {x1 = (pos.x-radius), x2 = (pos.x+radius), y1 = (pos.y-radius), y2 = (pos.y+radius)}
                    roboports[key]["active"] = roboport.energy > 0
                end
            end
        end
    end
    global.roboports[force.name] = roboports
    return roboports
end

--- Get all logistics containers that are within the logistics network
-- takes a force as a parameter
function getLogisticsChests(force)
    local type = "logistic-container"
    local chests = {}
    local disconnected = {}
    local surface = game.get_surface(1)

    for coord in surface.get_chunks() do
        local X,Y = coord.x, coord.y

        if surface.is_chunk_generated{X,Y} then
            local area = {{X*32, Y*32}, {X*32 + 32, Y*32 + 32}}
            for _,chest in pairs(surface.find_entities_filtered{area=area, type=type, force=force.name}) do
                --if chest.force.name == force.name then
                    local key = string.gsub(chest.position.x.."A"..chest.position.y, "-", "_")
                    if inLogisticsNetwork(chest, force.name) then
                        chests[key] = chest
                    else
                        disconnected[key] = chest
                    end
                --end
            end
        end
    end
    global.logisticsChests[force.name] = chests
    global.disconnectedChests[force.name] = disconnected
    return chests
end

--- Get all items in logistics containers
-- We also record the individual totals for each logistics container type
-- takes a force as a parameter
function getLogisticsItems(force)
    local items = {}
    local chests = global.logisticsChests[force.name]
    local names = global.logisticsChestsNames
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
    global.logisticsItems[force.name] = items
    global.logisticsItemsTotal[force.name] = total
    return items
end

--- Check if an entity is within the logistics network coverage
-- Only actively powered roboports are considered
-- takes entity and force name as parameters
function inLogisticsNetwork(entity, force)
    local pos = entity.position
    local roboports = global.roboports[force]
    for _,roboport in pairs(roboports) do

        if roboport.valid and roboport.active then
            local coverage = roboport.coverage
            local A = {x = coverage.x1, y = coverage.y1}
            local B = {x = coverage.x2, y = coverage.y1}
            local C = {x = coverage.x2, y = coverage.y2}
            local D = {x = coverage.x1, y = coverage.y2}

            if isInsideSquare(A, B, C, D, pos) then
                return true
            end
        end
    end
    return false
end

--- Check if recorded chests are still within the logistics network
-- This check runs after a roboport has been built/removed
function checkChestsCoverage(add, force, roboport)
    local chests = global.logisticsChests[force]
    local disconnected = global.disconnectedChests[force]
    local surface = game.get_surface(1)

    if add then
        if roboport and roboport.energy > 0 then
            local type = "logistic-container"
            local radius = global.roboradius[roboport.name]
            local pos = roboport.position
            local area = {{(pos.x-radius), (pos.y-radius)}, {(pos.x+radius), (pos.y+radius)}}

            for _,chest in pairs(surface.find_entities_filtered{area=area, type=type, force=force}) do
                    local key = string.gsub(chest.position.x.."A"..chest.position.y, "-", "_")
                    chests[key] = chest
                    debugLog("Added Chest # " .. key .. " New Coverage")
                    if disconnected[key] then
                        disconnected[key] = nil
                        debugLog("Removed Chest # " .. key .. " From Disconnected Chests list")
                    end
            end
        end
    else
        for key,chest in pairs(chests) do
            if not inLogisticsNetwork(chest, force) then
                chests[key] = nil
                debugLog("Removed Chest # " .. key .. " No Coverage")
                if not disconnected[key] then
                    disconnected[key] = chest
                    debugLog("Added Chest # " .. key .. " To Disconnected Chests list")
                end
            end
        end
    end
    global.logisticsChests[force] = chests
    global.disconnectedChests[force] = disconnected
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
                    --if chest.force.name == force.name then -- no longer needed in 0.12
                        local key = string.gsub(chest.position.x.."A"..chest.position.y, "-", "_")
                        chests[key] = chest
                    --end
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

    -- get item info
    for type,chests in pairs(types) do
        if filters["group"][type] then
            for key,chest in pairs(chests) do
                if chest and chest.valid and chest.name ~= nil then
                    if filters["chests"][nameToCode(chest.name)] or filters["chests"]["all"] then
                        local count = chest.get_item_count(item)

                        total[type] = total[type] + count
                        total["all"] = total["all"] + count

                        if count > 0 then
                            if not info["chests"][key] then
                                info["chests"][key] = {}
                            end

                            info["chests"][key]["entity"] = chest
                            info["chests"][key]["name"] = chest.name
                            info["chests"][key]["pos"] = chest.position
                            info["chests"][key]["count"] = count
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
function debugLog(msg)
    if DEV and msg then
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
