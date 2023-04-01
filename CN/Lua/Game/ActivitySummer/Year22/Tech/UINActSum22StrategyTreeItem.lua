-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActSum22StrategyTreeItem = class("UINActSum22StrategyTreeItem", UIBaseNode)
local base = UIBaseNode
UINActSum22StrategyTreeItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Root, self, self._OnClickRoot)
  self:SetActSum22TechItemNew(false)
end

UINActSum22StrategyTreeItem.InitActSum22StrategyItem = function(self, techData, resloader, clickFunc)
  -- function num : 0_1 , upvalues : _ENV
  self._techData = techData
  self._clickFunc = clickFunc
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).enabled = false
  resloader:LoadABAssetAsync(PathConsts:GetAtlasAssetPath("SectorBuilding"), function(spriteAtlas)
    -- function num : 0_1_0 , upvalues : self, _ENV, techData
    if spriteAtlas == nil then
      return 
    end
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).sprite = (AtlasUtil.GetResldSprite)(spriteAtlas, techData:GetWATechIcon())
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).enabled = true
  end
)
  ;
  ((self.ui).img_Frame):SetIndex(techData:GetActTechUIFrameId())
  self:UpdActSum22TechItem()
end

UINActSum22StrategyTreeItem.UpdActSum22TechItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local curLv = (self._techData):GetCurLevel()
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R2 in 'UnsetPending'

  if (self._techData):IsActTechLevelLoop() then
    (((self.ui).tex_Lvl).text).text = tostring(curLv)
  else
    local maxLv = (self._techData):GetMaxLevel()
    ;
    ((self.ui).tex_Lvl):SetIndex(0, tostring(curLv), tostring(maxLv))
  end
  do
    self:_TryUpdLock(curLv == 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
end

UINActSum22StrategyTreeItem._TryUpdLock = function(self, lock)
  -- function num : 0_3 , upvalues : _ENV
  if IsNull((self.ui).lockBg) then
    return 
  end
  if lock then
    if IsNull(self._lockGo) then
      self._lockGo = (((self.ui).lockBg).gameObject):Instantiate(self.transform)
      -- DECOMPILER ERROR at PC25: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self._lockGo).transform).anchoredPosition = Vector2.zero
    end
    ;
    (self._lockGo):SetActive(true)
  else
    if not IsNull(self._lockGo) then
      (self._lockGo):SetActive(false)
    end
  end
end

UINActSum22StrategyTreeItem.SetActSum22TechItemNew = function(self, isNew)
  -- function num : 0_4 , upvalues : _ENV
  if IsNull((self.ui).obj_New) then
    return 
  end
  ;
  ((self.ui).obj_New):SetActive(isNew)
end

UINActSum22StrategyTreeItem.SetActSum22TechItemLvUp = function(self, isLvUp)
  -- function num : 0_5 , upvalues : _ENV
  if IsNull((self.ui).obj_LvUp) then
    return 
  end
  ;
  ((self.ui).obj_LvUp):SetActive(isLvUp)
end

UINActSum22StrategyTreeItem._OnClickRoot = function(self)
  -- function num : 0_6
  if self._clickFunc ~= nil then
    (self._clickFunc)(self, self._techData)
  end
end

return UINActSum22StrategyTreeItem

