-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWin21SectorBar = class("UIWin21SectorBar", UIBaseWindow)
local base = UIBaseWindow
local JumpManager = require("Game.Jump.JumpManager")
local TaskEnum = require("Game.Task.TaskEnum")
local ActivitySectorIIEnum = require("Game.ActivitySectorII.ActivitySectorIIEnum")
UIWin21SectorBar.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.AddButtonListener)((self.ui).btn_Task, self, self.OnClickWAMapTask)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Shop, self, self.OnClickWinterShop)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Tree, self, self.__OnClickOpenTech)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ReprintShop, self, self.__OnClickJumpShop)
  self.__refreshShopTokenCount = BindCallback(self, self.__RefreshShopTokenCount)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__refreshShopTokenCount)
  self.resloader = ((CS.ResLoader).Create)()
end

UIWin21SectorBar.InitSectorBar = function(self, actId)
  -- function num : 0_1 , upvalues : _ENV
  self.actId = actId
  local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
  self.sectorIIData = sectorIICtrl:GetSectorIIDataByActId(self.actId)
  self.shopCurrencyId = (self.sectorIIData):GetSectorIITokenId()
  self.actFrameId = (self.sectorIIData):GetSectorIIActFrameId()
  self.reprintShopId = (self.sectorIIData):GetSectorIIReprintShopId()
  self.reprintShopIcon = (self.sectorIIData):GetSectorIIReprintShopIcon()
  self:__RefreshShopTokenIcon()
  self:__RefreshShopTokenCount()
  self:__RefreshReprintShopTokenIcon()
  self:__RefreshReprintShopTokenName()
  self:__InitSectorIITaskReddot()
  self:__InitSectorIIShopReddot()
  self:__InitSectorIITechReddot()
  local isFinished = not (self.sectorIIData):IsActivityRunning()
  self:SetIsTreeFinishedUI(isFinished)
end

UIWin21SectorBar.SetIsTreeFinishedUI = function(self, active)
  -- function num : 0_2
  ((self.ui).obj_TreeIsOver):SetActive(active)
end

UIWin21SectorBar.OnClickWAMapTask = function(self)
  -- function num : 0_3 , upvalues : JumpManager, TaskEnum
  JumpManager:Jump((JumpManager.eJumpTarget).DynTask, nil, nil, {(TaskEnum.eTaskType).LargeActivityTask}, true)
end

UIWin21SectorBar.OnClickWinterShop = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self.sectorIIData == nil then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.Win21Shop, function(window)
    -- function num : 0_4_0 , upvalues : self
    window:InitActivityWinterShop(self.sectorIIData)
  end
)
end

UIWin21SectorBar.__RefreshShopTokenIcon = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[self.shopCurrencyId]
  if itemCfg == nil then
    error("Cant get itemCfg, id = " .. tostring(self.shopCurrencyId))
    return 
  end
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_TokenIcon).sprite = CRH:GetSprite(itemCfg.small_icon)
end

UIWin21SectorBar.__RefreshShopTokenCount = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local itemCount = PlayerDataCenter:GetItemCount(self.shopCurrencyId)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_TokenCount).text = tostring(itemCount)
end

UIWin21SectorBar.__OnClickJumpShop = function(self)
  -- function num : 0_7 , upvalues : JumpManager
  if self.reprintShopId ~= 0 then
    JumpManager:Jump((JumpManager.eJumpTarget).DynShop, nil, nil, {self.reprintShopId})
  end
end

UIWin21SectorBar.__RefreshReprintShopTokenIcon = function(self)
  -- function num : 0_8 , upvalues : _ENV
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

  if not (string.IsNullOrEmpty)(self.reprintShopIcon) then
    ((self.ui).img_ReprintShopIcon).sprite = (AtlasUtil.GetSpriteFromAtlas)("UI_Shop", self.reprintShopIcon, self.resloader)
  end
end

UIWin21SectorBar.__RefreshReprintShopTokenName = function(self)
  -- function num : 0_9 , upvalues : _ENV
  local shopCfg = (ConfigData.shop)[self.reprintShopId]
  if shopCfg then
    (((self.ui).btn_ReprintShop).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_ReprintShopName).text = (LanguageUtil.GetLocaleText)(shopCfg.name)
  else
    ;
    (((self.ui).btn_ReprintShop).gameObject):SetActive(false)
  end
