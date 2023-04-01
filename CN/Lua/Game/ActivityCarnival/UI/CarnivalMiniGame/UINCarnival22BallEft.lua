-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnival22BallEft = class("UINCarnival22BallEft", UIBaseNode)
local base = UIBaseNode
local CS_UnityEngine_Time = (CS.UnityEngine).Time
UINCarnival22BallEft.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINCarnival22BallEft.InitBallEft = function(self, index)
  -- function num : 0_1 , upvalues : CS_UnityEngine_Time
  self._playeTime = CS_UnityEngine_Time.time
  local scale = ((self.ui).scales)[index]
  if scale == nil then
    scale = ((self.ui).scales)[#(self.ui).scales]
  end
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).uI_Carnival22MiniGame_click).scale = scale
end

UINCarnival22BallEft.IsBallEftFnish = function(self)
  -- function num : 0_2 , upvalues : CS_UnityEngine_Time
  do return (self.ui).still_time < CS_UnityEngine_Time.time - self._playeTime end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

return UINCarnival22BallEft

