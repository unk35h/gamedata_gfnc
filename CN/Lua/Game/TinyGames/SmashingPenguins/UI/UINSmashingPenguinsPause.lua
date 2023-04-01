-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSmashingPenguinsPause = class("UINSmashingPenguinsPause", UIBaseNode)
local base = UIBaseNode
UINSmashingPenguinsPause.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Back, self, self.OnEndGameBtnClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Continue, self, self.OnContinueGameBtnClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Restart, self, self.OnRestartGameBtnClick)
end

UINSmashingPenguinsPause.InitSmashingPenguinsPause = function(self, mainController)
  -- function num : 0_1 , upvalues : _ENV
  self.mainController = mainController
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Score).text = tostring(mainController.currentScore)
end

UINSmashingPenguinsPause.OnEndGameBtnClick = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local mainUI = UIManager:GetWindow(UIWindowTypeID.SmashingPenguins)
  if IsNull(mainUI) then
    return 
  end
  mainUI:OnQuitGameBtnClick()
end

UINSmashingPenguinsPause.OnContinueGameBtnClick = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local mainUI = UIManager:GetWindow(UIWindowTypeID.SmashingPenguins)
  if IsNull(mainUI) then
    return 
  end
  ;
  (self.mainController):SetSmashingPenguinsGamePause(false)
  self:Hide()
  mainUI:OnContinueGame()
end

UINSmashingPenguinsPause.OnRestartGameBtnClick = function(self)
  -- function num : 0_4
  self:Hide()
  ;
  (self.mainController):RestartSmashingPenguins()
end

return UINSmashingPenguinsPause

