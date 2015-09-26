--- Remote interface functions
remote.add_interface("advanced-logistics-system",
    {
        showSettings = function(player)
            local index = player.index
            hideGUI(player, index)
            showSettings(player, index)
        end
    }
)