-- params : ...
-- function num : 0 , upvalues : _ENV
local UICommonGiftSelect = class("UICommonGiftSelect", UIBaseWindow)
local base = UIBaseWindow
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UICommonGiftSelect.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.SetTopStatus)(self, self.__OnClickBack, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_buttonYes, self, self.__OnClickYesBtn)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_buttonNo, self, self.__OnClickNoBtn)
  self.__onClickItem = BindCallback(self, self.__OnClickItem)
  self.itemPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).uINBaseItemWithCount)
  ;
  ((self.ui).uINBaseItemWithCount):SetActive(false)
  ;
  ((self.ui).obj_img_Select):SetActive(false)
end

UICommonGiftSelect.InitCommonGiftSelect = function(self, itemList, numList, yesCallback, noCallback)
  -- function num : 0_1
  self.__selectedOneIndex = nil
  self.__itemList = itemList
  self.__numList = numList
  self.__yesCallback = yesCallback
  self.__noCallback = noCallback
  self.__onClickCallback = nil
  self:__RefreshItemList()
end

UICommonGiftSelect.SetTitleAndSubTitle = function(self, mainTitle, subTitle)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  if mainTitle ~= nil then
    ((self.ui).tex_title).text = ConfigData:GetTipContent(mainTitle)
  end
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R3 in 'UnsetPending'

  if subTitle ~= nil then
    ((self.ui).tex_subTitle).text = ConfigData:GetTipContent(subTitle)
  end
end

UICommonGiftSelect.SetOnItemClick = function(self, onClickCallback)
  -- function num : 0_3
  self.__onClickCallback = onClickCallback
end

UICommonGiftSelect.__RefreshItemList = function(self)
  -- function num : 0_4 , upvalues : _ENV
  (self.itemPool):HideAll()
  for index,itemId in ipairs(self.__itemList) do
    local num = (self.__numList)[index]
    local item = (self.itemPool):GetOne()
    local itemCfg = (ConfigData.item)[itemId]
    item:InitItemWithCount(itemCfg, num, self.__onClickItem, nil, nil, nil)
    item:BindClickCustomArg({index = index, item = item})
  end
end

UICommonGiftSelect.__OnClickItem = function(self, itemCfg, clickArg)
  -- function num : 0_5 , upvalues : _ENV
  self.__selectedOneIndex = clickArg.index
  local item = clickArg.item
  if item ~= nil then
    (((self.ui).obj_img_Select).transform):SetParent(item.transform)
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (((self.ui).obj_img_Select).transform).localPosition = Vector3.zero
    ;
    ((self.ui).obj_img_Select):SetActive(true)
  end
  if self.__onClickCallback ~= nil then
    (self.__onClickCallback)(itemCfg, clickArg)
  end
end

UICommonGiftSelect.__OnClickYesBtn = function(self)
  -- function num : 0_6
  if self.__selectedOneIndex == nil then
    return 
  end
  if self.__yesCallback ~= nil then
    (self.__yesCallback)(self.__selectedOneIndex)
  end
end

UICommonGiftSelect.__OnClickNoBtn = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self.__noCallback ~= nil then
    (self.__noCallback)()
  end
  ;
  (UIUtil.OnClickBack)()
end

UICommonGiftSelect.__OnClickBack = function(self)
  -- function num : 0_8
  self:Delete()
end

return UICommonGiftSelect

