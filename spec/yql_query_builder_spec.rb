require File.expand_path('../spec_helper', __FILE__)

describe YqlQuery::Builder do
  before(:each) do
    @builder = YqlQuery::Builder.new
  end

  describe "#table()" do
    it "should set the table" do
      @builder.table('music.artists')
      @builder.query.table.should == 'music.artists'
    end

    it "should return the builder" do
      @builder.table('music.artists').should be_kind_of(YqlQuery::Builder)
    end
  end

  describe "#limit()" do
    it "should set the limit" do
      @builder.limit(5)
      @builder.query.limit.should == 5
    end

    it "should return the builder" do
      @builder.limit(5).should be_kind_of(YqlQuery::Builder)
    end
  end

  describe "#offset()" do
    it "should set the offset" do
      @builder.offset(10)
      @builder.query.offset.should == 10
    end

    it "should return the builder" do
      @builder.offset(10).should be_kind_of(YqlQuery::Builder)
    end
  end

  describe "#select()" do
    it "should set the select" do
      @builder.select('name')
      @builder.query.select.should == 'name'
    end

    it "should accept select as an array" do
      @builder.select(['age', 'sex', 'language', 'other'])
      @builder.query.select.should == ['age', 'sex', 'language', 'other']
    end

    it "should return the builder" do
      @builder.select('name').should be_kind_of(YqlQuery::Builder)
    end
  end

  describe "#use()" do
    it "should set the use" do
      @builder.use('http://namedata.com', 'names')
      @builder.query.uses.include?(YqlQuery::Source.new('http://namedata.com', 'names')).should be_true
    end

    it "should return the builder" do
      @builder.use('http://namedata.com', 'names').should be_kind_of(YqlQuery::Builder)
    end
  end

  describe "#conditions()" do
    it "should set the conditions" do
      @builder.conditions("name = 'fred'")
      @builder.query.conditions.include?("name = 'fred'").should be_true
    end

    it "should return the builder" do
      @builder.conditions("name = 'fred'").should be_kind_of(YqlQuery::Builder)
    end

    it "should be aliased as #where()" do
      @builder.where("name = 'jeff'")
      @builder.query.conditions.include?("name = 'jeff'").should be_true
    end

    it "should store all conditions" do
      @builder.conditions("name = 'fred'")
      @builder.conditions("age = 22")
      @builder.query.conditions.include?("name = 'fred'").should be_true
      @builder.query.conditions.include?("age = 22").should be_true
    end

    it "should accept conditions as an array" do
      @builder.conditions(["name = 'greg'", "age = 34"])
      @builder.query.conditions.include?("name = 'greg'").should be_true
      @builder.query.conditions.include?("age = 34").should be_true
    end

    it "should accept conditions as a hash" do
      @builder.conditions({ :genre => 'jazz', :type => 'bebop'})
      @builder.query.conditions.include?("genre = 'jazz'").should be_true
      @builder.query.conditions.include?("type = 'bebop'").should be_true
    end
  end

  describe "#sort()" do
    it "should set the sort" do
      @builder.sort('nickname')
      @builder.query.sort.should == 'nickname'
    end

    it "should accept an optional hash to set the sort order" do
      @builder.sort('nickname', :descending => true)
      @builder.query.sort_order.should == { :descending => true }
    end

    it "should default the sort order to descending=false" do
      @builder.sort('nickname')
      @builder.query.sort_order.should == { :descending => false }
    end

    it "should return the builder" do
      @builder.sort('nickname').should be_kind_of(YqlQuery::Builder)
    end
  end

  describe "#tail()" do
    it "should set the tail" do
      @builder.tail(3)
      @builder.query.tail.should == 3
    end

    it "should return the builder" do
      @builder.tail(3).should be_kind_of(YqlQuery::Builder)
    end
  end

  describe "#truncate()" do
    it "should set the truncate option" do
      @builder.truncate(3)
      @builder.query.truncate.should == 3
    end

    it "should return the builder" do
      @builder.truncate(3).should be_kind_of(YqlQuery::Builder)
    end
  end

  describe "#reverse" do
    it "should set the reverse option" do
      @builder.reverse
      @builder.query.reverse.should be_true
    end

    it "should return the builder" do
      @builder.reverse.should be_kind_of(YqlQuery::Builder)
    end
  end

  describe "#unique()" do
    it "should set the unique option" do
      @builder.unique("Rating.AverageRating")
      @builder.query.unique.should == "Rating.AverageRating"
    end

    it "should return the builder" do
      @builder.unique("Rating.AverageRating").should be_kind_of(YqlQuery::Builder)
    end
  end

  describe "#sanitize()" do
    it "should set the unique option" do
      @builder.sanitize("Rating.Description")
      @builder.query.sanitize.should == "Rating.Description"
    end

    it "should default sanitize to true" do
      @builder.sanitize
      @builder.query.sanitize.should be_true
    end

    it "should return the builder" do
      @builder.sanitize("Rating.Description").should be_kind_of(YqlQuery::Builder)
    end
  end

  context "chaining" do
    it "should combine query options" do
      @builder.table('music.artists').limit(5).conditions("name = 'Jose James'")
      @builder.query.limit.should == 5
      @builder.query.table.should == 'music.artists'
      @builder.query.conditions.include?("name = 'Jose James'").should be_true
    end

  end

  describe "#to_s" do

    it "should return the generated query" do
      @builder.table('music.artists').limit(5).conditions("name = 'Jose James'")
      @builder.to_s.should == "select * from music.artists where name = 'Jose James' limit 5"
    end

    it "should be aliased as to_query" do
      @builder.table('music.artists').limit(5).conditions("name = 'Jose James'")
      @builder.to_s.should == @builder.to_query
    end

  end

  context "generating queries" do
    before(:each) do
      @builder.table('music.artists')
    end

    it "should generate ther right query when given a different data source to use" do
      @builder.conditions("name = 'Jose James'").use('http://musicbrainz.org/data.xml', 'musicBrainzArtists').table('musicBrainzArtists')
      @builder.to_s.should == "use http://musicbrainz.org/data.xml as musicBrainzArtists; select * from musicBrainzArtists where name = 'Jose James'"
    end

    it "should generate ther right query when given multiple data sources to use" do
      @builder.conditions("name = 'Jose James'").use('http://musicbrainz.org/data.xml', 'musicBrainzArtists').use('http://musicbrainz.org/albums.xml', 'musicBrainzAlbums').table('musicBrainzArtists')
      @builder.to_s.should == "use http://musicbrainz.org/data.xml as musicBrainzArtists; use http://musicbrainz.org/albums.xml as musicBrainzAlbums; select * from musicBrainzArtists where name = 'Jose James'"
    end

    it "should generate the right query when given a single condition" do
      @builder.conditions("name = 'Jose James'")
      @builder.to_s.should == "select * from music.artists where name = 'Jose James'"
    end

    it "should generate the right query when given multiple conditions" do
      @builder.conditions("name = 'Jose James'").conditions("genre = 'Jazz'")
      @builder.to_s.should == "select * from music.artists where name = 'Jose James' and genre = 'Jazz'"
    end

    it "should generate the right query when given a limit" do
      @builder.conditions("name = 'John'").limit(5)
      @builder.to_s.should == "select * from music.artists where name = 'John' limit 5"
    end

    it "should generate the right query when given an offset" do
      @builder.conditions("name = 'John'").offset(15)
      @builder.to_s.should == "select * from music.artists where name = 'John' offset 15"
    end

    it "should generate the right query when given a select" do
      @builder.conditions("name = 'John'").select('Title, First Name, Email')
      @builder.to_s.should == "select Title, First Name, Email from music.artists where name = 'John'"
    end

    it "should generate the right query when given a select as an array" do
      @builder.conditions("name = 'John'").select(['age', 'sex', 'language', 'other'])
      @builder.to_s.should == "select age, sex, language, other from music.artists where name = 'John'"
    end

    it "should generate the right query when given a sort" do
      @builder.sort('popularity')
      @builder.to_s.should == "select * from music.artists | sort(field='popularity')"
    end

    it "should generate the right query when given a sort descending" do
      @builder.sort('popularity', :descending => true)
      @builder.to_s.should == "select * from music.artists | sort(field='popularity', descending='true')"
    end

    it "should generate the right query when given a tail" do
      @builder.tail(5)
      @builder.to_s.should == "select * from music.artists | tail(count=5)"
    end

    it "should generate the right query when given a truncate" do
      @builder.truncate(5)
      @builder.to_s.should == "select * from music.artists | truncate(count=5)"
    end

    it "should generate the right query when given a reverse" do
      @builder.reverse
      @builder.to_s.should == "select * from music.artists | reverse()"
    end

    it "should generate the right query when given a unique" do
      @builder.unique('art')
      @builder.to_s.should == "select * from music.artists | unique(field='art')"
    end

    it "should generate the right query when given a sanitize" do
      @builder.sanitize('art')
      @builder.to_s.should == "select * from music.artists | sanitize(field='art')"
    end

    it "should generate the right query when given a sanitize all fields" do
      @builder.sanitize
      @builder.to_s.should == "select * from music.artists | sanitize()"
    end
  end

end