require "test_helper"

unless ENV["DISABLE_HTTP_MOCK"]
  class KCNA
    def set_language(lang)
      @lang = lang
    end

    private def fetch_article(article_id)
      lang = { KCNA::JA => "ja" }[@lang]
      xml_path = File.expand_path("../fixture/#{article_id.downcase}_#{lang}.xml", __FILE__)
      File.read(xml_path)
    end

    private def fetch_article_list(start, news_type, from_date, to_date)
      if start == 0 && news_type == "" && from_date == "" && to_date == "2017-07-07"
        File.read(File.expand_path("../fixture/articles1.xml", __FILE__))
      elsif start == 103000
        File.read(File.expand_path("../fixture/articles_empty.xml", __FILE__))
      else
        raise "Unknown arguments"
      end
    end
  end
end

class KCNATest < Minitest::Test
  @kcna = KCNA.new
  @kcna.set_language(KCNA::JA)

  define_method(:kcna) do
    self.class.instance_variable_get(:@kcna)
  end

  def test_version
    refute_nil ::KCNA::VERSION
  end

  def test_get_article
    article =  kcna.get_article("AR0099775")
    assert_equal "AR0099775", article.id
    assert_equal <<EXPECTED.chomp, article.content
【平壌７月５日発朝鮮中央通信】金日成主席回顧インドネシア委員会が、６月２２日に結成された。
同回顧委員会の委員長にインドネシア先鋒者党中央指導理事会書記長のリスティヤント氏が選出された。
回顧委員会は、６月２５日から７月１０日までを回顧期間に定め、この期間に金日成主席の革命的生涯と業績をたたえる政治・文化行事を催すことにした。
EXPECTED
    assert_equal "金日成主席回顧インドネシア委を結成", article.main_title
    assert Date.parse("2017-07-05") === article.date, "Expected: 2017-07-05, Actual: #{article.date}"
    assert_equal 0, article.photo_count
    assert_equal 0, article.music_count
    assert_equal 0, article.movie_count
  end

  def test_get_article_list
    articles = kcna.get_article_list(0, to_date: "2017-07-07")
    assert_equal 10, articles.size
    assert_equal "AR0099896", articles[0].id
    assert Date.parse("2017-07-07") === articles[0].date, "Expected: 2017-07-07, Actual: #{articles[0].date}"
    assert_equal "大陸間弾道ロケット試射の成功を慶祝する平壌市軍民交歓大会", articles[0].display_title
    assert_equal "大陸間弾道ロケット試射の成功を慶祝する平壌市軍民交歓大会", articles[0].main_title
    assert_equal 1, articles[0].movie_count
    assert_equal 0, articles[0].music_count
    assert_equal 29, articles[0].photo_count
  end

  def test_get_article_list_with_empty_result
    articles = kcna.get_article_list(103000) # Index Librorum Prohibitorum > KCNA
    assert_equal 0, articles.size
  end
end
