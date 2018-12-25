require_relative "./model/lane.rb"
require_relative "./model/sheet.rb"
require_relative "./model/state.rb"
require_relative "./func/permutation.rb"
require_relative "./func/sponge.rb"
require_relative "./func/util.rb"

module Keccak
  class << self
    # keccakのパラメータは、contextと呼ばれる連想配列にまとめて扱う。
    # context = { bitrate:<ブロックサイズ>, capacity:<キャパシティ>, output_size:<出力長>, suffix:<メッセージ接尾辞> }
    #
    # suffixは、SHA3シリーズで指定されており、メッセージはその後ろに指定の数ビットを差し込んで扱われる。必要なければ空配列又は未指定でよい
    def check_context( context )
      # 必要不可欠なパラメータが無い場合はエラー
      if context[:bitrate].nil? || context[:capacity].nil? || context[:output_size].nil? then
        raise ArgumentError,"necessary parameter is missing [bitrate,capacity,output_size,(suffix)]"
      end

      # バイト単位でしか処理できないので、bitrate(block size)は8の倍数でなくてはならない
      raise ArgumentError,"bitrate must be multiples of 8" unless (context[:bitrate]%8).equal?(0)

      # state sizeは、bitrate+capacityできまる。ここから、lane sizeを出して、[1,2,4,8,16,32,64]のいずれかにならなければエラー
      state_size = context[:bitrate] + context[:capacity]
      lane_size  = state_size / 25
      raise ArgumentError, "illegal lane size [1,2,4,8,16,32,64]" unless [1,2,4,8,16,32,64].include?(lane_size)

      # 出力長はバイト単位でしか処理できないので、8の倍数でなくてはならない
      raise ArgumentError,"output_size must be multiples of 8" unless (context[:output_size]%8).equal?(0)

      # パラメータは0より上でなくてはならない
      if context[:bitrate] <= 0 || context[:capacity] <= 0 || context[:output_size] <= 0 then
        raise ArgumentError,"must be :bitrate > 0, :capacity > 0, :output_size > 0"
      end

      # suffixがある場合、 0,1 のみを要素に持つ配列でないといけない(bit arrayを表現している)
      unless context[:suffix].nil? then
        context[:suffix].each do |e|
          raise ArgumentError,"illegal suffix (it is not bit array)" unless( e==0 || e==1 )
        end
      end
    end

    # 吸収のステップ。空のstateを生成して、メッセージを吸収させていく。
    #
    # message  : メッセージ byte-string
    # context  : keccakのパラータを格納した連想配列
    # return   : messageを吸収し終わったstateを返す
    def absorb_step( message, context )
      # contextの検査は事前に行うものとする
      # 空のstate (5 * 5 * lane_size の立方体)を生成する
      lane_size = ( context[:bitrate] + context[:capacity] ) / 25
      state = Keccak::State.from_size(lane_size)

      # ブロックサイズ(byte)
      block_size_byte = context[:bitrate] / 8
      # メッセージは block_size_byte 毎にstateに吸収される
      # 全てのメッセージを吸収し終わるまで、 吸収(absorb)->撹拌(permutation) を繰り返す
      loop_count = ( message.size / block_size_byte ) + 1
      loop_count.times do |i|
        # 次に吸収させるビット配列を生成する
        absorbed_msg = message.slice( i * block_size_byte , block_size_byte )
        absorbed_bit_array = Keccak::Util.bytes_to_bit_array( absorbed_msg )
        # 最後の繰り返し時は、suffixとパディングを入れる。パディングは、必ず入る。
        # 今回は8bit単位で処理されることが決まっているので、suffixの追加とパディングはかならず同時に行われる
        if i.equal?( loop_count-1 ) then
          # suffixの追加 (存在する場合)
          absorbed_bit_array += context[:suffix] unless context[:suffix].nil?
          # pad10*1 パディング
          absorbed_bit_array = Keccak::Sponge.msg_padding( absorbed_bit_array , context[:bitrate] )
        end
        # stateにメッセージを1ブロック分吸収させる
        Keccak::Sponge.absorb!( state, absorbed_bit_array )
        Keccak::Permutation.all_rounds!( state )
      end
      # 吸収・撹拌終了
      return state
    end

    # 搾取のステップ。stateの状態を直接変える
    def squeeze_step( state , context )
      # contextの検査は事前に行うものとする
      output_byte_size = context[:output_size] / 8
      block_size_byte = context[:bitrate] / 8

      output_buffer = ""
      while output_buffer.size < output_byte_size do
        squeezed_bit_array = Keccak::Sponge.squeeze( state, context[:bitrate] )
        byte_buffer = Keccak::Util.bit_array_to_bytes( squeezed_bit_array )
        output_buffer += byte_buffer
        Keccak::Permutation.all_rounds!( state )
      end
      # 最後に、長すぎる部分を切り落とす
      return output_buffer.slice(0,output_byte_size)
    end

    def digest( msg_byte, context )
      check_context( context )
      state  = Keccak.absorb_step( msg_byte, context )
      digest = Keccak.squeeze_step( state, context )
      return digest
    end

    def hex_digest( msg_hex, context )
      msg_byte = [msg_hex].pack("H*")
      digest = Keccak.digest( msg_byte, context )
      return digest.unpack("H*")[0]
    end
  end
end

module Digest
  class Keccak224
    @@context = { bitrate:1152, capacity:448, output_size:224 }
    def self.hex_digest( m )
      return Keccak.hex_digest( m , @@context)
    end
  end

  class Keccak256
    @@context = { bitrate:1088, capacity:512, output_size:256 }
    def self.hex_digest( m )
      return Keccak.hex_digest( m , @@context)
    end
  end

  class Keccak384
    @@context = { bitrate:832, capacity:768, output_size:384 }
    def self.hex_digest( m )
      return Keccak.hex_digest( m , @@context)
    end
  end

  class Keccak512
    @@context = { bitrate:576, capacity:1024, output_size:512 }
    def self.hex_digest( m )
      return Keccak.hex_digest( m , @@context)
    end
  end

  class SHA3_224
    @@context = { bitrate:1152, capacity:448, output_size:224, suffix:[0,1] }
    def self.hex_digest( m )
      return Keccak.hex_digest( m , @@context)
    end
  end

  class SHA3_256
    @@context = { bitrate:1088, capacity:512, output_size:256, suffix:[0,1] }
    def self.hex_digest( m )
      return Keccak.hex_digest( m , @@context)
    end
  end

  class SHA3_384
    @@context = { bitrate:832, capacity:768, output_size:384, suffix:[0,1] }
    def self.hex_digest( m )
      return Keccak.hex_digest( m , @@context)
    end
  end

  class SHA3_512
    @@context = { bitrate:576, capacity:1024, output_size:512, suffix:[0,1] }
    def self.hex_digest( m )
      return Keccak.hex_digest( m , @@context)
    end
  end
end
