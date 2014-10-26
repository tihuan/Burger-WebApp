require 'pry'

class Burger < ActiveRecord::Base
include ActionView::Helpers::TextHelper
attr_accessor :sumbeef, :sumcheese, :sumonions
require 'set'

	def self.load
		default_burger = Burger.create(id:1, buns:"Extra Toasted") if Burger.where(id:1).empty?
	end

	#Dealing with MxC
	def beef_by_cheese
		case "#{self.beefcount}x#{self.cheesecount}"
		when "0x0"
			self.code << "Veggie"
		when "0x2"
			self.code << "Grill Chz"
		when "1x0"
			self.code << "HAMB"
		when "1x1"
			self.code << "CHB"
		when "2x0"
			self.code << "Dbl MEAT"
		when "2x2"
			self.code << "DblDbl"
		else
			self.code << "#{self.beefcount}x#{self.cheesecount}"
 		end
	end

	def countcode
		@word = %W(#{ self.beef_by_cheese } #{ self.frystyle } #{ self.cheesestyle }
		          		     #{ self.spread } #{ self.pickles } #{ self.buns } #{ self.cooklevel }
		          		     #{ self.onion1 } #{ self.onion2 } #{ self.onion3 } #{ self.onion4 }
		          		)

		self.result = @word.to_set

		#Count Onion Options. Push Onions @line-143. Need to count onions here in case Animal style takes GR
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

		#Check Spread, Lettuce, Tomatoes. Push ">" if missing any.
		lt = ["#{self.lettuce}","#{self.tomatoes}"]
		if lt.include? ""
			self.code << ">"
		elsif self.spread == "" and self.ketchup == "" and self.mustard == ""
			self.code << ">"
		else
		end

		#Dealing with Animal Style
		animalstyle = Set["mfd","X S","P","GR"]
		if animalstyle.subset? self.result
			self.code << "Animal"
			gr -= 1
		end

		#Dealing with Core Condiments IF ">" presents
		if self.code.include? ">"
			self.code << "#{self.spread}" if self.spread == "S"
			self.code << "#{self.lettuce}" if self.lettuce == "L"
			self.code << "#{self.tomatoes}" if self.tomatoes == "T"
		end

		#Push onions
		if raw == 0 and chop == 0 and gr == 0 and whgr == 0
			self.code << "WO"
		end

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

		#Dealing with Spread
		if self.spread == "X S"
			self.code << self.spread unless self.code.include? "Animal"
		else
		end

		#Dealing with Lettuce
		if self.lettuce == "X L"
			self.code << self.lettuce unless self.code.include? "X L"
		else
		end

		#Dealing with Tomatoes
		if self.tomatoes == "X T"
			self.code << self.tomatoes unless self.code.include? "X T"
		else
		end

		#Dealing with pickles
		self.code << "#{self.pickles}" if self.pickles != ""

		#Dealing with other requests
		self.code << "#{self.cheesestyle}" if self.cheesestyle == "Cold_cheese"
		self.code << "#{self.chopchillies}" if self.chopchillies != ""
		self.code << "#{self.extrasalt}" if self.extrasalt != ""
		self.code << "#{self.mustard}" if self.mustard != ""
		self.code << "#{self.ketchup}" if self.ketchup != ""
		mustard_inst = (self.mustard != "" and self.spread == '')
		ketchup_inst = (self.ketchup != "" and self.spread == '')
		if self.code.include? ">"
		elsif mustard_inst or ketchup_inst
			self.code << "Inst"
		end

		# Dealing with Fry Style
		self.code << "#{self.frystyle}" if self.frystyle != " "

		#Add "only" here. >> This is the end of condiments code <<
		self.code << "only" if self.code.include? ">"

		#Bun Request
		self.code << "#{self.cooklevel}" if self.cooklevel != " "

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

		#Check if XE condition exists
		extra_everything = Set["X T","X L","X raw","X S","P","chillies"]
		check_code = self.code.to_set
		if extra_everything.subset? check_code
			self.code.insert(1,"XE")
			self.code.delete('X T')
			self.code.delete('X L')
			self.code.delete('X raw')
			self.code.delete('X S')
			self.code.delete('P')
			self.code.delete('chillies')
		end

		#Dealing with "Cut in Half" request
		self.code << "#{self.cutinhalf}" if self.cutinhalf != ""

		#Clean up "WO" if "only" exists
		self.code.delete("WO") if self.code.include? "only"

		#Clean up Animal Style Ingredients if "Animal" exists
		if self.code.include? "Animal"
			self.code.delete('mfd')
			self.code.delete('X S')
			self.code.delete('P')
		end


		#self.code = self.code.uniq
		self.code = self.code*" "

	end

#Burger.load
end

private



