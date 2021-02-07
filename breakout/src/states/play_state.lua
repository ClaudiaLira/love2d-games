PlayState = Class { __includes = BaseState }

function PlayState:init()
    self.paddle = Paddle()
    self.paused = false
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            Sounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        Sounds['pause']:play()
        return
    end

    self.paddle:update(dt)

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    self.paddle:render()

    if self.paused then
        love.graphics.setFont(Fonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end