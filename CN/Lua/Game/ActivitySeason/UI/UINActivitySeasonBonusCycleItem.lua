-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActivitySeasonBonusCycleItem = class("UINActivitySeasonBonusCycleItem", UIBaseNode)
local base = UIBaseNode
UINActivitySeasonBonusCycleItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_bg, self, self.OnClickConfirm)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_icon, self, self.OnClickRewardShow)
end

UINActivitySeasonBonusCycleItem.InitBounsCycleItem = function(self, activitySeasonData, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._data = activitySeasonData
  self._callback = callback
  self._cycleExpLimit = (self._data):GetSeasonRewardCycleExpLimit()
  local mainCfg = (self._data):GetSeasonMainCfg()
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)(mainCfg.cir_des)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).sprite = CRH:GetSpriteByItemId((mainCfg.cirRewardIds)[1])
  self:RefreshBounsCycleItem()
end

UINActivitySeasonBonusCycleItem.RefreshBounsCycleItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local curLevel = (self._data):GetSeasonRewardCurLv()
  local maxLevel = (self._data):GetSeasonRewardLvLimit()
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  if curLevel < maxLevel then
    ((self.ui).canvasGroup).alpha = 0.9
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Num).text = "0"
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_ExpProgress).fillAmount = 0
    ;
    ((self.ui).tex_ExpProgress):SetIndex(0, "0", tostring(self._cycleExpLimit))
    return 
  end
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).canvasGroup).alpha = 1
  local exp = (self._data):GetSeasonRewardCurExp()
  local count = exp // self._cycleExpLimit
  local curExp = exp % self._cycleExpLimit
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Num).text = tostring(count)
  -- DECOMPILER ERROR at PC47: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).img_ExpProgress).fillAmount = curExp / self._cycleExpLimit
  ;
  ((self.ui).tex_ExpProgress):SetIndex(0, tostring(curExp), tostring(self._cycleExpLimit))
end

UINActivitySeasonBonusCycleItem.OnClickConfirm = function(self)
  -- function num : 0_3
  if self._callback ~= nil then
    (self._callback)()
  end
end

UINActivitySeasonBonusCycleItem.OnClickRewardShow = function(self)
  -- function num : 0_4 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.EventBattlePassRewardPreview, function(window)
    -- function num : 0_4_0 , upvalues : self
    if window == nil then
      return 
    end
    local mainCfg = (self._data):GetSeasonMainCfg()
    window:InitBPRewardPreview((mainCfg.cirRewardIds)[1], mainCfg.cirRewardPreviewIds, mainCfg.cirRewardPreviewNums)
  end
)
end

return UINActivitySeasonBonusCycleItem

