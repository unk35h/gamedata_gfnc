-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWAMMMapLineItem = class("UINWAMMMapLineItem", UIBaseNode)
local base = UIBaseNode
UINWAMMMapLineItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWAMMMapLineItem.InitWAMMMapLine = function(self, startPos, endPos)
  -- function num : 0_1 , upvalues : _ENV
  local length, angle, dirVector = nil, nil, nil
  length = (Vector2.Distance)(startPos, endPos)
  dirVector = endPos - startPos
  angle = (Vector2.Angle)(Vector2.right, dirVector)
  angle = angle * (((Vector3.Cross)(Vector3.right, (Vector3.New)(dirVector.x, dirVector.y, 0))).z > 0 and 1 or -1)
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.transform).anchoredPosition = startPos
  -- DECOMPILER ERROR at PC43: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.transform).localEulerAngles = (Vector3.New)(0, 0, angle)
  -- DECOMPILER ERROR at PC52: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.transform).sizeDelta = (Vector2.New)(length, ((self.transform).sizeDelta).y)
  self.length = length
end

UINWAMMMapLineItem.SwitchLine2DottedLine = function(self)
  -- function num : 0_2
  ((self.ui).obj_img_Line):SetActive(false)
  ;
  ((self.ui).obj_img_PipeLine):SetActive(true)
end

UINWAMMMapLineItem.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINWAMMMapLineItem

