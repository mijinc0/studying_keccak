require_relative "../../src/func/sponge.rb"

# **** Padding rule ******
#
# Let j = ( -m - 2 ) mod x
# Return P = 1 || 0^j || 1
#
# ************************
# なので、最小のパディングを "11(2bit)" として、メッセージには必ずパディングが入る。
# 実際には、メッセージは8bit単位で処理されるので、最小のパディングは "10000001" になる。
RSpec.describe "Keccak::SpongeFunctions" do
  # pad10*1
  describe "message padding" do
    # bit length
    let(:block_size){ 64 }

    context "need padding" do
      # bit array
      msg_bit_array = [1,1,0,0,0,1,0,1,0,1,0,1,0,0,0,1,1,1,1,1,0,1,0,1,1,1,0,0,0,1,0,1,0,0,0,1]
      expected = [1,1,0,0,0,1,0,1,0,1,0,1,0,0,0,1,1,1,1,1,0,1,0,1,1,1,0,0,0,1,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1]
      it{ expect( Keccak::Sponge.msg_padding( msg_bit_array , block_size ) ).to eq expected }
    end

    context "if buffer is empty, make block-size-padding" do
      # bit array
      msg_bit_array = []
      expected = [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1]
      it{ expect( Keccak::Sponge.msg_padding( msg_bit_array , block_size ) ).to eq expected }
    end

    context "NOT need padding" do
      # 大きければ何もしない
      msg_bit_array = [1,1,0,0,0,1,0,1,0,1,0,1,0,0,0,1,1,1,1,1,0,1,0,1,1,1,0,0,0,1,0,1,0,0,0,1,1,1,0,0,0,1,0,1,0,1,0,1,0,0,0,1,1,1,1,1,0,1,0,1,1,1,0,0,0,1,0,1,0,0,0,1]
      it{ expect( Keccak::Sponge.msg_padding( msg_bit_array , block_size ) ).to eq msg_bit_array }
    end
  end

  let(:after_absorb_state) do
    x0y0 = [1, 1, 0, 0, 0, 1, 0, 1]; x1y0 = [0, 1, 0, 1, 0, 0, 0, 1]; x2y0 = [1, 1, 1, 1, 0, 1, 0, 1]; x3y0 = [1, 1, 0, 0, 0, 1, 0, 1]; x4y0 = [0, 0, 0, 1, 1, 0, 0, 0]
    x0y1 = [0, 0, 0, 0, 0, 0, 0, 0]; x1y1 = [0, 0, 0, 0, 0, 0, 0, 0]; x2y1 = [0, 0, 0, 0, 0, 0, 0, 1]; x3y1 = [0, 0, 0, 0, 0, 0, 0, 0]; x4y1 = [0, 0, 0, 0, 0, 0, 0, 0]
    x0y2 = [0, 0, 0, 0, 0, 0, 0, 0]; x1y2 = [0, 0, 0, 0, 0, 0, 0, 0]; x2y2 = [0, 0, 0, 0, 0, 0, 0, 0]; x3y2 = [0, 0, 0, 0, 0, 0, 0, 0]; x4y2 = [0, 0, 0, 0, 0, 0, 0, 0]
    x0y3 = [0, 0, 0, 0, 0, 0, 0, 0]; x1y3 = [0, 0, 0, 0, 0, 0, 0, 0]; x2y3 = [0, 0, 0, 0, 0, 0, 0, 0]; x3y3 = [0, 0, 0, 0, 0, 0, 0, 0]; x4y3 = [0, 0, 0, 0, 0, 0, 0, 0]
    x0y4 = [0, 0, 0, 0, 0, 0, 0, 0]; x1y4 = [0, 0, 0, 0, 0, 0, 0, 0]; x2y4 = [0, 0, 0, 0, 0, 0, 0, 0]; x3y4 = [0, 0, 0, 0, 0, 0, 0, 0]; x4y4 = [0, 0, 0, 0, 0, 0, 0, 0]

    struct = [ [x0y0,x0y1,x0y2,x0y3,x0y4] , [x1y0,x1y1,x1y2,x1y3,x1y4] , [x2y0,x2y1,x2y2,x2y3,x2y4] , [x3y0,x3y1,x3y2,x3y3,x3y4] , [x4y0,x4y1,x4y2,x4y3,x4y4]]
    sheets = []
    for sheet in struct do
      lines = []
      for line in sheet do
        lines.push( Keccak::Lane.new(line) )
      end
      sheets.push( Keccak::Sheet.new(lines) )
    end
    return Keccak::State.new( sheets )
  end

  describe "absorb" do
    state = Keccak::State.from_size(8)
    absorbed_bit_array = [1,1,0,0,0,1,0,1,0,1,0,1,0,0,0,1,1,1,1,1,0,1,0,1,1,1,0,0,0,1,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1]

    Keccak::Sponge.absorb!( state , absorbed_bit_array )
    it{ expect( state ).to eq after_absorb_state }
  end

  describe "squeeze" do
    squeeze_size = 64
    expected = [1,1,0,0,0,1,0,1,0,1,0,1,0,0,0,1,1,1,1,1,0,1,0,1,1,1,0,0,0,1,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1]
    it{ expect( Keccak::Sponge.squeeze( after_absorb_state , squeeze_size ) ).to eq expected }
  end
end
