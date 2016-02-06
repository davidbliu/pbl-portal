class MembersController < ApplicationController


  def index
    @members = Member.where(latest_semester: Semester.current_semester)
      .sort_by{|x| x.committee}
  end

  def update
    render json: params
  end

  def update_commitments
    if current_member
      mem = Member.find(current_member.id)
      mem.commitments = params[:hours].map{|x| x.to_i}
      mem.save!
      render json: mem.commitments
    else
      redirect_to '/auth/google_oauth2'
    end
  end

  def me
    if current_member and current_member.email
      @me = current_member
    else
      redirect_to '/auth/google_oauth2'
    end
  end



end
