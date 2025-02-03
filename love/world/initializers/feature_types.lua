require "world.initializers.feature_type.PINE"
local feature_type = require "world.feature_type"
feature_type.set_describer(feature_type.WELL, function(feature_id) return "This is a well. You drink from it to replenish energy!" end)
feature_type.set_describer(feature_type.WOOD_BUYER, function(feature_id) return "This is a wood buyer. You sell wood to him!" end)
feature_type.set_describer(feature_type.PORTAL, function(feature_id) return "This is a portal. You enter it!" end)
feature_type.set_describer(feature_type.SIGN, function(feature_id) return "Its a sign. You read it!" end)
return nil