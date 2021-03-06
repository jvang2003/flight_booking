# == Schema Information
#
# Table name: frequent_fliers
#
#  id         :integer          not null, primary key
#  airline_id :integer
#  discount   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe FrequentFlier do
	let(:airline) {FactoryGirl.create(:airline, :set_name => "Virgin America")}
	let(:client) {FactoryGirl.create(:client, :set_name => "Tester")}
	let(:frequentflier) {FactoryGirl.create(:frequent_flier, airline: airline, set_discount: 5)}

	subject{frequentflier}

	it {should respond_to(:airline)}
	it {should respond_to(:discount)}
	it {should respond_to(:clients)}

	it {should be_valid}

	describe "Associations: " do
		let!(:frequent_flier_membership) {FactoryGirl.create(:frequent_flier_client, client: client, set_frequent_flier_id: frequentflier.id)}
		
		it "should have an airline with the name Virgin America" do
			frequentflier.airline.name.should match "Virgin America"
		end

		it "should have a client with the name Tester" do
			frequentflier.clients[0].name.should match "Tester"
		end
	end

	describe "Validations: " do
		describe "it should validate that airline_id is present" do
			before {frequentflier.airline_id = nil}
			it {should_not be_valid}
		end

		describe "it should validate that discount is present" do
			before {frequentflier.discount = nil}
			it {should_not be_valid}
		end
	end
end
