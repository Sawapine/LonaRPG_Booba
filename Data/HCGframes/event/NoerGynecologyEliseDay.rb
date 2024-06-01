
p "Playing HCGframe : EliseGynecologyEliseDayTalk.rb"
if $game_map.threat
	SndLib.sys_buzzer
	$game_map.popup(0,"QuickMsg:Lona/incombat#{rand(2)}",0,0)
	return
end


if $story_stats["RecQuestElise"] ==0
call_msg("TagMapNoerEliseGynecology:elise/day_1TimeBegin0")
call_msg("TagMapNoerEliseGynecology:elise/day_1TimeBegin1")
$story_stats["RecQuestElise"] = 1
$story_stats["RecQuestEliseAmt"] = 6+$game_date.dateAmt

################################################################ ABOM BAT
elsif $story_stats["RecQuestElise"] == 5 && $game_date.dateAmt >= $story_stats["RecQuestEliseAmt"] && $game_date.day?
	tmpMobAlive = $game_map.npcs.any?{
		|event| 
		next unless event.summon_data
		next unless event.summon_data[:abomBat]
		next if event.deleted?
		next if event.npc.action_state == :death
		true
	}
	if !tmpMobAlive
		call_msg("CompElise:RecQuestElise5/end0")
		call_msg("CompElise:RecQuestElise5/end1")
		call_msg("CompElise:RecQuestElise5/end2") #[懂,蝦？]
		if $game_temp.choice == 0
			call_msg("CompElise:RecQuestElise5/end2_y")
		else
			call_msg("CompElise:RecQuestElise5/end2_n")
			get_character(0).actor.set_aggro($game_player.actor,$data_arpgskills["BasicNormal"],430)
		end
		$story_stats["RecQuestElise"] = 6
		$story_stats["RecQuestEliseAmt"] = 1 + $game_date.dateAmt
	else
		call_msg("its escaped, kill it!, dont let it escape!")
	end

################################################################收集體力藥草
elsif $story_stats["QuProgStaHerbCollect"]==1 && $game_party.item_number($data_items[27]) >=4
	get_character(0).call_balloon(0)
	$story_stats["QuProgStaHerbCollect"] = 2
	$game_party.lose_item($data_items[27],4)
	call_msg("TagMapNoerEliseGynecology:elise/StaHerbCollect0")
	SndLib.sound_equip_armor
	$game_map.popup(0,"-4",$data_items[27].icon_index,-1)
	call_msg("TagMapNoerEliseGynecology:elise/StaHerbCollect1")

################################################################ 幫LISA治療
elsif $story_stats["RecQuestLisa"] == 15 && $game_player.record_companion_name_ext == "CompExtUniqueLisaDown"
	$story_stats["RecQuestLisaAmt"] = 6 + $game_date.dateAmt
	
	call_msg("CompLisa:Lisa16/ElisaTalk0")
	get_character(0).call_balloon(0)
	portrait_hide
		chcg_background_color(0,0,0,0,7)
			portrait_off
			tmpLisaEV = get_character($game_map.get_storypoint("lisa")[2])
			tmpEliseX,tmpEliseY=$game_map.get_storypoint("elise")
			bedEV=$game_map.events[$game_map.get_storypoint("DoTricket")[2]]
			tmpLisaEV.moveto(bedEV.x,bedEV.y)
			set_event_force_page(tmpLisaEV.id,1)
			tmpLisaEV.set_npc("NeutralHp1Sandbag")
			tmpLisaEV.npc.death_event = "EffectLisaHiveDed"
			tmpLisaEV.balloon_XYfix = -20
			tmpLisaEV.forced_y = -16
			tmpLisaEV.animation = tmpLisaEV.animation_overfatigue_stable
			get_character($game_player.get_followerID(-1)).set_this_companion_disband
			$game_player.moveto(tmpLisaEV.x+1,tmpLisaEV.y)
			$game_player.direction = 4
			get_character(0).moveto(tmpLisaEV.x-1,tmpLisaEV.y)
			get_character(0).direction = 6
		call_msg("CompLisa:Lisa16/ElisaTalk1")
		chcg_background_color(0,0,0,255,-7)
	call_msg("CompLisa:Lisa16/ElisaTalk2")
	get_character(0).npc_story_mode(true)
	get_character(0).move_forward_force ; wait(40)
	get_character(0).animation = get_character(0).animation_atk_sh
	wait(10)
	optain_item($data_items[147],1) #ItemBerserkDrug
	wait(20)
	get_character(0).npc_story_mode(false)
	if $story_stats["RecQuestElise"] >= 40
		$story_stats["RecQuestLisa"] = 17 #KEEP MEMORY
		call_msg("CompLisa:Lisa16/ElisaTalk3_berY")
	else
		$story_stats["RecQuestLisa"] = 16 #Reset Memory
		call_msg("CompLisa:Lisa16/ElisaTalk3_berN")
	end
	call_msg("CompLisa:Lisa16/ElisaTalk4")
	
	portrait_hide
		chcg_background_color(0,0,0,0,7)
			cam_center(0)
			portrait_off
			get_character(0).moveto(tmpEliseX,tmpEliseY)
			get_character(0).direction = 2
		chcg_background_color(0,0,0,255,-7)
	call_msg("CompLisa:Lisa16/ElisaTalk5")
	optain_exp(3500)
	
	
