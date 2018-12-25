# Deterministic test data for "permutation_spec.
require_relative "../../src/model/state.rb"
require_relative "../../src/model/sheet.rb"
require_relative "../../src/model/lane.rb"

# long値を64bitのLineオブジェクトに変換する
def long_to_lane( long_value )
  bit_array = []
  for i in 0..63 do
    bit_array.push( long_value >> i & 1 )
  end
  return Keccak::Lane.new(bit_array)
end

# [[ long, long, long, long, long ],
#  [ long, long, long, long, long ],
#  [ long, long, long, long, long ],
#  [ long, long, long, long, long ],
#  [ long, long, long, long, long ]]
# で表現されたlanesizeが64bitのstateをKeccak::Stateオブジェクトに変換する
def generate_state_from_array_struct( struct )
  sheets = []
  struct.each do |sheet_array|
    lines = []
    sheet_array.each do |long_value|
      lines.push( long_to_lane( long_value ) )
    end
    sheets.push( Keccak::Sheet.new(lines) )
  end
  return Keccak::State.new( sheets )
end

def get_deterministic_start_state
  # BlockSize => 576 bit
  # 下記のデータは、64bitのlineがlong値(64bit整数)で表現されている
  after_absorb = [[460, 0, 0, 0, 0], \
                  [0, 0, 0, 0, 0], \
                  [0, 0, 0, 0, 0], \
                  [0, 9223372036854775808, 0, 0, 0], \
                  [0, 0, 0, 0, 0]]
  return generate_state_from_array_struct( after_absorb )
end

def get_deterministic_after_theta_state
  after_theta = [[460, 0, 0, 0, 0], \
                 [460, 460, 460, 460, 460], \
                 [1, 1, 1, 1, 1], \
                 [0, 9223372036854775808, 0, 0, 0], \
                 [9223372036854776728, 9223372036854776728, 9223372036854776728, 9223372036854776728, 9223372036854776728]]
  return generate_state_from_array_struct( after_theta )
end

def get_deterministic_after_rho_and_pi_state
  after_rho_and_pi = [[460, 0, 920, 123547418624, 4611686018427387904], \
                      [8092405580431360, 965214208, 64, 0, 18014398509481984], \
                      [8796093022208, 0, 0, 471040, 506050226683904], \
                      [0, 16184811160862720, 235648, 32768, 0], \
                      [15081472, 2305843009213693952, 0, 0, 1840]]
  return generate_state_from_array_struct( after_rho_and_pi )
end

def get_deterministic_after_chi_state
  after_chi = [[8796093022668, 0, 920, 123547889664, 4612192068654071808], \
               [8092405580431360, 16184812126076928, 235712, 32768, 18014398509481984], \
               [8796108103680, 2305843009213693952, 0, 471040, 506050226685744], \
               [460, 16184811160862720, 236312, 123547451392, 4611686018427387904], \
               [8092405595512832, 2305843010178908160, 64, 0, 18014398509483824]]
  return generate_state_from_array_struct( after_chi )
end

def get_deterministic_after_iota_state
  after_iota = [[8796093022669, 0, 920, 123547889664, 4612192068654071808], \
                [8092405580431360, 16184812126076928, 235712, 32768, 18014398509481984], \
                [8796108103680, 2305843009213693952, 0, 471040, 506050226685744], \
                [460, 16184811160862720, 236312, 123547451392, 4611686018427387904], \
                [8092405595512832, 2305843010178908160, 64, 0, 18014398509483824]]
  return generate_state_from_array_struct( after_iota )
end

def get_deterministic_after_rounds_state
  after_rounds = [[12064587861610016902, 1420310091065692327, 14053702240072734244, 17986005929328750835, 3807079223108712064], \
                  [16051390273388789323, 1200464302119730108, 9579470720324063044, 9213260061797958410, 15239705187331816652], \
                  [1967223475766300385, 13361730036147754039, 10992022904660817276, 13191930635209375834, 9562982566573793563],\
                  [1604528745641041788, 7729397811237106250, 2572471060771778338, 1089167774992471973, 13211007501956777066], \
                  [10128771505792781323, 12671557949755369112, 2426515143822999563, 14802478548645389472, 8118538297826500580]]
  return generate_state_from_array_struct( after_rounds )
end
