require_relative "./lane.rb"

# sheetはy-z平面
module Keccak
  class Sheet
    ## region static method ##

    # laneのサイズを指定して全てが0のSheet作成
    def self.from_size( lane_size )
      lanes = []
      5.times do
        lanes.push( Lane.from_size(lane_size) )
      end
      return Sheet.new( lanes )
    end

    def self.deep_copy( sheet )
      lanes = []
      for y in 0..4 do
        lanes.push( Lane.deep_copy( sheet.pick_lane(y) ) )
      end
      return Sheet.new( lanes )
    end

    ## region end ##

    def initialize( lane_array )
      # sheetの高さは5で固定
      raise ArgumentError,"sheet size must be 5" unless lane_array.size.equal?(5)
      # 全てのlaneが同じ長さでなくてはならない
      for y in 1..4 do
        raise ArgumentError,"all lanes size must be same" unless lane_array[y-1].get_size.equal?(lane_array[y].get_size)
      end
      @lane_array = lane_array
    end

    def == (other)
      return false unless self.class.equal?( other.class )
      # pick_laneで一つずつ取り出して、laneの==で比較
      @lane_array.each_with_index do |lane,y|
        return false unless lane == other.pick_lane(y)
      end
      return true
    end

    def get_lane_size()
      return @lane_array[0].get_size
    end

    # < bang method >
    # y : rotateさせたいlaneのy座標
    # amount : rotateさせたい量
    def rotate_lane!( y , amount )
      # 座標は循環させる
      y %= 5
      @lane_array[y].rotate!(amount)
    end

    def xor_lane!( y , lane )
      y %= 5
      @lane_array[y].xor_lane!( lane )
    end

    def pick_lane( y )
      # 座標は循環させる
      y %= 5
      return @lane_array[y]
    end

    # < bang method >
    def insert_lane!( y , lane )
      # 座標は循環させる
      y %= 5
      @lane_array[y] = lane
    end

    # ビット配列のxorを取っていくと...
    # - その配列の中に1が奇数個あれば1
    # - その配列の中に1が偶数個あれば0
    # が結果となる。これによるデータのチェックをパリティと呼ぶ
    # この関数ではlaneの各要素に対応するパリティを取ったlaneを生成する
    def get_parity_lane()
      # index=0 を初期値とする
      result = Lane.deep_copy(@lane_array[0])
      # index1..4 まで、初期値に重ねてxorしていく
      for y in 1..4 do
        result.xor_lane!( @lane_array[y] )
      end
      return result
    end
  end
end
