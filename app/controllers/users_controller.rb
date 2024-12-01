class UsersController < ApplicationController

  def create
    user = User.new(user_params)
    if user.save
      flash[:notice] = "Thanks for signing up, #{user.username}!"
      redirect_to new_user_session_path
    else
      msg = "Some error occurred when saving your account:"
      user.errors.full_messages.each do |error|
        # TODO newlines aren't rendering properly in the flash messages. 
        msg += "\n#{error}"
      end
      flash[:error] = msg
      redirect_to new_registration_path(user)
    end
  end

  def show
    @user = User.find_by(username: params[:username])
    @events = @user.organized_events;
    #@events = Event.where(organizer_id: @user.id)
  end

  private
  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end
end
