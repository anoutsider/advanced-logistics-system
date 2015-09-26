--Fonts
data:extend(
{
  {
    type = "font",
    name = "font-s",
    from = "default",
    size = 12
  },
  {
    type = "font",
    name = "font-m",
    from = "default",
    size = 14
  },
  {
    type = "font",
    name = "font-l",
    from = "default",
    size = 16
  },
  {
    type = "font",
    name = "font-sb",
    from = "default-semibold",
    size = 12
  },
  {
    type = "font",
    name = "font-mb",
    from = "default-semibold",
    size = 14
  },
  {
    type = "font",
    name = "font-lb",
    from = "default-semibold",
    size = 16
  }
}
)

--- Settings GUI
data.raw["gui-style"].default["lv_settings_table"] =
{
    type = "table_style",
    font = "font-m",
    minimal_width = 576,
    scalable = false,
    cell_padding = 4,
    horizontal_spacing=0,
    vertical_spacing=6,
    column_graphical_set =
    {
        type = "composition",
        filename = "__core__/graphics/gui.png",
        priority = "extra-high-no-scale",
        corner_size = {3, 3},
        position = {8, 0}
    }
}

data.raw["gui-style"].default["lv_settings_info_label"] =
{
    type = "label_style",
    parent = "label_style",
    align = "left",
    font = "font-s",
}

--- Location view gui

data.raw["gui-style"].default["lv_location_view"] =
{
    type = "button_style",
    parent = "button_style",
    width = 100,
    height = 100,
    top_padding = 65,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-mb",
    default_font_color = {r=0.98, g=0.66, b=0.22},
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/location.png",
            priority = "extra-high-no-scale",
            width = 100,
            height = 100,
            x = 0
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/location-hover.png",
            priority = "extra-high-no-scale",
            width = 100,
            height = 100,
            x = 0
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/location-hover.png",
            width = 100,
            height = 100,
            x = 0
        }
    }
}

--- Main GUI
data.raw["gui-style"].default["lv_frame"] =
{
    type = "frame_style",
    font = "font-m",
    minimal_width = 740,
    top_padding = 2,
    right_padding = 2,
    bottom_padding = 10,
    left_padding = 2,
    scalable = false, 
}

data.raw["gui-style"].default["lv_frame_hidden"] =
{
    type = "frame_style",
    parent = "lv_frame",
    visible = false
}

data.raw["gui-style"].default["lv_title_label"] =
{
    type = "label_style",
    parent = "label_style",
    width = 730,
    align = "center",
    font = "font-lb",
    font_color = {r=0.98, g=0.66, b=0.22}
}

data.raw["gui-style"].default["lv_content_frame"] =
{
    type = "frame_style",
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    graphical_set = { type = "none" },
}

--- Items gui

data.raw["gui-style"].default["lv_items_frame"] =
{
    type = "frame_style",
    parent = "lv_content_frame",
}

data.raw["gui-style"].default["lv_items_table"] =
{
    type = "table_style",
    minimal_height = 400,
    cell_padding = 2,
    horizontal_spacing=0,
    vertical_spacing=4,
    column_graphical_set =
    {
        type = "composition",
        filename = "__core__/graphics/gui.png",
        priority = "extra-high-no-scale",
        corner_size = {3, 3},
        position = {8, 0}
    }
}

-- search
data.raw["gui-style"].default["lv_search_frame"] =
{
    type = "frame_style",
    top_padding = 5,
    right_padding = 5,
    bottom_padding = 5,
    left_padding = 5,
    minimal_height = 40,
    align = "center",
}

data.raw["gui-style"].default["lv_search_frame_hidden"] =
{
    type = "frame_style",
    parent = "lv_search_frame",
    visible = false
}

data.raw["gui-style"].default["lv_search_label"] =
{
    type = "label_style",
    parent = "label_style",
    align = "left",
    top_padding = 3,
    font = "font-mb",
    font_color = {r=0.98, g=0.66, b=0.22}
}

