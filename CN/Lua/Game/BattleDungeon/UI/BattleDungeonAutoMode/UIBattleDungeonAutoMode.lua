-- params : ...
-- function num : 0 , upvalues : _ENV
local UIBattleDungeonAutoMode = class("UIBattleDungeonAutoMode", UIBaseWindow)
local base = UIBaseWindow
local UINBattleDungeonAutoResult = require("Game.BattleDungeon.UI.BattleDungeonAutoMode.UINBattleDungeonAutoResult")
local UINBattleDungeonAutoStart = require("Game.BattleDungeon.UI.BattleDungeonAutoMode.UINBattleDungeonAutoStart")
local UINBattleDungeonPlotAutoStart = require("Game.BattleDungeon.UI.BattleDungeonAutoMode.UINBattleDungeonPlotAutoStart")
local UINBattleDungeonLevelAutoStart = require("Game.BattleDungeon.UI.BattleDungeonAutoMode.UINBattleDungeonLevelAutoStart")
local eNodeType = {normalSet = 1, plotSet = 2, dunLevelSet = 3, reward = 4}
UIBattleDungeonAutoMode.OnInit = function(self)
  -- function num : 0_0 , upvalues : eNodeType, UINBattleDungeonAutoStart, UINBattleDungeonPlotAutoStart, UINBattleDungeonLevelAutoStart, UINBattleDungeonAutoResult, _ENV
  self.__nodeCfg = {
[eNodeType.normalSet] = {class = UINBattleDungeonAutoStart, obj = (self.ui).autoBattle}
, 
[eNodeType.plotSet] = {class = UINBattleDungeonPlotAutoStart, obj = (self.ui).autoChip}
, 
[eNodeType.dunLevelSet] = {class = UINBattleDungeonLevelAutoStart, obj = (self.ui).autoBattle}
, 
[eNodeType.reward] = {class = UINBattleDungeonAutoResult, obj = (self.ui).autoResult}
}
  self.nodeDic = {}
  for _,cfg in pairs(self.__nodeCfg) do
    (cfg.obj):SetActive(false)
  end
  self.__OnClickClose = BindCallback(self, self.OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickClose)
  self.__OnBattleStart = BindCallback(self, self.OnBattleStart)
  ;
  (UIUtil.SetTopStatus)(self, self.OnCloseAutoMode, nil, nil, nil, true)
end

UIBattleDungeonAutoMode.__PreCloseItem = function(self)
  -- function num : 0_1 , upvalues : _ENV
  for _,node in pairs(self.nodeDic) do
    node:Hide()
  end
end

UIBattleDungeonAutoMode.InitDungeonAutoSet = function(self, dungeonStageData, callback)
  -- function num : 0_2 , upvalues : eNodeType
  self:__PreCloseItem()
  ;
  ((self.ui).tex_Title):SetIndex(0)
  self.closeCallback = nil
  self.startcallback = callback
  if (dungeonStageData.dungeonData):IsFrageDungeon() then
    local plotSetNode = self:__GetNode(eNodeType.plotSet)
    plotSetNode:Show()
    plotSetNode:InitPlotAutoStart(dungeonStageData, self.__OnBattleStart)
  else
    do
      local autoSetNode = self:__GetNode(eNodeType.normalSet)
      autoSetNode:Show()
      autoSetNode:InitAutoStart(dungeonStageData, self.__OnBattleStart)
    end
  end
end

UIBattleDungeonAutoMode.InitDungeonAutoRes = function(self, dInterfaceData, count, rewardDic, ath, callback)
  -- function num : 0_3 , upvalues : eNodeType
  self:__PreCloseItem()
  ;
  ((self.ui).tex_Title):SetIndex(1)
  local resultNode = self:__GetNode(eNodeType.reward)
  resultNode:Show()
  if dInterfaceData ~= nil then
    resultNode:InitAutoResultTitle(dInterfaceData:GetIDungeonLevelData(), dInterfaceData:GetIDungeonStageData())
  else
    resultNode:InitAutoResultTitle(nil, nil)
  end
  resultNode:InitAutoResult(count, rewardDic, ath, self.__OnClickClose)
  self.startcallback = nil
  self.closeCallback = callback
end

UIBattleDungeonAutoMode.InitSectorIIDunAutoSet = function(self, dungeonLevelData, startcallback)
  -- function num : 0_4 , upvalues : eNodeType
  self:__PreCloseItem()
  ;
  ((self.ui).tex_Title):SetIndex(0)
  local dunLevelNode = self:__GetNode(eNodeType.dunLevelSet)
  dunLevelNode:InitDunLevelAutoStart(dungeonLevelData, self.__OnBattleStart)
  dunLevelNode:Show()
  self.closeCallback = nil
  self.startcallback = startcallback
end

UIBattleDungeonAutoMode.InitSectorIIDunAutoRes = function(self)
  -- function num : 0_5
end

UIBattleDungeonAutoMode.OnClickClose = function(self)
  -- function num : 0_6 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UIBattleDungeonAutoMode.OnBattleStart = function(self, count)
  -- function num : 0_7 , upvalues : _ENV
  (UIUtil.OnClickBack)()
  if self.startcallback ~= nil then
    (self.startcallback)(count)
  end
end

UIBattleDungeonAutoMode.__GetNode = function(self, type)
  -- function num : 0_8
  if (self.nodeDic)[type] ~= nil then
    return (self.nodeDic)[type]
  end
  local cfg = (self.__nodeCfg)[type]
  local node = ((cfg.class).New)()
  node:Init(cfg.obj)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.nodeDic)[type] = node
  return node
end

UIBattleDungeonAutoMode.OnCloseAutoMode = function(self)
  -- function num : 0_9
  self:Delete()
  if self.closeCallback then
    (self.closeCallback)()
  end
end

UIBattleDungeonAutoMode.OnDelete = function(self)
  -- function num : 0_10 , upvalues : _ENV, base
  for _,node in pairs(self.nodeDic) do
    node:Delete()
  end
  ;
  (base.OnDelete)(self)
end

return UIBattleDungeonAutoMode

