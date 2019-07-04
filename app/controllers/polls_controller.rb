class PollsController < ApplicationController
  def create
  end

  def new
  end

  def index
    @new_poll = Poll.new
  end
end
