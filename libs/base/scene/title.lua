Title = {}
local command_window
local option_window

local function remove_window(f)
	command_window:close()
	
	Transitions.new(Color.black() .. 0, Color.black(), {
		time = 160,
	
		onEnd = f
	})
end

local function newGame()
	remove_window(function()
		Title:stop()
		SceneMap:run()
			
		Transitions.new(Color.black(), Color.black() .. 0, {
			time = 160,
		})	
	end)
end

local function exit()
	remove_window(function()
		love.event.quit()
	end)
end

local function options()
	command_window:close()
	
	local w, h = 48, 48
	
	option_window = Window.new(w, h, Game.width - (w * 2), Game.height - (h * 2))
	option_window:addChoice(Vocab.musicVolume, {
		value = {min = 0, max = 1, default = 1, increment = 0.1, type = 'rect'},
		onPress = function()
			option_window.val_locked = true
		end
	})
	
	option_window:addChoice(Vocab.fullscreen, {
		value = {default = false},
		onPress = function()
			option_window.val_locked = true
		end
	})
	
	option_window.canClose = true
	option_window.onClose = function()
		local w = 320 / 2
		local h = 32
		
		local x = 320 - (w / 2)
		local y = 480 - h - 32
		
		command_window = Window.new(x, y, w, h)
		
		command_window:addChoice(Vocab.newGame, {onPress = newGame})
		command_window:addChoice(Vocab.continue)
		command_window:addChoice(Vocab.exit, {onPress = exit})
		command_window:addChoice(Vocab.options, {onPress = options})
		
		command_window:automateHeight()
		command_window.y = command_window.y - command_window.height
	end
end

local function create_window()
	local w = (Game.width / 2) / 2
	local h = 32
	
	local x = Game.width / 2 - (w / 2)
	local y = Game.height - h - 32
	
	command_window = Window.new(x, y, w, h)

	command_window:addChoice(Vocab.newGame, {onPress = newGame})
	command_window:addChoice(Vocab.continue)
	command_window:addChoice(Vocab.exit, {onPress = exit})
	command_window:addChoice(Vocab.options, {onPress = options})
	
	command_window:automateHeight()
	command_window.y = command_window.y - command_window.height
end

function Title.load()
	Transitions.new(Color.black(), Color.black() .. 0, {
		onEnd = function()
			create_window()
		end
	})
	
	love.graphics.setBackgroundColor(0.5, 0.5, 0.5, 1)
end

function Title.draw()
	local name = Vocab.gameName
	
	local w = GFX.bigFont:getWidth(name)
	local x = Game.width / 2 - (w / 2)
	-- local x = ((640) - (50 * #name) / 2) / 2
	
	GFX.print{
		x = x,
		y = 48,
		
		text = name,
		color = {1,1,1,1},
		
		shadow = true,
		font = GFX.bigFont,
	}
end

Title = SceneManager.registerScene(Title)