PlayState = Class { __includes = BaseState }

function PlayState:init()
    self.paddle = Paddle()
    self.ball = Ball(math.random(7))
    self.bricks = LevelMaker.createMap()

    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)

    self.ball.x = VIRTUAL_WIDTH / 2 - 4
    self.ball.y = VIRTUAL_HEIGHT - 42

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
    self.ball:update(dt)

    if self.ball:collides(self.paddle) then
        self.ball.y = self.paddle.y - self.ball.height
        self.ball.dy = -self.ball.dy

        if self.ball.x < self.paddle.x + self.paddle.width / 2 and self.paddle.dx < 0 then
            self.ball.dx = -(50 + 8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))
        end

        if self.ball.x > self.paddle.x + self.paddle.width / 2 and self.paddle.dx > 0 then 
            self.ball.dx = 50 + 8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x)
        end

        Sounds['paddle-hit']:play()
    end

    for _, brick in pairs(self.bricks) do
        if brick.inPlay and self.ball:collides(brick) then
            brick:hit()

            if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x - self.ball.width
            elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x + brick.width
            elseif self.ball.y < brick.y then
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y - self.ball.height
            else
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y + brick.height
            end
            self.ball.dy = self.ball.dy * 1.02
            break
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()

    for _, brick in pairs(self.bricks) do
        brick:render()
    end

    self.paddle:render()
    self.ball:render()

    if self.paused then
        love.graphics.setFont(Fonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end