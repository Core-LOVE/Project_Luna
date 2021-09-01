local trans = {}
trans.z = 10
trans.active = true

function trans.new(fc, sc, settings)
	local v = {}
	
	v.color = fc
	v.startCol = fc
	v.nextCol = sc
	
	v.settings = settings or {}
	v.settings.time = (v.settings.time or 60) / 30
	v.settings.style = v.settings.style or 'linear'
	v.settings.remove = v.settings.remove or true
	
	v.tween = Tween.new(v.settings.time, v.color, {v.nextCol[1], v.nextCol[2], v.nextCol[3], v.nextCol[4]}, v.settings.style)
	
	setmetatable(v, {__index = trans})
	trans[#trans + 1] = v
	return v
end

function trans:terminate()
	self.time = v.settings.time + 0.1
end

function trans.draw()
	for k = 1, #trans do
		local v = trans[k]
		
		if v then
			local done = v.tween:update(0.1)
			
			GFX.screen{
				color = v.color,
				
				z = v.z or trans.z,
			}

			if done and v.settings.remove then
				if type(v.settings.onEnd) == 'function' then
					v.settings.onEnd()
				end
				
				table.remove(trans, k)
			end
		end
	end
end

function trans.init()
	registerEvent(trans, 'draw')
end

return trans