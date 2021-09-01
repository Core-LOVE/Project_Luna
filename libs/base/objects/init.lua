local path = ... .. [[/]]
path = path:gsub('libs/', '')

Objectify = function(t)
	t.__init = function()
		local v = {}
		
		setmetatable(v, {__index = t})
		table.insert(t, v)
		return v
	end
	
	return t
end

Window = require(path .. 'window')
Event = require(path .. 'event')