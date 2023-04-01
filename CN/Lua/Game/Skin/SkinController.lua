-- params : ...
-- function num : 0 , upvalues : _ENV
local SkinController = class("SkinController", ControllerBase)
local base = ControllerBase
local SkinConditionFunc = require("Game.Skin.SkinConditionFunc")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
SkinController.GetHeroId = function(self, skinId)
  -- function num : 0_0 , upvalues : _ENV
  local cfg = (ConfigData.skin)[skinId]
  if cfg == nil then
    return nil
  end
  return cfg.heroId
end

SkinController.GetResModel = function(self, heroId, skinId)
  -- function num : 0_1 , upvalues : _ENV
  local heroCfg = (ConfigData.hero_data)[heroId]
  local cfg = nil
  if heroCfg ~= nil then
    cfg = (ConfigData.resource_model)[heroCfg.src_id]
  else
    error("hero_data is NULL  id:" .. tostring(heroId))
    return 
  end
  if cfg == nil then
    error("resource_model is NULL  id:" .. tostring(heroCfg.src_id))
    return 
  end
  return self:UpdateResModel(cfg, skinId)
end

SkinController.UpdateResModel = function(self, resmodelCfg, skinId)
  -- function num : 0_2 , upvalues : _ENV
  local cfg = (setmetatable({}, {__index = resmodelCfg}))
  local skinCfg = nil
  if skinId or 0 ~= 0 then
    skinCfg = (ConfigData.skin)[skinId]
  end
  if skinCfg == nil or skinCfg.skin_locked then
    cfg.src_id_pic = resmodelCfg.res_Name
    cfg.src_id_model = resmodelCfg.res_Name
  else
    if not (string.IsNullOrEmpty)(skinCfg.src_id_pic) or not resmodelCfg.res_Name then
      cfg.src_id_pic = skinCfg.src_id_pic
      if not (string.IsNullOrEmpty)(skinCfg.src_id_model) or not resmodelCfg.res_Name then
        cfg.src_id_model = skinCfg.src_id_model
        return cfg
      end
    end
  end
end

SkinController.CheckSourceValid = function(self, skinId)
  -- function num : 0_3 , upvalues : _ENV, SkinConditionFunc
  if skinId == nil or not (PlayerDataCenter.skinData):IsSkinUnlocked(skinId) then
    return false, nil
  end
  local skinCfg = (ConfigData.skin)[skinId]
  if skinCfg == nil then
    return false, nil
  end
  for _,condition in ipairs(skinCfg.conditions) do
    local func = SkinConditionFunc[condition]
    if func ~= nil and func(skinCfg, self) then
      return true, condition
    end
  end
  return false, (skinCfg.conditions)[1]
end

SkinController.CanHideLive2dBg = function(self, skinId)
  -- function num : 0_4 , upvalues : _ENV
  local skinCfg = (ConfigData.skin_live2d)[skinId]
  if skinCfg ~= nil then
    return skinCfg.is_open_hide_bg
  end
  return false
end

SkinController.IsHaveVoice = function(self, skinId)
  -- function num : 0_5 , upvalues : _ENV
  local skinCfg = (ConfigData.skin)[skinId]
  if skinCfg ~= nil then
    return skinCfg.has_voice
  end
  return false
end

SkinController.GetAllSourceValid = function(self, skinId)
  -- function num : 0_6 , upvalues : _ENV, SkinConditionFunc
  if skinId == nil or not (PlayerDataCenter.skinData):IsSkinUnlocked(skinId) then
    return table.emptytable
  end
  local skinCfg = (ConfigData.skin)[skinId]
  if skinCfg == nil then
    return table.emptytable
  end
  local list = nil
  for _,condition in ipairs(skinCfg.conditions) do
    local func = SkinConditionFunc[condition]
    if func ~= nil and func(skinCfg, self) then
      if list == nil then
        list = {}
      end
      ;
      (table.insert)(list, condition)
    end
  end
  if list ~= nil then
    return list
  end
  return table.emptytable
end

SkinController.CheckMouseOpen = function(self, heroId, skinId)
  -- function num : 0_7 , upvalues : _ENV
  do
    if skinId or 0 == 0 then
      local heroCfg = (ConfigData.hero_data)[heroId]
      if heroCfg ~= nil then
        skinId = heroCfg.default_skin
      end
    end
    do return (ConfigData.skin_live2d)[skinId] == nil or ((ConfigData.skin_live2d)[skinId]).mouth_shape == 1 end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
