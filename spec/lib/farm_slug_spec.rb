require 'spec_helper'

describe 'FarmSlugs' do
  #FarmSlugs is provided through a monkey patch on ActiveRecord::Base
  let(:fso){ FactoryGirl.build :farm_slug_object }
  let(:fso_alt){ FactoryGirl.build :farm_slug_object_alt }

  describe '#use_farm_slugs' do

    describe 'Validations' do
      # it 'should validate presence of :id_method' do
        # fso.name = nil
        # fso.valid?
        # fso.errors.messages[:name].include?("can't be blank").should == true
      # end
    end #end Validations

    it 'should save a parameterized version of :id_method to the :slug_method attribute' do
      fso.name = 'Farm Slug Test Name'
      fso.save
      fso.slug.should == 'farm-slug-test-name'
      fso.slug.should == 'Farm Slug Test Name'.parameterize
    end

    it 'should append the :id, if identical names are used' do
      test_name = 'Farm Slug Test Name'
      fso.name = test_name
      fso.save

      new_fso = FarmSlugObject.new name: test_name.upcase
      new_fso.save
      fso.slug.should_not == new_fso.slug
      new_fso.slug.should == "#{fso.slug}_#{new_fso.id}"
    end

    it 'should not append :id on update' do
      fso.save
      old_slug = fso.slug
      fso.save
      fso.slug.should == old_slug
    end

    it 'should change :slug if :name gets changed' do
      fso.save
      new_name = 'A new name for this funny object'
      fso.name = new_name
      fso.save
      fso.slug.should == new_name.parameterize
    end
    
    specify 'if no name is passed, the slug should save as [object_class_name]_[object.id]' do
      fso.name = nil
      fso.save
      fso.slug.should == "farm-slug-object_#{fso.id}"
    end
    
    specify 'name method value gets truncated at 100 characters' do
      n = Faker::Lorem.characters(character_count = 100) 
      fso.name = n
      fso.save!
      fso.slug.should == n.parameterize
      
      fso.name = "#{n}xxx"
      fso.save!
      fso.slug.should == "#{n.parameterize}_#{fso.id}"
    end
    
    describe 'Alternate Method Names' do
      it 'should work as expected if alternate method names are passed with use_farm_slugs' do
        # Alternate method names are set up in farm_slug_object_alt. They are "title" and "url_slug"
        fso_alt.title = "A title goes here"
        fso_alt.save
        fso_alt.url_slug.should == fso_alt.title.parameterize
        fso_alt.url_slug.should == 'a-title-goes-here'
      end
      
    end
  end #end use_farm_slugs

  describe 'ActiveRecord method overrides' do
    let(:name){ 'ActiveRecord method overrides object name' }
    before(:each) do
      fso.name = name
      fso.save
    end

    describe '#to_param' do
      it 'should return the slug' do
        fso.to_param.should == name.parameterize
      end
    end

    describe '#find(slug/val)' do
      it 'should find the object by slug' do
        FarmSlugObject.find('ActiveRecord method overrides object name'.parameterize).should == fso
      end

      it 'should raise a record not found error if the slug does not match a record' do
        expect{ FarmSlugObject.find('aklsfdji3n12`92imciis adf') }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'should find a record by id, if an integer is passed' do
        FarmSlugObject.find(fso.id).should == fso
      end
    end
  end

  describe 'Overriding Record name defaults' do
    it 'should not save a record with the name "new", but "new_RECORD_ID" instead' do
      fso.name = 'new'
      fso.save
      fso.slug.should_not == 'new'
      fso.slug.should == "new_#{fso.id}"
    end
    
    it "should not save a record name that has been reserved, but instead, append the record's id to it" do
      # The farm_slug_object_alt object has been set up with farm_slugs(:reserved_names => 'reserved')
      # fso alt also has altered slug and id methods
      fso_alt.title = 'reserved'  
      fso_alt.save
      fso_alt.url_slug.should_not == 'reserved'
      fso_alt.url_slug.should == "reserved_#{fso_alt.id}"
    end
    
    it "should not save a record name that ends in with '/edit' as a slug, but instead drops the slash" do
      fso.name = "A Name/edit"
      fso.save!
      # fso.slug.should == "a-name_edit_#{fso.id}"  
      fso.slug.should == "a-name-edit"  
    end
    
    specify "similarly for '/edit/" do
      fso.name = "A Name/edit/"
      fso.save!
      fso.slug.should == "a-name-edit"
      # fso.slug.should == "a-name_edit_#{fso.id}"
    end
        
    it "should NOT save a record name as a slug that is a simple integer. It should save as integer_RECORD_ID" do
      fso.name = "12345"
      fso.save!
      fso.slug.should == "12345_#{fso.id}"      
    end
    
    it "should save normally, if name begins with an integer, but contains letters too" do
      fso.name = "12345 String"
      fso.save!
      fso.slug.should == "12345-string"
    end
    
    it "should save normally a name that ends in an integer" do
      fso.name = "String 12345"
      fso.save!
      fso.slug.should == 'string-12345'
    end
  end


  before(:each) do
    #fso.class_eval{ use_farm_slugs }
  end
end


