require 'json'

class JsonArrayTable

  def self.parse(text)
    text.lines.map{ |line| JSON.parse(line) }
  end

  def self.generate(rows)
    rows.map{|cols|
      JSON.generate(cols) + "\n"
    }.join("")
  end

end