end

UIWin21SectorBar.__InitSectorIIShopReddot = function(self)
  -- function num : 0_10 , upvalues : _ENV, ActivitySectorIIEnum
  local isOk, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, self.actFrameId, (ActivitySectorIIEnum.eActSectorIIRedDotTypeId).recommendShop)
  if isOk then
    if self.__refresnShopReddot == nil then
      self.__refresnShopReddot = function(node)
    -- function num : 0_10_0 , upvalues : self
    ((self.ui).blueDot_shop):SetActive(node:GetRedDotCount() > 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end

    end
    RedDotController:AddListener(node.nodePath, self.__refresnShopReddot)
    ;
    (self.__refresnShopReddot)(node)
  end
end

UIWin21SectorBar.__RemoveSectorIIShopReddot = function(self)
  -- function num : 0_11 , upvalues : _ENV, ActivitySectorIIEnum
  local isOk, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, self.actFrameId, (ActivitySectorIIEnum.eActSectorIIRedDotTypeId).recommendShop)
  if isOk then
    RedDotController:RemoveListener(node.nodePath, self.__refresnShopReddot)
  end
  self.__refresnShopReddot = nil
end

UIWin21SectorBar.__InitSectorIITaskReddot = function(self)
  -- function num : 0_12 , upvalues : _ENV, ActivitySectorIIEnum
  local isOk, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, self.actFrameId, (ActivitySectorIIEnum.eActSectorIIRedDotTypeId).sectorIITask)
  if isOk then
    if self.__refresnTaskReddot == nil then
      self.__refresnTaskReddot = function(node)
    -- function num : 0_12_0 , upvalues : self
    ((self.ui).redDot_task):SetActive(node:GetRedDotCount() > 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end

    end
    RedDotController:AddListener(node.nodePath, self.__refresnTaskReddot)
    ;
    (self.__refresnTaskReddot)(node)
  end
end

UIWin21SectorBar.__RemoveSectorIITaskReddot = function(self)
  -- function num : 0_13 , upvalues : _ENV, ActivitySectorIIEnum
  local isOk, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, self.actFrameId, (ActivitySectorIIEnum.eActSectorIIRedDotTypeId).sectorIITask)
  if isOk then
    RedDotController:RemoveListener(node.nodePath, self.__refresnTaskReddot)
  end
  self.__refresnTaskReddot = nil
end

UIWin21SectorBar.__OnClickOpenTech = function(self)
  -- function num : 0_14 , upvalues : _ENV
  local isFinished = not (self.sectorIIData):IsActivityRunning()
  if isFinished then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.ActivityWinterTech, function(win)
    -- function num : 0_14_0 , upvalues : self
    if win ~= nil then
      win:InitWATech(self.actId)
    end
  end
)
end

UIWin21SectorBar.__InitSectorIITechReddot = function(self)
  -- function num : 0_15 , upvalues : _ENV, ActivitySectorIIEnum
  local isOk, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, self.actFrameId, (ActivitySectorIIEnum.eActSectorIIRedDotTypeId).techRoot)
  if isOk then
    if self.__refresnTechReddot == nil then
      self.__refresnTechReddot = function(node)
    -- function num : 0_15_0 , upvalues : self
    ((self.ui).blueDot_tree):SetActive(node:GetRedDotCount() > 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end

    end
    RedDotController:AddListener(node.nodePath, self.__refresnTechReddot)
    ;
    (self.__refresnTechReddot)(node)
  end
end

UIWin21SectorBar.__RemoveSectorIITechReddot = function(self)
  -- function num : 0_16 , upvalues : _ENV, ActivitySectorIIEnum
  local isOk, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, self.actFrameId, (ActivitySectorIIEnum.eActSectorIIRedDotTypeId).techRoot)
  if isOk then
    RedDotController:RemoveListener(node.nodePath, self.__refresnTechReddot)
  end
  self.__refresnTechReddot = nil
end

UIWin21SectorBar.OnDelete = function(self)
  -- function num : 0_17 , upvalues : _ENV, base
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__refreshShopTokenCount)
  self:__RemoveSectorIITaskReddot()
  self:__RemoveSectorIIShopReddot()
  self:__RemoveSectorIITechReddot()
  ;
  (base.OnDelete)(self)
end

return UIWin21SectorBar

