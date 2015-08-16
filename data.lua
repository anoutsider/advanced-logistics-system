require("styles.main")
require("prototypes.controller")
require("config")

if itemRequired then    
    require("prototypes.technology-item")
    require("prototypes.recipe")
    require("prototypes.item")
else
    require("prototypes.technology")
end
