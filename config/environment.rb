# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Loads Zendesk environment variables
zendesk = File.join Rails.root, 'config', 'zendesk.rb'
load(zendesk) if File.exists?(zendesk)

# Initialize the Rails application.
ZendeskTestApp::Application.initialize!
