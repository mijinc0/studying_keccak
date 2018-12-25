# 総合テスト
require_relative "../src/keccak.rb"

RSpec.describe Keccak do
  describe "Keccak-224" do
    messages = ["c04d3afdcd7eeb62", \
                "9b9f54634b35dedc558f7480defaaa96", \
                "e73a67349aed2fea4920deaf8360cad62f73c2d8a7d41ee8", \
                "1a448de996c187d3930f71287cbc5e73b4d8b2513162f27065bc21f9096c6643", \
                "e00239518eec2e4dcf1b2f0696b76067719f15a51e98f83c83cbdb1363a20b42de61e1b692fffeee", \
                "a50afcfe2b2be68bff885b168fc9808a9b6c134ac91a8955a47a53f3463603a66f8de49c568085b6b1e3179604dbbfdf", \
                "f25f7e1c0bc9727e8e92ee831168830703cd1ca1ac42fa0d70c51f82ad35dfa8e7e85982503b9f9332f4911317e1b8b6e8efc44f436a6cce", \
                "4f2eb6e3f9e751703fce66dc214cd1bec10ffacb1238e88af5b92eec836443201e5e931ca66bfc6397a21403bc7dedcec588eaa738da5ce388c305a30f102f04", \
                "99cd66696b5aee8347753dae6342619c8189deb611850d7fd038a50bdb0deaebc0ffc77c56ff154483d5e1291bb1fadf935bae1bb8d4556c0f2d36d09711adbe998bcd3cf4417325", \
                "3fdeb6349469fcbf70f973c4743b2ea13562efe750238051992028ee2e00228106458c96f4c8038e4d7784c6bbfbc8452277513a7ed94385087c4f6c3409fd25ee8a39b7c97f376913fe1ce61cca9a52"]

    hashes = ["dbd99c1a4f8dffae5a0f87eed47a8a9f97e5b4e28edb59e343127221", \
              "c3518dd5e5627adafacdf25be13068273493311a48e0a75d81726041", \
              "0f82f91fbdd7584689e70a486ea99cc2191d6cc4e60de3ff5e92b10b", \
              "d1c06e959811a15d51f068839562e8eb2bb27857264d7663f236a86e", \
              "5ebb124524df286e6b0f72acbbdfa55f738bfe5ce17410fe5c36f582", \
              "ab82966e0b51352de96fcdccc8f43ee63f151ad9b66a736df80f4b51", \
              "f01542cd0af6de3ae907dfa9978254d71f6b010fde792fd11a4c9caa", \
              "c7c8790a0f4bf94e21382c234fedc7591667ec6dd38b503b7b21cdaf", \
              "55e5d9dffccef0eefb875acb08a0d4a1a5c7bfe7c70fe96fa078a6b5", \
              "dda95701331816092b4c7e5e21e372d75744c296e3d7474afdc90d16"]

    messages.size.times do |i|
      subject = Digest::Keccak224.hex_digest( messages[i] )
      it{ expect( subject.downcase ).to eq hashes[i] }
    end
  end

  describe "Keccak-256" do
    messages = ["9a52718bc2ca9661", \
                "bace2eec7309891ee2aef8b531c1d2d1", \
                "dab52592b2f90115b273cae2e1063a9fe55f4a5d827df6eb", \
                "5a386d77ee70717236494c978b412d976bd1441cd826a8a331bc9e945048115a", \
                "143115bc245b82eb9199ccf4896d03909c73687706edb906a93cb630ca62ec71204c53b466c61c02", \
                "8a108815f553794ee0ac1c22a2fe027480a98ffd9b41ea0a8a904cc149b821d27ede8aba74fcef58c6bcd86a45254684", \
                "87c0aac3661658b29ef7741629ec2a77cca6e2708f752376362062887cac40b2d987a9458a2de88fd50d961677c72efd7d19e19f367a082c", \
                "e0a83f22ccc0e0f36f1cdc767f36dd24ff3f408298c0932c9552bc885beb1e9e700926c7e372655b3f2d201aeef5191e57eecca63a8c0cf9cee01ca343750ffc", \
                "fd8f612e923912162b7b0e5bbab915f5cca5bc5ebc16f1a633df604c8993e183db3a4becc8bce6b1131179c7ade08ce08787f6e8b5aa2c980108f73b69d093f75fb93be820693af9", \
                "7e3126abedd15a0347464ca49014305cf4044283314de5723d99b2d669aa1463e8d26454a8ce124755602f817b97b650cd7be9bb30f4611122d1071bb3d535824935188ae731b8ee6c37e31368a44519"]

    hashes = ["cdb389bce9618e0c4fac897f8a822d53d960d23070ee5003cac465fde1ab3ff1", \
              "8b537737f39db64865fa4bb8640b7fe0c59d51ca685118bc6d19d0f356ebadaa", \
              "220bc460fd2875b29802235ba913024aedabb70df527459f934acea7c381b930", \
              "93d83db6363673a0bd6b8722836406d5819702c50216a714f9bf7694eca25003", \
              "ac0689e37d1ce9426b8b1aadea47b283b5146470da36c415ade3d46f6c1abc8f", \
              "ace3447d8fc7ec0353ab0a4405b1d8ba6bee0f53f023e487a14b31c8025489cc", \
              "f74fa595719cc1c622833287c94b934fb0df21a938baab6ecfafa11aa1685e38", \
              "992f0aa5218f8804349872ad552788ecae72393d467f91d3252ad84c5d19beff", \
              "a3e446184217ab6dff48fe92c3a3c49e21324c026117a3b10add40af6c77b8b1", \
              "de0999756c0adf3485272a70734f7b92de0257886df08c1d1ec632d4279d26da"]

    messages.size.times do |i|
      subject = Digest::Keccak256.hex_digest( messages[i] )
      it{ expect( subject.downcase ).to eq hashes[i] }
    end
  end

  describe "Keccak-384" do
    messages = ["fce17ffc94e4bbd8", \
                "a9716ca1bed783fa20b968fd8bc73f1b", \
                "1d49506aa74f80ef5f9580a4369ec58fb0ee2c97015bb279", \
                "17f8ff4cb873fb255621e9cc68a83477bed0063afe3c16ab911e742109f786d0", \
                "ecd5787e11fd32987b78bdaa7cb59cbdd336f9b4454dc2bccf5b80cad8dff24d287ee48d471f5df1", \
                "12d05de39667d687606a8f96862df36720ce64ea66e6bf9b7f0960fb2505267222293e4e9dea0cf295149cc6ec5f9b55", \
                "5b8f7cd27dba795346c158901781541ec04ce7c3fb493e97edbd1c05cd02534c012d418a5357ddcb2a71ee490f8d3107c86451bbb46a7e91", \
                "a108e51e7afd07af96764e9359f463d7bf263254cdfa2e4df45fa2c6cf750312a08dfd354c1d7a5cd3c03e3e7e6df5be196fa777a303dc9cae210408a8a69e71", \
                "b81a4748c2a7245897df786d6ecba2cb1dd5fde078057baed18a67da8ebfb713360157f259047f6ba32cc94fe15eb181ee2a4ecb12a5a2cd57737d207603ca44dbc28182fcd21480", \
                "e240b94466a9a78c87be36d2ae4365848c9ec046a2fdbd519a3e467ba5412a9e0b32423385c467956c7de892bcae0f423ffbf0742fdeb11625606e979ae249a9acc2dffc0107c7266af08381fe5b4ca6"]

    hashes = ["7511b39d730e9cfbca702095ad6af300dd6d7dd06e15058a8d0744763db83116b430e3970c6bf8796be549a8df097679", \
              "c086c64b83bccbcd8c89171418bc47f820dcb592d92fd53abf42fc8d029ddf49cf32cfcc67a7cb141e07b13790a9fd17", \
              "12c37afca7f95be225adc4ae309eea10e77207e20f221814622c1256c0eee9ccd5ee6c03bfc8c05733ccbf6a70061a6d", \
              "07d16c916f5c3f2d0de37555663d2e21db60c65be40f7577c5b5526fce9b88c79c6c16f40d2d8285842f17266bba0536", \
              "2ec1e071308571cced946617ce4d58cc5a55b466857a0f4440dce64eeb8cae6bbda4b1371b908c741917050ce626ac4f", \
              "afd5c82b66701aa7787eac6e4b7c7508448a05617446572ea26d2e6a55de662021d11440ed7289d5d0456017ff7ae4ee", \
              "3ffb2a63f767a179f2d611c2cc7ca18306bb66a9da82ca6c354385ab79d9c850317b5c218901c32eabc0656160a89c90", \
              "07fd01732fca30e3512d76ef5d29a46efbd0a9f02cee22f8d30dd6d5de54be8c5cedf1508c3cc20497f0142e271b919f", \
              "61068cfda0108fc32de836ca9384785e2fb4a379dec1028473cb1e213e4d12ec0335306156cb76a59b514d38f7528071", \
              "fe4f14f489356f90e9cbe9b5bb6630357c444d3b24925d8fb14a5e6f51b46c499cdeb531af1f1074d85d660b8e252b9e"]

    messages.size.times do |i|
      subject = Digest::Keccak384.hex_digest( messages[i] )
      it{ expect( subject.downcase ).to eq hashes[i] }
    end
  end

  describe "Keccak-512" do
    messages = ["2830289aa525dcae", \
                "3d6ac6f0eaaf216a4a0c3718d6cbd412", \
                "db3bb47954bbe90630de52126a027fab7814e5462d4e450b", \
                "15ad80da46b4b30e5ea32a5c9120b2a818401c007c8b6ec6435c696f359f13be", \
                "85d33cd785d407b10da2cd353d9c0230011cc8af1d2e9f18958f4dce23e9857c145310df80e92d37", \
                "a6e1af7de4b2b24808979aa3757ede310582059021f484d01bed761bad4632e7e73b2230c3ced60f091a3b76cb6e5fcc", \
                "56f1ef76b46d106091eb2769274b20f5fa777d7d01afda6b0c6a4f501f1e1b155346d72e5f3ec4691551b0df2daba248d187ceee27d1f69b", \
                "df3202400497bd84d16408473765468630584eb5f2a0fb6bbc3267fc7469578332ce22584e9b2d7c7c4295164a6625836f7f3b1b69f03dd2dc35004724487f14", \
                "5d832425035b469be91646ee84cb67358be102901c1c5742710ae9dcf40491cd297a8ed71b7b27d07ceeed9a1e2162fa5df767d57d3e030e1c918e4b676bdcac59fc6e290d71f786", \
                "75671bca87c7883f20eae675f1701a527e390b5e59544883f37a4030ef721ba4813bb841f8f4c7355fe44f747ff4aac05037a24aaec681e053b10cadb1ba42c44114e03074190c4cfb5f9ded90bd7443"]

    hashes = ["833c1ecabe54feea3b5e29a64870c5438af5b559067923df59d39e6452416b1f4b397b4a7ed1c76d869941f95a6b1995d0516fcb003fce19338c4cd2230fa618", \
              "a337a3aac9ddad6b7fd284d83ad2eb4cf7823ab30e56f59ed2796db6a0ea48549251874e902585fe09302f4de1805bd1f755d3beb66990c2930848dce65190b6", \
              "ec3784d513adad0d15df520118b44912462228bb84d75610b5fcf25db276520cae986c7400b56f3d1612134c3e8a8eb0a18666db2c087ff7ef3164bfb29226ef", \
              "1901d692d8d81a1a10a66abbf0d164cbc00f81078e8fe7fc416051371230139c3b8d60dcce897c62b5b32f01d389c7e07bdf376a663d922c100eb651dc2f4f37", \
              "1805d0709b95d294dc867e9f3d9421809225ee8b94eb5f89a9e0fa5625becc687a74a74cb983fe42b7561d1ede4737cf7ad45d42f6ee52e38b0424d225a6f2af", \
              "7c15d5d24515ff1b6690a496d02ae07b1d1fe6567061e1ab1efc0a31c082f3b2862f7bad0961aea90867924da70edab58508233001d8f0b2bd6da81366354b11", \
              "27dae0298096e1494495f53822f5b9f572e77e351a4a4c07c4e159a4c399b52c83efd3918c083e644c570c4723ab5270c8988881b4ab05f21f4559cd14c7d57a", \
              "c35c217238d8aeced32fbb60775d4dfb65d72f277e8292c5520dcdc1f936b8e6029bc08c85a5bd309c623ea4fd95f9e60b521f62ecc01944d48676c0dbf282e3", \
              "22e67f84eb29f2625eea13c95e78dd984c7b3cfbdf3a16701539ab086211b15f0246d99bbf907d12b8469a8df941c79443c369264e9a1cb443c89d947d96d076", \
              "439e62ba8f2b45b907f0359434dfd77f475c80137e43ec5e693fe699c58e0523d9003a4c6c36c63d6c95192cb3cbe9139050cd6ee2cc2e0eca5f0fc4ab6ca656"]

    messages.size.times do |i|
      subject = Digest::Keccak512.hex_digest( messages[i] )
      it{ expect( subject.downcase ).to eq hashes[i] }
    end
  end

  describe "SHA3-224" do
    messages = [""]

    hashes = ["6b4e03423667dbb73b6e15454f0eb1abd4597f9a1b078e3f5b5a6bc7"]

    messages.size.times do |i|
      subject = Digest::SHA3_224.hex_digest( messages[i] )
      it{ expect( subject.downcase ).to eq hashes[i] }
    end
  end

  describe "SHA3-256" do
    messages = [""]

    hashes = ["a7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a"]

    messages.size.times do |i|
      subject = Digest::SHA3_256.hex_digest( messages[i] )
      it{ expect( subject.downcase ).to eq hashes[i] }
    end
  end

  describe "SHA3-384" do
    messages = [""]

    hashes = ["0c63a75b845e4f7d01107d852e4c2485c51a50aaaa94fc61995e71bbee983a2ac3713831264adb47fb6bd1e058d5f004"]

    messages.size.times do |i|
      subject = Digest::SHA3_384.hex_digest( messages[i] )
      it{ expect( subject.downcase ).to eq hashes[i] }
    end
  end

  describe "SHA3-512" do
    messages = [""]

    hashes = ["a69f73cca23a9ac5c8b567dc185a756e97c982164fe25859e0d1dcc1475c80a615b2123af1f5f94c11e3e9402c3ac558f500199d95b6d3e301758586281dcd26"]

    messages.size.times do |i|
      subject = Digest::SHA3_512.hex_digest( messages[i] )
      it{ expect( subject.downcase ).to eq hashes[i] }
    end
  end
end
