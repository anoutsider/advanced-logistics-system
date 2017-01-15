--- Remote interface functions
remote.add_interface("advanced-logistics-system",
    {
        showSettings = function(player)
            local index = player.index
            hideGUI(player, index)
            showSettings(player, index)
        end,

        activateSystem = function(player)
            local index = player.index
            local forceName = player.force.name
            init()
            initForce(player.force)
            global.hasSystem[forceName] = true
            initPlayer(player)
            initGUI(player, true)
        end
    }
)
