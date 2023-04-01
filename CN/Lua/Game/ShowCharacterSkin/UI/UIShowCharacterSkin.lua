-- params : ...
-- function num : 0 , upvalues : _ENV
local UIShowCharacterSkin = class("UIShowCharacterSkin", UIBaseWindow)
local base = UIBaseWindow
local UINBtnCharacterAction = require("Game.ShowCharacterSkin.UI.UINBtnCharacterAction")
UIShowCharacterSkin.OnShow = function(self)
  -- function num : 0_0
end

UIShowCharacterSkin.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV, UINBtnCharacterAction
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._itemPool = (UIItemPool.New)(UINBtnCharacterAction, (self.ui).btn_House)
  ;
  ((self.ui).btn_House):SetActive(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SwitchHouse, self, self.OnClickSwitch)
end

UIShowCharacterSkin.InitShowCharacterSkin = function(self, showCharacterSkinController)
  -- function num : 0_2 , upvalues : _ENV
  self.showCharacterSkinController = showCharacterSkinController
  self.animationIdList = (self.showCharacterSkinController):GetAnimationIdList()
  ;
  (UIUtil.SetTopStatus)(self, self.OnClickBack)
  ;
  (UIUtil.SetTopOnlyShowReturn)(true)
  ;
  (self._itemPool):HideAll()
  for i,animationInfo in pairs(self.animationIdList) do
    local item = (self._itemPool):GetOne()
    item:InitShowCharacterSkin(i, animationInfo.tipId, function(index)
    -- function num : 0_2_0 , upvalues : self
    if not self.isPlayingId or self.isPlayingId ~= index then
      (self.showCharacterSkinController):PlayAnimationByIndex(index)
    end
  end
)
  end
end

UIShowCharacterSkin.SetTopText = function(self, index)
  -- function num : 0_3 , upvalues : _ENV
  self.isPlayingId = index
  local tipId = ((self.animationIdList)[index]).tipId
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).topTex_Name).text = (LanguageUtil.GetLocaleText)(ConfigData:GetTipContent(tipId))
end

UIShowCharacterSkin.OnClickBack = function(self)
  -- function num : 0_4
  (self.showCharacterSkinController):ExitShowCharacter()
  self:OnCloseWin()
end

UIShowCharacterSkin.OnClickSwitch = function(self)
  -- function num : 0_5 , upvalues : _ENV
  ((self.ui).switchBtnList):SetActive(not ((self.ui).switchBtnList).activeSelf)
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R1 in 'UnsetPending'

  if not ((self.ui).switchBtnList).activeSelf or not (Vector3.Temp)(0, 0, 180) then
    ((self.ui).img_Arrow).localEulerAngles = Vector3.zero
  end
end

UIShowCharacterSkin.OnDelete = function(self)
  -- function num : 0_6
end

return UIShowCharacterSkin

