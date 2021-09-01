module = function(virtual_t)
	local copy_t = virtual_t or {}
	
	local default_t = {}
	for k,v in pairs(virtual_t) do
		default_t[k] = v
	end
	
	local real_t = {}
	
	setmetatable(real_t, {
		__index = function(self, key)
			return copy_t[key]
		end,
		
		__newindex = function(self, key, val)
			if val == nil then
				copy_t[key] = default_t[key]
			else
				copy_t[key] = val
			end
		end,
	})
	
	return real_t
end