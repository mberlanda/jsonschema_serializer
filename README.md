# JsonschemaSerializer

[![Build Status](https://travis-ci.org/mberlanda/jsonschema_serializer.svg?branch=master)](https://travis-ci.org/mberlanda/jsonschema_serializer)
[![Gem Version](https://badge.fury.io/rb/jsonschema_serializer.svg)](https://badge.fury.io/rb/jsonschema_serializer)
[![Maintainability](https://api.codeclimate.com/v1/badges/7312071a0865c70f5d60/maintainability)](https://codeclimate.com/github/mberlanda/jsonschema_serializer/maintainability)

This purpose of this gem is to generate [JsonSchema](http://json-schema.org/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jsonschema_serializer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jsonschema_serializer

## Usage

You can generate a schema as follows:

```ruby
schema = JsonschemaSerializer::Builder.build do |b|

  subscriber = b._object title: :subscriber, required: [:age] do |prop|
    prop.merge! b.string :first_name, title: 'First Name'
    prop.merge! b.string :last_name, title: 'Last Name'
    prop.merge! b.integer :age, title: 'Age'
  end

  b.title "a title"
  b.description "a description"
  b.required :a, :b, :c
  b.properties.tap do |p|
    p.merge! b.string :a, description: "abc"
    p.merge! b.array :subscribers, description: "subscribers", items: subscriber
  end
end

schema.to_json
```

Allowed parameters for data types:

- `array`  : `:default, :description, items: {}||[{}], :minItems, :maxItems, :title`
- `boolean`: `:default, :description, :title`
- `integer`: `:default, :description, enum: [], :minimum, :maximum, :multipleOf, :title`
- `number` : `:default, :description, enum: [], :minimum, :maximum, :multipleOf, :title`
- `string` : `:default, :description, :format, :minLength, :title`

You can alternatively use an experimental builder for `ActiveRecord`


```ruby
serializer = JsonschemaSerializer::ActiveRecord

schema = serializer.from_active_record(MyActiveRecordClass)
schema = serializer.from_active_record(MyActiveRecordClass, only: %[desired1 desired2])
schema = serializer.from_active_record(MyActiveRecordClass, except: %[ignored1 ignored2])

# You can manipulate the resulting schema

schema.tap do |s|
  s.title "a title"
  s.description "a description"
end

schema.to_json
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mberlanda/jsonschema_serializer.
ygy
