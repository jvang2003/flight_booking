require 'spec_helper'

describe "FlightPage" do

	let(:airline) {FactoryGirl.create(:airline, :set_name => "Virgin America")}
	let(:airport1) {FactoryGirl.create(:airport, :set_name => "San Francisco International Airport")}
	let(:airport2) {FactoryGirl.create(:airport, :set_name => "Los Angeles International Airport")}
	let(:flight) {FactoryGirl.create(:flight, airline: airline, set_destination_airport: airport2.id, set_origin_airport: airport1.id, set_number: 202, set_bus_fare: 500, set_eco_fare: 250)}
	let!(:plane) {FactoryGirl.create(:plane, flight: flight)}

	subject {page}

	before do
		visit root_path	
	end

	
	describe "drop down box" do
		it "should have a div of class dropdowns" do
			should have_selector('div.dropdowns')
		end

		it "should contain a select with id 'airline_select'" do
			should have_selector('select#airline_select')
		end

		it "should contain a select with id 'origin_select'" do
			should have_selector('select#origin_select')
		end

		it "should contain a select with id 'dest_select'" do
			should have_selector('select#dest_select')
		end

		it "should contain a select with id 'price_select'" do
			should have_selector('select#price_select')
		end

		it "should contain an input with id 'select_date'" do
			should have_selector('input#select_date')
		end

		it "should contain a select with id 'min_seats'" do
			should have_selector('select#min_seats')
		end
	end

	describe "airline_select" do
		it "should contain a default option for 'all airlines'" do
			page.has_select?('airline_select', :with_options => ['All Airlines'])
		end

		it "should contain an option for each airline" do
			page.has_select?('airline_select', :with_options => [airline.name])
		end
	end

	describe "flight table" do
		it "should contain a div with id 'flight_table'" do
			should have_selector('div#flight_table')
		end

		it "should render _flight_table" do
			should have_selector('tbody#flight_table_tbody')
		end

		describe "table head" do
			it "should have a th with id 'airline'" do
				should have_selector('th#airline')
			end

			it "should have a th with id 'origin'" do
				should have_selector('th#origin')
			end

			it "should have a th with id 'destination'" do
				should have_selector('th#destination')
			end

			it "should have a th with id 'departure_info'" do
				should have_selector('th#departure_info')
			end

			it "should have a th with id 'arrival_info'" do
				should have_selector('th#arrival_info')
			end

			it "should have a th with id 'seats_avail'" do
				should have_selector('th#seats_avail')
			end

			it "should have a th with id 'price'" do
				should have_selector('th#price')
			end

			it "should have a th with id 'reservation_column'" do
				should have_selector('th#reservation_column')
			end
		end

		describe "table rows" do
			it "should have a tr with id 'flight0'" do
				should have_selector('tr#flight0')
			end

			it "should have a td with id '0airline' and text of Virgin America" do
				should have_selector('td#0airline', text: 'Virgin America')
			end

			it "should have a td with id '0origin' and text of San Francisco International Airport" do
				should have_selector('td#0origin', text: 'San Francisco International Airport')
			end

			it "should have a td with id '0destination' and text of Los Angeles International Airport" do
				should have_selector('td#0destination', text: 'Los Angeles International Airport')
			end

			it "should have a td with id '0departure_info' and text matching @time_now + 1" do
				should have_selector('td#0departure_info', text: '2013-02-03 17:05:06 UTC')
			end

			it "should have a td with id '0arrival_info' and text matching @time_now + 5 hours" do
				should have_selector('td#0arrival_info', text: '2013-02-03 21:05:06 UTC')
				#should have_selector('td#0arrival_info', text: (@time_now+(5/24.0)).to_time.ctime)
			end

			it "should have a td with id '0seats_avail and text of '162'" do
				should have_selector('td#0seats_avail', text: 162)
			end

			it "should have a td with id '0price' and text of '250'" do
				should have_selector('td#0price', text: 250)
			end


			describe "when economy seats aren't available but business are" do

				before do
					flight.eco_avail = 0
					flight.save
					visit root_path
				end

				it "should list the lowest price based on seats availability" do
					should have_selector('td#0price', text: 500)
				end
			end

			it "should have a td with id '0reservation' and reservation button" do
				should have_selector('td#0reservation')
				should have_selector('td#0reservation button.btn', text: "Reserve Flight")
			end
		end
	end
end