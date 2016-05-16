class Admin::StaffMembersController < Admin::AdminController
  before_action :load_resource, only: [:edit, :update, :destroy]

  def index
    @staff_members = StaffMember.all
  end

  def new
    @staff_member = StaffMember.new
  end

  def create
    @staff_member = StaffMember.new(staff_member_params)

    if @staff_member.save
      redirect_to :admin_staff_members, notice: t('.success')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @staff_member.update_attributes(staff_member_params)
      redirect_to :admin_staff_members, notice: t('.success')
    else
      render :edit
    end
  end

  def destroy
    @staff_member.destroy
    redirect_to :admin_staff_members, notice: t('.success')
  end

  private
    def load_resource
      @staff_member = StaffMember.find(params[:id])
    end

    def staff_member_params
      params.require(:staff_member).permit(:bio, :first_name, :last_name, :position, :department, :image_file, :staff_type, :order)
    end
end
