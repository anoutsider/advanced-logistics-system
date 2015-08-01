emptyAnimations =       { 
    filename = "__advanced-logistics-system__/graphics/trans.png",
    priority = "medium",
    width = 0,
    height = 0,
    direction_count = 18,
    frame_count = 1,
    animation_speed = 0.15,
    shift = {0, 0},
    axially_symmetrical = false
}

emptyLevel = {
    idle = emptyAnimations,
    idle_mask = emptyAnimations,
    idle_with_gun = emptyAnimations,
    idle_with_gun_mask = emptyAnimations,
    mining_with_hands = emptyAnimations,
    mining_with_hands_mask = emptyAnimations,
    mining_with_tool = emptyAnimations,
    mining_with_tool_mask = emptyAnimations,
    running_with_gun = emptyAnimations,
    running_with_gun_mask = emptyAnimations,
    running = emptyAnimations,
    running_mask = emptyAnimations
}

lsanimations = {
    level1 = emptyLevel, 
    level2addon = emptyLevel, 
    level3addon = emptyLevel
}


data:extend({
    {
        type = "player",
        name = "ls-controller",
        icon = "__base__/graphics/icons/player.png",
        flags = {"pushable", "placeable-player", "placeable-off-grid", "not-repairable", "not-on-map"},
        max_health = 100,
        healing_per_tick = 100,
        collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
        collision_mask = {"ghost-layer"},
        crafting_categories = {"crafting"},
        mining_categories = {"basic-solid"},
        damage_hit_tint = {r = 1, g = 0, b = 0, a = 0},
        inventory_size = 0,
        build_distance = 0,
        drop_item_distance = 0,
        reach_distance = 0,
        reach_resource_distance = 0,
        ticks_to_keep_gun = 0,
        ticks_to_keep_aiming_direction = 0,
        running_speed = 0,
        distance_per_frame = 0,
        maximum_corner_sliding_distance = 0,

        subgroup = "creatures",
        order="z",
        eat =
        {
            {
                filename = "__advanced-logistics-system__/sound/empty.ogg",
                volume = 1
            }
        },
        heartbeat =
        {
            {
                filename = "__advanced-logistics-system__/sound/empty.ogg"
            }
        },
        animations = lsanimations,
        mining_speed = 0,
        mining_with_hands_particles_animation_positions = {0, 0},
        mining_with_tool_particles_animation_positions = {0},
        running_sound_animation_positions = {0, 0}
    }

})