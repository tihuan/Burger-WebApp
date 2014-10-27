require 'pry'

class Burger < ActiveRecord::Base
include ActionView::Helpers::TextHelper
attr_accessor :sumbeef, :sumcheese, :sumonions
require 'set'

	def self.load
		Burger.create(id:1, buns:"Extra Toasted") if Burger.where(id:1).empty?
	end

	def count_code
		@code = []
		@word = %W(#{ beef_by_cheese } #{ self.frystyle } #{ self.cheesestyle }
		          		     #{ self.spread } #{ self.pickles } #{ self.buns } #{ self.cooklevel }
		          		     #{ self.onion1 } #{ self.onion2 } #{ self.onion3 } #{ self.onion4 }
		          		)
		@result = @word.to_set

		count_onions
		only_condiments_to_s
		count_animal
		onions_to_s
		extra_condiments_to_s(self.spread, 'S')
		extra_condiments_to_s(self.lettuce, 'L')
		extra_condiments_to_s(self.tomatoes, 'T')
		pickles_to_s
		other_requests_to_s
		frystyle_to_s
		only_to_s

		#Bun Request
		@code << "#{self.cooklevel}" if self.cooklevel != ' '

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

		cleanup_after_animal

		self.code = @code.join(' ')
	end

private
	#Dealing with MxC
	def beef_by_cheese
		case "#{self.beefcount}x#{self.cheesecount}"
		when "0x0"
			@code << "Veggie"
		when "0x2"
			@code << "Grill Chz"
		when "1x0"
			@code << "HAMB"
		when "1x1"
			@code << "CHB"
		when "2x0"
			@code << "Dbl MEAT"
		when "2x2"
			@code << "DblDbl"
		else
			@code << "#{self.beefcount}x#{self.cheesecount}"
 		end
 	end

 	def count_onions
 		#Count Onion Options. Push Onions @line-143. Need to count onions here in case Animal style takes GR
 		onions = ["#{self.onion1}","#{self.onion2}","#{self.onion3}","#{self.onion4}"]
 		@raw = 0
 		@chop = 0
 		@whgr = 0
 		@gr = 0
 		onions.each do |o|
 			@raw += 1 if o == "O"
 			@chop += 1 if o == "ChopO"
 			@whgr += 1 if o == "WHGR"
 			@gr += 1 if o == "GR"
 		end
 	end

 	def onions_to_s
 		if @raw == 0 && @chop == 0 && @gr == 0 && @whgr == 0
 			@code << "WO"
 		else
 			push_onion(@raw, 'raw')
 			push_onion(@chop, 'chop')
 			push_onion(@gr, 'GR')
 			push_onion(@whgr, 'WHGR')
 		end
 	end

 	def push_onion(onion, onion_name)
 		if onion == 1
 			@code << "#{onion_name}"
 		elsif onion > 1
 			(onion - 1).times {@code << "X #{onion_name}"}
 		end
 	end

 	#Dealing with Animal Style
 	def count_animal
 		animalstyle = Set["mfd","X S","P","GR"]
 		if animalstyle.subset? @result
 			@code << "Animal"
 			@gr -= 1
 		end
 	end

 	#Check Spread, Lettuce, Tomatoes. Push '>' if missing any.
 	def check_only_condiments
 		puts "lettuce_tomato"
		p lettuce_tomato = ["#{self.lettuce}","#{self.tomatoes}"]
		if lettuce_tomato.include? ''
			@code << '>'
		elsif self.spread == '' && self.ketchup == '' && self.mustard == ''
			@code << '>'
		end
	end

	#Dealing with Core Condiments IF '' presents
	def only_condiments_to_s
		puts "\n\n\n\nonly condiments?"
		p @code
		if check_only_condiments
			@code << "#{self.spread}" if self.spread == 'S'
			@code << "#{self.lettuce}" if self.lettuce == 'L'
			@code << "#{self.tomatoes}" if self.tomatoes == 'T'
			# marker to add 'only' at the end of the burger code
			@code << ''
		end
	end

	#Dealing with pickles
	def pickles_to_s
		@code << "#{self.pickles}" if self.pickles
	end

	def other_condiments_to_s(condiment)
		@code << "#{condiment}" if condiment
	end

	#Dealing with other requests
	def other_requests_to_s
		@code << "#{self.cheesestyle}" if self.cheesestyle == 'Cold_cheese'
		other_condiments_to_s(self.chopchillies)
		other_condiments_to_s(self.extrasalt)
		other_condiments_to_s(self.mustard)
		other_condiments_to_s(self.ketchup)
		mustard_inst = (self.mustard != '' && self.spread == '')
		ketchup_inst = (self.ketchup != '' && self.spread == '')
		if @code.include? ''
		elsif mustard_inst || ketchup_inst
			@code << "Inst"
		end
	end

	# Dealing with Fry Style
	def frystyle_to_s
		@code << "#{self.frystyle}" if self.frystyle != ' '
	end

	#Add "only" here. >> This is the end of condiments code <<
	def only_to_s
		puts "\n\n\n What's @code?"
		p @code
		@code << 'only' if @code.include? ''
	end

 	# Dealing with extra condiments
 	def extra_condiments_to_s(condiment, condiment_name)
 		if condiment == "X #{condiment_name}"
 			if condiment == 'X S'
 				@code << condiment unless @code.include? "Animal"
 			else
 				@code << condiment unless @code.include? condiment
 			end
 		end
 	end

 	#Clean up Animal Style Ingredients if "Animal" exists
 	def cleanup_after_animal
	 	if @code.include? "Animal"
	 		@code.delete('mfd')
	 		@code.delete('X S')
	 		@code.delete('P')
	 	end
 	end
end


