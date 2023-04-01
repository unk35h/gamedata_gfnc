-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIWarChessEvent = class("UIWarChessEvent", base)
local cs_ResLoader = CS.ResLoader
local UINWarChessEventChoiceItem = require("Game.WarChess.UI.Event.UINWarChessEventChoiceItem")
local UINWarChessEventEventNode = require("Game.WarChess.UI.Event.UINWarChessEventEventNode")
local UINWarChessEventLongNode = require("Game.WarChess.UI.Event.UINWarChessEventLongNode")
local UINWarChessEventFirstChoiceExitNode = require("Game.WarChess.UI.Event.UINWarChessEventFirstChoiceExitNode")
local eEventShowType = {normal = 0, long = 2, firstSelectExit = 4}
UIWarChessEvent.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_ResLoader, eEventShowType, UINWarChessEventEventNode, UINWarChessEventLongNode, UINWarChessEventFirstChoiceExitNode, _ENV
  self.resloader = (cs_ResLoader.Create)()
  ;
  ((self.ui).obj_choiceItem):SetActive(false)
  self.__eventTypeNode = {
[eEventShowType.normal] = {go = (self.ui).obj_eventNode, class = UINWarChessEventEventNode}
, 
[eEventShowType.long] = {go = (self.ui).obj_longTextNode, class = UINWarChessEventLongNode}
, 
[eEventShowType.firstSelectExit] = {go = (self.ui).obj_eventNode, class = UINWarChessEventFirstChoiceExitNode}
}
  for _,nodeCfg in pairs(self.__eventTypeNode) do
    (nodeCfg.go):SetActive(false)
  end
  self.__onClickEventChoice = BindCallback(self, self.__OnClickEventChoice)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Map, self, self.OnClickShowMap)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Exit, self, self.__OnClickExit)
  ;
  ((self.ui).tex_MapBtnName):SetIndex(0)
  self.__refreshItemNum = BindCallback(self, self.__RefreshItemNum)
  MsgCenter:AddListener(eMsgEventId.WC_ItemNumChange, self.__refreshItemNum)
  MsgCenter:AddListener(eMsgEventId.WC_ItemLimitNumChange, self.__refreshItemNum)
end

UIWarChessEvent.InitWCEvent = function(self, eventCtrl)
  -- function num : 0_1 , upvalues : eEventShowType
  self.eventCtrl = eventCtrl
  local eventCfg = (self.eventCtrl):GetWCEventConfig()
  local nodeCfg = (self.__eventTypeNode)[eventCfg.event_tag]
  local choiceDatas = (self.eventCtrl):GetWCEventChoices()
  if nodeCfg ~= nil then
    self.__eventNode = ((nodeCfg.class).New)()
    ;
    (nodeCfg.go):SetActive(true)
    ;
    (self.__eventNode):Init(nodeCfg.go)
    ;
    (self.__eventNode):InitWCEventNode(self, eventCfg, choiceDatas, self.__onClickEventChoice)
    self:RefreshWCEventBG(eventCfg.pic)
  end
  if eventCfg.event_tag == eEventShowType.firstSelectExit then
    local firstChoiceData = choiceDatas[1]
    self.__firstChoiceData = firstChoiceData
    ;
    (((self.ui).btn_Exit).gameObject):SetActive(true)
    ;
    (((self.ui).btn_Map).gameObject):SetActive(false)
  else
    do
      ;
      (((self.ui).btn_Exit).gameObject):SetActive(false)
      ;
      (((self.ui).btn_Map).gameObject):SetActive(true)
      self:__RefreshItemNum()
    end
  end
end

UIWarChessEvent.__RefreshItemNum = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local eventCfg = (self.eventCtrl):GetWCEventConfig()
  local itemId = eventCfg.ref_item
  if itemId ~= 0 and WarChessSeasonManager:GetIsInWCSeason() then
    local wcCtrl = WarChessManager:GetWarChessCtrl()
    local capacity = (wcCtrl.backPackCtrl):GetWCItemCapacity(itemId)
    local curNum = (wcCtrl.backPackCtrl):GetWCItemNum(itemId)
    ;
    ((self.ui).obj_countNode):SetActive(true)
    -- DECOMPILER ERROR at PC39: Confused about usage of register: R6 in 'UnsetPending'

    if capacity > 0 then
      ((self.ui).tex_Count).text = tostring(curNum) .. "/" .. tostring(capacity)
    else
      -- DECOMPILER ERROR at PC46: Confused about usage of register: R6 in 'UnsetPending'

      ;
      ((self.ui).tex_Count).text = tostring(curNum)
    end
  else
    do
      ;
      ((self.ui).obj_countNode):SetActive(false)
    end
  end
end

UIWarChessEvent.GetWCChoicePool = function(self)
  -- function num : 0_3 , upvalues : _ENV, UINWarChessEventChoiceItem
  if self.choicePool == nil then
    self.choicePool = (UIItemPool.New)(UINWarChessEventChoiceItem, (self.ui).obj_choiceItem)
  end
  return self.choicePool
end

UIWarChessEvent.RefreshWCEventBG = function(self, picId)
  -- function num : 0_4 , upvalues : _ENV
  local cfg = (ConfigData.warchess_event_pic)[picId]
  if cfg == nil then
    error("warchess_event_pic is null,id:" .. tostring(picId))
    return 
  end
  local colCfg = cfg.color
  local color = (Color.New)(colCfg[1] / 255, colCfg[2] / 255, colCfg[3] / 255)
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_TypeColor).color = color
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_RoomIcon).color = color
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_RoomIcon).sprite = CRH:GetSprite(cfg.icon, CommonAtlasType.ExplorationIcon)
  ;
  (((self.ui).img_RoomIcon).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC50: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_RoomType).text = (LanguageUtil.GetLocaleText)(cfg.title)
end

UIWarChessEvent.OnClickShowMap = function(self)
  -- function num : 0_5
  local isOpen = ((self.ui).frameNode).activeInHierarchy
  ;
  ((self.ui).tex_MapBtnName):SetIndex(isOpen and 1 or 0)
  ;
  ((self.ui).frameNode):SetActive(not isOpen)
  ;
  ((self.ui).itemHolder):SetActive(not isOpen)
end

UIWarChessEvent.__OnClickExit = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if self.__firstChoiceData ~= nil then
    self:__OnClickEventChoice(self.__firstChoiceData)
  else
    warn("not have exit choice")
  end
end

UIWarChessEvent.__OnClickEventChoice = function(self, choiceData)
  -- function num : 0_7
  (self.eventCtrl):WCEventSelect(choiceData)
end

UIWarChessEvent.OnDelete = function(self)
  -- function num : 0_8 , upvalues : base, _ENV
  (base.OnDelete)(self)
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.WC_ItemNumChange, self.__refreshItemNum)
  MsgCenter:RemoveListener(eMsgEventId.WC_ItemLimitNumChange, self.__refreshItemNum)
end

return UIWarChessEvent

