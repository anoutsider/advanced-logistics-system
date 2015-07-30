require "defines"
require "gui"

---  Enable/Disable Debugging
local DEV = false

--- oninit event
game.oninit(function()
    init()
end)

--- onload event
game.onload(function()
    init()
end)

--- Initiate default and global values
function init()

    glob.guiLoaded = glob.guiLoaded or {}
    glob.guiVisible = glob.guiVisible or {}
    glob.currentTab = glob.currentTab or {}

    glob.itemsPage = glob.itemsPage or {}
    glob.searchText = glob.searchText or {}
    glob.searchTick = glob.searchTick or {}
    glob.sort = glob.sort or {}

    glob.settings = glob.settings or {}
    glob.settings.guiPos = glob.settings.guiPos or {}
    glob.settings.itemsPerPage = glob.settings.itemsPerPage or {}
    glob.settings.refreshInterval = glob.settings.refreshInterval or {}
    glob.settings.exTools = glob.settings.exTools or {}

    -- roboports radius, manually set because there is no way to get the data right now
    glob.roboradius = {}
    glob.roboradius["roboport"] = 25
    glob.roboradius["bob-roboport-2"] = 50
    glob.roboradius["bob-roboport-3"] = 75
    glob.roboradius["bob-roboport-4"] = 100
    glob.roboradius["bob-logistic-zone-expander"] = 15
    glob.roboradius["bob-logistic-zone-expander-2"] = 30
    glob.roboradius["bob-logistic-zone-expander-3"] = 45
    glob.roboradius["bob-logistic-zone-expander-4"] = 60

    glob.roboports = glob.roboports or {}

    glob.logisticsChests = glob.logisticsChests or {}
    glob.logisticsChestsNames = glob.logisticsChestsNames or getLogisticsChestNames()
    glob.disconnectedChests = glob.disconnectedChests or {}


    glob.normalChests = glob.normalChests or {}
    glob.normalChestsNames = glob.normalChestsNames or getNormalChestNames()

    glob.logisticsItems = glob.logisticsItems or {}
    glob.logisticsItemsTotal = glob.logisticsItemsTotal or {}

    glob.normalItems = glob.normalItems or {}
    glob.normalItemsTotal = glob.normalItemsTotal or {}

    glob.currentItem = glob.currentItem or {}
    glob.currentItemInfo = glob.currentItemInfo or  {}
    glob.itemInfoFilters = glob.itemInfoFilters or {}

    glob.chestsUpgrade = glob.chestsUpgrade or {}

    glob.codeToName = {
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

    glob.guiTabs = {"logistics", "normal", "itemInfo"}
    glob.character = glob.character or {}

    -- init player specific globals
    initPlayers()

end

--- init player specific global values
function initPlayers()
    for i,p in ipairs(game.players) do        
        local force = p.force
        local name = force.name
        -- gui visibility
        if not glob.guiVisible[i] or glob.guiVisible[i] == nil then
            glob.guiVisible[i] = 0
        end
        -- init settings
        if not glob.settings[i] then
            glob.settings[i] = {}
        end
        -- gui position settings
        if not glob.settings[i].guiPos then
            glob.settings[i].guiPos = "center"
        end
        -- gui items per page settings
        if not glob.settings[i].itemsPerPage then
            glob.settings[i].itemsPerPage = 10
        end
        -- gui refresh interval
        if not glob.settings[i].refreshInterval then
            glob.settings[i].refreshInterval = 1
        end
        -- experimental tools - teleport, upgrade chests / too powerfull or not fully tested
        if not glob.settings[i].exTools then
            glob.settings[i].exTools = false
        end
        -- gui loaded
        if not glob.guiLoaded[i] and playerHasSystem(p) and not p.gui.top["logistics-view-button"] then
            initGUI(p)
        end
        -- roboports table
        if not glob.roboports[name] then
            glob.roboports[name] = getRoboPorts()
        end
        -- logistic containers
        if not glob.logisticsChests[name] then
            glob.logisticsChests[name] = getLogisticsChests(force)
        end
        -- out of coverage logistic containers
        if not glob.disconnectedChests[name] then
            glob.disconnectedChests[name] = {}
        end
        -- normal and smart containers
        if not glob.normalChests[name] then
            glob.normalChests[name] = getNormalChests(force)
        end
        -- items in logistic containers
        if not glob.logisticsItems[name] then
            glob.logisticsItems[name] = getLogisticsItems(force)
        end
        -- total number of items in logistic containers
        if not glob.logisticsItemsTotal[name] then
            glob.logisticsItemsTotal[name] = 0
        end
        -- items in normal and smart containers
        if not glob.normalItems[name] then
            glob.normalItems[name] = getNormalItems(force)
        end
        -- items in normal and smart containers
        if not glob.normalItemsTotal[name] then
            glob.normalItemsTotal[name] = 0
        end

        -- current active menu tab
        if not glob.currentTab[i] then
            glob.currentTab[i] = "logistics"
        end
        -- current active page per view type
        if not glob.itemsPage[i] then
            glob.itemsPage[i] = {}
            glob.itemsPage[i]["logistics"] = 1
            glob.itemsPage[i]["normal"] = 1
            glob.itemsPage[i]["disconnected"] = 1
            glob.itemsPage[i]["itemInfo"] = 1
        end
        -- current active sort per view type
        if not glob.sort[i] then
            glob.sort[i] = {}
            glob.sort[i]["logistics"] = {by = "total", dir = "desc"}
            glob.sort[i]["normal"] = {by = "total", dir = "desc"}
            glob.sort[i]["disconnected"] = {by = "count", dir = "desc"}
            glob.sort[i]["itemInfo"] = {by = "count", dir = "desc"}
        end
        -- current search text per table type
        if not glob.searchText[i] then
            glob.searchText[i] = {}
            glob.searchText[i]["logistics"] = ""
            glob.searchText[i]["normal"] = ""
        end
        -- used to check the current search text
        if not glob.searchTick[i] then
            glob.searchTick[i] = {}
            glob.searchTick[i]["logistics"] = nil
            glob.searchTick[i]["normal"] = nil
        end
        -- filters used in item info view
        if not glob.itemInfoFilters[i] then
            glob.itemInfoFilters[i] = {}
            glob.itemInfoFilters[i]["group"] = {logistics = true, normal = true}
            glob.itemInfoFilters[i]["chests"] = {all = true}
        end
    end
end

--- Hard reset all settings
function reset()
    for k,v in pairs(glob) do
        glob[k] = nil
    end
end

--- Checks if a player has a logistics system in his inventory
function playerHasSystem(player)
    return player.character.name == "ls-controller" or player.getitemcount("advanced-logistics-system") > 0
end

--- Handles items search
game.onevent(defines.events.ontick, function(event)
        for i,p in ipairs(game.players) do
            if playerHasSystem(p) then
                if (not p.gui.top["logistics-view-button"]) then
                    initGUI(p)
                end
                local refresh = glob.settings[i].refreshInterval * 60
                if event.tick % refresh == 0  then
                    if glob.guiVisible[i] == 1 then
                        local currentTab = glob.currentTab[i]
                        if currentTab == "itemInfo" then
                            local currentItem = glob.currentItem[i]
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
                if glob.searchTick[i]["logistics"] ~= nil then onLogisticsSearchTick(event) end
                if glob.searchTick[i]["normal"] ~= nil then onNormalSearchTick(event) end
            else
                destroyGUI(p, i)
            end
            
        end
end)

--- Entity Related Events
game.onevent(defines.events.onbuiltentity, function(event)
    entityBuilt(event, event.createdentity)
end)

game.onevent(defines.events.onrobotbuiltentity, function(event)
    entityBuilt(event, event.createdentity)
end)

game.onevent(defines.events.onpreplayermineditem, function(event)
    entityMined(event, event.entity)
end)

game.onevent(defines.events.onrobotpremined, function(event)
    entityMined(event, event.entity)
end)

game.onevent(defines.events.onentitydied, function(event)
    entityMined(event, event.entity)
end)

--- Entity built event handler for players & robots constructions
-- Checks if a logistics container has been built and updates the local chests table accordingly
-- Checks if a roboport has been built and updates the local roboports table accordingly
-- If a roboport is built a check will run on the logistics chests table for logistics network coverage
function entityBuilt(event, entity)
    local force = entity.force.name

    if entity.type == "logistic-container" then
        local chests = glob.logisticsChests[force]
        local disconnected = glob.disconnectedChests[force]
        local key = string.gsub(entity.position.x.."A"..entity.position.y, "-", "_")
        local upgrades = glob.chestsUpgrade[key]

        if inLogisticsNetwork(entity, force) then
            if not chests[key] then
                debugLog("Added Chest # " .. key .. "To Logistics Chests List")
                chests[key] = entity
                glob.logisticsChests[force] = chests
            end
        else
            if not disconnected[key] then
                debugLog("Added Chest # " .. key .. "To Disconnected Chests List")
                disconnected[key] = entity
                glob.disconnectedChests[force] = disconnected
            end
        end

        -- exTools - handle upgraded chests, restore inventory
        if upgrades and upgrades.inventory then
            for n,v in pairs(upgrades.inventory) do
                local stack = {name = n, count = v}
                entity.insert(stack)
            end
            glob.chestsUpgrade[key] = nil
        end

    elseif entity.type == "container" or entity.type == "smart-container" then
        local chests = glob.normalChests[force]
        local key = string.gsub(entity.position.x.."A"..entity.position.y, "-", "_")

        if not chests[key] then
            debugLog("Added Chest # " .. key .. "To Normal Chests List")
            chests[key] = entity
            glob.normalChests[force] = chests
        end

    elseif entity.type == "roboport" and glob.roboradius[entity.name] ~= nil then
        local roboports = glob.roboports[force]
        local key = string.gsub(entity.position.x.."A"..entity.position.y, "-", "_")
        if not roboports[key] then
            debugLog("Added Roboport # " .. key)
            roboports[key] = entity
            glob.roboports[force] = roboports
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
        local chests = glob.logisticsChests[force]
        local disconnected = glob.disconnectedChests[force]
        local key = string.gsub(entity.position.x.."A"..entity.position.y, "-", "_")

        if chests[key] then
            debugLog("Removed Chest # " .. key .. "From Logistics Chests List")
            chests[key] = nil
            glob.logisticsChests[force] = chests
        end

        if disconnected[key] then
            debugLog("Removed Chest # " .. key .. "From Disconnected Chests List")
            disconnected[key] = nil
            glob.disconnectedChests[force] = disconnected
        end

    elseif entity.type == "container" or entity.type == "smart-container" then

        local chests = glob.normalChests[force]
        local key = string.gsub(entity.position.x.."A"..entity.position.y, "-", "_")

        if chests[key] then
            debugLog("Removed Chest # " .. key .. "From Normal Chests List")
            chests[key] = nil
            glob.normalChests[force] = chests
        end

    elseif entity.type == "roboport" and glob.roboradius[entity.name] ~= nil then
        local roboports = glob.roboports[force]
        local key = string.gsub(entity.position.x.."A"..entity.position.y, "-", "_")
        if roboports[key] then
            debugLog("Removed Roboport # " .. key)
            roboports[key] = nil
            glob.roboports[force] = roboports
            checkChestsCoverage(false, force)
        end
    end
end

--- Get all active roboports and their logistics coverage box
-- We check if a roboport is active by checking it's energy value
function getRoboPorts()
    local type = "roboport"
    local roboports = {}
    for coord in game.getchunks() do
        local X,Y = coord.x, coord.y
        if game.ischunkgenerated{X,Y} then
            local area = {{X*32, Y*32}, {X*32 + 32, Y*32 + 32}}
            for _,roboport in pairs(game.findentitiesfiltered{area=area, type=type}) do
                if roboport.name ~= "roboport-pocket" and glob.roboradius[roboport.name] then
                    local key = string.gsub(roboport.position.x.."A"..roboport.position.y, "-", "_")
                    local radius = glob.roboradius[roboport.name]
                    local pos = roboport.position
                    local isActive = roboport.energy > 0 and "true" or "false"
                    if not roboports[key] then roboports[key] = {} end
                    roboports[key]["name"] = roboport.name
                    roboports[key]["position"] = pos
                    roboports[key]["coverage"] = {x1 = (pos.x-radius), x2 = (pos.x+radius), y1 = (pos.y-radius), y2 = (pos.y+radius)}
                    roboports[key]["active"] = isActive
                end
            end
        end
    end
    return roboports
end

--- Get all logistics containers that are within the logistics network
-- takes a force as a parameter
function getLogisticsChests(force)
    local type = "logistic-container"
    local chests = {}
    local disconnected = {}

    for coord in game.getchunks() do
        local X,Y = coord.x, coord.y

        if game.ischunkgenerated{X,Y} then
            local area = {{X*32, Y*32}, {X*32 + 32, Y*32 + 32}}
            for _,chest in pairs(game.findentitiesfiltered{area=area, type=type}) do
                if chest.force.name == force.name then
                    local key = string.gsub(chest.position.x.."A"..chest.position.y, "-", "_")
                    if inLogisticsNetwork(chest, force.name) then
                        chests[key] = chest
                    else
                        disconnected[key] = chest
                    end
                end
            end
        end
    end
    glob.logisticsChests[force.name] = chests
    glob.disconnectedChests[force.name] = disconnected
    return chests
end

--- Get all items in logistics containers
-- We also record the individual totals for each logistics container type
-- takes a force as a parameter
function getLogisticsItems(force)
    local items = {}
    local chests = glob.logisticsChests[force.name]
    local names = glob.logisticsChestsNames
    local total = 0

    for _,chest in pairs(chests) do
        if chest and chest.name ~= nil then
            local inventory = chest.getinventory(1)
            for n,v in pairs(inventory.getcontents()) do
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
    glob.logisticsItems[force.name] = items
    glob.logisticsItemsTotal[force.name] = total
    return items
end

--- Check if an entity is within the logistics network coverage
-- Only actively powered roboports are considered
-- takes entity and force name as parameters
function inLogisticsNetwork(entity, force)
    local pos = entity.position
    local roboports = glob.roboports[force]
    for _,roboport in pairs(roboports) do
        if roboport.active == "true" then
            local coverage = roboport["coverage"]
            local A = {x = coverage.x1, y = coverage.y1}
            local B = {x = coverage.x2, y = coverage.y1}
            local C = {x = coverage.x2, y = coverage.y2}
            local D = {x = coverage.x1, y = coverage.y2}

            if roboport.active == "true" then
                if isInsideSquare(A, B, C, D, pos) then
                    return true
                end
            end
        end
    end
    return false
end

--- Check if recorded chests are still within the logistics network
-- This check runs after a roboport has been built/removed
function checkChestsCoverage(add, force, roboport)
    debugLog("Checking Chests Coverage")
    local chests = glob.logisticsChests[force]
    local disconnected = glob.disconnectedChests[force]
    if add then
        if roboport and roboport.energy > 0 then
            local type = "logistic-container"
            local radius = glob.roboradius[roboport.name]
            local pos = roboport.position
            local area = {{(pos.x-radius), (pos.y-radius)}, {(pos.x+radius), (pos.y+radius)}}
            for _,chest in pairs(game.findentitiesfiltered{area=area, type=type}) do
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
    glob.logisticsChests[force] = chests
    glob.disconnectedChests[force] = disconnected
end

--- Get all normal containers
-- takes a force as a parameter
function getNormalChests(force)
    local types = {"container", "smart-container"}
    local chests = {}

    for coord in game.getchunks() do
        local X,Y = coord.x, coord.y

        if game.ischunkgenerated{X,Y} then
            local area = {{X*32, Y*32}, {X*32 + 32, Y*32 + 32}}
            for _,type in pairs(types) do
                for _,chest in pairs(game.findentitiesfiltered{area=area, type=type}) do
                    if chest.force.name == force.name then
                        local key = string.gsub(chest.position.x.."A"..chest.position.y, "-", "_")
                        chests[key] = chest
                    end
                end
            end
        end
    end
    glob.normalChests[force.name] = chests
    return chests
end

--- Get all items in containers
-- We also record the individual totals for each container type
-- takes a force as a parameter
function getNormalItems(force)
    local items = {}
    local chests = glob.normalChests[force.name]
    local names = glob.normalChestsNames
    local total = 0

    for _,chest in pairs(chests) do
        if chest and chest.name ~= nil then
            local inventory = chest.getinventory(1)
            for n,v in pairs(inventory.getcontents()) do
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
    glob.normalItems[force.name] = items
    glob.normalItemsTotal[force.name] = total
    return items
end

--- Get a specific item info
-- lists the containers this item is stored in along with other info
-- takes an item/entity name and a filters table as parameters
function getItemInfo(item, player, index, filters)
    local force = player.force.name
    local types = {logistics = glob.logisticsChests[force], normal = glob.normalChests[force], disconnected = glob.disconnectedChests[force]}
    local total = {logistics = 0, normal = 0, disconnected = 0, all = 0}
    local info = {chests = {}, total = total}

    -- get item info
    for type,chests in pairs(types) do
        if filters["group"][type] then
            for key,chest in pairs(chests) do
                if chest and chest.name ~= nil then
                    if filters["chests"][nameToCode(chest.name)] or filters["chests"]["all"] then
                        local count = chest.getitemcount(item)

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
    glob.currentItemInfo[index] = info
    return info

end

--- Convert chest names to gui codes
function nameToCode(name)
    for type,codes in pairs(glob.codeToName) do
        for c,n in pairs(codes) do
            if name == n then return c end
        end
    end
end

--- Convert gui codes to chest names
function codeToName(code)
    for type,codes in pairs(glob.codeToName) do
        for c,n in pairs(codes) do
            if code == c then return n end
        end
    end
end

--- Get normal chest names
function getNormalChestNames()
    local normalChestNames = {}
    for _,entity in pairs(game.entityprototypes) do
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
    for _,entity in pairs(game.entityprototypes) do
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
        local inventory = entity.getinventory(1)
        local content = false
        if  inventory.getcontents() then
            content = inventory.getcontents()
        end

        if glob.logisticsChests[force][key] then glob.logisticsChests[force][key] = nil end
        if glob.normalChests[force][key] then glob.normalChests[force][key] = nil end
        if glob.disconnectedChests[force][key] then glob.disconnectedChests[force][key] = nil end

        entity.destroy()

        if content then
            glob.chestsUpgrade[key] = {}
            glob.chestsUpgrade[key]["inventory"] = content
        end

        local upgrade = {
            name = "ghost",
            innername = name,
            position = pos,
            direction = dir,
            force = player.force,
        }

        game.createentity(upgrade)

    end
end

--- moves a player ghost to a position and highlights it
function viewPosition(player, index, position)
    glob.character[index] = player.character
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
    
    local character = glob.character[index]
    if character ~= nil and player.character.name == "ls-controller" then
        local locationFlow = player.gui.center.locationFlow
        if locationFlow ~= nil then
            locationFlow.destroy()
        end
        
        changeCharacter(player, character)
        showGUI(player, index)        
    end
end

--- creates a new player ghost controller
function createGhostController(player, position)
    local position = position or player.position
    game.createentity({name="ls-controller", position=position, force=player.force})
    local entities = game.findentitiesfiltered({area={{position.x, position.y},{position.x, position.y}}, name="ls-controller"})
    if entities[1] ~= nil then
        return entities[1]
    end
end

--- changes the player character
function changeCharacter(player, character)
    if player.character ~= nil and player.character.valid and player.character.name == "ls-controller" then
        player.character.destroy()
    end
    player.character = character
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
    for _,item in pairs(t) do
        count = count + 1
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

--- Loads items local data into a hidden frame
-- Deprecated, hopeless attempt to get the translated item names for sorting
function loadLocaleData(player, index)
    local localeData = glob.localeData[index]
    local localeFrame = player.gui.left.add({type = "frame", name = "localeFrame", direction = "vertical", style = "lv_frame_hidden"})
    for _,item in pairs(game.itemprototypes) do
        local name =  item.name
        if not localeData[name] then
            localeData[name] = true
            local itemLabel = localeFrame.add({type = "label", name = name .. "Label", caption = game.getlocaliseditemname(name)})
        end
    end

    -- save the data
    saveLocaleData(player, index)
end

--- Saves items local data to a table
-- Deprecated, hopeless attempt to get the translated item names for sorting
function saveLocaleData(player, index)
    local translatedNames = glob.translatedNames
    local localeFrame = player.gui.left.localeFrame

    if not translatedNames[index] then
        translatedNames[index] = {}
    end

    if localeFrame ~= nil then
        for _,labelName in pairs(localeFrame.childrennames) do
            if labelName:find("Label") ~= nil then
                local name = string.gsub(labelName, "Label", "")
                local label = localeFrame[labelName]
                if not translatedNames[index][name] then
                    translatedNames[index][name] = label.caption
                end
            end
        end
    end
    glob.translatedNames = translatedNames
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
