
class SpoontasticMealPlan::CLI

    attr_accessor :user_diet, :user_intolerance, :timeframe

    def call
        # recipe_id = 190292
        # SpoontasticMealPlan::API.get_meal_ingredient(recipe_id)
        puts ""
        puts "Hello! Welcome to Spoontastic Meal Plan."
        puts ""

        get_diet
        get_intolerance
        #get_timeframe

        get_mealplan_day
        print_mealplan_day
        select_recipe
     
    end

    def get_diet
        diet_list = SpoontasticMealPlan::MealScraper.diets
        puts ""
        puts "Please select your diet from the below list. Use a comma to separate multiple choices (e.g., '3, 5'). Press 'n' if you'd like to skip."
        puts ""
        list_results(diet_list)

        diet_input = gets.strip.split(", ")
        unless input_validation(diet_input, diet_list)
            puts ""
            puts "Invalid input. Let's try again."
            puts ""
            get_diet
        end

        @user_diet = select_search_word(diet_input, diet_list)
    end

    def get_intolerance
        intolerance_list = SpoontasticMealPlan::MealScraper.intolerances
        puts ""
        puts "Please select intolerance/s from the below list. Use a comma to separate multiple choices (e.g., '3, 5'). Press 'n' if none."
        puts ""
        list_results(intolerance_list)

        intolerance_input = gets.strip.split(", ")
        unless input_validation(intolerance_input, intolerance_list)
            puts ""
            puts "Invalid input. Let's try again."
            get_intolerance
        end
        
        @user_intolerance = select_search_word(intolerance_input, intolerance_list)
    end

    def list_results(array)
        array.each.with_index(1) do |element, index|
            puts "#{index}. #{element}"
        end
    end

    def input_validation(input_arr, data)
        input_arr.all? do |input|
          (1..data.length).include?(input.to_i) || input.downcase == "n"
        end   
      end

    def select_search_word(input_arr, data)
        input_arr.map do |input|
          input.downcase == "n" ? "" : data[input.to_i - 1]
        end 
    end

    # def get_timeframe
    #     puts ""
    #     puts "To generate a meal plan for one day or an entire week, please type either 'day' or 'week'."
    #     puts ""
    #     puts "To quit the program, enter 'x'."

    #     @timeframe = gets.strip.downcase

    #     if timeframe == "day"
    #         get_day_plan
    #         get_timeframe
    #     elsif timeframe == "week"
    #         get_week_plan
    #         get_timeframe
    #     elsif timeframe == "x" || "exit"
    #         goodbye
    #     else
    #         invalid_entry
    #     end 
    # end

    def search_hash
        @search_hash = {
          diet: user_diet,
          intolerance: user_intolerance,
          #timeframe: timeframe
        }
    end

#Mealplan Controller
    def get_mealplan_day 
        puts ""       
        puts "Here's your curated meal plan for the day."

        SpoontasticMealPlan::API.get_mealplan_day(search_hash)
    end

    # def get_mealplan
    #     puts ""
    #     puts "Here's your curated meal plan for the week."

    #     day_mealplan = SpoontasticMealPlan::API.get_day_mealplan(search_hash)
    #     SpoontasticMealPlan::Meal.create_from_collection(day_mealplan)
    # end

    def print_mealplan_day
        SpoontasticMealPlan::Meal.all.each.with_index(1) do |recipe_obj, i|
            puts ""
            puts "#{i}. #{recipe_obj.title}"
            puts "ReadyInMinutes #{recipe_obj.readyinMinutes}"
            puts "Servings #{recipe_obj.servings}"
            puts ""
          end 
    end

    def get_new_mealplan_list
        SpoontasticMealPlan::Meal.reset
        get_mealplan_day
        print_mealplan_day
    end

    def select_recipe
        puts "Select a recipe to read more, or enter 'new' to generate a new meal plan."
        #or 'x' to quit the program.

        input = gets.strip.downcase
    
        unless selection_validation(input)
            puts "Invalid input. Let's try again."
            select_recipe
        end
    
        if input == "new"
            get_new_mealplan_list
            select_recipe
        # elsif input == "x" || "exit"
        #     goodbye
        elsif
            get_recipe(input)
        end 
    end
    
    def selection_validation(input)
        (1..SpoontasticMealPlan::Meal.all.length).include?(input.to_i) || input == "new"
    end

    def get_recipe(input)
        index = input.to_i - 1
        selected_recipe = SpoontasticMealPlan::Meal.all[index]
        add_recipe_details(selected_recipe)
    end

    def add_recipe_details(recipe)
        recipe_instruction = SpoontasticMealPlan::API.get_recipe_instruction(recipe.id)
            if recipe_instruction
                meal.add_instruction(meal_instruction.flatten)
            end
      
        recipe_ingredient = SpoontasticMealPlan::API.get_recipe_ingredient(recipe.id)
            if recipe_ingredient
                meal.add_ingredient(meal_ingredient)
            end 
      
        # recipe_serving = SpoontasticMealPlan::API.get_serving(recipe.id)
        # recipe.add_serving(recipe_serving)
      
        display_recipe(recipe)

    end 

    def display_recipe(recipe)
        puts "Steps:"
        recipe.instruction.each { |step| puts "#{step}" }
        puts "Ingredients:"
        recipe.ingredients.each do |ingredient_hash|
          parsed_amount = parse_ingredient_amount(ingredient_hash["amount"])
          puts "#{parsed_amount} #{ingredient_hash['unit']} #{ingredient_hash['name']}"
        end
        # puts "Servings: #{recipe.servings}"
        
        planner_selection(recipe)
      end

    def goodbye
        puts ""
        puts "Until then. Goodluck with meal planning! Please come back anytime."
    end

    def invalid_entry
        puts "Invalid entry. Please choose 'day' or 'week' or exit."
        menu
    end

end
