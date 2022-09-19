local boilerplate = require("lib.love-game-boilerplate-lib")

local frameCommands = {
	
}

local fixedCommands = {
	
}

local settingsUiLayout = {
	-- TEMP: You have to set up the UI layout for library-owned settings yourself (TODO)
	"Graphics",
	{name = "Fullscreen", "graphics","fullscreen"},
	{name = "Interpolation", "graphics","interpolation"}
}

local settingsTypes = boilerplate.settingsTypes
local settingsTemplate = {
	fixedCommands = settingsTypes.commands("fixed", {
		
	})
}

local uiNames = {
	
}


local assetsConstructors, assetsUtilities = boilerplate.assetsConstructors, boilerplate.assetsUtilities
local assets = {
	ui = {
		font = {load = function(self) self.value = love.graphics.newImageFont("assets/images/ui/font.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.!?$,#@~:;-{}&()<>'%/*0123456789") end},
		cursor = {load = function(self) self.value = love.graphics.newImage("assets/images/ui/cursor.png") end},
		trueButton = {load = function(self) self.value = assetsUtilities.blankImage(0.2, 0.8, 0.2, 1, 18) end},
		falseButton = {load = function(self) self.value = assetsUtilities.blankImage(0.8, 0.2, 0.2, 1, 18) end}
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
	assets = assets,
	suppressQuitWithDoubleQuitEvent = true
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
