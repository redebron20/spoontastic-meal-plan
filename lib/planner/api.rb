
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

    def self.get_mealplan_day(search_hash)
        parsed_params = parse_search(search_hash)
        url = "https://api.spoonacular.com/mealplanner/generate?timeFrame=day&diet=#{parsed_params[:diet]}&intolerances=#{parsed_params[:intolerance]}&instructionsRequired=true&apiKey=#{KEY}"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        mealplan = JSON.parse(response)

        mealplan.each do |meals_hash|
            SpoontasticMealPlan::Meals.new({id: meals_hash["id"].to_i, title: meals_hash["title"], servings: meals_hash["servings"], readyinMinutes: meals_hash["readyInMinutes"]})
        end
        mealplan
        binding.pry
    end

    def self.parse_search(search_hash)
        search_hash.transform_values! { |input_arr| input_arr.join("&").downcase.gsub(" ", "&") }
        search_hash
    end



end


#https://api.spoonacular.com/mealplanner/generate?timeFrame=day&diet=vegetarian&intolerances=egg&instructionsRequired=true&apiKey=85064a6e000745df8969cd158fcf80eb>