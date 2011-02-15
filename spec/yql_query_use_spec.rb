require File.expand_path('../spec_helper', __FILE__)

describe YqlQuery::Use do
  before(:each) do
    @use_case = YqlQuery::Use.new('http://geodata.org/table.xml', 'geodata')
  end

  it "should be equivalent if both the source and as are equal" do
    @use_case.should == YqlQuery::Use.new('http://geodata.org/table.xml', 'geodata')
  end
end