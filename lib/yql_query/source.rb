module YqlQuery

  # A class used by {Builder} to store additional data sources.
  class Source
    attr_accessor :source, :as

    def initialize(source, as)
      @source = source
      @as = as
    end

    # Sources are equal if both their 'source' and 'as' attributes are equivalent.
    def ==(b)
      self.source == b.source && self.as == b.as
    end
  end
end