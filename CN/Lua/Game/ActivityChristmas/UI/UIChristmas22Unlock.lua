-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIChristmas22Unlock = class("UIChristmas22Unlock", base)
local ActCommonEnum = require("Game.Common.Activity.ActCommonEnum")
UIChristmas22Unlock.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.Delete, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_BG, self, self.OnClickNext)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Check, self, self.OnClickJump)
end

UIChristmas22Unlock.Christmas22UnlockBindFunc = function(self, avgFunc, envFunc, dunFunc)
  -- function num : 0_1
  self._avgFunc = avgFunc
  self._envFunc = envFunc
  self._dunFunc = dunFunc
end

UIChristmas22Unlock.InitChristmas22NewUnlock = function(self, unlockInfo, actData)
  -- function num : 0_2
  self._nextIndex = 1
  self._unlockInfo = unlockInfo
  self._infoList = unlockInfo:GetActUnlockInfoList()
  self._actData = actData
  self:__ShowMessage()
end

UIChristmas22Unlock.__ShowMessage = function(self)
  -- function num : 0_3 , upvalues : ActCommonEnum, _ENV
  local info = (self._infoList)[self._nextIndex]
  if info == nil then
    return 
  end
  if info.unlockType == (ActCommonEnum.ActUnlockType).NormalAvg then
    local avgCfg = (ConfigData.story_avg)[info.unlockId]
    if avgCfg ~= nil then
      local showIndex = avgCfg.number
      local desName = (LanguageUtil.GetLocaleText)(avgCfg.name)
      ;
      ((self.ui).tex_Unlock):SetIndex(1, tostring(showIndex), desName)
    end
  else
    do
      if info.unlockType == (ActCommonEnum.ActUnlockType).EnvDifficulty then
        local actId = (self._actData):GetActId()
        local diffInfoCfg = ((ConfigData.activity_hallowmas_stage_info)[actId])[info.unlockId]
        local envCfg = (ConfigData.activity_hallowmas_general_env)[info.unlockPara]
        if envCfg ~= nil and diffInfoCfg ~= nil then
          local desName = (LanguageUtil.GetLocaleText)(envCfg.general_env_name)
          local diffName = (LanguageUtil.GetLocaleText)(diffInfoCfg.difficulty_name)
          ;
          ((self.ui).tex_Unlock):SetIndex(0, desName, diffName)
        end
      else
        do
          if info.unlockType == (ActCommonEnum.ActUnlockType).DunRepeat then
            local stageCfg = (ConfigData.battle_dungeon)[info.unlockId]
            if stageCfg ~= nil then
              ((self.ui).tex_Unlock):SetIndex(2, (LanguageUtil.GetLocaleText)(stageCfg.name))
            end
          end
        end
      end
    end
  end
end

UIChristmas22Unlock.OnClickNext = function(self)
  -- function num : 0_4 , upvalues : _ENV
  self._nextIndex = self._nextIndex + 1
  if #self._infoList < self._nextIndex then
    (self._unlockInfo):ClearActUnlockInfo()
    ;
    (UIUtil.OnClickBack)()
  else
    self:__ShowMessage()
  end
end

UIChristmas22Unlock.OnClickJump = function(self)
  -- function num : 0_5 , upvalues : _ENV, ActCommonEnum
  (UIUtil.OnClickBack)()
  local info = (self._infoList)[self._nextIndex]
  if not (self._actData):IsActivityRunning() then
    return 
  end
  ;
  (self._unlockInfo):ClearActUnlockInfo()
  if info == nil then
    return 
  end
  -- DECOMPILER ERROR at PC27: Unhandled construct in 'MakeBoolean' P1

  if info.unlockType == (ActCommonEnum.ActUnlockType).NormalAvg and self._avgFunc ~= nil then
    (self._avgFunc)()
  end
  -- DECOMPILER ERROR at PC38: Unhandled construct in 'MakeBoolean' P1

  if info.unlockType == (ActCommonEnum.ActUnlockType).EnvDifficulty and self._envFunc ~= nil then
    (self._envFunc)()
  end
  if info.unlockType == (ActCommonEnum.ActUnlockType).DunRepeat and self._dunFunc ~= nil then
    (self._dunFunc)()
  end
end

UIChristmas22Unlock.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UIChristmas22Unlock

