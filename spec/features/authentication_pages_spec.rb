require 'spec_helper'

describe 'authentication' do

  subject { page }

  describe 'signin' do
    before { visit signin_path }

    it { should have_content 'Sign in' }
    it { should have_title 'Sign in' }

    context 'with invalid information' do
      before { click_button 'Sign in' }
      it { should have_content 'Invalid email/password combination' }
      it { should have_title 'Sign in' }

      context 'then moving to another page' do
        before { visit root_path }
        it { should_not have_content 'Invalid email/password combination' }
      end
    end

    context 'with valid information' do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Sign in'
      end

      it { should have_content 'Help Center' }
      it { should have_content 'Signed in.' }
    end
  end
end