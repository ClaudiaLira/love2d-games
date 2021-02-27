HighScoreState = Class { __includes = BaseState }

function HighScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        Sounds['wall-hit']:play()

        gStateMachine:change('start')
    end
end

function HighScoreState:render()
    love.graphics.printf('High Scores', Fonts['large'], 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(Fonts['medium'])
    for i = 1, 10 do
        local name = HighScores[i].name or '---'
        local score = HighScores[i].score or '---'

        love.graphics.printf(tostring(i)..'.', VIRTUAL_WIDTH/4, 60 + i * 13, 50, 'left')
        love.graphics.printf(name, VIRTUAL_WIDTH / 4 + 38, 60 + i * 13, 50, 'right')
        love.graphics.printf(tostring(score), VIRTUAL_WIDTH / 2, 60 + i * 13, 100, 'right')
    end

    love.graphics.printf('Press Enter to return to the main menu!', Fonts['small'], 0, VIRTUAL_HEIGHT - 18, VIRTUAL_WIDTH, 'center')
end