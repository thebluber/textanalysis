#encoding:utf-8
require "sinatra"
require "./models/text.rb"
require "./config/db.rb"

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
  textdata = file[:tempfile].read.force_encoding("utf-8")
  text = TextAnalysis.create(:title => file[:filename], :text => textdata)
  @data = text.show(n)
  @title = file[:filename]
  @total_length = text.list.length
  erb :data
end

get "/download" do
  redirect to "results.txt"
end

get "/example" do
  text = TextAnalysis.new(open("schloss.txt"))
  @data = text.show(20)
  @title = "Das Schloss"
  @total_length = text.list.length
  erb :data  
end
