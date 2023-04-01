-- params : ...
-- function num : 0 , upvalues : _ENV
local ExplorationExRoomCtrl = class("ExplorationExRoomCtrl", ExplorationCtrlBase)
local base = ExplorationCtrlBase
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
ExplorationExRoomCtrl.ctor = function(self, epCtrl)
  -- function num : 0_0 , upvalues : _ENV
  self.epNetWork = NetworkManager:GetNetwork(NetworkTypeID.Exploration)
  self.__OnExRoomLogicEnd = BindCallback(self, self.OnExRoomLogicEnd)
end

ExplorationExRoomCtrl.OnEpExRoomOpen = function(self, roomData, isFirst)
  -- function num : 0_1 , upvalues : _ENV, ExplorationEnum
  if roomData.epExRoomData == nil then
    error("Can\'t find epExRoomData")
    self:OnExRoomLogicEnd()
    return 
  end
  self.__epExRoomData = roomData.epExRoomData
  local exRoomCfg = (ConfigData.exploration_exroom)[(self.__epExRoomData).id]
  if exRoomCfg == nil then
    error("exploration_exroom cfg is null,id:" .. tostring((self.__epExRoomData).id))
    self:OnExRoomLogicEnd()
    return 
  end
  if exRoomCfg.exroom_type == (ExplorationEnum.exRoomType).AvgRoom then
    local avgCtrl = ControllerManager:GetController(ControllerTypeId.Avg, true)
    avgCtrl:StartAvg(nil, exRoomCfg.para1, self.__OnExRoomLogicEnd)
    ;
    ((self.epCtrl).autoCtrl):OnEnterEpExRoom(exRoomCfg.exroom_type, true)
  else
    do
      self:OnExRoomLogicEnd()
    end
  end
end

ExplorationExRoomCtrl.GetExRoomData = function(self)
  -- function num : 0_2
  return self.__epExRoomData
end

ExplorationExRoomCtrl.OnExRoomLogicEnd = function(self)
  -- function num : 0_3 , upvalues : _ENV, ExplorationEnum
  ((self.epCtrl).autoCtrl):OnExitEpExRoom()
  ;
  (self.epNetWork):CS_EXPLORATION_EX_OVER(function()
    -- function num : 0_3_0 , upvalues : self, _ENV, ExplorationEnum
    self.__epExRoomData = nil
    MsgCenter:Broadcast(eMsgEventId.OnExitRoomComplete, (ExplorationEnum.eExitRoomCompleteType).ExRoom)
  end
)
end

ExplorationExRoomCtrl.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return ExplorationExRoomCtrl

