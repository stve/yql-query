require 'hashie/mash'

module YqlQuery

  class Query
    attr_accessor :table, :limit, :offset, :select, :use, :conditions
    attr_accessor :sort, :tail, :truncate, :reverse, :unique, :sanitize

    def initialize
      self.conditions = []
    end
  end

  class Builder

    attr_accessor :query

    def initialize(options={})
      self.query = Query.new
      self.query.table      = options.delete(:table)
      self.query.limit      = options.delete(:limit)
      self.query.offset     = options.delete(:offset)
      self.query.select     = options.delete(:select)
      self.query.conditions = options.delete(:conditions) || []
      self.query.tail       = options.delete(:tail)
      self.query.truncate   = options.delete(:truncate)
      self.query.reverse    = options.delete(:reverse)
      self.query.unique     = options.delete(:unique)
      self.query.sanitize   = options.delete(:sanitize)
    end

    def table(table)
      self.query.table = table
      self
    end

    def limit(limit)
      self.query.limit = limit
      self
    end

    def offset(offset)
      self.query.offset = offset
      self
    end

    def select(select)
      self.query.select = select
      self
    end

    def use(use)
      self.query.use = use
      self
    end

    def conditions(conditions)
      self.query.conditions << conditions
      self
    end
    alias :where :conditions

    def sort(sort)
      self.query.sort = sort
      self
    end

    def tail(tail)
      self.query.tail = tail
      self
    end

    def truncate(truncate)
      self.query.truncate = truncate
      self
    end

    def reverse
      self.query.reverse = true
      self
    end

    def unique(unique)
      self.query.unique = unique
      self
    end

    def sanitize(sanitize)
      self.query.sanitize = sanitize
      self
    end
    # @per_page                   = args[:per_page]


  end
end