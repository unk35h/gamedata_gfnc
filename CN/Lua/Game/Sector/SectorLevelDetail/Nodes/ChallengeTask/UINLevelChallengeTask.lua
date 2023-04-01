-- params : ...
-- function num : 0 , upvalues : _ENV
local UINLevelChallengeTask = class("UINLevelChallengeTask", UIBaseNode)
local base = UIBaseNode
local UINLvChallengeTaskItem = require("Game.Sector.SectorLevelDetail.Nodes.ChallengeTask.UINLvChallengeTaskItem")
UINLevelChallengeTask.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINLvChallengeTaskItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  if not IsNull((self.ui).btn_root) then
    (UIUtil.AddButtonListener)((self.ui).btn_root, self, self._OnClickShowInfo)
  end
  self.taskItemPool = (UIItemPool.New)(UINLvChallengeTaskItem, (self.ui).callTaskItem, false)
end

UINLevelChallengeTask.InitLevelChallengeTask = function(self, stageCfg)
  -- function num : 0_1 , upvalues : _ENV
  self.stageCfg = stageCfg
  ;
  (self.taskItemPool):HideAll()
  for k,taskId in ipairs(stageCfg.hard_task) do
    local taskCfg = (ConfigData.task)[taskId]
    local isComplete = (PlayerDataCenter.sectorAchievementDatas):IsChallengeTaskComplete(stageCfg.id, taskId)
    local taskItem = (self.taskItemPool):GetOne()
    taskItem:InitLvChallengeTaskItem(taskCfg, isComplete)
  end
end

UINLevelChallengeTask._OnClickShowInfo = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local sctPowerLimitCfg = (ConfigData.sector_power_limit)[(self.stageCfg).power_limit]
  if sctPowerLimitCfg == nil then
    error("Cant get sector_power_limit, id = " .. tostring((self.stageCfg).power_limit))
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.FmtChallengeInfo, function(win)
    -- function num : 0_2_0 , upvalues : sctPowerLimitCfg
    if win == nil then
      return 
    end
    win:InitFmtChallengeInfo(sctPowerLimitCfg)
  end
)
end

UINLevelChallengeTask.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (self.taskItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINLevelChallengeTask

