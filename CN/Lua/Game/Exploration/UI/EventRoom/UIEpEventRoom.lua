-- params : ...
-- function num : 0 , upvalues : _ENV
local UIEpEventRoom = class("UIEpEventRoom", UIBaseWindow)
local base = UIBaseWindow
local Enum = require("Game.Exploration.EpEventRoomEnum")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local EventPage = require("Game.Exploration.UI.EventRoom.UINEpEventNode")
local LotteryPage = require("Game.Exploration.UI.EventRoom.UINEpEntLotteryNode")
local LongTextPage = require("Game.Exploration.UI.EventRoom.UINEpEntLongTexNode")
local UINEpEventPartFusion = require("Game.Exploration.UI.EventRoom.UINEpEventPartFusion")
local UIChoiceItem = require("Game.Exploration.UI.EventRoom.UIEpEventChoiceItem")
local GoodsItem = require("Game.Exploration.UI.EventRoom.UIEpChoiceGoodsItem")
UIEpEventRoom.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, Enum, EventPage, LotteryPage, LongTextPage, UINEpEventPartFusion
  (UIUtil.AddButtonListener)((self.ui).btn_Map, self, self.OnMapButtonClick)
  self.__OnChipDetailActiveChange = BindCallback(self, self.OnChipDetailActiveChange)
  MsgCenter:AddListener(eMsgEventId.OnDungeonDetailWinChange, self.__OnChipDetailActiveChange)
  self.__FromMapBackToUI = BindCallback(self, self.FromMapBackToUI)
  MsgCenter:AddListener(eMsgEventId.OnShowingMapRoomClick, self.__FromMapBackToUI)
  ;
  ((self.ui).obj_choiceItem):SetActive(false)
  ;
  ((self.ui).obj_goodsNode):SetActive(false)
  self.eventPageNode = {
[(Enum.eBranch).Event] = {go = (self.ui).obj_eventNode, class = EventPage}
, 
[(Enum.eBranch).Lottery] = {go = (self.ui).obj_lotteryNode, class = LotteryPage}
, 
[(Enum.eBranch).LongText] = {go = (self.ui).obj_longTextNode, class = LongTextPage}
, 
[(Enum.eBranch).PartFusion] = {go = (self.ui).obj_metalGearNode, class = UINEpEventPartFusion}
}
  self:ActiveUIMask(false)
end

UIEpEventRoom.InitEpEventRoom = function(self, eventData, choiceClickAction)
  -- function num : 0_1
  self.pageDic = {}
  self:UpdEpEventRoom(eventData, choiceClickAction)
  self:_RefreshWinUI()
end

UIEpEventRoom.UpdEpEventRoom = function(self, eventData, choiceClickAction)
  -- function num : 0_2
  self:_RefreshData(eventData)
  self:_RefreshPageNode(choiceClickAction)
end

UIEpEventRoom._RefreshData = function(self, eventData)
  -- function num : 0_3 , upvalues : _ENV
  local eventCfg = (ConfigData.event)[eventData.eventId]
  if eventCfg == nil then
    error("eRoomCfg null,id:" .. tostring(eventData.eventId))
    return 
  end
  self.eventCfg = eventCfg
  self.roomData = eventData
  self.onMapClick = false
end

UIEpEventRoom._RefreshPageNode = function(self, choiceClickAction)
  -- function num : 0_4 , upvalues : _ENV
  local branchId = (self.eventCfg).event_tag or 0
  if self.lastPage ~= nil then
    (self.lastPage):Hide()
  end
  local curPage = (self.pageDic)[branchId]
  if curPage ~= nil then
    curPage:RefreshBranchPage()
  else
    local ePageData = (self.eventPageNode)[branchId]
    if ePageData == nil then
      error("ePageData is nil ID:" .. tostring(branchId))
      return 
    end
    curPage = ((ePageData.class).New)()
    curPage:Init(ePageData.go)
    curPage:InitBranchPage(self, choiceClickAction)
    -- DECOMPILER ERROR at PC42: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (self.pageDic)[branchId] = curPage
  end
  do
    curPage:Show()
    self.lastPage = curPage
  end
end

UIEpEventRoom._RefreshWinUI = function(self)
  -- function num : 0_5 , upvalues : _ENV
  (((self.ui).btn_Map).gameObject):SetActive(ExplorationManager:HasRoomSceneInEp())
  self:_SwitchMapBtnState(self.onMapClick)
  self:_RefreshRoomTypeUI()
