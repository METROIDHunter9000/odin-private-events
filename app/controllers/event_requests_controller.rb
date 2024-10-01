class EventRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user, only: :create
  before_action :authorize_user_or_organizer, only: :destroy

  def create
    user_id = params[:user_id].to_i
    event_id = params[:event_id].to_i
    request = EventRequest.new(user_id: user_id, event_id: event_id)
    if request.save
      flash[:notice] = "Your event request has been submitted"
    else
      flash[:error] = "Failed to submit your event request!"
    end
    redirect_to event_path(id: event_id), status: :see_other
  end

  def destroy
    user_id = params[:user_id].to_i
    event_id = params[:event_id].to_i
    request = EventRequest.find_by(user_id: user_id, event_id: event_id)

    if request != nil && request.delete
      flash[:notice] = "The event join request was deleted"
      redirect_to event_path(id: event_id)
    else
      flash[:error] = "Failed to delete the request!"
    end
  end

  private
  def authorize_user_or_organizer
    event = Event.find(params[:event_id]) 
    if ! (current_user.id == event.organizer_id || current_user.id == params[:user_id].to_i)
      flash[:error] = "You are not permitted to delete another person's request to join"
      redirect_to "/", status: :see_other
    end
  end

  def authorize_user
    event = Event.find(params[:event_id]) 
    if current_user.id == event.organizer_id
      flash[:error] = "You are the organizer! You cannot request to join your own event!"
      redirect_to "/", status: :see_other
    elsif current_user.id != params[:user_id].to_i
      flash[:error] = "You are not permitted to create an event request for another user"
      redirect_to "/", status: :see_other
    end
  end
end
