-- params : ...
-- function num : 0 , upvalues : _ENV
local eActInteract = {}
eActInteract.eIntrctFuncs = {[-1] = function(entity)
  -- function num : 0_0 , upvalues : _ENV
  print("打招呼")
  if IsNull(entity.gameObject) then
    error("entity.gameObject is nil")
    return 
  end
  local actLbCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
  ;
  (actLbCtrl.actLbCmderCtrl):LbHeroAndCmdFace2Face(entity)
end
}
eActInteract.eSubNameFuncs = {}
return eActInteract

