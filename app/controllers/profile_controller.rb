class ProfileController < ApplicationController
	def edit_profile
    # @member = Member.where(email: params[:email]).first
    @member = current_member
  end

  def index
    @profiles = Profile.all
    @email_hash = Member.all.index_by(&:email)
  end

  def update
    if params[:id]
      @profile = Profile.find(params[:id])
    else
      @profile = Profile.new
    end
    @profile.name = params[:name]
    render nothing: true, status: 200
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def new
    @profile = Profile.new
    render :edit
  end

  def show
    @profile = Profile.find(params[:id])
    render :show, layout: false
  end

  def profile
  end

  def get_project
    @project = Project.where(name: params[:name]).first
    if @project == nil
      redirect_to :back
    else
      @email_hash = Member.all.index_by(&:email)
      render :template => 'profile/get_project'
    end
  end

  def projects
  	@projects = Project.all
  end

  def position
  	@position = params[:position]
  	
  end
end
