module Keccak
  module Util
    class << self
      # 0と1 のみを要素として持つ配列(bitの配列を表現しているもの)をbyte-stringに変換する
      def bit_array_to_bytes( bit_array )
        # 配列の要素は1か0でないとだめ
        bit_array.each do |bit|
          raise ArgumentError,"it is not bit array" unless bit==0 || bit==1
        end
        # 1byte(8bit)単位でないとこの関数は動かせない
        raise ArgumentError,"bit array size must be multiples of 8" unless (bit_array.size % 8).equal?(0)

        bytes = ""
        byte_size = bit_array.size / 8
        for i in 0..byte_size-1 do
          # 8bit毎に配列を取出す
          one_byte_array = bit_array.slice(i*8,8)
          # 取り出した配列をbyte_stringにしてbytesに加える
          byte = [ one_byte_array.join ].pack("b8")
          bytes += byte
        end
        return bytes
      end

      # byte-stringを 0と1 のみを要素として持つ配列(bitの配列を表現しているもの)に変換する
      def bytes_to_bit_array( bytes )
        # stateの容量は最大1600bit(200byte)なので、それより長いデータを 0,1 で構成された
        # 配列に変換する必要はない。なので、一応この関数の上限を設けておく。
        raise ArgumentError,"too big data. max data size = 200byte" if bytes.size > 200
        # bit-stringに変換して、splitで一文字ずつ分ける
        bit_array = bytes.unpack("b*")[0].split("")
        # 配列の要素を一つずつ文字から数字に変換していく
        for i in 0..bit_array.size-1 do
          bit_array[i] = bit_array[i].to_i
        end
        return bit_array
      end
    end
  end
end
