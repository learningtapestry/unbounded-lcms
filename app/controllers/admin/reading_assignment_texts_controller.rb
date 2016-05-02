class Admin::ReadingAssignmentTextsController < Admin::AdminController
  before_action :find_reading_assignment, except: [:index, :new, :create]

  def index
    @reading_assignment_texts = ReadingAssignmentText
      .order(name: :asc)
      .paginate(page: params[:page])
  end

  def new
    @reading_assignment_text = ReadingAssignmentText.new
  end

  def create
    @reading_assignment_text = ReadingAssignmentText.new(reading_assignment_text_params)
    if @reading_assignment_text.save
      redirect_to :admin_reading_assignment_texts, notice: t('.success')
    else
      render :new
    end
  end

  def edit
  end

  def update
    p = reading_assignment_text_params
    create_author_name = p.delete(:new_reading_assignment_authors)
    if create_author_name && create_author_name.size > 0 && create_author_name[0].present?
      new_author = ReadingAssignmentAuthor.create!(name: create_author_name[0])
      p[:reading_assignment_author_id] = new_author.id
    end

    if @reading_assignment_text.update_attributes(p)
      edit_path = edit_admin_reading_assignment_text_path(@reading_assignment_text)
      redirect_to edit_path, notice: t('.success')
    else
      render :edit
    end
  end

  def destroy
    @reading_assignment_text.destroy
    redirect_to :admin_reading_assignment_texts, notice: t('.success')
  end

  private
    def find_reading_assignment
      @reading_assignment_text = ReadingAssignmentText.find(params[:id])
    end

    def reading_assignment_text_params
      params.require(:reading_assignment_text).permit(
        :name,
        :reading_assignment_author_id,
        new_reading_assignment_authors: []
      )
    end
end
