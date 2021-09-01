GFX = {}

local queqe = {}
local fonts = {}

local function registerFont(name, size)
	if type(name) == 'string' then
		if not fonts[name] then
			fonts[name] = love.graphics.newFont('fonts/' .. name, size or 22)
		end
		
		return fonts[name]
	else
		return name
	end
end

GFX.defaultFont = registerFont 'def.ttf'
GFX.bigFont = registerFont('big.ttf', 50)

function GFX.draw(t)
	local t = t or {}
	
	t.x = t.x or 0
	t.y = t.y or 0
	t.z = t.z or 0
	
	t.type = t.type or 'image'
	t.color = t.color or Color.white()
	if t.type == 'rect' then
		if not t.width or not t.height then return end
		
		t.radX = t.radX or 0
		t.radY = t.radY or 0
		
		if t.outline then
			local outline = t.outline
			
			if outline == true then
				outline = {}
			end
			
			for k,v in pairs(t) do
				if k ~= 'outline' and k ~= 'color' and k ~= 'z' then
					outline[k] = v
				end
			end
			
			outline.font = origFont
			
			outline.xOffset = outline.xOffset or 0
			outline.yOffset = outline.yOffset or 0
			
			outline.x = outline.x + outline.xOffset
			outline.y = outline.y + outline.yOffset	
			outline.color = outline.color or Color.black()
			outline.mode = 'line'
			
			outline.z = t.z + 0.1
			
			GFX.draw(outline)
		end
	elseif t.type == 'text' then
		t.text = t.str or t.text
		t.text = t.string or t.text
		
		if not t.text then return end
		
		t.text = tostring(t.text)
		
		local origFont = t.font or GFX.defaultFont
		t.font = registerFont(origFont)

		if t.shadow then
			local shadow = t.shadow
			
			if shadow == true then
				shadow = {}
			end
			
			for k,v in pairs(t) do
				if k ~= 'shadow' and k ~= 'color' and k ~= 'z' then
					shadow[k] = v
				end
			end
			
			shadow.font = origFont
			
			shadow.xOffset = shadow.xOffset or 1
			shadow.yOffset = shadow.yOffset or 1
			
			shadow.x = shadow.x + shadow.xOffset
			shadow.y = shadow.y + shadow.yOffset	
			shadow.color = shadow.color or Color.black()
			
			shadow.z = shadow.z or (t.z - 0.1)
			
			GFX.draw(shadow)
		end
	else
		t.texture = t.img or t.texture
		t.texture = t.image or t.texture
		
		if not t.texture then return end
	end
	
	queqe[#queqe + 1] = t
end

function GFX.rect(t)
	local t = t or {}
	t.type = 'rect'
	
	GFX.draw(t)
end

function GFX.screen(t)
	local t = t or {}
	t.type = 'rect'
	
	t.width = 640
	t.height = 480
	
	GFX.draw(t)
end

function GFX.print(t)
	local t = t or {}
	t.type = 'text'
	
	GFX.draw(t)
end

RIGHT = 1

local function draw(t)
	love.graphics.setColor(t.color)
	
	if t.type == 'rect' then
		love.graphics.rectangle(t.mode or 'fill', t.x, t.y, t.width, t.height, t.radX, t.radY)
	elseif t.type == 'text' then
		love.graphics.setFont(t.font)
		
		local x = 0
		local y = 0
		
		if t.align == RIGHT then
			x = x - t.font:getWidth(t.text)
		end
		
		love.graphics.print(t.text, t.x + x, t.y + y)
	else
		love.graphics.draw(t.texture, t.x, t.y)
	end
	
	love.graphics.setColor(1, 1, 1, 1)
end

local function sort(a, b)
	return (a.z < b.z)
end

function GFX.internalDraw()
	table.sort(queqe, sort)
	
	for k = 1, #queqe do
		draw(queqe[k])
	end
	
	queqe = {}
end

GFX = module(GFX)