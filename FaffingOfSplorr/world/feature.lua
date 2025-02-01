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
    assert(type(feature_id)=="number", "feature_id should be a number")
    return get_feature_data(feature_id).feature_type_id
end
function M.set_statistic(feature_id, statistic_type_id, statistic_value)
    local old_value = M.get_statistic(feature_id, statistic_type_id)
    assert(type(feature_id)=="number", "feature_id should be a number")
    assert(type(statistic_type_id)=="string", "statistic_type_id should be a string")
    assert(type(statistic_value)=="number", "statistic_value should be a number")
    local feature_data = get_feature_data(feature_id)
    if feature_data.statistics == nil then
        feature_data.statistics = {}
    end
    feature_data.statistics[statistic_type_id]=statistic_value
    return old_value
end
function M.get_statistic(feature_id, statistic_type_id)
    assert(type(feature_id)=="number", "feature_id should be a number")
    assert(type(statistic_type_id)=="string", "statistic_type_id should be a string")
    local feature_data = get_feature_data(feature_id)
    if feature_data.statistics == nil then
        return nil
    end
    return feature_data.statistics[statistic_type_id]
end
function M.change_statistic(feature_id, statistic_type_id, delta)
    assert(type(feature_id)=="number", "feature_id should be a number")
    assert(type(statistic_type_id)=="string", "statistic_type_id should be a string")
    assert(type(delta)=="number", "delta should be a number")
    local new_value = M.get_statistic(feature_id, statistic_type_id) + delta
    M.set_statistic(feature_id, statistic_type_id, new_value)
    return new_value
end
function M.recycle(feature_id)
    assert(type(feature_id)=="number", "feature_id should be a number")
    world.data.features[feature_id] = {}
end
return M