############################################################### 一般對話
else
	tmpOrcResearch = $story_stats["RecQuestElise"] == 1 && $game_date.dateAmt >= $story_stats["RecQuestEliseAmt"] && !$DEMO
	tmpFishtopiaIsle = $story_stats["RecQuestElise"].between?(7,13) #漁人島 
	
		
	has_ItemAMT=0
	$game_party.all_items.each{
		|item|
		next if !item.type.eql?("Baby")
		next if item.addData["MouthStats"] == "Human"
		next if item.addData["MouthStats"] == "Moot"
		amt=$game_party.item_number(item)
		for i in 0...amt
		has_ItemAMT += $game_party.item_number(item)
		end
	}
	tmpHasBaby = has_ItemAMT > 0#$game_party.has_item_type("Baby")
	tmpLisaAbom = [16,17].include?($story_stats["RecQuestLisa"])
		tmpPicked = ""
		tmpQuestList = []
		tmpQuestList << [$game_text["TagMapNoerEliseGynecology:elise/DayTalkOPT_Cancel"]				,"Cancel"]			
		tmpQuestList << [$game_text["TagMapNoerEliseGynecology:elise/DayTalkOPT_Talk"]					,"Talk"]			if !tmpLisaAbom
		tmpQuestList << [$game_text["TagMapNoerEliseGynecology:elise/DayTalkOPT_LisaAbom"]				,"LisaAbom"]		if tmpLisaAbom
		tmpQuestList << [$game_text["commonNPC:commonNpc/Barter"]										,"Barter"]			
		tmpQuestList << [$game_text["TagMapNoerEliseGynecology:elise/DayTalkOPT_PregnancyCheck"]		,"PregnancyCheck"]	
		tmpQuestList << [$game_text["TagMapNoerEliseGynecology:elise/DayTalkOPT_OrcResearch"]			,"OrcResearch"]		if tmpOrcResearch
		tmpQuestList << [$game_text["TagMapNoerEliseGynecology:elise/DayTalkOPT_FishtopiaIsle"]			,"FishtopiaIsle"]	if tmpFishtopiaIsle
		tmpQuestList << [$game_text["TagMapNoerEliseGynecology:elise/DayTalkOPT_SellBaby"]				,"SellBaby"]	if tmpHasBaby
		cmd_sheet = tmpQuestList
		cmd_text =""
		for i in 0...cmd_sheet.length
			cmd_text.concat(cmd_sheet[i].first+",")
		end
		call_msg("TagMapNoerEliseGynecology:elise/day_talk",0,2,0)
		call_msg("\\optB[#{cmd_text}]")
		
		$game_temp.choice == -1 ? tmpPicked = false : tmpPicked = cmd_sheet[$game_temp.choice][1]
		$game_temp.choice = -1
	case tmpPicked
		when "Talk"
			call_msg("TagMapNoerEliseGynecology:elise/day_talk_about0")
			call_msg("TagMapNoerEliseGynecology:elise/day_talk_about1")
		when "LisaAbom"
			if $game_date.dateAmt >= $story_stats["RecQuestLisaAmt"] 
				call_msg("CompLisa:Lisa16_17/NotThere0")
				call_msg("CompLisa:Lisa16_17/NotThere1")
			else
				call_msg("CompLisa:Lisa16_17/StillThere0")
				call_msg("CompLisa:Lisa16_17/StillThere1_#{rand(3)}")
				call_msg("CompLisa:Lisa16_17/StillThere2_2")
			end
			
		when "Barter"
			$story_stats["HiddenOPT2"] = "1" if $game_party.has_item_type("Baby")
			shopNerf = ([([$story_stats["WorldDifficulty"].round,100].min)-0,0].max*0.001) #put the varible u want nerf shop,  if none put 0. var1=max  var2=min.   max-min must with in 100 (ex:weak125, -25)
			charStoreTP =  [(  3000+rand(6000)  )*(1-(shopNerf+shopNerf)),0].max.round  #wildHobo 150+rand(800) hobo 300+rand(1000) #Normie 500+rand(2000) #NonTradeShop 1000+rand(2500) #innkeeper 1000+rand(2500) #storeMarket 3000+rand(6000)
			charStoreExpireDate = $game_date.dateAmt+1+rand(4+$story_stats["Setup_Hardcore"]) #if nil. delete after close.  if < date. delete after nap.
			charStoreHashName = "#{@map_id}_#{get_character(0).id}".to_sym  #can be register with character name like "COCONA"
			#data 0item 1:weapon 2:armor
			#original price? 0,0   custom price? nil,price
			good=[
				
				[*$data_ItemName["ItemRedPotion"].get_type_and_id			,nil,(($data_ItemName["ItemRedPotion"].price)			*(shopNerf+1)).round,2+rand(10)], #21
				[*$data_ItemName["ItemBluePotion"].get_type_and_id			,nil,(($data_ItemName["ItemBluePotion"].price)			*(shopNerf+1)).round,2+rand(10)], #22 
				[*$data_ItemName["ItemContraceptivePills"].get_type_and_id	,nil,(($data_ItemName["ItemContraceptivePills"].price)	*(shopNerf+1)).round,2+rand(10)], #23 
				[*$data_ItemName["ItemRepellents"].get_type_and_id			,nil,(($data_ItemName["ItemRepellents"].price)			*(shopNerf+1)).round,2+rand(10)], #31 
				[*$data_ItemName["ItemAbortion"].get_type_and_id			,nil,(($data_ItemName["ItemAbortion"].price)			*(shopNerf+1)).round,2+rand(10)], #32 
				[*$data_ItemName["ItemNoerTea"].get_type_and_id				,nil,(($data_ItemName["ItemNoerTea"].price)				*(shopNerf+1)).round,2+rand(10)], #150
				[*$data_ItemName["ItemHiPotionLV2"].get_type_and_id			,nil,(($data_ItemName["ItemHiPotionLV2"].price)			*(shopNerf+1)).round,2+rand(10)], #24 
				##治療
				[*$data_ItemName["AidPregnancy"].get_type_and_id			,0,0,100],		#201
				[*$data_ItemName["AidLactation"].get_type_and_id			,0,0,3],		#200
				[*$data_ItemName["AidFeelsSick"].get_type_and_id			,0,0,1],		#203
				[*$data_ItemName["AidStomachSpasm"].get_type_and_id			,0,0,1],		#204
				[*$data_ItemName["AidWound"].get_type_and_id				,0,0,3],		#202
				[*$data_ItemName["AidVaginalDamaged"].get_type_and_id		,0,0,1],		#205
				[*$data_ItemName["AidUrethralDamaged"].get_type_and_id		,0,0,1],		#206
				[*$data_ItemName["AidSphincterDamaged"].get_type_and_id		,0,0,1],		#207
				[*$data_ItemName["AidSlaveBrand"].get_type_and_id			,0,0,1],		#208
				[*$data_ItemName["AidModWombSeedBed"].get_type_and_id		,0,0,3],		#209
				[*$data_ItemName["AidWormParasite"].get_type_and_id			,0,0,1],		#214
				[*$data_ItemName["AidSemenAddiction"].get_type_and_id		,0,0,3],		#210
				[*$data_ItemName["AidOgrasmAddiction"].get_type_and_id		,0,0,3],		#211
				[*$data_ItemName["AidDrugAddiction"].get_type_and_id		,0,0,3],		#212
				[*$data_ItemName["AidSTD"].get_type_and_id					,0,0,3],		#199
				[*$data_ItemName["AidEquip"].get_type_and_id				,0,0,1],		#215
				[*$data_ItemName["AidPiercingNose"].get_type_and_id			,0,0,1],		#221
				[*$data_ItemName["AidPiercingNoseB"].get_type_and_id		,0,0,3],		#221
				[*$data_ItemName["AidPiercingEar"].get_type_and_id			,0,0,3],		#222
				[*$data_ItemName["AidPiercingChest"].get_type_and_id		,0,0,3],		#223
				[*$data_ItemName["AidPiercingBelly"].get_type_and_id		,0,0,3],		#224
				[*$data_ItemName["AidPiercingArms"].get_type_and_id			,0,0,3],		#225
				[*$data_ItemName["AidPiercingAnal"].get_type_and_id			,0,0,3],		#226
				[*$data_ItemName["AidPiercingVag"].get_type_and_id			,0,0,3],		#227
				[*$data_ItemName["AidPiercingBack"].get_type_and_id			,0,0,3],		#228
				
				#改造
				[*$data_ItemName["AddModVagGlandsLink"].get_type_and_id			,0,0,1],		#230
				[*$data_ItemName["AddVulvaMilkGland"].get_type_and_id			,0,0,1],		#231
				[*$data_ItemName["AddVulvaSkin"].get_type_and_id				,0,0,1],		#232
				[*$data_ItemName["AddVulvaAnal"].get_type_and_id				,0,0,1],		#233
				[*$data_ItemName["AddVulvaUrethra"].get_type_and_id				,0,0,1],		#234
				[*$data_ItemName["AddVulvaEsophageal"].get_type_and_id			,0,0,1],		#235
				[*$data_ItemName["AddModTaste"].get_type_and_id					,0,0,1],		#236
				[*$data_ItemName["AddModMilkGland"].get_type_and_id				,0,0,1],		#237
				[*$data_ItemName["AddModSterilization"].get_type_and_id			,0,0,1],		#238
				[*$data_ItemName["AddModVagGlandsSurgical"].get_type_and_id		,0,0,1],		#239
				
				[*$data_ItemName["AidModVagGlandsLink"].get_type_and_id			,0,0,1],		#258
				[*$data_ItemName["AidVulvaMilkGland"].get_type_and_id			,0,0,1],		#259
				[*$data_ItemName["AidVulvaSkin"].get_type_and_id				,0,0,1],		#260
				[*$data_ItemName["AidVulvaAnal"].get_type_and_id				,0,0,1],		#261
				[*$data_ItemName["AidVulvaUrethra"].get_type_and_id				,0,0,1],		#262
				[*$data_ItemName["AidVulvaEsophageal"].get_type_and_id			,0,0,1],		#263
				[*$data_ItemName["AidModTaste"].get_type_and_id					,0,0,1],		#264
				[*$data_ItemName["AidModMilkGland"].get_type_and_id				,0,0,1],		#265
				[*$data_ItemName["AidModSterilization"].get_type_and_id			,0,0,1],		#266
				[*$data_ItemName["AidModVagGlandsSurgical"].get_type_and_id		,0,0,1],			#267

				[*$data_ItemName["AddModExpandedBooba"].get_type_and_id		,0,0,1],
				[*$data_ItemName["AidModExpandedBooba"].get_type_and_id		,0,0,1]

				]
				good << [*$data_ItemName["ItemBerserkDrug"].get_type_and_id	,nil,20000,1] if $story_stats["RecQuestElise"] >= 40 #ItemBerserkDrug

			manual_trade(good,charStoreHashName,charStoreTP,charStoreExpireDate,noSell=false,noBuy=false)

		when "PregnancyCheck"
			call_msg("TagMapNoerEliseGynecology:elise/preg_check_begin1")
			portrait_off
			tmpAggro = false
			chcg_background_color(0,0,0,0,7)
				wait(30)
				3.times{
					$game_portraits.lprt.shake
					$game_map.interpreter.flash_screen(Color.new(255,0,0,200),8,true)
					SndLib.sound_combat_hit_gore(90,50+rand(100))
					wait(30)+rand(60)
				}
				if $game_player.actor.preg_level >= 1
					$story_stats["HiddenOPT1"] = $game_player.actor.preg_whenGiveBirth?-(rand(5)-2)
					$game_player.actor.stat["displayBabyHealth"] = 1
					call_msg("TagMapNoerEliseGynecology:elise/preg_check_win0")
					call_msg("TagMapNoerEliseGynecology:elise/preg_check_win1")
					call_msg("TagMapNoerEliseGynecology:elise/preg_check_win2")
					$story_stats["HiddenOPT1"] = "0"
					
				else
					tmpAggro = true
					call_msg("TagMapNoerEliseGynecology:elise/preg_check_failed0")
					get_character(0).actor.set_aggro($game_player.actor,$data_arpgskills["BasicNormal"],600)
				end
				portrait_hide
				wait(30)
			chcg_background_color(0,0,0,255,-7)
			call_msg("TagMapNoerEliseGynecology:elise/preg_check_failed1") if tmpAggro
		
		when "OrcResearch"
			call_msg("CompElise:OrkindResearch1/begin0")
			call_msg("CompElise:OrkindResearch1/begin1")
			call_msg("CompElise:OrkindResearch1/begin2")
			case $game_temp.choice 
				when 0,-1
					call_msg("CompElise:OrkindResearch1/begin2_No")
				when 1
					
					set_comp=false
					if $game_temp.choice ==1 && $game_player.record_companion_name_ext == nil
						set_comp=true
					elsif $game_temp.choice ==1 && $game_player.record_companion_name_ext != nil
						$game_temp.choice = -1
						call_msg("commonComp:notice/ExtOverWrite")
						call_msg("common:Lona/Decide_optD")
						if $game_temp.choice ==1
							set_comp=true
						end
					end
					if set_comp
						call_msg("CompElise:OrkindResearch1/begin2_Yes1")
						portrait_hide
							chcg_background_color(0,0,0,0,7)
							get_character(0).set_this_event_companion_ext("CompExtUniqueElise",false,10+$game_date.dateAmt)
							get_character(0).delete
							$game_map.reserve_summon_event("CompExtUniqueElise",$game_player.x,$game_player.y)
							chcg_background_color(0,0,0,255,-7)
						call_msg("CompElise:OrkindResearch1/begin2_Yes2")
					end
			end
			
		when "FishtopiaIsle"
			#return call_msg("dev") #################################################################################### REMOVE AFTER ITS DONE
			if $game_player.player_slave?
				call_msg("CompElise:FishResearch1/slaveBlock")
				return eventPlayEnd
			end
			call_msg("CompElise:FishResearch1/begin0")
			call_msg("CompElise:FishResearch1/begin1")
			call_msg("CompElise:FishResearch1/begin2")
			case $game_temp.choice 
				when 0,-1
					call_msg("CompElise:OrkindResearch1/begin2_No")
				when 1
					
					set_comp=false
					if $game_temp.choice ==1 && $game_player.record_companion_name_ext == nil
						set_comp=true
					elsif $game_temp.choice ==1 && $game_player.record_companion_name_ext != nil
						$game_temp.choice = -1
						call_msg("commonComp:notice/ExtOverWrite")
						call_msg("common:Lona/Decide_optD")
						if $game_temp.choice ==1
						set_comp=true
						end
					end
					if set_comp
						call_msg("CompElise:OrkindResearch1/begin2_Yes1")
						portrait_hide
							chcg_background_color(0,0,0,0,7)
							get_character(0).set_this_event_companion_ext("CompExtUniqueElise",false,10+$game_date.dateAmt)
							get_character(0).delete
							$game_map.reserve_summon_event("CompExtUniqueElise",$game_player.x,$game_player.y)
							chcg_background_color(0,0,0,255,-7)
						call_msg("CompElise:OrkindResearch1/begin2_Yes2")
					end
			end

			when"SellBaby"
				call_msg("TagMapNoerEliseGynecology:elise/sell_baby_begin1")
				tmpAbom = $game_party.item_number($data_items[71]) #PlayerAbominationBaby
				
				
				temp_val=0
				$game_party.all_items.each{
					|item|
					next if !item.type.eql?("Baby")
					next if item.addData["MouthStats"] == "Human"
					next if item.addData["MouthStats"] == "Moot"
					amt=$game_party.item_number(item)
					for i in 0...amt
					temp_val += item.price
					end
				}
				tar_price= temp_val #$game_party.get_item_type_price("Baby")
				tar_price*=10
				
				
				
				temp_val=0
				$game_party.all_items.each{
					|item|
					next if !item.type.eql?("Baby")
					next if item.addData["MouthStats"] == "Human"
					next if item.addData["MouthStats"] == "Moot"
					amt=$game_party.item_number(item)
					$game_party.lose_item(item,$game_party.item_number(item),true)
				}
				#$game_party.lost_item_type("Baby")
				portrait_hide
				chcg_background_color(0,0,0,0,7)
					wait(60)
					portrait_off
				chcg_background_color(0,0,0,255,-7)
				optain_item_chain(tar_price,["ItemCoin1","ItemCoin2","ItemCoin3"],false)
				
				call_msg("TagMapNoerEliseGynecology:elise/sell_baby_begin2")
				call_msg("TagMapNoerEliseGynecology:elise/sell_baby_begin3") if $story_stats["RecQuestEliseBabySale"] == 0
				$story_stats["RecQuestEliseBabySale"] += 1
				$story_stats["RecQuestEliseAbomBabySale"] += tmpAbom
				
		end # case
	end # end day_talk


