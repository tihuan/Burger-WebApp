class Burger < ActiveRecord::Base

include ActionView::Helpers::TextHelper
attr_accessor :sumbeef, :sumcheese, :sumonions

before_validation :sumup
validate :total_less_than_4

	def self.load

		if Burger.where(id:1).empty?

			default_burger = Burger.create(id:1, buns:"Extra Toasted")
		else

		end
	end

	def countpatties

		nobeef = "No Beef Please." if self.normalbeef == "" and self.nosaltbeef == "" and self.heavymustardbeef == "" and self.normalmustardbeef == ""
		nrbeef = "#{self.normalbeef} Normal Beef/ " if self.normalbeef != ""
		nsbeef = "#{self.nosaltbeef} No Salt Beef/ " if self.nosaltbeef != ""
		hmbeef = "#{self.heavymustardbeef} Heavy Mustard Beef/ " if self.heavymustardbeef != ""
		nmbeef = "#{self.normalmustardbeef} Normal Mustard Beef/ " if self.normalmustardbeef != ""

		self.patties = "#{nrbeef} #{nsbeef} #{hmbeef} #{nmbeef} #{nobeef}"
	end

	def countcheese
		sumcheese = self.meltcheese.to_i + self.coldcheese.to_i 
		nocheese = 'No Cheese Please.' if self.meltcheese == "" and self.coldcheese == ""
		mtcheese = "#{self.meltcheese} Melted Cheese/ " if self.meltcheese != ""
		cdcheese = "#{self.coldcheese} Cold Cheese/ " if self.coldcheese != ""

		self.cheese = "#{mtcheese} #{cdcheese} #{nocheese}"
	end

	def countonions
		noonions = 'No Onion Please.' if self.rawwholeonions == "" and self.rawchoponions == "" and self.grillwholeonions == "" and self.grillchoponions == ""
		rwonions = "#{self.rawwholeonions} Fresh Whole Onion/ " if self.rawwholeonions != ""
		rconions = "#{self.rawchoponions} Fresh Chopped Onion/ " if self.rawchoponions != ""
		gwonions = "#{self.grillwholeonions} Grilled Whole Onion/ " if self.grillwholeonions != ""
		gconions = "#{self.grillchoponions} Grilled Chopped Onion/ " if self.grillchoponions != ""

		self.onions = "#{rwonions} #{rconions} #{gwonions} #{gconions} #{noonions}"
	end

	def counttomatoes
		tomatoes = 'No Tomato Please.' if self.tomatoes == ""
		tomatoes = pluralize(self.tomatoes, 'Slice') + ' of Tomatoes' if self.tomatoes != ""
		self.tomatoes = "#{tomatoes}"
	end

	def countlettuce
		lettuce = 'No Lettuce Please.' if self.lettuce == ""
		lettuce = "#{self.lettuce} Portion of Lettuce" if self.lettuce != ""
		self.lettuce = "#{lettuce}"
	end

	def countcondiments
		mustard = "Mustard/ " if self.mustard != ""
		ketchup = "Ketchup/ " if self.ketchup != ""
		extrasalt = "Extra Salt/ " if self.extrasalt != ""
		pickles = "Pickles/ " if self.pickles != ""
		chopchillies = "Chopped Chillies/ " if self.chopchillies != ""
		self.condiments = "#{mustard} #{ketchup} #{extrasalt} #{pickles} #{chopchillies}"
	end

	def countspecialrequests
		cutinhalf = "Cut in Half/ " if self.cutinhalf != ""
		animalstyle = "Animal Style/" if self.animalstyle != ""
		self.specialrequests = "#{cutinhalf} #{animalstyle}"
	end

	def sumup
		self.sumbeef = self.normalbeef.to_i + self.nosaltbeef.to_i + self.heavymustardbeef.to_i + self.normalmustardbeef.to_i
		self.sumcheese = self.meltcheese.to_i + self.coldcheese.to_i
		self.sumonions = self.rawwholeonions.to_i + self.rawchoponions.to_i + self.grillwholeonions.to_i + self.grillchoponions.to_i
	end

	def total_less_than_4
			errors.add(:base, "Beef patties can only be up to 4 in total. Currently there are #{@sumbeef} patties.") if sumbeef.to_i > 4
			errors.add(:base, "Cheese can only be up to 4 in total. Currently there are #{@sumcheese} cheese.") if sumcheese.to_i > 4
			errors.add(:base, "Onions can only be up to 4 in total. Currently there are #{@sumonions} onions.") if sumonions.to_i > 4
	end

Burger.load
end

private



