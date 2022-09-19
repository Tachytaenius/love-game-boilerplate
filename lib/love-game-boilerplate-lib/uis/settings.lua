local path = (...):gsub("%.[^%.]+$", ""):gsub("%.uis$", "")

local suit = require(path .. ".lib.suit")
local assets = require(path .. ".assets")
local config = require(path .. ".config")
local ui = require(path .. ".ui")
local settings = require(path .. ".settings")

local types, typeInstanceOrigins, template, uiLayout = settings("meta")

local trueButton, falseButton

local settingsUI = {}

function settingsUI.construct(state)
	trueButton, falseButton = assets.ui.trueButton, assets.ui.falseButton
	state.causesPause = true
	state.changes = {}
end

local function get(state, ...)
	local current = state.changes
	for i = 1, select("#", ...) do
		local key = select(i, ...)
		if current[key] ~= nil then
			current = current[key]
		else
			-- Get from original settings
			local current = settings
			for i = 1, select("#", ...) do
				current = current[select(i, ...)]
			end
			return current
		end
	end
	return current
end

local function set(state, to, ...)
	local current = state.changes
	local len = select("#", ...)
	for i = 1, len - 1 do
		local key = select(i, ...)
		current[key] = current[key] or {}
		current = current[key]
	end
	
	current[select(len, ...)] = to
end

function settingsUI.update(state)
	local x, y = config.canvasSystemWidth / 3, config.canvasSystemHeight / 12
	local w, h = config.canvasSystemWidth / 3, assets.ui.font.value:getHeight() + 3
	local pad = 4
	suit.layout:reset(x, y, pad)
	
	local rectangles = {}
	local function finishRect()
		if #rectangles ~= 0 then
			rectangles[#rectangles][3], rectangles[#rectangles][4] = w + pad * 2, (suit.layout._y + pad) - rectangles[#rectangles][2] + h + pad
		end
	end
	
	if suit.Button("Cancel", suit.layout:row(w/2-pad/2, h)).hit then
		return true, "plainPause"
	end
	if suit.Button("OK", suit.layout:col()).hit then
		local function traverse(currentChanges, currentSettings, currentTemplate)
			for k, v in pairs(currentChanges) do
				if type(currentTemplate[k]) == "table" then
					 -- Another category to traverse
					traverse(v, currentSettings[k], currentTemplate[k])
				else--if type(currentTemplate[k]) == "function"
					-- A setting to change
					currentSettings[k] = v
				end
			end
		end
		traverse(state.changes, settings, template)
		
		settings("apply", suppressRemakeWindow) -- TODO: Define the variable
		settings("save")
		return true, "plainPause"
	end
	
	suit.layout:reset(x, y + h, pad)
	
	for _, category in ipairs(uiLayout) do
		finishRect()
		suit.layout:row(w, h)
		suit.Label(category.title .. ":", {align = "left"}, suit.layout:row(w, h))
		rectangles[#rectangles + 1] = {suit.layout._x - pad, suit.layout._y - pad}
		for _, item in ipairs(category) do
			local settingName = item.name
			local settingState = get(state, unpack(item))
			
			local current = template
			for _, key in ipairs(item) do
				current = current[key]
			end
			assert(type(current) == "function", "Settings UI layout references nonexistent setting")
			local settingType = typeInstanceOrigins[current]
			local x,y,w,h=suit.layout:row(w, h)
			if settingType == types.boolean then
				if suit.ImageButton((settingState and trueButton or falseButton).value, {id = i}, x,y,w,h).hit then
					set(state, not settingState, unpack(item))
				end
				suit.Label(item.name, {align = "right"}, x,y,w,h)
			end
			-- TODO: Implement more settings types
		end
	end
	
	finishRect()
	
	function state.draw()
		for _, rectangle in ipairs(rectangles) do
			love.graphics.rectangle("line", unpack(rectangle))
		end
	end
end

return settingsUI
