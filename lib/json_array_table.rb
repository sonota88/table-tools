require 'json'

class JsonArrayTable
  def self.parse(text)
    text.lines.map{ |line| JSON.parse(line) }
  end
end
