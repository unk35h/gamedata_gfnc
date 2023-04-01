-- params : ...
-- function num : 0 , upvalues : _ENV
local AvgUtil = {}
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
AvgUtil.contentSpliter = "<|>"
AvgUtil.ChangeUltSkillOrder = function(change)
  -- function num : 0_0 , upvalues : _ENV
  local window = UIManager:GetWindow(UIWindowTypeID.BattleSkillModule)
  if window ~= nil then
    (window.ultSkillNode):ChangeUltSkillUIOrder(change)
  end
end

AvgUtil.ShowMainCamera = function(active)
  -- function num : 0_1 , upvalues : _ENV
  local sceneName = ((CS.GSceneManager).Instance).curSceneName
  if (string.IsNullOrEmpty)(sceneName) then
    return 
  end
  local MainCamera = UIManager:GetMainCamera()
  do
    if IsNull(MainCamera) then
      local camCtrl = nil
      if (string.contains)(sceneName, "Arena") then
        camCtrl = (CS.CameraController).Instance
      else
        if sceneName == (Consts.SceneName).Main then
          camCtrl = (CS.OasisCameraController).Instance
        end
      end
      if not IsNull(camCtrl) then
        MainCamera = camCtrl.MainCamera
      end
    end
    if not IsNull(MainCamera) then
      local lowerCameraName = (string.lower)(MainCamera.name)
      if (string.contains)(lowerCameraName, "main") and MainCamera.enabled ~= active then
        MainCamera.enabled = active
      end
    end
  end
end

AvgUtil.GetConditionText = function(id, param1, param2)
  -- function num : 0_2 , upvalues : CheckerTypeId, _ENV, ExplorationEnum, AvgUtil
  local str = nil
  if id == CheckerTypeId.CompleteStage then
    local stageCfg = (ConfigData.sector_stage)[param1]
    if stageCfg == nil then
      error("Cant\'t find sector_stage cfg,id = " .. tostring(param1))
    end
    local diffstr = nil
    local difficult = stageCfg.difficulty
    if difficult == (ExplorationEnum.eDifficultType).Normal then
      diffstr = ConfigData:GetTipContent(TipContent.DifficultyName_1)
    else
      if difficult == (ExplorationEnum.eDifficultType).Hard then
        diffstr = ConfigData:GetTipContent(TipContent.DifficultyName_2)
      else
        diffstr = ConfigData:GetTipContent(TipContent.DifficultyName_3)
      end
    end
    local showSectorId = ConfigData:GetSectorIdShow(stageCfg.sector)
    local newDesc = (string.format)(ConfigData:GetTipContent(TipContent.LockTip_Sector), tostring(showSectorId), tostring(showSectorId), tostring(stageCfg.num), diffstr)
    str = (AvgUtil.__AddDecription)(str, newDesc, false)
  else
    do
      if id == CheckerTypeId.CompleteDungeon then
        local stageCfg = (ConfigData.battle_dungeon)[param1]
        if stageCfg == nil then
          error("Cant\'t find battleDungeon cfg,id = " .. tostring(param1))
        end
        local newDesc = (string.format)(ConfigData:GetTipContent(TipContent.FunctionUnlockDescription_BattleDungeon), (LanguageUtil.GetLocaleText)(stageCfg.name))
        str = (AvgUtil.__AddDecription)(str, newDesc, false)
        str = (string.format)((LanguageUtil.GetLocaleText)(str), tostring(param1))
      else
        do
          do
            if id == CheckerTypeId.PlayerLevel then
              local newDesc = (string.format)(ConfigData:GetTipContent(TipContent.FunctionUnlockDescription_Level), tostring(param1))
              str = (AvgUtil.__AddDecription)(str, newDesc, false)
            end
            return str
          end
        end
      end
    end
  end
end

AvgUtil.__AddDecription = function(oldDesc, newDesc, lineWrap)
  -- function num : 0_3 , upvalues : _ENV
  if (string.IsNullOrEmpty)(oldDesc) then
    return newDesc
  end
  if lineWrap then
    oldDesc = oldDesc .. ",\n" .. newDesc
  else
    oldDesc = oldDesc .. "," .. newDesc
  end
  return oldDesc
end

AvgUtil.GetAvgContentShow = function(content)
  -- function num : 0_4 , upvalues : _ENV, AvgUtil
  if (string.IsNullOrEmpty)(content) then
    return content
  end
  local hasSplit = (string.find)(content, AvgUtil.contentSpliter)
  if hasSplit then
    content = (string.gsub)(content, AvgUtil.contentSpliter, "")
  end
  return content
end

AvgUtil.GetAvgContentSplitStr = function(content, splitIdx)
  -- function num : 0_5 , upvalues : _ENV, AvgUtil
  if (string.IsNullOrEmpty)(content) then
    return content
  end
  local contentList = (string.split)(content, AvgUtil.contentSpliter)
  local newContent = ""
  for i = 1, splitIdx do
    local str = contentList[i]
    if str ~= nil then
      newContent = newContent .. str
    end
  end
  return newContent
end

return AvgUtil

