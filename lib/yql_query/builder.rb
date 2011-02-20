module YqlQuery

  class Builder

    attr_accessor :query

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

    def use(use, as)
      self.query.uses << Source.new(use, as)
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

    def sort(sort, options={:descending => false})
      self.query.sort = sort
      self.query.sort_order = options
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

    def sanitize(sanitize=true)
      self.query.sanitize = sanitize
      self
    end

    def to_s
      self.query.to_s
    end
    alias :to_query :to_s

  end
end