end

SkinController.HeroSkinChange = function(self, heroId, nowSkinCfg, callback)
  -- function num : 0_8 , upvalues : _ENV
  local skinId = 0
  if nowSkinCfg ~= nil and not nowSkinCfg.isdefault_skin then
    skinId = nowSkinCfg.id
  end
  local heroNetCtr = NetworkManager:GetNetwork(NetworkTypeID.Hero)
  heroNetCtr:CS_HERO_SkinChange(heroId, skinId, callback)
  AudioManager:PlayAudioById(1119)
end

SkinController.CheckItemListsForSkins = function(self, itemIdList, callback, CRData)
  -- function num : 0_9
  self.itemIdList = itemIdList
  self._callback = callback
  self.index = 0
  self:_DoNext(CRData)
end

SkinController.GetGoodsBySkinCfg = function(self, skinCfg)
  -- function num : 0_10 , upvalues : _ENV
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Store) then
    return nil
  end
  local param = (skinCfg.conditionParamDic)[proto_csmsg_SystemFunctionID.SystemFunctionID_Store]
  if param == nil then
    return nil
  end
  local shopCtr = ControllerManager:GetController(ControllerTypeId.Shop, true)
  for i,v in ipairs(param) do
    local shopData = (shopCtr.shopDataDic)[v]
    local goodsData = shopData ~= nil and shopData:GetShopGoodDataByItemId(skinCfg.id, true) or nil
    if goodsData ~= nil then
      local isLimitTime, isInTime = goodsData:GetStillTime()
      if not isLimitTime or isInTime then
        return goodsData
      end
    end
  end
  return nil
end

SkinController.GetGiftBySkinCfg = function(self, skinCfg)
  -- function num : 0_11 , upvalues : _ENV
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Gift) then
    return nil
  end
  local param = (skinCfg.conditionParamDic)[proto_csmsg_SystemFunctionID.SystemFunctionID_Gift]
  if param == nil then
    return nil
  end
  local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift)
  if payGiftCtrl == nil then
    return nil
  end
  for _,giftId in ipairs(param) do
    local giftInfo = payGiftCtrl:GetPayGiftDataById(giftId)
    if giftInfo ~= nil and giftInfo:IsUnlock() then
      return giftInfo
    end
  end
  return nil
end

SkinController.GetActFrameDataBySkinCfg = function(self, skinCfg)
  -- function num : 0_12 , upvalues : _ENV
  local actFrameCtr = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  local param = (skinCfg.conditionParamDic)[proto_csmsg_SystemFunctionID.SystemFunctionID_Operate_Active]
  if param == nil then
    return nil
  end
  for i,v in ipairs(param) do
    local actData = actFrameCtr:GetActivityFrameData(v)
    if actData ~= nil and actData:IsActivityOpen() then
      return actData
    end
  end
  return nil
end

SkinController._DoNext = function(self, CRData)
  -- function num : 0_13 , upvalues : _ENV
  self.index = self.index + 1
  if #self.itemIdList < self.index then
    if self._callback ~= nil then
      (self._callback)()
    end
    return 
  end
  local item = (ConfigData.item)[(self.itemIdList)[self.index]]
  local isFirstGetSkin = true
  if CRData ~= nil and CRData.crItemTransDic ~= nil and (CRData.crItemTransDic)[item.id] ~= nil then
    isFirstGetSkin = false
  end
  if item.type == eItemType.Skin and isFirstGetSkin then
    local skin = (ConfigData.skin)[item.id]
    do
      local showWindowFunc = function()
    -- function num : 0_13_0 , upvalues : _ENV, skin, self, CRData
    UIManager:HideWindow(UIWindowTypeID.CommonReward)
    UIManager:ShowWindowAsync(UIWindowTypeID.GetHeroSkin, function(window)
      -- function num : 0_13_0_0 , upvalues : skin, self, CRData
      if window == nil then
        return 
      end
      window:InitGetHeroSkin(skin, function()
        -- function num : 0_13_0_0_0 , upvalues : self, CRData
        self:_DoNext(CRData)
      end
)
    end
)
  end

      if not (string.IsNullOrEmpty)(skin.skin_avg) then
        (ControllerManager:GetController(ControllerTypeId.Avg, true)):ShowAvg(skin.skin_avg, showWindowFunc)
      else
        showWindowFunc()
      end
      return 
    end
  end
  do
    self:_DoNext(CRData)
  end
end

return SkinController

