require "rails_helper"

describe "as an employee" do
  before :each do
  @user = User.create(name: "Jim Bob",
    address: "2020 Whiskey River Blvd",
    city: "Bamaville",
    state: "AL",
    zip: "33675",
    email: "jimbobwoowoo@aol.com",
    password: "merica4lyfe",
    role: 1)
  end
  it 'does not allow default user to see admin dashboard index' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    visit "/admin"

    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
