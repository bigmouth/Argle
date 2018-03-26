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
TILE_WALL = 1
TILE_BALL_1 = 2
TILE_BALL_2 = 3

tiles = {}
grid = {
  balls_1 = {{3, 2}, {5, 4}},
  balls_2 = {{5, 2}, {3, 4}},
  walls = {{2, 2}, {2, 5}, {7, 2}, {7, 5}} }

key_move = { s = MOVE_SOUTH, w = MOVE_NORTH, a = MOVE_WEST, d = MOVE_EAST }

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

  for _, i in ipairs(grid.balls_1) do
    makeTile(i[1], i[2], TILE_BALL_1)
  end

  for _, i in ipairs(grid.balls_2) do
    makeTile(i[1], i[2], TILE_BALL_2)
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
        if t.type > TILE_WALL then
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
          end
        end
      end

      tiles = ntiles
    end
  end
end

function moveall(direction)
  if direction == MOVE_SOUTH then
    for j = 1, WIDTH do
      target = 0
      for i = HEIGHT, 1, -1 do
        t = tiles[i][j]
        if target == 0 and t.type == TILE_NONE then
          target = i
        elseif target > 0 and t.type > TILE_WALL then
          t.ty = target
          target = target - 1
        elseif t.type == TILE_WALL then
          target = 0
        end
      end
    end
  elseif direction == MOVE_NORTH then
    for j = 1, WIDTH do
      target = 0
      for i = 1, HEIGHT do
        t = tiles[i][j]
        if target == 0 and t.type == TILE_NONE then
          target = i
        elseif target > 0 and t.type > TILE_WALL then
          t.ty = target
          target = target + 1
        elseif t.type == TILE_WALL then
          target = 0
        end
      end
    end
  elseif direction == MOVE_WEST then
    for i = 1, HEIGHT do
      left = 0
      for j = 1, WIDTH do
        t = tiles[i][j]
        if left == 0 and t.type == TILE_NONE then
          left = j
        elseif left > 0 and t.type > TILE_WALL then
          t.tx = left
          left = left + 1
        elseif t.type == TILE_WALL then
          left = 0
        end
      end
    end
  elseif direction == MOVE_EAST then
    for i = 1, HEIGHT do
      right = 0
      for j = WIDTH, 1, -1 do
        t = tiles[i][j]
        if right == 0 and t.type == TILE_NONE then
          right = j
        elseif right > 0 and t.type > TILE_WALL then
          t.tx = right
          right = right - 1
        elseif t.type == TILE_WALL then
          right = 0
        end
      end
    end
  end
end

function love.keypressed(key, scancode, isrepeat)
  if moving == MOVE_NONE then
    moving = key_move[key] or MOVE_NONE
    moveall(moving)
  end
end

function love.draw()
  love.graphics.rectangle("line", PADDING, PADDING, TILE_SIZE * WIDTH, TILE_SIZE * HEIGHT)
  for i = 1, HEIGHT do
    for j = 1, WIDTH do
      t = tiles[i][j]
      if t.type == TILE_BALL_1 then
        love.graphics.circle("fill", t.x * TILE_SIZE - TILE_SIZE / 2 + PADDING, t.y * TILE_SIZE - TILE_SIZE / 2 + PADDING, TILE_SIZE / 2)
      elseif t.type == TILE_BALL_2 then
        love.graphics.circle("line", t.x * TILE_SIZE - TILE_SIZE / 2 + PADDING, t.y * TILE_SIZE - TILE_SIZE / 2 + PADDING, TILE_SIZE / 2)
      elseif t.type == TILE_WALL then
        love.graphics.rectangle("fill", t.x * TILE_SIZE - TILE_SIZE + PADDING, t.y * TILE_SIZE - TILE_SIZE + PADDING, TILE_SIZE, TILE_SIZE)
      end
    end
  end
end
