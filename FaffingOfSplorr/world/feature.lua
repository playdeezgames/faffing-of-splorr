local feature_type = require "world.feature_type"
local world = require "world.world"
local M = {}
world.data.features = {}
local function get_feature_data(feature_id)
    return world.data.features[feature_id]
end
function M.initialize(feature_id, feature_type_id)
    assert(type(feature_id)=="number", "feature_id should be a number")
    assert(type(feature_type_id)=="string", "feature_type_id should be a string")
    world.data.features[feature_id] = {
        feature_type_id = feature_type_id
    }
    local initializer = feature_type.get_initializer(feature_type_id)
    if initializer ~= nil then
        initializer(feature_id)
    end
end
function M.create(feature_type_id)
    assert(type(feature_type_id)=="string", "feature_type_id should be a string")
    local feature_id = #world.data.features + 1
    M.initialize(feature_id, feature_type_id)
    return feature_id
end
function M.get_feature_type(feature_id)
    return get_feature_data(feature_id).feature_type_id
end
return M