data.raw["gui-style"].default["lv_searchfield_style"] =
{
    type = "textfield_style",
    parent = "textfield_style",
}

-- item info
data.raw["gui-style"].default["lv_info_flow"] =
{
    type = "flow_style",
    horizontal_spacing = 0,
    vertical_spacing = 0,
    width = 736,
    scalable = false,
}

data.raw["gui-style"].default["lv_info_frame"] =
{
    type = "frame_style",
    top_padding = 5,
    right_padding = 5,
    bottom_padding = 5,
    left_padding = 5,
    minimal_height = 40
}

data.raw["gui-style"].default["lv_info_label"] =
{
    type = "label_style",
    parent = "label_style",
    align = "left",
    font = "font-mb",
    font_color = {r=0.98, g=0.66, b=0.22}
}

-- item filters
data.raw["gui-style"].default["lv_filters_frame"] =
{
    type = "frame_style",
    top_padding = 0,
    right_padding = 5,
    bottom_padding = 0,
    left_padding = 5,
    minimal_height = 40
}

-- items table headers
data.raw["gui-style"].default["lv_table_flow"] =
{
    type = "flow_style",
    horizontal_spacing = 4,
    vertical_spacing = 0,
    width = 72,
    scalable = false,
}

data.raw["gui-style"].default["lv_total_flow"] =
{
    type = "flow_style",
    horizontal_spacing = 4,
    vertical_spacing = 0,
    width = 82,
    scalable = false,
}

data.raw["gui-style"].default["lv_pos_flow"] =
{
    type = "flow_style",
    horizontal_spacing = 4,
    vertical_spacing = 0,
    width = 82,
    scalable = false,
}

data.raw["gui-style"].default["lv_sort_flow"] =
{
    type = "flow_style",
    horizontal_spacing = 0,
    vertical_spacing = 0,
    width = 14,
    scalable = false,
}

data.raw["gui-style"].default["lv_name_flow"] =
{
    type = "flow_style",
    horizontal_spacing = 4,
    vertical_spacing = 0,
    width = 252,
    scalable = false,
}

data.raw["gui-style"].default["lv_items_info_flow"] =
{
    type = "flow_style",
    horizontal_spacing = 0,
    vertical_spacing = 0,
    width = 26,
    scalable = false,
}

data.raw["gui-style"].default["lv_tools_flow"] =
{
    type = "flow_style",
    horizontal_spacing = 6,
    vertical_spacing = 0,
    width = 252,
    scalable = false,
}

-- Networks 
data.raw["gui-style"].default["lv_network_value_flow"] =
{
    type = "flow_style",
    parent = "flow_style",
    scalable = false,
    width = 188,
}

data.raw["gui-style"].default["lv_network_name_hidden"] =
{
    type = "label_style",
    parent = "label_style",
    visible = false
}

data.raw["gui-style"].default["lv_networks_table"] =
{
    type = "table_style",
    cell_padding = 5,
    horizontal_spacing=0,
    vertial_spacing=0,
    column_graphical_set =
    {
        type = "composition",
        filename = "__core__/graphics/gui.png",
        priority = "extra-high-no-scale",
        corner_size = {3, 3},
        position = {8, 0}
    }
}

-- Buttons

data.raw["gui-style"].default["lv_button"] =
{
    type = "button_style",
    parent = "button_style",
    top_padding = 3,
    right_padding = 3,
    bottom_padding = 3,
    left_padding = 3,
    font = "font-m",
    hovered_font_color = {r=0.1, g=0.1, b=0.1},
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 0
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 32
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 0
        }
    }
}

data.raw["gui-style"].default["lv_button_selected"] =
{
    type = "button_style",
    parent = "lv_button",
    default_font_color = {r=0.1, g=0.1, b=0.1},
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 32
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 0
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 0
        }
    }
}

