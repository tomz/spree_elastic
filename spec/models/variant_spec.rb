require 'spec_helper'
require 'pry'

describe Spree::Variant do
  def update_index
    if Spree::Variant.__elasticsearch__.client.indices.exists(:index => 'spree-variants')
      Spree::Variant.__elasticsearch__.client.indices.delete(:index => 'spree-variants')
    end
    Spree::Variant.import
    sleep 3 # wait for elastic search
  end

  context "with a single variant" do
    let!(:variant) { create(:variant) }

    before { update_index }

    it "finds the variant" do
      search = Spree::Variant.elasticsearch(variant.sku)
      search.records.first.should == variant
      search.records.count.should == 1
    end
  end

  context "with two variants" do
    let!(:variant_1) { create(:variant, :sku => "R001") }
    let!(:variant_2) { create(:variant, :sku => "S001") }

    before { update_index }

    it "finds the variant" do
      search = Spree::Variant.elasticsearch(variant_1.sku)
      search.records.first.should == variant_1
      search.records.count.should == 1
    end
  end
end