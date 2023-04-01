-- params : ...
-- function num : 0 , upvalues : _ENV
local UINADCRewardNode = class("UINADCRewardNode", UIBaseNode)
local base = UIBaseNode
local UINADCRewardItem = require("Game.ActivityDailyChallenge.UI.UINADCRewardItem")
local UINADCRewardPreiview = require("Game.ActivityDailyChallenge.UI.UINADCRewardPreiview")
UINADCRewardNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINADCRewardItem, UINADCRewardPreiview
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).closeBG, self, self.Hide)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ScoreReward, self, self.Hide)
  ;
  (UIUtil.AddButtonListener)((self.ui).bottom, self, self.OnClickCycleReward)
  self.__OnClickRewardCallback = BindCallback(self, self.OnClickReward)
  self._itemPool = (UIItemPool.New)(UINADCRewardItem, (self.ui).item)
  ;
  ((self.ui).item):SetActive(false)
  self._previewNode = (UINADCRewardPreiview.New)()
  ;
  (self._previewNode):Init((self.ui).rewardFrame)
  ;
  (self._previewNode):Hide()
end

UINADCRewardNode.InitADCRewardNode = function(self, adcData, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._adcData = adcData
  self._cycleCfg = adcData:GetADCCycleAward()
  self._callback = callback
  ;
  (self._itemPool):HideAll()
  local awardCfgList = (self._adcData):GetADCAwardCfg()
  for i,cfg in ipairs(awardCfgList) do
    local item = (self._itemPool):GetOne()
    item:InitADCRewardItem(self._adcData, i, self.__OnClickRewardCallback)
  end
  ;
  (((self.ui).exItem).transform):SetAsLastSibling()
  self:__RefreshExtra()
  self:__RefreshNextStage()
  ;
  (self._previewNode):Hide()
end

UINADCRewardNode.RefreshADCRewardNode = function(self)
  -- function num : 0_2 , upvalues : _ENV
  for i,v in ipairs((self._itemPool).listItem) do
    v:RefreshADCRewardItem()
  end
  self:__RefreshExtra()
  self:__RefreshNextStage()
  ;
  (self._previewNode):Hide()
end

UINADCRewardNode.__RefreshExtra = function(self)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_Score).text = tostring((self._adcData):GetADCTotalPoint())
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R1 in 'UnsetPending'

  if (self._adcData):GetADCTotalPoint() < (self._adcData):GetADCMaxFixedPoint() then
    ((self.ui).img_progressCircle).fillAmount = 0
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).text).text = "0/" .. tostring((self._cycleCfg).need_point)
    return 
  end
  local basePoint = (math.max)((self._adcData):GetADCCycleGotPoint(), (self._adcData):GetADCMaxFixedPoint())
  local diff = (self._adcData):GetADCTotalPoint() - basePoint
  -- DECOMPILER ERROR at PC47: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_progressCircle).fillAmount = diff / (self._cycleCfg).need_point
  -- DECOMPILER ERROR at PC59: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).text).text = tostring(diff) .. "/" .. tostring((self._cycleCfg).need_point)
end

UINADCRewardNode.__RefreshNextStage = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local awardCfg = (self._adcData):GetADCAwardCfg()
  local curPoint = (self._adcData):GetADCTotalPoint()
  local extraCfg = (self._adcData):GetADCCycleAward()
  local nextPoint = 0
  for index,cfg in ipairs(awardCfg) do
    if curPoint < cfg.need_point then
      nextPoint = cfg.need_point
      break
    end
  end
  do
    do
      if nextPoint == 0 then
        local diff = curPoint - (self._adcData):GetADCMaxFixedPoint()
        diff = (math.floor)(diff / extraCfg.need_point) + 1
        nextPoint = (self._adcData):GetADCMaxFixedPoint() + (diff) * extraCfg.need_point
      end
      -- DECOMPILER ERROR at PC44: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.ui).tex_num).text = tostring(nextPoint)
    end
  end
end

UINADCRewardNode.OnClickReward = function(self, awardCfg, item)
  -- function num : 0_5 , upvalues : _ENV
  if not (self._adcData):IsCanADCFixedReward(awardCfg.need_point) then
    self:__ShowPreview(awardCfg, (item.transform).position, (self._adcData):IsReceiveADCFixedReward(awardCfg.need_point))
    return 
  end
  ;
  (self._adcData):ReqADCScoreReward(awardCfg.need_point, false, function()
    -- function num : 0_5_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:RefreshADCRewardNode()
      if self._callback ~= nil then
        (self._callback)()
      end
    end
  end
)
end

UINADCRewardNode.OnClickCycleReward = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if not (self._adcData):IsCanADCExtraReward() then
    self:__ShowPreview(self._cycleCfg, (((self.ui).exItem).transform).position, false)
    return 
  end
  ;
  (self._adcData):ReqADCScoreReward(nil, true, function()
    -- function num : 0_6_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:RefreshADCRewardNode()
      if self._callback ~= nil then
        (self._callback)()
      end
    end
  end
)
end

UINADCRewardNode.__ShowPreview = function(self, awardCfg, pos, isPicked)
  -- function num : 0_7
  pos = (((self._previewNode).transform).parent):InverseTransformPoint(pos)
  pos.y = (((self._previewNode).transform).localPosition).y
  pos.z = (((self._previewNode).transform).localPosition).z
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self._previewNode).transform).localPosition = pos
  ;
  (self._previewNode):Show()
  ;
  (self._previewNode):InitADCAwardPreview(awardCfg, isPicked)
end

return UINADCRewardNode

