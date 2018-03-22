MOVE_NONE = 0
MOVE_NORTH = 1
MOVE_SOUTH = 2
MOVE_WEST = 3
MOVE_EAST = 4

WIDTH = 8
HEIGHT = 6

TILE_SIZE = 64
PADDING = 2

function love.load()
  Object = require "classic"
  
  tiles = {}
  
  for i = 1, HEIGHT do
    tiles[i] = {}
    for j = 1, WIDTH do
      tiles[i][j] = { type = 0, x = j, y = i, tx = j, ty = i }
    end
  end
  
  tiles[2][3] = {type = 1, x = 3, y = 2, tx = 3, ty = 2}
  tiles[4][3] = {type = 1, x = 3, y = 4, tx = 3, ty = 4}
  tiles[4][5] = {type = 1, x = 5, y = 4, tx = 5, ty = 4}
  
  moving = MOVE_NONE
  
  love.window.setMode(
    TILE_SIZE * WIDTH + 2 * PADDING, 
    TILE_SIZE * HEIGHT+ 2 * PADDING,
    {})
end

function love.update(dt)
  if moving ~= MOVE_NONE then
    next = MOVE_NONE
    for i = 1, HEIGHT do
      for j = 1, WIDTH do
        t = tiles [i][j]
        if t.type == 1 then
          if moving == MOVE_SOUTH then
            t.y = t.y + dt * 5
            if t.y > t.ty then
              t.y = t.ty
            else
              next = MOVE_SOUTH
            end
          elseif moving == MOVE_NORTH then
            t.y = t.y - dt * 5
            if t.y < t.ty then
              t.y = t.ty
            else
              next = MOVE_NORTH
            end
          elseif moving == MOVE_WEST then
            t.x = t.x - dt * 5
            if t.x < t.tx then
              t.x = t.tx
            else
              next = MOVE_WEST
            end
          elseif moving == MOVE_EAST then
            t.x = t.x + dt * 5
            if t.x > t.tx then
              t.x = t.tx
            else
              next = MOVE_EAST
            end
          end
        end
      end
    end
    moving = next
    if next == MOVE_NONE then
      ntiles = {}
      
      for i = 1, HEIGHT do
        ntiles[i] = {}
        for j = 1, WIDTH do
          ntiles[i][j] = { type = 0, x = j, y = i, tx = j, ty = i }
        end
      end
      
      for i = 1, HEIGHT do
        for j = 1, WIDTH do
          t = tiles[i][j]
          if t.type > 0 then
            ntiles[t.y][t.x] = t
            print ("in: " ..t.x .. ":" .. t.y .. " -> " .. t.x .. ":" .. t.y)
          end
        end
      end
      
      tiles = ntiles
    end
  end
end

function love.keypressed(key, scancode, isrepeat)
  if moving == MOVE_NONE then    
    if key == 's' then
      moving = MOVE_SOUTH
      for j = 1, WIDTH do
        bottom = 0
        for i = HEIGHT, 1, -1 do
          t = tiles[i][j]
          if bottom == 0 and t.type == 0 then
            bottom = i
          elseif bottom > 0 and t.type == 1 then
            t.ty = bottom
            bottom = bottom - 1
          end
        end
      end
    elseif key == 'w' then
      moving = MOVE_NORTH
      for j = 1, WIDTH do
        top = 0
        for i = 1, HEIGHT do
          t = tiles[i][j]
          if top == 0 and t.type == 0 then
            top = i
          elseif top > 0 and t.type == 1 then
            t.ty = top
            top = top + 1
            print("now: " .. t.x .. ":" .. t.y .. " to " .. t.tx .. ":" .. t.ty)
          end
        end
      end
    elseif key == 'a' then
      moving = MOVE_WEST
      for i = 1, HEIGHT do
        left = 0
        for j = 1, WIDTH do
          t = tiles[i][j]
          if left == 0 and t.type == 0 then
            left = j
          elseif left > 0 and t.type == 1 then
            t.tx = left
            left = left + 1
          end
        end
      end      
    elseif key == 'd' then
      moving = MOVE_EAST
      for i = 1, HEIGHT do
        right = 0
        for j = WIDTH, 1, -1 do
          t = tiles[i][j]
          if right == 0 and t.type == 0 then
            right = j
          elseif right > 0 and t.type == 1 then
            t.tx = right
            right = right - 1
          end
        end
      end      
    end
  end
end

function love.draw()
  love.graphics.rectangle("line", PADDING, PADDING, TILE_SIZE * WIDTH, TILE_SIZE * HEIGHT)
  for i = 1, HEIGHT do
    for j = 1, WIDTH do
      t = tiles[i][j]
      if t.type == 1 then
        love.graphics.circle("fill", t.x * TILE_SIZE - TILE_SIZE / 2 + PADDING, t.y * TILE_SIZE - TILE_SIZE / 2 + PADDING, 32)
      end      
    end
  end
end