push = require 'libs/push'
Class = require 'libs/class'

require 'src/Paddle'
require 'src.Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

SPEED_INCREMENT = 1.03

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Pong LÖVE')
    math.randomseed(os.time())

    smallFont = love.graphics.newFont('resources/font.ttf', 8)
    scoreFont = love.graphics.newFont('resources/font.ttf', 32)
    largeFont = love.graphics.newFont('resources/font.ttf', 16)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('resources/sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('resources/sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('resources/sounds/wall_hit.wav', 'static')
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    player1Score = 0
    player2Score = 0

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 30, 5, 20)

    servingPlayer = 1

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    gameState = 'start'
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end
    player1:update(dt)

    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end
    player2:update(dt)

    if gameState == 'serve' then
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
    elseif gameState == 'play' then
        if ball:collides(player1) then
            ball.dx = -ball.dx * SPEED_INCREMENT
            ball.x = player1.x + player1.width

            if player1.dy ~= 0 then
                ball.dy = ball.dy + player1.dy / 2
            elseif ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:play()
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx * SPEED_INCREMENT
            ball.x = player2.x - ball.width
            if player1.dy ~= 0 then
                ball.dy = ball.dy + player2.dy / 2
            elseif ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:play()
        end

        -- top boundary
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy

            sounds['wall_hit']:play()
        end
        --bottom boundary
        if ball.y > VIRTUAL_HEIGHT - ball.height then
            ball.y = VIRTUAL_HEIGHT - ball.height
            ball.dy = -ball.dy

            sounds['wall_hit']:play()
        end

        -- player 2 scores
        if ball.x < 0 then
            player2Score = player2Score + 1
            servingPlayer = 1

            sounds['score']:play()

            if player2Score == 10 then
                winningPlayer = 2
                gameState = 'gameOver'
            else
                ball:reset()
                gameState = 'serve'
            end
        end

        -- player 1 scores
        if ball.x > VIRTUAL_WIDTH then
            player1Score = player1Score + 1
            servingPlayer = 2

            sounds['score']:play()

            if player1Score == 10 then
                winningPlayer = 1
                gameState = 'gameOver'
            else
                ball:reset()
                gameState = 'serve'
            end
        end
        ball:update(dt)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'gameOver' then
            gameState = 'serve'
            ball:reset()
            player1Score = 0
            player2Score = 0

            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 1)

    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Pong LOVE!', 0, 40, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press ENTER to play!', 0, 60, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. '\'s serve', 0, 40, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press ENTER to serve', 0, 60, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'gameOver' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
    end

    -- scores
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 100, 10)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 80, 10)

    -- players
    player1:render()
    player2:render()


    --ball
    ball:render()

    displayFPS()
    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end