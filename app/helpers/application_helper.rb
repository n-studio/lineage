module ApplicationHelper

  def emoji_flag(country)
    ISO3166::Country[country]&.emoji_flag
  end
end
