# frozen_string_literal: true

require 'spec/rails_helper.rb'
require 'rspec/rails'
# note: require 'devise' after require 'rspec/rails'
require 'devise'

# RSpec.configure do |config|
#   # For Devise > 4.1.1
#   config.include Devise::Test::ControllerHelpers, :type => :controller
#   # Use the following instead if you are on Devise <= 4.1.1
#   # config.include Devise::TestHelpers, :type => :controller
# end

RSpec.describe PostController, type: :controller do
  login_admin

# describe 'GET #index' do
#   subject { get :index }

  it "should get index" do
    # Note, rails 3.x scaffolding may add lines like get :index, {}, valid_session
    # the valid_session overrides the devise login. Remove the valid_session from your specs
    get 'index'
    response.should be_success
  end
end
