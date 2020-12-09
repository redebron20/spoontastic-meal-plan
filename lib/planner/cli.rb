
class SpoontasticMealPlan::CLI

    attr_accessor :user_diet, :user_intolerance, :meal_timeframe

    def call
        puts ""
        puts "Hello! Welcome to Spoontastic Meal Plan."
        puts ""

        get_diet
        get_intolerance
        get_timeframe
               
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

    def get_timeframe
        puts ""
        puts "To generate a meal plan for one day or an entire week, please type either 'day' or 'week'."
        puts ""
        puts "To quit the program, enter 'x'."

        input = gets.strip.downcase

        if input == "day"
            puts ""
            puts "Here's your curated meal plan for the day."
            get_day_plan
            get_timeframe
        elsif input == "week"
            get_week_plan
            get_timeframe
        elsif input == "x" || "exit"
            goodbye
        else
            invalid_entry
        end

        @meal_timeframe = input
    end

    def search_hash
        @search_hash = {
          diets: user_diet,
          intolerances: user_intolerance,
          timeframe: meal_timeframe
        }
    end

#Recipe Controller
    def get_day_plan
        
        puts "Here's your customized meal plan for the day."

        basic_recipes_arr = WeeklyMealPlanner::FoodAPI.get_recipes_list(search_hash)
        WeeklyMealPlanner::Recipe.create_from_collection(basic_recipes_arr)

        puts "Would you like to see more meal plans?"
    end

    def get_week_plan
        puts ""
        puts "Here's your curated meal plan for the week."
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
