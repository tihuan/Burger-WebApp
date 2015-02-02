class Burger < ActiveRecord::Base

include ActionView::Helpers::TextHelper
attr_accessor :sumbeef, :sumcheese, :sumonions
require 'set'

	def self.load

		if Burger.where(id:1).empty?

			default_burger = Burger.create(id:1, buns:"Extra Toasted")
		else

		end
	end

	def countcode
		wordstring = "#{self.beefcount}x#{self.cheesecount},#{self.frystyle},#{self.cheesestyle},#{self.spread},#{self.pickles},#{self.buns},#{self.cooklevel},#{self.onion1},#{self.onion2},#{self.onion3},#{self.onion4}"
		word = wordstring.split(",")
		@result = word.to_set

		@code = []

		#Count Onion Options. Push Onions @line-143. Need to count onions here in case Anial style takes GR
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
		if @result.include? "0x0"
			@code << "Veggie"
		elsif @result.include? "0x2"
			@code << "Grill Chz"
		elsif @result.include? "1x0"
			@code << "HAMB"
		elsif @result.include? "1x1"
			@code << "CHB"
		elsif @result.include? "2x0"
			@code << "Dbl MEAT"
		elsif @result.include? "2x2"
			@code << "DblDbl"
		else
			@code << "#{self.beefcount}x#{self.cheesecount}"
		end

		#Check Spread, Lettuce, Tomatoes. Push ">" if missing any.
		lt = ["#{self.lettuce}","#{self.tomatoes}"]
		if lt.include? ""
			@code << ">"
		elsif self.spread == "" and self.ketchup == "" and self.mustard == ""
			@code << ">"
		else
		end

		#Dealing with Animal Style
		# binding.pry
		animalstyle = Set["mfd","X S","P","GR"]
		if animalstyle.subset? @result
			@code << "Animal"
			gr -= 1
		end

		#Dealing with Core Condiments IF ">" presents
		if @code.include? ">"
			@code << "#{self.spread}" if self.spread == "S"
			@code << "#{self.lettuce}" if self.lettuce == "L"
			@code << "#{self.tomatoes}" if self.tomatoes == "T"
		end

		#Push onions
		if raw == 0 and chop == 0 and gr == 0 and whgr == 0
			@code << "WO"
		end

		if raw == 1
			@code << "raw"
		elsif raw > 1
			(raw-1).times {@code << "X raw"}
		end

		if chop == 1
			@code << "chop"
		elsif chop > 1
			(chop-1).times {@code << "X chop"}
		end

		if gr == 1
			@code << "GR"
		elsif gr > 1
			(gr-1).times {@code << "X GR"}
		end

		if whgr == 1
			@code << "WHGR"
		elsif whgr > 1
			(whgr-1).times {@code << "X WHGR"}
		end

		#Dealing with Spread
		if self.spread == "X S"
			@code << self.spread unless @code.include? "Animal"
		else
		end

		#Dealing with Lettuce
		if self.lettuce == "X L"
			@code << self.lettuce unless @code.include? "X L"
		else
		end

		#Dealing with Tomatoes
		if self.tomatoes == "X T"
			@code << self.tomatoes unless @code.include? "X T"
		else
		end

		#Dealing with pickles
		@code << "#{self.pickles}" if self.pickles != ""

		#Dealing with other requests
		@code << "#{self.cheesestyle}" if self.cheesestyle == "Cold_cheese"
		@code << "#{self.chopchillies}" if self.chopchillies != ""
		@code << "#{self.extrasalt}" if self.extrasalt != ""
		@code << "#{self.mustard}" if self.mustard != ""
		@code << "#{self.ketchup}" if self.ketchup != ""
		mustard_inst = (self.mustard != "" and self.spread == '')
		ketchup_inst = (self.ketchup != "" and self.spread == '')
		if @code.include? ">"
		elsif mustard_inst or ketchup_inst
			@code << "Inst"
		end

		# Dealing with Fry Style
		@code << "#{self.frystyle}" if self.frystyle != " "

		#Add "only" here. >> This is the end of condiments code <<
		@code << "only" if @code.include? ">"

		#Bun Request
		@code << "#{self.cooklevel}" if self.cooklevel != " "

		#Dealing with buns request. Flying Dutchman needs special handling
		if self.buns != "" and self.buns != "FLYING DUTCHMAN"
			@code << "#{self.buns}"

			#Dealing with Flying Dutchman when code includes irregular burgers: 2x1, 2x3, etc.
		elsif self.buns == "FLYING DUTCHMAN" and @code.include? "#{self.beefcount}x#{self.cheesecount}"
			@code.unshift("#{self.buns}")

			#Dealing with Flying Dutchman when code includes regular burgers: HAMB, CHB, etc.
		else
			@code.unshift("#{self.beefcount}x#{self.cheesecount}")
			@code.unshift("#{self.buns}")
			#Get rid of "HAMB", "CHB", etc.
			list = ["HAMB","CHB","Dbl MEAT","DblDbl"]
			list.each do |l|
				if @code.include? l
					@code.delete(l)
				end
			end
		end

		#Check if XE condition exists
		extra_everything = Set["X T","X L","X raw","X S","P","chillies"]
		check_code = @code.to_set
		if extra_everything.subset? check_code
			@code.insert(1,"XE")
			@code.delete('X T')
			@code.delete('X L')
			@code.delete('X raw')
			@code.delete('X S')
			@code.delete('P')
			@code.delete('chillies')
		end

		#Dealing with "Cut in Half" request
		@code << "#{self.cutinhalf}" if self.cutinhalf != ""

		#Clean up "WO" if "only" exists
		@code.delete("WO") if @code.include? "only"

		#Clean up Animal Style Ingredients if "Animal" exists
		if @code.include? "Animal"
			@code.delete('mfd')
			@code.delete('X S')
			@code.delete('P')
		end


		#@code = @code.uniq
		@code = @code*" "
		self.code = @code
	end

# Burger.load
end

private



