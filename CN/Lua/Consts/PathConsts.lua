-- params : ...
-- function num : 0 , upvalues : _ENV
local cs_PathConsts = CS.PathConsts
local cs_FilePathHelper = (CS.FilePathHelper).Instance
local CS_LanguageGlobal = CS.LanguageGlobal
PathConsts = {SpriteAtlasExtension = cs_PathConsts.SpriteAtlasExtension, PrefabExtension = cs_PathConsts.PrefabExtension, DataExtension = ".dat", UnityConfigAssetExtension = ".asset", SpriteAtlasPathHead = cs_PathConsts.SpriteAtlasPathHead, UIPrefabPathHead = cs_PathConsts.UIPrefabPathHead, ModelPrefabPath = cs_PathConsts.ModelPrefabPath, OasisBuildingPath = cs_PathConsts.OasisBuildingPrefabPath, OasisBuildingEffectPath = "Res/Effect/Prefabs/OasisBuilding/", SectorPath = "Res/Model/Sector/", PbFilePath = "Res/pb/", SkillIconPathHead = "SkillIcons/", CharacterPicPathHead = cs_PathConsts.CharacterPicPathHead, CharacterBigImgPrefabHead = cs_PathConsts.CharacterBigImgPrefabHead, FriendshipDungeonPicHead = "HeroStoryLevel/", MaterialDungeonPicHead = "MaterialLevel/Background/", OasisBuildingIconPath = "OasisBuilding/", AchievementIconPath = "Res/Images/AchievementIcon/", AchivLevelIconPath = "AchivLevelIcon/", MaterialDungeonBGIconPath = "MaterialLevel/Icon/", DormPath = "Res/Model/Dorm/", DormRoomPath = "Res/Model/Dorm/Rooms/", DormFntPath = "Res/Model/Dorm/Furnitures/", AvgImgPath = "Avg/", AvgNounImgPath = "Avg/NounDes/", FormationPath = "Res/Model/Formation/", ShowCharacterSkinPath = "Res/Model/Formation/", CampIconPath = "CampIcon/", SpecWeaponPath = "SpecWeapon/", EffectPath = "Res/Effect/Prefabs/", PersistentUserDataPath = cs_PathConsts.PersistentDataPath .. "save_data/user_data/", PersistentDataPath = cs_PathConsts.PersistentDataPath .. "save_data/", PersistentDeployDataPath = cs_PathConsts.PersistentDataPath .. "save_data/deploy_data/", PersistentBannerCachePath = cs_PathConsts.PersistentDataPath .. "res_cache/banner_img/", PersistentNoticeCachePath = cs_PathConsts.PersistentDataPath .. "res_cache/notice_cache/", PersistentShareImgPath = cs_PathConsts.PersistentDataPath .. "shareImgTemp.png", SectorBackgroundPath = "SectorLevel/", BannerPicPath = "HomeAdv/", LotteryPicPath = "Lottery/", LotteryModelPath = "Res/Model/LotteryShow/", SeceneIconPicPath = "SectorIcon/", ImagePath = "Res/Images/", FactoryPath = "Res/Model/Factory/", CampVideoPath = "GetHero/", UltSkillVideoPath = "UltSkill/", SectorLoadVideoPath = "SectorLoading/", SectorCompleteVideoPath = "SectorAnimation/", LuaSkillScriptsPath = cs_PathConsts.LuaSkillScriptsPath, TreeDCanvasPath = "Res/UIPrefabs/Common/", FestivalSignPath = "Res/UIPrefabs/FestivalSignIn/", ShopGiftBgPath = "Shop/GiftBag/", ShopRecommendPath = "Shop/Recommend/", ShopFurnitureThemePath = "Shop/FurnitureTheme/", GuideTipsPathHead = "Guide/", UserInfoDressUpPathHead = "UserInfoDressUp/", TitleBgPath = "TitleIcon", FestivalBackgroundPath = "FestivalSign/", HeroSkinThemePicPath = "HeroSkinTheme/", CharDunStageIconPath = "CharDunMapImage/", CharDunPrefabPath = "Res/UIPrefabs/CharacterDungeon/", CharDunEntrancePicPath = "Activity/CharDun/", CharDunPicPath = "CharDun/", MainSceneBgTexturePath = "MainSceneBg/", MainSceneDeckPrefabPath = "Res/Effect/Prefabs/MainSceneDeck/", WhiteDayPath = "Activity/WhiteDay22/", AprilFoolPath = "Activity/AprilFool22/", WarChessCharacterPath = "Res/Model/Fbx/Character/", WarChessPrefabPath = "Res/WarChess/GridPrefabs/", WarChessAreaPrefabPath = "Res/WarChess/AreaPrefab/", WarChessUINodePath = "Res/UIPrefabs/WarChess/", WarChessEffectPath = "FX/Warchess/ScenesEffect/", ActivityOpenVedio = "Activity/"}
-- DECOMPILER ERROR at PC110: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetImagePath = function(self, name)
  -- function num : 0_0
  return self.ImagePath .. name .. ".png"
