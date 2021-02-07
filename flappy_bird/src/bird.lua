Bird = Class()

local GRAVITY = 20
local ANTI_GRAVITY = -5
local OFFSET = 2

BIRD_WIDTH =38
BIRD_HEIGHT = 24

function Bird:init()
    self.image = love.graphics.newImage('resources/sprites/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2

    self.dy = 0
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = ANTI_GRAVITY
    end
    self.y = self.y + self.dy
end

function Bird:collides(pipe)
    if (self.x + OFFSET) + (self.width - 2 * OFFSET) >= pipe.x and self.x + OFFSET <= pipe.x + PIPE_WIDTH then
        if (self.y + OFFSET) + (self.height - 2 * OFFSET) >= pipe.y and self.y + OFFSET <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end