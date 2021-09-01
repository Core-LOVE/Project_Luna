local color = {}
local cache = {}

local mt = {}

function mt.__concat(a, b)
	a[4] = b
	return a
end

function mt.__add(a, b)
	for k,v in ipairs(a) do
		v = v + b
	end
	
	return a
end

function mt.__sub(a, b)
	for k,v in ipairs(a) do
		v = v - b
	end
	
	return a
end

function mt.__mul(a, b)
	for k,v in ipairs(a) do
		v = v * b
	end
	
	return a
end

function mt.__div(a, b)
	for k,v in ipairs(a) do
		v = v / b
	end
	
	return a
end

function mt.__pow(a, b)
	for k,v in ipairs(a) do
		v = v ^ b
	end
	
	return a
end

function mt.__eq(a, b)
	return ((a[1] == b[1]) and (a[2] == b[2]) and (a[3] == b[3]) and (a[4] == b[4]))
end

function mt.__lt(a, b)
	return ((a[1] < b[1]) and (a[2] < b[2]) and (a[3] < b[3]) and (a[4] < b[4]))
end

function mt.__le(a, b)
	return ((a[1] <= b[1]) and (a[2] <= b[2]) and (a[3] <= b[3]) and (a[4] <= b[4]))
end

function color.hex(hex)
	local r = '0x' .. string.sub(hex, 1, 2)
	local g = '0x' .. string.sub(hex, 3, 4)
	local b = '0x' .. string.sub(hex, 5, 6)
	
	local t = {tonumber(r) / 255, tonumber(g) / 255, tonumber(b) / 255}
	t[4] = 1
	
	setmetatable(t, mt)
	return t
end

local function declare(hex)
	return function()
		return color.hex(hex)
	end
end

color.white = declare('FFFFFF')
color.black = declare('000000')
color.gray = declare('999999')
color.darkgray = declare('3F3F3F')
color.lightgray = declare('BFBFBF')
color.red = declare('FF0000')
color.green = declare('00FF00')
color.blue = declare('0000FF')

setmetatable(color, {__call = function(self, rgb)
	return color.hex(rgb)
end})

return color