-- params : ...
-- function num : 0 , upvalues : _ENV
local AllSpecWeaponData = class("AllSpecWeaponData")
local SpecWeaponData = require("Game.SpecWeapon.SpecWeaponData")
AllSpecWeaponData.ctor = function(self)
  -- function num : 0_0 , upvalues : _ENV
  local systemOpenCfg = (ConfigData.system_open)[proto_csmsg_SystemFunctionID.SystemFunctionID_SpecWeapon]
  self._screening = (systemOpenCfg ~= nil and systemOpenCfg.screening)
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

AllSpecWeaponData.CreateOrUpdateHeroWeapon = function(self, heroData, weaponId, step, level)
  -- function num : 0_1 , upvalues : SpecWeaponData
  if self._screening then
    return 
  end
  local specWeapon = heroData:GetHeroDataSpecWeapon(weaponId)
  if specWeapon ~= nil then
    specWeapon:RefreshSpecWeapon(step, level)
  else
    specWeapon = (SpecWeaponData.New)()
    specWeapon:InitSpecWeapon(weaponId, step, level)
    heroData:BindHeroSpecWeapon(specWeapon)
  end
end

AllSpecWeaponData.GetHeroSpecWeaponId = function(self, heroId)
  -- function num : 0_2 , upvalues : _ENV
  if self._screening then
    return nil
  end
  local heroMapping = (ConfigData.spec_weapon_basic_config).heroWeaponMapping
  local weaponList = heroMapping[heroId]
  return weaponList ~= nil and weaponList[1] or nil
end

AllSpecWeaponData.ContainHeroSpecWeapon = function(self, heroId)
  -- function num : 0_3
  do return self:GetHeroSpecWeaponId(heroId) ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

AllSpecWeaponData.IsUnlockSpecWeaponSystem = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self._screening then
    return false
  end
  return FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_SpecWeapon)
end

AllSpecWeaponData.CreateVistualMaxWeapon = function(self, weaponId)
  -- function num : 0_5 , upvalues : _ENV, SpecWeaponData
  if self._screening then
    return nil
  end
  local maxStep = ((ConfigData.spec_weapon_step).stepDic)[weaponId]
  local maxLevel = ((ConfigData.spec_weapon_level).levelDic)[weaponId]
  local specWeapon = (SpecWeaponData.New)()
  specWeapon:InitSpecWeapon(weaponId, maxStep, maxLevel)
  return specWeapon
end

AllSpecWeaponData.LvupHeroSpecWeapon = function(self, weaponId, count, callBack)
  -- function num : 0_6 , upvalues : _ENV
  if not self:IsUnlockSpecWeaponSystem() then
    return 
  end
  local cfg = (ConfigData.spec_weapon_basic_config)[weaponId]
  if cfg == nil or not (CheckCondition.CheckLua)(cfg.pre_condition, cfg.pre_para1, cfg.pre_para2) then
    return 
  end
  local heroData = PlayerDataCenter:GetHeroData(cfg.hero_id)
  if heroData == nil then
    return 
  end
  local specWeaponData = heroData:GetHeroDataSpecWeapon(weaponId)
  if specWeaponData == nil then
    return 
  end
  if not count then
    count = 1
  end
  if count == 1 and not specWeaponData:IsSpecWeaponCouldUprage() then
    return 
  else
    if count > 1 and not specWeaponData:IsSpecWeaponCouldMultipleUprage(count) then
      return 
    end
  end
  if self._network == nil then
    self._network = NetworkManager:GetNetwork(NetworkTypeID.SpecWeapon)
  end
  local curStep = specWeaponData:GetSpecWeaponCurStep()
  local curLevel = specWeaponData:GetSpecWeaponCurLevel()
  local successFunc = function()
    -- function num : 0_6_0 , upvalues : _ENV, callBack
    MsgCenter:Broadcast(eMsgEventId.SpecWeaponLvUp)
    if callBack ~= nil then
      callBack()
    end
  end

  if curStep == 0 then
    (self._network):CS_SpecWeapon_Unlock(weaponId, function()
    -- function num : 0_6_1 , upvalues : successFunc
    successFunc()
  end
)
  else
    if specWeaponData:IsSpecWeaponContinueStep() then
      (self._network):CS_SpecWeapon_Step(weaponId, function()
    -- function num : 0_6_2 , upvalues : successFunc
    successFunc()
  end
)
    else
      local targetLevel = specWeaponData:GetSpecWeaponCurLevel() + count
      ;
      (self._network):CS_SpecWeapon_Upgrade(weaponId, targetLevel, function()
    -- function num : 0_6_3 , upvalues : successFunc
    successFunc()
  end
)
    end
  end
end

AllSpecWeaponData.GetSpecWeaponLevelPointCfg = function(self, weaponId)
  -- function num : 0_7 , upvalues : _ENV
  return ConfigData.spec_weapon_points
end

AllSpecWeaponData.IsSpecWeaponCloseQuickEnhanceTip = function(self)
  -- function num : 0_8
  return self._isCloseQuickEnhanceTip
end

AllSpecWeaponData.SetSpecWeaponCloseQuickEnhanceTip = function(self, flag)
  -- function num : 0_9
  self._isCloseQuickEnhanceTip = flag
end

return AllSpecWeaponData

