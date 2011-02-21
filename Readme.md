YqlQuery
========

A simple [YQL query](http://developer.yahoo.com/yql/guide/index.html) generation library written in ruby, providing a chainable query builder capable of generating the most complex query conditions you can throw at it.

Installation
------------

    (sudo) gem install yql-query

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

Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (c) 2011 Steve Agalloco. See LICENSE for details.