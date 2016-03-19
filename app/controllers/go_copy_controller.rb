class GoCopyController < ApplicationController
	def trash
		@copies = GoLinkCopy.where('id in (?)', GoLinkCopy.can_view(myEmail))
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
