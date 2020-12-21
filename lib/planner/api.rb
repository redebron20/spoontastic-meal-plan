
class SpoontasticMealPlan::API

    def self.get_mealplan_day(search_hash)
        parsed_params = parse_search(search_hash)
        url = "https://api.spoonacular.com/mealplanner/generate?timeFrame=day&diet=#{parsed_params[:diet]}&intolerances=#{parsed_params[:intolerance]}&instructionsRequired=true&apiKey=#{ENV['API_KEY']}"
        
        get_JSON(url)["meals"].each do |meals_hash|
            SpoontasticMealPlan::Meal.new({id: meals_hash["id"].to_i, title: meals_hash["title"], servings: meals_hash["servings"], readyinMinutes: meals_hash["readyInMinutes"]})
        end
    end

    def self.parse_search(search_hash)
        search_hash.transform_values! { |input_arr| input_arr.join("&").downcase.gsub(" ", "&") }
        search_hash
    end

    def self.get_recipe_instruction(id)
        url = "https://api.spoonacular.com/recipes/#{id}/analyzedInstructions?apiKey=#{ENV['API_KEY']}"
        get_JSON(url)[0]["steps"].map do |step_hash|
            step_hash.values_at("step")
        end
    end

    def self.get_recipe_ingredient(id)
        url = "https://api.spoonacular.com/recipes/#{id}/information?includeNutrition=false&apiKey=#{ENV['API_KEY']}"
        get_JSON(url)["extendedIngredients"].map do |ingredient_hash|
            ingredient_hash.select { |k, v| k == "name" || k == "amount" || k == "unit"}
        end
    end

    def self.get_JSON(url)
        uri = URI.parse(url)
        response = Net::HTTP.get_response(uri)
        JSON.parse(response.body)
    end 

end
