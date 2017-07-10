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

  private def post(path, body, max_redirect = 3)
    raise "Too many redirects" if max_redirect == 0

    res = @client.post("http://kcna.kp#{path}", body: body)
    if res.ok?
      res
    elsif res.redirect?
      raise "Response error: #{res.status}" unless res.status == HTTP::Status::TEMPORARY_REDIRECT
      post(path, body, max_redirect - 1)
    else
      raise "Response error: #{res.status}"
    end
  end

  def set_language(lang)
    data = {
      article_code: "", article_type_list: "", news_type_code: "", show_what: "", mediaCode: "",
      lang: lang
    }
    post("/kcna.user.home.retrieveHomeInfoList.kcmsf", data)
  end

  private def fetch_article(article_id)
    data = { article_code: article_id, kwContent: "" }
    post("/kcna.user.article.retrieveArticleInfoFromArticleCode.kcmsf", data).body
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

  private def fetch_article_list(start, news_type, from_date, to_date)
    data = { page_start: start, kwDispTitle: "", keyword: "", newsTypeCode: news_type, articleTypeList: "", photoCount: 0, movieCount: 0, kwContent: "", fromDate: from_date, toDate: to_date }
    post("/kcna.user.article.retrieveArticleListForPage.kcmsf", data).body
  end

  def get_article_list(start = 0, news_type: "", from_date: "", to_date: "")
    doc = REXML::Document.new(fetch_article_list(start, news_type, from_date, to_date))
    article_ids = REXML::XPath.match(doc, "//articleCode").map(&:text)
    disp_titles = REXML::XPath.match(doc, "//dispTitle").map { |node| normalize_text(node.text) }
    main_titles = REXML::XPath.match(doc, "//mainTitle").map { |node| normalize_text(node.text) }
    sub_titles = REXML::XPath.match(doc, "//subTitle").map { |node| normalize_text(node.text) }
    dates = REXML::XPath.match(doc, "//sendInfo").map(&:text)
    movie_counts = REXML::XPath.match(doc, "//fMovieCnt").map { |node| node.text.to_i }
    music_counts = REXML::XPath.match(doc, "//fMusicCnt").map { |node| node.text.to_i }
    photo_counts = REXML::XPath.match(doc, "//fPhotoCnt").map { |node| node.text.to_i }

    article_ids.zip(
      disp_titles, main_titles, sub_titles, dates,
      movie_counts, music_counts, photo_counts
    ).map do |id, disp, main, sub, date, movie, music, photo|
      date = "2015-04-02" if id == "AR0060168"
      Article.new(
        id: id, date: Date.parse(date),
        display_title: disp, main_title: main, sub_title: sub,
        movie_count: movie, music_count: music, photo_count: photo
      )
    end
  end
end
