function GenerateQuads(atlas, tileWidth, tileHeight)
    local horizontalCount = atlas:getWidth() / tileWidth
    local verticalCount = atlas:getHeight() / tileHeight

    local tileCount = 1
    local spritesheet = {}

    for y = 0, verticalCount - 1 do
        for x = 0, horizontalCount - 1 do
            spritesheet[tileCount] = love.graphics.newQuad(x * tileWidth, y * tileHeight, tileWidth, tileHeight, atlas:getDimensions())
            tileCount = tileCount + 1
        end
    end

    return spritesheet
end

function table.slice(tbl, first, last, step)
    local sliced = {}

    for i = first or 1, last or #tbl, step or 1 do
      sliced[#sliced+1] = tbl[i]
    end

    return sliced
end

function GenerateQuadsPaddles(atlas)
    local x = 0
    local y = 64

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        quads[counter] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
        counter = counter + 1
        quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16, atlas:getDimensions())
        counter = counter + 1
        quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, atlas:getDimensions())
        counter = counter + 1
        quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16, atlas:getDimensions())
        counter = counter + 1
        
        x = 0
        y = y + 32
    end

    return quads
end