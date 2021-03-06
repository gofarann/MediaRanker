class WorksController < ApplicationController
  def index
    @works = Work.all
    @albums = category_index("album")
    @books = category_index("book")
    @movies = category_index("movie")
  end

  def show
    @selected_work = Work.find_by id: params[:id]
    if !@selected_work
      render_404
    end
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.create work_params
    unless @work.id == nil
      case @work.category
      when "album"
        flash[:success] = "Successfully created album #{@work.id}."
        redirect_to albums_path
      when "movie"
        flash[:success] = "Successfully created movie #{@work.id}."
        redirect_to movies_path
      when "book"
        flash[:success] = "Successfully created book #{@work.id}."
        redirect_to books_path
      end
    else
      case @work.category
      when "album"
        flash.now[:error] = "A problem occured: Could not create album"
        render 'albums/new'
      when "movie"
        flash.now[:error] = "A problem occured: Could not create movie"
        render 'movies/new'
      when "book"
        flash.now[:error] = "A problem occured: Could not create book"
        render 'books/new'
      end
    end
  end

  def edit
    @work = Work.find params[:id]
  end

  def update
    @work = Work.find params[:id]
    #update should not change category
    @work.title = work_params[:title]
    @work.creator = work_params[:creator]
    @work.description = work_params[:description]
    @work.publication_year = work_params[:publication_year]

    if @work.save
      # flash[:success] = "Successfully created #{@work.category} #{@work.id}."
      redirect_to work_path #this needs to redirect to category path
    else
      # flash.now[:error] = "A problem occured: Could not update #{@work.category}"
      render "edit"
    end
  end

  def upvote
    work = Work.find_by_id params[:work_id]#this is one work object
    user = User.find_by_id session[:user_id] # this is one user object

    if session[:user_id] != nil
      if work.already_voted?(user) == true
        flash[:error] = "user has already voted for this work"
        redirect_to :back
      else
        @vote = Vote.create!(user_id:user.id, work_id:work.id)
        flash[:success] = "Successfully upvoted!"
        redirect_to :back
      end
    else
      flash[:error] = "You must log in to do that"
      redirect_to :back
    end
  end

  def destroy
    Work.destroy(params[:id])
    # flash[:success] = "Successfully destroyed #{@work.category} #{@work.id}."
    redirect_to works_path #this needs to be edited in the future to category path
  end
end



private

def work_params
  params.require(:work).permit(:category, :title, :creator, :description, :publication_year)
end



# #if user upvoting already voted, he/she cannot vote again
# user_vote_count = 0
# Vote.all.each do |vote|
#   if vote.work_id == @work.id && vote.user_id == @user.id
#     user_vote_count += 1
#   end
# end
#
# if user_vote_count











# def vote_params
#   params.require(:vote).permit(:user_id, :work_id)
# end
