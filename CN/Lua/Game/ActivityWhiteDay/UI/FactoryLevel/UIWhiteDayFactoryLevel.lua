-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWhiteDayFactoryLevel = class("UIWhiteDayFactoryLevel", UIBaseWindow)
local base = UIBaseWindow
local UINWhiteDayFactoryLevelItem = require("Game.ActivityWhiteDay.UI.FactoryLevel.UINWhiteDayFactoryLevelItem")
UIWhiteDayFactoryLevel.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWhiteDayFactoryLevelItem
  self.levelItemPool = (UIItemPool.New)(UINWhiteDayFactoryLevelItem, (self.ui).obj_rowItem)
  ;
  ((self.ui).obj_rowItem):SetActive(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, nil, UIUtil.OnClickBack)
  self.__genWDFLLevelItems = BindCallback(self, self.GenWDFLLevelItems)
  MsgCenter:AddListener(eMsgEventId.WhiteDayPhotoChange, self.__genWDFLLevelItems)
  MsgCenter:AddListener(eMsgEventId.WhiteDayOrderChange, self.__genWDFLLevelItems)
end

UIWhiteDayFactoryLevel.InitWDFactoryLevel = function(self, AWDData)
  -- function num : 0_1
  self.AWDData = AWDData
  self:GenWDFLLevelItems()
end

UIWhiteDayFactoryLevel.GenWDFLLevelItems = function(self)
  -- function num : 0_2 , upvalues : _ENV
  (self.levelItemPool):HideAll()
  local curLevel = (self.AWDData):GetAWDFactoryLevel()
  local factoryCfg = (self.AWDData):GetAWDFactoryCfg()
  local curExp = ((self.AWDData):GetAWDFactoryExp())
  local preLevelCfg = nil
  for level,levelCfg in ipairs(factoryCfg) do
    local levelItem = (self.levelItemPool):GetOne()
    levelItem:InitWDFactoryLevelItem(self.AWDData, preLevelCfg, levelCfg, curLevel, curExp)
    preLevelCfg = levelCfg
  end
end

UIWhiteDayFactoryLevel.__OnClickClose = function(self)
  -- function num : 0_3
  self:Hide()
end

UIWhiteDayFactoryLevel.OnShow = function(self)
  -- function num : 0_4 , upvalues : _ENV, base
  (UIUtil.SetTopStatus)(self, self.__OnClickClose, nil, nil, nil, true)
  ;
  (base.OnShow)(self)
end

UIWhiteDayFactoryLevel.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base, _ENV
  (base.OnDelete)(self)
  MsgCenter:RemoveListener(eMsgEventId.WhiteDayPhotoChange, self.__genWDFLLevelItems)
  MsgCenter:RemoveListener(eMsgEventId.WhiteDayOrderChange, self.__genWDFLLevelItems)
end

return UIWhiteDayFactoryLevel

