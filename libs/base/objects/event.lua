local Event = {}
Event.active = true
Event.pixelMovement = false

function Event:render()
	local v = self
	
	GFX.rect{
		x = v.x,
		y = v.y,
		width = 32,
		height = 32,
	}
end

function Event:tick()
	
end

function Event.new(x, y)
	local v = Event.__init()
	
	v.x = x
	v.y = y
	v.canControl = false
	
	return v
end

function Event.draw()
	for k,v in ipairs(Event) do
		v:render()
	end
end

function Event.update()
	for k,v in ipairs(Event) do
		v:tick()
	end
end


function Event.init()
	registerEvent(Event, 'draw')
	registerEvent(Event, 'update')
end

return Objectify(Event)