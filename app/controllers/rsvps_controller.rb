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
      if !event.is_private
        head :forbidden
      elsif user_id == current_user.id
        head :bad_request
      else
        # valid case 1. current user == organizer AND event is private AND user != organizer: cross-ref EventRequests (accepting RSVP request)
        request = EventRequest.find_by(user_id: user_id, event_id: event.id)
        if request != nil
          rsvp = Rsvp.new(user_id: user_id, event_id: event.id)
          requestee = User.find(request.user_id)
          if request.destroy && rsvp.save
            flash[:notice] = "You have accepted #{requestee.username}'s request to join #{event.title}!"
            redirect_to event_path(id: event.id)
          else
            flash.now[:error] = "Failed to accept #{requestee.username}' request to join #{event.title}"
          end
        else
          head :bad_request
        end
      end
    elsif current_user.id == user_id
      if event.is_private
        # valid case 2. current user != organizer AND current user id matches user_id AND event is private (accepting Event Invitation)
        invitation = EventInvitation.find_by(user_id: user_id, event_id: event.id)
        if invitation != nil
          rsvp = Rsvp.new(user_id: user_id, event_id: event.id)
          if invitation.destroy && rsvp.save
            flash[:notice] = "You have accepted #{event.organizer.username}'s invitation to join #{event.title}!"
            redirect_to event_path(id: event.id)
          else
            flash.now[:error] = "Failed to accept #{event.organizer.username}' invitation to join #{event.title}"
          end
        else
          head :bad_request
        end
      else
        # valid case 3. current user != organizer AND current user id matches user_id AND event is public (open RSVP)
        rsvp = Rsvp.new(user_id: user_id, event_id: event.id)
        if rsvp.save
          flash[:notice] = "You have RSVP'd for #{event.title}!"
          redirect_to event_path(id: event.id)
        else
          flash.now[:error] = "Failed to RSVP for #{event.title}"
        end
      end
    else
      head :bad_request
    end

  end

  def destroy
    user_id = params[:user_id].to_i # url params parse as strings by default
    event_id = params[:event_id].to_i
    user = User.find(user_id)
    event = Event.find(event_id)

    rsvp = Rsvp.where(event_id: event_id, user_id: user_id)
    rsvp.delete_all
    if user_id = current_user.id
      flash[:notice] = "You have removed yourself from #{event.title}"
    else
      flash[:notice] = "#{user.username} has been removed from #{event.title}"
    end
    redirect_to event_path(id: event_id), status: :see_other
  end

  private
  def authorize_user
    user_id = params[:user_id].to_i
    event = Event.find(params[:event_id]) 
    if ! (current_user.id == event.organizer_id && event.is_private || current_user.id == user_id)
      flash[:error] = "You are not permitted to delete another person's RSVP status"
      redirect_to "/", status: :see_other
    end
  end
end
