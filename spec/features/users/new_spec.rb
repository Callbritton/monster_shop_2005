require 'rails_helper'

RSpec.describe "As a visitor" do

  it "I can register as a new user from a link in the nav bar" do
    visit '/merchants'

    within '.topnav' do
      click_on "Register"
    end

    expect(current_path).to eq("/register")

    fill_in :name, with: "Garrett James Drew-Chris"
    fill_in :address, with: "123 Main St."
    fill_in :city, with: "Denver"
    fill_in :state, with: "CO"
    fill_in :zip, with: "80444"
    fill_in :email, with: "us@turing.io"
    fill_in :password, with: "password"
    fill_in :password_confirmation, with: "password"

    click_on "Submit"

    expect(current_path).to eq("/profile")

    expect(User.count).to eq(1)
    expect(page).to have_content("You are now registered and logged in")
    expect(page).to have_content("Garrett James Drew-Chris")

  end

  it "Returns me to form if registration form is missing details" do
    visit '/merchants'

    within '.topnav' do
      click_on "Register"
    end

    expect(current_path).to eq("/register")

    fill_in :name, with: "Garrett James Drew-Chris"
    fill_in :address, with: "123 Main St."
    fill_in :city, with: "Denver"
    fill_in :state, with: "CO"
    fill_in :zip, with: ""
    fill_in :email, with: "us@turing.io"
    fill_in :password, with: "password"
    fill_in :password_confirmation, with: "password"

    click_on "Submit"

    expect(current_path).to eq("/register")

    expect(User.count).to eq(0)
    expect(page).to have_content("Error: Please fill in all required information, ensuring your password and confirmation match")

  end

  it "Returns me to form if registration form is missing details" do
    visit '/merchants'

    within '.topnav' do
      click_on "Register"
    end

    expect(current_path).to eq("/register")

    fill_in :name, with: "Garrett James Drew-Chris"
    fill_in :address, with: "123 Main St."
    fill_in :city, with: "Denver"
    fill_in :state, with: "CO"
    fill_in :zip, with: "80444"
    fill_in :email, with: "us@turing.io"
    fill_in :password, with: "passsword"
    fill_in :password_confirmation, with: "password"

    click_on "Submit"

    expect(current_path).to eq("/register")

    expect(User.count).to eq(0)
    expect(page).to have_content("Error: Please fill in all required information, ensuring your password and confirmation match")

  end

  it "does not accept duplicate email addresses" do
    visit '/merchants'

    within '.topnav' do
      click_on "Register"
    end

    expect(current_path).to eq("/register")

    fill_in :name, with: "Garrett James Drew-Chris"
    fill_in :address, with: "123 Main St."
    fill_in :city, with: "Denver"
    fill_in :state, with: "CO"
    fill_in :zip, with: "80444"
    fill_in :email, with: "us@turing.io"
    fill_in :password, with: "passsword"
    fill_in :password_confirmation, with: "password"

    click_on "Submit"

    expect(current_path).to eq("/register")

    expect(User.count).to eq(0)
    expect(page).to have_content("Error: Please fill in all required information, ensuring your password and confirmation match")

  end
end
