require_relative 'node'
require_relative 'state_type'
require_relative 'pair'

class Graph
  attr_accessor :graph, :rows, :cols, :start_point, :end_point, :result, :teleports

  def initialize rows, cols
    @rows = rows
    @cols = cols
    @result = []
    @teleports = []

    init_graph
    puts @rows, @cols
  end
  
  def init_map
    (0...@rows).each do |row|
      (0...@cols).each do |col|
        if @graph[row][col].type == StateType::START
          @start_point = Pair.new(row, col)
        elsif @graph[row][col].type == StateType::GOAL
          @end_point = Pair.new(row, col)
        elsif @graph[row][col].type == StateType::TP
          @teleports << Pair.new(row, col)
        end
      end
    end
    puts @teleports
  end

  def reset_map
    @start_point = nil
    @end_point = nil
    @teleports = []
    @result = []
    init_graph
  end

  private
  def init_graph
    @graph = []
    (0...@rows).each do |row|
      tmp = Array.new
      (0...@cols).each do |col|
        tmp << Node.new(row*@cols + col, row, col)
      end
      @graph << tmp
    end
  end

end
