class Admin::LeadershipPostsController < Admin::AdminController
  before_action :load_resource, only: [:edit, :update, :destroy]

  def index
    @leadership_posts = LeadershipPost.all.order_by_name_with_precedence
  end

  def new
    @leadership_post = LeadershipPost.new
  end

  def create
    @leadership_post = LeadershipPost.new(leadership_post_params)

    if @leadership_post.save
      redirect_to :admin_leadership_posts, notice: t('.success')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @leadership_post.update_attributes(leadership_post_params)
      redirect_to :admin_leadership_posts, notice: t('.success')
    else
      render :edit
    end
  end

  def destroy
    @leadership_post.destroy
    redirect_to :admin_leadership_posts, notice: t('.success')
  end

  private

  def load_resource
    @leadership_post = LeadershipPost.find(params[:id])
  end

  def leadership_post_params
    params.require(:leadership_post).permit(:dsc, :first_name, :last_name, :order, :school, :image_file)
  end
end
