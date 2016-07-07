local inspect = require "inspect" --lua cannot print tables by default; instead use inspect()

local HC = require "HC" --collision detection

math.randomseed(os.time())

function gen_monster(class)
    local monster_height=img:getWidth()
    local monster_width =img:getHeight()

    monster={state={class,"normal",1},rect=HC.rectangle(width+monster_width*2,math.random(0,height),monster_width,monster_height),dx=math.random(-1,-5),dy=0}
        
    table.insert(monsters,monster)
end


function merge(...)
    path=""

    for x,obj in ipairs({...}) do
        path=path.."/"..obj
    end

    return path
end

function love.load()
    width=800
    height=600
    
    love.window.setMode(width,height)
    love.graphics.setBackgroundColor(255,255,255)
    
    img=love.graphics.newImage("Images/zombie.png")

    monsters={}
end
    
function love.update()
    if math.random(1,100)==1 then gen_monster("pawn") end

    for x,monster in ipairs(monsters) do
        monsters[x].rect:move(monster.dx,monster.dy)
    end
end
    
function love.draw()
    love.graphics.print("Zombies..",100,100)
    
    for x,monster in ipairs(monsters) do
        local mx,my = monster.rect:bbox()
        love.graphics.draw(img,mx,my)
    end
end