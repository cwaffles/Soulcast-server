require 'rails_helper'

RSpec.describe SoulsController, type: :controller do
	before(:each) do
    DatabaseCleaner.clean_with(:truncation, reset_ids: true)
		@dev1 = Device.create(token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
													latitude: 50,
													longitude: -100,
													radius: 20.0)

		@dev2 = Device.create(token: "30d89b9620d59f88350af570e7349472d8e02e54367f41825918e054fde792ad",
													latitude: 50,
													longitude: -100,
													radius: 20.0)

		@dev3 = Device.create(token: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
													latitude: 25,
													longitude: -100,
													radius: 20.0)

		@dev4 = Device.create(token: "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB",
													latitude: 75,
													longitude: -100,
													radius: 20.0)

		@dev5 = Device.create(token: "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC",
													latitude: 60,
													longitude: -100,
													radius: 20.0)
  end

	context 'does end to end transmission' do
		before(:all) do
			# @device1 = Device.new(long, lat, rad ...)
			# @device2 = Device.new(long, lat, rad ...)
		end
		xit 'when casting a soul within mutual radius of another' do
			# device1.radius = ...
			# device2.radius = ...
			# someSoul = Soul.new(device: device1, ...)
			# someSoul.save!
			# expect(device2.whatever).to_be not_nil ...
		end
		xit 'when casting a soul NOT within mutual radius of another' do

		end
	end
	context 'Nearby' do
		xit 'two devices are within mutual radius' do
			# expect(device1.nearby)=1
			# expect(device2.nearby)=1
		end
		xit 'three devices are within mutual radius' do
			# expect(device1.nearby)=2
			# expect(device2.nearby)=2
			# expect(device2.nearby)=2
		end
		xit 'No three devices are within mutual radius' do
			# expect(device1.nearby)=0
			# expect(device2.nearby)=0
			# expect(device2.nearby)=0
		end
		xit 'One device are within mutual radius' do
			# expect(device1.nearby)=0
		end
	end
end
