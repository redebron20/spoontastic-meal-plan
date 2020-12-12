
class SpoontasticMealPlan::Ingredient
    # attr_accessor :name, :amount, :unit
    @@all = []

    def initialize(ingredient_hash)
        ingredient_hash.each do |k, v| 
            self.class.attr_accessor k
            self.send(("#{k}="), v)
        end
        save
    end

    def self.create_from_collection(ingredient_arr)
        ingredient_arr.each do |ingredient_hash|
            self.new(ingredient_hash)
        end
    end

    def save
        self.class.all << self
    end

    def self.all
        @@all
    end

end
