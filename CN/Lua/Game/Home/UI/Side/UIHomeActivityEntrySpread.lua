-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHomeActivityEntrySpread = class("UIHomeActivityEntrySpread", UIBaseWindow)
local base = UIBaseWindow
local UINSectorActivityEntry = require("Game.ActivityFrame.UI.UINSectorActivityEntry")
local ActEntryEnum = require("Game.Home.UI.Side.Enum.ActEntryEnum")
UIHomeActivityEntrySpread.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.entryItemDic = {}
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.__OnClickBackground)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scroll_advList).onInstantiateItem = BindCallback(self, self.__OnInstantiateEntryItem)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scroll_advList).onChangeItem = BindCallback(self, self.__OnChangeEntryItem)
end

UIHomeActivityEntrySpread.SetActEntrySpreadProperty = function(self, infoList, resload, clickFunc, enterWay, pageViewCtrl)
  -- function num : 0_1 , upvalues : _ENV
  (((UIUtil.CreateNewTopStatusData)(self)):SetTopStatusBackAction(self.BackAction)):PushTopStatusDataToBackStack(true)
  self.infoList = infoList
  self.resload = resload
  self.clickFunc = clickFunc
  self.enterWay = enterWay
  self.pageViewCtrl = pageViewCtrl
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R6 in 'UnsetPending'

  if not IsNull(self.pageViewCtrl) then
    (self.pageViewCtrl).autoDrag = false
  end
  self:UpdateEntryItemShow()
end

UIHomeActivityEntrySpread.UpdateEntryItemShow = function(self)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).scroll_advList).totalCount = #self.infoList
  ;
  ((self.ui).scroll_advList):RefillCells()
end

UIHomeActivityEntrySpread.BackAction = function(self)
  -- function num : 0_3
  self:Delete()
end

UIHomeActivityEntrySpread.__OnClickBackground = function(self)
  -- function num : 0_4 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIHomeActivityEntrySpread.__OnChangeEntryItem = function(self, go, index)
  -- function num : 0_5 , upvalues : _ENV
  local entryItem = (self.entryItemDic)[go]
  entryItem:RefreshSectorActivity(((self.infoList)[index + 1]).cfg, ((self.infoList)[index + 1]).activityFrameInfo, self.resload, self.clickFunc)
  ;
  (UIUtil.AddButtonListener)((entryItem.ui).btn_Activity, self, self.Delete)
end

UIHomeActivityEntrySpread.__OnInstantiateEntryItem = function(self, go)
  -- function num : 0_6 , upvalues : UINSectorActivityEntry
  local entryItem = (UINSectorActivityEntry.New)()
  entryItem:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.entryItemDic)[go] = entryItem
end

UIHomeActivityEntrySpread.OnDelete = function(self)
  -- function num : 0_7 , upvalues : _ENV, base
  if self.entryItemDic ~= nil then
    for i,v in pairs(self.entryItemDic) do
      v:Delete()
    end
    self.entryItemDic = nil
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R1 in 'UnsetPending'

  if not IsNull(self.pageViewCtrl) then
    (self.pageViewCtrl).autoDrag = true
  end
  ;
  (base.OnDelete)(self)
end

return UIHomeActivityEntrySpread

