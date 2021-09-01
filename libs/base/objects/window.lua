local Window = {}
Window.active = true

Window.color = Color.blue
Window.radX = 6
Window.radY = 6
Window.opacity = 0.5
Window.z = 5

function Window:addChoice(name, settings)
	local settings = settings or {}
	
	self.options[#self.options + 1] = {
		name = name, 
		onPress = settings.onPress,
		
		value = settings.value,
	}
end

function Window:automateHeight()
	local r = 32 + 6
	
	self.height = #self.options * r
end

function Window:render()
	local v = self
	
	local h = (v.alpha / v.opacity)
	local h2 = v.height * h
	
	GFX.rect{
		x = v.x,
		y = v.y,
		width = v.width,
		height = h2,
		
		radX = Window.radX,
		radY = Window.radY,
		
		outline = {color = Color.white()},
		
		color = Window.color() .. v.alpha,
		z = v.z or Window.z,
	}
	
	if v.active then
		for k = 1, #v.options do
			local o = v.options[k]
			
			local r = 6
				
			local time = Timer.time() / 9
			local alpha = math.sin(time) / 4 + 0.25
			
			if v.cursor == (k - 1) then
				GFX.rect{
					x = v.x + r,
					y = (v.y + r) + ((32 + r) * (k - 1)),
					width = v.width - (r * 2),
					height = 28,
					
					radX = Window.radX / 2,
					radY = Window.radY / 2,
					
					outline = {color = Color.white() .. (alpha + 0.5)},
					
					color = Color.white() .. alpha,
					z = (v.z or Window.z) + 0.2,
				}
				
				if v.val_locked then
					GFX.rect{
						x = v.x + r,
						y = (v.y + r) + ((32 + r) * (k - 1)) + 28,
						width = v.width - (r * 2),
						height = 4,

						radX = Window.radX / 2,
						radY = Window.radY / 2,
					
						color = Color.white() .. alpha + 0.5,		
						z = (v.z or Window.z) + 0.2,
					}
				end
			end
			
			GFX.print{
				text = o.name,
				
				x = v.x + r + 4,
				y = v.y + ((32 + r) * (k - 1)) + 4,
				
				color = Color.white(),
				
				z = (v.z or Window.z) + 0.1,
			}
			
			--value
			local val = o.value
			
			if val then
				local text = val.default

				if not val.type then
					if type(text) == 'boolean' then
						text = Vocab[tostring(text)]
					else
						text = text .. '/' .. val.max
					end
					
					GFX.print{
						text = text,
						
						x = v.x + v.width - (r * 2),
						y = v.y + ((32 + r) * (k - 1)) + 4,
						
						align = RIGHT,
						
						color = Color.white(),
						
						z = (v.z or Window.z) + 0.1,
					}
				else
					if val.type == "rect" then
						for i = 1, 2 do
							local w = val.max * 32
							local w2 = val.default * w
							
							GFX.rect{
								x = v.x + v.width - (r * 2) - w,
								y = v.y + ((32 + r) * (k - 1)) + 6,
								width = (i == 2 and w2) or w,
								height = 28,
								
								color = (i == 2 and Color.white()) or Color.gray(),
								z = (v.z or Window.z) + ((i == 2 and 0.15) or 0.1),
							}
						end
					end
				end
			end
		end
	end
end

function Window:tick()
	local v = self
	
	if #v.options ~= 0 then
		if not v.locked and not v.val_locked then
			if Pressed 'down' then
				v.cursor = (v.cursor + 1) % #v.options
				Keys.setDelay('down', 8)
			elseif Pressed 'up' then
				v.cursor = (v.cursor == 0 and #v.options - 1) or (v.cursor - 1)
				Keys.setDelay('up', 8)	
			end
			
			if Pressed 'enter' and not v.closed then
				local option = v.options[v.cursor + 1]
				
				if option.onPress then
					option.onPress()
				end
				
				Keys.setDelay('enter', 12)
			end
			
			if Pressed 'cancel' and v.canClose then
				v:close()
			end
		else
			local option = v.options[v.cursor + 1]
			local value = option.value
			
			local left, right = 'left', 'right'

			local isBool = type(value.default) == 'boolean'
			local inc = value.increment or 1
			
			if not isBool then
				if Pressed(left) then
					value.default = value.default - inc
					
					Keys.setDelay(left, 8)	
				elseif Pressed(right) then
					value.default = value.default + inc
					
					Keys.setDelay(right, 8)	
				end
				
				if value.default < value.min then
					value.default = value.max
				elseif value.default > value.max then
					value.default = value.min
				end	
			else
				if Pressed(left) or Pressed(right) then
					value.default = not value.default
					
					Keys.setDelay(left, 8)	
					Keys.setDelay(right, 8)	
				end
			end	
			
			if Pressed 'enter' or Pressed 'cancel' then
				v.val_locked = false
				
				Keys.setDelay('cancel', 12)
				Keys.setDelay('enter', 12)
			end
		end
	end
end

function Window:close()
	if self.active and not self.closed then
		if self.onClose then
			self.onClose()
		end
		
		self.active = false
		self.closed = true
	end
end

function Window.new(x, y, width, height)
	local v = Window.__init()
	
	v.x = x
	v.y = y
	v.width = width
	v.height = height
	v.active = false
	v.alpha = 0
	v.closed = false
	v.opacity = Window.opacity
	
	v.canClose = false
	
	v.val_locked = false
	v.locked = false
	
	v.options = {}
	v.cursor = 0
	
	return v
end

function Window.draw()
	for k,v in ipairs(Window) do
		v:render()
	end
end

function Window.update()
	for k,v in ipairs(Window) do
		v:tick()
		
		v.alpha = v.alpha + ((v.closed and -0.075) or 0.075)

		if v.alpha > v.opacity and not v.closed then
			if not v.active then
				v.active = true
			end
			
			v.alpha = v.opacity
		end
	
		if v.alpha < 0 then
			table.remove(Window, k)
		end
	end
end

function Window.init()
	registerEvent(Window, 'draw')
	registerEvent(Window, 'update')
end

return Objectify(Window)