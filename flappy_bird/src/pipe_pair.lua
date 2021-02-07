PipePair = Class()

GAP_LENGTH = 90

function PipePair:init(y)
    self.x = VIRTUAL_WIDTH + 32

    self.y = y

    self.pipes = {
        ['upper'] = Pipe('top', self.x, self.y),
        ['lower'] = Pipe('bottom', self.x, self.y + PIPE_HEIGHT + GAP_LENGTH)
    }

    self.remove = false
    self.scored = false
end

function PipePair:update(dt)
    if self.x < -PIPE_WIDTH then
        self.remove = true
    else
        self.x = self.x - PIPE_SPEED * dt
        -- TODO: ground moves in a different speed from pipe if we fix jitter movement with math.floor
        -- self.x = math.floor(self.x - PIPE_SPEED * dt)

        self.pipes['upper'].x = self.x
        self.pipes['lower'].x = self.x
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end