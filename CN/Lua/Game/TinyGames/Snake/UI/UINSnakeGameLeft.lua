-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSnakeGameLeft = class("UINSnakeGameLeft", UIBaseNode)
local SnakeGameConfig = require("Game.TinyGames.Snake.Config.SnakeGameConfig")
UINSnakeGameLeft.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Play, self, self._OnBtnStartSnakeGame)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Rank, self, self._OnBtnRank)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_EndRank, self, self._OnBtnRank)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Rule, self, self._OnBtnGameRule)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Retry, self, self._OnBtnRetry)
  ;
  ((self.ui).joystick):onTouchMove("+", BindCallback(self, self.OnJoyStickMove))
  ;
  ((self.ui).joystick):onTouchUp("+", BindCallback(self, self.OnJoyStickUp))
  self._lastStickDir = 0
end

UINSnakeGameLeft.InitSnakeGameLeft = function(self, snakeCtrl, snakeWindow)
  -- function num : 0_1 , upvalues : _ENV
  self._snakeCtrl = snakeCtrl
  self._snakeWindow = snakeWindow
  local showEndTime = (self._snakeCtrl):GetSnakeActEndTime()
  local timeTable = TimeUtil:TimestampToDate(showEndTime, false, true)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Time).text = (string.format)("%2d/%2d %2d:%2d", timeTable.month, timeTable.day, timeTable.hour, timeTable.min)
end

UINSnakeGameLeft.EnterSnakeGameLeftInit = function(self)
  -- function num : 0_2
  ((self.ui).controlNode):SetActive(false)
  ;
  ((self.ui).resultlNode):SetActive(false)
  ;
  ((self.ui).initialNode):SetActive(true)
end

UINSnakeGameLeft.InitSnakeGameLeftPlay = function(self)
  -- function num : 0_3
  ((self.ui).controlNode):SetActive(true)
  ;
  ((self.ui).resultlNode):SetActive(false)
  ;
  ((self.ui).initialNode):SetActive(false)
  self:OnJoyStickUp()
  self._lastStickDir = 0
  self:RefreshSnakeLeftScore(0)
end

UINSnakeGameLeft.InitSnakeGameLeftEnd = function(self)
  -- function num : 0_4
  ((self.ui).controlNode):SetActive(false)
  ;
  ((self.ui).resultlNode):SetActive(true)
end

UINSnakeGameLeft.RefeshSnakeLeftBestScore = function(self, bestScore, rankIndex)
  -- function num : 0_5 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).tex_score).text = tostring(bestScore)
  ;
  ((self.ui).tex_Rank):SetIndex(0, tostring(rankIndex))
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_BestScore).text = tostring(bestScore)
end

UINSnakeGameLeft.RefreshSnakeLeftScore = function(self, score)
  -- function num : 0_6 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_PlayScore).text = tostring(score)
end

UINSnakeGameLeft.OnJoyStickMove = function(self, joyStickData)
  -- function num : 0_7 , upvalues : SnakeGameConfig, _ENV
  local angle = joyStickData.angle360
  if joyStickData.power < SnakeGameConfig.JoyStickPowerZone then
    return 
  end
  local dir = nil
  if self._lastStickDir == 0 then
    if angle >= 45 and angle < 135 then
      dir = 1
    else
      if angle >= 135 and angle < 225 then
        dir = 3
      else
        if angle >= 225 and angle < 315 then
          dir = 2
        else
          dir = 4
        end
      end
    end
  else
    local deadAngle = SnakeGameConfig.JoyStickDeadZone
    if 45 + deadAngle <= angle and angle < 135 - deadAngle then
      dir = 1
    else
      if 135 + deadAngle <= angle and angle < 225 - deadAngle then
        dir = 3
      else
        if 225 + deadAngle <= angle and angle < 315 - deadAngle then
          dir = 2
        else
          if 315 + deadAngle <= angle or angle < 45 - deadAngle then
            dir = 4
          else
            return 
          end
        end
      end
    end
  end
  do
    if dir == self._lastStickDir then
      return 
    end
    self:OnJoyStickUp()
    self._lastStickDir = dir
    ;
    (self._snakeCtrl):TryChangeSnakeDir(dir)
    local img = ((self.ui).obj_highlights)[self._lastStickDir]
    if img ~= nil then
      img.color = Color.white
    end
  end
end

UINSnakeGameLeft.OnJoyStickUp = function(self)
  -- function num : 0_8
  do
    if self._lastStickDir > 0 then
      local img = ((self.ui).obj_highlights)[self._lastStickDir]
      if img ~= nil then
        img.color = (self.ui).color_normal
      end
    end
    self._lastStickDir = 0
  end
end

UINSnakeGameLeft._OnBtnStartSnakeGame = function(self)
  -- function num : 0_9
  (self._snakeCtrl):StartSnakeGame()
end

UINSnakeGameLeft._OnBtnGameRule = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local GuidePicture = require("Game.Guide.GuidePicture.GuidePicture")
  ;
  (GuidePicture.OpenGuidePicture)((self._snakeCtrl):GetSnakeRuleId())
end

UINSnakeGameLeft._OnBtnRank = function(self)
  -- function num : 0_11
  (self._snakeCtrl):ClickSnakeRank()
end

UINSnakeGameLeft._OnBtnRetry = function(self)
  -- function num : 0_12
  (self._snakeCtrl):ClickSnakeRetry()
end

return UINSnakeGameLeft

