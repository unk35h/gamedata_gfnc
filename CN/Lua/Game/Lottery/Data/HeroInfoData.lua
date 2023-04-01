-- params : ...
-- function num : 0 , upvalues : _ENV
local HeroInfoData = class("HeroInfoData")
local HeroData = require("Game.PlayerData.Hero.HeroData")
local HeroTalentData = require("Game.HeroTalent.HeroTalentData")
HeroInfoData.ctor = function(self)
  -- function num : 0_0
end

HeroInfoData.InitData = function(self, heroId)
  -- function num : 0_1 , upvalues : _ENV, HeroData
  self.heroId = heroId
  self.heroCfg = (ConfigData.hero_data)[heroId]
  self.career = (self.heroCfg).career
  self.camp = (self.heroCfg).camp
  local dataDic = {}
  dataDic.basic = {id = self.heroId}
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (dataDic.basic).potentialLvl = (ConfigData.game_config).heroMaxPotential
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (dataDic.basic).level = (ConfigData.game_config).heroMaxLevel
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (dataDic.basic).star = (ConfigData.hero_rank).maxStar
  self.heroData = (HeroData.New)(dataDic)
  self.rankCfg = (self.heroData).rankCfg
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.heroData).isRemoveAllBounce = true
  self.__notHaveLegalSkin = nil
  self:RefreshData()
end

HeroInfoData.GenMaxTalent = function(self)
  -- function num : 0_2 , upvalues : _ENV, HeroTalentData
  if (ConfigData.buildinConfig).HeroTalentForbid then
    return 
  end
  local talentCfg = (ConfigData.hero_talent)[self.heroId]
  if talentCfg == nil then
    error(" talent is NIL")
    return 
  end
  local fackerTalent = (HeroTalentData.CreateWithMaxLevel)(talentCfg)
  ;
  (self.heroData):BindHeroDataTalent(fackerTalent)
end

HeroInfoData.GenSpecWeaopn = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local weaponId = (PlayerDataCenter.allSpecWeaponData):GetHeroSpecWeaponId(self.heroId)
  if weaponId or 0 > 0 then
    local weaponData = (PlayerDataCenter.allSpecWeaponData):CreateVistualMaxWeapon(weaponId)
    ;
    (self.heroData):BindHeroSpecWeapon(weaponData)
    ;
    (self.heroData):ReplaceHeroSkill()
  end
end

HeroInfoData.RefreshData = function(self)
  -- function num : 0_4
  self:UpdateSkin()
end

HeroInfoData.UpdateSkin = function(self)
  -- function num : 0_5 , upvalues : _ENV
  self.skinId = (PlayerDataCenter.skinData):DealNotSelfHaveHeroSkinOverraid(0, self.heroId)
  self.__notHaveLegalSkin = self.skinId == nil
  local skinCtr = ControllerManager:GetController(ControllerTypeId.Skin, true)
  self.resCfg = skinCtr:GetResModel(self.heroId, self.skinId)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HeroInfoData.GetResPicName = function(self)
  -- function num : 0_6
  if not (self.resCfg).src_id_pic then
    return (self.resCfg).res_Name
  end
end

HeroInfoData.GetHeroInfoMaxLevel = function(heroId, potential)
  -- function num : 0_7 , upvalues : _ENV
  local hero_max_potentialCfg = ((ConfigData.hero_potential)[heroId])[potential]
  if hero_max_potentialCfg == nil then
    return (ConfigData.game_config).heroMaxLevel
  end
  return hero_max_potentialCfg.level_max
end

HeroInfoData.GetHeroInfoIsNotHaveLegalSkin = function(self)
  -- function num : 0_8
  return self.__notHaveLegalSkin
end

return HeroInfoData

