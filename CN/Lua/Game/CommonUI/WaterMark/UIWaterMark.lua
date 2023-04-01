-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWaterMark = class("UIWaterMark", UIBaseWindow)
local base = UIBaseWindow
UIWaterMark.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.__permanent = true
  self.__OnScreenSizeChanged = BindCallback(self, self._OnScreenSizeChanged)
  MsgCenter:AddListener(eMsgEventId.OnScreenSizeChanged, self.__OnScreenSizeChanged)
end

UIWaterMark.SetWaterMarkUID = function(self, uid)
  -- function num : 0_1 , upvalues : _ENV
  local uidStr = tostring(uid)
  local contentStr = uidStr .. "  <color=#808080>" .. uidStr .. "</color>  "
  for i = 1, 8 do
    contentStr = contentStr .. contentStr
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_WaterMark).text = contentStr
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.ui).tex_WaterMark).transform).eulerAngles = (Vector3.New)(0, 0, -10)
  self._uidAngle = 10
  self:_UpdUIDMarkSize()
end

UIWaterMark._UpdUIDMarkSize = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local x = (UIManager.BackgroundStretchSize).x
  local y = (UIManager.BackgroundStretchSize).y
  local rad = (math.rad)(self._uidAngle)
  local cosRad = (math.cos)(rad)
  local sinRad = (math.sin)(rad)
  local width = y * sinRad + x * cosRad
  local height = y * cosRad + x * sinRad
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R8 in 'UnsetPending'

  ;
  (((self.ui).tex_WaterMark).transform).sizeDelta = (Vector2.New)(width, height)
end

UIWaterMark._OnScreenSizeChanged = function(self)
  -- function num : 0_3
  self:_UpdUIDMarkSize()
end

UIWaterMark.OnDelete = function(self)
  -- function num : 0_4 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.OnScreenSizeChanged, self.__OnScreenSizeChanged)
  ;
  (base.OnDelete)(self)
end

return UIWaterMark

