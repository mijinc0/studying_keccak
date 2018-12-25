=begin
- mod5としての循環
- プラス、マイナス方向への状態のシフト
- 一列になったデータをstate(5*5*wの立方体)に変換する機能
- 要素へのアクセス

構造は stat[ sheet[ lane[ bit ] * 5 ] * 5 ] とする。
=end

require_relative "../../src/model/lane.rb"

RSpec.describe Keccak::Lane do
  # 1要素1bitで管理する
  # indexを座標と捉える
  let(:original_array){[0,1,1,0,0,0,1,1,1,1,0,0,1,1,1,0]}

  subject{ Keccak::Lane.new( original_array ) }

  describe "error generate Keccak::Lane object" do
    # laneのサイズは [1,2,4,8,16,32,64] のいずれか
    it{ expect{ Keccak::Lane.from_size(0) }.to raise_error( ArgumentError , "lane size must be one of 1,2,4,8,16,32,64 bit" ) }
    # laneの各要素はbitを表現するので 0 or 1 でなけばならない
    it{ expect{ Keccak::Lane.new([0,1,1,0,0,0,1,1,1,2,0,0,1,1,1,0]) }.to raise_error( ArgumentError , "lane element must be zero or one" ) }
  end

  describe "compare object ==" do
    context "expect true" do
      it{ expect( subject ).to eq Keccak::Lane.new(original_array) }
    end

    context "expect false due to the class" do
      it{ expect( subject ).not_to eq 1  }
    end

    context "expect false due to element comparison" do
      it{ expect( subject ).not_to eq Keccak::Lane.new(original_array.rotate(1)) }
    end
  end

  describe "getter" do
    it{ expect( subject.to_array ).to eq original_array }
  end

  describe "access to element" do
    # 指定がlaneサイズより低いインデックスの場合
    context "get(n) n < lane.size" do
      it{ expect( subject.get(10) ).to eq original_array[10] }
    end
    # 指定がlaneサイズ以上のインデックスの場合
    context "get(n) n >= lane.size" do
      # mod(lane.size)して取得することになる
      # 17 mod 16 = 1
      it{ expect( subject.get(17) ).to eq original_array[1] }
    end
  end

  # mod w の世界なので循環することに注意
  describe "shift" do
    context "bang plus shift" do
      before { subject.rotate!(29) }
      it { expect( subject.to_array ).to eq original_array.rotate(-29) }
    end

    context "bang minous shift" do
      before { subject.rotate!(-17) }
      it { expect( subject.to_array ).to eq original_array.rotate(17) }
    end

    context "NOT bang plus shift" do
      it { expect( subject.rotate(29).to_array ).to eq original_array.rotate(-29) }
    end
  end

  describe "lane xor lane" do
    another_array = [0,0,1,1,0,0,1,0,0,1,0,1,1,1,1,0]
    another_lane  = Keccak::Lane.new(another_array)
    let(:expected_array){ Array.new(original_array.size){|i| original_array[i] ^ another_array[i]} }

    it { expect( subject.xor_lane(another_lane).to_array ).to eq expected_array }
  end

  describe "lane xor lane!" do
    another_array = [0,0,1,1,0,0,1,0,0,1,0,1,1,1,1,0]
    another_lane  = Keccak::Lane.new(another_array)
    let(:expected_array){ Array.new(original_array.size){|i| original_array[i] ^ another_array[i]} }

    before{ subject.xor_lane!(another_lane) }
    it { expect( subject.to_array ).to eq expected_array }
  end

  # 論理AND
  describe "lane and lane" do
    another_array = [0,0,1,1,0,0,1,0,0,1,0,1,1,1,1,0]
    another_lane  = Keccak::Lane.new(another_array)
    let(:expected_array){ Array.new(original_array.size){|i| original_array[i] & another_array[i]} }

    it { expect( subject.and_lane(another_lane).to_array ).to eq expected_array }
  end

  # 論理NOT
  describe "lane not" do
    let(:expected_array){ Array.new(original_array.size){|i| ~original_array[i] & 1} }

    it { expect( subject.not_lane().to_array ).to eq expected_array }
  end

  describe "deep copy" do
    lane = Keccak::Lane.new([0,0])
    copied_lane = Keccak::Lane.deep_copy(lane)
    another_array = [1,1]
    another_lane  = Keccak::Lane.new(another_array)
    lane.xor_lane!(another_lane)
    it{ expect( lane.to_array ).not_to eq copied_lane.to_array }
  end
end