end

-- DECOMPILER ERROR at PC113: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetHeroVideoPath = function(self, videoName)
  -- function num : 0_1
  return self.CampVideoPath .. videoName
end

-- DECOMPILER ERROR at PC116: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetSectorLoadVideoPath = function(self, videoName)
  -- function num : 0_2
  return self.SectorLoadVideoPath .. videoName
end

-- DECOMPILER ERROR at PC119: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetFullPrefabPath = function(self, prefabPath)
  -- function num : 0_3
  return prefabPath .. self.PrefabExtension
end

-- DECOMPILER ERROR at PC122: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetModelPrefabPath = function(self, prefabName)
  -- function num : 0_4
  return self.ModelPrefabPath .. prefabName .. self.PrefabExtension
end

-- DECOMPILER ERROR at PC125: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetUIPrefabPath = function(self, resName)
  -- function num : 0_5 , upvalues : _ENV
  if (string.IsNullOrEmpty)(resName) then
    return ""
  else
    return self.UIPrefabPathHead .. resName .. self.PrefabExtension
  end
end

-- DECOMPILER ERROR at PC128: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetOasisBuildingPrefabPath = function(self, resName)
  -- function num : 0_6 , upvalues : _ENV
  if (string.IsNullOrEmpty)(resName) then
    return ""
  else
    return self.OasisBuildingPath .. resName .. self.PrefabExtension
  end
end

-- DECOMPILER ERROR at PC131: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetOasisBuildingEffetPrefabPath = function(self, resName)
  -- function num : 0_7 , upvalues : _ENV
  if (string.IsNullOrEmpty)(resName) then
    return ""
  else
    return self.OasisBuildingEffectPath .. resName .. self.PrefabExtension
  end
end

-- DECOMPILER ERROR at PC134: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetOasisPrefabPath = function(self, resName)
  -- function num : 0_8 , upvalues : _ENV
  if (string.IsNullOrEmpty)(resName) then
    return ""
  else
    return "Res/Model/Oasis/" .. resName .. self.PrefabExtension
  end
end

-- DECOMPILER ERROR at PC137: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetSectorPrefabPath = function(self, resName)
  -- function num : 0_9 , upvalues : _ENV
  if (string.IsNullOrEmpty)(resName) then
    return ""
  else
    return self.SectorPath .. resName .. self.PrefabExtension
  end
end

-- DECOMPILER ERROR at PC140: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetSkillIconPath = function(self, skillIcon)
  -- function num : 0_10
  return self:GetResImagePath(self.SkillIconPathHead .. skillIcon .. ".png")
end

-- DECOMPILER ERROR at PC143: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetProfessorModelPath = function(self, sexName, resName)
  -- function num : 0_11
  return self.CharacterPicPathHead .. sexName .. "/" .. resName .. self.PrefabExtension
end

-- DECOMPILER ERROR at PC146: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCharacterTexturePath = function(self, path)
  -- function num : 0_12
  return self.CharacterPicPathHead .. path .. ".png"
end

-- DECOMPILER ERROR at PC149: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCharacterLive2DPath = function(self, resName)
  -- function num : 0_13 , upvalues : cs_FilePathHelper
  return cs_FilePathHelper:GetAssetLangPath(self.CharacterPicPathHead .. resName .. "/L2D/" .. resName, self.PrefabExtension)
end

-- DECOMPILER ERROR at PC152: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCharacterFaceImgPath = function(self, resName, faceId)
  -- function num : 0_14
  return self.CharacterPicPathHead .. resName .. "/Face/" .. resName .. "_face_" .. faceId .. ".png"
end

-- DECOMPILER ERROR at PC155: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCharacterPicPath = function(self, resName)
  -- function num : 0_15 , upvalues : _ENV
  resName = (PlayerDataCenter.skinData):GetAltSkinResName(resName)
  return self.CharacterPicPathHead .. resName .. "/npic_" .. resName .. ".png"
end

-- DECOMPILER ERROR at PC158: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCharacterBigImgPrefabPath = function(self, resName)
  -- function num : 0_16 , upvalues : _ENV, cs_FilePathHelper
  resName = (PlayerDataCenter.skinData):GetAltSkinResName(resName)
  return cs_FilePathHelper:GetAssetLangPath(self.CharacterBigImgPrefabHead .. resName .. "/lpic_" .. resName, self.PrefabExtension)
end

-- DECOMPILER ERROR at PC161: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCharacterSmallPicPath = function(self, resName)
  -- function num : 0_17 , upvalues : _ENV
  resName = (PlayerDataCenter.skinData):GetAltSkinResName(resName)
  return self.CharacterPicPathHead .. resName .. "/spic_" .. resName .. ".png"
end

-- DECOMPILER ERROR at PC164: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCharacterModelPathEx = function(self, prefabName, specSign, perfectLevel)
  -- function num : 0_18 , upvalues : cs_FilePathHelper
  if not specSign then
    specSign = 0
  end
  if not perfectLevel then
    perfectLevel = -1
  end
  return cs_FilePathHelper:GetCharacterModelPathEx(prefabName, specSign, perfectLevel)
end

-- DECOMPILER ERROR at PC167: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCharacterActivityLobbyModelPath = function(self, prefabName)
  -- function num : 0_19
  return self.CharacterBigImgPrefabHead .. prefabName .. "/amodel_" .. prefabName .. self.PrefabExtension
end

-- DECOMPILER ERROR at PC170: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCharacterDormModelPath = function(self, prefabName, specSign)
  -- function num : 0_20 , upvalues : _ENV
  if not specSign then
    specSign = 0
  end
  do
    if specSign > 0 then
      local modelSignCfg = (ConfigData.model_spec_sign)[specSign]
      if modelSignCfg ~= nil then
        return self.CharacterBigImgPrefabHead .. prefabName .. "/" .. modelSignCfg.pre_sign .. "dmodel_" .. prefabName .. self.PrefabExtension
      end
    end
    return self.CharacterBigImgPrefabHead .. prefabName .. "/dmodel_" .. prefabName .. self.PrefabExtension
  end
end

-- DECOMPILER ERROR at PC173: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCharacterFightModelPath = function(self, prefabName, specSign)
  -- function num : 0_21 , upvalues : _ENV
  if not specSign then
    specSign = 0
  end
  do
    if specSign > 0 then
      local modelSignCfg = (ConfigData.model_spec_sign)[specSign]
      if modelSignCfg ~= nil then
        return self.CharacterBigImgPrefabHead .. prefabName .. "/" .. modelSignCfg.pre_sign .. "fmodel_" .. prefabName .. self.PrefabExtension
      end
    end
    return self.CharacterBigImgPrefabHead .. prefabName .. "/fmodel_" .. prefabName .. self.PrefabExtension
  end
end

-- DECOMPILER ERROR at PC176: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetFriendshipDungeonPicPath = function(self, resName)
  -- function num : 0_22
  return self:GetResImagePath(self.FriendshipDungeonPicHead .. "HeroStory" .. resName .. ".png")
end

-- DECOMPILER ERROR at PC179: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetMaterailDungeonPicPath = function(self, resName)
  -- function num : 0_23
  return self:GetResImagePath(self.MaterialDungeonPicHead .. "MatBg" .. resName .. ".png")
end

-- DECOMPILER ERROR at PC182: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetOasisBuildingIconPath = function(self, resName)
  -- function num : 0_24
  return self:GetResImagePath(self.OasisBuildingIconPath .. resName .. ".png")
end

-- DECOMPILER ERROR at PC185: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetMaterialDungeonBGIconPath = function(self, resName)
  -- function num : 0_25
  return self:GetResImagePath(self.MaterialDungeonBGIconPath .. resName .. ".png")
end

-- DECOMPILER ERROR at PC188: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetAchivLevelIconPath = function(self, resName)
  -- function num : 0_26
  return self:GetResImagePath(self.AchivLevelIconPath .. resName .. ".png")
