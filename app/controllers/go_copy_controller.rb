class GoCopyController < ApplicationController
	def trash
		puts 'trash controller'
		puts GoLinkCopy.all.length
		puts 'that was teh number of copies'
		puts myEmail
		viewable = GoLinkCopy.can_view(myEmail)
		puts viewable
		puts 'those were vieable'
		@copies = GoLinkCopy.where('id in (?)', viewable)
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
