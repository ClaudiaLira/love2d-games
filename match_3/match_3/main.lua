require 'src.dependencies'

local push = require 'libs.push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

BACKGROUND_SCROLL_SPEED = 80

local backgroundX = 0

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Match 3')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
        canvas = true
    })

    Assets.load()
    STATE_MACHINE = StateMachine {
        ['start'] = function() return StartState() end,
        ['begin-game'] = function() return BeginGameState() end
    }

    STATE_MACHINE:change('start')

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    backgroundX = backgroundX - BACKGROUND_SCROLL_SPEED * dt

    if backgroundX <= -1024 + VIRTUAL_WIDTH - 4 + 51 then
        backgroundX = 0
    end
    STATE_MACHINE:update(dt)
    InputManager.resetKeys()
end

function love.draw()
    push:start()

    love.graphics.draw(Assets.textures['background'], backgroundX, 0)
    STATE_MACHINE:render()
    push:finish()
end