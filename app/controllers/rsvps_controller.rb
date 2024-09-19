class RsvpsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :authorize_user, only: :destroy

  def index
    @rsvps = Rsvp.where(event_id: params[:event_id])
  end

  # valid create cases:
  def create
    rsvp = nil
    event = Event.find(params[:event_id])
    user_id = params[:user_id].to_i # url params parse as strings by default

    if current_user.id == event.organizer_id
      if event.is_public
        head :forbidden
      elsif user_id == current_user.id
        head :bad_request
      else
        # valid case 1. current user == organizer AND event is private AND attendee != organizer: cross-ref EventRequests (accepting RSVP request)
      end
    elsif current_user.id == user_id
      if event.is_private
        # valid case 2. current user != organizer AND current user id matches user_id AND event is private (accepting Event Invitation)
      else
        # valid case 3. current user != organizer AND current user id matches user_id AND event is public (open RSVP)
        rsvp = Rsvp.new(attendee_id: user_id, event_id: event.id)
      end
    else
      head :bad_request
    end

    if rsvp != nil
      if rsvp.save
        flash[:notice] = "You have RSVP'd for #{event.title}!"
        redirect_to event_path(id: event.id)
      else
        flash.now[:error] = "Failed to RSVP for #{event.title}"
      end
    end
  end

  def destroy
    attendee_id = params[:user_id].to_i # url params parse as strings by default
    event_id = params[:event_id].to_i
    attendee = User.find(attendee_id)
    event = Event.find(event_id)

    rsvp = Rsvp.where(event_id: event_id, attendee_id: attendee_id)
    rsvp.delete_all
    if attendee_id = current_user.id
      flash[:notice] = "You have removed yourself from #{event.title}"
    else
      flash[:notice] = "#{attendee.username} has been removed from #{event.title}"
    end
    redirect_to event_path(id: event_id), status: :see_other
  end

  private
  def authorize_user
    attendee_id = params[:user_id].to_i
    event = Event.find(params[:event_id]) 
    if ! (current_user.id == event.organizer_id && event.is_private || current_user.id == attendee_id)
      flash[:error] = "You are not permitted to delete another person's RSVP status"
      redirect_to "/", status: :see_other
    end
  end
end
