-- params : ...
-- function num : 0 , upvalues : _ENV
local UIDungeonTowerRacing = class("UIDungeonTowerRacing", UIBaseWindow)
local base = UIBaseWindow
local UINDunTowerRacingItem = require("Game.DungeonCenter.TowerUI.UINDunTowerRacingItem")
UIDungeonTowerRacing.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINDunTowerRacingItem
  (UIUtil.SetTopStatus)(self, self.Delete)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancle, self, self._OnBtnCloseClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Bg, self, self._OnBtnCloseClicked)
  self._racingTaskPool = (UIItemPool.New)(UINDunTowerRacingItem, (self.ui).taskItem, false)
  self.__onRacingRewardPick = BindCallback(self, self._OnRacingRewardPick)
end

UIDungeonTowerRacing.InitTowerRacing = function(self, towerTypeData)
  -- function num : 0_1 , upvalues : _ENV
  self._towerTypeData = towerTypeData
  local towerId = towerTypeData:GetDungeonTowerTypeId()
  self._towerId = towerId
  local isComplete, totalFrame = (PlayerDataCenter.dungeonTowerSData):GetTowerTotalRacingFrame(towerId)
  self._isComplete = isComplete
  self._totalFrame = totalFrame
  if isComplete then
    ((self.ui).tex_TotalTime):SetIndex(0, (BattleUtil.FrameToTimeString)(totalFrame, true))
  else
    ;
    ((self.ui).tex_TotalTime):SetIndex(1)
  end
  self:_InitRacingTaskList()
end

UIDungeonTowerRacing._InitRacingTaskList = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local isComplete, totalFrame = self._isComplete, self._totalFrame
  ;
  (self._racingTaskPool):HideAll()
  local towerRacingCfg = (self._towerTypeData):GetTowerRacingCfg()
  if towerRacingCfg == nil then
    return 
  end
  local pickedList = {}
  for id,racingCfg in pairs(towerRacingCfg) do
    local isPicked = (PlayerDataCenter.dungeonTowerSData):IsTowerRacingRewardPick(self._towerId, racingCfg.reward_id)
    local achieve = false
    if isPicked then
      (table.insert)(pickedList, id)
    else
      local frame = (BattleUtil.SecondToFrame)(racingCfg.time_limit)
      achieve = not isComplete or totalFrame <= frame
      local racingTaskItem = (self._racingTaskPool):GetOne()
      racingTaskItem:InitRacintTaskItem(racingCfg, false, achieve, self.__onRacingRewardPick)
    end
  end
  for _,id in pairs(pickedList) do
    local racingCfg = towerRacingCfg[id]
    local racingTaskItem = (self._racingTaskPool):GetOne()
    racingTaskItem:InitRacintTaskItem(racingCfg, true, false, self.__onRacingRewardPick)
  end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UIDungeonTowerRacing._OnRacingRewardPick = function(self, racingCfg, racingTaskItem)
  -- function num : 0_3 , upvalues : _ENV
  local dunTowerNetwork = NetworkManager:GetNetwork(NetworkTypeID.DungeonTower)
  dunTowerNetwork:CS_DUNGEONTOWER_Pick(self._towerId, racingCfg.reward_id, function()
    -- function num : 0_3_0 , upvalues : _ENV, self, racingCfg
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_3_0_0 , upvalues : self, _ENV, racingCfg
      if window == nil then
        return 
      end
      self:_InitRacingTaskList()
      local CommonRewardData = require("Game.CommonUI.CommonRewardData")
      local CRData = (CommonRewardData.CreateCRDataUseList)(racingCfg.reward_ids, racingCfg.reward_nums)
      window:AddAndTryShowReward(CRData)
    end
)
  end
)
end

UIDungeonTowerRacing._OnBtnCloseClicked = function(self)
  -- function num : 0_4 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIDungeonTowerRacing.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UIDungeonTowerRacing

