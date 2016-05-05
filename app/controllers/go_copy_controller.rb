class GoCopyController < ApplicationController
	def trash
		viewable = GoLinkCopy.can_view(myEmail)
		@copies = GoLinkCopy.includes(:groups).where('id in (?)', viewable)
	end

	def destroy
		GoLinkCopy.find(params[:id]).destroy
		redirect_to :back
	end
	def restore
		GoLinkCopy.find(params[:id]).restore
		redirect_to :back
	end
end
