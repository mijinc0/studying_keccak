# Laneは z軸 に伸びる配列
module Keccak
  class Lane
    ### region static method ###

    # laneのサイズは [1,2,4,8,16,32,64] のいずれか
    def self.check_lane_size( size )
      unless [1,2,4,8,16,32,64].include?( size )
        raise ArgumentError,"lane size must be one of 1,2,4,8,16,32,64 bit"
      end
    end

    # laneの各要素はbitを表現するので 0 or 1 でなけばならない
    def self.check_element( e )
      raise ArgumentError,"lane element must be zero or one" unless( e==0 || e==1 )
    end

    def self.check_elements( array )
      array.each{ |e| check_element( e ) }
    end

    # 空のlaneを作成
    def self.from_size( size )
      check_lane_size(size)
      return Lane.new( Array.new(size){0} )
    end

    # deep copy
    def self.deep_copy( lane )
      return Lane.new( Array.new( lane.to_array ) )
    end

    ### region end ###

    def initialize( array )
      Lane.check_lane_size( array.size )
      Lane.check_elements( array )
      @raw_array = Array.new(array)
    end

    def == (other)
      return false unless self.class.equal?( other.class )
      return true if @raw_array == other.to_array
      return false
    end

    def to_array()
      return @raw_array
    end

    def get_size()
      return @raw_array.size
    end

    # access to element
    # indexは mod( lane.size ) される
    def get( index )
      return @raw_array[index % get_size]
    end

    # mod lane.size でrotateさせる
    # 注意が必要なのが、rubyのArrayに実装されているのとは逆に動く
    # これは、インデックスの増減と合わせるため
    def rotate( amount )
      return Lane.new( @raw_array.rotate(-1 * amount) )
    end

    # < bang method >
    # mod lane.size でrotateさせる
    # 注意が必要なのが、rubyのArrayに実装されているのとは逆に動く
    # これは、インデックスの増減と合わせるため
    def rotate!( amount )
      @raw_array.rotate!( -1 * amount )
    end

    def compare_lane_size( lane )
      raise ArgumentError,"two lanes size must be same" unless get_size == lane.to_array.size
    end

    # return : 引数のlaneを対応するindex同士の論理XORをとった新しいLaneオブジェクト
    def xor_lane( lane )
      compare_lane_size( lane )
      copied_array = Array.new( lane.to_array )
      @raw_array.each_with_index{ |e,i| copied_array[i] ^= e }
      return Lane.new( copied_array )
    end

    # return : 引数のlaneを対応するindex同士の論理ANDをとった新しいLaneオブジェクト
    def and_lane( lane )
      compare_lane_size( lane )
      copied_array = Array.new( lane.to_array )
      @raw_array.each_with_index{ |e,i| copied_array[i] &= e }
      return Lane.new( copied_array )
    end

    # return : 全要素に論理NOTをかけた新しいLaneオブジェクト
    def not_lane()
      result_array = Array.new( get_size ){0}
      @raw_array.each_with_index{ |e,i| result_array[i] = ~e & 1 }
      return Lane.new( result_array )
    end

    # < bang method >
    # 対応するindex同士の論理XORを取った値をこのlaneの要素に変えてしまう破壊的メソッド
    def xor_lane!( lane )
      compare_lane_size( lane )
      lane.to_array.each_with_index{ |e,i| @raw_array[i] ^= e }
    end
  end
end
