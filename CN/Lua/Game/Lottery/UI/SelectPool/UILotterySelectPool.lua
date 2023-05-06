-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UILotterySelectPool = class("UILotterySelectPool", base)
local UINLtrSelectPoolItem = require("Game.Lottery.UI.SelectPool.UINLtrSelectPoolItem")
local cs_MessageCommon = CS.MessageCommon
UILotterySelectPool.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINLtrSelectPoolItem
  (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self._OnClickConfirm)
  self._optionPool = (UIItemPool.New)(UINLtrSelectPoolItem, (self.ui).option, false)
  self._OnSelectOptionFunc = BindCallback(self, self._OnSelectOption)
end

UILotterySelectPool.InitLtrSelectPool = function(self, ltrGroupData, defaultSelectLtrId, confirmFunc)
  -- function num : 0_1
  self.confirmFunc = confirmFunc
  self.ltrDataList = ltrGroupData:GetLtrInGroupDataList()
  for i = 1, 2 do
    local ltrData = (self.ltrDataList)[i]
    local optionItem = (self._optionPool):GetOne()
    optionItem:InitLtrSelectPoolItem(ltrData, self._OnSelectOptionFunc)
    if ltrData.poolId == defaultSelectLtrId then
      self:_OnSelectOption(optionItem, ltrData)
    else
      optionItem:UpdLtrPoolItemSelect(false)
    end
  end
  if defaultSelectLtrId == 0 then
    ((self.ui).img_Locked):SetActive(true)
    ;
    (((self.ui).obj_Select).gameObject):SetActive(false)
  end
end

UILotterySelectPool._OnSelectOption = function(self, optionItem, ltrData)
  -- function num : 0_2 , upvalues : _ENV
  if self._lastSelectOptionItem == optionItem then
    return 
  end
  self._curSelectLtrData = ltrData
  if self._lastSelectOptionItem ~= nil then
    (self._lastSelectOptionItem):UpdLtrPoolItemSelect(false)
  end
  optionItem:UpdLtrPoolItemSelect(true)
  self._lastSelectOptionItem = optionItem
  ;
  ((self.ui).img_Locked):SetActive(false)
  ;
  (((self.ui).obj_Select).gameObject):SetActive(true)
  ;
  ((self.ui).obj_Select):SetParent(optionItem.transform)
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).obj_Select).anchoredPosition = Vector2.zero
end

UILotterySelectPool.BackAction = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self._curSelectLtrData == nil then
    self._curSelectLtrData = (self.ltrDataList)[1]
  end
  if self.confirmFunc ~= nil then
    (self.confirmFunc)(self._curSelectLtrData)
  end
  ;
  (UIUtil.ReShowTopStatus)()
  self:Delete()
end

UILotterySelectPool._OnClickConfirm = function(self)
  -- function num : 0_4 , upvalues : cs_MessageCommon, _ENV
  if self._curSelectLtrData == nil then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(318))
    return 
  end
  ;
  (UIUtil.OnClickBackByUiTab)(self)
end

UILotterySelectPool.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (self._optionPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UILotterySelectPool

