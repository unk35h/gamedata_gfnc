-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Sector.SectorLevel.UINLevelSimpleItem")
local UINActLevelWin23Item = class("UINActLevelSimpleItem", base)
local ActSectorEnum = require("Game.ActivitySummer.UI.Sector.actSectorEnum")
UINActLevelWin23Item.OnInit = function(self)
  -- function num : 0_0 , upvalues : base
  (base.OnInit)(self)
end

UINActLevelWin23Item.InitSectorLevelItem = function(self, stageCfg, arrangeCfg, clickEvent, resLoader)
  -- function num : 0_1 , upvalues : base
  (base.InitSectorLevelItem)(self, stageCfg, arrangeCfg, clickEvent, resLoader)
end

UINActLevelWin23Item.RefreshNoEntry = function(self)
  -- function num : 0_2
  ((self.ui).noEntry):SetActive(not self.isUnlock)
end

UINActLevelWin23Item.ShowBlueDotLevelItem = function(self, show)
  -- function num : 0_3
end

UINActLevelWin23Item.RefreshLevelState = function(self)
  -- function num : 0_4 , upvalues : _ENV
  self.isClear = (PlayerDataCenter.sectorStage):IsStageComplete((self.stageCfg).id)
  ;
  ((self.ui).clearLevel):SetActive(self.isClear)
  self.isUnlock = (PlayerDataCenter.sectorStage):IsStageUnlock((self.stageCfg).id)
  self:RefreshNoEntry()
  if (self.stageCfg).show_item > 0 then
    ((self.ui).previewItem):SetActive(true)
    -- DECOMPILER ERROR at PC37: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_PreviewItem).sprite = CRH:GetSpriteByItemId((self.stageCfg).show_item)
  else
    ;
    ((self.ui).previewItem):SetActive(false)
  end
end

UINActLevelWin23Item.OnClickLevelItem = function(self)
  -- function num : 0_5 , upvalues : base, _ENV
  (base.OnClickLevelItem)(self)
  if self.stageCfg then
    local win23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
    if win23Ctrl then
      win23Ctrl:RecordNowStageId((self.stageCfg).id)
    end
  end
end

UINActLevelWin23Item.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UINActLevelWin23Item

