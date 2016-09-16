class ArtworksController < ApplicationController
  skip_before_action :verify_authenticity_token, :if => Proc.new{|c| c.request.format=='application/json'}
  before_action :api_auth, :if => Proc.new{|c| c.request.format=='application/json'}
  
  def callback
    # put output file, identified by source fingerprint
    artwork = Artwork.find_by_source_fingerprint params[:source]
    unless artwork.nil?
      artwork.output = params[:output]
      artwork.save
      render json: {"message"=>"ok"}, status: 200
    else
      render json: {"message"=>"not found"}, status: 404
    end
  end
end