end

-- DECOMPILER ERROR at PC191: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetDormPath = function(self, resName)
  -- function num : 0_27
  return self.DormPath .. resName .. self.PrefabExtension
end

-- DECOMPILER ERROR at PC194: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetDormRoomPath = function(self, resName)
  -- function num : 0_28
  return self.DormRoomPath .. resName .. self.PrefabExtension
end

-- DECOMPILER ERROR at PC197: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetDormFntPath = function(self, resName)
  -- function num : 0_29 , upvalues : cs_FilePathHelper
  return cs_FilePathHelper:GetAssetLangPath(self.DormFntPath .. resName, self.PrefabExtension)
end

-- DECOMPILER ERROR at PC200: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetVideoFilePathWitLang = function(self, videoPath)
  -- function num : 0_30 , upvalues : cs_FilePathHelper
  return cs_FilePathHelper:GetVideoFilePathWitLang(videoPath)
end

-- DECOMPILER ERROR at PC203: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetDormFntThemeIconPath = function(self, resName)
  -- function num : 0_31
  return self:GetResImagePath("Dorm/FurnitureTheme/" .. resName .. ".png")
end

-- DECOMPILER ERROR at PC206: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetAvgImgPath = function(self, name)
  -- function num : 0_32
  return self:GetResImagePath(self.AvgImgPath .. name .. ".png")
end

-- DECOMPILER ERROR at PC209: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetFormationModelPath = function(self, prefabName)
  -- function num : 0_33
  return self.FormationPath .. prefabName .. self.PrefabExtension
end

-- DECOMPILER ERROR at PC212: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCampPicPath = function(self, resName)
  -- function num : 0_34
  return self:GetResImagePath(self.CampIconPath .. resName .. ".png")
end

-- DECOMPILER ERROR at PC215: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetSpecWeaponPicPath = function(self, resName)
  -- function num : 0_35
  return self:GetResImagePath(self.SpecWeaponPath .. resName .. ".png")
end

-- DECOMPILER ERROR at PC218: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetAvgNounImgPath = function(self, ImgName)
  -- function num : 0_36
  return self:GetResImagePath(self.AvgNounImgPath .. ImgName .. ".png")
end

-- DECOMPILER ERROR at PC221: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetAtlasAssetPath = function(self, atlasName)
  -- function num : 0_37
  return self.SpriteAtlasPathHead .. atlasName .. self.SpriteAtlasExtension
end

-- DECOMPILER ERROR at PC224: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetEffectPath = function(self, prefabName)
  -- function num : 0_38
  return self.EffectPath .. prefabName .. self.PrefabExtension
end

-- DECOMPILER ERROR at PC227: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetPersistentUserDataPath = function(self, strplayerId)
  -- function num : 0_39
  return self.PersistentUserDataPath .. strplayerId .. self.DataExtension
end

-- DECOMPILER ERROR at PC230: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetPersistentSystemDataPath = function(self, fileName)
  -- function num : 0_40
  return self.PersistentDataPath .. fileName .. self.DataExtension
end

-- DECOMPILER ERROR at PC233: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetPersistentDeployDataPath = function(self, strplayerId, fileName)
  -- function num : 0_41
  return self.PersistentDeployDataPath .. strplayerId .. "/" .. fileName .. self.DataExtension
end

-- DECOMPILER ERROR at PC236: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetPersistentBannerCachePath = function(self, fileName)
  -- function num : 0_42
  return self.PersistentBannerCachePath .. fileName .. ".png"
end

-- DECOMPILER ERROR at PC239: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetPersistentNoticeCachePath = function(self, fileName)
  -- function num : 0_43
  return self.PersistentNoticeCachePath .. fileName .. ".png"
end

-- DECOMPILER ERROR at PC242: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetSectorBackgroundPath = function(self, resName)
  -- function num : 0_44
  return self:GetResImagePath(self.SectorBackgroundPath .. resName .. ".png")
end

-- DECOMPILER ERROR at PC245: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetSectorStrategyOverviewBgPath = function(self, resName)
  -- function num : 0_45
  return self:GetResImagePath("StrategyOverview/" .. resName .. ".png")
end

-- DECOMPILER ERROR at PC248: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetBannerPicPath = function(self, fileName)
  -- function num : 0_46
  return self:GetResImagePath(self.BannerPicPath .. fileName .. ".png")
