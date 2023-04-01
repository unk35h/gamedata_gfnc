-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWarChessMonsterPicItem = class("UINWarChessMonsterPicItem", UIBaseNode)
local base = UIBaseNode
UINWarChessMonsterPicItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Select, self, self.OnBtnSelected)
  self.originTexture = ((self.ui).img_EnemyPic).texture
end

UINWarChessMonsterPicItem.InitItem = function(self, monsterCfg, resloader, onClickCallback)
  -- function num : 0_1 , upvalues : _ENV
  if monsterCfg == nil then
    return 
  end
  self.monsterCfg = monsterCfg
  self._onClickCallback = onClickCallback
  local resId = monsterCfg.src_id
  if resId == self.__cacheResId then
    return 
  end
  local resCfg = (ConfigData.resource_model)[resId]
  self.__cacheResId = resId
  if resCfg ~= nil then
    local path = PathConsts:GetCharacterSmallPicPath(resCfg.res_Name)
    resloader:LoadABAssetAsync(path, function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

    if texture ~= nil and not IsNull(self.gameObject) then
      ((self.ui).img_EnemyPic).texture = texture
    end
  end
)
  end
end

UINWarChessMonsterPicItem.InitMapItem = function(self, onClickCallback)
  -- function num : 0_2
  self._onClickCallback = onClickCallback
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_EnemyPic).texture = self.originTexture
end

UINWarChessMonsterPicItem.SetItemSelect = function(self, selected)
  -- function num : 0_3 , upvalues : _ENV
  if selected then
    (((self.ui).img_Select).transform):SetParent(self.transform)
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).img_Select).transform).anchoredPosition = Vector2.zero
  end
end

UINWarChessMonsterPicItem.OnBtnSelected = function(self)
  -- function num : 0_4
  if self._onClickCallback ~= nil then
    (self._onClickCallback)(self)
  end
end

UINWarChessMonsterPicItem.SetRefreshSelectUI = function(self, isOn)
  -- function num : 0_5 , upvalues : _ENV
  local index = isOn and 1 or 0
  ;
  ((self.ui).Img_Select):SetIndex(index)
  if not isOn or not Color.white then
    local nameCol = Color.black
  end
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_SkillName).color = nameCol
  if not isOn or not (self.ui).col_DescWhite then
    local descCol = (self.ui).col_DescBlack
  end
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_SkillDesc).color = descCol
end

UINWarChessMonsterPicItem.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  self.originTexture = nil
  ;
  (base.OnDelete)(self)
end

return UINWarChessMonsterPicItem

