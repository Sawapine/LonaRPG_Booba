module DataManager
  class << self
    alias_method :load_mod_database_Lona_Booba_Graphics, :load_mod_database
  end

  def self.load_mod_database
    load_mod_database_Lona_Booba_Graphics
	
	modFolder = "ModScripts/_Mods/Lona_Booba_Graphics/"
	
	FileGetter.load_mod_EventLib("#{modFolder}MapBB001.rvdata2")

    $data_states << RPG::State.new
		$data_states.last.id = $data_states.length-1
		$data_states.last.load_additional_data("#{modFolder}items/states/ExpandedBooba.json")
	
    $data_items << RPG::Item.new #make new empty item
		$data_items.last.id = $data_items.length-1 #create item ID to last array length
		$data_items.last.load_additional_data("#{modFolder}items/AddModExpandedBooba.json")
			
	$data_items << RPG::Item.new #make new empty item
		$data_items.last.id = $data_items.length-1 #create item ID to last array length
		$data_items.last.load_additional_data("#{modFolder}items/AidModExpandedBooba.json")

    $mod_load_script["Data/HCGframes/event/NoerGynecologyEliseDay.rb"] = "ModScripts/_Mods/Lona_Booba_Graphics/Data/HCGframes/event/NoerGynecologyEliseDay.rb"
	
	palette_list = Dir.glob('ModScripts/_Mods/Lona_Booba_Graphics/PaletteChanger/*.json')
    palette_list.reverse!
    palette_list.each do |json_path|
      BitmapChanger.load_setting_file(json_path)
    end
  end
end



module FileGetter

MOD_FOLDER = "ModScripts/_Mods/Lona_Booba_Graphics/"

  def self.preprocess_lona_booba_pose_json(lona_json, booba_json)
    json = []
    lona_json.each do |pose|
      json << pose
      next unless pose.has_key? "name_order"
      pose["name_order"] << "ExpandedBooba"
      old_bmps = pose["bmps"]
      pose["bmps"] = {}
      old_bmps.each_pair do |k, v|
        pose["bmps"]["#{k},ExpandedBooba00"] = v
        if booba_json.empty?
          if File.exist? "#{MOD_FOLDER}Graphics/Portrait/Lona/#{v}"
            pose["bmps"]["#{k},ExpandedBooba01"] = "../../../#{MOD_FOLDER}Graphics/Portrait/Lona/#{v}"
          else
            pose["bmps"]["#{k},ExpandedBooba01"] = v
          end
        end
      end
    end
    booba_json.each do |pose|
      json << pose
      next unless pose.has_key? "name_order"
      pose["name_order"] << "ExpandedBooba"
      old_bmps = pose["bmps"]
      pose["bmps"] = {}
      old_bmps.each_pair do |k, v|
        if File.exist? "#{MOD_FOLDER}Graphics/Portrait/Lona/#{v}"
          pose["bmps"]["#{k},ExpandedBooba01"] =
            "../../../#{MOD_FOLDER}Graphics/Portrait/Lona/#{v}"
        else
          pose["bmps"]["#{k},ExpandedBooba01"] = v
        end
      end
    end
    json
  end

  def self.load_lona_portrait_parts_dir
    partsHash = Hash.new
    name_order = Hash.new
    Dir["Data/Pconfig/Pconfig_lona/poses/*"].each do |dir|

      fileList = getFileList(dir + "/*.json")
      pose_name = File.basename(dir).downcase

      mod_path = "#{MOD_FOLDER}Data/Pconfig/Pconfig_lona/poses/#{File.basename(dir)}"
      modfileList = getFileList("#{mod_path}/*.json")

      prp "lona pose #{pose_name}"
      fileList.each do |filename|
        prp "load portrait json: #{filename}"
        file = File.open(filename)
        lona_json = JSON.decode(file.read)
        booba_json = []

        if File.exist?(File.join(mod_path, File.basename(filename)))
          mod_file = File.open(File.join(mod_path, File.basename(filename)))
          booba_json = JSON.decode(mod_file.read)
        end
        json = preprocess_lona_booba_pose_json(lona_json, booba_json)

        parts_config = handle_lona_parts_arr(json, name_order) #[name_order,parts]
        partsHash[pose_name].nil? ? partsHash[pose_name] = parts_config[1] : partsHash[pose_name] += parts_config[1]
        name_order = parts_config[0]
      end

      modfileList.each do |file|
        prp "load portrait json: #{file}"
        file = File.open(file)
        json = preprocess_lona_booba_pose_json([], JSON.decode(file.read))

        parts_config = handle_lona_parts_arr(json, name_order)
        partsHash[pose_name].nil? ? partsHash[pose_name] = parts_config[1] : partsHash[pose_name] += parts_config[1]
        name_order = parts_config[0]
      end
    end

    fileList = getFileList("Data/Pconfig/Pconfig_LayeredNPC/poses/*.json")
    fileList.each do |filename|
      pose_name = filename[38..-6] # 裁到剩檔名本名
      prp "load portrait json: #{filename}"
      prp "NPC pose #{pose_name}"
      file = File.open(filename)
      parts_config = handle_lona_parts_arr(JSON.decode(file.read), name_order) #[name_order,parts]
      partsHash[pose_name].nil? ? partsHash[pose_name] = parts_config[1] : partsHash[pose_name] += parts_config[1]
      name_order = parts_config[0]
    end
    save_data([name_order, partsHash], "Data/lona_pconfig.rvdata2") if FileGetter::WRITING_LIST
    prp "Data/lona_parts.rvdata2 written" if FileGetter::WRITING_LIST
    return [name_order, partsHash]
  end
end