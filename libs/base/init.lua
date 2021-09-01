--[[window stuff]]
	love.window.setMode(Game.width, Game.height, Game.flags)
--

local path = ... .. [[/]]

--[[require function change]]
require(path .. 'require')
path = path:gsub('libs/', '')

--[[module]]
require(path .. 'module')

--[[sceneManager]]
require(path .. 'sceneManager')

--[[engine]]
require(path .. 'gfx')
Timer = require(path .. 'timer')
Keys = require(path .. 'keys')

--[[ext]]
Color = require(path .. 'ext/color')
Tween = require(path .. 'ext/tween')
Transitions = require(path .. 'ext/transitions')

--[[parsers]]
ini = require(path .. 'parser/ini')

--[[objects]]
require(path .. 'objects')

--[[etc..]]
require(path .. 'vocab')
require(path .. 'data')

--[[scenes]]
require(path .. 'scene')

function love.update()
	Timer.translateTime(1)
	
	SceneManager.call('update')
end

function love.draw()
	SceneManager.call('draw')

	GFX.internalDraw()
end

function love.keypressed( key )
	SceneManager.call('keypressed', key)
end

function love.keyreleased( key )
	SceneManager.call('keyreleased', key)
end

function love.resize(w, h)
	if Game.widescreen then
		Game.width = w
		Game.height = h
	end
end