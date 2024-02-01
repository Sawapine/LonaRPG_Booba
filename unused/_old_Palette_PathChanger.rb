=begin
module DataManager
    # How alias_method should be used within a module.
    self.singleton_class.send(:alias_method, :load_mod_database_PaletteReplacer, :load_mod_database)

    def self.load_mod_database
        load_mod_database_PaletteReplacer
        # Get a list of palette settings files to load.
        palette_list = FileGetter.getFileList('ModScripts/_Mods/Lona_Booba_Graphics/PaletteChanger/*.json');
        # Reverse the order in the list so palettes apply in the correct order. PaletteChanger also does this.
        palette_list.reverse!
        palette_list.each{
            |json_path|
            BitmapChanger.load_setting_file(json_path)
        }
        # Load a specific palette settings file. Uncomment to use.
        #BitmapChanger.load_setting_file('ModScripts/_Mods/Lona_Booba_Graphics/PaletteChanger/10_DEFAULT_Transformations.json')
    end
end


source_files = [
  "ModScripts/_Mods/Lona_Booba_Graphics/PaletteChanger/unactive_jsons/110_Skin_White_BOOBA.json",
  "ModScripts/_Mods/Lona_Booba_Graphics/PaletteChanger/unactive_jsons/310_Skin_Dark_BOOBA.json",
  "ModScripts/_Mods/Lona_Booba_Graphics/PaletteChanger/unactive_jsons/320_Skin_White_pale_BOOBA.json",
  "ModScripts/_Mods/Lona_Booba_Graphics/PaletteChanger/unactive_jsons/9000_DedGirl_BOOBA.json"
]

target_folder = "ModScripts/PaletteChanger/unactive_jsons/"

# Проверяем наличие файлов в целевой папке
existing_files = Dir.glob("#{target_folder}/*.json").map { |file| File.basename(file) }

# Копирование отсутствующих файлов при запуске игры
source_files.each do |source_file|
  target_file = File.join(target_folder, File.basename(source_file))

  next if existing_files.include?(File.basename(source_file))

  if File.exist?(source_file)
    source_content = File.read(source_file)

    File.open(target_file, "w") do |file|
      file.write(source_content)
    end

    existing_files << File.basename(source_file)
  end
end


source_files = [
  "110_Skin_White_BOOBA.json",
  "310_Skin_Dark_BOOBA.json",
  "320_Skin_White_pale_BOOBA.json",
  "9000_DedGirl_BOOBA.json"
]

bat_file_path = "ModScripts/PaletteChanger/BOOBA_unactive_jsons_delete.bat"

unless File.exist?(bat_file_path)
  bat_file_content = "REM This batch file will delete the files\n"

  source_files.each do |source_file|
    bat_file_content += "DEL \"%CD%\\unactive_jsons\\#{source_file}\"\n"
  end
  
    # Добавляем удаление самого батника
  bat_file_content += "DEL \"%~f0\"\n"

  File.open(bat_file_path, "w") do |file|
    file.write(bat_file_content)
  end
end

=end
