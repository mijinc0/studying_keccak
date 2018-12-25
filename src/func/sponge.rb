require_relative "../model/state.rb"

module Keccak
  module Sponge
    class << self
      # **** Padding rule ******
      #
      # Let j = ( -m - 2 ) mod x
      # Return P = 1 || 0^j || 1
      #
      # ************************
      # なので、最小のパディングを "11(2bit)" として、メッセージには必ずパディングが入る。
      # 実際には、メッセージは8bit単位で処理されるので、最小のパディングは "10000001" になる。
      #
      #       data : 要素が0,1のみで構成された配列
      # block_size : bit長
      # return : パディングされた配列　block_sizeが配列サイズより大きい場合、引数の配列をそのまま返す
      def msg_padding( data , block_size )
        # block_sizeが配列サイズより大きい場合、引数の配列をそのまま返す
        return data if data.size >= block_size

        pad_length = (-1 * data.size - 2 ) % block_size
        pad_data = [1] + ( [0]*pad_length ) + [1]

        return data + pad_data
      end

      # ***** absorb rule *********
      # pm[ w( 5y + x ) + z ] = s[ x , y , z ]
      #
      #    pm : padded message
      #     w : lane size
      # x,y,z : point in state
      #
      # [e,g]
      # Let w = 8
      # pm[ 0 ]  = 8( 5*0 + 0 ) + 0 = s[0,0,0]
      # pm[ 28 ] = 8( 5*0 + 3 ) + 4 = s[3,0,4]
      # ***************************
      #
      # 吸収は、要素とのXORによって行う
      # この関数は、第一引数のstateの状態を上書きする
      def absorb!( state , absorbed_bit_array )
        lane_size  = state.get_lane_size()
        state_size = 25 * lane_size
        raise ArgumentError,"absorbed data size is too big" if state_size < absorbed_bit_array.size

        # lane_sizeで割り切れるように吸収対象データをパディングする
        pad_length = ( -1 * absorbed_bit_array.size ) % lane_size
        padded_array = absorbed_bit_array + [0]*pad_length

        # lane size 毎に配列を分割する
        sliced_array = []
        for k in 0..((padded_array.size / lane_size) -1) do
          sliced = padded_array.slice(k * lane_size, lane_size)
          sliced_array.push( sliced )
        end

        # 分割した配列をKeccak::Laneオブジェクトにする
        lanes = []
        for array in sliced_array do
          lanes.push( Keccak::Lane.new(array) )
        end

        # XORにて各レーンを吸収させていく
        lanes.each_with_index do | lane , i |
          x = i % 5
          y = i / 5
          state.xor_lane!( x, y, lane )
        end
      end

      def squeeze( state , squeeze_size )
        lane_size  = state.get_lane_size()
        state_size = 25 * lane_size
        raise ArgumentError,"squeeze_size is too big" if state_size < squeeze_size

        # stateから取り出さなくてはいけないlaneの数を求める
        squeeze_lanes_count = squeeze_size / lane_size
        squeeze_lanes_count += 1 unless squeeze_size % lane_size == 0

        # 搾取
        squeezed_data = []
        for i in 0..squeeze_lanes_count do
          x = i % 5
          y = i / 5
          squeezed_data += Array.new( state.pick_lane(x,y).to_array() )
        end

        return squeezed_data[0..squeeze_size-1]
      end
    end
  end
end
