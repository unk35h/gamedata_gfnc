-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINShareCommonBtn = class("UINShareCommonBtn", base)
UINShareCommonBtn.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Root, self, self._OnClickRoot)
end

UINShareCommonBtn.InitShareCommonBtn = function(self, shareFunc, shareId)
  -- function num : 0_1 , upvalues : _ENV
  self._shareFunc = shareFunc
  TimerManager:StopTimer(self._hideTipsTimer)
  ;
  ((self.ui).shareTip):SetActive(false)
  if shareId == nil or not (ControllerManager:GetController(ControllerTypeId.Share, true)):CanGetShareReward(shareId) then
    return 
  end
  local shareCfg = (ConfigData.share)[shareId]
  if shareCfg == nil then
    error("Cant get shareCfg, id:" .. tostring(shareId))
    return 
  end
  for itemId,itemNum in pairs(shareCfg.reward) do
    local itemCfg = (ConfigData.item)[itemId]
    -- DECOMPILER ERROR at PC50: Confused about usage of register: R10 in 'UnsetPending'

    ;
    ((self.ui).img_ItemIcon).sprite = CRH:GetSprite(itemCfg.icon)
    -- DECOMPILER ERROR at PC56: Confused about usage of register: R10 in 'UnsetPending'

    ;
    ((self.ui).tex_ItemNum).text = tostring(itemNum)
    ;
    ((self.ui).shareTip):SetActive(true)
    self._hideTipsTimer = TimerManager:StartTimer((self.ui).hideTipsTime, function()
    -- function num : 0_1_0 , upvalues : _ENV, self
    if IsNull(self.transform) then
      return 
    end
    ;
    ((self.ui).shareTip):SetActive(false)
  end
)
    do break end
  end
end

UINShareCommonBtn._OnClickRoot = function(self)
  -- function num : 0_2
  if self._shareFunc ~= nil then
    (self._shareFunc)()
  end
end

UINShareCommonBtn.OnDelete = function(self)
  -- function num : 0_3 , upvalues : _ENV, base
  TimerManager:StopTimer(self._hideTipsTimer)
  ;
  (base.OnDelete)(self)
end

return UINShareCommonBtn

