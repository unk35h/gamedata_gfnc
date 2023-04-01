-- params : ...
-- function num : 0 , upvalues : _ENV
local UIATHSuitDetailNode = class("UIATHSuitDetailNode", UIBaseNode)
local base = UIBaseNode
local UINAthSuitColleItem = require("Game.Arithmetic.AthMain.UINAthSuitColleItem")
UIATHSuitDetailNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINAthSuitColleItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.SuitItemPool = (UIItemPool.New)(UINAthSuitColleItem, (self.ui).colleItem, false)
  ;
  (UIUtil.AddButtonListener)((self.ui).obj_SuitEffectBg, self, self.OnClicKClose)
end

UIATHSuitDetailNode.InitSuitDetailNode = function(self, suitId, resLoader)
  -- function num : 0_1 , upvalues : _ENV
  self.suitId = suitId
  self.resLoader = resLoader
  local suitParamCfg = ((ConfigData.ath_suit).suitParamDic)[self.suitId]
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

  if suitParamCfg ~= nil then
    ((self.ui).tex_SuitName).text = (LanguageUtil.GetLocaleText)(suitParamCfg.name)
    ;
    (self.resLoader):LoadABAssetAsync(PathConsts:GetAtlasAssetPath("AthSuitIcon"), function(spriteAtlas)
    -- function num : 0_1_0 , upvalues : self, _ENV, suitParamCfg
    if spriteAtlas == nil then
      return 
    end
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_SuitIcon).sprite = (AtlasUtil.GetResldSprite)(spriteAtlas, suitParamCfg.icon)
  end
)
  end
  ;
  (self.SuitItemPool):HideAll()
  local intro = nil
  for _,cfg in pairs((ConfigData.ath_suit)[self.suitId]) do
    local item = (self.SuitItemPool):GetOne()
    item:InitAthSuitColleItem(cfg.num)
    if intro == nil then
      intro = (LanguageUtil.GetLocaleText)(cfg.describe)
    else
      intro = intro .. "\n" .. (LanguageUtil.GetLocaleText)(cfg.describe)
    end
  end
  -- DECOMPILER ERROR at PC60: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Intro).text = intro
end

UIATHSuitDetailNode.SetCoulClickThroughGos = function(self, list)
  -- function num : 0_2 , upvalues : _ENV
  local goList = {}
  for key,value in pairs(list) do
    (table.insert)(goList, value.gameObject)
  end
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).obj_SuitEffectBg).m_throughTargets = goList
end

UIATHSuitDetailNode.OnClicKClose = function(self)
  -- function num : 0_3
  self:Hide()
end

UIATHSuitDetailNode.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (self.SuitItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UIATHSuitDetailNode

