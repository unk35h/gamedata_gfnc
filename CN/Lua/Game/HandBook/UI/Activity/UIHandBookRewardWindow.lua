-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHandBookRewardWindow = class("UIHandBookRewardWindow", UIBaseWindow)
local base = UIBaseWindow
local UINHandBookRewardItem = require("Game.HandBook.UI.Activity.UINHandBookRewardItem")
local cs_Tweening = (CS.DG).Tweening
UIHandBookRewardWindow.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHandBookRewardItem
  (((UIUtil.CreateNewTopStatusData)(self)):SetTopStatusBackAction(self.Delete)):PushTopStatusDataToBackStack()
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickBack)
  self._rewardPool = (UIItemPool.New)(UINHandBookRewardItem, (self.ui).item)
  ;
  ((self.ui).item):SetActive(false)
end

UIHandBookRewardWindow.InitHandBookRewardWindow = function(self, name, rewardIdList)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).tex_ActName).text = name
  local totalCount = 0
  local hasCount = 0
  ;
  (self._rewardPool):HideAll()
  for _,itemId in ipairs(rewardIdList) do
    totalCount = totalCount + 1
    local itemCfg = (ConfigData.item)[itemId]
    local noGet = true
    if itemCfg.type == eItemType.DormFurniture and (PlayerDataCenter.dormBriefData):ExistDormFntItem(itemId) then
      noGet = false
    end
    -- DECOMPILER ERROR at PC43: Unhandled construct in 'MakeBoolean' P1

    if itemCfg.type == eItemType.HeroCard and (PlayerDataCenter.heroDic)[(itemCfg.arg)[1]] ~= nil then
      noGet = false
    end
    if itemCfg.type == eItemType.Skin and (PlayerDataCenter.skinData):IsHaveSkin((itemCfg.arg)[1]) then
      noGet = false
    end
    if PlayerDataCenter:GetItemCount(itemId) > 0 then
      noGet = false
    end
    local item = (self._rewardPool):GetOne()
    item:InitHandbookReward(itemId)
    item:SetHandbookRewardState(noGet)
    if not noGet then
      hasCount = hasCount + 1
    end
  end
  ;
  ((self.ui).tex_Progress):SetIndex(0, tostring(hasCount), tostring(totalCount))
end

UIHandBookRewardWindow.PlayBookRewardAni = function(self, worldPos)
  -- function num : 0_2 , upvalues : cs_Tweening, _ENV
  ((self.ui).main):DOComplete()
  ;
  ((((self.ui).main):DOMove(worldPos, 0.2)):From()):SetEase((cs_Tweening.Ease).OutQuad)
  ;
  ((((self.ui).main):DOScale(0.2, 0.2)):From()):SetEase((cs_Tweening.Ease).OutQuad)
  for i,v in ipairs((self._rewardPool).listItem) do
    v:PlayBookRewarsItemAni(0.1 + (i - 1) * 0.033)
  end
end

UIHandBookRewardWindow.OnClickBack = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIHandBookRewardWindow.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  ((self.ui).main):DOComplete()
  ;
  (self._rewardPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UIHandBookRewardWindow

