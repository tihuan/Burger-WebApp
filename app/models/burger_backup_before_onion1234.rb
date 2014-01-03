class Burger < ActiveRecord::Base

include ActionView::Helpers::TextHelper
attr_accessor :sumbeef, :sumcheese, :sumonions
require 'set'

before_validation :sumup
validate :total_less_than_4

	def self.load

		if Burger.where(id:1).empty?

			default_burger = Burger.create(id:1, buns:"Extra Toasted")
		else

		end
	end

	def countpatties

		nobeef = "No Beef Please." if self.normalbeef == "0" and self.nosaltbeef == "0" and self.heavymustardbeef == "0" and self.normalmustardbeef == "0"
		nrbeef = "#{self.normalbeef} Normal Beef/ " if self.normalbeef != "0"
		nsbeef = "#{self.nosaltbeef} No Salt Beef/ " if self.nosaltbeef != "0"
		hmbeef = "#{self.heavymustardbeef} Heavy Mustard Beef/ " if self.heavymustardbeef != "0"
		nmbeef = "#{self.normalmustardbeef} Normal Mustard Beef/ " if self.normalmustardbeef != "0"

		self.patties = "#{nrbeef} #{nsbeef} #{hmbeef} #{nmbeef} #{nobeef}"
	end

	def countcheese
		sumcheese = self.meltcheese.to_i + self.coldcheese.to_i 
		nocheese = 'No Cheese Please.' if self.meltcheese == "0" and self.coldcheese == "0"
		mtcheese = "#{self.meltcheese} Melted Cheese/ " if self.meltcheese != "0"
		cdcheese = "#{self.coldcheese} Cold Cheese/ " if self.coldcheese != "0"

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

	def countcondiments
		mustard = "Mustard/ " if self.mustard != ""
		ketchup = "Ketchup/ " if self.ketchup != ""
		extrasalt = "Extra Salt/ " if self.extrasalt != ""
		pickles = "pickles" if self.pickles != ""
		chopchillies = "Chopped Chillies/ " if self.chopchillies != ""
		self.condiments = "#{mustard} #{ketchup} #{extrasalt} #{pickles} #{chopchillies}"
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

	def countresult
		result = []
		wordstring = "#{self.beefcount}x#{self.cheesecount},#{self.frystyle},#{self.cheesestyle},#{self.spread},#{self.pickles},#{self.grillwholeonions},#{self.rawwholeonions},#{self.rawchoponions},#{self.buns},#{self.cooklevel},#{self.onion1},#{self.onion2},#{self.onion3},#{self.onion4}"

		word = wordstring.split(",")
		word.each do |w|
			result << w		
		end

		self.result = result.to_set

		#Dealing with onion options
		if self.grillchoponions != ""
			splitonion = self.grillchoponions.split(",")
			splitonion.each do |o|
				self.result << o
			end
		end

	end

	def countcode
		self.code = []

		#Count Onion Options:
		onions = ["#{self.onion1}","#{self.onion2}","#{self.onion3}","#{self.onion4}"]
		raw = 0
		chop = 0
		whgr = 0
		gr = 0
		onions.each do |o|
			raw += 1 if o == "O"
			chop += 1 if o == "ChopO"
			whgr += 1 if o == "WHGR"
			gr += 1 if o == "GR"
		end

		#Dealing with MxC
		if self.result.include? "1x0"
			self.code << "HAMB"
		elsif self.result.include? "1x1"
			self.code << "CHB"
		elsif self.result.include? "2x0"
			self.code << "Dbl MEAT"
		elsif self.result.include? "2x2"
			self.code << "DblDbl"
		else
			self.code << "#{self.beefcount}x#{self.cheesecount}"
		end

		#Check Spread, Lettuce, Tomatoes. Push ">" if missing any.
		slt = ["#{self.spread}","#{self.lettuce}","#{self.tomatoes}"]
		self.code << ">" if slt.include? ""

		#Dealing with Animal Style
		animalstyle = Set["mfd","XS","P","GR"]
		if animalstyle.subset? self.result
			self.code << "Animal" 
			self.result.delete('mfd')
			self.result.delete('XS')
			self.result.delete('P')
			gr -= 1
		end

		#Dealing with Core Condiments IF ">" presents
		if self.code.include? ">"
			self.code << "#{self.spread}" unless self.spread == "" or self.code.include? "Animal"
			self.code << "#{self.lettuce}" if self.lettuce != ""
			self.code << "#{self.tomatoes}" if self.tomatoes != ""
		end

=begin		if self.tomatoes == "" and self.spread != "" and self.lettuce != "" and self.code.include? "Animal"
			self.code << "T"
		elsif self.tomatoes == "" and self.spread != "" and self.lettuce != ""
			self.code << "SL"
		elsif self.tomatoes != "" and self.spread != "" and self.lettuce == ""
			self.code << "L"				
		else
		end
