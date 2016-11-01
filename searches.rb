require_relative 'state'
require_relative 'state_type'

def astar(map)
  graph = map.graph
  start_point = map.start_point
  end_point = map.end_point
  tps = map.teleports

  return -1 if end_point == nil || start_point == nil

  visited = {}
  queue = []
  queue << State.new(start_point.x, start_point.y, start_point.x*COLS + start_point.y, 0, 0, nil) #cost = 0, heuristic = 0, parent = nil

  while queue.size > 0
    state = queue.shift
    visited[state.x*COLS + state.y] = state               #state unique value
    puts "visiting #{state.val} with cost #{state.cost} and heuristic #{state.heuristic}"

    if state.x == end_point.x && state.y == end_point.y
      puts "found node #{state.x}, #{state.y}"
      return path(state)
    end

    # if (state.x > 0 && visited[(state.x-1)*ROWS+state.y] == nil && check_queue(queue, (state.x-1)*ROWS+state.y))
    #   queue << State.new(state.x-1, state.y, (state.x-1)*ROWS + state.y, state.cost+1,
    #                     euclidian_distance(state.x-1, state.y, end_point.x, end_point.y), state) if graph[state.x-1][state.y].type != StateType::WALL
    # end
    # if (state.x < ROWS-1 && visited[(state.x+1)*ROWS+state.y] == nil && check_queue(queue, (state.x+1)*ROWS+state.y))
    #   queue << State.new(state.x+1, state.y, (state.x+1)*ROWS + state.y, state.cost+1,
    #                     euclidian_distance(state.x+1, state.y, end_point.x, end_point.y), state) if graph[state.x+1][state.y].type != StateType::WALL
    # end
    # if (state.y > 0 && visited[state.x*ROWS+state.y-1] == nil && check_queue(queue, state.x*ROWS+state.y-1))
    #   queue << State.new(state.x, state.y-1, state.x*ROWS + state.y - 1, state.cost+1,
    #                     euclidian_distance(state.x, state.y-1, end_point.x, end_point.y), state) if graph[state.x][state.y-1].type != StateType::WALL
    # end
    # if (state.y < COLS-1 && visited[state.x*ROWS+state.y+1] == nil && check_queue(queue, state.x*ROWS+state.y+1))
    #   queue << State.new(state.x, state.y+1, state.x*ROWS + state.y + 1, state.cost+1,
    #                     euclidian_distance(state.x, state.y+1, end_point.x, end_point.y), state) if graph[state.x][state.y+1].type != StateType::WALL
    # end
    # queue.sort! { |first, second| first.cost + first.heuristic <=> second.cost + second.heuristic }

    (-1..1).each do |x_step|
      (-1..1).each do |y_step|
        next if x_step == 0 && y_step == 0

        state_val = (state.x + x_step)*COLS + state.y + y_step
        if state.x + x_step >= 0  && state.x + x_step < ROWS && state.y + y_step >= 0 && state.y + y_step < COLS
          if visited[state_val] == nil && check_queue(queue, state_val) && graph[state.x + x_step][state.y + y_step].type != StateType::WALL
              queue << State.new(state.x + x_step, state.y + y_step, state_val, state.cost + 10,
                                  euclidian_distance(state.x + x_step, state.y + y_step, end_point.x, end_point.y), state)
              puts state_val
          else
              #puts 'to be contiuned (kek)'
          end
        end
      end
    end
    if graph[state.x][state.y].type == StateType::TP
      tps.each do |tp|
        if state.x != tp.x && state.y != tp.y
          state_val = tp.x*COLS + tp.y
          if  visited[state_val] == nil && check_queue(queue, state_val)
            queue << State.new(tp.x, tp.y, state_val, state.cost + 5, euclidian_distance(tp.x, tp.y, end_point.x, end_point.y), state)
          end
        end
      end
    end
    queue.sort! { |first, second| first.cost + first.heuristic <=> second.cost + second.heuristic }

  end
  return -1
end

def path(state)
  path = []
  while state != nil
    path << state
    state = state.parent
  end
  return path.reverse
end

def euclidian_distance(x1, y1, x2, y2)
  return Math.sqrt((x1 - x2)**2 + (y1 - y2)**2)
end

def optimize_queue queue, state
  queue.each do |s|
    if s.val == state.val && s.cost + s.heuristic > state.cost + state.heuristic
      s.cost = state.cost
      s.heuristic = state.heuristic
      s.parent = state.parent
      queue.sort! { |first, second| first.cost + first.heuristic <=> second.cost + second.heuristic }
      return
    end
    queue << state
    queue.sort! { |first, second| first.cost + first.heuristic <=> second.cost + second.heuristic }
  end
end

def check_queue queue, state_val
  return false if queue.any? { |state| state.val == state_val }
  return true
end
