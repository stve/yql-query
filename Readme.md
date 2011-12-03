YqlQuery
========

A simple [YQL query](http://developer.yahoo.com/yql/guide/index.html) generation library written in ruby, providing a chainable query builder capable of generating the most complex query conditions you can throw at it.

## Installation

    (sudo) gem install yql-query

## Documentation

[http://rdoc.info/gems/yql-query](http://rdoc.info/gems/yql-query)

Usage
-----

yql-query's primary interface is the Builder class.  Once you've instantiated a builder, you can pretty much generate whatever query you'd like using it.

    builder = YqlQuery::Builder.new
    builder.table('music.artists')

to generate a query, the Builder class provides a number of methods to construct it's arguments:

    builder.table('music.artists')
    builder.select('name, genre')
    builder.conditions("bands = 'false'")
    builder.sort('age')

conditions are also aliased as 'where':

    #using 'where'
    builder.where("bands = 'true'")

    # is the same thing as
    builder.conditions("bands = 'true'")

conditions can be passed as either a string, an array or

    builder.conditions(["name = 'Erykah Badu'", "release_year > '2005'"])

methods can be chained together:

    builder.table('music.artists').select('name').where("genre = 'jazz'")

to generate the query, just call to_s or to_query:

    builder.to_s
    # => 'select * from tablename...'

    builder.to_query
    # => 'select * from tablename...'

passing a hash with a Builder instance to creates sub-select:

    guid_query = Builder.new.table('users').select('guid').where("role = 'admin'")

    builder = Builder.new.table('actions).where(:guid => guid_query)
    builder.to_s
    # => "select * from actions where guid in (select guid from users where role = 'admin')"

The full list of methods available:

    table('music.albums')
    use('http://somedomain.com/table.xml', 'othersource')
    select('name')
    conditions("genre = 'jazz'")
    sort('albumName')
    sort_descending('albumName')
    limit(5)
    offset(10)
    tail(5)
    truncate(10)
    unique('format')
    sanitize('description')
    remote(10, 30) # remote limits and offsets

Refer to the [documentation](http://rdoc.info/gems/yql-query) for complete usage and more examples.

## <a name="ci"></a>Build Status
[![Build Status](https://secure.travis-ci.org/spagalloco/yql-query.png)][ci]

[ci]: http://travis-ci.org/jnunemaker/twitter

## <a name="dependencies"></a>Dependency Status
[![Dependency Status](https://gemnasium.com/spagalloco/yql-query.png)][gemnasium]

[gemnasium]: https://gemnasium.com/spagalloco/yql-query


## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 Steve Agalloco. See [LICENSE](https://github.com/spagalloco/yql-query/blob/master/License.md) for details.
