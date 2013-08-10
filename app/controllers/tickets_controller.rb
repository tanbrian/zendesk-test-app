require 'zendesk_api'
require 'json'

class TicketsController < ApplicationController

  def new
  end

  def create
    options = { subject: params[:subject], comment: { value: params[:issue] }, 
                requester: params[:email], priority: 'normal' }
    if ticket_valid? options
      flash[:success] = 'Ticket created.'
      @ticket = ZendeskAPI::Ticket.create(client, options)
      redirect_to ticket_path(@ticket.id)
    else
      flash[:error] = 'Something went wrong. Try again.'
      redirect_to root_url
    end
  end

  def index
    @tickets = client.tickets.fetch!(reload: true)
  end

  def show
    @id = params[:id]
    @ticket = ZendeskAPI::Ticket.find(client, id: @id)
    @comments = client.requests.find(id: @id).comments
    @users = client.users
  end

  def update
    @comment = params[:comment]
    @request = client.requests.find(id: params[:id]) 
    @request.comment = { body: @comment }
    @request.save 
    redirect_to ticket_path(id: params[:id])
  end 

  private

  def ticket_valid?(values)
    values.has_value?('') ? false : true
  end
end