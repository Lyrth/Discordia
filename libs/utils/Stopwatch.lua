--[=[@c Stopwatch desc]=]

local hrtime = require('uv').hrtime
local constants = require('constants')
local Time = require('utils/Time')

local format = string.format

local MS_PER_NS = 1 / (constants.NS_PER_US * constants.US_PER_MS)

local Stopwatch, get = require('class')('Stopwatch')

function Stopwatch:__init(stopped)
	local t = hrtime()
	self._initial = t
	self._final = stopped and t or nil
end

function Stopwatch:__tostring()
	return format('Stopwatch: %s ms', self.milliseconds)
end

--[=[
@m name
@p name type
@r type
@d desc
]=]
function Stopwatch:stop()
	if self._final then return end
	self._final = hrtime()
end

--[=[
@m name
@p name type
@r type
@d desc
]=]
function Stopwatch:start()
	if not self._final then return end
	self._initial = self._initial + hrtime() - self._final
	self._final = nil
end

--[=[
@m name
@p name type
@r type
@d desc
]=]
function Stopwatch:reset()
	self._initial = self._final or hrtime()
end

--[=[
@m name
@p name type
@r type
@d desc
]=]
function Stopwatch:getTime()
	return Time(self.milliseconds)
end

--[=[@p milliseconds type desc]=]
function get.milliseconds(self)
	local ns = (self._final or hrtime()) - self._initial
	return ns * MS_PER_NS
end

return Stopwatch
