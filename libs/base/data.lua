local function loadstuff(dir)
	local t = {}
	local dir = "data/" .. dir .. "/"
	
	local files = love.filesystem.getDirectoryItems(dir)
	
	for k, file in ipairs(files) do
		local char = ini.load(dir .. file)['char']
		
		t[k] = char
	end
	
	return t
end

Data = {}

Data.actors = loadstuff 'actors'