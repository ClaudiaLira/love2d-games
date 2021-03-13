local inputManager = {}

local keys = {}

function love.keypressed(key)
    keys[key] = true
end

function inputManager.wasPressed(key)
    return keys[key]
end

function inputManager.resetKeys()
    keys = {}
end

return inputManager