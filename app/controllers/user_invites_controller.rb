class UserInvitesController < InheritedResources::Base

  private

    def user_invite_params
      params.require(:user_invite).permit(:inviter, :invited, :vk_id, :result, :status)
    end
end

