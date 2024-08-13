module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :success  then "bg-flash-messages-green"
    when :danger   then "bg-flash-messages-red"
    when :error  then "bg-flash-messages-yellow"
    else "bg-gray-500"
    end
  end

  # 取得したサムネイル画像がなかった場合はsample.jpgを付与する
  def google_material_thumbnail(google_material)
    google_material['volumeInfo']['imageLinks'].nil? ? 'no_image.png' : google_material['volumeInfo']['imageLinks']['thumbnail']
  end

  #thumbnailはネストしている配置となっているのでdigを使って取り出す
  #また画像のリンクがhttpとなっているためgsubを使いhttpsに変更する。変更した値をbookImageに代入する
  def set_google_material_params(google_material)
    google_material['volumeInfo']['image'] = google_material.dig('volumeInfo', 'imageLinks', 'thumbnail')&.gsub("http", "https")

    #ISBNは13桁と10桁があり、どちら1つを取得できればよいので、最初に検索した値をsystemidに代入する
    if google_material['volumeInfo']['industryIdentifiers']&.select { |h| h["type"].include?("ISBN") }.present?
      google_material['volumeInfo']['systemid'] = google_material['volumeInfo']['industryIdentifiers']&.select { |h| h["type"].include?("ISBN") }.first["identifier"]
    end
     #volumeInfoの中が必要な項目のみになるようsliceを使って絞りこむ
    google_material['volumeInfo'].slice('title', 'authors', 'publishedDate', 'infoLink', 'image', 'systemid', 'canonicalVolumeLink')
  end

  # 教材追加時のチェックボックス内容
  def experience_levels
    ["初学者", "経験者", "1冊で合格", "資格合格最低限内容", "深掘りした内容", "問題数多め", "解説が丁寧"]
  end
end
