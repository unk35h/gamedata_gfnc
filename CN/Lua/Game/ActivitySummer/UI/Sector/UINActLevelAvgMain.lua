-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Sector.SectorLevel.UINLevelAvgMain")
local UINActLevelAvgMain = class("UINActLevelAvgMain", base)
local ActSectorEnum = require("Game.ActivitySummer.UI.Sector.actSectorEnum")
UINActLevelAvgMain.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, base
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (base.OnInit)(self)
end

UINActLevelAvgMain.InitActLAvgMain = function(self, avgCfg, arrangeCfg, clickEvent, resLoader)
  -- function num : 0_1 , upvalues : base
  (base.InitLAvgMain)(self, avgCfg, arrangeCfg, clickEvent, resLoader)
  self:SwitchActLAvgTypeUI(avgCfg, arrangeCfg)
end

UINActLevelAvgMain.SwitchActLAvgTypeUI = function(self, avgCfg, arrangeCfg)
  -- function num : 0_2 , upvalues : _ENV, ActSectorEnum
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).img_Hard).enabled = false
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Simple).enabled = false
  local ctrl = ControllerManager:GetController(ControllerTypeId.SectorController)
  if ctrl == nil then
    return 
  end
  local showTypeID = ctrl:TryGetShowTypeID(avgCfg.sectorId, arrangeCfg, avgCfg.show_type)
  if showTypeID == nil then
    return 
  end
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_Hard).enabled = showTypeID == (ActSectorEnum.eSectorMode).Normal
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_Simple).enabled = showTypeID == (ActSectorEnum.eSectorMode).Support
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINActLevelAvgMain.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINActLevelAvgMain

