-- params : ...
-- function num : 0 , upvalues : _ENV
local UINGuidePicture_0623NewItem = class("UINGuidePicture_0623NewItem", UIBaseNode)
local UINGuidePicture_0623NewDesItem = require("Game.Guide.GuidePicture.UINGuidePicture_0623NewDesItem")
UINGuidePicture_0623NewItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINGuidePicture_0623NewDesItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.desItemPool = (UIItemPool.New)(UINGuidePicture_0623NewDesItem, (self.ui).obj_tex_Des)
  ;
  ((self.ui).obj_tex_Des):SetActive(false)
end

UINGuidePicture_0623NewItem.InitPictureItemBase = function(self, deslist, index, title)
  -- function num : 0_1 , upvalues : _ENV
  self.index = index
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Title).text = (LanguageUtil.GetLocaleText)(title)
  if deslist == nil then
    (self.desItemPool):HideAll()
    return 
  end
  ;
  (self.desItemPool):HideAll()
  for order,desCfg in ipairs(deslist) do
    local desItem = (self.desItemPool):GetOne()
    desItem:InitGPNewDesItem(desCfg)
  end
end

UINGuidePicture_0623NewItem.InitPictureItem = function(self, deslist, index, title, resPath, resloader)
  -- function num : 0_2 , upvalues : _ENV
  self:InitPictureItemBase(deslist, index, title)
  resloader:LoadABAssetAsync(resPath, function(picture)
    -- function num : 0_2_0 , upvalues : _ENV, self, index
    if IsNull(picture) then
      return 
    end
    if self.index ~= index then
      return 
    end
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Pic).texture = picture
  end
)
end

UINGuidePicture_0623NewItem.PlayGuideVedio = function(self, vedioPath, moivePlayer)
  -- function num : 0_3
  if moivePlayer == nil then
    return 
  end
  moivePlayer:SetVideoRender((self.ui).img_Pic)
  moivePlayer:PlayVideo(vedioPath, nil, 1, true)
end

return UINGuidePicture_0623NewItem

