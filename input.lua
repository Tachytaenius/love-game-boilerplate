local path = (...):gsub('%.[^%.]+$', '')

local commands = require(path .. ".commands")
local settings = require(path .. ".settings")

local input = {}

local previousFrameRawCommands, thisFrameRawCommands, fixedCommandsList

local function didCommandBase(name, commandsTable, settingsTable)
	assert(commandsTable[name], name .. " is not a valid command")
	
	local assignee = settingsTable[name]
	if (type(assignee) == "string" and (settings.useScancodes and love.keyboard.isScancodeDown or love.keyboard.isDown)(assignee)) or (type(assignee) == "number" and love.mouse.isGrabbed() and love.mouse.isDown(assignee)) then
		thisFrameRawCommands[name] = true
	end
	
	local deltaPolicy = commandsTable[name]
	if deltaPolicy == "onPress" then
		return thisFrameRawCommands[name] and not previousFrameRawCommands[name]
	elseif deltaPolicy == "onRelease" then
		return not thisFrameRawCommands[name] and previousFrameRawCommands[name]
	elseif deltaPolicy == "whileDown" then
		return thisFrameRawCommands[name]
	else
		error(deltaPolicy .. " is not a valid delta policy")
	end
end

function input.didFrameCommand(name)
	return didCommandBase(name, commands.frameCommands, settings.frameCommands)
end

function input.didFixedCommand(name)
	return fixedCommandsList[name]
end

function input.stepRawCommands(paused)
	if not paused then
		for name, deltaPolicy in pairs(commands.fixedCommands) do
			local didCommandThisFrame = didCommandBase(name, commands.fixedCommands, settings.fixedCommands)
			fixedCommandsList[name] = fixedCommandsList[name] or didCommandThisFrame
		end
	end
	
	previousFrameRawCommands, thisFrameRawCommands = thisFrameRawCommands, {}
end

function input.clearRawCommands()
	previousFrameRawCommands, thisFrameRawCommands = {}, {}
end

function input.clearFixedCommandsList()
	fixedCommandsList = {}
end

return input
