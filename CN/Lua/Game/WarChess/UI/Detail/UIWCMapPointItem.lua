-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWCMapPointItem = class("UIWCMapPointItem", UIBaseNode)
local base = UIBaseNode
UIWCMapPointItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self:HideCareerIcon()
end

UIWCMapPointItem.GetSizeDelta = function(self)
  -- function num : 0_1
  return ((self.ui).rect_mapPoint).sizeDelta
end

UIWCMapPointItem.SetLocalPos = function(self, x, y)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).rect_mapPoint).localPosition = (Vector2.New)(x, y)
end

UIWCMapPointItem.SetImgItemInfo = function(self, index)
  -- function num : 0_3
  ((self.ui).uiItem_mapPoint):SetIndex(index)
end

UIWCMapPointItem.SetImgCareer = function(self, monsterCfg)
  -- function num : 0_4 , upvalues : _ENV
  if not monsterCfg then
    self:HideCareerIcon()
  end
  local careerId = monsterCfg.career
  local careerCfg = (ConfigData.career)[careerId]
  if careerCfg == nil then
    error("Can\'t find careerCfg, campId = " .. tostring(careerId))
  else
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).img_career).sprite = CRH:GetSprite(careerCfg.icon, CommonAtlasType.CareerCamp)
    ;
    (((self.ui).img_career).gameObject):SetActive(true)
    self.careerIconActive = true
  end
end

UIWCMapPointItem.HideCareerIcon = function(self)
  -- function num : 0_5
  if self.careerIconActive == nil or self.careerIconActive then
    (((self.ui).img_career).gameObject):SetActive(false)
    self.careerIconActive = false
  end
end

UIWCMapPointItem.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UIWCMapPointItem

