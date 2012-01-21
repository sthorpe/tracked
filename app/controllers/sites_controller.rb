class SitesController < ApplicationController
  
  def index
    @sites = Site.find(:all, :order => "count").reverse
  end
  
  def update_sites
    @sites = Site.find(:all, :order => "count").reverse
    respond_to do |format|
	    format.html { render :layout => false }
	  end
  end
end
