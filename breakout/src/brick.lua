Brick = Class {}

function Brick:init(x, y)
    self.tier = 0
    self.color = 1

    self.x = x
    self.y = y

    self.width = 32
    self.height = 16

    self.inPlay = true
end

function Brick:hit()
    Sounds['brick-hit-2']:play()
    self.inPlay = false
end

function Brick:render()
    if self.inPlay then
        love.graphics.draw(Textures['main'], Frames['bricks'][1 + (self.color - 1) * 4 + self.tier], self.x, self.y)
    end
end