require "kcna/version"
require "httpclient"

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

  def set_language(lang)
    data = {
      article_code: "", article_type_list: "", news_type_code: "", show_what: "", mediaCode: "",
      lang: lang
    }
    @client.post("http://kcna.kp/kcna.user.home.retrieveHomeInfoList.kcmsf", body: data)
  end
end
