module YqlQuery

  class Source
    attr_accessor :source, :as

    def initialize(source, as)
      @source = source
      @as = as
    end

    def ==(b)
      self.source == b.source && self.as == b.as
    end
  end
end