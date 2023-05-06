-- params : ...
-- function num : 0 , upvalues : _ENV
require("Game.ConfigData.ConfigData")
local ConfigDataLoader = {}
local data_name_list = {
{"assist_level", "assist_level"}
, 
{"assist_team", "assist_team"}
, 
{"init_logic", "init_logic"}
, 
{"factory", "factory"}
, 
{"shop", "shop"}
, 
{"shop_normal", "shop_normal"}
, 
{"item_currency", "item_currency_price"}
, 
{"lottery_para", "lottery_para"}
, 
{"lottery_group", "lottery_group"}
, 
{"lottery", "lottery"}
, 
{"lottery_reward_pool", "lottery_reward_pool"}
, 
{"lottery_selection", "lottery_selection"}
, 
{"lottery_preview", "lottery_preview"}
, 
{"login_popup_ui", "login_popup_ui"}
, 
{"login_popup_client_ctrl", "login_popup_client_ctrl"}
, 
{"building", "oasis_building"}
, 
{"oasis_weather_preset", "oasis_weather_preset"}
, 
{"oasis_building_model", "oasis_building_model"}
, 
{"oasis_weather", "oasis_weather"}
, 
{"buildingLevel", "oasis_building_level"}
, 
{"buildingBuff", "building_buff"}
, 
{"training", "training"}
, 
{"task", "task"}
, 
{"taskStep", "task_step"}
, 
{"sectorAchievement", "sector_achievement"}
, 
{"game_config", "game_config"}
, 
{"hero_data", "hero_data"}
, 
{"hero_level", "hero_level"}
, 
{"hero_skill", "hero_skill"}
, 
{"hero_skill_level", "hero_skill_level"}
, 
{"hero_rank", "hero_rank"}
, 
{"hero_star", "hero_star"}
, 
{"item", "item"}
, 
{"item_type_tag", "item_type_tag"}
, 
{"item_time_limit", "item_time_limit"}
, 
{"sector", "sector"}
, 
{"sector_stage", "sector_stage"}
, 
{"sector_act_des_cover", "sector_act_des_cover"}
, 
{"sector_stage_bgm", "sector_stage_bgm"}
, 
{"sector_unlock_mention", "sector_unlock_mention"}
, 
{"sector_power_limit", "sector_power_limit"}
, 
{"active", "active"}
, 
{"achievement_level", "achievement_level"}
, 
{"achievement", "achievement"}
, 
{"chip", "chip"}
, 
{"chip_tag", "chip_tag"}
, 
{"chip_intro", "chip_intro"}
, 
{"chip_mark", "chip_mark"}
, 
{"resource_model", "resource_model"}
, 
{"model_spec_sign", "model_spec_sign"}
, 
{"reward_purchase", "reward_purchase"}
, 
{"camp", "camp"}
, 
{"career", "career"}
, 
{"camp_connection", "camp_connection"}
, 
{"camp_active_skill", "camp_active_skill"}
, 
{"exploration_treasure", "exploration_treasure"}
, 
{"treasure_logic2", "treasure_logic2"}
, 
{"monster", "monster"}
, 
{"monster_stage", "monster_stage"}
, 
{"event", "event"}
, 
{"event_choice", "event_choice"}
, 
{"event_upgrade", "event_upgrade"}
, 
{"event_jump", "event_jump"}
, 
{"event_assist", "event_assist"}
, 
{"event_assist_ex", "event_assist_ex"}
, 
{"event_partfusion", "event_partfusion"}
, 
{"event_replace_txt", "event_replace_txt"}
, 
{"exploration_reconsitution", "exploration_reconsitution"}
, 
{"exploration", "exploration"}
, 
{"exploration_monster_room", "exploration_monster_room"}
, 
{"exploration_type", "exploration_type"}
, 
{"ep_function_pool", "exploration_function_pool"}
, 
{"ep_mvp_special", "ep_mvp_special"}
, 
{"attribute", "attribute"}
, 
{"exploration_buff", "exploration_buff"}
, 
{"exploration_buff_logic", "exploration_buff_logic"}
, 
{"exploration_roomtype", "exploration_roomtype"}
, 
{"exploration_shop", "exploration_shop"}
, 
{"exploration_exroom", "exploration_exroom"}
, 
{"audio_category", "audio_category"}
, 
{"audio_voice", "audio_voice"}
, 
{"audio_voice_point", "audio_voice_point"}
, 
{"system_open", "system_open"}
, 
{"guide", "guide"}
, 
{"guide_step", "guide_step"}
, 
{"tips_guide", "tips_guide"}
, 
{"exploration_guide", "exploration_guide"}
, 
{"oasis_area", "oasis_area"}
, 
{"system_jump", "system_jump"}
, 
{"arithmetic", "arithmetic"}
, 
{"ath_affix_pool", "ath_affix_pool"}
, 
{"ath_attribute_pool", "ath_attribute_pool"}
, 
{"ath_efficiency", "ath_efficiency"}
, 
{"ath_suit", "ath_suit"}
, 
{"ath_area", "ath_area"}
, 
{"ath_shard", "ath_shard"}
, 
{"ath_affix_lv", "ath_affix_lv"}
, 
{"ath_reconsitution", "ath_reconsitution"}
, 
{"anti_addiction", "anti_addiction"}
, 
{"dorm_house", "dorm_house"}
, 
{"dorm_room", "dorm_room"}
, 
{"dorm_comfort", "dorm_comfort"}
, 
{"dorm_furniture", "dorm_furniture"}
, 
{"dorm_fnt_category", "dorm_fnt_category"}
, 
{"dorm_ai", "dorm_ai"}
, 
{"dorm_action", "dorm_action"}
, 
{"dorm_interpoint", "dorm_interpoint"}
, 
{"dorm_hero_talk", "dorm_hero_talk"}
, 
{"dorm_room_unlock", "dorm_room_unlock"}
, 
{"dorm_hero_greet", "dorm_hero_greet"}
, 
{"dorm_special_hero", "dorm_special_hero"}
, 
{"dorm_theme", "dorm_theme"}
, 
{"tip_language", "tip_language"}
, 
{"label_text", "label_text"}
, 
{"star_score", "star_score"}
, 
{"life_skill", "life_skill"}
, 
{"friendship_level", "friendship_level"}
, 
{"friendship_gift", "friendship_gift"}
, 
{"friendship_hero", "friendship_hero"}
, 
{"friendship_foster", "friendship_foster"}
, 
{"friendship_total_level", "friendship_total_level"}
, 
{"battle_dungeon", "battle_dungeon"}
, 
{"battle_dungeon_dungeon", "battle_dungeon_dungeon"}
, 
{"battle_dungeon_period_drop", "battle_dungeon_period_drop"}
, 
{"material_dungeon", "material_dungeon"}
, 
{"dungeon_tower", "dungeon_tower"}
, 
{"dungeon_tower_type", "dungeon_tower_type"}
, 
{"dungeon_tower_racing", "dungeon_tower_racing"}
, 
{"formation_rule", "formation_rule"}
, 
{"common_ranklist", "common_ranklist"}
, 
{"hero_score", "hero_score"}
, 
{"scene", "scene"}
, 
{"level_arrange", "level_arrange"}
, 
{"overclock", "overclock"}
, 
{"event_random", "event_random"}
, 
{"story_avg", "story_avg"}
, 
{"story_condition_text", "story_condition_text"}
, 
{"commander_skill", "commander_skill"}
, 
{"commander_skill_unlock", "commander_skill_unlock"}
, 
{"commander_skill_level", "commander_skill_level"}
, 
{"commander_skill_master_level", "commander_skill_master_level"}
, 
{"battle_skill_hurt_result_config", "battle_skill_hurt_result_config"}
, 
{"battle_skill_heal_result_config", "battle_skill_heal_result_config"}
, 
{"monster_tag", "monster_tag"}
, 
{"battle_grid", "battle_grid"}
, 
{"grid_creation", "grid_creation"}
, 
{"shop_page", "shop_page"}
, 
{"shop_des", "shop_des"}
, 
{"shop_hero", "shop_hero"}
, 
{"shop_resource", "shop_resource"}
, 
{"shop_recharge", "shop_recharge"}
, 
{"exploration_discard", "exploration_discard"}
, 
{"banner", "banner"}
, 
{"avg_character", "avg_character"}
, 
{"homeside_info", "homeside_info"}
, 
{"homeside_switch", "homeside_switch"}
, 
{"overload", "overload"}
, 
{"dungeon_info", "dungeon_info"}
, 
{"attr_combat", "attr_combat"}
, 
{"battle_skill", "battle_skill"}
, 
{"battle_creation", "battle_creation"}
, 
{"performance_device", "performance_device"}
, 
{"performance_gpu", "performance_gpu"}
, 
{"performance_setting", "performance_setting"}
, 
{"performance_typeinfo", "performance_typeinfo"}
, 
{"hero_potential", "hero_potential"}
, 
{"daily_challenge", "daily_challenge"}
, 
{"skill_label_info", "skill_label_info"}
, 
{"dungeonSubInfo", "dungeonSubInfo"}
, 
{"factory_order", "factory_order"}
, 
{"rookie_star", "rookie_star"}
, 
{"dungeon_material_count", "dungeon_material_count"}
, 
{"offline_push", "offline_push"}
, 
{"loading_tips", "loading_tips"}
, 
{"pay_sdk", "pay_sdk"}
, 
{"pay_product", "pay_product"}
, 
{"pay_recharge", "pay_recharge"}
, 
{"battlepass_type", "battlepass_type"}
, 
{"battlepass", "battlepass"}
, 
{"month_card", "month_card"}
, 
{"daily_bonus", "daily_bonus"}
, 
{"daily_bonus_time", "daily_bonus_time"}
, 
{"mail", "mail"}
, 
{"skin", "skin"}
, 
{"skinTheme", "skinTheme"}
, 
{"skin_live2d", "skin_live2d"}
, 
{"skin_lable", "skin_skin_lable"}
, 
{"shop_classification", "shop_classification"}
, 
{"shop_classification", "shop_classification"}
, 
{"navigation_main", "navigation_main"}
, 
{"navigation_sub", "navigation_sub"}
, 
{"weekly_challenge", "weekly_challenge"}
, 
{"banner_tv", "banner_tv"}
, 
{"weekly_challenge_score", "weekly_challenge_score"}
, 
{"weekly_challenge_rank_reward", "weekly_challenge_rank_reward"}
, 
{"weekly_challenge_base_reward", "weekly_challenge_base_reward"}
, 
{"weekly_challenge_shop", "weekly_challenge_shop"}
, 
{"tower_data_shop", "tower_data_shop"}
, 
{"weekly_challenge_config", "weekly_challenge_config"}
, 
{"sign_activity", "sign_activity"}
, 
{"sign_activity_award", "sign_activity_award"}
, 
{"pay_gift_type", "pay_gift_type"}
, 
{"gift_daily", "gift_daily"}
, 
{"shop_recommend", "shop_recommend"}
, 
{"friendship_award", "friendship_award"}
, 
{"activity_name", "activity_name"}
, 
{"monster_level", "monster_level"}
, 
{"wave_battles", "wave_battles"}
, 
{"endless", "endless"}
, 
{"endless_layer", "endless_layer"}
, 
{"recommend_dialogue", "recommend_dialogue"}
, 
{"warehouse", "warehouse"}
, 
{"sector_career_info", "sector_career_info"}
, 
{"chat_cd", "chat_cd"}
, 
{"chat", "chat"}
, 
{"portrait", "portrait"}
, 
{"portrait_frame", "portrait_frame"}
, 
{"portrait_card", "portrait_card"}
, 
{"noun_des", "noun_des"}
, 
{"noun_des_type", "noun_des_type"}
, 
{"training_task", "training_task"}
, 
{"support_limit", "support_limit"}
, 
{"support_count", "support_count"}
, 
{"support_fix", "support_fix"}
, 
{"tower_hero_data", "tower_hero_data"}
, 
{"tower_monster_data", "tower_monster_data"}
, 
{"game_set_describe", "game_set_describe"}
, 
{"game_set_group", "game_set_group"}
, 
{"wechat_activity", "wechat_activity"}
, 
{"hero_merge", "hero_merge"}
, 
{"dorm_fight", "dorm_fight"}
, 
{"activity_double", "activity_double"}
, 
{"activity_return", "activity_return"}
, 
{"activity_time_limit", "activity_time_limit"}
, 
{"activity_time_limit_pool_para", "activity_time_limit_pool_para"}
, 
{"tower_data_monster_strength", "tower_data_monster_strength"}
, 
{"skill_adapter", "skill_adapter"}
, 
{"challenge_appearance", "challenge_appearance"}
, 
{"activity_reward", "activity_reward"}
, 
{"activity_hero", "activity_hero"}
, 
{"activity_entrance", "activity_entrance"}
, 
{"weekly_challenge_warning", "weekly_challenge_warning"}
, 
{"activity_tech_line", "activity_tech_line"}
, 
{"activity_tech", "activity_tech"}
, 
{"activity_tech_level", "activity_tech_level"}
, 
{"activity_winter", "activity_winter"}
, 
{"activity_winter_challenge_award", "activity_winter_challenge_award"}
, 
{"activity_winter_dungeon_detail", "activity_winter_dungeon_detail"}
, 
{"activity_winter_level_type", "activity_winter_level_type"}
, 
{"activity_winter_level_pos", "activity_winter_level_pos"}
, 
{"activity_winter_sector_stage_extra", "activity_winter_sector_stage_extra"}
, 
{"activity_winter_sector_story_extra", "activity_winter_sector_story_extra"}
, 
{"activity_winter_challenge_score", "activity_winter_challenge_score"}
, 
{"dungeon_buff", "dungeon_buff"}
, 
{"common_logic_des", "common_logic_des"}
, 
{"hero_talent", "hero_talent"}
, 
{"hero_talent_tree", "hero_talent_tree"}
, 
{"hero_talent_effect", "hero_talent_effect"}
, 
{"battle_buff_replace", "battle_buff_replace"}
, 
{"battle_buff", "battle_buff"}
, 
{"flappy_bird", "flappy_bird"}
, 
{"defeat_jump", "defeat_jump"}
, 
{"battle_mvp", "battle_mvp"}
, 
{"background", "background"}
, 
{"main_interface", "main_interface"}
, 
{"activity_user_return", "activity_user_return"}
, 
{"task_activity", "task_activity"}
, 
{"system_rule", "system_rule"}
, 
{"avatar_part", "avatar_part"}
, 
{"activity", "activity"}
, 
{"activity_carnival_env", "activity_carnival_env"}
, 
{"activity_carnival_exp", "activity_carnival_exp"}
, 
{"activity_carnival_level", "activity_carnival_level"}
, 
{"activity_carnival", "activity_carnival"}
, 
{"activity_tech_branch", "activity_tech_branch"}
, 
{"activity_carnival_difficulty", "activity_carnival_difficulty"}
, 
{"activity_carnival_catalog", "activity_carnival_catalog"}
, 
{"customized_gift", "customized_gift"}
, 
{"mash_up", "mash_up"}
, 
{"activity_carnival_level_detail", "activity_carnival_level_detail"}
, 
{"handbook", "handbook"}
, 
{"tiny_game_type", "tiny_game_type"}
, 
{"activity_tiny_game_main", "activity_tiny_game_main"}
, 
{"activity_tiny_game_point", "activity_tiny_game_point"}
, 
{"activity_tiny_game_avg_pre_condition", "activity_tiny_game_avg_pre_condition"}
, 
{"handbook_activity", "handbook_activity"}
, 
{"activity_dailychallenge", "activity_dailychallenge"}
, 
{"activity_dailychallenge_dungeon", "activity_dailychallenge_dungeon"}
, 
{"activity_dailychallenge_award", "activity_dailychallenge_award"}
, 
{"activity_summer_main", "activity_summer_main"}
, 
{"activity_summer_entrance_name", "activity_summer_entrance_name"}
, 
{"activity_summer_level_detail", "activity_summer_level_detail"}
, 
{"activity_summer_warchess_pos", "activity_summer_warchess_pos"}
, 
{"activity_summer_warchess_story_pos", "activity_summer_warchess_story_pos"}
, 
{"warchess_level", "warchess_level"}
, 
{"warchess_buff", "warchess_buff"}
, 
{"warchess_level_real_rewards", "warchess_level_real_rewards"}
, 
{"spec_weapon_basic_config", "spec_weapon_basic_config"}
, 
{"spec_weapon_step", "spec_weapon_step"}
, 
{"spec_weapon_level", "spec_weapon_level"}
, 
{"spec_weapon_points", "spec_weapon_points"}
, 
{"spec_weapon_skill_des", "spec_weapon_skill_des"}
, 
{"tiny_snake", "tiny_snake"}
, 
{"activity_hero_token_reward", "activity_hero_token_reward"}
, 
{"activity_hero_ui_config", "activity_hero_ui_config"}
, 
{"activity_hero_task_daily", "activity_hero_task_daily"}
, 
{"activity_hero_level_detail", "activity_hero_level_detail"}
, 
{"task_unlock_type", "task_unlock_type"}
, 
{"task_unlock", "task_unlock"}
, 
{"monster_lable", "monster_lable"}
, 
{"monster_lable_theme", "monster_lable_theme"}
, 
{"warchess_season_score_show", "warchess_season_score_show"}
, 
{"activity_hallowmas_main", "activity_hallowmas_main"}
, 
{"activity_tech_type", "activity_tech_type"}
, 
{"season_battle_ex", "season_battle_ex"}
, 
{"warchess_room_type", "warchess_room_type"}
, 
{"activity_spring_interact", "activity_spring_interact"}
, 
{"activity_general", "activity_general"}
, 
{"share", "share"}
, 
{"share_QRCode", "share_QRCode"}
, 
{"activity_general_term_task", "activity_general_term_task"}
, 
{"activity_general_daily_task", "activity_general_daily_task"}
, 
{"title", "title"}
, 
{"title_background", "title_background"}
, 
{"room_special_deploy", "room_special_deploy"}
, 
{"dorm_fight_fx", "dorm_fight_fx"}
, 
{"dorm_fight_config", "dorm_fight_config"}
, 
{"activity_head", "activity_head"}
, 
{"active_level", "active_level"}
, 
{"pay_gift_pop_des", "pay_gift_pop_des"}
, 
{"activity_angela_main", "activity_angela_main"}
, 
{"official_assist", "official_assist"}
, 
{"banner_mail_npic", "banner_mail_npic"}
}
ConfigDataLoader.LoadConfigHead = "LuaConfigs."
ConfigDataLoader.GetConfigNameList = function()
  -- function num : 0_0 , upvalues : data_name_list
  return data_name_list
end

ConfigDataLoader.AfterLoadConfigComplete = function()
  -- function num : 0_1 , upvalues : data_name_list, _ENV
  data_name_list = nil
  ConfigData:InitConfigData()
  require("Game.ConfigData.LanguageUtil")
  ;
  ((CS.GameData).instance):InitGameConfigFromLua(ConfigData.game_config, ConfigData.buildinConfig)
end

return ConfigDataLoader

