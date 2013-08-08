require 'zendesk_api'
require 'json'

class TicketsController < ApplicationController

  def new
  end

  def create
    options = { subject: params[:subject], comment: { value: params[:issue] }, 
                requester: params[:email], priority: 'normal' }
    @ticket = ZendeskAPI::Ticket.create(client, options)
  end

  def index
    @tickets = client.tickets.fetch! reload: true
  end

end