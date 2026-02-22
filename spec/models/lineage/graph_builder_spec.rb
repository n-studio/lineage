require "rails_helper"

RSpec.describe Lineage::GraphBuilder, type: :model do
  let(:user) { User.create!(email: "user@example.com", password: "password123") }
  let(:style) { Style.create!(name: "Wing Chun") }

  describe "#call" do
    it "builds nodes and edges for a simple master-disciple lineage" do
      master = Practitioner.create!(name: "Chan Wah Shun", added_by: user)
      disciple = Practitioner.create!(name: "Yip Man", added_by: user)
      disciple.disciple_of!(master, style: style)

      result = described_class.new(practitioner: master, style: style, mode: :root).call

      expect(result[:nodes].map { |n| n[:name] }).to contain_exactly("Chan Wah Shun", "Yip Man")
      expect(result[:edges]).to contain_exactly(
        { source: master.id.to_s, target: disciple.id.to_s }
      )
      expect(result[:current_id]).to eq(master.id)
      expect(result[:flipped]).to be false
    end

    it "builds leaves mode with flipped flag" do
      master = Practitioner.create!(name: "Chan Wah Shun", added_by: user)
      disciple = Practitioner.create!(name: "Yip Man", added_by: user)
      disciple.disciple_of!(master, style: style)

      result = described_class.new(practitioner: disciple, style: style, mode: :leaves).call

      expect(result[:nodes].map { |n| n[:name] }).to contain_exactly("Chan Wah Shun", "Yip Man")
      expect(result[:edges]).to contain_exactly(
        { source: master.id.to_s, target: disciple.id.to_s }
      )
      expect(result[:flipped]).to be true
    end

    it "collects multi-generation lineage" do
      grandmaster = Practitioner.create!(name: "Leung Jan", added_by: user)
      master = Practitioner.create!(name: "Chan Wah Shun", added_by: user)
      disciple = Practitioner.create!(name: "Yip Man", added_by: user)
      master.disciple_of!(grandmaster, style: style)
      disciple.disciple_of!(master, style: style)

      result = described_class.new(practitioner: grandmaster, style: style, mode: :root).call

      expect(result[:nodes].size).to eq(3)
      expect(result[:edges].size).to eq(2)
      expect(result[:edges]).to contain_exactly(
        { source: grandmaster.id.to_s, target: master.id.to_s },
        { source: master.id.to_s, target: disciple.id.to_s }
      )
    end

    it "handles multiple masters" do
      master1 = Practitioner.create!(name: "Chan Wah Shun", added_by: user)
      master2 = Practitioner.create!(name: "Leung Bik", added_by: user)
      disciple = Practitioner.create!(name: "Yip Man", added_by: user)
      disciple.disciple_of!(master1, style: style)
      disciple.disciple_of!(master2, style: style)

      result = described_class.new(practitioner: disciple, style: style, mode: :leaves).call

      expect(result[:nodes].size).to eq(3)
      expect(result[:edges].size).to eq(2)
    end

    it "handles cycles without infinite loops" do
      leung_yee_tai = Practitioner.create!(name: "Leung Yee Tai", added_by: user)
      wong_wah_po = Practitioner.create!(name: "Wong Wah Po", added_by: user)
      leung_yee_tai.disciple_of!(wong_wah_po, style: style)
      wong_wah_po.disciple_of!(leung_yee_tai, style: style)

      result = described_class.new(practitioner: leung_yee_tai, style: style, mode: :root).call

      expect(result[:nodes].size).to eq(2)
    end

    it "returns empty graph when no style" do
      practitioner = Practitioner.create!(name: "Yip Man", added_by: user)

      result = described_class.new(practitioner: practitioner, style: nil, mode: :root).call

      expect(result[:nodes].size).to eq(1)
      expect(result[:edges]).to be_empty
    end

    it "does not duplicate edges" do
      grandmaster = Practitioner.create!(name: "Leung Jan", added_by: user)
      master1 = Practitioner.create!(name: "Chan Wah Shun", added_by: user)
      master2 = Practitioner.create!(name: "Leung Bik", added_by: user)
      disciple = Practitioner.create!(name: "Yip Man", added_by: user)
      master1.disciple_of!(grandmaster, style: style)
      master2.disciple_of!(grandmaster, style: style)
      disciple.disciple_of!(master1, style: style)
      disciple.disciple_of!(master2, style: style)

      result = described_class.new(practitioner: grandmaster, style: style, mode: :root).call

      edge_pairs = result[:edges].map { |e| [e[:source], e[:target]] }
      expect(edge_pairs).to eq(edge_pairs.uniq)
    end

    it "includes node metadata" do
      practitioner = Practitioner.create!(name: "Yip Man", country_code: "HK", added_by: user)

      result = described_class.new(practitioner: practitioner, style: style, mode: :root).call

      node = result[:nodes].first
      expect(node[:id]).to eq(practitioner.id.to_s)
      expect(node[:name]).to eq("Yip Man")
      expect(node[:country_code]).to eq("HK")
    end
  end
end
