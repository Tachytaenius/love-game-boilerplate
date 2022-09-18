# LÖVE game boilerplate library

TODO: Explanation.

Make sure in `conf.lua` you set `t.window` to `nil`.

Basic `main.lua`:
```lua
local boilerplate = require("lib.love-game-boilerplate-lib")

local frameCommands = {
	
}

local fixedCommands = {
	
}

local settingsUiLayout = {
	
}

local settingsTypes = boilerplate.settingsTypes
local settingsTemplate = {
	fixedCommands = settingsTypes.commands("fixed", {
		
	})
}

local initConfig = {
	fixedUpdateTickLength = 1 / 24,
	outputCanvasWidth = 384,
	outputCanvasHeight = 256,
	frameCommands = frameCommands,
	fixedCommands = fixedCommands,
	settingsUiLayout = settingsUiLayout,
	settingsTemplate = settingsTemplate
}

function boilerplate.load(args)
	
end

function boilerplate.update(dt)
	
end

function boilerplate.fixedUpdate(dt)
	
end

function boilerplate.draw(lerp, dt)
	love.graphics.setCanvas(boilerplate.outputCanvas)
	love.graphics.clear()
	love.graphics.print("It works!")
	love.graphics.setCanvas()
end

-- function boilerplate.getScreenshotCanvas()
-- 	
-- end

function boilerplate.quit()
	
end

boilerplate.init(initConfig, arg)
```
