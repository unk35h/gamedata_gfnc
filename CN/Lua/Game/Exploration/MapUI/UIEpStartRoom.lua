-- params : ...
-- function num : 0 , upvalues : _ENV
local UIEpStartRoom = class("UIEpStartRoom", UIBaseNode)
local SectorEnum = require("Game.Sector.SectorEnum")
UIEpStartRoom.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.resloader = ((CS.ResLoader).Create)()
end

UIEpStartRoom.InitRoomUI = function(self, roomData, resloader)
  -- function num : 0_1 , upvalues : _ENV
  self.roomData = roomData
  local sectorStageCfg = ExplorationManager:GetSectorStageCfg()
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_LayerCount).text = tostring(ExplorationManager:GetCurLevelIndex() + 1) .. "/" .. tostring(ExplorationManager:GetLevelCount())
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_LevelName).text = (LanguageUtil.GetLocaleText)(sectorStageCfg.name)
  local levelInfo = nil
  if sectorStageCfg.endlessCfg ~= nil then
    levelInfo = ConfigData:GetEndlessInfoMsg(sectorStageCfg, (sectorStageCfg.endlessCfg).index * 10)
    -- DECOMPILER ERROR at PC41: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_LevelCount).text = levelInfo
  else
    if sectorStageCfg.challengeCfg ~= nil then
      (((self.ui).tex_LevelCount).gameObject):SetActive(false)
      ;
      (((self.ui).img_SectorIcon).gameObject):SetActive(false)
      return 
    else
      levelInfo = ConfigData:GetSectorInfoMsg(sectorStageCfg.sector, sectorStageCfg.num, sectorStageCfg.difficulty)
      -- DECOMPILER ERROR at PC69: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.ui).tex_LevelCount).text = levelInfo
    end
  end
  ;
  (((self.ui).img_SectorIcon).gameObject):SetActive(false)
  local sectorCfg = ExplorationManager:GetSectorCfg()
  local hasCfg = sectorCfg ~= nil
  if not hasCfg then
    error("Cant get sectorCfg By ExplorationManager:GetSectorCfg()")
    return 
  end
  local textureName = sectorCfg.scene_icon
  if not (string.IsNullOrEmpty)(textureName) then
    resloader:LoadABAssetAsync(PathConsts:GetSeceneIconPicPath(textureName), function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if IsNull(self.transform) then
      return 
    end
    ;
    (((self.ui).img_SectorIcon).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_SectorIcon).texture = texture
  end
)
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UIEpStartRoom.GetRoomSize = function(self)
  -- function num : 0_2
  return (((self.ui).roomNode).transform).sizeDelta
end

UIEpStartRoom.ChangeUIState = function(self, eRoomState, withTween, isAutoPath)
  -- function num : 0_3
end

return UIEpStartRoom

