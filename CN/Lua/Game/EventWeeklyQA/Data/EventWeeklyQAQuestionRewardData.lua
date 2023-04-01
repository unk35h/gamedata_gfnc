-- params : ...
-- function num : 0 , upvalues : _ENV
local EventWeeklyQAQuestionRewardData = class("EventWeeklyQAQuestionRewardData")
EventWeeklyQAQuestionRewardData.eRewardState = {unComplete = 0, CompleteNoPicked = 1, Picked = 2}
EventWeeklyQAQuestionRewardData.ctor = function(self, needScore, rewardCfg, currentState)
  -- function num : 0_0
  self.needScore = needScore
  self.rewardCfg = rewardCfg
  self.currentState = currentState
  return self
end

return EventWeeklyQAQuestionRewardData

