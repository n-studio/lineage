require "rails_helper"

RSpec.describe "Lineage tree", type: :system do
  before do
    driven_by :rack_test
  end

  let(:user) { User.create!(email: "user@example.com", password: "password123") }
  let(:style) { Style.create!(name: "Wing Chun") }

  before { sign_in user }

  describe "creating a lineage tree" do
    it "creates a practitioner and views empty lineage" do
      visit new_practitioner_path

      fill_in "Name", with: "Yip Man"
      select "Yes", from: "Public figure"
      click_on "Add Practitioner"

      expect(page).to have_content("Practitioner was successfully created.")
      expect(page).to have_content("Yip Man")
    end

    it "adds a master to a practitioner and displays the tree" do
      master = Practitioner.create!(name: "Chan Wah Shun", public_figure: true, added_by: user)
      disciple = Practitioner.create!(name: "Yip Man", public_figure: true, added_by: user)
      disciple.disciple_of!(master, style: style)

      visit practitioner_path(disciple, style: style.name, mode: "leaves")

      expect(page).to have_content("Yip Man's lineage")
      expect(page).to have_content("Wing Chun")
      expect(page).to have_link("Chan Wah Shun")
      expect(page).to have_link("Yip Man")
    end

    it "displays a multi-generation lineage tree from root" do
      grandmaster = Practitioner.create!(name: "Leung Jan", added_by: user)
      master = Practitioner.create!(name: "Chan Wah Shun", added_by: user)
      disciple = Practitioner.create!(name: "Yip Man", added_by: user)

      master.disciple_of!(grandmaster, style: style)
      disciple.disciple_of!(master, style: style)

      visit practitioner_path(grandmaster, style: style.name, mode: "root")

      expect(page).to have_content("Leung Jan's lineage")
      expect(page).to have_link("Leung Jan")
      expect(page).to have_link("Chan Wah Shun")
      expect(page).to have_link("Yip Man")
    end

    it "displays a lineage tree with multiple masters" do
      master1 = Practitioner.create!(name: "Chan Wah Shun", added_by: user)
      master2 = Practitioner.create!(name: "Leung Bik", added_by: user)
      disciple = Practitioner.create!(name: "Yip Man", added_by: user)

      disciple.disciple_of!(master1, style: style)
      disciple.disciple_of!(master2, style: style)

      visit practitioner_path(disciple, style: style.name, mode: "leaves")

      expect(page).to have_content("Yip Man's lineage")
      expect(page).to have_link("Chan Wah Shun")
      expect(page).to have_link("Leung Bik")
    end

    it "navigates from practitioner index to show page" do
      practitioner = Practitioner.create!(name: "Yip Man", public_figure: true, added_by: user)
      Practitioner.create!(name: "Chu Shong Tin", public_figure: true, added_by: user)
        .disciple_of!(practitioner, style: style)

      visit practitioners_path

      expect(page).to have_content("Latest added practitioners")
      click_link "Yip Man"

      expect(page).to have_content("Yip Man's lineage")
    end

    it "adds a master via the form" do
      practitioner = Practitioner.create!(name: "Yip Man", public_figure: true, added_by: user)
      style # ensure style exists

      visit new_practitioner_master_path(practitioner_id: practitioner.id)

      fill_in "Name", with: "Chan Wah Shun"
      select "Wing Chun", from: "Style"
      click_on "Add master"

      expect(page).to have_content("Master was successfully added.")
      expect(Practitioner.find_by(name: "Chan Wah Shun")).to be_present
      expect(practitioner.masters).to include(Practitioner.find_by(name: "Chan Wah Shun"))
    end

    it "adds a disciple via the form" do
      practitioner = Practitioner.create!(name: "Yip Man", public_figure: true, added_by: user)
      style # ensure style exists

      visit new_practitioner_disciple_path(practitioner_id: practitioner.id)

      fill_in "Name", with: "Chu Shong Tin"
      select "Wing Chun", from: "Style"
      click_on "Add disciple"

      expect(page).to have_content("Disciple was successfully added.")
      expect(Practitioner.find_by(name: "Chu Shong Tin")).to be_present
      expect(practitioner.disciples).to include(Practitioner.find_by(name: "Chu Shong Tin"))
    end

    it "displays the full Wing Chun lineage tree" do
      ng_mui = Practitioner.create!(name: "Ng Mui", legendary: true, added_by: user)
      yim_wing_chun = Practitioner.create!(name: "Yim Wing Chun", added_by: user)
      leung_bok_cho = Practitioner.create!(name: "Leung Bok Cho", added_by: user)
      leung_lan_kwai = Practitioner.create!(name: "Leung Lan Kwai", added_by: user)
      leung_yee_tai = Practitioner.create!(name: "Leung Yee Tai", added_by: user)
      wong_wah_po = Practitioner.create!(name: "Wong Wah Po", added_by: user)
      leung_jan = Practitioner.create!(name: "Leung Jan", added_by: user)
      chan_wah_shun = Practitioner.create!(name: "Chan Wah Shun", added_by: user)
      leung_bik = Practitioner.create!(name: "Leung Bik", added_by: user)
      yip_man = Practitioner.create!(name: "Yip Man", added_by: user)
      chu_shong_tin = Practitioner.create!(name: "Chu Shong Tin", added_by: user)

      yim_wing_chun.disciple_of!(ng_mui, style: style)
      leung_bok_cho.disciple_of!(yim_wing_chun, style: style)
      leung_lan_kwai.disciple_of!(leung_bok_cho, style: style)
      leung_yee_tai.disciple_of!(wong_wah_po, style: style)
      wong_wah_po.disciple_of!(leung_lan_kwai, style: style)
      leung_jan.disciple_of!(leung_yee_tai, style: style)
      leung_jan.disciple_of!(wong_wah_po, style: style)
      chan_wah_shun.disciple_of!(leung_jan, style: style)
      leung_bik.disciple_of!(leung_jan, style: style)
      leung_bik.disciple_of!(wong_wah_po, style: style)
      yip_man.disciple_of!(chan_wah_shun, style: style)
      yip_man.disciple_of!(leung_bik, style: style)
      chu_shong_tin.disciple_of!(yip_man, style: style)

      visit practitioner_path(ng_mui, style: style.name, mode: "root")

      expect(page).to have_content("Ng Mui's lineage")
      expect(page).to have_link("Ng Mui")
      expect(page).to have_link("Yim Wing Chun")
      expect(page).to have_link("Leung Bok Cho")
      expect(page).to have_link("Leung Lan Kwai")
      expect(page).to have_link("Wong Wah Po")
      expect(page).to have_link("Leung Yee Tai")
      expect(page).to have_link("Leung Jan")
      expect(page).to have_link("Chan Wah Shun")
      expect(page).to have_link("Leung Bik")
      expect(page).to have_link("Yip Man")
      expect(page).to have_link("Chu Shong Tin")

      # Verify the tree is rendered with the correct CSS class
      expect(page).to have_css("div.tree")
    end
  end

  describe "switching between lineage views" do
    let!(:master) { Practitioner.create!(name: "Chan Wah Shun", added_by: user) }
    let!(:disciple) { Practitioner.create!(name: "Yip Man", added_by: user) }

    before do
      disciple.disciple_of!(master, style: style)
    end

    it "switches between root and leaves mode" do
      visit practitioner_path(disciple, style: style.name, mode: "root")
      expect(page).to have_content("Yip Man's lineage")
      expect(page).not_to have_css("div.tree.flipped")

      visit practitioner_path(disciple, style: style.name, mode: "leaves")
      expect(page).to have_content("Yip Man's lineage")
      expect(page).to have_css("div.tree.flipped")
      expect(page).to have_link("Chan Wah Shun")
    end
  end

  describe "practitioner profile sidebar" do
    it "shows masters and disciples in the profile" do
      master = Practitioner.create!(name: "Chan Wah Shun", added_by: user)
      disciple = Practitioner.create!(name: "Yip Man", added_by: user)
      student = Practitioner.create!(name: "Chu Shong Tin", added_by: user)

      disciple.disciple_of!(master, style: style)
      student.disciple_of!(disciple, style: style)

      visit practitioner_path(disciple, style: style.name, mode: "root")

      within("aside") do
        expect(page).to have_content("Masters")
        expect(page).to have_link("Chan Wah Shun")
        expect(page).to have_content("Disciples")
        expect(page).to have_link("Chu Shong Tin")
        expect(page).to have_link("Add Master")
        expect(page).to have_link("Add Disciple")
      end
    end
  end
end
