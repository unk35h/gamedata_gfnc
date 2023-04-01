-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnivalNewUnlock = class("UINCarnivalNewUnlock", UIBaseNode)
local base = UIBaseNode
local ActivityCarnivalEnum = require("Game.ActivityCarnival.ActivityCarnivalEnum")
UINCarnivalNewUnlock.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_BG, self, self.OnClickNext)
  ;
  (UIUtil.AddButtonListener)((self.ui).checkBG, self, self.OnClickJump)
end

UINCarnivalNewUnlock.CarnivalNewUnlockBindFunc = function(self, reviewStageFunc, envFunc)
  -- function num : 0_1
  self._reviewStageFunc = reviewStageFunc
  self._envFunc = envFunc
end

UINCarnivalNewUnlock.InitCarnivalNewUnlock = function(self, carnivalData)
  -- function num : 0_2
  self._nextIndex = 1
  self._carnivalData = carnivalData
  self._infoList = carnivalData:GetNewunlockInfo()
  self:__ShowMessage()
end

UINCarnivalNewUnlock.__ShowMessage = function(self)
  -- function num : 0_3 , upvalues : ActivityCarnivalEnum, _ENV
  local info = (self._infoList)[self._nextIndex]
  if info == nil then
    return 
  end
  if info.unlockType == (ActivityCarnivalEnum.eActivityCarnivalUnlockNew).Env then
    local envCfg = (self._carnivalData):GetCarnivalEnvCfgById(info.unlockId)
    if envCfg ~= nil then
      local desName = (LanguageUtil.GetLocaleText)(envCfg.env_name)
      ;
      ((self.ui).tex_CNUnlock):SetIndex(info.unlockType - 1, desName)
    end
  else
    do
      if info.unlockType == (ActivityCarnivalEnum.eActivityCarnivalUnlockNew).Stage then
        local stageCfg = (ConfigData.sector_stage)[info.unlockId]
        if stageCfg ~= nil then
          local showIndex = stageCfg.num
          local desName = (LanguageUtil.GetLocaleText)(stageCfg.name)
          ;
          ((self.ui).tex_CNUnlock):SetIndex(info.unlockType - 1, tostring(showIndex), desName)
        end
      else
        do
          local avgCfg = (ConfigData.story_avg)[info.unlockId]
          if avgCfg ~= nil then
            local showIndex = avgCfg.number
            local desName = (LanguageUtil.GetLocaleText)(avgCfg.name)
            ;
            ((self.ui).tex_CNUnlock):SetIndex(info.unlockType - 1, tostring(showIndex), desName)
          end
        end
      end
    end
  end
end

UINCarnivalNewUnlock.OnClickNext = function(self)
  -- function num : 0_4
  self._nextIndex = self._nextIndex + 1
  if #self._infoList < self._nextIndex then
    (self._carnivalData):ClearNewUnlockInfo()
    self:Hide()
  else
    self:__ShowMessage()
  end
end

UINCarnivalNewUnlock.OnClickJump = function(self)
  -- function num : 0_5 , upvalues : ActivityCarnivalEnum
  local info = (self._infoList)[self._nextIndex]
  if not (self._carnivalData):IsActivityRunning() and info.unlockType == (ActivityCarnivalEnum.eActivityCarnivalUnlockNew).Env then
    return 
  end
  self:Hide()
  ;
  (self._carnivalData):ClearNewUnlockInfo()
  if info == nil then
    return 
  end
  -- DECOMPILER ERROR at PC31: Unhandled construct in 'MakeBoolean' P1

  if info.unlockType == (ActivityCarnivalEnum.eActivityCarnivalUnlockNew).Env and self._envFunc ~= nil then
    (self._envFunc)()
  end
  if self._reviewStageFunc ~= nil then
    (self._reviewStageFunc)()
  end
end

return UINCarnivalNewUnlock

