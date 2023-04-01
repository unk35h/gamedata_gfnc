-- params : ...
-- function num : 0 , upvalues : _ENV
local AllSkinData = class("AllSkinData")
AllSkinData.ctor = function(self)
  -- function num : 0_0
  self.skinDic = {}
  self.flatSkinDic = {}
  self.L2dHideDic = {}
end

AllSkinData.UpdateData = function(self, data)
  -- function num : 0_1 , upvalues : _ENV
  for heroId,v in pairs(data) do
    -- DECOMPILER ERROR at PC6: Confused about usage of register: R7 in 'UnsetPending'

    (self.skinDic)[heroId] = v.unlockSkin
    for skinId,_ in pairs(v.unlockSkin) do
      -- DECOMPILER ERROR at PC12: Confused about usage of register: R12 in 'UnsetPending'

      (self.flatSkinDic)[skinId] = true
    end
    for key,skinId in pairs(v.L2DHide) do
      self:UpdateHideL2dBg(heroId, skinId, true)
    end
  end
end

AllSkinData.UpdateHeroDefaultSkin = function(self, heroId)
  -- function num : 0_2 , upvalues : _ENV
  local heroCfg = (ConfigData.hero_data)[heroId]
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  if (self.skinDic)[heroId] == nil then
    (self.skinDic)[heroId] = {}
  end
  local defaultSkinId = heroCfg.default_skin
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.skinDic)[heroId])[defaultSkinId] = true
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.flatSkinDic)[defaultSkinId] = true
end

AllSkinData.GetHeroIdBySkinId = function(self, skinId)
  -- function num : 0_3 , upvalues : _ENV
  local skinCtrl = ControllerManager:GetController(ControllerTypeId.Skin, true)
  local heroId = skinCtrl:GetHeroId(skinId)
  return heroId
end

AllSkinData.IsHaveSkin = function(self, skinId)
  -- function num : 0_4 , upvalues : _ENV
  if skinId or 0 == 0 then
    warn("skin \"0\" is out of data, pls update it to real skin id!")
    return true
  end
  if not self:IsSkinUnlocked(skinId) then
    return false
  end
  return (self.flatSkinDic)[skinId]
end

AllSkinData.RecordLive2dSwitchState = function(self, heroId, skinId, isOpen)
  -- function num : 0_5 , upvalues : _ENV
  if self.live2dSwitchDic == nil then
    if isOpen then
      return 
    end
    self.live2dSwitchDic = {}
  end
  if (self.live2dSwitchDic)[heroId] == nil then
    if isOpen then
      return 
    end
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self.live2dSwitchDic)[heroId] = {}
  end
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R4 in 'UnsetPending'

  if isOpen then
    ((self.live2dSwitchDic)[heroId])[skinId] = nil
  else
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.live2dSwitchDic)[heroId])[skinId] = true
  end
  MsgCenter:Broadcast(eMsgEventId.OnHeroLive2dChange, heroId, skinId, isOpen)
end

AllSkinData.GetLive2dSwitchState = function(self, heroId, skinId)
  -- function num : 0_6 , upvalues : _ENV
  if not skinId or skinId == 0 then
    skinId = ((ConfigData.hero_data)[heroId]).default_skin
  end
  local isL2DRectify = self:IsL2dRectify(skinId)
  if isL2DRectify then
    return false
  end
  if self.live2dSwitchDic == nil then
    return true
  end
  if (self.live2dSwitchDic)[heroId] == nil then
    return true
  end
  do return ((self.live2dSwitchDic)[heroId])[skinId] == nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

AllSkinData.IsSkinUnlocked = function(self, skinId)
  -- function num : 0_7 , upvalues : _ENV
  if skinId == 0 then
    warn("skin 0 is out of data, pls update it to real skin id!")
    return true
  end
  local skinCfg = (ConfigData.skin)[skinId]
  if skinCfg == nil then
    return true
  end
  if skinCfg.skin_locked then
    return false
  end
  if skinCfg.rectify_skin and not (self.flatSkinDic)[skinId] then
    return false, true
  end
  return true
end

AllSkinData.GetAltSkinResName = function(self, skinResName)
  -- function num : 0_8 , upvalues : _ENV
  local skinId = ((ConfigData.skin).skinRes2SkinId)[skinResName]
  if skinId == nil then
    return skinResName
  end
  local skinCfg = (ConfigData.skin)[skinId]
  local src_id_pic_rectify = skinCfg.src_id_pic_rectify
  if not (string.IsNullOrEmpty)(src_id_pic_rectify) and (self.flatSkinDic)[skinId] then
    return src_id_pic_rectify
  end
  return skinResName
end

AllSkinData.UpdateHideL2dBg = function(self, heroId, skinId, isHide)
  -- function num : 0_9
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self.L2dHideDic)[skinId] = isHide
end

AllSkinData.GetHideL2dDic = function(self)
  -- function num : 0_10
  return self.L2dHideDic
end

AllSkinData.IsHideL2dBg = function(self, skinId)
  -- function num : 0_11
  if not self:IsHaveSkin(skinId) then
    return false
  end
  if (self.L2dHideDic)[skinId] == nil then
    return false
  end
  return (self.L2dHideDic)[skinId]
end

AllSkinData.IsL2dRectify = function(self, skinId)
  -- function num : 0_12 , upvalues : _ENV
  local live2dConfig = (ConfigData.skin_live2d)[skinId]
  if live2dConfig ~= nil then
    return live2dConfig.rectify_l2d
  end
  return false
end

AllSkinData.IsHaveL2d = function(self, skinId)
  -- function num : 0_13 , upvalues : _ENV
  if self:IsL2dRectify(skinId) then
    return false
  end
  local skinCfg = (ConfigData.skin)[skinId]
  if skinCfg.live2d_level <= 0 then
    do return skinCfg == nil end
    do return false end
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

AllSkinData.DealNotSelfHaveHeroSkinOverraid = function(self, skinId, heroId)
  -- function num : 0_14 , upvalues : _ENV
  if (self.flatSkinDic)[skinId] ~= nil then
    return skinId
  end
  local heroCfg = (ConfigData.hero_data)[heroId]
  if skinId == 0 then
    skinId = heroCfg.default_skin
  end
  local GetNextLevelSkin = function(theSkinId, isInit)
    -- function num : 0_14_0 , upvalues : _ENV, self, skinId, heroCfg, GetNextLevelSkin
    if theSkinId == nil then
      return nil
    end
    local skinCfg = (ConfigData.skin)[theSkinId]
    if skinCfg == nil then
      return nil
    end
    if not skinCfg.rectify_skin or (self.flatSkinDic)[skinId] ~= nil then
      return theSkinId
    end
    if skinCfg.theme < 1 or skinCfg.theme > 3 then
      if isInit then
        theSkinId = heroCfg.default_skin
      else
        return nil
      end
    else
      local targetTheme = skinCfg.theme + 1
      theSkinId = nil
      for _,id in ipairs(heroCfg.skin) do
        local tempSkinCfg = (ConfigData.skin)[id]
        if tempSkinCfg.theme == targetTheme then
          theSkinId = id
          break
        end
      end
    end
    do
      return GetNextLevelSkin(theSkinId, false)
    end
  end

  local skinCfg = (ConfigData.skin)[skinId]
  if skinCfg.rectify_skin then
    skinId = heroCfg.default_skin
    skinId = GetNextLevelSkin(skinId, true)
  end
  return skinId
end

return AllSkinData

