-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Sector.SectorLevel.UINLevelSimpleItem")
local UINActLevelSimpleItem = class("UINActLevelSimpleItem", base)
local ActSectorEnum = require("Game.ActivitySummer.UI.Sector.actSectorEnum")
UINActLevelSimpleItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, base
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (base.OnInit)(self)
end

UINActLevelSimpleItem.InitSectorLevelItem = function(self, stageCfg, arrangeCfg, clickEvent, resLoader)
  -- function num : 0_1 , upvalues : base
  (base.InitSectorLevelItem)(self, stageCfg, arrangeCfg, clickEvent, resLoader)
  self:SwitchActLTypeUI(stageCfg, arrangeCfg)
end

UINActLevelSimpleItem.SwitchActLTypeUI = function(self, stageCfg, arrangeCfg)
  -- function num : 0_2 , upvalues : ActSectorEnum, _ENV
  self:_ShowUI((ActSectorEnum.eSectorMode).Support)
  local ctrl = ControllerManager:GetController(ControllerTypeId.SectorController)
  if ctrl == nil then
    return 
  end
  local showTypeID = ctrl:TryGetShowTypeID(stageCfg.sector, arrangeCfg, stageCfg.show_type)
  if showTypeID == (ActSectorEnum.eSectorMode).Normal then
    self:_ShowUI((ActSectorEnum.eSectorMode).Normal)
  end
end

UINActLevelSimpleItem._ShowUI = function(self, eSectorMode)
  -- function num : 0_3 , upvalues : ActSectorEnum, _ENV
  local isSupport = eSectorMode == (ActSectorEnum.eSectorMode).Support
  local imgIdx = isSupport and 0 or 1
  if not isSupport or not Color.black then
    local col = Color.white
  end
  ;
  ((self.ui).img_Button):SetIndex(imgIdx)
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_SubTile).color = col
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Tile).color = col
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_Pic).color = col
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

UINActLevelSimpleItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINActLevelSimpleItem

