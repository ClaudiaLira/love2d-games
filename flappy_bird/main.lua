push = require('libs.push')
Class = require('libs.class')

require('src.bird')
require('src.pipe')
require('src.pipe_pair')
require('src.state_machine')
require('src.states.base_state')
require('src.states.play_state')
require('src.states.title_state')
require('src.states.score_state')
require('src.states.countdown_state')

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60
local BACKGROUND_LOOPING_POINT = 413

local background = love.graphics.newImage('resources/sprites/background.png')
local backgroundScroll = 0
local backgroundSpeed = 0
local ground = love.graphics.newImage('resources/sprites/ground.png')
local groundScroll = 0
local groundSpeed = 0

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Love2D Bird')

    math.randomseed(os.time())

    smallFont = love.graphics.newFont('resources/fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('resources/fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('resources/fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('resources/fonts/flappy.ttf', 56)

    love.graphics.setFont(flappyFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine{
        ['title'] = function () return TitleState() end,
        ['play'] = function () return PlayState() end,
        ['score'] = function () return ScoreState() end,
        ['countdown'] = function () return CountdownState() end
    }

    gStateMachine:change('title')

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    backgroundSpeed = (backgroundSpeed + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    backgroundScroll = math.floor(backgroundSpeed)

    groundSpeed = (groundSpeed + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
    groundScroll = math.floor(groundSpeed)

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end