local inspect = require "inspect" --lua cannot print tables by default; instead use inspect()

local HC = require "HC" --collision detection

math.randomseed(os.time())

function gen_monster(class)
    local monster_height=images[class].normal[1]:getWidth()
    local monster_width =images[class].normal[1]:getWidth()

    monster={state={class,"normal"},rect=HC.rectangle(width+pawn_width*2,math.random(0,height),pawn_width,pawn_height),dx=math.random(-1,-5),dy=0}
        
    table.insert(monsters,monster)
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string.ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end

function merge(...)
    path=""

    for x,obj in ipairs({...}) do
        path=path.."/"..obj
    end

    return path
end

function get_states(dir,name)
    local states={}

    if name==nil then name="" end

    for x,obj in ipairs(love.filesystem.getDirectoryItems(merge(dir,name))) do

        print(obj)
        if string.ends(obj,".png") then
            table.insert(states,love.graphics.newImage(merge(dir,name,obj)))
        else
            states[obj]=get_states(merge(dir,name),obj) states[name]=nil

            if string.starts(obj,"loop_") then 
                table.insert(states[obj],0)
                states[name:gsub("%loop_","")]=states[obj]
                states[obj]=nil
            end
        end
    end

    return states
end

function love.load()
    width=800
    height=600
    
    love.window.setMode(width,height)
    love.graphics.setBackgroundColor(255,255,255)
    
    images=get_states("Images")

    print(inspect(images))
    
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
        love.graphics.draw(images[monster.image],mx,my)
    end
end