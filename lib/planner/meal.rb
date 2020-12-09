class SpoontasticMealPlan::MealPlan

    @@all = []

    def save
        self.class.all < self
    end

    def self.all
        @@all
    end

end