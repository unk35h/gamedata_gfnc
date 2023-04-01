-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActSum22MapSelected = class("UINActSum22MapSelected", UIBaseNode)
local base = UIBaseNode
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
UINActSum22MapSelected.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._starDefaultWidth = (((self.ui).challenge).rect).width
end

UINActSum22MapSelected.InitMapSelected = function(self, sectorLevelData)
  -- function num : 0_1
  ((self.ui).ani_root):Rewind()
  ;
  ((self.ui).ani_root):Play()
  self._sectorLevelData = sectorLevelData
  if (self._sectorLevelData):GetIsBattle() then
    self:__RefreshStage()
  else
    self:__RefreshAvg()
  end
end

UINActSum22MapSelected.__RefreshStage = function(self)
  -- function num : 0_2 , upvalues : _ENV, SectorStageDetailHelper
  local isSideStage = (self._sectorLevelData):GetSectroIILevelIsSide()
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Title).text = (self._sectorLevelData):GetLevelTitle()
  local stageCfg = (self._sectorLevelData):GetLevelEpStageCfg()
  if isSideStage then
    ((self.ui).tex_SubTitle):SetIndex(2, tostring(stageCfg.num))
  else
    ;
    ((self.ui).tex_SubTitle):SetIndex(0, tostring(stageCfg.num))
  end
  local total, count = (self._sectorLevelData):GetSectorIILevelChallengeTaskNum()
  if total or 0 > 0 then
    (((self.ui).challenge).gameObject):SetActive(true)
    local vec = ((self.ui).challenge).sizeDelta
    vec.x = self._starDefaultWidth * total
    -- DECOMPILER ERROR at PC53: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).challenge).sizeDelta = vec
    vec = ((self.ui).img_ChallengeCur).sizeDelta
    vec.x = self._starDefaultWidth * count
    -- DECOMPILER ERROR at PC62: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).img_ChallengeCur).sizeDelta = vec
  else
    do
      ;
      (((self.ui).challenge).gameObject):SetActive(false)
      local playMoudle = (SectorStageDetailHelper.SectorPlayMoudle)(stageCfg.sector)
      local has, unCompletestageId = (SectorStageDetailHelper.HasUnCompleteStage)(playMoudle)
      ;
      ((self.ui).unComplete):SetActive(not has or unCompletestageId == (self._sectorLevelData):GetLevelSageId())
      -- DECOMPILER ERROR: 2 unprocessed JMP targets
    end
  end
end

UINActSum22MapSelected.__RefreshAvg = function(self)
  -- function num : 0_3 , upvalues : _ENV
  ((self.ui).unComplete):SetActive(false)
  ;
  (((self.ui).challenge).gameObject):SetActive(false)
  local avgCfg = (self._sectorLevelData):GetLevelAvgCfg()
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Title).text = (LanguageUtil.GetLocaleText)(avgCfg.name)
  ;
  ((self.ui).tex_SubTitle):SetIndex(1, tostring(avgCfg.number))
end

return UINActSum22MapSelected

