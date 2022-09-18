# LÖVE game boilerplate library
***Check the caveats section!***

TODO: Explanation, how-to-use beyond just a caveats section.

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

function boilerplate.quit()
	
end

boilerplate.init(initConfig, arg)
```

## Caveats

The settings template is merged with the library-owned settings template, *not* replacing any settings found. If you want to add more frame commands you'll have to include the whole lot of library-owned frame commands in your `main.lua` as the frame commands list counts as one whole setting. TODO: Code to merge the two lists.
