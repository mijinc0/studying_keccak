# The Keccak-f Permutation function

require_relative "../model/state.rb"

module Keccak
  module Permutation
    class << self
      # Round Constants
      def generate_rc()
        l_rc = [0x0000000000000001, 0x0000000000008082, 0x800000000000808A, 0x8000000080008000, \
                0x000000000000808B, 0x0000000080000001, 0x8000000080008081, 0x8000000000008009, \
                0x000000000000008A, 0x0000000000000088, 0x0000000080008009, 0x000000008000000A, \
                0x000000008000808B, 0x800000000000008B, 0x8000000000008089, 0x8000000000008003, \
                0x8000000000008002, 0x8000000000000080, 0x000000000000800A, 0x800000008000000A, \
                0x8000000080008081, 0x8000000000008080, 0x0000000080000001, 0x8000000080008008]
        rc = []
        # 64bit整数を 0,1 のビットを表現した配列に変換する
        for long in l_rc do
          element = []
          for i in 0..63 do
            element.push( long >> i & 1 )
          end
          rc.push( element )
        end
        return rc
      end

      RC = Permutation.generate_rc()

      # Rotation Offsets
      RO = [[ 0,36, 3,41,18], \
            [ 1,44,10,45, 2], \
            [62, 6,43,15,61], \
            [28,55,25,21,56], \
            [27,20,39, 8,14]]

      def theta!( state )
        # state中の全columnのパリティを取る。取得したパリティはx-z座標に対応するように並べる。
        parity_plane = state.get_parity_plane()
        # state-A の全要素について、自身の座標を[x,y,z]としたとき、
        # A xor parity_plane[x-1,z] xor parity_plane[x+1,z-1]
        # をとる。この時、座標は各平面の長さでmodされる。
        for x in 0..4 do
          for y in 0..4 do
            # A xor parity_plane[x-1,z]
            state.xor_lane!( x, y, parity_plane[ (x-1) % 5 ] )
            # A xor parity_plane[x+1,z-1]
            # z-1は、laneをプラス方向へ1つrotateすることで実現する
            state.xor_lane!( x, y, parity_plane[ (x+1) % 5 ].rotate(1) )
          end
        end
      end

      def rho!( state )
        for x in 0..4 do
          for y in 0..4 do
            state.rotate_lane!( x, y, RO[x][y] )
          end
        end
      end

      def pi!( state )
        # [x,y]のlaneを[y,2x+3y]に差し替えることで状態を回転させる
        copied_state = State.deep_copy(state)
        for x in 0..4 do
          for y in 0..4 do
            state.insert_lane!( y, 2*x+3*y, copied_state.pick_lane(x,y) )
          end
        end
      end

      def chi!( state )
        copied_state = State.deep_copy(state)
        for x in 0..4 do
          for y in 0..4 do
            # 全ての[x,y]について、
            # n = NOT[x+1,y] とする
            n = copied_state.pick_lane(x+1,y).not_lane()
            # a = n and [x+2,y] とする
            a = n.and_lane( copied_state.pick_lane(x+2,y) )
            # [x,y] = [x,y] xor a
            state.xor_lane!( x, y, a )
          end
        end
      end

      def iota!( state , round_count )
        raise ArgumentError,"must be 0 <= round_count <= 23" if round_count<0 || round_count>23
        # RC[round_count] を[x=0,y=0]にxorする。（余る部分は切り捨てる）
        lane_size = state.get_lane_size()
        rc = RC[round_count]
        state.xor_lane!( 0, 0, Lane.new(rc[0..(lane_size-1)]) )
      end

      # Permutationを行うラウンド回数を計算する
      # L = log2( lane_size )
      # round = 12 + 2L
      def calculate_round( state )
        lane_size = state.get_lane_size()
        el = Math.log( lane_size, 2 ).to_i
        return (12 + 2 * el)-1
      end

      def all_rounds!( state )
        round_count = Permutation.calculate_round( state )
        for r in 0..round_count do
          Permutation.theta!( state )
          Permutation.rho!( state )
          Permutation.pi!( state )
          Permutation.chi!( state )
          Permutation.iota!( state, r )
        end
      end
    end
  end
end
