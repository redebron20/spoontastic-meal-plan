
class SpoontasticMealPlan::CLI

    def call
        puts ""
        puts "Hello! Welcome to Spoontastic Meal Plan."
        puts ""

        get_diet
        get_intolerance
        
        # puts "To see a customized meal plan for one day or an entire week, please choose between 'day' or 'week'."
        # puts ""
        # puts "To continue this later, enter 'exit'."
        # puts ""
        menu
    end

    def get_diet
        puts "Please select your diet from the below list."
    end

    def get_intolerance
        puts "Please select intolerance/s from the below list."
    end

    def menu
        input = gets.strip.downcase

        if input == "day"
            puts "Here's your customized meal plan for the day."
            day_plan
            menu
        elsif input == "week"
            puts "Here's a customized meal plan for the week."
            week_plan
            menu
        elsif input == "exit"
            goodbye
        else
            invalid_entry
        end
    end

    def day_plan
        puts "Day Meal"
        puts ""
        puts ""
        puts "Would you like to see other daily meal plans?"
    end

    def week_plan
        puts "Week Meal"
    end

    def goodbye
        puts "Until then. Goodluck with meal planning! Please come back anytime."
    end

    def invalid_entry
        puts "Invalid entry. Please choose 'day' or 'week' or exit."
        menu
    end


end
