require "world.initializers.character_type.HERO"
local character_type = require "world.character_type"
character_type.set_describer(
    character_type.DRUID, 
    function(character_id) 
        return "He's a druid. He doesn't want you punching trees."
    end)
return nil