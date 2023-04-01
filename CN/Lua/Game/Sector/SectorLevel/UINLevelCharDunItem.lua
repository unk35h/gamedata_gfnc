-- params : ...
-- function num : 0 , upvalues : _ENV
local UINLevelCharDunItem = class("UINLevelCharDunItem", UIBaseNode)
local base = UIBaseNode
UINLevelCharDunItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickStage)
end

UINLevelCharDunItem.InitCharDunSectorStage = function(self, stageId, clickEvent, seclectStateFunc, resLoader)
  -- function num : 0_1 , upvalues : _ENV
  self._stageId = stageId
  self._stageCfg = (ConfigData.sector_stage)[stageId]
  self._clickEvent = clickEvent
  self._resLoader = resLoader
  self._seclectStateFunc = seclectStateFunc
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)((self._stageCfg).name)
  ;
  ((self.ui).tex_Number):SetIndex(0, tostring((self._stageCfg).num))
  local heroGrowCtrl = (ControllerManager:GetController(ControllerTypeId.ActivityHeroGrow))
  local actHeroCfg = nil
  local actId, data = heroGrowCtrl:GetHeroGrowDataBySectorId((self._stageCfg).sector)
  if data ~= nil then
    actHeroCfg = data:GetHeroGrowCfg()
  else
    if actId ~= nil then
      actHeroCfg = (ConfigData.activity_hero)[actId]
    end
  end
  local path = PathConsts:GetCharDunPrefabPath((self._stageCfg).pic)
  if IsNull(self.bgPrefab) then
    (self._resLoader):LoadABAssetAsync(path, function(prefab)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if IsNull(prefab) or IsNull((self.ui).rect_Holder) then
      return 
    end
    self.bgPrefab = prefab:Instantiate((self.ui).rect_Holder)
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (self.transform).sizeDelta = ((self.bgPrefab).transform).sizeDelta
  end
)
  end
  local markItemCfg, strDrop = nil, nil
  do
    if actHeroCfg ~= nil then
      local markItemId = actHeroCfg.token
      markItemCfg = (ConfigData.item)[markItemId]
      strDrop = (LanguageUtil.GetLocaleText)(actHeroCfg.token_drop)
    end
    -- DECOMPILER ERROR at PC78: Confused about usage of register: R12 in 'UnsetPending'

    ;
    ((self.ui).tex_Drop).text = strDrop or ""
    if markItemCfg == nil then
      ((self.ui).imgDrop):SetActive(false)
    else
      ;
      ((self.ui).imgDrop):SetActive(true)
      -- DECOMPILER ERROR at PC98: Confused about usage of register: R12 in 'UnsetPending'

      ;
      ((self.ui).img_BigIcon).sprite = CRH:GetSprite(markItemCfg.icon)
      -- DECOMPILER ERROR at PC105: Confused about usage of register: R12 in 'UnsetPending'

      ;
      ((self.ui).img_SmallIcon).sprite = CRH:GetSprite(markItemCfg.small_icon)
      -- DECOMPILER ERROR at PC108: Confused about usage of register: R12 in 'UnsetPending'

      ;
      ((self.ui).tex_Count).text = ""
    end
    self._lastSelectState = false
    self:RefreshStageUI()
    self:SeletedLevelItem(false, false)
    self:RefreshUncompletedEp(false, false)
  end
end

UINLevelCharDunItem.RefreshStageUI = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local isunLock = (PlayerDataCenter.sectorStage):IsStageUnlock(self._stageId)
  if isunLock then
    ((self.ui).obj_Lock):SetActive(false)
    return 
  end
  ;
  ((self.ui).obj_Lock):SetActive(true)
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Condition).text = (PlayerDataCenter.sectorStage):GetGetUnlockInfo(self._stageId)
end

UINLevelCharDunItem.OnClickStage = function(self)
  -- function num : 0_3
  if self._clickEvent ~= nil then
    (self._clickEvent)(self)
  end
end

UINLevelCharDunItem.GetLevelStageData = function(self)
  -- function num : 0_4
  return self._stageCfg
end

UINLevelCharDunItem.IsLevelUnlock = function(self)
  -- function num : 0_5 , upvalues : _ENV
  return (PlayerDataCenter.sectorStage):IsStageUnlock(self._stageId)
end

UINLevelCharDunItem.SeletedLevelItem = function(self, select, withTween)
  -- function num : 0_6
  if self._seclectStateFunc ~= nil and select ~= self._lastSelectState then
    (self._seclectStateFunc)(self, select, self._lastSelectState)
  end
  self._lastSelectState = select
end

UINLevelCharDunItem.RefreshUncompletedEp = function(self, flag)
  -- function num : 0_7
end

UINLevelCharDunItem.SetBluedot = function(self, show)
  -- function num : 0_8
  ((self.ui).blueDot):SetActive(show)
end

UINLevelCharDunItem.OnDelete = function(self)
  -- function num : 0_9 , upvalues : _ENV, base
  if not IsNull(self.bgPrefab) then
    DestroyUnityObject(self.bgPrefab)
  end
  ;
  (base.OnDelete)(self)
end

return UINLevelCharDunItem

