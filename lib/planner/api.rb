
class SpoontasticMealPlan::API

    #URL = "https://api.spoonacular.com/mealplanner/generate"

    def mealplan
        key = "85064a6e000745df8969cd158fcf80eb"
        url = "https://api.spoonacular.com/mealplanner/generate?timeFrame=day&apiKey=#{key}"
        # extention = "?apiKey=#{ENV['API_KEY']}"
        # url = URL + extention
        #url = "https://api.spoonacular.com/mealplanner/generate?apiKey=85064a6e000745df8969cd158fcf80eb"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        formatted_resp = JSON.parse(response)
        #resp_2 = HTTParty.get(url)

        binding.pry

    end


end

#https://api.spoonacular.com/mealplanner/generate?apiKey=85064a6e000745df8969cd158fcf80eb
#timeFrame=day