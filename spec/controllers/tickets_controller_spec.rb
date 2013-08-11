require 'spec_helper'

describe TicketsController do

  let(:ticket) { double('ZendeskAPI::Ticket', id: 1) } 

  describe '#create' do

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

  describe '#index' do
    it 'renders the tickets page' do
      get :index
      response.should be_success
    end
  end
end