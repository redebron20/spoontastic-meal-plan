
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

    def self.get_day_mealplan(search_hash)
        parsed_params = search_hash
        url = "https://api.spoonacular.com/recipes/search?timeFrame=#{parsed_params[:timeframe]}&diet=#{parsed_params[:diet]}&intolerances=#{parsed_params[:intolerance]}&instructionsRequired=true&apiKey=#{KEY}"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        formatted_resp = JSON.parse(response)
        binding.pry   
    end

    # def self.parse_search(search_hash)
    #     search_hash.transform_values! { |input_arr| input_arr.join("&").downcase.gsub(" ", "&") }
    #     search_hash
    # end



end


#https://api.spoonacular.com/mealplanner/generate?timeFrame=day&diet=vegetarian&intolerances=egg&instructionsRequired=true&apiKey=85064a6e000745df8969cd158fcf80eb>