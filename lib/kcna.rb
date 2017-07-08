require "kcna/version"
require "kcna/article"
require "httpclient"
require "date"
require "rexml/document"

class KCNA
  KO = "kor"
  EN = "eng"
  ZH = "chn"
  RU = "rus"
  ES = "spn"
  JA = "jpn"

  def initialize
    @client = HTTPClient.new
  end

  def normalize_text(content)
    great_leader_pattern = /<nobr><strong><font.*>(.*)<\/font><\/strong><\/nobr>/
    patterns = ["\n", "<br>", "&nbsp;", great_leader_pattern]
    content.gsub(Regexp.union(patterns)) do |match|
      case match
      when "\n", "&nbsp;"
        ""
      when "<br>"
        "\n"
      when great_leader_pattern
        $1
      end
    end.sub(/(－－－|‐‐‐)$/, "")
  end

  def set_language(lang)
    data = {
      article_code: "", article_type_list: "", news_type_code: "", show_what: "", mediaCode: "",
      lang: lang
    }
    @client.post("http://kcna.kp/kcna.user.home.retrieveHomeInfoList.kcmsf", body: data, follow_redirect: true)
  end

  private def fetch_article(article_id)
    article_url = "http://kcna.kp/kcna.user.article.retrieveArticleInfoFromArticleCode.kcmsf"
    data = { article_code: article_id, kwContent: "" }
    @client.post(article_url, body: data, follow_redirect: true).body
  end

  def get_article(article_id)
    doc = REXML::Document.new(fetch_article(article_id))
    container = REXML::XPath.first(doc, "//NData")
    raise "Article not found" if container.elements.size == 0

    date = Date.strptime(REXML::XPath.first(doc, "//articleCreateDate").text, "%Y.%m.%d")
    content = normalize_text(REXML::XPath.first(doc, "//content").text)
    display_title = normalize_text(REXML::XPath.first(doc, "//dispTitle").text)
    main_title = normalize_text(REXML::XPath.first(doc, "//mainTitle").text)
    sub_title = normalize_text(REXML::XPath.first(doc, "//subTitle").text)
    article_id = REXML::XPath.first(doc, "//articleCode").text
    movie_count = REXML::XPath.first(doc, "//fMovieCnt").text.to_i
    photo_count = REXML::XPath.first(doc, "//fPhotoCnt").text.to_i
    music_count = REXML::XPath.first(doc, "//fMusicCnt").text.to_i

    Article.new(
      id: article_id, content: content,
      date: date,
      main_title: main_title, sub_title: sub_title, display_title: display_title,
      movie_count: movie_count, photo_count: photo_count, music_count: music_count
    )
  end
end
