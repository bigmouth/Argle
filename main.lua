MOVE_NONE = 0
MOVE_NORTH = 1
MOVE_SOUTH = 2
MOVE_WEST = 3
MOVE_EAST = 4

WIDTH = 8
HEIGHT = 6

TILE_SIZE = 64
PADDING = 2

TILE_NONE = 0
TILE_BALL = 1
TILE_WALL = 2

tiles = {}
grid = { balls = {{3, 2}, {3, 4}, {5, 4}}, walls = {{2, 2}, {2, 5}, {7, 2}, {7, 5}} }

function makeTile(x, y, type)
  tiles[y][x] = { type = type, x = x, y = y, tx = x, ty = y }
end

function love.load()
  Object = require "classic"

  for i = 1, HEIGHT do
    tiles[i] = {}
    for j = 1, WIDTH do
      makeTile(j, i, TILE_NONE)
    end
  end

  for _, i in ipairs(grid.balls) do
    print(i[0])
    makeTile(i[1], i[2], TILE_BALL)
  end

  for _, i in ipairs(grid.walls) do
    makeTile(i[1], i[2], TILE_WALL)
  end

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
        if t.type == TILE_BALL then
          if moving == MOVE_SOUTH then
            t.y = t.y + dt * 9
            if t.y > t.ty then
              t.y = t.ty
            else
              next = MOVE_SOUTH
            end
          elseif moving == MOVE_NORTH then
            t.y = t.y - dt * 9
            if t.y < t.ty then
              t.y = t.ty
            else
              next = MOVE_NORTH
            end
          elseif moving == MOVE_WEST then
            t.x = t.x - dt * 9
            if t.x < t.tx then
              t.x = t.tx
            else
              next = MOVE_WEST
            end
          elseif moving == MOVE_EAST then
            t.x = t.x + dt * 9
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
          ntiles[i][j] = { type = TILE_NONE, x = j, y = i, tx = j, ty = i }
        end
      end

      for i = 1, HEIGHT do
        for j = 1, WIDTH do
          t = tiles[i][j]
          if t.type ~= TILE_NONE then
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
          if bottom == 0 and t.type == TILE_NONE then
            bottom = i
          elseif bottom > 0 and t.type == TILE_BALL then
            t.ty = bottom
            bottom = bottom - 1
          elseif t.type == TILE_WALL then
            bottom = 0
          end
        end
      end
    elseif key == 'w' then
      moving = MOVE_NORTH
      for j = 1, WIDTH do
        top = 0
        for i = 1, HEIGHT do
          t = tiles[i][j]
          if top == 0 and t.type == TILE_NONE then
            top = i
          elseif top > 0 and t.type == TILE_BALL then
            t.ty = top
            top = top + 1
          elseif t.type == TILE_WALL then
            top = 0
          end
        end
      end
    elseif key == 'a' then
      moving = MOVE_WEST
      for i = 1, HEIGHT do
        left = 0
        for j = 1, WIDTH do
          t = tiles[i][j]
          if left == 0 and t.type == TILE_NONE then
            left = j
          elseif left > 0 and t.type == TILE_BALL then
            t.tx = left
            left = left + 1
          elseif t.type == TILE_WALL then
            left = 0
          end
        end
      end
    elseif key == 'd' then
      moving = MOVE_EAST
      for i = 1, HEIGHT do
        right = 0
        for j = WIDTH, 1, -1 do
          t = tiles[i][j]
          if right == 0 and t.type == TILE_NONE then
            right = j
          elseif right > 0 and t.type == TILE_BALL then
            t.tx = right
            right = right - 1
          elseif t.type == TILE_WALL then
            right = 0
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
      if t.type == TILE_BALL then
        love.graphics.circle("fill", t.x * TILE_SIZE - TILE_SIZE / 2 + PADDING, t.y * TILE_SIZE - TILE_SIZE / 2 + PADDING, TILE_SIZE / 2)
      elseif t.type == TILE_WALL then
        love.graphics.rectangle("fill", t.x * TILE_SIZE - TILE_SIZE + PADDING, t.y * TILE_SIZE - TILE_SIZE + PADDING, TILE_SIZE, TILE_SIZE)
      end
    end
  end
end
