require 'rubygems'
require 'gosu'
require_relative 'graph'
require_relative 'pair'
require_relative 'searches'

WIDTH, HEIGHT = 600, 600
COLS = 5
ROWS = 5
CELL_SIZE = 100

class Game < Gosu::Window

  def initialize
    super ROWS*CELL_SIZE, COLS*CELL_SIZE
    self.caption = "Me Am Smart"
    @font = Gosu::Font.new(20)
    @map = Graph.new(5, 5)
  end

  def draw
    (0..4).each do |row|
      (0..4).each do |col|
        draw_cell col*CELL_SIZE, row*CELL_SIZE, CELL_SIZE, CELL_SIZE, type_color(@map.graph[row][col].type)#Gosu::Color.new(100, 50, 50)
        @font.draw("#{@map.graph[row][col].val}", col*CELL_SIZE, row*CELL_SIZE, 1, 1.0, 1.0, 0xff_ffff00)
      end
    end
    draw_result @map.result
  end

  def update

  end

  def needs_cursor?
    true
  end

  def button_down btn_id
    case btn_id
    when Gosu::KbEscape
      close
    when Gosu::KbR
      @map.reset_map
    when Gosu::MsLeft
      row, col = get_cell_position self.mouse_x, self.mouse_y
      type = StateType::change_type(@map.graph[row][col].type)
      @map.graph[row][col].type = type
    when Gosu::KbEnter
      #puts "#{@map.start_point.x} #{@map.start_point.y} #{@map.end_point.x} #{@map.end_point.y}" if @map.start_point != nil && @map.end_point != nil
      @map.init_map
      result = astar(@map)
      @map.result = result if result != -1
    end
  end

  private
  def draw_cell x, y, w, h, color
    draw_quad x, y, color, x+w, y, color, x+w, y+h, color, x, y+h, color
    draw_border x, y, w, h
  end
  def draw_border x, y, w, h
    draw_line x, y, Gosu::Color::RED, x+w, y, Gosu::Color::RED
    draw_line x+w, y, Gosu::Color::RED, x+w, y+h, Gosu::Color::RED
    draw_line x+h, y+h, Gosu::Color::RED, x, y+h, Gosu::Color::RED
    draw_line x, y+h, Gosu::Color::RED, x, y, Gosu::Color::RED
  end
  def draw_result result
    result.each_with_index do |state, index|
      @font.draw("#{index}", state.y*CELL_SIZE + CELL_SIZE/3, state.x*CELL_SIZE + CELL_SIZE/3, 1, 1.0, 1.0, 0xaa_4ED374)
    end
  end
  def get_cell_position x, y
    x_mod = x % CELL_SIZE
    y_mod = y % CELL_SIZE

    col = (x - x_mod)/CELL_SIZE
    row = (y - y_mod)/CELL_SIZE

    return row, col
  end
  def type_color type
    return Gosu::Color.argb(0xaaafb7aa) if type == StateType::EMPTY
    return Gosu::Color.argb(0xaa371d10) if type == StateType::WALL
    return Gosu::Color.argb(0xaa5a6070) if type == StateType::TP
    return Gosu::Color.argb(0xaaC4410D) if type == StateType::FIRE
    return Gosu::Color.argb(0xaaadd7ef) if type == StateType::ITEM
    return Gosu::Color.argb(0xaa5593cc) if type == StateType::START
    return Gosu::Color.argb(0xaa59d845) if type == StateType::GOAL
  end
end

Game.new.show
