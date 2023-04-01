-- params : ...
-- function num : 0 , upvalues : _ENV
local UINReHolderStyleNormal = class("UINReHolderStyleNormal", UIBaseNode)
local base = UIBaseNode
UINReHolderStyleNormal.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  if (self.ui).btn_ShowCharacter ~= nil then
    (UIUtil.AddButtonListener)((self.ui).btn_ShowCharacter, self, self._OnClickShowRoleModel)
  end
end

UINReHolderStyleNormal.InitReHolderStyle = function(self, passCfg, resloader)
  -- function num : 0_1 , upvalues : _ENV
  local skinId = passCfg.banner_skin
  local skinCfg = (ConfigData.skin)[skinId]
  local heroCfg = (ConfigData.hero_data)[skinCfg.heroId]
  local themCfg = (ConfigData.skinTheme)[skinCfg.theme]
  local campCfg = (ConfigData.camp)[heroCfg.camp]
  self._heroId = skinCfg.heroId
  self._skinId = skinId
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).img_Camp).sprite = CRH:GetSprite(campCfg.icon, CommonAtlasType.CareerCamp)
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_SkinName).text = (LanguageUtil.GetLocaleText)(skinCfg.name)
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(heroCfg.name)
  ;
  ((self.ui).tex_Series):SetIndex(0, (LanguageUtil.GetLocaleText)(themCfg.name))
  local path = PathConsts:GetCharacterBigImgPrefabPath(skinCfg.src_id_pic)
  resloader:LoadABAssetAsync(path, function(prefab)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if IsNull(prefab) or IsNull(self.transform) then
      return 
    end
    self.bigImgGameObject = prefab:Instantiate(((self.ui).heroHolder).transform)
    local commonPicCtrl = (self.bigImgGameObject):FindComponent(eUnityComponentID.CommonPicController)
    commonPicCtrl:SetPosType("BpPurchase")
  end
)
end

UINReHolderStyleNormal._OnClickShowRoleModel = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self._heroId == nil then
    return 
  end
  local showCharacterSkinCtrl = ControllerManager:GetController(ControllerTypeId.ShowCharacterSkin, true)
  showCharacterSkinCtrl:InitShowCharacterSkinCtrl(self._heroId, self._skinId, nil, nil)
end

return UINReHolderStyleNormal

