
describe SoulsController do
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
