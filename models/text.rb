#encoding: utf-8
class TextAnalysis
  include DataMapper::Resource
    property :id, Serial
    property :title, String
    property :text, Text

  def list
    self.text.split.map(&:downcase).map{|w| w.gsub(/\p{Punct}/, "")}.reject{|i| i == ""}
  end

  def frequency
    result = self.list.inject(Hash.new(0)){|res, el| res[el] += 1; res}
    result.sort_by{|k,v| v}.reverse
  end

  def show(n)
    self.frequency.take(n)
  end
end 
