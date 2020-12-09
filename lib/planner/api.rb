
class SpoontasticMealPlan::API

    #URL = "https://api.spoonacular.com/mealplanner/generate"

    # def hidden_key
    #     extention = "?apiKey=#{ENV['API_KEY']}"
    #     url = URL + extention
    #     uri = URI(url)
    #     response = Net::HTTP.get(uri)
    #     formatted_resp = JSON.parse(response)
    # end

    KEY = "85064a6e000745df8969cd158fcf80eb"

    def self.get_mealplan_day(search)
        parsed_params = parse_search(search)
        url = "https://api.spoonacular.com/recipes/search?offset=#{parsed_params[:offset]}&number=#{parsed_params[:number]}&query=#{parsed_params[:timeframe]}&diet=#{parsed_params[:diets]}&intolerances=#{parsed_params[:intolerances]}&instructionsRequired=true&apiKey=#{KEY}"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        formatted_resp = JSON.parse(response)
        # get_JSON(url)["results"].map do |recipe_hash|
        #     recipe_hash.select { |k, v| k == "id" || k == "title" }
        # end
        binding.pry
    end

end