$story_stats["HiddenOPT1"] = "0"
$story_stats["HiddenOPT2"] = "0"
$game_temp.choice = -1

prev_RecQuestEliseAbortion = $story_stats["RecQuestEliseAbortion"]
############################################################### 手術演出 ##############################################################################
if $game_party.has_item_type("SurgeryCoupon")
	call_msg("TagMapNoerEliseGynecology:elise/surgery_begin0")
	portrait_hide
	chcg_background_color(0,0,0,0,7)
		portrait_off
		call_msg("TagMapNoerEliseGynecology:elise/surgery_begin1")
		tmpDoTricketX,tmpDoTricketY,tmpDoTricketID=$game_map.get_storypoint("DoTricket")
		tar_elise=get_character(0)
		$game_player.moveto(get_character(tmpDoTricketID).x,get_character(tmpDoTricketID).y) ; $game_player.direction = 2
		$game_player.animation = $game_player.animation_overfatigue
		get_character(0).moveto($game_player.x-1,$game_player.y) ; get_character(0).direction = 6
		portrait_hide
	chcg_background_color(0,0,0,255,-7)
	
	call_msg("TagMapNoerEliseGynecology:elise/surgery_begin2")
	portrait_hide
	chcg_background_color(0,0,0,0,7)
		portrait_off
	
		call_msg("TagMapNoerEliseGynecology:elise/surgery_begin3") 				if !$game_party.has_item?($data_items[201])#墮胎票
		
		no_end_dialog =0
		#結渣卷 沒懷孕
		call_msg("TagMapNoerEliseGynecology:elise/surgery_begin3_Miscarriage") 	if $game_party.has_item?($data_items[201])
		if $game_party.has_item?($data_items[201]) && $game_player.actor.preg_level ==0 #有墮胎票但沒懷孕 #id 201
			map_background_color(0,0,0,255,0)
			call_msg("TagMapNoerEliseGynecology:elise/surgery_begin3_Miscarriage_nopreg1")
			call_msg("TagMapNoerEliseGynecology:elise/surgery_begin3_Miscarriage_nopreg2")
			$game_player.actor.health = 0
			return load_script("Data/HCGframes/OverEvent_Death.rb")
		elsif $game_party.has_item?($data_items[201]) && $game_player.actor.preg_level >=1
			#墮胎票 有懷孕
			map_background_color(0,0,0,255,0)
			portrait_hide
			wait(15)
			SndLib.sys_equip
			wait(30)
			call_msg("TagMapNoerEliseGynecology:elise/surgery_begin3_Miscarriage_endFB")
			6.times{
				$game_portraits.lprt.shake
				$game_map.interpreter.flash_screen(Color.new(255,0,0,200),8,true)
				SndLib.sound_combat_hit_gore(90,50+rand(100))
				wait(30)+rand(60)
			}
			portrait_hide
			wait(10)
			tmpRecRace = $game_player.actor.baby_race
			tmpRecRace = "OthersElise" if tmpRecRace == "Others"
			tmpPregLvl = $game_player.actor.preg_level
			load_script("Data/HCGframes/BirthEvent_Miscarriage.rb")
			portrait_off
			wait(30)
			SndLib.sys_equip
			wait(30)
			$game_message.add("#{$game_text["TagMapNoerEliseGynecology:elise/surgery_begin3_Miscarriage_endF1"]}#{$game_text["DataNpcName:race/#{tmpRecRace}"]}#{$game_text["TagMapNoerEliseGynecology:elise/surgery_begin3_Miscarriage_endF2"]}#{$game_text["TagMapNoerEliseGynecology:elise/surgery_begin3_Miscarriage_endF3_preg_level#{tmpPregLvl}"]}")
			$game_map.interpreter.wait_for_message
			portrait_hide
			no_end_dialog = 0
			$story_stats["RecQuestEliseAbortion"] += 1
		end
		
		#治療烙印
		if $game_party.has_item?($data_items[208])
			$story_stats["SlaveOwner"] = 0
		end
		
		$game_party.force_use_item_type("SurgeryCoupon")
		$game_party.lost_item_type("SurgeryCoupon")
		
		
		
		########################################################## 手術完成
	map_background_color
	$game_player.animation = nil
	chcg_background_color(0,0,0,255,-7)
	if no_end_dialog ==0
		call_msg("TagMapNoerEliseGynecology:elise/surgery_end")
		portrait_hide
	end
	#return eveny thing to normal
	portrait_hide
	chcg_background_color(0,0,0,0,7)
		portrait_off
		cam_center(0)
		get_character(tmpDoTricketID).summon_data[:canSleep] = true
		posi=$game_map.get_storypoint("elise")
		get_character(0).moveto(posi[0],posi[1]) ; get_character(0).direction = 2
	chcg_background_color(0,0,0,255,-7)
end

$story_stats["HiddenOPT1"] = "0"
$story_stats["HiddenOPT2"] = "0"
$story_stats["HiddenOPT3"] = "0"
achCheckEliseAbortion if $story_stats["RecQuestEliseAbortion"] != prev_RecQuestEliseAbortion
eventPlayEnd


##### check balloon
get_character(0).call_balloon(0)

tmpQ1 = $game_party.item_number($data_items[27]) >= 4
return get_character(0).call_balloon(28,-1) if $story_stats["QuProgStaHerbCollect"]==1 && tmpQ1
return if $DEMO
tmpDay = $game_date.day?
tmpQ1 = $story_stats["RecQuestElise"] == 1
tmpQ2 = $game_date.dateAmt >= $story_stats["RecQuestEliseAmt"]
return get_character(0).call_balloon(28,-1) if tmpQ1 && tmpQ2 && tmpDay
tmpQ1= $game_party.has_item?($data_items[107])
tmpQ2=$story_stats["RecQuestElise"] ==4
return get_character(0).call_balloon(28,-1) if tmpQ1 && tmpQ2 && tmpDay
tmpQ1 = $game_date.dateAmt >= $story_stats["RecQuestEliseAmt"]
tmpQ2 = $story_stats["RecQuestElise"] == 6
return get_character(0).call_balloon(28,-1) if tmpDay && tmpQ1 && tmpQ2
return get_character(0).call_balloon(28,-1) if $story_stats["RecQuestElise"] == 7
#幫麗莎治療
tmpQ2 = $story_stats["RecQuestLisa"] == 15
tmpQ3 = $game_player.record_companion_name_ext == "CompExtUniqueLisaDown"
return get_character(0).call_balloon(28,-1) if tmpQ2 && tmpQ3
####