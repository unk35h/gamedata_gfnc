-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Sector.SectorLevel.UINLevelAvgMain")
local UINActLevelAvgWin23Main = class("UINActLevelAvgMain", base)
local ActSectorEnum = require("Game.ActivitySummer.UI.Sector.actSectorEnum")
UINActLevelAvgWin23Main.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, base
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (base.OnInit)(self)
end

UINActLevelAvgWin23Main.InitActLAvgMain = function(self, avgCfg, arrangeCfg, clickEvent, resLoader)
  -- function num : 0_1 , upvalues : base
  (base.InitLAvgMain)(self, avgCfg, arrangeCfg, clickEvent, resLoader)
  self:RefreshWin23AvgIcon(resLoader)
end

UINActLevelAvgWin23Main.RefreshWin23AvgIcon = function(self, resLoader)
  -- function num : 0_2 , upvalues : _ENV
  (((self.ui).img_icon).gameObject):SetActive(false)
  resLoader:LoadABAssetAsync(PathConsts:GetAtlasAssetPath("SectorLevelIcon"), function(spriteAtlas)
    -- function num : 0_2_0 , upvalues : _ENV, self
    if spriteAtlas == nil or IsNull(self.transform) then
      return 
    end
    local stageIcon = (AtlasUtil.GetResldSprite)(spriteAtlas, "SStageTutorial")
    ;
    (((self.ui).img_icon).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_icon).sprite = stageIcon
  end
)
end

UINActLevelAvgWin23Main.RefreshLAvgMainState = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  self.isUnlock = avgPlayCtrl:IsAvgUnlock((self.avgCfg).id)
  ;
  ((self.ui).noEntry):SetActive(not self.isUnlock)
  ;
  ((self.ui).clearLevel):SetActive(avgPlayCtrl:IsAvgPlayed((self.avgCfg).id))
end

UINActLevelAvgWin23Main.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINActLevelAvgWin23Main

