assets = {}

local imagesPath = 'assets/images/'
local soundsPath = 'assets/sounds/'
local fontsPath = 'assets/fonts/'

function assets.load()
    assets.textures = {
        ['main'] = love.graphics.newImage(imagesPath .. 'match3.png'),
        ['background'] = love.graphics.newImage(imagesPath .. 'background.png')
    }

    assets.sounds = {
        ['music'] = love.audio.newSource(soundsPath .. 'music3.mp3', 'static'),
        ['select'] = love.audio.newSource(soundsPath .. 'select.wav', 'static'),
        ['error'] = love.audio.newSource(soundsPath .. 'error.wav', 'static'),
        ['match'] = love.audio.newSource(soundsPath .. 'match.wav', 'static'),
        ['clock'] = love.audio.newSource(soundsPath .. 'clock.wav', 'static'),
        ['game-over'] = love.audio.newSource(soundsPath .. 'game-over.wav', 'static'),
        ['next-level'] = love.audio.newSource(soundsPath .. 'next-level.wav', 'static')
    }

    assets.frames = {
        ['tiles'] = GenerateTileQuads(assets.textures['main'])
    }

    assets.fonts = {
        ['small'] = love.graphics.newFont(fontsPath .. 'font.ttf', 8),
        ['medium'] = love.graphics.newFont(fontsPath .. 'font.ttf', 16),
        ['large'] = love.graphics.newFont(fontsPath .. 'font.ttf', 32)
    }
end

return assets