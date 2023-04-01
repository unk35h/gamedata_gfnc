-- params : ...
-- function num : 0 , upvalues : _ENV
local CommonResHelper = {}
local AtlasResName = {"CommonIcon", "CompanyCareer", "ExplorationIcon", "SkillIcon", "BaseItemQuality", "HeroHeadIcon"}
CommonResHelper.Init = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self._resloader = ((CS.ResLoader).Create)()
  self._commonAtlas = {}
  self._baseItemFx = {}
end

CommonResHelper.LoadCommonAtlas = function(self, cs_DownloadWindow, progress)
  -- function num : 0_1 , upvalues : AtlasResName, _ENV
  local atlasCount = #AtlasResName
  local atlasProgress = progress / atlasCount
  local maxProgress = cs_DownloadWindow:GetCurrentProgress() + progress
  for index,resName in ipairs(AtlasResName) do
    local atlasWait = (self._resloader):LoadABAssetAsyncAwait(PathConsts:GetSpriteAtlasPath(resName))
    ;
    (coroutine.yield)(atlasWait)
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R12 in 'UnsetPending'

    ;
    (self._commonAtlas)[index - 1] = atlasWait.Result
    cs_DownloadWindow:AddProgress(atlasProgress, progress)
  end
  self.atlasCount = (table.count)(self._commonAtlas)
end

CommonResHelper.GetSprite = function(self, spriteName, atlasType)
  -- function num : 0_2 , upvalues : _ENV
  if atlasType == nil or type(atlasType) ~= "number" then
    atlasType = 0
  end
  local atlas = (self._commonAtlas)[atlasType]
  if self.atlasCount <= atlasType or IsNull(atlas) then
    return nil
  end
  local sp = (AtlasUtil.GetResldSprite)(atlas, spriteName)
  return sp
end

CommonResHelper.GetSpriteByItemConfig = function(self, itemCfg, isSmall)
  -- function num : 0_3 , upvalues : _ENV
  if itemCfg == nil then
    return nil
  end
  if itemCfg.type == eItemType.Avatar or itemCfg.type == eItemType.Skin or itemCfg.type == eItemType.AvatarFrame or itemCfg.action_type == eItemActionType.HeroCardFrag or itemCfg.action_type == eItemActionType.HeroCard then
    return CRH:GetSprite(itemCfg.icon, CommonAtlasType.HeroHeadIcon)
  else
    if not isSmall or not itemCfg.small_icon then
      local icon = itemCfg.icon
    end
    return CRH:GetSprite(icon)
  end
end

CommonResHelper.GetSpriteByItemId = function(self, itemId, isSmall)
  -- function num : 0_4 , upvalues : _ENV
  if itemId or 0 == 0 then
    return nil
  end
  return self:GetSpriteByItemConfig((ConfigData.item)[itemId], isSmall)
end

CommonResHelper.GetHeroSkinSprite = function(self, heroId, skinId)
  -- function num : 0_5 , upvalues : _ENV
  local resName = nil
  local id = skinId or 0
  do
    if id ~= 0 then
      local skinCfg = (ConfigData.skin)[id]
      if skinCfg ~= nil and not (string.IsNullOrEmpty)(skinCfg.src_id_icon) then
        return CRH:GetSprite(skinCfg.src_id_icon, CommonAtlasType.HeroHeadIcon)
      end
    end
    local heroCfg = (ConfigData.hero_data)[heroId]
    do
      if heroCfg ~= nil and heroCfg.fragment ~= nil then
        local itemCfg = (ConfigData.item)[heroCfg.fragment]
        if itemCfg ~= nil then
          return CRH:GetSprite(itemCfg.icon, CommonAtlasType.HeroHeadIcon)
        end
      end
      return nil
    end
  end
end

CommonResHelper.LoadBaseItemFx = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local path = ItemEffPatch.greetLoop
  ;
  (self._resloader):LoadABAssetAsync(path, function(prefab)
    -- function num : 0_6_0 , upvalues : self
    -- DECOMPILER ERROR at PC1: Confused about usage of register: R1 in 'UnsetPending'

    (self._baseItemFx).greetLoop = prefab
  end
)
end

CommonResHelper.GetBaseItemFx = function(self)
  -- function num : 0_7
  return self._baseItemFx
end

CommonResHelper.GetDefaultKeySprite = function(self, itemID, isSmall)
  -- function num : 0_8 , upvalues : _ENV
  if isSmall == nil then
    isSmall = true
  end
  if not itemID then
    local ticketID = ConstGlobalItem.SKey
  end
  local costItemCfg = (ConfigData.item)[ticketID]
  return CRH:GetSpriteByItemConfig(costItemCfg, true)
end

return CommonResHelper

