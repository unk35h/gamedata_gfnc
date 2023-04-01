-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityHeroGrow.UI.UINCharaDungeonBase")
local UINCharDunMillau = class("UINCharDunMillau", base)
local HeroCubismInteration = require("Game.Hero.Live2D.HeroCubismInteration")
UINCharDunMillau.OnInit = function(self)
  -- function num : 0_0 , upvalues : base
  (base.OnInit)(self)
  self.heroID = 1054
  self.skinID = 305400
  self:_LoadLive2D()
end

UINCharDunMillau._LoadLive2D = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local skinCfg = (ConfigData.skin)[self.skinID]
  if skinCfg == nil then
    error("skinCfg is NIL")
    return 
  end
  local resName = skinCfg.src_id_pic
  self.resLoader = ((CS.ResLoader).Create)()
  ;
  (self.resLoader):LoadABAssetAsync(PathConsts:GetCharacterBigImgPrefabPath(resName), function(prefab)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if IsNull(prefab) then
      return 
    end
    self.bigImgGameObject = prefab:Instantiate()
    ;
    ((self.bigImgGameObject).transform):SetParent(((self.ui).picHolder).transform)
    ;
    ((self.bigImgGameObject).transform):SetLayer(LayerMask.UI)
    local commonPicCtrl = (self.bigImgGameObject):FindComponent(eUnityComponentID.CommonPicController)
    commonPicCtrl:SetPosType("CharDun")
  end
)
end

return UINCharDunMillau