data.raw["gui-style"].default["lv_button_main"] =
{
    type = "button_style",
    parent = "lv_button",
    top_padding = 6,
    right_padding = 8,
    bottom_padding = 6,
    left_padding = 8,
    font = "font-m",
}

data.raw["gui-style"].default["lv_button_main_icon"] =
{
    type = "button_style",
    parent = "button_style",
    width = 32,
    height = 32,
    top_padding = 6,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 256,
            y = 32
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 288,
            y = 32
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 288,
            y = 32
        }
    }
}

data.raw["gui-style"].default["lv_button_close"] =
{
    type = "button_style",
    parent = "button_style",
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    width = 16,
    height = 16,
    font = "font-sb",
    align = "center",
    hovered_font_color = {r=0.1, g=0.1, b=0.1},
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 16,
            height = 16,
            x = 0
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 16,
            height = 16,
            x = 32
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 16,
            height = 16,
            x = 0
        }
    }
}

-- items table action icons
data.raw["gui-style"].default["lv_button_info"] =
{
    type = "button_style",
    parent = "button_style",
    width = 22,
    height = 23,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 325,
            y= 37
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 357,
            y= 37
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 22,
            height = 23,
            x = 357,
            y= 37
        }
    }
}

data.raw["gui-style"].default["lv_button_location"] =
{
    type = "button_style",
    parent = "button_style",
    width = 22,
    height = 23,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 5,
            y= 69
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 37,
            y= 69
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 22,
            height = 23,
            x = 37,
            y= 69
        }
    }
}

data.raw["gui-style"].default["lv_button_teleport"] =
{
    type = "button_style",
    parent = "button_style",
    width = 22,
    height = 23,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 133,
            y= 69
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 165,
            y= 69
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 22,
            height = 23,
            x = 165,
            y= 69
        }
    }
}

data.raw["gui-style"].default["lv_button_delete"] =
{
    type = "button_style",
    parent = "button_style",
    width = 22,
    height = 23,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 69,
            y= 69
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 101,
            y= 69
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 22,
            height = 23,
            x = 101,
            y= 69
        }
    }
}

data.raw["gui-style"].default["lv_button_delete_selected"] =
{
    type = "button_style",
    parent = "button_style",
    width = 22,
    height = 23,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 101,
            y= 69
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 69,
            y= 69
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
            monolith_image =
            {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 22,
            height = 23,
            x = 101,
            y= 69
        }
    }
}

data.raw["gui-style"].default["lv_button_up_apc"] =
{
    type = "button_style",
    parent = "button_style",
    width = 22,
    height = 23,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 197,
            y= 69
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 325,
            y= 69
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 22,
            height = 23,
            x = 325,
            y= 69
        }
    }
}

data.raw["gui-style"].default["lv_button_up_ppc"] =
{
    type = "button_style",
    parent = "button_style",
    width = 22,
    height = 23,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 229,
            y= 69
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 325,
            y= 69
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 22,
            height = 23,
            x = 325,
            y= 69
        }
    }
}

data.raw["gui-style"].default["lv_button_up_sc"] =
{
    type = "button_style",
    parent = "button_style",
    width = 22,
    height = 23,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 261,
            y= 69
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 325,
            y= 69
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 22,
            height = 23,
            x = 325,
            y= 69
        }
    }
}


data.raw["gui-style"].default["lv_button_up_rc"] =
{
    type = "button_style",
    parent = "button_style",
    width = 22,
    height = 23,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 293,
            y= 69
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 325,
            y= 69
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 22,
            height = 23,
            x = 325,
            y= 69
        }
    }
}

-- items table sort icons
data.raw["gui-style"].default["lv_button_name"] =
{
    type = "button_style",
    parent = "lv_button",
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    width = 230,
    height = 32,
    hovered_font_color = {r=0.1, g=0.1, b=0.1},
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 0
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 32
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 0
        }
    }
}

