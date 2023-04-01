-- params : ...
-- function num : 0 , upvalues : _ENV
local dormFightCtrl = ControllerManager:GetController(ControllerTypeId.DormFight, true)
if dormFightCtrl ~= nil then
  dormFightCtrl:TestEnterPvpEntry()
end

