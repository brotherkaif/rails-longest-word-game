require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    # define an empty array and fill it with 10 random letters
    @grid = [] 
    @grid << ("A".."Z").to_a.sample while @grid.length < 10
  end

  def score
    # split the user's guess and the grid string into arrays so we can check it.
    @split_attempt = params["user_answer"].upcase.split("")
    split_grid = params["grid"].split("")

    # check if the letter is in the grid
    letter_check = @split_attempt.all? { |letter| @split_attempt.count(letter) <= split_grid.count(letter) }
    
    # check if the word is in the dictionary
    dic_check = dictionary(params["user_answer"])

    # generate the end of game message based on these parameters
    @message = generate_message(dic_check, letter_check, params["user_answer"])
  end

  def dictionary(user_answer)
    # use the wagon dictionary API to check if word is in the dictionary
    file_path = "https://wagon-dictionary.herokuapp.com/#{user_answer}"
    json_file = open(file_path).read
    response = JSON.parse(json_file)
    return response["found"]
  end

  def generate_message(dic_check, letter_check, user_answer)
    if letter_check && dic_check
      score = user_answer.length * 100
      return "Congratulations, the word '#{user_answer.upcase}' scored #{score} points!"
    elsif !dic_check && letter_check
      return "'#{user_answer.upcase}' is in the grid, but it's not an English word!"
    elsif dic_check && !letter_check
      return "'#{user_answer.upcase}' is a real word, but it ain't in the grid!"
    elsif !dic_check && !letter_check
      return "'#{user_answer.upcase}' is neither in the grid or an actual word. Pathetic!"
    end
  end

end
