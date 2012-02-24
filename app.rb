#encoding:utf-8
require "sinatra"
require ".models/text.rb"
require ".config/db.rb"

get "/" do
  redirect to "index.html"
end

get "/favicon.ico" do
  halt 404
end

post "/display_results" do
  file = params[:file]
  unless file && file[:tempfile] && file[:filename]
    return
  end
  n = params[:select_n].to_i
  text = Text.create(:title => file[:filename], :text => file[:tempfile]
  @data = text.show(n)
  @title = file[:filename]
  @total_length = text.w_list.length
  erb :data
end

get "/download" do
  redirect to "results.txt"
end

get "/example" do
  text = Text.new(open("schloss.txt"))
  @data = text.show(20)
  @title = "Das Schloss"
  @total_length = text.w_list.length
  erb :data  
end
