-- params : ...
-- function num : 0 , upvalues : _ENV
local UINADCRewardItem = class("UINADCRewardItem", UIBaseNode)
local base = UIBaseNode
UINADCRewardItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_icon, self, self.OnClickAwardItem)
end

UINADCRewardItem.InitADCRewardItem = function(self, adcData, index, callback)
  -- function num : 0_1 , upvalues : _ENV
  local awardCfgList = adcData:GetADCAwardCfg()
  self._adcData = adcData
  self._awardCfg = awardCfgList[index]
  self._callback = callback
  if index > 1 then
    local lastPoint = (awardCfgList[index - 1]).need_point
    self._startPoint = lastPoint + ((self._awardCfg).need_point - lastPoint) / 2
  else
    do
      self._startPoint = 0
      if awardCfgList[index + 1] ~= nil then
        local nextPoint = (awardCfgList[index + 1]).need_point
        self._endPoint = (self._awardCfg).need_point + (nextPoint - (self._awardCfg).need_point) / 2
      else
        do
          do
            local sizeDelta = ((self.ui).tr_ProgressSlider).sizeDelta
            sizeDelta.x = sizeDelta.x * 0.7
            -- DECOMPILER ERROR at PC44: Confused about usage of register: R6 in 'UnsetPending'

            ;
            (((self.ui).tr_ProgressSlider).transform).sizeDelta = sizeDelta
            self._endPoint = (self._awardCfg).need_point
            self._isFinal = true
            -- DECOMPILER ERROR at PC55: Confused about usage of register: R5 in 'UnsetPending'

            ;
            ((self.ui).tex_Progress).text = tostring((self._awardCfg).need_point)
            self:RefreshADCRewardItem()
          end
        end
      end
    end
  end
end

UINADCRewardItem.RefreshADCRewardItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local curPoint = (self._adcData):GetADCTotalPoint()
  local sliderVal = 0
  if not self._isFinal then
    if curPoint < (self._awardCfg).need_point then
      sliderVal = (curPoint - self._startPoint) / ((self._awardCfg).need_point - self._startPoint) / 2
    else
      sliderVal = 0.5 + (curPoint - (self._awardCfg).need_point) / (self._endPoint - (self._awardCfg).need_point) / 2
    end
  else
    if self._endPoint <= curPoint then
      sliderVal = 1
    else
      if curPoint <= self._startPoint then
        sliderVal = 0
      else
        local rate = (curPoint - self._startPoint) / (self._endPoint - self._startPoint)
        sliderVal = rate * 0.71428571428571
      end
    end
  end
  do
    sliderVal = (math.clamp)(sliderVal, 0, 1)
    -- DECOMPILER ERROR at PC57: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_SliderHandle).fillAmount = sliderVal
    local unlock = (self._awardCfg).need_point <= (self._adcData):GetADCTotalPoint()
    local canReward = (self._adcData):IsCanADCFixedReward((self._awardCfg).need_point)
    if not unlock then
      ((self.ui).img_icon):SetIndex(1)
      local color = (((self.ui).img_icon).image).color
      color.a = 1
      -- DECOMPILER ERROR at PC87: Confused about usage of register: R6 in 'UnsetPending'

      ;
      (((self.ui).img_icon).image).color = color
      ;
      ((self.ui).img_Received):SetActive(false)
      ;
      ((self.ui).img_Available):SetActive(false)
    elseif canReward then
      ((self.ui).img_icon):SetIndex(0)
      local color = (((self.ui).img_icon).image).color
      color.a = 1
      -- DECOMPILER ERROR at PC114: Confused about usage of register: R6 in 'UnsetPending'

      ;
      (((self.ui).img_icon).image).color = color
      ;
      ((self.ui).img_Received):SetActive(false)
      ;
      ((self.ui).img_Available):SetActive(true)
    else
      ((self.ui).img_icon):SetIndex(1)
      local color = (((self.ui).img_icon).image).color
      color.a = 0.6
      -- DECOMPILER ERROR at PC139: Confused about usage of register: R6 in 'UnsetPending'

      ;
      (((self.ui).img_icon).image).color = color
      ;
      ((self.ui).img_Received):SetActive(true)
      ;
      ((self.ui).img_Available):SetActive(false)
    end
    -- DECOMPILER ERROR: 4 unprocessed JMP targets
  end
end

UINADCRewardItem.OnClickAwardItem = function(self)
  -- function num : 0_3
  if self._callback ~= nil then
    (self._callback)(self._awardCfg, self)
  end
end

return UINADCRewardItem

