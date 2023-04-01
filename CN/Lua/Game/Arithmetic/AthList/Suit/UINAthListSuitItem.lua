-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAthListSuitItem = class("UINAthListSuitItem", UIBaseNode)
local base = UIBaseNode
local UINAthSuitColleItem = require("Game.Arithmetic.AthMain.UINAthSuitColleItem")
local cs_Edge = ((CS.UnityEngine).RectTransform).Edge
UINAthListSuitItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINAthSuitColleItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Root, self, self.__OnClickRoot)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ShowIntro, self, self.__OnClickShowIntro)
  ;
  ((self.ui).colleItem):SetActive(false)
  self.colleItemPool = (UIItemPool.New)(UINAthSuitColleItem, (self.ui).colleItem)
end

UINAthListSuitItem.InitAthListSuitItem = function(self, suitId, isRecommend, clickFunc, resLoader, curCount)
  -- function num : 0_1 , upvalues : _ENV
  self.suitId = suitId
  self.clickFunc = clickFunc
  local suitList = (ConfigData.ath_suit)[suitId]
  if suitList == nil then
    error("Cant find ath suitList, suitId = " .. tostring(suitId))
    return 
  end
  local suitParamCfg = ((ConfigData.ath_suit).suitParamDic)[suitId]
  self._suitParamCfg = suitParamCfg
  local iconName = suitParamCfg.icon
  ;
  (((self.ui).btn_ShowIntro).gameObject):SetActive(suitParamCfg.suit_lable_id ~= 0)
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).enabled = false
  resLoader:LoadABAssetAsync(PathConsts:GetAtlasAssetPath("AthSuitIcon"), function(spriteAtlas)
    -- function num : 0_1_0 , upvalues : self, _ENV, iconName
    if spriteAtlas == nil then
      return 
    end
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).sprite = (AtlasUtil.GetResldSprite)(spriteAtlas, iconName)
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).enabled = true
  end
)
  ;
  ((self.ui).tex_Own):SetIndex(0, tostring(curCount))
  local own = curCount > 0
  -- DECOMPILER ERROR at PC64: Confused about usage of register: R10 in 'UnsetPending'

  if not own or not (self.ui).ownColor_Tex then
    (((self.ui).tex_Own).text).color = (self.ui).notOwnColor_Tex
    -- DECOMPILER ERROR at PC75: Confused about usage of register: R10 in 'UnsetPending'

    if not own or not (self.ui).ownColor_Bg then
      ((self.ui).img_OwnBg).color = (self.ui).notOwnColor_Bg
      -- DECOMPILER ERROR at PC82: Confused about usage of register: R10 in 'UnsetPending'

      ;
      ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(suitParamCfg.name)
      ;
      ((self.ui).img_Recommend):SetActive(isRecommend)
      ;
      (self.colleItemPool):HideAll()
      local intro = nil
      for k,suitCfg in ipairs(suitList) do
        local colleItem = (self.colleItemPool):GetOne()
        colleItem:InitAthSuitColleItem(suitCfg.num)
        if intro == nil then
          intro = (LanguageUtil.GetLocaleText)(suitCfg.describe)
        else
          intro = intro .. "\n" .. (LanguageUtil.GetLocaleText)(suitCfg.describe)
        end
      end
      -- DECOMPILER ERROR at PC121: Confused about usage of register: R11 in 'UnsetPending'

      ;
      ((self.ui).tex_Intro).text = intro
      ;
      ((self.ui).obj_RateBg):SetActive(false)
      -- DECOMPILER ERROR: 8 unprocessed JMP targets
    end
  end
end

UINAthListSuitItem.ShowAthListSuitItemUsingRate = function(self, usingRate)
  -- function num : 0_2 , upvalues : _ENV
  ((self.ui).obj_RateBg):SetActive(true)
  ;
  ((self.ui).tex_Rate):SetIndex(0, GetPreciseDecimalStr(usingRate // 100, 2))
end

UINAthListSuitItem.__OnClickRoot = function(self)
  -- function num : 0_3
  if self.clickFunc ~= nil then
    (self.clickFunc)(self.suitId)
  end
end

UINAthListSuitItem.__OnClickShowIntro = function(self)
  -- function num : 0_4 , upvalues : _ENV, cs_Edge
  UIManager:ShowWindowAsync(UIWindowTypeID.RichIntro, function(win)
    -- function num : 0_4_0 , upvalues : self, cs_Edge
    if win ~= nil then
      win:ShowIntroLabelList((self.ui).suitIntroHolder, {(self._suitParamCfg).suit_lable_id})
      win:SetIntroListPosition(cs_Edge.Left, cs_Edge.Top)
    end
  end
)
end

UINAthListSuitItem.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (self.colleItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINAthListSuitItem

