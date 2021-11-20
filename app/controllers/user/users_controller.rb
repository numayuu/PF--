class User::UsersController <

  private
    def user_params
      params.require(:user).permit(:name,:profile_id,:introduction)
    end
end
