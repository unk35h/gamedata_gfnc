-- params : ...
-- function num : 0 , upvalues : _ENV
local HotfixBattleRoleView = class("HotfixBattleRoleView", HotfixBase)
local BattleRoleView = CS.BattleRoleView
local CS_BattleManager_Ins = (CS.BattleManager).Instance
local InitRole_RetainOld = function(self, summonerEntity, isHideStateBar, isHideInfoBar, showHpText)
  -- function num : 0_0 , upvalues : CS_BattleManager_Ins
  self:InitRole(summonerEntity, isHideStateBar, isHideInfoBar, showHpText)
  local charaInfoRenderHandle = CS_BattleManager_Ins.charaInfoRenderHandle
  if charaInfoRenderHandle ~= nil and not charaInfoRenderHandle.enableBattleUIState then
    charaInfoRenderHandle:HideCharacterInfoWindow()
  end
end

HotfixBattleRoleView.Register = function(self)
  -- function num : 0_1 , upvalues : BattleRoleView, InitRole_RetainOld
  self:RegisterHotfix(BattleRoleView, "InitRole", InitRole_RetainOld, true)
end

return HotfixBattleRoleView