data.raw["gui-style"].default["lv_button_name_selected"] =
{
    type = "button_style",
    parent = "lv_button_name",
    default_font_color = {r=0.1, g=0.1, b=0.1},
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 32
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 0
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 0
        }
    }
}

data.raw["gui-style"].default["lv_button_total"] =
{
    type = "button_style",
    parent = "lv_button",
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    width = 60,
    height = 32,
    hovered_font_color = {r=0.1, g=0.1, b=0.1},
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 0
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 32
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 0
        }
    }
}

data.raw["gui-style"].default["lv_button_total_selected"] =
{
    type = "button_style",
    parent = "lv_button_total",
    default_font_color = {r=0.1, g=0.1, b=0.1},
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 32
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 0
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 0
        }
    }
}

data.raw["gui-style"].default["lv_button_count"] =
{
    type = "button_style",
    parent = "lv_button_total",
}

data.raw["gui-style"].default["lv_button_count_selected"] =
{
    type = "button_style",
    parent = "lv_button_total_selected",
}

data.raw["gui-style"].default["lv_button_pos"] =
{
    type = "button_style",
    parent = "lv_button_total",
    width = 60,
}

data.raw["gui-style"].default["lv_button_pos_selected"] =
{
    type = "button_style",
    parent = "lv_button_total_selected",
    width = 60,
}

data.raw["gui-style"].default["lv_button_position"] =
{
    type = "button_style",
    parent = "lv_button_total",
    width = 60,
}

data.raw["gui-style"].default["lv_button_position_selected"] =
{
    type = "button_style",
    parent = "lv_button_total_selected",
    width = 60,
}

data.raw["gui-style"].default["lv_button_size"] =
{
    type = "button_style",
    parent = "lv_button_total",
    width = 60,
}

data.raw["gui-style"].default["lv_button_size_selected"] =
{
    type = "button_style",
    parent = "lv_button_total_selected",
    width = 60,
}

data.raw["gui-style"].default["lv_button_items"] =
{
    type = "button_style",
    parent = "lv_button_total",
    width = 60,
}

data.raw["gui-style"].default["lv_button_items_selected"] =
{
    type = "button_style",
    parent = "lv_button_total_selected",
    width = 60,
}

data.raw["gui-style"].default["lv_button_log"] =
{
    type = "button_style",
    parent = "lv_button_total",
    width = 60,
}

data.raw["gui-style"].default["lv_button_log_selected"] =
{
    type = "button_style",
    parent = "lv_button_total_selected",
    width = 60,
}

data.raw["gui-style"].default["lv_button_con"] =
{
    type = "button_style",
    parent = "lv_button_total",
    width = 60,
}

data.raw["gui-style"].default["lv_button_con_selected"] =
{
    type = "button_style",
    parent = "lv_button_total_selected",
    width = 60,
}

data.raw["gui-style"].default["lv_button_charging"] =
{
    type = "button_style",
    parent = "lv_button_total",
    width = 60,
}

data.raw["gui-style"].default["lv_button_charging_selected"] =
{
    type = "button_style",
    parent = "lv_button_total_selected",
    width = 60,
}

data.raw["gui-style"].default["lv_button_waiting"] =
{
    type = "button_style",
    parent = "lv_button_total",
    width = 60,
}

data.raw["gui-style"].default["lv_button_waiting_selected"] =
{
    type = "button_style",
    parent = "lv_button_total_selected",
    width = 60,
}

data.raw["gui-style"].default["lv_button_all"] =
{
    type = "button_style",
    parent = "lv_button",
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    width = 32,
    height = 32,
}

data.raw["gui-style"].default["lv_button_all_selected"] =
{
    type = "button_style",
    parent = "lv_button_selected",
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    width = 32,
    height = 32,
}

data.raw["gui-style"].default["lv_button_apc"] =
{
    type = "button_style",
    parent = "button_style",
    width = 32,
    height = 32,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 64
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 96
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 64
        }
    }
}

