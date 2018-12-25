require_relative "../../src/func/util.rb"

RSpec.describe "Keccak Utils" do
  describe "convert bit-array to bytes" do
    context "nomal" do
      # 0xFC16
      bit_array = [0,0,1,1,1,1,1,1,0,1,1,0,1,0,0,0]
      expected = ["fc16"].pack("H*")
      # little endian
      it{ expect( Keccak::Util.bit_array_to_bytes( bit_array ) ).to eq expected }
    end

    context "error : NOT bit-array" do
      bit_array = [0,0,1,1,1,1,1,1,0,3,1,0,1,0,0,0]
      it{ expect{ Keccak::Util.bit_array_to_bytes( bit_array ).to raise_error( ArgumentError , "it is not bit array" ) } }
    end

    context "error : NOT multiples of 8" do
      bit_array = [0,0,1,1,1,1,1,1,0,1,1,0,1,0,0]
      it{ expect{ Keccak::Util.bit_array_to_bytes( bit_array ).to raise_error( ArgumentError , "bit array size must be multiples of 8" ) } }
    end
  end

  describe "convert bytes to bit-array" do
    context "nomal" do
      bytes = ["ff"*10].pack("H*")
      expected = [1]*8*10
      it{ expect( Keccak::Util.bytes_to_bit_array( bytes ) ).to eq expected }
    end

    # 最大1600bit(200byte)までしか使わないので、それ以上だと警告を出すようにしておく、
    context "error : too big" do
      too_big_data = ["ff"*201].pack( "H*")
      it{ expect{ Keccak::Util.bytes_to_bit_array( too_big_data ).to raise_error( ArgumentError , "too big data. max data size = 200byte" ) } }
    end
  end
end
