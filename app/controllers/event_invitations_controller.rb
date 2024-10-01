class EventInvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_organizer, only: :create
  before_action :authorize_user_or_organizer, only: :destroy

  def create
    user_id = params[:user_id].to_i
    event_id = params[:event_id].to_i
    invitation = EventInvitation.new(event_id: event_id, user_id: user_id)
    if invitation.save
      flash[:notice] = "Your invitation has been submitted"
    else
      flash[:error] = "Failed to submit your invitation!"
    end
    redirect_to event_path(id: event_id), status: :see_other
  end

  def destroy
    user_id = params[:user_id].to_i
    event_id = params[:event_id].to_i
    invitation = EventInvitation.find_by(user_id: user_id, event_id: event_id)

    if invitation != nil && invitation.delete
      flash[:notice] = "The invitation was deleted"
      redirect_to event_path(id: event_id)
    else
      flash[:error] = "Failed to delete the invitation!"
    end
  end

  private
  def authorize_organizer
    event = Event.find(params[:event_id]) 
    if current_user.id != event.organizer_id
      flash[:error] = "You are not the event organizer! You cannot invite anyone!"
      redirect_to "/", status: :see_other
    end
  end

  def authorize_user_or_organizer
    event = Event.find(params[:event_id]) 
    if ! (current_user.id == event.organizer_id || current_user.id == params[:user_id].to_i)
      flash[:error] = "You are not permitted to delete another person's event invitation"
      redirect_to "/", status: :see_other
    end
  end
end
