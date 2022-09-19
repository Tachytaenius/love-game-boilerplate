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
	-- TEMP: You have to set up the UI layout for library-owned settings yourself (TODO)
}

local settingsTypes = boilerplate.settingsTypes
local settingsTemplate = {
	fixedCommands = settingsTypes.commands("fixed", {
		
	})
}

local uiNames = {
	
}

local assets = {
	ui = {
		font = {load = function(self) self.value = love.graphics.newImageFont("assets/images/ui/font.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.!?$,#@~:;-{}&()<>'%/*0123456789") end},
		cursor = {load = function(self) self.value = love.graphics.newImage("assets/images/ui/cursor.png") end}
	}
}

local initConfig = {
	fixedUpdateTickLength = 1 / 24,
	canvasSystemWidth = 384,
	canvasSystemHeight = 256,
	frameCommands = frameCommands,
	fixedCommands = fixedCommands,
	settingsUiLayout = settingsUiLayout,
	settingsTemplate = settingsTemplate,
	uiNames = uiNames,
	uiNamePathPrefix = "uis",
	uiTint = {0.5, 0.5, 0.5},
	assets = assets
}

local unsaved

function boilerplate.load(args)
	unsaved = true
end

function boilerplate.update(dt, performance)
	
end

function boilerplate.fixedUpdate(dt)
	unsaved = true
	-- use boilerplate.fixedMouseDx and boilerplate.fixedMouseDy to look around et cetera
end

function boilerplate.draw(lerp, dt, performance)
	love.graphics.setCanvas(boilerplate.inputCanvas)
	love.graphics.clear()
	
	love.graphics.setCanvas()
end

function boilerplate.getUnsaved()
	return unsaved
end

function boilerplate.save()
	unsaved = false
end

function boilerplate.quit()
	
end

boilerplate.init(initConfig, arg)
```

TODO: Document all the UI variables

## Notes:

Some config options are sent straight to their respective systems and not to the config module.
