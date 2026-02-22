# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

user = User.find_or_create_by!(email: "user@example.com") do |u|
  u.password = "aaaaaaaa"
  u.admin = true
end

style = Style.find_or_create_by!(name: "Wing Chun")
pole_style = Style.find_or_create_by!(name: "Six and a half point long pole")

def find_or_seed!(user, name, **attrs)
  Practitioner.find_or_create_by!(name: name) do |p|
    p.added_by = user
    p.public_figure = true
    attrs.each { |k, v| p.send(:"#{k}=", v) }
  end
end

def relate!(disciple, master, style:)
  disciple.disciple_of!(master, style: style) unless disciple.disciple_of?(master)
end

ng_mui         = find_or_seed!(user, "Ng Mui", legendary: true, controversial: true, created_style: style)
chi_sin        = find_or_seed!(user, "Chi Sin", legendary: true, controversial: true, created_style: pole_style)
yim_wing_chun  = find_or_seed!(user, "Yim Wing Chun", controversial: true)
leung_bok_cho  = find_or_seed!(user, "Leung Bok Cho")
leung_lan_kwai = find_or_seed!(user, "Leung Lan Kwai")
leung_yee_tai  = find_or_seed!(user, "Leung Yee Tai")
wong_wah_po    = find_or_seed!(user, "Wong Wah Po")
leung_jan      = find_or_seed!(user, "Leung Jan")
chan_wah_shun   = find_or_seed!(user, "Chan Wah Shun")
leung_bik      = find_or_seed!(user, "Leung Bik")
yip_man        = find_or_seed!(user, "Yip Man")
yip_chun       = find_or_seed!(user, "Yip Chun")
yip_ching      = find_or_seed!(user, "Yip Ching")
leung_sheung   = find_or_seed!(user, "Leung Sheung")
chu_shong_tin  = find_or_seed!(user, "Chu Shong Tin")

relate!(yim_wing_chun, ng_mui, style: style)
relate!(leung_bok_cho, yim_wing_chun, style: style)
relate!(leung_lan_kwai, leung_bok_cho, style: style)
relate!(leung_yee_tai, chi_sin, style: pole_style)
relate!(leung_yee_tai, wong_wah_po, style: style)
relate!(wong_wah_po, leung_yee_tai, style: pole_style)
relate!(wong_wah_po, leung_lan_kwai, style: style)
relate!(leung_jan, leung_yee_tai, style: style)
relate!(leung_jan, wong_wah_po, style: style)
relate!(chan_wah_shun, leung_jan, style: style)
relate!(leung_bik, leung_jan, style: style)
relate!(leung_bik, wong_wah_po, style: style)
relate!(yip_man, chan_wah_shun, style: style)
relate!(yip_man, leung_bik, style: style)
relate!(yip_chun, yip_man, style: style)
relate!(yip_ching, yip_man, style: style)
relate!(leung_sheung, yip_man, style: style)
relate!(chu_shong_tin, yip_man, style: style)
