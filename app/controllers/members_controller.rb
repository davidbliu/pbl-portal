class MembersController < ApplicationController

  before_filter :is_logged_in, :only=> [:edit_profile]
  def officer
    
  end

  def index
    @members = Member.current_members
      .where.not(committee:'GM')
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

      # save it in clicks
      Thread.new{
        GoLinkClick.create(
          key: '/tabling',
          golink_id: 'tabling_id',
          member_email: myEmail
        )
        ActiveRecord::Base.connection.close
      }
    
    else
      redirect_to '/auth/google_oauth2'
    end
  end

  

end
