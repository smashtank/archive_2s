require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class Item < ActiveRecord::Base
  archive_2s :method_name => :archive_value

  def to_s
    "to_s"
  end

  def archive_value
    name
  end
end

class Thing < ActiveRecord::Base
  archive_2s :include_by_default => true

  def to_s
    name
  end
end

describe Archive2s do
  it "should archive when item is destroyed" do
    thing_one = Thing.create(:name => 'Thing One', :description => 'foo')
    id = thing_one.id
    thing_one.destroy
    archive = ::Archive2s::Model.last
    archive.model_type.should == 'Thing'
    archive.model_id.should == id
  end

  it "find_archived should fetch only archived items" do
    item_one = Item.create(:name => 'Item One', :description => 'foo')
    item_two = Item.create(:name => 'Item Two', :description => 'bar')
    ids = [item_one.id, item_two.id]
    item_two.destroy
    Item.find_archived(ids.last).should be_an_instance_of(Item)
  end

  it "find_archived should raise an error if it can't find an id" do
    lambda {Item.find_archived(999)}.should raise_error(ActiveRecord::RecordNotFound)
  end

  it "find_archived should raise an error if it can't find even one of the ids" do
    item_one = Item.create(:name => 'Item One', :description => 'foo')
    item_two = Item.create(:name => 'Item Two', :description => 'bar')
    ids = [item_one.id, item_two.id]
    item_two.destroy
    lambda {Item.find_archived(ids)}.should raise_error(ActiveRecord::RecordNotFound)
  end

  describe "include by default" do
    it "should return archived results when true" do
      thing_one = Thing.create(:name => 'Thing One', :description => 'foo')
      thing_two = Thing.create(:name => 'Thing Two', :description => 'bar')
      ids = [thing_one.id, thing_two.id]
      thing_two.destroy
      things = Thing.find(ids)

      things.length.should == 2
      things.collect(&:id).include?(ids.last).should be_true
    end

    it "should not return archived result when false" do
      item_one = Item.create(:name => 'Item One', :description => 'foo')
      item_two = Item.create(:name => 'Item Two', :description => 'bar')
      ids = [item_one.id, item_two.id]
      item_two.destroy
      lambda {Item.find(ids)}.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  it "should archive the default to_s" do
    thing_one = Thing.create(:name => 'Thing One', :description => 'foo')
    t_to_s = thing_one.to_s
    thing_one.destroy
    archived_thing = Thing.find_archived(thing_one.id)
    archived_thing.to_s.should == t_to_s
  end

  it "should archive a specified method" do
    item_one = Item.create(:name => 'Item One', :description => 'foo')
    i_to_s = item_one.archive_value
    item_one.destroy
    archived_thing = Item.find_archived(item_one.id)
    archived_thing.archive_value.should == i_to_s
  end

  it "should return a readonly AR model" do
    item_one = Item.create(:name => 'Item One', :description => 'foo')
    item_one.destroy
    archived_thing = Item.find_archived(item_one.id)
    archived_thing.readonly?.should be_true
  end

  #reload should do nothing, not sure how to test that though

end