end

-- DECOMPILER ERROR at PC251: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetLotteryPicPath = function(self, fileName)
  -- function num : 0_47
  return self:GetResImagePath(self.LotteryPicPath .. fileName .. ".png")
end

-- DECOMPILER ERROR at PC254: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetLotteryModelPath = function(self, fileName)
  -- function num : 0_48
  return self.LotteryModelPath .. fileName .. self.PrefabExtension
end

-- DECOMPILER ERROR at PC257: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetSeceneIconPicPath = function(self, resName)
  -- function num : 0_49
  return self:GetResImagePath(self.SeceneIconPicPath .. resName .. ".png")
end

-- DECOMPILER ERROR at PC260: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetFactoryPath = function(self, resName)
  -- function num : 0_50
  return self.FactoryPath .. resName .. self.PrefabExtension
end

-- DECOMPILER ERROR at PC263: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetSpriteAtlasPath = function(self, resName)
  -- function num : 0_51
  return self.SpriteAtlasPathHead .. resName .. ".spriteatlas"
end

-- DECOMPILER ERROR at PC266: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetTreeDCanvasPath = function(self, canvasName)
  -- function num : 0_52
  return self.TreeDCanvasPath .. canvasName .. ".prefab"
end

-- DECOMPILER ERROR at PC269: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetShopGiftBgPath = function(self, resName)
  -- function num : 0_53
  return self:GetResImagePath(self.ShopGiftBgPath .. resName .. ".png")
end

-- DECOMPILER ERROR at PC272: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetShopFurnitureThemePath = function(self, resName)
  -- function num : 0_54
  return self:GetResImagePath(self.ShopFurnitureThemePath .. resName .. ".png")
end

-- DECOMPILER ERROR at PC275: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetShopRecommendPath = function(self, resName)
  -- function num : 0_55
  return self:GetResImagePath(self.ShopRecommendPath .. resName .. ".png")
end

-- DECOMPILER ERROR at PC278: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetGuideTipsPath = function(self, path, resName)
  -- function num : 0_56
  return self:GetResImagePath(self.GuideTipsPathHead .. path .. "/" .. resName .. ".png")
end

-- DECOMPILER ERROR at PC281: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetUserDressUpPath = function(self, resName)
  -- function num : 0_57
  return self:GetResImagePath(self.UserInfoDressUpPathHead .. resName .. ".png")
end

-- DECOMPILER ERROR at PC284: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetUserTitleBgPath = function(self, resName)
  -- function num : 0_58
  return self.SpriteAtlasPathHead .. self.TitleBgPath .. "/" .. resName .. ".png"
end

-- DECOMPILER ERROR at PC287: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetSectorCompleteVideoPath = function(self, sectorId)
  -- function num : 0_59
  return self.SectorCompleteVideoPath .. "SectorAnimation_" .. sectorId
end

-- DECOMPILER ERROR at PC290: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetFestivalSignPath = function(self, path)
  -- function num : 0_60
  return self.FestivalSignPath .. path .. ".prefab"
end

-- DECOMPILER ERROR at PC293: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetFestivalBgPath = function(self, path)
  -- function num : 0_61
  return self:GetResImagePath(self.FestivalBackgroundPath .. path .. ".png")
end

-- DECOMPILER ERROR at PC296: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetHeroSkinThemePicPath = function(self, path)
  -- function num : 0_62
  return self:GetResImagePath(self.HeroSkinThemePicPath .. path .. ".png")
end

-- DECOMPILER ERROR at PC299: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetDynHeadPath = function(self, resName)
  -- function num : 0_63
  return self:GetResImagePath("DynHead/" .. resName .. ".png")
end

-- DECOMPILER ERROR at PC302: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetDynHeadFramePath = function(self, resName)
  -- function num : 0_64
  return "Res/Effect/Headframe/" .. resName .. ".prefab"
end

-- DECOMPILER ERROR at PC305: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetShowCharacterSkinPrefabPath = function(self, prefabName)
  -- function num : 0_65
  return self.ShowCharacterSkinPath .. prefabName .. self.PrefabExtension
end

-- DECOMPILER ERROR at PC308: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetShowCharacterSkinPrefabPath = function(self, prefabName)
  -- function num : 0_66
  return self.ShowCharacterSkinPath .. prefabName .. self.PrefabExtension
end

