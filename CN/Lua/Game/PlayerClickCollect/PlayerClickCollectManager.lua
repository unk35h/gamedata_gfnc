-- params : ...
-- function num : 0 , upvalues : _ENV
local PlayerClickCollectManager = class("PlayerClickCollectManager")
local WAIT_TIME = 60
PlayerClickCollectManager.ctor = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.__waitReportTimer = nil
  self.__wait2ReportClickNumDic = {}
  self.__tryReport = BindCallback(self, self.__TryReport)
end

PlayerClickCollectManager.BtnClickNumCollect = function(self, reportId)
  -- function num : 0_1
  self:__OnBtnClick(reportId)
end

PlayerClickCollectManager.__OnBtnClick = function(self, reportId)
  -- function num : 0_2
  local clickNum = (self.__wait2ReportClickNumDic)[reportId] or 0
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__wait2ReportClickNumDic)[reportId] = clickNum + 1
  self:__TryStartReportTimer()
end

PlayerClickCollectManager.__TryStartReportTimer = function(self)
  -- function num : 0_3 , upvalues : _ENV, WAIT_TIME
  if self.__waitReportTimer == nil then
    self.__waitReportTimer = TimerManager:StartTimer(WAIT_TIME, self.__tryReport, self, true)
  end
end

PlayerClickCollectManager.__TryReport = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if (table.IsEmptyTable)(self.__wait2ReportClickNumDic) then
    return 
  end
  local objNetwork = NetworkManager:GetNetwork(NetworkTypeID.Object)
  local buttonClickDic = {}
  for key,value in pairs(self.__wait2ReportClickNumDic) do
    buttonClickDic[key] = value
  end
  objNetwork:CS_CLIENT_OP_SYNC(buttonClickDic)
  self.__wait2ReportClickNumDic = {}
  self.__waitReportTimer = nil
end

PlayerClickCollectManager.OnLogout = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self.__waitReportTimer ~= nil then
    TimerManager:StopTimer(self.__waitReportTimer)
    self.__waitReportTimer = nil
  end
  self.__wait2ReportClickNumDic = {}
end

return PlayerClickCollectManager

