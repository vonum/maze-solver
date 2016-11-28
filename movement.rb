require_relative "searches"

def move_king state, end_point, graph, queue, visited
  (-1..1).each do |x_step|
    (-1..1).each do |y_step|
      next if x_step == 0 && y_step == 0
      child_x = state.x + x_step
      child_y = state.y + y_step
      if validate_position(child_x, child_y)
        state_val = child_x*COLS + child_y
        if validate_state(state_val, child_x, child_y, graph, queue, visited)
            queue << State.new(child_x, child_y, state_val, state.cost + 10,
                                euclidian_distance(child_x, child_y, end_point.x, end_point.y), state)
            puts state_val
        else
            #puts 'to be contiuned (kek)'
            #add code for revalueating state if it is already in queue
        end
      end
    end
  end
end


def move_rook state, end_point, graph, queue, visited
  dir_matrix = [[-1, 0], [1, 0], [0, -1], [0, 1]]
  dir_matrix.each do |dir|
    step = 1
    x_step = dir[0]
    y_step = dir[1]
    while true
      child_x = state.x + x_step*step
      child_y = state.y + y_step*step
      if validate_position(child_x, child_y)
        state_val = child_x*COLS + child_y
        if validate_state(state_val, child_x, child_y, graph, queue, visited)
          queue << State.new(child_x, child_y, state_val, state.cost + 10,
                              euclidian_distance(child_x, child_y, end_point.x, end_point.y), state)
        else
          break
        end
      else
        break
      end
      step += 1
    end
  end
end

def move_bishop


end

def move_knight state, end_point, graph, queue, visited
  dir_matrix = [[-2, -1], [-2, 1], [2, -1], [2, 1], [-1, -2], [1, -2], [-1, 2], [1, 2]]
  dir_matrix.each do |dir|
    x_step = dir[0]
    y_step = dir[1]

    child_x = state.x + x_step
    child_y = state.y + y_step

    if validate_position(child_x, child_y)
      state_val = child_x*COLS + child_y
      if validate_state(state_val, child_x, child_y, graph, queue, visited)
        queue << State.new(child_x, child_y, state_val, state.cost + 10,
                            euclidian_distance(child_x, child_y, end_point.x, end_point.y), state)
      end
    end
  end
end
