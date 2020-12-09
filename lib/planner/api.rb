
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

    def self.mealplan
        url = "https://api.spoonacular.com/recipes/search?timeFrame=day&diet=vegetarian&intolerances=dairy&instructionsRequired=true&apiKey=#{KEY}"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        formatted_resp = JSON.parse(response)
        binding.pry
    end

end


