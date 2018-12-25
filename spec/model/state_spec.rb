require_relative "../../src/model/lane.rb"
require_relative "../../src/model/sheet.rb"
require_relative "../../src/model/state.rb"

def get_init_lanes()
  lane0 = Keccak::Lane.new([1,0,0,0,0,0,0,0])
  lane1 = Keccak::Lane.new([0,1,0,0,0,0,0,0])
  lane2 = Keccak::Lane.new([0,0,1,0,0,0,0,0])
  lane3 = Keccak::Lane.new([0,0,0,1,0,0,0,0])
  lane4 = Keccak::Lane.new([0,0,0,0,1,0,0,0])
  return [lane0,lane1,lane2,lane3,lane4]
end

def get_init_sheets()
  sheets = []
  5.times{ sheets.push( Keccak::Sheet.new(get_init_lanes)) }
  return sheets
end

def get_init_state()
  return Keccak::State.new(get_init_sheets)
end

RSpec.describe Keccak::State do
  subject{ get_init_state }

  describe "compare object ==" do
    context "expect true" do
      it{ expect( subject ).to eq get_init_state }
    end

    context "expect false due to the class" do
      it{ expect( subject ).not_to eq 1  }
    end

    context "expect false due to element comparison" do
      # x=2,y=2のlaneを19rotateしてずらしたstateを生成する
      another_sheets = get_init_sheets
      another_sheets[2].rotate_lane!(2,19)
      # x=2,y=2のlaneを19rotateしてずらしているので一致しなくなることを期待する
      it{ expect( subject ).not_to eq Keccak::State.new( another_sheets )  }
    end
  end

  describe "shift lane" do
    context "plus shift" do
      # x=3,y=3(8%5) のlaneを+15rotateしたstateを生成する
      another_sheets = get_init_sheets
      another_sheets[3].rotate_lane!(8,15)
      expected_state = Keccak::State.new(another_sheets)
      # 同じく、subjectの x=3,y=3(8%5) のlaneを+15rotateして比較する
      before{ subject.rotate_lane!(3,8,15) }
      it{ expect( subject ).to eq expected_state }
    end

    context "minous shift" do
      # x=0,y=2 のlaneを-15rotateしたstateを生成する
      another_sheets = get_init_sheets
      another_sheets[0].rotate_lane!(2,-15)
      expected_state = Keccak::State.new(another_sheets)
      # 同じく、subjectの x=0,y=2 のlaneを-15rotateして比較する
      before{ subject.rotate_lane!(0,2,-15) }
      it{ expect( subject ).to eq expected_state }
    end
  end

  describe "xor lane!" do
    l = Keccak::Lane.new([1,1,1,1,1,1,1,1])
    expected_sheets = get_init_sheets()
    expected_sheets[2].xor_lane!(0,l)
    expected = Keccak::State.new( expected_sheets )

    before{ subject.xor_lane!( 2, 0, l ) }
    it{ expect( subject ).to eq expected }
  end

  describe "pick lane" do
    expected_lane = get_init_lanes[2]
    # x=3,y=2 のlaneをピックアップする
    it{ expect( subject.pick_lane(3,2) ).to eq expected_lane }
  end

  describe "insert lane" do
    # x=2,y=3(13%5) の位置これを差し込んだstateを生成する
    inserted_lane = Keccak::Lane.new([1,1,1,1,1,1,1,1])
    sheets = get_init_sheets
    sheets[2].insert_lane!( 13 , inserted_lane )
    expected_state = Keccak::State.new( sheets )

    # 同じ位置に、同じものを挿し込む
    before{ subject.insert_lane!( 2, 13, inserted_lane ) }
    it{ expect( subject ).to eq expected_state }
  end

  describe "get parity plane" do
    # 0..4までのKeccak::Sheetのparity_laneを配列化する。
    # つまり、
    # [ x=0 のsheetのparity_lane,
    #   x=1 のsheetのparity_lane,
    #   x=2 のsheetのparity_lane,
    #   x=3 のsheetのparity_lane,
    #   x=4 のsheetのparity_lane ]
    # を生成する。
    # この結果はplane(x-z平面)になる
    expected_result = []
    sheets = get_init_sheets
    sheets.each do |sheet|
      parity_lane = sheet.get_parity_lane
      expected_result.push( parity_lane )
    end
    # ひとつずつ取り出して検査する
    expected_result.each_with_index do | expect,i |
      it{ expect( subject.get_parity_plane()[i] ).to eq expect }
    end
  end

  describe "deep copy" do
    init_state = get_init_state
    copied_state = Keccak::State.deep_copy( init_state )
    # コピー側だけrotate_lane!して、init_stateと異なる状態になることを確認する
    copied_state.rotate_lane!(14,22,19)
    it{ expect( init_state ).not_to eq copied_state }
  end
end
