
class SpoontasticMealPlan::MealScraper

    @@diets = []
    @@intolerances = []

    def self.diets
        if @@diets.empty?
            doc = parse_doc("diets")
            doc.css('//section[@jss-title="Diets"]/h4').each {|e| @@diets << e.text}
          end
          @@diets
    end

    def self.intolerances
        if @@intolerances.empty?
          doc = parse_doc("intolerances")
          doc.css('//section[@jss-title="Intolerances"]/ul/li').each {|e| @@intolerances << e.text}
        end 
        @@intolerances
      end

    def self.parse_doc(search_type)
        site = URI.open("https://spoonacular.com/food-api/docs##{search_type.capitalize}")
        doc = Nokogiri::HTML(site)
        binding.pry
    end

end