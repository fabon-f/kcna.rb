class KCNA::Article
  attr_reader :id

  def self.attr_reader_hash(key, default = nil)
    define_method(key, -> { @attrs[key].nil? ? default : @attrs[key] })
  end

  attr_reader_hash :date
  attr_reader_hash :content
  attr_reader_hash :main_title
  attr_reader_hash :sub_title, ""
  attr_reader_hash :display_title
  attr_reader_hash :movie_count, 0
  attr_reader_hash :photo_count, 0
  attr_reader_hash :music_count, 0

  def initialize(id, **attrs)
    raise "id is not a string" unless id.kind_of?(String)
    @id = id
    @attrs = attrs
  end
end
