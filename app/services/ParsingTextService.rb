module TextParser
  def self.text_parser(text)
    wholelot_array = []
    text.split("\n").each do |line|
      wholelot_array.push(line.split("**"))
    end
    wholelot_array
  end

end