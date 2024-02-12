class GamesController < ApplicationController

require 'open-uri'
require 'json'

  def new
    grid = []
    10.times do
      grid << ("A".."Z").to_a.sample
    end
    @grid = grid
  end

  def score
    # raise
    @user_input = params[:user_input]
    url = "https://wagon-dictionary.herokuapp.com/#{@user_input}"
    api_result_serialized = URI.open(url).read
    api_result = JSON.parse(api_result_serialized)

    grid_counter = Hash.new(0)
    @grid = params[:grid]
    @grid.chars.each { |letter| grid_counter[letter.upcase] += 1 }
    attempt_counter = Hash.new(0)
    @user_input.each_char { |letter| attempt_counter[letter.upcase] += 1 }

    @validation = "a in the dictionary but not in the grid" if api_result["found"]
    @validation = "valid" if api_result["found"] && attempt_counter.all? { |letter, count| count <= grid_counter[letter] }
    @validation = "not english" if api_result["error"]
    # @score = raise.length * 100
  end
end
