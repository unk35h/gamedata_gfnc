-- params : ...
-- function num : 0 , upvalues : _ENV
local UI_HBCampInfo = class("UI_HBCampInfo", UIBaseWindow)
local base = UIBaseWindow
UI_HBCampInfo.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.handBookCtrl = ControllerManager:GetController(ControllerTypeId.HandBook, true)
end

UI_HBCampInfo.InitHBCampInfo = function(self, campId, resloader, backCallback)
  -- function num : 0_1 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.__OnClickBack)
  self.backCallback = backCallback
  local name = ConfigData:GetTipContent(8303)
  ;
  (self.handBookCtrl):SetHBViewSetLayer(2, name)
  local campCfg = (ConfigData.camp)[campId]
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Camp).text = (LanguageUtil.GetLocaleText)(campCfg.name)
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_CampDescribtion).text = (LanguageUtil.GetLocaleText)(campCfg.camp_info)
  local collectRate, totalNum = (self.handBookCtrl):GetCampHeroCollectNum(campId)
  ;
  ((self.ui).tex_Count):SetIndex(0, tostring(collectRate), tostring(totalNum))
  resloader:LoadABAssetAsync(PathConsts:GetCampPicPath(campCfg.icon), function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if IsNull(self.transform) then
      return 
    end
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_CampIcon).texture = texture
  end
)
end

UI_HBCampInfo.__OnClickBack = function(self)
  -- function num : 0_2
  (self.handBookCtrl):SetHBViewSetLayer(1)
  if self.backCallback ~= nil then
    (self.backCallback)()
  end
  self:Delete()
end

UI_HBCampInfo.OnDelete = function(self)
  -- function num : 0_3
end

return UI_HBCampInfo

