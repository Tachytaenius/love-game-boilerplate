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

local uiNames = {
	
}

local assetsConstructors, assetsUtilities = boilerplate.assetsConstructors, boilerplate.assetsUtilities
local assets = {
	ui = {
		font = {load = function(self) self.value = love.graphics.newImageFont("assets/images/ui/font.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.!?$,#@~:;-{}&()<>'%/*0123456789") end},
		cursor = {load = function(self) self.value = love.graphics.newImage("assets/images/ui/cursor.png") end}
	}
}

local initConfig = {
	fixedUpdateTickLength = 1 / 24,
	canvasSystemWidth = 480,
	canvasSystemHeight = 270,
	frameCommands = frameCommands,
	fixedCommands = fixedCommands,
	settingsUiLayout = settingsUiLayout,
	settingsTemplate = settingsTemplate,
	uiNames = uiNames,
	uiNamePathPrefix = "uis",
	uiTint = {0.5, 0.5, 0.5},
	assets = assets,
	suppressQuitWithDoubleQuitEvent = true,
	defaultFilterMin = "nearest",
	defaultFilterMag = nil,
	defaultFilterAnisotropy = nil,
	lineStyle = "rough",
	scrollSpeed = 20,
	uiPad = 4,
	uiButtonPad = 2
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
	love.graphics.setCanvas(boilerplate.gameCanvas)
	love.graphics.clear(0, 0, 0, 1)
	-- Draw world
	love.graphics.setCanvas()
	
	love.graphics.setCanvas(boilerplate.hudCanvas)
	love.graphics.clear()
	-- Draw HUD
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
