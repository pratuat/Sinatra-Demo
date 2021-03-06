require './config/environment'

class ClarkApp < Sinatra::Base
  set :logging, true
  set :views, 'app/views'

  get '/' do
    slim :index
  end

  post '/' do
    if params[:file]
      @container = DataContainer.new

      events = File.open(params[:file][:tempfile], 'r').read.split("\n").map(&:split)

      events.each do |event|
        EventProcessorService.call(event, @container)
      end

      @file_name = params[:file][:filename]
      @user_points = @container.get_users_points
    end

    slim :index
  end
end