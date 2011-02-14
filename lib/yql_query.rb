require 'hashie/mash'

module YqlQuery

  class Query
    attr_accessor :table, :limit, :offset, :select, :use, :conditions
    attr_accessor :sort, :tail, :truncate, :reverse, :unique, :sanitize

    def initialize
      self.conditions = []
    end

    def to_s
      [select_statement, conditions_statement, limit_offset_statement, filter_statement].join(' ').chomp(' ')
    end

    private
      def select_statement
        stmt = "select #{@select || '*'}"
        stmt << " from "
        stmt << @table if @table
        stmt
      end

      def conditions_statement
        @conditions.uniq.any? ? "where #{@conditions.uniq.join(' and ')}" : ""
      end

      def limit_offset_statement
        stmt = ''
        stmt << "limit #{@limit}" if @limit
        stmt << "offset #{@offset}" if @offset
        stmt
      end

      def filter_statement
        statements = []
        statements << "sort(field='#{@sort}')" if @sort
        statements << "tail(count=#{@tail})" if @tail
        statements << "truncate(count=#{@truncate})" if @truncate
        statements << "reverse()" if @reverse
        statements << "sanitize(field='#{@sanitize}')" if @sanitize
        statements.any? ? "| #{statements.join(' | ')}" : ''
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

    def to_s
      self.query.to_s
    end
    alias :to_query :to_s

  end
end