=end
		#Push onions
		if raw == 1
			self.code << "raw"
		elsif raw > 1
			(raw-1).times {self.code << "X raw"}
		end

		if chop == 1
			self.code << "chop"
		elsif chop > 1
			(chop-1).times {self.code << "X chop"}
		end

		if gr == 1
			self.code << "GR"
		elsif gr > 1
			(gr-1).times {self.code << "X GR"}
		end

		if whgr == 1
			self.code << "WHGR"
		elsif whgr > 1
			(whgr-1).times {self.code << "X WHGR"}
		end

		# Dealing with Fry Style
		self.code << "#{self.frystyle}" if self.result.include? "#{self.frystyle}" and self.frystyle != ""

=begin		# Also dealing with onion options
		if self.rawwholeonions == "" and self.rawchoponions == "" and self.grillwholeonions == "" and self.grillchoponions == ""
			self.code << "WO"

		elsif self.code.include? "Animal" and self.result.include? "2GR" 
			self.code << "XGR"

		elsif self.code.include? "Animal" and self.result.include? "3GR"
			self.code << "XXGR"

		elsif self.code.include? "Animal" and self.result.include? "4GR"
			self.code << "XXXGR"	

		elsif self.result.include? "2GR" or self.result.include? "3GR" or self.result.include? "4GR"
			splitonion = self.grillchoponions.split(',')
			splitonion.delete('1GR')
			# Make splitonion look good in self.code
			splitonion.each do |o|
				self.code << o
			end
		# Add "1GR" to code if Animal is not present	
		elsif self.result.include? "1GR"
			self.code << "1GR"
		else		
		end

		if self.grillwholeonions != ""
			self.code << self.grillwholeonions
		end

		if self.rawchoponions != ""
			self.code << self.rawchoponions
		end

		if self.rawwholeonions != ""
			self.code << self.rawwholeonions
		end

=end	
		#Dealing with Tomatoes
		if self.tomatoes == "XT"
			self.code << self.tomatoes
		else
		end

		#Dealing with Lettuce
		if self.lettuce == "XL"
			self.code << self.lettuce
		else 
		end
				
		#Dealing with other condiments if not used by Animal style in self.result
		self.code << "#{self.pickles}" if self.result.include? "P"
		#self.code << "#{self.spread}" if self.result.include? "XS"

		#Dealing with other requests
		self.code << "Cold_Cheese" if self.cheesestyle == "coldcheese"
		self.code << "#{self.chopchillies}" if self.chopchillies != ""
		self.code << "#{self.extrasalt}" if self.extrasalt != ""
		self.code << "#{self.mustard}" if self.mustard != ""
		self.code << "#{self.ketchup}" if self.ketchup != ""
		mustard_inst = (self.mustard != "" and self.spread == '')
		ketchup_inst = (self.ketchup != "" and self.spread == '')
		self.code << "Inst" if mustard_inst or ketchup_inst

=begin		#Add "Only" if two or more condiments == ""
		no_onions = self.rawwholeonions == "" and self.rawchoponions == "" and self.grillwholeonions == "" and self.grillchoponions ==""
		if no_onions == true
			no_onions == ""
		end
		condiments = ["#{self.spread}","#{self.lettuce}","#{self.tomatoes}","#{self.chopchillies}","#{self.extrasalt}","#{no_onions}"]
		count = 0
		condiments.each do |c|
			if c == ""
				count += 1
			else
			end
		end

		if count > 1
			self.code << "#{self.lettuce}" if self.lettuce != ""
			self.code << "#{self.tomatoes}" if self.tomatoes != ""
			self.code << "#{self.chopchillies}" if self.chopchillies != ""
			self.code << "#{self.extrasalt}" if self.extrasalt != ""
			self.code << "only"
		end
=end
		#What to do with Onions?

		#Bun Request
		self.code << "#{self.cooklevel}" if self.cooklevel != ""

		#Dealing with buns request. Flying Dutchman needs special handling
		if self.buns != "" and self.buns != "FLYING DUTCHMAN" 
			self.code << "#{self.buns}" 

			#Dealing with Flying Dutchman when code includes irregular burgers: 2x1, 2x3, etc.
		elsif self.buns == "FLYING DUTCHMAN" and self.code.include? "#{self.beefcount}x#{self.cheesecount}"
			self.code.unshift("#{self.buns}")

			#Dealing with Flying Dutchman when code includes regular burgers: HAMB, CHB, etc.
		else 
			self.code.unshift("#{self.beefcount}x#{self.cheesecount}") 
			self.code.unshift("#{self.buns}")
			#Get rid of "HAMB", "CHB", etc.
			list = ["HAMB","CHB","Dbl MEAT","DblDbl"]
			list.each do |l|
				if self.code.include? l
					self.code.delete(l)
				end
			end
		end

		#Other Requests and Put "Cut in Half" request to the end of the In-N-Out code
		self.code << "#{self.cutinhalf}" if self.cutinhalf != ""


		#self.code = self.code.uniq
		self.code = self.code*" "
	
	end

#Burger.load
end

private



