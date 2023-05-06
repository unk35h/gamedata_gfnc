-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivitySpring.UI.UISpring23Unlock")
local UIActivitySeasonUnlock = class("UIActivitySeasonUnlock", base)
local ActCommonEnum = require("Game.Common.Activity.ActCommonEnum")
UIActivitySeasonUnlock.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.OnCloseUnlock)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Check, self, self.OnClickJump)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_BG, self, self.OnClickBG)
  ;
  (((self.ui).tex_UnlockExtra).gameObject):SetActive(false)
end

UIActivitySeasonUnlock.BindSeasonUnlockFunc = function(self, avgCheckFunc, avgJumpFunc, repeatCheckFunc, repeatJumpFunc)
  -- function num : 0_1
  self._avgCheckFunc = avgCheckFunc
  self._avgJumpFunc = avgJumpFunc
  self._repeatCheckFunc = repeatCheckFunc
  self._repeatJumpFunc = repeatJumpFunc
end

UIActivitySeasonUnlock.ShowNext = function(self)
  -- function num : 0_2 , upvalues : ActCommonEnum, _ENV
  self._index = self._index + 1
  local unlockElemt = (self._unlockList)[self._index]
  if unlockElemt.unlockType == (ActCommonEnum.ActUnlockType).NormalAvg then
    local avgCfg = (ConfigData.story_avg)[unlockElemt.unlockId]
    if avgCfg ~= nil then
      local showIndex = avgCfg.number
      local desName = (LanguageUtil.GetLocaleText)(avgCfg.name)
      ;
      ((self.ui).tex_Unlock):SetIndex(0, desName)
    end
    do
      do
        self:__PlayTween()
        if unlockElemt.unlockType == (ActCommonEnum.ActUnlockType).DunRepeat then
          local stageCfg = (ConfigData.battle_dungeon)[unlockElemt.unlockId]
          if stageCfg ~= nil then
            ((self.ui).tex_Unlock):SetIndex(0, (LanguageUtil.GetLocaleText)(stageCfg.name))
          end
          self:__PlayTween()
        else
          do
            self:OnClickBG()
          end
        end
      end
    end
  end
end

UIActivitySeasonUnlock.OnClickJump = function(self)
  -- function num : 0_3 , upvalues : _ENV, ActCommonEnum
  local unlockElemt = (self._unlockList)[self._index]
  if unlockElemt == nil then
    return 
  end
  ;
  (UIUtil.OnClickBackByUiTab)(self)
  if unlockElemt.unlockType == (ActCommonEnum.ActUnlockType).NormalAvg then
    if self._avgCheckFunc ~= nil and not (self._avgCheckFunc)() then
      return 
    end
    if self._avgJumpFunc ~= nil then
      (self._avgJumpFunc)()
    end
  else
    if unlockElemt.unlockType == (ActCommonEnum.ActUnlockType).DunRepeat then
      if self._repeatCheckFunc ~= nil and not (self._repeatCheckFunc)() then
        return 
      end
      if self._repeatJumpFunc ~= nil then
        (self._repeatJumpFunc)()
      end
    end
  end
end

return UIActivitySeasonUnlock

