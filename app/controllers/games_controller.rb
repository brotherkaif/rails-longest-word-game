require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = [] 
    @grid << ("A".."Z").to_a.sample while @grid.length < 10
  end

  def score
    dic_return = load_json(params["user_answer"])
    dic_check = dic_return["found"]

    split_attempt = params["user_answer"].upcase.split("")
    split_grid = params["grid"].split("")
    letter_check = split_attempt.all? { |letter| split_attempt.count(letter) <= split_grid.count(letter) }

    if letter_check && dic_check
      score = params["user_answer"].length * 100
      @message = "Congratulations, you scored #{score} points!"
    elsif !dic_check && letter_check
      @message = "Your word is in the grid, but it's not an English word!"
    elsif dic_check && !letter_check
      @message = "That's a real word, but it ain't in the grid!"
    elsif !dic_check && !letter_check
      @message = "That is neither in the grid or an actual word. Pathetic!"
    end
  end

  def load_json(input)
    file_path = "https://wagon-dictionary.herokuapp.com/#{input}"
    json_file = open(file_path).read

    return JSON.parse(json_file)
  end
end
