require 'src.dependencies'

if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Breakout')

    Fonts = {
        ['small'] = love.graphics.newFont('assets/fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('assets/fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('assets/fonts/font.ttf', 32)
    }
    love.graphics.setFont(Fonts['small'])

    Textures = {
        ['background'] = love.graphics.newImage('assets/images/background.png'),
        ['main'] = love.graphics.newImage('assets/images/breakout.png'),
        ['arrows'] = love.graphics.newImage('assets/images/arrows.png'),
        ['hearts'] = love.graphics.newImage('assets/images/hearts.png'),
        ['particle'] = love.graphics.newImage('assets/images/particle.png'),
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    Sounds = {
        ['paddle-hit'] = love.audio.newSource('assets/sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('assets/sounds/score.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('assets/sounds/wall_hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('assets/sounds/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('assets/sounds/select.wav', 'static'),
        ['no-select'] = love.audio.newSource('assets/sounds/no-select.wav', 'static'),
        ['brick-hit-1'] = love.audio.newSource('assets/sounds/brick-hit-1.wav', 'static'),
        ['brick-hit-2'] = love.audio.newSource('assets/sounds/brick-hit-2.wav', 'static'),
        ['hurt'] = love.audio.newSource('assets/sounds/hurt.wav', 'static'),
        ['victory'] = love.audio.newSource('assets/sounds/victory.wav', 'static'),
        ['recover'] = love.audio.newSource('assets/sounds/recover.wav', 'static'),
        ['high-score'] = love.audio.newSource('assets/sounds/high_score.wav', 'static'),
        ['pause'] = love.audio.newSource('assets/sounds/pause.wav', 'static'),
        ['music'] = love.audio.newSource('assets/sounds/music.wav', 'static')
    }

    Frames = {
        ['paddles'] = GenerateQuadsPaddles(Textures['main']),
        ['balls'] = GenerateQuadsBalls(Textures['main']),
        ['bricks'] = GenerateQuadBricks(Textures['main']),
        ['hearts'] = GenerateQuads(Textures['hearts'], 10, 9)
    }

    gStateMachine = StateMachine {
        ['start'] = function () return StartState() end,
        ['play'] = function () return PlayState() end,
        ['serve'] = function () return ServeState() end,
        ['game-over'] = function () return GameOverState() end,
        ['victory'] = function () return VictoryState() end,
        ['high-scores'] = function () return HighScoreState() end,
        ['enter-high-score'] = function () return EnterHighScoreState() end
    }

    gStateMachine:change('start')

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    gStateMachine:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.draw()
    push:apply('start')
    background = Textures['background']
    local backgroundWidth = background:getWidth()
    local backgroundHeight = background:getHeight()

    love.graphics.draw(background, 0, 0, 0, VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))

    gStateMachine:render()
    DisplayFPS()
    push:apply('end')
end

function love.quit()
    print("Thanks for playing. Please play again soon!")
end

function love.focus(f)
    if f then
      print("Window is focused.")
    else
      print("Window is not focused.")
    end
end