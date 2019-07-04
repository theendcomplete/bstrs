class MeetingsController < ApplicationController

  before_action :new, only: [:index, :create]

  def new
    @meeting = Vcommunity.new
    @meeting.community_type = 'event'
  end

  def index
    @meetings =  Vcommunity.where(user: current_user, community_type: 'event')
  end

  def create
    current_user.vcommunities << Vcommunity.find_or_create_by_addr(current_user, params['meeting']['address'])
  end

  def invite
  end

  private

  def meeting_params
    accessible = %i[name address]
    params.require(:meeting).permit(accessible)
  end
end
