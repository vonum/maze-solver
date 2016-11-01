class State
  attr_accessor :x, :y, :val, :cost, :heuristic, :parent
  def initialize x, y, val, cost, heuristic, parent
    @x = x
    @y = y
    @val = val
    @cost = cost
    @heuristic = heuristic
    @parent = parent
  end
end
