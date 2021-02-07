Pipe = Class()

local PIPE_IMAGE = love.graphics.newImage('resources/sprites/pipe.png')
PIPE_SPEED = 60
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

function Pipe:init(orientation, x, y)
    self.x = x
    self.y = y
    self.orientation = orientation
    self.width = PIPE_IMAGE:getWidth()
end

function Pipe:render()
    love.graphics.draw(
        PIPE_IMAGE,
        self.x,
        self.orientation == 'bottom' and self.y or self.y + PIPE_HEIGHT,
        0,
        1,
        self.orientation == 'bottom' and 1 or -1
    )
end