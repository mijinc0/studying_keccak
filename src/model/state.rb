require_relative "./sheet.rb"

module Keccak
  class Keccak::State
    ## region static method ##

    def self.from_size( lane_size )
      sheets = []
      5.times do
        sheets.push( Sheet.from_size(lane_size) )
      end
      return Keccak::State.new( sheets )
    end

    def self.deep_copy( state )
      sheets = []
      for i in 0..4 do
        sheets.push( Sheet.deep_copy( state.to_sheet_array()[i] ) )
      end
      return Keccak::State.new( sheets )
    end

    ## region end ##

    def initialize( sheet_array )
      # stateの幅は5で固定
      raise ArgumentError,"state width must be 5" unless sheet_array.size.equal?(5)
      # 全てのsheetのlane sizeが全て同じでなくてはならない
      for i in 1..4 do
        raise ArgumentError,"all lanes size must be same" unless sheet_array[i-1].get_lane_size.equal?(sheet_array[i].get_lane_size)
      end
      @sheet_array = sheet_array
    end

    def to_sheet_array()
      return @sheet_array
    end

    def == (other)
      return false unless self.class.equal?( other.class )
      # 一枚ずつsheetを取り出して、==マッチャを使って確認していく
      @sheet_array.each_with_index do |sheet,i|
        return false unless sheet == other.to_sheet_array()[i]
      end
      return true
    end

    def get_lane_size()
      return @sheet_array[0].get_lane_size()
    end

    # < bang method >
    # x : rotateさせたいlaneのx座標(0..4)
    # y : rotateさせたいlaneのy座標(0..4)
    # amount : rotateさせたい量
    def rotate_lane!( x , y , amount )
      # 座標は循環させる
      x %= 5
      @sheet_array[x].rotate_lane!(y,amount)
    end

    def xor_lane!( x , y , lane )
      x %= 5
      @sheet_array[x].xor_lane!(y,lane)
    end

    # x : 取り出したいlaneのx座標(0..4)
    # y : 取り出したいlaneのy座標(0..4)
    def pick_lane( x , y )
      # 座標は循環させる
      x %= 5
      return @sheet_array[x].pick_lane(y)
    end

    # < bang method >
    def insert_lane!( x , y , lane )
      # 座標は循環させる
      x %= 5
      @sheet_array[x].insert_lane!(y,lane)
    end

    # 各sheetのparity_laneを取得し、plane(x-z平面)となるデータを生成する
    def get_parity_plane()
      parity_plane = []
      for i in 0..4 do
        parity_plane.push( @sheet_array[i].get_parity_lane() )
      end
      return parity_plane
    end
  end
end
