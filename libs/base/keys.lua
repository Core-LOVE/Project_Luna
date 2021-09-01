local Keys = {}
Keys.active = true

local options = {
	cancel = 'x',
	enter = 'z',
	
	left = 'left',
	right = 'right',
	up = 'up',
	down = 'down',
}

KEY_PRESSED = 1
KEY_DOWN = true
KEY_UP = false
KEY_RELEASED = 0

local state = {
	cancel = KEY_UP,
	enter = KEY_UP,
	
	left = KEY_UP,
	right = KEY_UP,
	up = KEY_UP,
	down = KEY_UP,
}

local delay = {}

setmetatable(delay, {
	__index = function(self, key)
		rawset(self, key, 0)
		
		return rawget(self, key)
	end
})

function Keys.getDelay(key)
	return delay[key]
end


function Keys.setDelay(key, val)
	if Keys.getDelay(key) <= 0 then
		delay[key] = val
	end
end

function Keys.getState(key)
	if Keys.getDelay(key) <= 0 then
		return state[key]
	else
		return KEY_UP
	end
end

function Pressed(key)
	local st = Keys.getState(key)
	
	return (st == KEY_PRESSED and true) or (st == KEY_RELEASED and false) or st
end

function Keys.update()
	for k,v in pairs(delay) do
		if v > 0 then
			delay[k] = delay[k] - 1
		end
	end
	
	for k,v in pairs(options) do
		local key = love.keyboard.isDown(v)
		local st = state[k]
		
		if key and st == KEY_PRESSED then
			state[k] = KEY_DOWN
		elseif not key and st == KEY_RELEASED then
			state[k] = KEY_UP
		end
	end
end

function Keys.keypressed(key)
	for k,v in pairs(options) do
		if v == key then
			state[k] = KEY_PRESSED
		end
	end
end

function Keys.keyreleased(key)
	for k,v in pairs(options) do
		if v == key then
			state[k] = KEY_RELEASED
		end
	end
end

function Keys.init()
	registerEvent(Keys, 'keyreleased')
	registerEvent(Keys, 'keypressed')
	registerEvent(Keys, 'update')
end

return Keys