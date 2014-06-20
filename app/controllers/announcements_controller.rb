class AnnouncementsController < ApplicationController
  load_and_authorize_resource
  before_filter :set_current_announcement, :only => [:edit, :update, :destroy]

  # ------------- before filter methods ------------- #
  def set_current_announcement
    @announcement = Announcement.find(params[:id])
  end
  # ------------- end before filter methods ------------- #

  def hide
    ids = [params[:id], *cookies.signed[:hidden_announcement_ids]]
    cookies.permanent.signed[:hidden_announcement_ids] = ids
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def index
    @announcements = Announcement.all
  end

  def new
    @announcement = Announcement.new({:starts_at => Date::today, :ends_at => Date::today})
  end


  def create
    parse_time
    @announcement = Announcement.new(params[:announcement])
    if @announcement.save
      redirect_to(announcements_url, :notice => 'Announcement was successfully created.')
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    parse_time
    if  @announcement.update_attributes(params[:announcement])
      redirect_to(announcements_url, :notice => 'Announcement was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @announcement.destroy(:force)
    redirect_to(announcements_url)
  end

  private
  def parse_time
    params[:announcement][:starts_at] = Date.strptime(params[:announcement][:starts_at],'%m/%d/%Y')
    params[:announcement][:ends_at] = Date.strptime(params[:announcement][:ends_at],'%m/%d/%Y')
  end
end