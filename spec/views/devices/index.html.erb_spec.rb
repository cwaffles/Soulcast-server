require 'rails_helper'

RSpec.describe "devices/index", type: :view do
  before(:each) do
    assign(:devices, [
      Device.create!(
        :token => "Token",
        :latitude => 2.5,
        :longitude => 3.5,
        :radius => 4.5,
        :os => "Os"
      ),
      Device.create!(
        :token => "Token",
        :latitude => 2.5,
        :longitude => 3.5,
        :radius => 4.5,
        :os => "Os"
      )
    ])
  end

  it "renders a list of devices" do
    render
    assert_select "tr>td", :text => "Token".to_s, :count => 2
    assert_select "tr>td", :text => 2.5.to_s, :count => 2
    assert_select "tr>td", :text => 3.5.to_s, :count => 2
    assert_select "tr>td", :text => 4.5.to_s, :count => 2
    assert_select "tr>td", :text => "Os".to_s, :count => 2
  end
end
