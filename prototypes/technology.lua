data:extend(
{
    {
        type = "technology",
        name = "advanced-logistics-systems",
        icon = "__advanced-logistics-system-fork__/graphics/technology/advanced-ls.png",
        icon_size = 256,
        effects ={},
        prerequisites =
        {
            "logistic-robotics",
            "construction-robotics"
        },
        unit =
        {
            count = 100,
            ingredients =
            {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
            },
            time = 30
        },
        order = "c-k-c-a",
    }
})
