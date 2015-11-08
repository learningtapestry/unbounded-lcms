module Unbounded
  module Admin
    class UsersController < Unbounded::AdminController
      before_action :find_resource, except: [:index, :new, :create]

      def index
        @users = @organization.users.order(name: :asc).paginate(page: params[:page])
      end

      def new
        @user = User.new
      end

      def create
        User.transaction do
          @user = User.create_with(password: Devise.friendly_token.first(20))
                      .create(user_params)
          @user.add_to_organization(@organization)
          @user.add_role(@organization, Role.named(:admin))
          redirect_to(:unbounded_admin_users, notice: t('.success', user: @user.email))
        end
      rescue
        flash[:notice] = t('.error', user: @user.email)
        render :new
      end

      def edit
      end

      def update
        if @user.update_attributes(user_params)
          redirect_to(edit_unbounded_admin_user_path(@user),
            notice: t('.success', user: @user.email)
          )
        else
          render :edit
        end
      end

      def destroy
        @user.destroy
        redirect_to :unbounded_admin_users, notice: t('.success')
      end

      def reset_password
        @user.send_reset_password_instructions
        redirect_to :unbounded_admin_users, notice: t('.success')
      end

      private
        def find_resource
          @user = @organization.users.find(params[:id])
        end

        def user_params
          params.require(:content_models_user).permit(:name, :email)
        end
    end
  end
end
