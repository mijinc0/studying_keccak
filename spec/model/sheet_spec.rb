require_relative "../../src/model/lane.rb"
require_relative "../../src/model/sheet.rb"

def get_init_lanes()
  lane0 = Keccak::Lane.new([1,0,0,0,0,0,0,0])
  lane1 = Keccak::Lane.new([0,1,0,0,0,0,0,0])
  lane2 = Keccak::Lane.new([0,0,1,0,0,0,0,0])
  lane3 = Keccak::Lane.new([0,0,0,1,0,0,0,0])
  lane4 = Keccak::Lane.new([0,0,0,0,1,0,0,0])
  return [lane0,lane1,lane2,lane3,lane4]
end

def get_init_sheet()
  return Keccak::Sheet.new( get_init_lanes )
end

RSpec.describe Keccak::Sheet do
  subject{ get_init_sheet }

  describe "compare object ==" do
    context "expect true" do
      it{ expect( subject ).to eq get_init_sheet }
    end

    context "expect false due to the class" do
      it{ expect( subject ).not_to eq 1  }
    end

    context "expect false due to element comparison" do
      another_lanes = get_init_lanes
      another_lanes[0].rotate!(1)
      it{ expect( subject ).not_to eq Keccak::Sheet.new( another_lanes )  }
    end
  end

  describe "shift lane" do
    context "plus shift" do
      # index=0 だけシフトしたKeccak::Sheetを生成して期待する結果とする
      another_lanes = get_init_lanes
      another_lanes[0].rotate!(30)
      expected_sheet = Keccak::Sheet.new(another_lanes)

      before{ subject.rotate_lane!(0,30) }
      it{ expect( subject ).to eq expected_sheet }
    end

    context "munous shift" do
      # index=0 だけシフトしたKeccak::Sheetを生成して期待する結果とする
      another_lanes = get_init_lanes
      another_lanes[0].rotate!(-30)
      expected_sheet = Keccak::Sheet.new(another_lanes)

      before{ subject.rotate_lane!(0,-30) }
      it{ expect( subject ).to eq expected_sheet }
    end
  end

  describe "xor lane!" do
    l = Keccak::Lane.new([1,1,1,1,1,1,1,1])
    expected_lanes = get_init_lanes()
    expected_lanes[3].xor_lane!(l)
    expected = Keccak::Sheet.new( expected_lanes )

    before{ subject.xor_lane!( 3 , l ) }
    it{ expect( subject ).to eq expected }
  end

  describe "pick lane" do
    another_lanes = get_init_lanes
    expected_lane = another_lanes[18 % another_lanes.size]
    it{ expect( subject.pick_lane(18) ).to eq expected_lane }
  end

  describe "insert lane" do
    # これを差し込んだKeccak::Sheetを生成する
    inserted_lane = Keccak::Lane.new([1,1,1,1,1,1,1,1])
    another_lanes = get_init_lanes
    another_lanes[63 % another_lanes.size] = inserted_lane
    expected_sheet = Keccak::Sheet.new(another_lanes)

    before{ subject.insert_lane!( 63 , inserted_lane ) }
    it{ expect( subject ).to eq expected_sheet }
  end

  # パリティ => 全てのlaneのxor総計
  describe "get parity lane" do
    another_sheet = get_init_sheet
    # ここに、次々に xor_lane! していく
    expected_lane = another_sheet.pick_lane(0)
    for i in 1..4 do
      expected_lane.xor_lane!(another_sheet.pick_lane(i))
    end
    it{ expect( subject.get_parity_lane() ).to eq expected_lane }
  end

  describe "deep_copy" do
    init_sheet = get_init_sheet
    copied_sheet = Keccak::Sheet.deep_copy( init_sheet )
    # コピー側だけrotate_lane!して、init_sheetと異なる状態になることを確認する
    copied_sheet.rotate_lane!(2,6)
    it{ expect( init_sheet ).not_to eq copied_sheet }
  end
end
