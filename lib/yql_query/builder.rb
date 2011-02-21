module YqlQuery

  # The primary query builder class, wraps a {Query} object and provides methods to assign query arguments.
  class Builder

    attr_accessor :query

    # Instantiates a new Builder instance.
    # @param
    def initialize(options={})
      self.query = Query.new
      self.query.table      = options.delete(:table)
      self.query.limit      = options.delete(:limit)
      self.query.offset     = options.delete(:offset)
      self.query.select     = options.delete(:select)
      self.query.conditions = options.delete(:conditions) || []
      self.query.uses       = options.delete(:uses) || []
      self.query.tail       = options.delete(:tail)
      self.query.truncate   = options.delete(:truncate)
      self.query.reverse    = options.delete(:reverse)
      self.query.unique     = options.delete(:unique)
      self.query.sanitize   = options.delete(:sanitize)
    end

    # Assigns the table for the query being constructed
    #
    # @param [String] table The name of the table.
    # @return [YqlQuery::Builder] YqlQuery::Builder instance reflecting the table assigned.
    def table(table)
      self.query.table = table
      self
    end

    # Assigns the limit for the query being constructed
    #
    # @param [Object] limit The limit for the query.
    # @return [YqlQuery::Builder] YqlQuery::Builder instance reflecting the limit assigned.
    #
    # @example The limit may be passed as either a string or fixnum:
    #   base = Builder.new.limit(5)
    #   base = Builder.new.limit('5')
    def limit(limit)
      self.query.limit = limit
      self
    end

    # Assigns the offset for the query being constructed
    #
    # @param [Object] offset The offset for the query.
    # @return [YqlQuery::Builder] YqlQuery::Builder instance reflecting the offset assigned.
    #
    # @example The offset may be passed as either a string or fixnum:
    #   base = Builder.new.offset(5)
    #   base = Builder.new.offset('5')
    def offset(offset)
      self.query.offset = offset
      self
    end

    # Assigns the columns to select for the query being constructed
    #
    # @param [Object] select The select arguments for the query.
    # @return [YqlQuery::Builder] YqlQuery::Builder instance reflecting the select arguments assigned.
    #
    # @example The select may be passed as either a string or an array:
    #   base = Builder.new.select('name')
    #   base = Builder.new.select('name, age')
    #   base = Builder.new.select(['name', 'age'])
    def select(select)
      self.query.select = select
      self
    end

    # Assigns additional datatable sources for use with the query being constructed
    #
    # @param [String] source The url of the data source.
    # @param [String] as The name the data source will be referenced as in queries.
    # @return [YqlQuery::Builder] YqlQuery::Builder instance reflecting the data source arguments assigned.
    #
    # @example The select may be passed as either a string or an array:
    #   base = Builder.new.use('http://anothersource/sometable.xml', 'sometable')
    #   base.to_s
    #   # => "use http://anothersource/sometable.xml as sometable; select * from tablename"
    def use(source, as)
      self.query.uses << Source.new(source, as)
      self
    end

    def conditions(conditions)
      if conditions.kind_of?(String)
        self.query.conditions << conditions
      elsif conditions.kind_of?(Array)
        self.query.conditions += conditions
      elsif conditions.kind_of?(Hash)
        conditions.each { |key, value|
          if value.kind_of?(YqlQuery::Builder)
            self.query.conditions << "#{key} in (#{value})"
          else
            self.query.conditions << "#{key} = '#{value}'"
          end
        }
      end
      self
    end
    alias :where :conditions

    # Assigns the sort for the query being constructed
    #
    # @param [Object] sort The column to sort for the query.
    # @return [YqlQuery::Builder] YqlQuery::Builder instance reflecting the sort assigned.
    #
    # @example
    #   base = Builder.new.sort('name)
    def sort(sort, options={:descending => false})
      self.query.sort = sort
      self.query.sort_order = options
      self
    end

    # Assigns the tail argument for the query being constructed
    #
    # @param [Object] tail The tail argument for the query.
    # @return [YqlQuery::Builder] YqlQuery::Builder instance reflecting the tail filter assigned.
    #
    # @example The tail argument may be passed as either a string or fixnum:
    #   base = Builder.new.tail(5)
    #   base = Builder.new.tail('5')
    def tail(tail)
      self.query.tail = tail
      self
    end

    # Assigns the truncate argument for the query being constructed
    #
    # @param [Object] truncate The truncate argument for the query.
    # @return [YqlQuery::Builder] YqlQuery::Builder instance reflecting the truncate filter assigned.
    #
    # @example The truncate argument may be passed as either a string or fixnum:
    #   base = Builder.new.truncate(5)
    #   base = Builder.new.truncate('5')
    #   base.to_s
    #   # => "select * from tablename | truncate(5)"
    def truncate(truncate)
      self.query.truncate = truncate
      self
    end

    # Adds the reverse filter to the query being constructed
    #
    # @return [YqlQuery::Builder] YqlQuery::Builder instance reflecting the offset assigned.
    #
    # @example
    #   base = Builder.new.reverse
    #   base.to_s
    #   # => "select * from tablename | reverse"
    def reverse
      self.query.reverse = true
      self
    end

    # Assigns the unique argument for the query being constructed
    #
    # @param [Object] truncate The unique argument for the query.
    # @return [YqlQuery::Builder] YqlQuery::Builder instance reflecting the unique filter assigned.
    #
    # @example
    #   base = Builder.new.unique('genre')
    #   base.to_s
    #   # => "select * from tablename | unique(field='genre')"
    def unique(unique)
      self.query.unique = unique
      self
    end

    # Assigns the sanitize argument for the query being constructed
    #
    # @param [Object] sanitize The sanitize argument for the query.
    # @return [YqlQuery::Builder] YqlQuery::Builder instance reflecting the sanitize filter assigned.
    #
    # @example Sanitize accepts either a string representing the column name or a boolean 'true' to sanitize all
    #   base = Builder.new.sanitize('genre')
    #   base.to_s
    #   # => "select * from tablename | sanitize(field='genre')"
    #
    #   base = Builder.new.sanitize(true)
    #   base.to_s
    #   # => "select * from tablename | sanitize()"
    def sanitize(sanitize=true)
      self.query.sanitize = sanitize
      self
    end

    # Returns the generated YQL query based on the arguments provided
    def to_s
      self.query.to_s
    end
    alias :to_query :to_s

  end
end