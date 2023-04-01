-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActWinter23ChapterBtn = class("UINActWinter23ChapterBtn", UIBaseNode)
local base = UIBaseNode
local cs_DoTween = ((CS.DG).Tweening).DOTween
local ActivityWinter23Enum = require("Game.ActivityWinter23.Data.ActivityWinter23Enum")
UINActWinter23ChapterBtn.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickWinter23Lv)
end

UINActWinter23ChapterBtn.InitWinter23LvBtn = function(self, modeId, callback)
  -- function num : 0_1
  self.modeId = modeId
  self.callback = callback
  self:_InitUI(self.modeId)
end

UINActWinter23ChapterBtn._InitUI = function(self, modeId)
  -- function num : 0_2 , upvalues : ActivityWinter23Enum, _ENV
  if modeId == (ActivityWinter23Enum.levelSelectButtonType).mainButton then
    ((self.ui).img_LIcon):SetIndex(1)
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_Line).color = ((self.ui).Line_color)[2]
    ;
    ((self.ui).tex_CNName):SetIndex(1)
    ;
    ((self.ui).img_RIcon):SetIndex(1)
    -- DECOMPILER ERROR at PC34: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).img_RIcon).transform).localEulerAngles = (Vector3.Temp)(0, 0, 0)
    ;
    ((self.ui).tex_ENName):SetIndex(0)
  else
    if modeId == (ActivityWinter23Enum.levelSelectButtonType).repeatButton then
      ((self.ui).img_LIcon):SetIndex(0)
      -- DECOMPILER ERROR at PC55: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.ui).img_Line).color = ((self.ui).Line_color)[1]
      ;
      ((self.ui).tex_CNName):SetIndex(0)
      ;
      ((self.ui).img_RIcon):SetIndex(1)
      -- DECOMPILER ERROR at PC75: Confused about usage of register: R2 in 'UnsetPending'

      ;
      (((self.ui).img_RIcon).transform).localEulerAngles = (Vector3.Temp)(0, 0, 180)
      ;
      ((self.ui).tex_ENName):SetIndex(0)
    else
      if modeId == (ActivityWinter23Enum.levelSelectButtonType).normalDiffButton then
        ((self.ui).img_LIcon):SetIndex(2)
        -- DECOMPILER ERROR at PC96: Confused about usage of register: R2 in 'UnsetPending'

        ;
        ((self.ui).img_Line).color = ((self.ui).Line_color)[4]
        ;
        ((self.ui).tex_CNName):SetIndex(2)
        ;
        ((self.ui).img_RIcon):SetIndex(0)
        ;
        ((self.ui).tex_ENName):SetIndex(1)
      else
        if modeId == (ActivityWinter23Enum.levelSelectButtonType).hardDiffButton then
          ((self.ui).img_LIcon):SetIndex(3)
          -- DECOMPILER ERROR at PC127: Confused about usage of register: R2 in 'UnsetPending'

          ;
          ((self.ui).img_Line).color = ((self.ui).Line_color)[3]
          ;
          ((self.ui).tex_CNName):SetIndex(3)
          ;
          ((self.ui).img_RIcon):SetIndex(0)
          ;
          ((self.ui).tex_ENName):SetIndex(1)
        end
      end
    end
  end
end

UINActWinter23ChapterBtn.OnClickWinter23Lv = function(self)
  -- function num : 0_3
  if self.callback ~= nil then
    (self.callback)(self.modeId)
  end
end

UINActWinter23ChapterBtn.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINActWinter23ChapterBtn

