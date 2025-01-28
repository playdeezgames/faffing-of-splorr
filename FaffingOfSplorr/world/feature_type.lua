local M = {}
local data = {}
local function get_descriptor(feature_type_id)
    if data[feature_type_id] == nil then
        data[feature_type_id] = {}
    end
    return data[feature_type_id]
end
function M.get_initializer(feature_type_id)
    return get_descriptor(feature_type_id).initializer
end
function M.set_initializer(feature_type_id, initializer)
    local old_initializer = M.get_initializer(feature_type_id)
    get_descriptor(feature_type_id).initializer = initializer
    return old_initializer
end
return M