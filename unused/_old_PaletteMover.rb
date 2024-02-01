=begin
def insert_into_file_temporarily
  default_file = "ModScripts/PaletteChanger/10_DEFAULT_Transformations.json"
  mod_file = "ModScripts/_Mods/Lona_Booba_Graphics/PaletteChanger/10_DEFAULT_Transformations.json"

  # Проверяем, существуют ли оба файла
  if File.exist?(default_file) && File.exist?(mod_file)
    # Читаем оба файла
    default_data = File.readlines(default_file)
    mod_data = File.readlines(mod_file)

    # Находим нужную строку в модифицированном файле
    new_line = mod_data.find { |line| line.include?("Graphics/Portrait/Lona/pose1_subpose3_preg8m.png") }

    if new_line
      # Находим индекс строки, после которой нужно вставить новую строку в файле по умолчанию
      index = default_data.index { |line| line.include?("Graphics/Portrait/Lona/pose1_subpose1_preg8m.png") }

      # Вставляем новую строку после найденной
      default_data.insert(index + 1, new_line)

      # Записываем обновленные данные обратно в файл
      File.open(default_file, "w") do |f|
        f.puts(default_data)
      end

      puts "Строка успешно добавлена в файл."

      # Создаем новый поток, который ждет 30 секунд, затем восстанавливает исходное состояние файла
      Thread.new do
        sleep(20)

        # Восстанавливаем исходное состояние файла
        default_data.delete_at(index + 1)
        File.open(default_file, "w") do |f|
          f.puts(default_data)
        end

        puts "Строка успешно удалена из файла."
      end
    else
      puts "Не удалось найти нужную строку в файле #{mod_file}."
    end
  else
    puts "Один или оба файла не найдены."
  end
end

insert_into_file_temporarily

=begin

source_files = [
  "ModScripts/_Mods/Lona_Booba_Graphics/PaletteChanger/11_DEFAULT_Transformations_BOOBA.json",
  "ModScripts/_Mods/Lona_Booba_Graphics/PaletteChanger/10001_DEFAULT_Races_BOOBA.json"
]

target_folder = "ModScripts/PaletteChanger/"

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
  "ModScripts/_Mods/Lona_Booba_Graphics/PaletteChanger/unused/110_Skin_White_BOOBA.json",
  "ModScripts/_Mods/Lona_Booba_Graphics/PaletteChanger/unused/310_Skin_Dark_BOOBA.json",
  "ModScripts/_Mods/Lona_Booba_Graphics/PaletteChanger/unused/320_Skin_White_pale_BOOBA.json",
  "ModScripts/_Mods/Lona_Booba_Graphics/PaletteChanger/unused/9000_DedGirl_BOOBA.json"
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
  "11_DEFAULT_Transformations_BOOBA.json",
  "10001_DEFAULT_Races_BOOBA.json"
]

bat_file_path = "ModScripts/PaletteChanger/delete_booba_palette_files.bat"

unless File.exist?(bat_file_path)
  bat_file_content = "REM This batch file will delete the files\n"

  source_files.each do |source_file|
    bat_file_content += "DEL \"%CD%\\#{source_file}\"\n"
  end

  File.open(bat_file_path, "w") do |file|
    file.write(bat_file_content)
  end
end

# Здесь вы можете добавить вызов команды для выполнения .bat файла при выходе из игры.
# Например:
# `system(bat_file_path)` или `exec(bat_file_path)`
# Обратите внимание, что вызов команды может привести к немедленному выходу из игры.


=end