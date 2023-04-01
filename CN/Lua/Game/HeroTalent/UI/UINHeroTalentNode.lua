-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHeroTalentNode = class("UINHeroTalentNode", UIBaseNode)
local base = UIBaseNode
UINHeroTalentNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Item, self, self.OnClickTalentItem)
  self._defaultColor = (((self.ui).buttom).image).color
  self._maxColor = self._defaultColor
end

UINHeroTalentNode.SetTalentMaxColor = function(self, color)
  -- function num : 0_1
  self._maxColor = color
end

UINHeroTalentNode.InitHeroTalentNode = function(self, heroTalentNode, clickCallback)
  -- function num : 0_2 , upvalues : _ENV
  self._heroTalentNode = heroTalentNode
  self._clickCallback = clickCallback
  local effect = (self._heroTalentNode):GetHeroTalentNodeCurLevelEffect()
  if effect == nil then
    effect = (self._heroTalentNode):GetHeroTalentNodeNexLevelEffect()
  end
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R4 in 'UnsetPending'

  if effect ~= nil then
    ((self.ui).img_Icon).sprite = CRH:GetSprite(effect.icon)
  end
  self:RefreshHeroTalentNodeUI()
end

UINHeroTalentNode.RefreshHeroTalentNodeUI = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local curLv = (self._heroTalentNode):GetHeroTalentNodeCurLevel()
  local maxLv = (self._heroTalentNode):GetHeroTalentNodeMaxLevel()
  local isUnlock = (self._heroTalentNode):IsHeroTalentNodeUnlock()
  local isMaxLv = (self._heroTalentNode):IsHeroTalentNodeMaxLevel()
  if not isMaxLv or not (self.ui).maxColor then
    local color = Color.white
  end
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R6 in 'UnsetPending'

  if not IsNull((self.ui).tex_Count) then
    ((self.ui).tex_Count).text = tostring(curLv) .. "/" .. tostring(maxLv)
  end
  ;
  ((self.ui).img_Lock):SetActive(not isUnlock)
  ;
  ((self.ui).buttom):SetIndex(isMaxLv and 1 or 0)
  -- DECOMPILER ERROR at PC61: Confused about usage of register: R6 in 'UnsetPending'

  if not isMaxLv or not self._maxColor then
    (((self.ui).buttom).image).color = self._defaultColor
  end
end

UINHeroTalentNode.OnClickTalentItem = function(self)
  -- function num : 0_4
  if self._clickCallback ~= nil then
    (self._clickCallback)(self)
  end
end

UINHeroTalentNode.GetHeroTalentNode = function(self)
  -- function num : 0_5
  return self._heroTalentNode
end

UINHeroTalentNode.GetLineTargetPoint = function(self, horizontalDir, verticalDir)
  -- function num : 0_6
  local index = 0
  if horizontalDir == 0 and verticalDir > 0 then
    index = 1
  else
    if horizontalDir > 0 and verticalDir > 0 then
      index = 2
    else
      if horizontalDir > 0 and verticalDir == 0 then
        index = 3
      else
        if horizontalDir > 0 and verticalDir < 0 then
          index = 4
        else
          if horizontalDir == 0 and verticalDir < 0 then
            index = 5
          else
            if horizontalDir < 0 and verticalDir < 0 then
              index = 6
            else
              if horizontalDir < 0 and verticalDir == 0 then
                index = 7
              else
                if horizontalDir < 0 and verticalDir > 0 then
                  index = 8
                end
              end
            end
          end
        end
      end
    end
  end
  return ((self.ui).broadPoints)[index]
end

return UINHeroTalentNode

