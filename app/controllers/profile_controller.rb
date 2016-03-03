class ProfileController < ApplicationController
	def edit_profile
    # @member = Member.where(email: params[:email]).first
    @member = current_member
  end

  def index
    @profiles = Profile.all
    @email_hash = Member.all.index_by(&:email)
  end

  def update_profile
    # TODO: validate data
    @member = Member.where(email: params[:email]).first
    puts @member.name
    puts 'that was the member'
    puts params
    puts 'those were the params'
    render nothing: true, status: 200
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