data.raw["gui-style"].default["lv_button_apc_selected"] =
{
    type = "button_style",
    parent = "lv_button_apc",
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 96
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 64
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 64
        }
    }
}

data.raw["gui-style"].default["lv_button_ppc"] =
{
    type = "button_style",
    parent = "button_style",
    width = 32,
    height = 32,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 128
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 160
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 128
        }
    }
}

data.raw["gui-style"].default["lv_button_ppc_selected"] =
{
    type = "button_style",
    parent = "lv_button_ppc",
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 160
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 128
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 128
        }
    }
}

data.raw["gui-style"].default["lv_button_sc"] =
{
    type = "button_style",
    parent = "button_style",
    width = 32,
    height = 32,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 192
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 224
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 192
        }
    }
}

data.raw["gui-style"].default["lv_button_sc_selected"] =
{
    type = "button_style",
    parent = "lv_button_sc",
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 224
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 192
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 192
        }
    }
}

data.raw["gui-style"].default["lv_button_rc"] =
{
    type = "button_style",
    parent = "button_style",
    width = 32,
    height = 32,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 256
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 288
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 256
        }
    }
}

data.raw["gui-style"].default["lv_button_rc_selected"] =
{
    type = "button_style",
    parent = "lv_button_rc",
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 288
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 256
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 256
        }
    }
}

data.raw["gui-style"].default["lv_button_woc"] =
{
    type = "button_style",
    parent = "button_style",
    width = 32,
    height = 32,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 0,
            y = 32
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 32,
            y = 32
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 0,
            y = 32
        }
    }
}

data.raw["gui-style"].default["lv_button_woc_selected"] =
{
    type = "button_style",
    parent = "lv_button_woc",
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 32,
            y = 32
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 0,
            y = 32
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 0,
            y = 32
        }
    }
}

data.raw["gui-style"].default["lv_button_irc"] =
{
    type = "button_style",
    parent = "button_style",
    width = 32,
    height = 32,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 64,
            y = 32
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 96,
            y = 32
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 64,
            y = 32
        }
    }
}

data.raw["gui-style"].default["lv_button_irc_selected"] =
{
    type = "button_style",
    parent = "lv_button_irc",
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 96,
            y = 32
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 64,
            y = 32
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 64,
            y = 32
        }
    }
}

data.raw["gui-style"].default["lv_button_stc"] =
{
    type = "button_style",
    parent = "button_style",
    width = 32,
    height = 32,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 128,
            y = 32
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 160,
            y = 32
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 128,
            y = 32
        }
    }
}

data.raw["gui-style"].default["lv_button_stc_selected"] =
{
    type = "button_style",
    parent = "lv_button_stc",
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 160,
            y = 32
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 128,
            y = 32
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 128,
            y = 32
        }
    }
}

data.raw["gui-style"].default["lv_button_smc"] =
{
    type = "button_style",
    parent = "button_style",
    width = 32,
    height = 32,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 192,
            y = 32
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 224,
            y = 32
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 192,
            y = 32
        }
    }
}

data.raw["gui-style"].default["lv_button_smc_selected"] =
{
    type = "button_style",
    parent = "lv_button_smc",
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 224,
            y = 32
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 192,
            y = 32
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 192,
            y = 32
        }
    }
}

data.raw["gui-style"].default["lv_button_log"] =
{
    type = "button_style",
    parent = "button_style",
    width = 32,
    height = 32,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 128,
            y = 96
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 160,
            y = 96
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 160,
            y = 96
        }
    }
}

data.raw["gui-style"].default["lv_button_log_selected"] =
{
    type = "button_style",
    parent = "lv_button_log",
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 160,
            y = 96
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 128,
            y = 96
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 128,
            y = 96
        }
    }
}

