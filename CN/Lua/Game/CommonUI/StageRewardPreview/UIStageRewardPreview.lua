-- params : ...
-- function num : 0 , upvalues : _ENV
local UIStageRewardPreview = class("UIStageRewardPreview", UIBaseWindow)
local base = UIBaseWindow
local UINStageRewardPreItem = require("Game.CommonUI.StageRewardPreview.UINStageRewardPreItem")
UIStageRewardPreview.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINStageRewardPreItem
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self._OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Bg, self, self._OnClickClose)
  self.rowItemPool = (UIItemPool.New)(UINStageRewardPreItem, (self.ui).rowItem, false)
  ;
  (UIUtil.SetTopStatus)(self, self.Delete, nil, nil, nil, true)
end

UIStageRewardPreview.InitUIStageRewardPreview = function(self, rewardListCfg, curStage)
  -- function num : 0_1 , upvalues : _ENV
  (((self.ui).obj_Current).gameObject):SetActive(false)
  local showCur = false
  ;
  (self.rowItemPool):HideAll()
  for k,v in ipairs(rewardListCfg) do
    local isPick = k <= curStage
    local rowItem = (self.rowItemPool):GetOne()
    rowItem:InitStageRewardPreItem(v, isPick)
    if curStage == k then
      showCur = true
      ;
      (((self.ui).obj_Current).gameObject):SetActive(true)
      local parent = rowItem:GetStageRewardPreItemCurHolder()
      ;
      ((self.ui).obj_Current):SetParent(parent)
      -- DECOMPILER ERROR at PC45: Confused about usage of register: R12 in 'UnsetPending'

      ;
      ((self.ui).obj_Current).anchoredPosition = Vector2.zero
    end
  end
  -- DECOMPILER ERROR at PC57: Confused about usage of register: R4 in 'UnsetPending'

  if showCur then
    ((self.ui).scrollRect).verticalNormalizedPosition = 1 - (curStage - 1) / (#rewardListCfg - 1)
  else
    -- DECOMPILER ERROR at PC61: Confused about usage of register: R4 in 'UnsetPending'

    ((self.ui).scrollRect).verticalNormalizedPosition = 1
  end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UIStageRewardPreview._OnClickClose = function(self)
  -- function num : 0_2 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIStageRewardPreview.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (self.rowItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UIStageRewardPreview

