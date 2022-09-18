local path = (...):gsub('%.init$', '')

local settings = require(path .. ".settings")
local commands = require(path .. ".commands")
local input = require(path .. ".input")

local boilerplate = {}

boilerplate.settingsTypes = settings("getTypes")

function boilerplate.remakeWindow()
	local width, height
	if boilerplate.outputCanvas then
		width = boilerplate.outputCanvas:getWidth() * settings.graphics.scale
		height = boilerplate.outputCanvas:getHeight() * settings.graphics.scale
	else
		width = boilerplate.outputCanvasWidth * settings.graphics.scale
		height = boilerplate.outputCanvasHeight * settings.graphics.scale
	end
	love.window.setMode(width, height, {
		vsync = settings.graphics.vsync,
		fullscreen = settings.graphics.fullscreen,
		borderless = settings.graphics.fullscreen and settings.graphics.borderlessFullscreen,
		display = settings.graphics.display
	})
end

function boilerplate.init(initConfig, arg)
	love.graphics.setDefaultFilter("nearest", "nearest")
	
	-- TODO: Make a table for all the input options and verify their presence, perhaps even validate them
	
	boilerplate.outputCanvasWidth, boilerplate.outputCanvasHeight = initConfig.outputCanvasWidth, initConfig.outputCanvasHeight
	
	-- Merge library-owned frame commands into frameCommands
	
	local frameCommands = initConfig.frameCommands
	
	frameCommands.pause = frameCommands.pause or "onRelease"
	
	frameCommands.toggleMouseGrab = frameCommands.toggleMouseGrab or "onRelease"
	frameCommands.takeScreenshot = frameCommands.takeScreenshot or "onRelease"
	frameCommands.toggleInfo = frameCommands.toggleInfo or "onRelease"
	frameCommands.previousDisplay = frameCommands.previousDisplay or "onRelease"
	frameCommands.nextDisplay = frameCommands.nextDisplay or "onRelease"
	frameCommands.scaleDown = frameCommands.scaleDown or "onRelease"
	frameCommands.scaleUp = frameCommands.scaleUp or "onRelease"
	frameCommands.toggleFullscreen = frameCommands.toggleFullscreen or "onRelease"
	
	frameCommands.uiPrimary = frameCommands.uiPrimary or "whileDown"
	frameCommands.uiSecondary = frameCommands.uiSecondary or "whileDown"
	frameCommands.uiModifier = frameCommands.uiModifier or "whileDown"
	
	-- Merge library-owned settings into settingsUiLayout
	
	-- Merge library-owned settings into settingsTemplate
	
	local settingsTypes = boilerplate.settingsTypes
	local settingsTemplate = initConfig.settingsTemplate
	
	settingsTemplate.graphics = settingsTemplate.graphics or {}
	settingsTemplate.graphics.fullscreen = settingsTemplate.graphics.fullscreen or settingsTypes.boolean(false)
	settingsTemplate.graphics.interpolation = settingsTemplate.graphics.interpolation or settingsTypes.boolean(true)
	settingsTemplate.graphics.scale = settingsTemplate.graphics.scale or settingsTypes.natural(2)
	settingsTemplate.graphics.display = settingsTemplate.graphics.display or settingsTypes.natural(1)
	settingsTemplate.graphics.maxTicksPerFrame = settingsTemplate.graphics.maxTicksPerFrame or settingsTypes.natural(4)
	settingsTemplate.graphics.vsync = settingsTemplate.graphics.vsync or settingsTypes.boolean(true)
	
	settingsTemplate.mouse = settingsTemplate.mouse or {}
	settingsTemplate.mouse.divideByScale = settingsTypes.boolean(true)
	settingsTemplate.mouse.xSensitivity = settingsTypes.number(1)
	settingsTemplate.mouse.ySensitivity = settingsTypes.number(1)
	settingsTemplate.mouse.cursorColour = settingsTypes.rgba(1, 1, 1, 1)
	
	settingsTemplate.useScancodesForCommands = settingsTemplate.useScancodesForCommands or settingsTypes.boolean(true)
	
	settingsTemplate.frameCommands = settingsTemplate.frameCommands or settingsTypes.commands("frame", {})
	local frameCommandsSettingDefaults = settingsTemplate.frameCommands(nil) -- HACK: Get defaults by calling with settingsTemplate.frameCommands with nil
	for commandName, inputType in pairs({
		pause = "escape",
		
		toggleMouseGrab = "f1",
		takeScreenshot = "f2",
		toggleInfo = "f3",
		
		previousDisplay = "f7",
		nextDisplay = "f8",
		scaleDown = "f9",
		scaleUp = "f10",
		toggleFullscreen = "f11",
		
		uiPrimary = 1,
		uiSecondary = 2,
		uiModifier = "lalt"
	}) do
		frameCommandsSettingDefaults[commandName] = frameCommandsSettingDefaults[commandName] or inputType
	end
	
	settings("configure", initConfig.settingsUiLayout, initConfig.settingsTemplate)
	
	commands.frameCommands = initConfig.frameCommands
	commands.fixedCommands = initConfig.fixedCommands
	
	function love.run()
		love.load(love.arg.parseGameArguments(arg), arg)
		local lag = initConfig.fixedUpdateTickLength
		local updatesSinceLastDraw, lastLerp = 0, 1
		love.timer.step()
		
		return function()
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do -- Events
				if name == "quit" then
					if not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
			
			do -- Update
				local delta = love.timer.step()
				lag = math.min(lag + delta, initConfig.fixedUpdateTickLength * settings.graphics.maxTicksPerFrame)
				local frames = math.floor(lag / initConfig.fixedUpdateTickLength)
				lag = lag % initConfig.fixedUpdateTickLength
				love.update(dt)
				if not paused then
					local start = love.timer.getTime()
					for _=1, frames do
						updatesSinceLastDraw = updatesSinceLastDraw + 1
						love.fixedUpdate(initConfig.fixedUpdateTickLength)
					end
				end
			end
			
			if love.graphics.isActive() then -- Rendering
				love.graphics.origin()
				love.graphics.clear(love.graphics.getBackgroundColor())
				
				local lerp = lag / initConfig.fixedUpdateTickLength
				deltaDrawTime = ((lerp + updatesSinceLastDraw) - lastLerp) * initConfig.fixedUpdateTickLength
				love.draw(lerp, deltaDrawTime)
				updatesSinceLastDraw, lastLerp = 0, lerp
				
				love.graphics.present()
			end
			
			love.timer.sleep(0.001)
		end
	end
	
	function love.load(arg, unfilteredArg)
		settings("load")
		settings("apply")
		settings("save")
		boilerplate.outputCanvas = love.graphics.newCanvas(boilerplate.outputCanvasWidth, boilerplate.outputCanvasHeight)
		input.clearRawCommands()
		input.clearFixedCommandsList()
		if boilerplate.load then
			boilerplate.load(arg, unfilteredArg)
		end
	end
	
	function love.update(dt)
		if input.didFrameCommand("toggleMouseGrab") then
			love.mouse.setRelativeMode(not love.mouse.getRelativeMode())
		end
		
		if input.didFrameCommand("takeScreenshot") then
			-- If uiModifier is held then takeScreenshot will include HUD et cetera.
			takeScreenshot(input.didFrameCommand("uiModifier") and contentCanvas or scene.outputCanvas)
		end
		
		-- if not ui.current or ui.current.type ~= "settings" then
			if input.didFrameCommand("toggleInfo") then
				settings.graphics.showPerformance = not settings.graphics.showPerformance
				settings("save")
			end
			
			if input.didFrameCommand("previousDisplay") and love.window.getDisplayCount() > 1 then
				settings.graphics.display = (settings.graphics.display - 2) % love.window.getDisplayCount() + 1
				settings("apply") -- TODO: Test thingy... y'know, "press enter to save or wait 5 seconds to revert"
				settings("save")
			end
			
			if input.didFrameCommand("nextDisplay") and love.window.getDisplayCount() > 1 then
				settings.graphics.display = (settings.graphics.display) % love.window.getDisplayCount() + 1
				settings("apply")
				settings("save")
			end
			
			if input.didFrameCommand("scaleDown") and settings.graphics.scale > 1 then
				settings.graphics.scale = settings.graphics.scale - 1
				settings("apply")
				settings("save")
			end
			
			if input.didFrameCommand("scaleUp") then
				settings.graphics.scale = settings.graphics.scale + 1
				settings("apply")
				settings("save")
			end
			
			if input.didFrameCommand("toggleFullscreen") then
				settings.graphics.fullscreen = not settings.graphics.fullscreen
				settings("apply")
				settings("save")
			end
		-- end
		
		if boilerplate.update then
			boilerplate.update(dt)
		end
		
		input.stepRawCommands(--[=[paused()]=])
	end
	
	function love.fixedUpdate(dt)
		if boilerplate.fixedUpdate then
			boilerplate.fixedUpdate(dt)
		end
		
		input.clearFixedCommandsList()
	end
	
	function love.draw(lerp, dt)
		assert(boilerplate.outputCanvas:getWidth() == boilerplate.outputCanvasWidth)
		assert(boilerplate.outputCanvas:getHeight() == boilerplate.outputCanvasHeight)
		if boilerplate.draw then
			boilerplate.draw(lerp, dt)
		end
		love.graphics.draw(boilerplate.outputCanvas,
			love.graphics.getWidth() / 2 - (boilerplate.outputCanvasWidth * settings.graphics.scale) / 2, -- topLeftX == centreX - width / 2
			love.graphics.getHeight() / 2 - (boilerplate.outputCanvasHeight * settings.graphics.scale) / 2,
			0, settings.graphics.scale
		)
	end
	
	function love.quit()
		-- TODO: Test
		return boilerplate.quit and boilerplate.quit()
	end
end

return boilerplate
