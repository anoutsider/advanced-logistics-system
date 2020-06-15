emptyAnimations =       {
    filename = "__advanced-logistics-system-2__/graphics/trans.png",
    priority = "medium",
    width = 1,
    height = 1,
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


lsplayer = table.deepcopy(data.raw.character.character)
lsplayer.name = 'ls-controller'
lsplayer.max_health = 1
lsplayer.healing_per_tick = 0
lsplayer.collision_mask = {"ghost-layer"}
lsplayer.inventory_size = 0
lsplayer.build_distance = 0
lsplayer.drop_item_distance = 0
lsplayer.reach_distance = 0
lsplayer.reach_resource_distance = 0
lsplayer.ticks_to_keep_gun = 0
lsplayer.ticks_to_keep_aiming_direction = 0
lsplayer.running_speed = 0
lsplayer.distance_per_frame = 0
lsplayer.maximum_corner_sliding_distance = 0
lsplayer.loot_pickup_distance = 0
lsplayer.item_pickup_distance = 0
lsplayer.order="z"
lsplayer.eat =
{
    {
        filename = "__advanced-logistics-system-2__/sound/empty.ogg",
        volume = 1
    }
}
lsplayer.heartbeat =
{
    {
        filename = "__advanced-logistics-system-2__/sound/empty.ogg"
    }
}
lsplayer.animations = lsanimations
lsplayer.mining_speed = 0
lsplayer.mining_with_hands_particles_animation_positions = {0, 0}
lsplayer.mining_with_tool_particles_animation_positions = {0}
lsplayer.running_sound_animation_positions = {0, 0}

data:extend({lsplayer});

