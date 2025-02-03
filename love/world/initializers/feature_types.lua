require "world.initializers.feature_type.PINE"
local feature = require "world.feature"
local feature_type = require "world.feature_type"
feature.set_describer(
    function(feature_id)
        local feature_type_id = feature.get_feature_type(feature_id)
        if feature_type_id == feature_type.PINE then
            return "This is a tree. You punch it!"
        elseif feature_type_id == feature_type.WELL then
            return "This is a well. You drink from it to replenish energy!"
        elseif feature_type_id == feature_type.WOOD_BUYER then
            return "This is a wood buyer. You sell wood to him!"
        elseif feature_type_id == feature_type.PORTAL then
            return "This is a portal. You enter it!"
        end
        return ""
    end)
return nil