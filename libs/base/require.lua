local r = require

require = function(path)
	local lib = r('libs/' .. path)
	
	if type(lib) == 'table' then
		if type(lib.init) == 'function' then
			lib.init()
		end
	end
	
	return lib
end

import = r