# AlsTypograf

Ruby client for ArtLebedevStudio.RemoteTypograf Web Service.

## Project links

* [Sources](https://github.com/alsemyonov/als_typograf)
* [Documentation](http://rubydoc.info/gems/als_typograf)
* [Issue Tracker](https://github.com/alsemyonov/als_typograf/issues)
* [Wiki](https://github.com/alsemyonov/als_typograf/wiki)
* [![Code Climate](https://codeclimate.com/github/alsemyonov/als_typograf/badges/gpa.svg)](https://codeclimate.com/github/alsemyonov/als_typograf)
* [![Test Coverage](https://codeclimate.com/github/alsemyonov/als_typograf/badges/coverage.svg)](https://codeclimate.com/github/alsemyonov/als_typograf)
* [![Build Status](https://travis-ci.org/alsemyonov/als_typograf.png?branch=master)](http://travis-ci.org/alsemyonov/als_typograf)

## Example

Default charset is UTF-8

```ruby
require 'als_typograf'
puts AlsTypograf.process('"Вы все еще кое-как верстаете в "Ворде"? - Тогда мы идем к вам!"')

class Article < ActiveRecord::Base
  typograf :title, use_br: false, use_p: false
  typograf :content
  typograf :skills, :achievements, :description, encoding: 'UTF-16'
  typograf foo: {use_br: false},
           bar: {use_p:  false},
           baz: {entity_type: AlsTypograf::NO_ENTITIES}
end
```

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## ArtLebedevStudio.RemoteTypograf

* [Typograf homepage](http://typograf.artlebedev.ru/)
* [Web-service address](http://typograf.artlebedev.ru/webservices/typograf.asmx)
* [WSDL-description](http://typograf.artlebedev.ru/webservices/typograf.asmx?WSDL)

## Copyright

© Alexander Semyonov, 2009-2014. See LICENSE for details.
