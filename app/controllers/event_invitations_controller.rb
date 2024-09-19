class EventInvitationsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :authorize_user, only: :destroy

  private
  def authorize_user
    event = Event.find(params[:event_id]) 
    if ! (current_user.id == event.organizer_id || current_user.id == params[:user_id])
      flash[:error] = "You are not permitted to delete another person's invitation to an event"
      redirect_to "/", status: :see_other
    end
  end
end
