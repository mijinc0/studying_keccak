# Deterministic test data for "keccak_spec.
require_relative "../src/model/state.rb"
require_relative "../src/model/sheet.rb"
require_relative "../src/model/lane.rb"

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

# Keccak512
def get_context()
  return { bitrate:576, capacity:1024, output_size:512, suffix:[] }
end

def get_msg_byte()
  msg = "fe1c4d"
  return [msg].pack("H*")
end

def get_state_after_absorb_step()
  after_absorb = [[6556505275100376823, 14963648550860522668, 15682275547020670936, 13517159049042350316, 12570166781363795450], \
                  [6900193871504209890, 4309169055301732350, 7639773092108055973, 5109850682008084799, 15650280718324983745], \
                  [11493651883905769334, 8970577198025904056, 8774115187285470979, 2197455173113333458, 917199733084744911], \
                  [14360572660193882176, 10824114938870124047, 10098873181387325519, 3765629686109032106, 1324416134924618061], \
                  [15420337099273570961, 4094865127061698285, 6990866632222951683, 17035843703552396229, 12351407458622536296]]

  return generate_state_from_array_struct( after_absorb )
end

def get_state_after_squeeze_step()
  after_squeeze = [[3080272221973603350, 6829746159662079798, 1256268301257388537, 6201656363882271302, 9486968142787252474], \
                   [8799486469382437087, 5453691317316215823, 14199823752351908570, 3620957672651810906, 1592682701943623204], \
                   [6607236165057392637, 12598368489816847067, 2277861476160359574, 6517386446058307191, 3133467945853336635], \
                   [9884640220112056898, 8524481988718258282, 4423859711188211872, 1924793939802783259, 17194326227191199912], \
                   [17902974716912098209, 13617539548425102722, 13847547327859914796, 1464411550801579277, 12432431553160261556]]

  return generate_state_from_array_struct( after_squeeze )
end

def get_digest_bytes()
  digest = "f72e5552cf62fd5ae2f75570c469c25f76df33107ea7819f40f00ab6bf004bc7918afa2ee40a00d6ac84d481138fa9cffe875dc26c3ecd3bb88f8df66ee47d7c"
  return [digest].pack("H*")
end
