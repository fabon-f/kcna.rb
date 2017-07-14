# kcna.rb

A Ruby gem for kcna.kp(KCNA, Korean Central News Agency)

## Installation

Add this line to your Gemfile and execute `bundle`. (recommended way)

```ruby
gem 'kcna'
```

You can also install it by `gem install kcna`.

## Usage

```ruby
require "kcna"

kcna = KCNA.new

kcna.get_article_list.each do |article|
  content = kcna.get_article(article.id).content
  File.write("/path/to/directory/#{article.id}.txt", content)
end
```

See also [RubyDoc](http://www.rubydoc.info/github/hinamiyagk/kcna.rb/master).

## License

MIT
