require_relative "./testdata_for_keccak.rb"
require_relative "../src/keccak.rb"

RSpec.describe Keccak do
  # コンテキストの検査関数(block_size,lane_size,etc...)
  describe "ckeck keccak context" do
    context "SHA3-512 context nomal" do
      context = { bitrate:576, capacity:1024, output_size:512, suffix:[0,1] }
      it{ expect{ Keccak.check_context(context) }.not_to raise_error }
    end

    context "error : blocksize (bitrate) % 8 != 0" do
      context = { bitrate:575, capacity:1024, output_size:512, suffix:[] }
      it{ expect{ Keccak.check_context(context) }.to raise_error( ArgumentError , "bitrate must be multiples of 8" ) }
    end

    context "error : lane ((btrate + capacity)/25) size" do
      context = { bitrate:576, capacity:1016, output_size:512, suffix:[] }
      it{ expect{ Keccak.check_context(context) }.to raise_error( ArgumentError , "illegal lane size [1,2,4,8,16,32,64]" ) }
    end

    context "error : output_size % 8 = 0" do
      context = { bitrate:576, capacity:1024, output_size:510, suffix:[] }
      it{ expect{ Keccak.check_context(context) }.to raise_error( ArgumentError , "output_size must be multiples of 8" ) }
    end

    context "error : illegal suffix" do
      context = { bitrate:576, capacity:1024, output_size:512, suffix:[0,3] }
      it{ expect{ Keccak.check_context(context) }.to raise_error( ArgumentError , "illegal suffix (it is not bit array)" ) }
    end
  end

  describe "absorb step" do
    msg_byte = get_msg_byte()
    context  = get_context()
    state = Keccak.absorb_step( msg_byte , context )
    expected = get_state_after_absorb_step()
    it{ expect( state ).to eq expected }
  end

  describe "squeeze step" do
    state = get_state_after_absorb_step()
    context = get_context()
    output  = Keccak.squeeze_step( state, context )
    # stateの状態を検査
    expected_state = get_state_after_squeeze_step()
    it{ expect( state ).to eq expected_state }
    # アウトプットを検査
    expected_digest = get_digest_bytes()
    it{ expect( output ).to eq expected_digest }
  end

  # 上記の2つのステップを通しでやってみる。
  describe "all step" do
    msg_byte = get_msg_byte()
    context  = get_context()
    output = Keccak.digest( msg_byte , context )
    expected = get_digest_bytes()
    it{ expect( output ).to eq expected }
  end
end
