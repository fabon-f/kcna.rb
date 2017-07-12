# Represents an article.
class KCNA::Article
  # @return [String] ID of the article
  attr_reader :id

  def self.attr_reader_hash(key, default = nil)
    define_method(key, -> { @attrs[key].nil? ? default : @attrs[key] })
  end
  private_class_method :attr_reader_hash

  # @!attribute [r]
  # @return [Date] date of the article
  attr_reader_hash :date
  # @!attribute [r]
  # @return [String] content of the article
  attr_reader_hash :content
  # @!attribute [r]
  # @return [String] main title of the article
  attr_reader_hash :main_title
  # @!attribute [r]
  # @return [String] subtitle of the article
  attr_reader_hash :sub_title, ""
  # @!attribute [r]
  # @return [String]
  attr_reader_hash :display_title
  # @!attribute [r]
  # @return [Integer] the number of movies related to the article
  attr_reader_hash :movie_count, 0
  # @!attribute [r]
  # @return [Integer] the number of photos related to the article
  attr_reader_hash :photo_count, 0
  # @!attribute [r]
  # @return [Integer] the number of musics related to the article
  attr_reader_hash :music_count, 0

  # @param [Hash] attrs attributes of article
  # @option attrs [Date] :date date of the article
  # @option attrs [String] :content content of the article
  # @option attrs [String] :main_title main title of the article
  # @option attrs [String] :sub_title subtitle of the article
  # @option attrs [String] :display_title
  # @option attrs [Integer] :movie_count the number of movies related to the article
  # @option attrs [Integer] :photo_count the number of photos related to the article
  # @option attrs [Integer] :music_count the number of musics related to the article
  def initialize(id, **attrs)
    raise "id is not a string" unless id.kind_of?(String)
    @id = id
    @attrs = attrs
  end
end
