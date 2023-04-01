-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINActLbInteract = class("UINActLbInteract", base)
local UINActLbInteractItem = require("Game.ActivityLobby.UI.Main.Interact.UINActLbInteractItem")
local cs_Tweening = (CS.DG).Tweening
local cs_Ease = cs_Tweening.Ease
local cs_DoTween = cs_Tweening.DOTween
UINActLbInteract.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINActLbInteractItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._interactList = (UIItemPool.New)(UINActLbInteractItem, (self.ui).intractItem, false)
  self._resLoader = ((CS.ResLoader).Create)()
  local atlasPath = PathConsts:GetSpriteAtlasPath("UI_ActivityLobbyMain")
  self._iconAtlas = (self._resLoader):LoadABAsset(atlasPath)
end

UINActLbInteract.UpdateLbInteractList = function(self, interActionList)
  -- function num : 0_1 , upvalues : _ENV, cs_DoTween, cs_Ease
  (self._interactList):HideAll()
  for _,interAction in pairs(interActionList) do
    local interactItem = (self._interactList):GetOne()
    interactItem:InitActLbInteractItem(interAction, self._iconAtlas)
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (interactItem.gameObject).name = "interactItem_" .. tostring(interAction:GetLbIntrctActionId())
  end
  if self._listCount == #interActionList then
    return 
  end
  if #interActionList ~= 0 then
    if self._listSeq ~= nil then
      (self._listSeq):Restart()
    else
      -- DECOMPILER ERROR at PC44: Confused about usage of register: R2 in 'UnsetPending'

      ;
      (((self.ui).fade_List).transform).localScale = Vector3.one
      -- DECOMPILER ERROR at PC47: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.ui).fade_List).alpha = 1
      local listSeq = (cs_DoTween.Sequence)()
      listSeq:Append((((((self.ui).fade_List).transform):DOScale((Vector3.New)(0.98, 0.98, 1), 0.95)):From()):SetEase(cs_Ease.OutElastic))
      listSeq:Join((((self.ui).fade_List):DOFade(0.6, 0.25)):From())
      listSeq:SetAutoKill(false)
      self._listSeq = listSeq
    end
    do
      AudioManager:PlayAudioById(1275)
      self._listCount = #interActionList
    end
  end
end

UINActLbInteract.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  if self._resLoader ~= nil then
    (self._resLoader):Put2Pool()
    self._resLoader = nil
  end
  if self._listSeq ~= nil then
    (self._listSeq):Kill()
    self._listSeq = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINActLbInteract

