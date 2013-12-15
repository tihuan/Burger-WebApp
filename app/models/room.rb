class Room < ActiveRecord::Base
	attr_accessor :w_word
	
	def self.loadup

		if Room.where(id:1..6).empty?

			central_corridor = Room.create(id:1, name:"Central Corridor", 
				
				description: 

				"The Gothons of Planet Percal #25 have invaded your ship and destroyed your entire crew. You are the last surviving member and your last mission is to get 
				the neutron destruct bomb from the Weapons Armory, put it in the bridge, and blow the ship up after getting into an escape pod. You're running down the 
				central corridor to the Weapons Armory when a Gothon jumps out, red scaly skin, dark grimy teeth, and evil clown costume flowing around his hate filled body. 
				He's blocking the door to the Armory and about to pull a weapon to blast you. Whar are you going to do?", 

				directions: '{"Tickle Gothon" => "6", Shoot!: "6", "Tell a Joke" => "2"}' )

			laser_armory = Room.create(id:2, name:"Laser Weapon Armory", 
				
				description: 

				"Lucky for you they made you learn Gothon insults in the academy. You tell the one Gothon joke you know: 
				\"Lbhe zbgure vf fb sng, jura fur fvgf nebhaq gur ubhfr, fur fvgf nebhaq gur ubhfr.\" 
				The Gothon stops, tries not to laugh, then busts out laughing and can't move. While he's laughing you run up and shoot him square in the head putting him down, 
				then jump through the Weapon Armory door. You do a dive roll into the Weapon Armory, crouch and scan the room for more Gothons that might be hiding. 
				It's dead quiet, too quiet. You stand up and run to the far side of the room and find the neutron bomb in its container. There's a keypad lock on the box and 
				you need the code to get the bomb out. If you get the code wrong 10 times then the lock closes forever and you can't get the bomb. The code is 3 digits.", 

				directions:'{"123" => "6", "859" => "6", "425" => "6", "111" => "6", "666" => "6", "777" => "6", "888" => "6", "909" => "6", "404" => "3", "423" => "6"}')

			the_bridge = Room.create(id:3, name:"The Bridge", 
				
				description: 

				"The container clicks open and the seal breaks, letting gas out. You grab the neutron bomb and run as fast as you can to the bridge where you must 
				place it in the right spot. You burst onto the Bridge with the netron destruct bomb under your arm and surprise 5 Gothons who are trying to take control of 
				the ship. Each of them has an even uglier clown costume than the last. They haven't pulled their weapons out yet, as they see the active bomb under your 
				arm and don't want to set it off. What are you going to do?", 

				directions:'{"Slowly Put Down the Bomb" => "4", "Shoot Them Again and Again and Again" => "6", "Beg for Mercy" => "6", "Flip the Finger" => "6"}')

			escape_pod = Room.create(id:4, name:"Escape Pod", 
				
				description: 

				"You point your blaster at the bomb under your arm and the Gothons put their hands up and start to sweat. 
				You inch backward to the door, open it, and then carefully place the bomb on the floor, pointing your blaster at it. 
				You then jump back through the door, punch the close button and blast the lock so the Gothons can't get out. 
				Now that the bomb is placed you run to the escape pod to get off this tin can. 
				You rush through the ship desperately trying to make it to the escape pod before the whole ship explodes. 
				It seems like hardly any Gothons are on the ship, so your run is clear of interference. 
				You get to the chamber with the escape pods, and now need to pick one to take. 
				Some of them could be damaged but you don't have time to look. There's 5 pods, which one do you take?", 
				
				directions:'{"Pod 1"=>"6", " Pod 2"=>"6", "Pod 3"=>"6", "Pod 4"=>"5", " Pod 5"=>"6", "Pod 6"=>"6"}')

			the_end = Room.create(id:5, name:"The End", 
				
				description: 

				"You jump into pod 2 and hit the eject button. The pod easily slides out into space heading to the planet below. 
				As it flies to the planet, you look back and see your ship implode then explode like a bright star, taking out the Gothon ship at the same time. You won!", 

				directions:'{"Go Back to Beginning" => "1"}')

			you_lose = Room.create(id:6, name:"You Lose", description: "You jump into a random pod and hit the eject button. The pod escapes out into the void of space, then implodes as the hull ruptures, crushing your body into jam jelly.", directions:'{"Go Back to Beginning" => "1"}')

		else

		end

	end

	def scan(keywords)

		begin

			direction = ["north", "south", "east", "west", "down", "up", "left", "right", "back"]

			verb = ["go", "stop", "kill", "eat", "help"]

			stop = ["the", "in", "of", "from", "at", "it", "and"]

			noun = ["door", "bear", "princess", "cabinet"]

			pair = Struct.new(:token, :word)

			sentence = ["test"]

			splitwords = keywords.split

			splitwords.each do |w|

				if direction.include?(w) 
					w_word = pair.new(:direction, "#{w}")
					#sentence << w_word_dir
					#puts w_word_dir 
					#puts "\n"

				elsif verb.include?(w) 
					w_word = pair.new(:verb, "#{w}")
					#sentence << w_word_verb
					#puts w_word_verb
					#puts "\n"

				elsif stop.include?(w) 
					w_word = pair.new(:stop, "#{w}")	

				elsif noun.include?(w)
					w_word = pair.new(:noun, "#{w}")
														
				else
					w_word = pair.new(:error, "#{w}")
						#sentence << w_word_error
						#puts w_word_error
						#puts "\n"
				end

				sentence.push(w_word)
			end

		rescue

		end

		self.scanresults = sentence.to_s

	end

	def testscan(words)
		splitwords = words.split
		self.scanresults = splitwords
	end

end

Room.loadup


