#encoding:utf-8
require "sinatra"

class Text
  attr_accessor :text, :w_list, :frequency
  def initialize(file)
    @text = file.read.force_encoding("utf-8")
    @w_list = @text.split.map(&:downcase).map{|w| w.gsub(/\p{Punct}/, "")}.reject{|i| i == ""}
    @frequency = self.count_rel.reverse
  end
  
#Häufigkeit zählen
  def count_rel
    result = @w_list.inject(Hash.new(0)){|res, el| res[el] += 1; res}
    result.sort_by{|k,v| v}
  end

#Successiv zählen
  def count
    arr = []
    @w_list.inject(Hash.new(0)){|res, el| res[el] += 1; arr << [el, res[el]]; res}  
    return arr 
  end
#die ersten n Results anzeigen
  def show(n)
    @frequency.take(n).map{|r| r.push(r[1] / @w_list.length.to_f * 100)}
  end
end

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
  text = Text.new(file[:tempfile])
  @data = text.show(n)
  download_f = open("results.txt", "w")
    download_f.puts "WORD\tABSOLUTE FREQUENCY\tRELATIVE FREQUENCY\n"
    @data.each{|d| download_f.puts "#{d[0]}\t#{d[1]}\t#{d[2]}\n"}
    download_f.close
  @title = file[:filename]
  @total_length = text.w_list.length
  erb :data
end

get "/download" do
  redirect to "results.txt"
end

get "/alt" do
  text = Text.new(open("schloss.txt"))
  @data = text.show(20)
  file = open("results.txt", "w")
    file.puts "WORD\tABSOLUTE FREQUENCY\tRELATIVE FREQUENCY\n"
    @data.each{|d| file.puts "#{d[0]}\t#{d[1]}\t#{d[2]}\n"}
    file.close
  @title = "Das Schloss"
  @total_length = text.w_list.length
  erb :data  
end
