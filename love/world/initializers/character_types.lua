require "world.initializers.character_type.HERO"
local character = require "world.character"
character.set_describer(
    function(character_id)
        return ""
    end)
return nil