end

UIEpEventRoom._SwitchMapBtnState = function(self, isOpen)
  -- function num : 0_6
  ((self.ui).obj_Frame):SetActive(not isOpen)
  ;
  ((self.ui).tex_BtnName):SetIndex(not isOpen and 0 or 1)
end

UIEpEventRoom._RefreshRoomTypeUI = function(self)
  -- function num : 0_7 , upvalues : _ENV, ExplorationEnum
  local eRoomType = (self.roomData).eRoomType
  local cfg = (ConfigData.exploration_roomtype)[eRoomType]
  if cfg == nil then
    error("exploration room type is null,id:" .. tostring(eRoomType))
    return 
  end
  local colCfg = cfg.color
  local color = (Color.New)(colCfg[1], colCfg[2], colCfg[3])
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_TypeColor).color = color
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_RoomIcon).color = color
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_RoomIcon).sprite = CRH:GetSprite(cfg.icon, CommonAtlasType.ExplorationIcon)
  ;
  (((self.ui).img_RoomIcon).gameObject):SetActive(true)
  if eRoomType == (ExplorationEnum.eRoomType).recovery then
    ((self.ui).tex_RoomType):SetIndex(1)
  else
    if eRoomType == (ExplorationEnum.eRoomType).partfusion then
      ((self.ui).tex_RoomType):SetIndex(2)
      ;
      (((self.ui).img_RoomIcon).gameObject):SetActive(false)
    else
      ;
      ((self.ui).tex_RoomType):SetIndex(0)
    end
  end
end

UIEpEventRoom.GetEventChoiceItem = function(self, index)
  -- function num : 0_8
  if (self.lastPage).choiceItemDic == nil then
    return nil
  end
  return ((self.lastPage).choiceItemDic)[index]
end

UIEpEventRoom.ActiveUIMask = function(self, flag)
  -- function num : 0_9
  ((self.ui).obj_AniMask):SetActive(flag)
end

UIEpEventRoom.OnMapButtonClick = function(self)
  -- function num : 0_10
  if self.onMapClick == nil then
    self.onMapClick = false
  else
    self.onMapClick = not self.onMapClick
  end
  self:_SwitchMapBtnState(self.onMapClick)
end

UIEpEventRoom.FromMapBackToUI = function(self)
  -- function num : 0_11
  self.onMapClick = false
  self:_SwitchMapBtnState(self.onMapClick)
end

UIEpEventRoom.OnChipDetailActiveChange = function(self, bool)
  -- function num : 0_12
  if bool then
    self:Hide()
  else
    self:Show()
  end
end

UIEpEventRoom.GetAniItemPosAndScale = function(self)
  -- function num : 0_13
  local position = (self.transform):InverseTransformPoint((((self.ui).obj_ChipAniNode).transform).position)
  local scale = (((self.ui).obj_ChipAniNode).transform).scale
  return position, scale
end

UIEpEventRoom.CloseWindow = function(self)
  -- function num : 0_14
  self:Delete()
end

UIEpEventRoom.GetChoiceItemPool = function(self)
  -- function num : 0_15 , upvalues : _ENV, UIChoiceItem
  if self.choicePool == nil then
    self.choicePool = (UIItemPool.New)(UIChoiceItem, (self.ui).obj_choiceItem)
  end
  return self.choicePool
end

UIEpEventRoom.GetExtraItemPool = function(self)
  -- function num : 0_16 , upvalues : _ENV, GoodsItem
  if self.extraPool == nil then
    self.extraPool = (UIItemPool.New)(GoodsItem, (self.ui).obj_goodsNode)
  end
  return self.extraPool
end

UIEpEventRoom.OnDelete = function(self)
  -- function num : 0_17 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.OnDungeonDetailWinChange, self.__OnChipDetailActiveChange)
  MsgCenter:RemoveListener(eMsgEventId.OnShowingMapRoomClick, self.__FromMapBackToUI)
  for id,page in pairs(self.pageDic) do
    page:Delete()
  end
  if self.choicePool ~= nil then
    (self.choicePool):DeleteAll()
    self.choicePool = nil
  end
  if self.extraPool ~= nil then
    (self.extraPool):DeleteAll()
    self.extraPool = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIEpEventRoom

