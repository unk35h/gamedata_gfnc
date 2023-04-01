-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessMainTop_PressPanel = class("UINWarChessMainTop_PressPanel", base)
local UINWarChessMainTop_PressPanelItem = require("Game.WarChess.UI.Main.Top.UINWarChessMainTop_PressPanelItem")
local UINWarChessMainTop_PressPanelEffectItem = require("Game.WarChess.UI.Main.Top.UINWarChessMainTop_PressPanelEffectItem")
UINWarChessMainTop_PressPanel.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWarChessMainTop_PressPanelItem, UINWarChessMainTop_PressPanelEffectItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.__OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_bG, self, self.__OnClickClose)
  self._pressLevelPool = (UIItemPool.New)(UINWarChessMainTop_PressPanelItem, (self.ui).obj_pressureItem, false)
  self._effectItemPool = (UIItemPool.New)(UINWarChessMainTop_PressPanelEffectItem, (self.ui).obj_item, false)
end

UINWarChessMainTop_PressPanel.BindPressResloader = function(self, resloader)
  -- function num : 0_1 , upvalues : _ENV
  self._resloader = resloader
  self._iconAtlas = (AtlasUtil.GetSpirteAtlas)(UIAtlasConsts.Atlas_WarChess, resloader)
end

UINWarChessMainTop_PressPanel.__OnClickClose = function(self)
  -- function num : 0_2
  self:Hide()
end

UINWarChessMainTop_PressPanel.RefreshWCPressFrame = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  local wcStressCfgs = (wcCtrl.turnCtrl):GetWCStressCfgs()
  local stressLevel, stressPoint = (wcCtrl.turnCtrl):GetWCStressLevelAndPoint()
  ;
  ((self.ui).tex_Lv):SetIndex(0, tostring(stressLevel))
  ;
  (self._pressLevelPool):HideAll()
  ;
  (self._effectItemPool):HideAll()
  for level,stressCfg in ipairs(wcStressCfgs) do
    local isReached = stressCfg.stresspoint <= stressPoint
    local levelItem = ((self._pressLevelPool):GetOne())
    local iconSprite = nil
    if not (string.IsNullOrEmpty)(stressCfg.stressicon) then
      iconSprite = (AtlasUtil.GetResldSprite)(self._iconAtlas, stressCfg.stressicon)
    end
    levelItem:RefreshWCPressItem(stressPoint, R16_PC52, iconSprite)
    levelItem:PlayPressureItemTween(level)
    if isReached then
      local effectItem = (self._effectItemPool):GetOne()
      effectItem:RefreshWCPressEffectItem(R16_PC52)
    end
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINWarChessMainTop_PressPanel.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessMainTop_PressPanel

