-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityWinter23.UI.Sector.UINActLevelWin23Item")
local UINActLevelWin23RepeatItem = class("UINActLevelWin23RepeatItem", base)
local ActSectorEnum = require("Game.ActivitySummer.UI.Sector.actSectorEnum")
UINActLevelWin23RepeatItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : base
  (base.OnInit)(self)
end

UINActLevelWin23RepeatItem.InitSectorLevelItem = function(self, stageCfg, arrangeCfg, clickEvent, resLoader)
  -- function num : 0_1 , upvalues : base
  (base.InitSectorLevelItem)(self, stageCfg, arrangeCfg, clickEvent, resLoader)
  self:RefreshDropText()
end

UINActLevelWin23RepeatItem.RefreshDropText = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local win23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
  if win23Ctrl then
    local farmDescCfg = (win23Ctrl:GetWinter23Data()):GetFarmDescCfg()
    local stageDescCfg = farmDescCfg[(self.stageCfg).id]
    if stageDescCfg then
      local desc = (LanguageUtil.GetLocaleText)(stageDescCfg.drop_up_desc)
      if not (string.IsNullOrEmpty)(desc) then
        ((self.ui).obj_DropUp):SetActive(true)
        -- DECOMPILER ERROR at PC33: Confused about usage of register: R5 in 'UnsetPending'

        ;
        ((self.ui).drop_text).text = desc
        return 
      end
    end
  end
  do
    ;
    ((self.ui).obj_DropUp):SetActive(false)
  end
end

UINActLevelWin23RepeatItem.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINActLevelWin23RepeatItem

