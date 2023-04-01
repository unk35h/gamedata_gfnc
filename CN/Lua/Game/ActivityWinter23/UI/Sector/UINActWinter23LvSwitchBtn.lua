-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActWinter23LvSwitchBtn = class("UINActWinter23LvSwitchBtn", UIBaseNode)
local base = UIBaseNode
local cs_DoTween = ((CS.DG).Tweening).DOTween
local bgPictureDic = {"Activity/Winter23/UI_Winter23SelectNormalBg.png", "Activity/Winter23/UI_Winter23SelectHardBg.png"}
UINActWinter23LvSwitchBtn.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickWinter23Lv)
end

UINActWinter23LvSwitchBtn.InitWinter23LvBtn = function(self, diffIdx, diffCfg, resloader, callback)
  -- function num : 0_1
  self.index = diffIdx
  self.callback = callback
  self.cfg = diffCfg
  self.resloader = resloader
  self:_InitUI(diffIdx, diffCfg)
  self:SetWinter23LvState(false)
end

UINActWinter23LvSwitchBtn.SetWinter23LvState = function(self, flag)
  -- function num : 0_2
  if flag == self._flag then
    return 
  end
  self._flag = flag
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).item_group).alpha = flag and 1 or 0.3
end

UINActWinter23LvSwitchBtn._InitUI = function(self, diffIdx, diffCfg)
  -- function num : 0_3 , upvalues : _ENV, bgPictureDic
  local index = diffIdx - 1
  ;
  ((self.ui).img_Icon):SetIndex(diffCfg.difficulty_id - 1)
  local path = PathConsts:GetResImagePath(bgPictureDic[diffCfg.difficulty_id])
  ;
  (self.resloader):LoadABAssetAsync(path, function(texture)
    -- function num : 0_3_0 , upvalues : _ENV, self
    if IsNull(self.transform) or IsNull(texture) then
      return 
    end
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Bottom).texture = texture
  end
)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Mode).text = (LanguageUtil.GetLocaleText)(diffCfg.difficulty_name_en)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_TitleName).text = (LanguageUtil.GetLocaleText)(diffCfg.difficulty_name)
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)(diffCfg.difficulty_desc)
end

UINActWinter23LvSwitchBtn.OnClickWinter23Lv = function(self)
  -- function num : 0_4
  if self.callback ~= nil then
    (self.callback)(self.index)
  end
end

UINActWinter23LvSwitchBtn.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UINActWinter23LvSwitchBtn

