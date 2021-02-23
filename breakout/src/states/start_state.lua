StartState = Class{__includes = BaseState}

local highlighted = 1

function StartState:update(dt)
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        highlighted = highlighted == 1 and 2 or 1
        Sounds['paddle-hit']:play()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        Sounds['confirm']:play()

        if highlighted == 1 then
            gStateMachine:change('serve', {
                paddle = Paddle(PADDLE_SKIN['pink']),
                bricks = LevelMaker.createMap(1),
                health = 3,
                score = 0,
                level = 1
            })
        end
    end
end

function StartState:render()
    love.graphics.setFont(Fonts['large'])
    love.graphics.printf('BREAKOUT', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(Fonts['medium'])

    startText = {{1, 1, 1, 1}, 'START'}
    highScoreText =  {{1, 1, 1, 1}, 'HIGH SCORE'}

    if highlighted == 1 then
        startText[1] = {103/255, 1, 1, 1}
    elseif highlighted == 2 then
        highScoreText = {{103/255, 1, 1, 1}, 'HIGH SCORE'}
    end

    love.graphics.printf(startText, 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(highScoreText, 0, VIRTUAL_HEIGHT / 2 + 90, VIRTUAL_WIDTH, 'center')
end