-- DECOMPILER ERROR at PC311: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCharDunStageIconPath = function(self, resName)
  -- function num : 0_67
  return self:GetResImagePath(self.CharDunStageIconPath .. resName .. ".png")
end

-- DECOMPILER ERROR at PC314: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCharDunEntrancePicPath = function(self, resName)
  -- function num : 0_68
  return self:GetResImagePath(self.CharDunEntrancePicPath .. resName .. ".png")
end

-- DECOMPILER ERROR at PC317: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCharDunPrefabPath = function(self, resName)
  -- function num : 0_69
  return self.CharDunPrefabPath .. resName .. ".prefab"
end

-- DECOMPILER ERROR at PC320: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCharDunPath = function(self, resName)
  -- function num : 0_70
  return self:GetResImagePath(self.CharDunPicPath .. resName .. ".png")
end

-- DECOMPILER ERROR at PC323: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCharDunVideoPath = function(self, heroID)
  -- function num : 0_71
  return "CharDun/" .. "CharDun_" .. heroID
end

-- DECOMPILER ERROR at PC326: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCharDunVideoFullPath = function(self, heroID)
  -- function num : 0_72
  return "Res/media/videos/CharDun/" .. "CharDun_" .. heroID .. ".usm"
end

-- DECOMPILER ERROR at PC329: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetAvgVideoPath = function(self, pathName)
  -- function num : 0_73
  return "avg/" .. pathName
end

-- DECOMPILER ERROR at PC332: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetGuideVideoPath = function(self, path, name)
  -- function num : 0_74
  return "Guide/" .. path .. "/" .. name
end

-- DECOMPILER ERROR at PC335: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetMainSceneBgPath = function(self, resName)
  -- function num : 0_75
  return self:GetResImagePath(self.MainSceneBgTexturePath .. resName .. ".png")
end

-- DECOMPILER ERROR at PC338: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetMainSceneDeckPath = function(self, resName)
  -- function num : 0_76
  return self.MainSceneDeckPrefabPath .. resName .. ".prefab"
end

-- DECOMPILER ERROR at PC341: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetMainSceneMatPath = function(self, resName)
  -- function num : 0_77
  return "Res/Materials/HomeMainBg/" .. resName .. ".mat"
end

-- DECOMPILER ERROR at PC344: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetWhiteDayPhotoPath = function(self, resName)
  -- function num : 0_78
  return self:GetResImagePath(self.WhiteDayPath .. resName .. ".png")
end

-- DECOMPILER ERROR at PC347: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetWhiteDayLinePath = function(self, resName)
  -- function num : 0_79
  return self:GetResImagePath(self.WhiteDayPath .. resName .. ".png")
end

-- DECOMPILER ERROR at PC350: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetMainBgThumbnail = function(self, resName)
  -- function num : 0_80
  return self:GetResImagePath("MainSceneBgThumbnail/" .. resName .. ".png")
end

-- DECOMPILER ERROR at PC353: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetResImagePath = function(self, relPath)
  -- function num : 0_81 , upvalues : cs_FilePathHelper
  return cs_FilePathHelper:GetResImagePath(relPath)
end

-- DECOMPILER ERROR at PC356: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetAprilFoolLevelPath = function(self, resName)
  -- function num : 0_82
  return self:GetResImagePath(self.AprilFoolPath .. resName .. ".png")
end

-- DECOMPILER ERROR at PC359: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetActivityComebackPrefab = function(self, resName)
  -- function num : 0_83
  return "Res/UIPrefabs/EventComeback/" .. resName .. ".prefab"
end

-- DECOMPILER ERROR at PC362: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetActivityLobbyUIPrefab = function(self, resName)
  -- function num : 0_84
  return "Res/UIPrefabs/ActivityLobby/" .. resName .. ".prefab"
end

-- DECOMPILER ERROR at PC365: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetRoundRewardPoolPic = function(self, resName)
  -- function num : 0_85
  return self:GetResImagePath("RewardPool/" .. resName .. ".png")
end

-- DECOMPILER ERROR at PC368: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCharacterAvatarMainPrefabPath = function(self)
  -- function num : 0_86
  return "Res/Avatar/AvatarMain.prefab"
end

-- DECOMPILER ERROR at PC371: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCharacterAvatarPartPrefabPath = function(self, avatarName, prefabName)
  -- function num : 0_87
  return "Res/Avatar/" .. avatarName .. "/" .. prefabName .. ".prefab"
