-- create item icon styles
for _,entitytype in pairs(data.raw) do
   for _,entity in pairs(entitytype) do
      if entity.stack_size and entity.icon then
        local style =
        {
            type = "button_style",
            parent = "item-icon-style",
            default_graphical_set =
            {
                type = "monolith",
                monolith_image =
                {
                    filename = entity.icon,
                    priority = "extra-high-no-scale",
                    width = 32,
                    height = 32,
                }
            },
            hovered_graphical_set =
            {
                type = "monolith",
                monolith_image =
                {
                    filename = entity.icon,
                    priority = "extra-high-no-scale",
                    width = 32,
                    height = 32,
                }
            },
            clicked_graphical_set =
            {
                type = "monolith",
                monolith_image =
                {
                    filename = entity.icon,
                    priority = "extra-high-no-scale",
                    width = 32,
                    height = 32,
                }
            }
        }
        data.raw["gui-style"].default["item-icon-" .. entity.name] = style
      end
   end
end