local Timer = {}
local t = 0

function Timer.time()
	return t
end

function Timer.translateTime(v)
	t = t + v
end

return Timer