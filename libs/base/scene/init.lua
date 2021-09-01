local path = ... .. [[/]]
path = path:gsub('libs/', '')

require(path .. 'title')
require(path .. 'map')

Title:run()