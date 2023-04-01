-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonCenterUtil = {}
DungeonCenterUtil.EnterDungeonFormationDeal = function()
  -- function num : 0_0 , upvalues : _ENV
  (ControllerManager:GetController(ControllerTypeId.SectorController)):EnbleSectorUI3D(false)
  UIManager:HideWindow(UIWindowTypeID.Sector)
  UIManager:HideWindow(UIWindowTypeID.DungeonTowerLevel)
  UIManager:HideWindow(UIWindowTypeID.DungeonLevelDetail)
  UIManager:HideWindow(UIWindowTypeID.ActivityWinterDungeon)
  UIManager:HideWindow(UIWindowTypeID.DungeonTowerSelect)
end

DungeonCenterUtil.ExitDungeonFormationDeal = function()
  -- function num : 0_1 , upvalues : _ENV
  (ControllerManager:GetController(ControllerTypeId.SectorController)):EnbleSectorUI3D(true)
  UIManager:ShowWindowOnly(UIWindowTypeID.DungeonLevelDetail, true)
  UIManager:ShowWindowOnly(UIWindowTypeID.DungeonTowerLevel, true)
  UIManager:ShowWindowOnly(UIWindowTypeID.Sector, true)
  UIManager:ShowWindowOnly(UIWindowTypeID.ActivityWinterDungeon, true)
  UIManager:ShowWindowOnly(UIWindowTypeID.DungeonTowerSelect, true)
end

return DungeonCenterUtil

