local path = (...):gsub("%.[^%.]+$", "")

local log = {}

function log.out(messageType, message)
	local line = "[" .. os.date("%Y-%m-%d %H:%M:%S") .. "] [" .. messageType .. "] " .. message .. "\n"
	assert(love.filesystem.append("latest.log", line))
	if log.currentLogPath then
		assert(love.filesystem.append(log.currentLogPath, line))
	end
end

function log.start()
	love.filesystem.write("latest.log", "")
	local info = love.filesystem.getInfo("logs")
	if not info then
		assert(love.filesystem.createDirectory("logs"))
	elseif info.type ~= "directory" then
		log.out("Error", "There is already a non-folder item called logs. Rename it or move it to store logs other than latest.log")
		return
	end
	log.currentLogPath = "logs/" .. os.date("%Y-%m-%d %H-%M-%S") .. ".log" -- TODO: Append 1, 2, 3 etc if another file is found with the same name, just like with screenshots
end

function log.info(message)
	log.out("Info", message)
end

function log.error(message)
	log.out("Error", message)
end

function log.fatal(message)
	log.out("Fatal", message)
end

function log.debug(message)
	if require(path .. ".settings").logging.logDebugMessages then -- HACK to avoid circular dependency error
		log.out("Debug", message)
	end
end

function log.trace(message)
	if require(path .. ".settings").logging.logTraceMessages then
		log.out("Trace", message)
	end
end

return log