end

-- DECOMPILER ERROR at PC374: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCharacterPrefab = function(self, resName)
  -- function num : 0_88
  return "Res/Character/" .. resName .. ".prefab"
end

-- DECOMPILER ERROR at PC377: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCarnivalPic = function(self, resName)
  -- function num : 0_89
  return self.ImagePath .. "Activity/Carnival22/" .. resName .. ".png"
end

-- DECOMPILER ERROR at PC380: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetMiniGameItemPic = function(self, resName)
  -- function num : 0_90
  return self.ImagePath .. "Activity/MiniGame/" .. resName .. ".png"
end

-- DECOMPILER ERROR at PC383: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetActLimitTaskPic = function(self, resName)
  -- function num : 0_91
  return self.ImagePath .. "Activity/LimitTask/" .. resName .. ".png"
end

-- DECOMPILER ERROR at PC386: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetHandbookItemPic = function(self, resName)
  -- function num : 0_92
  return self.ImagePath .. "Handbook/" .. resName .. ".png"
end

-- DECOMPILER ERROR at PC389: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetActivityKeyExertionPath = function(self, resName)
  -- function num : 0_93
  return self.ImagePath .. "Activity/LuckyBag/" .. resName .. ".png"
end

-- DECOMPILER ERROR at PC392: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetActivityPath = function(self, resName)
  -- function num : 0_94
  return self.ImagePath .. "Activity/" .. resName .. ".png"
end

-- DECOMPILER ERROR at PC395: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetWarChessCharCtrlPath = function(self, charName)
  -- function num : 0_95 , upvalues : _ENV
  return PathConsts.WarChessCharacterPath .. charName .. "/" .. charName .. "_warchess_animator.controller"
end

-- DECOMPILER ERROR at PC398: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetWarChessPrefabPath = function(self, resName)
  -- function num : 0_96 , upvalues : _ENV
  return PathConsts.WarChessPrefabPath .. resName .. self.PrefabExtension
end

-- DECOMPILER ERROR at PC401: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetWarChessAreaPrefabPath = function(self, resName)
  -- function num : 0_97 , upvalues : _ENV
  return PathConsts.WarChessAreaPrefabPath .. resName .. self.PrefabExtension
end

-- DECOMPILER ERROR at PC404: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetWarChessUINodePrefabPath = function(self, resName)
  -- function num : 0_98
  return self.WarChessUINodePath .. resName .. ".prefab"
end

-- DECOMPILER ERROR at PC407: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetWarChessEffectPrefabPath = function(self, name)
  -- function num : 0_99 , upvalues : _ENV
  return PathConsts.WarChessEffectPath .. name .. self.PrefabExtension
end

-- DECOMPILER ERROR at PC410: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetSpecWeaponVideoPath = function(self, name)
  -- function num : 0_100
  return "SpecWeapon/" .. name
end

-- DECOMPILER ERROR at PC413: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetGiftPopBg = function(self, resName)
  -- function num : 0_101 , upvalues : _ENV
  return PathConsts.ImagePath .. "GiftPopBg/" .. resName .. ".png"
end

-- DECOMPILER ERROR at PC416: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetTinyGamePrefabPath = function(self, name)
  -- function num : 0_102
  return "Res/Model/TinyGame/Prefabs/" .. name .. self.PrefabExtension
end

-- DECOMPILER ERROR at PC419: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetWarChessSeasonPic = function(self, resName)
  -- function num : 0_103
  return self.ImagePath .. "WarChessSeason/" .. resName .. ".png"
end

-- DECOMPILER ERROR at PC422: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetCharDunVer2Bg = function(self, name)
  -- function num : 0_104 , upvalues : _ENV
  return PathConsts.ImagePath .. "CharDun/Ver2/" .. name .. ".png"
end

-- DECOMPILER ERROR at PC425: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetStrategyOverviewItem = function(self, name)
  -- function num : 0_105
  return "Res/UIPrefabs/StrategyOverViewItem/" .. name .. ".prefab"
end

-- DECOMPILER ERROR at PC428: Confused about usage of register: R3 in 'UnsetPending'

PathConsts.GetActivityOpenVedio = function(self, name)
  -- function num : 0_106 , upvalues : _ENV
  return PathConsts.ActivityOpenVedio .. name
end


