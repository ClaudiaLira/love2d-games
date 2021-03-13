function GenerateTileQuads(atlas)
    local tiles = {}

    local x = 0
    local y = 0

    local counter = 1

    for _ = 1, 9 do
        for _ = 1, 2 do
            tiles[counter] = {}

            for _ = 1, 6 do
                table.insert(tiles[counter], love.graphics.newQuad(x, y, 32 ,32, atlas:getDimensions()))
                x = x + 32
            end

            counter = counter + 1
        end
        y = y + 32
        x = 0
    end

    return tiles
end