require 'spec_helper'

feature 'signup' do 
  background { visit signup_path } 

  given(:submit) { 'Create Account' }

  scenario 'with valid information' do
    fill_in 'Name', with: 'Test User'
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: 'foobar'
    fill_in 'Password Confirmation', with: 'foobar'

    expect { click_button submit }.to change(User, :count).by(1)
    expect(page).to have_content 'Help Center'
  end

  scenario 'with invalid information' do
    expect { click_button submit }.not_to change(User, :count).by(1)    
    expect(page).to have_content 'error'
    expect(page).to have_selector 'div.alert.alert-error'
  end
end

feature 'signin' do
  given(:submit) { 'Sign in' }
  given(:user) { FactoryGirl.create(:user) }

  background do
    visit signin_path
    user.save
  end

  scenario 'with valid information' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button submit

    expect(page).to have_selector 'div.alert.alert-success'
    expect(page).to have_content 'Help Center'
  end

  scenario 'with invalid information' do
    click_button submit 
    expect(page).to have_selector 'div.alert.alert-error'
  end
end