-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDailyDungeonQuickBattle = class("UINDailyDungeonQuickBattle", UIBaseNode)
local base = UIBaseNode
local UINDailyDungeonQuickBattleItem = require("Game.DailyDungeon.UI.LevelSelect.UINDailyDungeonQuickBattleItem")
local cs_MovieManager = (CS.MovieManager).Instance
UINDailyDungeonQuickBattle.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, nil, UIUtil.OnClickBack)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Clear, nil, UIUtil.OnClickBack)
  ;
  (UIUtil.AddButtonListener)((self.ui).background, nil, UIUtil.OnClickBack)
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).list).onInstantiateItem = BindCallback(self, self.__OnInstantiateItem)
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).list).onChangeItem = BindCallback(self, self.__OnChangeItem)
  self._itemDic = {}
end

UINDailyDungeonQuickBattle.InitDailyQuickBattle = function(self, matDungeonCfg, startNum, dungeonElems)
  -- function num : 0_1 , upvalues : _ENV, cs_MovieManager
  (UIUtil.SetTopStatus)(self, self.QuickQuit, nil, nil, nil, true)
  self._scrollIndex = 0
  self._isInAutoShow = true
  self._stageList = {}
  self._startNum = startNum
  self._dungeonElems = dungeonElems
  local battleDyncElem = (PlayerDataCenter.dungeonDyncData):GetDailyDungeonDyncData()
  self._isDouble = battleDyncElem:DgDyncIsHaveMultReward()
  for i = startNum, #matDungeonCfg.stage_id do
    local stageId = (matDungeonCfg.stage_id)[i]
    local stageCfg = (ConfigData.battle_dungeon)[stageId]
    ;
    (table.insert)(self._stageList, stageCfg)
  end
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).list).totalCount = #self._dungeonElems
  ;
  ((self.ui).list):RefillCells()
  if self._moviePlayer == nil then
    self._moviePlayer = cs_MovieManager:GetMoviePlayer()
  end
  local avgPath = PathConsts:GetAvgVideoPath("dailyDungeonQuickBattle")
  ;
  (self._moviePlayer):SetVideoRender((self.ui).videoHodler)
  ;
  (self._moviePlayer):PlayVideo(avgPath)
  ;
  (self._moviePlayer):SetLoopSeek(0, 59)
  self:__ShowItem(1.2)
end

UINDailyDungeonQuickBattle.__OnInstantiateItem = function(self, go)
  -- function num : 0_2 , upvalues : UINDailyDungeonQuickBattleItem
  local item = (UINDailyDungeonQuickBattleItem.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._itemDic)[go] = item
end

UINDailyDungeonQuickBattle.__OnChangeItem = function(self, go, index)
  -- function num : 0_3
  local item = (self._itemDic)[go]
  local stageCfg = (self._stageList)[index + 1]
  local dungeonElem = (self._dungeonElems)[index + 1]
  local stageIndex = index + self._startNum
  item:InitDailyQuickBattleItem(stageCfg, stageIndex, self._isDouble, dungeonElem.commonRewards)
  if index > self._scrollIndex then
    item:ShowDailyQuickBattleItem(not self._isInAutoShow)
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

UINDailyDungeonQuickBattle.__ShowItem = function(self, time)
  -- function num : 0_4 , upvalues : _ENV
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).rect).raycastTarget = false
  ;
  (((self.ui).btn_Clear).gameObject):SetActive(false)
  ;
  ((self.ui).obj_Finish):SetActive(false)
  self._timerId = TimerManager:StartTimer(time, function()
    -- function num : 0_4_0 , upvalues : self, _ENV
    self._scrollIndex = self._scrollIndex + 1
    local index = self._scrollIndex
    local go = ((self.ui).list):GetCellByIndex(index - 1)
    do
      if go ~= nil then
        local item = (self._itemDic)[go]
        item:ShowDailyQuickBattleItem(true)
      end
      ;
      ((self.ui).list):LocationItem(index - 1, 500)
      if (self._dungeonElems)[index + 1] == nil then
        TimerManager:StopTimer(self._timerId)
        self._timerId = nil
        ;
        (self._moviePlayer):CancelLoopSeek()
        ;
        (self._moviePlayer):PresetsPauseVideoFrameNo(59)
        ;
        (self._moviePlayer):SetPauseVideoCallback(function()
      -- function num : 0_4_0_0 , upvalues : self
      ((self.ui).obj_Finish):SetActive(true)
      self._isInAutoShow = false
      -- DECOMPILER ERROR at PC8: Confused about usage of register: R0 in 'UnsetPending'

      ;
      ((self.ui).rect).raycastTarget = true
      ;
      (((self.ui).btn_Clear).gameObject):SetActive(true)
    end
)
      else
        if index == 1 then
          self:__ShowItem(2.5)
        end
      end
    end
  end
)
end

UINDailyDungeonQuickBattle.__ShowQuick = function(self)
  -- function num : 0_5 , upvalues : _ENV
  self._isInAutoShow = false
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).rect).raycastTarget = true
  ;
  (((self.ui).btn_Clear).gameObject):SetActive(true)
  ;
  ((self.ui).obj_Finish):SetActive(true)
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  for _,item in pairs(self._itemDic) do
    item:ShowDailyQuickBattleItem(true)
  end
  ;
  ((self.ui).list):LocationItem(#self._dungeonElems - 1, 9999)
  ;
  (self._moviePlayer):CancelLoopSeek()
  ;
  (self._moviePlayer):PresetsPauseVideoFrameNo(59)
end

UINDailyDungeonQuickBattle.QuickQuit = function(self, toHome)
  -- function num : 0_6 , upvalues : _ENV, cs_MovieManager
  if not toHome and self._isInAutoShow then
    self:__ShowQuick()
    ;
    (UIUtil.SetTopStatus)(self, self.QuickQuit, nil, nil, nil, true)
    return 
  end
  if self._moviePlayer ~= nil then
    (self._moviePlayer):ReSet()
    cs_MovieManager:ReturnMoviePlayer(self._moviePlayer)
    self._moviePlayer = nil
  end
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  self:Hide()
end

UINDailyDungeonQuickBattle.OnDelete = function(self)
  -- function num : 0_7 , upvalues : cs_MovieManager, _ENV, base
  if self._moviePlayer ~= nil then
    (self._moviePlayer):ReSet()
    cs_MovieManager:ReturnMoviePlayer(self._moviePlayer)
    self._moviePlayer = nil
  end
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINDailyDungeonQuickBattle

