# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, "\\1en"
#   inflect.singular /^(ox)en/i, "\\1"
#   inflect.irregular "person", "people"
#   inflect.uncountable %w( fish sheep )
# end

# AniListAdapterのファイル名（anilist_adapter.rb）をZeitwerkが正しくCamelCaseに変換するためのアクロニム定義
# IGDBは通常のCamelCase（IgdbAdapter）を使用するためアクロニム登録不要
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym 'AniList'
end
