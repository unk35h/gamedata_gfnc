-- params : ...
-- function num : 0 , upvalues : _ENV
local UINMiniGameGroupList = class("UINMiniGameGroupList", UIBaseNode)
local base = UIBaseNode
local UINMiniGameGroupItem = require("Game.ActivityHistoryTinyGame.UI.UINMiniGameGroupItem")
local CS_ResLoader = CS.ResLoader
UINMiniGameGroupList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINMiniGameGroupItem, CS_ResLoader
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._itemPool = (UIItemPool.New)(UINMiniGameGroupItem, (self.ui).gameItem)
  ;
  ((self.ui).gameItem):SetActive(false)
  self.__OnEnterMiniGameCallback = BindCallback(self, self.__OnEnterMiniGame)
  self.resLoader = (CS_ResLoader.Create)()
end

UINMiniGameGroupList.InitMiniGameGroup = function(self, actHTGData)
  -- function num : 0_1 , upvalues : _ENV
  self._actHTGData = actHTGData
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).actName).text = (self._actHTGData):GetActivityName()
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  local actFrameId = (self._actHTGData):GetActFrameId()
  ;
  (self._itemPool):HideAll()
  for index,gameType in ipairs(((self._actHTGData):GetTGCfgData()).tiny_game_type) do
    local item = (self._itemPool):GetOne()
    local data = (self._actHTGData):GetHTGData(gameType)
    item:InitMiniGameGroupItem(data, self.resLoader, self.__OnEnterMiniGameCallback)
    item:PlayMiniGroupItemAni(index * 0.033)
  end
  self._timerId = TimerManager:StartTimer(1, self.__CountDown, self)
  self:__CountDown()
end

UINMiniGameGroupList.__CountDown = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self._nextTime == nil or self._nextTime < PlayerDataCenter.timestamp then
    if (self._actHTGData):GetActivityDestroyTime() < PlayerDataCenter.timestamp then
      if self._timerId ~= nil then
        TimerManager:StopTimer(self._timerId)
        self._timerId = nil
      end
      for i,v in ipairs((self._itemPool).listItem) do
        v:SetHTGMiniGameLocked(true)
      end
      return 
    end
    local desIndex = nil
    if PlayerDataCenter.timestamp < (self._actHTGData):GetActivityEndTime() then
      self._nextTime = (self._actHTGData):GetActivityEndTime()
      for i,v in ipairs((self._itemPool).listItem) do
        v:SetHTGMiniGameLocked(false)
      end
      desIndex = 0
    else
      self._nextTime = (self._actHTGData):GetActivityDestroyTime()
      for i,v in ipairs((self._itemPool).listItem) do
        v:SetHTGMiniGameLocked(true)
      end
      desIndex = 1
    end
    local date = TimeUtil:TimestampToDate(self._nextTime, false, true)
    ;
    ((self.ui).text_time):SetIndex(desIndex, (string.format)("%02d", date.month), (string.format)("%02d", date.day), (string.format)("%02d", date.hour), (string.format)("%02d", date.min))
  end
  do
    local diffCount = self._nextTime - PlayerDataCenter.timestamp
    local d, h, m = TimeUtil:TimestampToTimeInter(diffCount, false, true)
    if d > 0 then
      ((self.ui).tex_TimeLeft):SetIndex(0, tostring(d))
    else
      if h > 0 then
        ((self.ui).tex_TimeLeft):SetIndex(1, tostring(h))
      else
        ;
        ((self.ui).tex_TimeLeft):SetIndex(2, tostring(m))
      end
    end
  end
end

UINMiniGameGroupList.__OnEnterMiniGame = function(self, miniGameData)
  -- function num : 0_3
  if (self._actHTGData):IsActivityRunning() then
    (self._actHTGData):PlayHTG(miniGameData:GetTinyGameType())
  end
end

UINMiniGameGroupList.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base, _ENV
  (base.OnDelete)(self)
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  ;
  (self.resLoader):Put2Pool()
  self.resLoader = nil
end

return UINMiniGameGroupList

