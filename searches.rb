require_relative 'state'
require_relative 'state_type'
require_relative 'movement'

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


    if graph[state.x][state.y].type == StateType::TP
      tps.each do |tp|
        if state.x != tp.x && state.y != tp.y
          state_val = tp.x*COLS + tp.y
          if  visited[state_val] == nil && check_queue(queue, state_val)
            queue << State.new(tp.x, tp.y, state_val, state.cost, manhattan_distance(tp.x, tp.y, end_point.x, end_point.y), state)
            puts "added tp #{tp.x}, #{tp.y}"
          end
        end
      end
    end
    # KING
    #move_king(state, end_point, graph, queue, visited)

    # ROOK
    #move_rook(state, end_point, graph, queue, visited)

    # KNIGHT
    #move_knight(state, end_point, graph, queue, visited)

    # BISHOP
    move_bishop(state, end_point, graph, queue, visited)

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

def manhattan_distance(x1, y1, x2, y2)
  return ((x1 - x2) + (y1 - y2)).abs
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

def validate_state state_val, child_x, child_y, graph, queue, visited
  if visited[state_val] == nil && check_queue(queue, state_val) && graph[child_x][child_y].type != StateType::WALL
    return true
  else
    return false
    #puts 'to be contiuned (kek)'
    #add code for revalueating state if it is already in queue
  end
end

def validate_position child_x, child_y
  return true if child_x >= 0  && child_x < ROWS && child_y >= 0 && child_y < COLS
  return false
end
