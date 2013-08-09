require 'spec_helper'

describe 'ticket pages' do

  subject { page }

  describe 'new ticket page' do
    before do 
      visit root_path
      fill_in 'Name', with: 'Billybob Joe'
      fill_in 'Email', with: 'user@test.com'
      fill_in 'Subject', with: 'Oh no!'
      fill_in 'Issue', with: 'My computer spontaneously blew up!'
      click_button 'Create Ticket'
    end

    it { should have_content('Ticket created.') }
  end
end