data.raw["gui-style"].default["lv_button_con"] =
{
    type = "button_style",
    parent = "button_style",
    width = 32,
    height = 32,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 192,
            y = 96
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 224,
            y = 96
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 224,
            y = 96
        }
    }
}

data.raw["gui-style"].default["lv_button_con_selected"] =
{
    type = "button_style",
    parent = "lv_button_con",
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 224,
            y = 96
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 192,
            y = 96
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 192,
            y = 96
        }
    }
}

data.raw["gui-style"].default["lv_button_port"] =
{
    type = "button_style",
    parent = "button_style",
    width = 32,
    height = 32,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 256,
            y = 96
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 288,
            y = 96
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 288,
            y = 96
        }
    }
}

data.raw["gui-style"].default["lv_button_port_selected"] =
{
    type = "button_style",
    parent = "lv_button_port",
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 288,
            y = 96
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 32,
            height = 32,
            x = 256,
            y = 96
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 32,
            height = 32,
            x = 256,
            y = 96
        }
    }
}

data.raw["gui-style"].default["lv_button_edit"] =
{
    type = "button_style",
    parent = "button_style",
    width = 22,
    height = 23,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    visible = true,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 5,
            y= 101
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 37,
            y= 101
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 22,
            height = 23,
            x = 37,
            y= 101
        }
    }
}

data.raw["gui-style"].default["lv_button_confirm"] =
{
    type = "button_style",
    parent = "button_style",
    width = 22,
    height = 23,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    font = "font-m",
    scalable = false,
    visible = true,
    default_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 69,
            y= 101
        }
    },
    hovered_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 22,
            height = 23,
            x = 101,
            y= 101
        }
    },
    clicked_graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            width = 22,
            height = 23,
            x = 101,
            y= 101
        }
    }
}

data.raw["gui-style"].default["lv_button_hidden"] =
{
    type = "button_style",
    parent = "button_style",
    visible = false,
}


-- sort controls
data.raw["gui-style"].default["lv_sort_desc"] =
{
    type = "frame_style",
    parent = "frame_style",
    width = 14,
    height = 14,
    top_padding  = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    scalable = false,
    graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 14,
            height = 14,
            x = 322,
            y = 9
        }
    }
}

data.raw["gui-style"].default["lv_sort_asc"] =
{
    type = "frame_style",
    parent = "frame_style",
    width = 14,
    height = 14,
    top_padding  = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    scalable = false,
    graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 14,
            height = 14,
            x = 338,
            y = 9
        }
    }
}

data.raw["gui-style"].default["lv_sort"] =
{
    type = "frame_style",
    parent = "frame_style",
    width = 14,
    height = 14,
    top_padding  = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    scalable = false,
    graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 14,
            height = 14,
            x = 352,
            y = 64
        }
    }
}

data.raw["gui-style"].default["lv_sort_holder"] =
{
    type = "frame_style",
    parent = "frame_style",
    width = 16,
    height = 9,
    top_padding  = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    scalable = false,
    graphical_set =
    {
        type = "monolith",
        monolith_image =
        {
            filename = "__advanced-logistics-system__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 16,
            height = 32,
            x = 352,
            y = 64
        }
    }
}

-- Item icons base styles
data.raw["gui-style"].default["item-icon-style"] =
{
    type = "checkbox_style",
    parent = "checkbox_style",
    width = 38,
    height = 38,
    left_padding = 1,
    scalable = false,
    default_background =
    {
        filename = "__advanced-logistics-system__/graphics/gui.png",
        priority = "extra-high-no-scale",
        width = 32,
        height = 32,
        x = 0
    },
    hovered_background =
    {
        filename = "__advanced-logistics-system__/graphics/gui.png",
        priority = "extra-high-no-scale",
        width = 32,
        height = 32,
        x = 32
    },
    clicked_background =
    {
        filename = "__advanced-logistics-system__/graphics/gui.png",
        width = 32,
        height = 32,
        x = 32
    }
}
