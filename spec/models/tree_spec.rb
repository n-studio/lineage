require 'rails_helper'

RSpec.describe Tree, type: :model do
  let(:leung_jan) { Practitioner.create(name: "Leung Jan") }
  let(:leung_bik) { Practitioner.create(name: "Leung Bik") }

  before do
    style = Style.create(name: "Wing Chun")
    pole_style = Style.create(name: "Six and a half point long pole")
    ng_mui = Practitioner.create(name: "Ng Mui", legendary: true, controversial: true)
    chi_sin = Practitioner.create(name: "Chi Sin", legendary: true, controversial: true)
    yim_wing_chun = Practitioner.create(name: "Yim Wing Chun", controversial: true)
    yim_wing_chun.disciple_of!(ng_mui, style: style)
    leung_bok_cho = Practitioner.create(name: "Leung Bok Cho")
    leung_bok_cho.disciple_of!(yim_wing_chun, style: style)
    leung_lan_kwai = Practitioner.create(name: "Leung Lan Kwai")
    leung_lan_kwai.disciple_of!(leung_bok_cho, style: style)
    leung_yee_tai = Practitioner.create(name: "Leung Yee Tai")
    leung_yee_tai.disciple_of!(chi_sin, style: pole_style)
    wong_wah_po = Practitioner.create(name: "Wong Wah Po")
    leung_yee_tai.disciple_of!(wong_wah_po, style: style)
    wong_wah_po.disciple_of!(leung_yee_tai, style: pole_style)
    wong_wah_po.disciple_of!(leung_lan_kwai, style: style)
    leung_jan.disciple_of!(leung_yee_tai, style: style)
    leung_jan.disciple_of!(wong_wah_po, style: style)
    chan_wah_shun = Practitioner.create(name: "Chan Wah Shun")
    chan_wah_shun.disciple_of!(leung_jan, style: style)
    leung_bik.disciple_of!(leung_jan, style: style)
    leung_bik.disciple_of!(wong_wah_po, style: style)
    yip_man = Practitioner.create(name: "Yip Man")
    yip_man.disciple_of!(chan_wah_shun, style: style)
    yip_man.disciple_of!(leung_bik, style: style)
    chu_shong_tin = Practitioner.create(name: "Chu Shong Tin")
    chu_shong_tin.disciple_of!(yip_man, style: style)
  end

  describe "#node_appears_lower_level" do
    it "shows the right level" do
      style = Style.first
      root_practitioner = Practitioner.includes(:disciples).order(:id).first
      tree = TreeBuilder.new(practitioners: [root_practitioner], style: style, mode: :root).call

      expect(tree.node_appears_lower_level({ id: leung_jan.id, position: [0, 0, 0, 0, 0, 1] })).to eq(1)
      expect(tree.node_appears_lower_level({ id: leung_bik.id, position: [0, 0, 0, 0, 0, 2] })).to eq(2)
    end
  end
end
