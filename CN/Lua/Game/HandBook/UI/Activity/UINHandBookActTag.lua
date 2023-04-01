-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHandBookActTag = class("UINHandBookActTag", UIBaseNode)
local base = UIBaseNode
local CS_DOTween = ((CS.DG).Tweening).DOTween
UINHandBookActTag.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ActItem, self, self.OnClickActTag)
end

UINHandBookActTag.InitHandBookActTag = function(self, name, callback)
  -- function num : 0_1
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).tex_ActName).text = name
  self._callback = callback
end

UINHandBookActTag.PlayBookTagAni = function(self, delayTime)
  -- function num : 0_2 , upvalues : CS_DOTween
  if self._tween ~= nil then
    (self._tween):Kill()
    self._tween = nil
  end
  self._tween = (CS_DOTween.Sequence)()
  ;
  (self._tween):AppendInterval(delayTime)
  ;
  (self._tween):AppendCallback(function()
    -- function num : 0_2_0 , upvalues : self
    ((self.ui).ani_ActItem):Play()
  end
)
end

UINHandBookActTag.OnClickActTag = function(self)
  -- function num : 0_3
  if self._callback ~= nil then
    (self._callback)()
  end
end

UINHandBookActTag.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  if self._tween ~= nil then
    (self._tween):Kill()
    self._tween = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINHandBookActTag

