require "test_helper"

class ArticleTest < Minitest::Test
  def test_insufficient_params
    assert_raises do
      KCNA::Article.new(content: "")
    end
  end

  def test_accessors
    article = KCNA::Article.new("AR114514", content: "抗日の血戦万里 日帝を打ち破り、三千里の我が国を取り戻された首領様", main_title: "金日成大元帥万々歳", sub_title: "", music_count: 1, movie_count: 1, photo_count: 0)
    assert_equal "AR114514", article.id
    assert_equal "抗日の血戦万里 日帝を打ち破り、三千里の我が国を取り戻された首領様", article.content
    assert_equal "金日成大元帥万々歳", article.main_title
    assert_equal "", article.sub_title
    assert_equal 1, article.music_count
    assert_equal 1, article.movie_count
    assert_equal 0, article.photo_count
  end

  def test_accessor_defaults
    article = KCNA::Article.new("AR114514", content: "抗日の血戦万里 日帝を打ち破り、三千里の我が国を取り戻された首領様")
    assert_nil article.date
    assert_equal 0, article.movie_count
    assert_equal 0, article.photo_count
    assert_equal 0, article.music_count
  end

  def test_to_h
    content = "抗日の血戦万里 日帝を打ち破り、三千里の我が国を取り戻された首領様"
    article = KCNA::Article.new("AR114514", content: content)
    assert_equal ({ date: nil, content: content, main_title: nil, sub_title: nil, display_title: nil, movie_count: 0, photo_count: 0, music_count: 0 }), article.to_h
  end
end
