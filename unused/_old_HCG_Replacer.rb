=begin 
module DataManager
	#hack database
	self.singleton_class.send(:alias_method, :load_mod_database_Lona_Booba_Graphics, :load_mod_database)
	def self.load_mod_database
		load_mod_database_Lona_Booba_Graphics ##keep me in first
		#Sample ---- your mod folder
		modFolder = "ModScripts/_Mods/Lona_Booba_Graphics/"

$mod_load_script["Data/HCGframes/event/NoerGynecologyEliseDay.rb"] = "ModScripts/_Mods/Lona_Booba_Graphics/Data/HCGframes/event/NoerGynecologyEliseDay.rb"
end
end

=end