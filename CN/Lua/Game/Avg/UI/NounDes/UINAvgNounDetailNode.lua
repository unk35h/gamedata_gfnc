-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAvgNounDetailNode = class("UINAvgNounDetailNode", UIBaseNode)
local base = UIBaseNode
local CS_ResLoader = CS.ResLoader
UINAvgNounDetailNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_expand, self, self.ExpandAvgNoun)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Unfold, self, self.OnBtnUnflodClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Fold, self, self.OnBtnFlodClick)
  self.height = ((self.transform).sizeDelta).y
end

UINAvgNounDetailNode.InitInfo = function(self, nounId)
  -- function num : 0_1 , upvalues : _ENV, CS_ResLoader
  self.nounCfg = (ConfigData.noun_des)[nounId]
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Title).text = (LanguageUtil.GetLocaleText)((self.nounCfg).name)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Content).text = (LanguageUtil.GetLocaleText)((self.nounCfg).des)
  if (string.IsNullOrEmpty)((self.nounCfg).picture) == false then
    ((self.ui).obj_pic):SetActive(true)
    if self.resloader ~= nil then
      (self.resloader):Put2Pool()
      self.resloader = nil
    end
    -- DECOMPILER ERROR at PC49: Confused about usage of register: R2 in 'UnsetPending'

    if (self.nounCfg).picture_type ~= nil and (self.nounCfg).picture_type == 0 then
      ((self.ui).Layout_pic).minHeight = 524
    else
      -- DECOMPILER ERROR at PC57: Confused about usage of register: R2 in 'UnsetPending'

      if (self.nounCfg).picture_type == 1 then
        ((self.ui).Layout_pic).minHeight = 396
      end
    end
    self.resloader = (CS_ResLoader.Create)()
    ;
    (self.resloader):LoadABAssetAsync(PathConsts:GetAvgNounImgPath((self.nounCfg).picture), function(texture)
    -- function num : 0_1_0 , upvalues : self
    -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

    ((self.ui).img_Pic).texture = texture
  end
)
  else
    ;
    ((self.ui).obj_pic):SetActive(false)
  end
  ;
  ((self.ui).scroll):StopMovement()
  -- DECOMPILER ERROR at PC85: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.ui).scroll).content).anchoredPosition = Vector2.zero
end

UINAvgNounDetailNode.ExpandAvgNoun = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local avgnounwindow = UIManager:GetWindow(UIWindowTypeID.AvgNounDes)
  avgnounwindow:OnClickExpand()
  ;
  (((self.ui).btn_expand).gameObject):SetActive(false)
end

UINAvgNounDetailNode.OnBtnUnflodClick = function(self)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  (self.transform).sizeDelta = (Vector2.New)((self.ui).int_unFold, self.height)
  self:_ShowFlodBtnActive(true)
end

UINAvgNounDetailNode.OnBtnFlodClick = function(self)
  -- function num : 0_4 , upvalues : _ENV
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  (self.transform).sizeDelta = (Vector2.New)((self.ui).int_fold, self.height)
  self:_ShowFlodBtnActive(false)
end

UINAvgNounDetailNode._ShowFlodBtnActive = function(self, isFlod)
  -- function num : 0_5
  (((self.ui).btn_Unfold).gameObject):SetActive(not isFlod)
  ;
  (((self.ui).btn_Fold).gameObject):SetActive(isFlod)
end

UINAvgNounDetailNode.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UINAvgNounDetailNode

