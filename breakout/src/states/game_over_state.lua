GameOverState = Class { __includes = BaseState }

function GameOverState:enter(params)
    self.score = params.score
    self.highScores = loadHighScores()
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local isHighScore = false

        local scoreIndex = 11

        for i = 10, 1, -1 do
            local score = self.highScores[i].score or 0
            if self.score > score then
                highScoreIndex = i
                isHighScore = true
            end
        end

        if isHighScore then
            Sounds['high-score']:play()
            gStateMachine:change('enter-high-score', {
                score = self.score,
                scoreIndex = highScoreIndex,
                highScores = self.highScores
            })
        else
            gStateMachine:change('start')
        end
    end
end

function GameOverState:render()
    love.graphics.setFont(Fonts['large'])
    love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(Fonts['medium'])
    love.graphics.printf('Final Score: ' .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter!', 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
end