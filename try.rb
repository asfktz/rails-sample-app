
class Person
  def greet
    puts 'koko'
  end
end

class Bob < Person
  10.times do
    greet
  end
end