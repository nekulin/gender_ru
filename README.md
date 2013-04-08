# GenderRu

Gem tries detect gender and nationality by name. It supports Russian and Azerbaijanian names.

## Installation

Add this line to your application's Gemfile:

    gem 'gender_ru'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gender_ru

## Usage

```ruby
name = GenderRu::FullName.new surname: 'Иванова', name: 'Анна', patronymic: 'Петровна'

name.gender         # => :female
name.ethnicity      # => :russian
name.female?        # => true
name.male?          # => false
name.russian?       # => true
name.azerbaijanian? # => false

# Husband's surname
name.male_surname   # => "Иванов"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
