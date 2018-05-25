# Changelog

## v 0.1.0 (2018-05-25)

- validation against json-schema gem
- 100% code coverage
- added appraisal gem for generating multiple gemfiles
- created a dummy rails app (valid both for rails 4 and rails 5)
- rails 4 backward compatibility for ActiveRecord
- improved ci

## v 0.0.5 (2018-05-23)

- json pretty generation by default
- added a Rails rake task example in the README.md
- added schema `title` and `required` attributes
- refactored `from_active_record` method in `from_model`
- manipulate a dup of table columns

## v 0.0.4 (2018-05-22)

- corrected `ActiveRecord::ConnectionAdapters::SqlTypeMetadata` reference in `JsonschemaSerializer::ActiveRecord`

## v 0.0.3 (2018-05-21)

- improved documentation on existing code base
- refactored `JsonschemaSerializer::ActiveRecord` as a `class`

## v 0.0.2 (2018-05-20)

- basic rDoc comments for documentation

## v 0.0.1 (2018-05-20)

- basic implementation of `JsonschemaSerializer::Builder`
- POC implementation of a `JsonschemaSerializer::ActiveRecord` module
