-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UIWarChessJumpSystem = class("UIWarChessJumpSystem", base)
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local eGridToward = eWarChessEnum.eGridToward
UIWarChessJumpSystem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, eGridToward
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListenerWithArg)((self.ui).btn_up, self, self.__OnClickJump, eGridToward.up)
  ;
  (UIUtil.AddButtonListenerWithArg)((self.ui).btn_down, self, self.__OnClickJump, eGridToward.down)
  ;
  (UIUtil.AddButtonListenerWithArg)((self.ui).btn_left, self, self.__OnClickJump, eGridToward.left)
  ;
  (UIUtil.AddButtonListenerWithArg)((self.ui).btn_right, self, self.__OnClickJump, eGridToward.right)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_cancle, self, self.__OnClickCancle)
end

UIWarChessJumpSystem.InitWCJumpSystem = function(self, jumpCtrl)
  -- function num : 0_1
  self.__jumpCtrl = jumpCtrl
  local teamData = jumpCtrl:WCJumpGetTeamData()
  local teamIndex = teamData:GetWCTeamIndex()
  self.__heroEntity = ((jumpCtrl.wcCtrl).teamCtrl):GetWCHeroEntity(teamIndex, nil, nil)
  self:__UpdateUIPos()
end

UIWarChessJumpSystem.__UpdateUIPos = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.__heroEntity == nil then
    return 
  end
  local showPos = (self.__heroEntity):WCHeroEntityGetShowPos()
  local uiPos = (Vector3.New)(showPos.x, showPos.y + 1, showPos.z)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).trans_jumpNode).position = uiPos
end

UIWarChessJumpSystem.__OnClickJump = function(self, dir)
  -- function num : 0_3
  (self.__jumpCtrl):WCJumpSubSysJump(dir)
end

UIWarChessJumpSystem.__OnClickCancle = function(self)
  -- function num : 0_4
  (self.__jumpCtrl):WCJumpSubSysCancle()
end

UIWarChessJumpSystem.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UIWarChessJumpSystem

