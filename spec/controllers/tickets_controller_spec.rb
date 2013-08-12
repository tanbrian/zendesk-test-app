require 'spec_helper'

describe TicketsController do

  describe '#create' do
    let(:ticket) { double('ZendeskAPI::Ticket', id: 1) }
    let(:user) { FactoryGirl.create(:user) }

    context 'when signed in' do
      before { controller.instance_variable_set :@current_user, user }

      context 'with valid information' do
        before do
          ZendeskAPI::Ticket.stub(:create).and_return ticket
          post :create
        end

        specify { response.should redirect_to '/tickets/1' }
        specify { flash[:success].should_not be_nil }
      end

      context 'with invalid information' do
        before do 
          controller.stub(:ticket_valid?).and_return false
          post :create
        end

        specify { response.should render_template :new }
        specify { flash[:error].should_not be_nil }
      end
    end

    context 'when not signed in' do
      before do
        ZendeskAPI::Ticket.stub(:create).and_return ticket
        post :create
      end

      specify { response.should redirect_to signin_path }
    end
  end
end