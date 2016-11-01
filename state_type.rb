module StateType
  EMPTY = 0
  WALL = 1
  TP = 2
  FIRE = 3
  ITEM = 4
  START = 5
  GOAL = 6

  def StateType.change_type type
    type += 1
    return 0 if type > 6
    return type
  end
end
