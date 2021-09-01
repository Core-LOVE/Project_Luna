SceneManager = {}

local calls = {}

function SceneManager.registerEvent(lib, event)
	if type(lib[event]) == 'function' then
		calls[event] = calls[event] or {}
		
		table.insert(calls[event], {lib[event], parent = lib})
	end
end

registerEvent = SceneManager.registerEvent

function SceneManager.call(event, ...)
	if calls[event] then
		for k,v in ipairs(calls[event]) do
			if v.parent.active then
				v[1](...)
			end
		end
	end
end

local eventList = {
	'update','draw',
}

function SceneManager.registerScene(t)
	t.active = false
	
	for k,v in pairs(eventList) do
		SceneManager.registerEvent(t, v)
	end
	
	setmetatable(t, {__index = SceneManager})
	return t
end

function SceneManager.run(scene)
	if not scene.active then
		if type(scene.load) == 'function' then
			scene.load()
		end
		
		scene.active = true
	end
end

function SceneManager.terminate(scene)
	if scene.active then
		scene.active = false
	end
end

SceneManager.stop = SceneManager.terminate

SceneManager = module(SceneManager)