module YqlQuery

  # The object underlying {Builder} which stores and generates the query.
  class Query
    attr_accessor :table, :limit, :offset, :select, :uses, :conditions
    attr_accessor :sort, :tail, :truncate, :reverse, :unique, :sanitize
    attr_accessor :sort_order

    def initialize
      self.conditions = []
      self.uses = []
    end

    # generates a query based on it's attributes
    def to_s
      [use_statement, select_statement, conditions_statement, limit_offset_statement, filter_statement].join(' ').squeeze(' ').strip
    end

    private
      def use_statement
        @uses.map { |use| "use #{use.source} as #{use.as};" }.join(' ')
      end

      def select_statement
        stmt = 'select '
        stmt << case @select
          when String
            @select
          when Array
            @select.join(', ')
          else
            '*'
        end
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
        if @sort
          if @sort_order && @sort_order[:descending]
            statements << "sort(field='#{@sort}', descending='true')"
          else
            statements << "sort(field='#{@sort}')"
          end
        end

        statements << "tail(count=#{@tail})" if @tail
        statements << "truncate(count=#{@truncate})" if @truncate
        statements << "reverse()" if @reverse
        statements << "unique(field='#{@unique}')" if @unique
        if @sanitize && @sanitize == true
          statements << "sanitize()"
        elsif @sanitize
          statements << "sanitize(field='#{@sanitize}')"
        end
        statements.any? ? "| #{statements.join(' | ')}" : ''
      end
  end
end