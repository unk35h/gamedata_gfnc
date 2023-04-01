-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessLevelTrigger = class("UINWarChessLevelTrigger", UIBaseNode)
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
UINWarChessLevelTrigger.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_levelTrigger, self, self.__OnClickLevelTrigger)
  self.__refreshCouldUse = BindCallback(self, self.__RefreshCouldUse)
  MsgCenter:AddListener(eMsgEventId.WC_TeamAPChange, self.__refreshCouldUse)
  MsgCenter:AddListener(eMsgEventId.WC_SelectTeam, self.__refreshCouldUse)
  MsgCenter:AddListener(eMsgEventId.WC_ItemNumChange, self.__refreshCouldUse)
  MsgCenter:AddListener(eMsgEventId.WC_TimeRewind, self.__refreshCouldUse)
end

UINWarChessLevelTrigger.InitWCLevelTrigger = function(self, icon, resloader, trigger_id)
  -- function num : 0_1 , upvalues : _ENV
  self.__triggerCfg = (ConfigData.warchess_level_trigger)[trigger_id]
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_BtnBottom).sprite = (AtlasUtil.GetSpriteFromAtlas)("WarChess", icon, resloader)
  if #(self.__triggerCfg).item >= 4 then
    self.__costItemId = ((self.__triggerCfg).item)[3]
    self.__costItemCost = ((self.__triggerCfg).item)[4]
  end
  self:__RefreshCouldUse()
end

UINWarChessLevelTrigger.__RefreshCouldUse = function(self)
  -- function num : 0_2 , upvalues : _ENV, eWarChessEnum
  local isCouldUse = false
  local apCost = (self.__triggerCfg).ap_cost
  local wcCtrl = (WarChessManager:GetWarChessCtrl())
  -- DECOMPILER ERROR at PC6: Overwrote pending register: R4 in 'AssignReg'

  local teamData, ap = .end, nil
  ;
  ((self.ui).obj_ActionPoint):SetActive(apCost > 0)
  ;
  ((self.ui).obj_ItemCost):SetActive(self.__costItemId ~= nil)
  if wcCtrl.state == (eWarChessEnum.eWarChessState).play then
    teamData = (wcCtrl.curState):GetCurSelectedTeamData()
  end
  if teamData ~= nil then
    ap = teamData:GetTeamActionPoint()
  end
  if ap ~= nil and apCost <= ap then
    isCouldUse = true
  end
  if self.__costItemId ~= nil then
    local itemNum = (wcCtrl.backPackCtrl):GetWCItemNum(self.__costItemId)
    local itemCapacity = (wcCtrl.backPackCtrl):GetWCItemCapacity(self.__costItemId)
    isCouldUse = not isCouldUse or self.__costItemCost <= itemNum
    ;
    ((self.ui).tex_ItemNum):SetIndex(0, tostring(itemNum), tostring(itemCapacity))
  end
  -- DECOMPILER ERROR at PC78: Confused about usage of register: R6 in 'UnsetPending'

  if isCouldUse then
    ((self.ui).img_BtnBottom).color = Color.white
  else
    -- DECOMPILER ERROR at PC84: Confused about usage of register: R6 in 'UnsetPending'

    ((self.ui).img_BtnBottom).color = Color.gray
  end
  self.__isCouldUse = isCouldUse
  -- DECOMPILER ERROR: 10 unprocessed JMP targets
end

UINWarChessLevelTrigger.__OnClickLevelTrigger = function(self)
  -- function num : 0_3 , upvalues : _ENV, eWarChessEnum
  if not self.__isCouldUse then
    return 
  end
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  if not (wcCtrl.curState):IsCanOpenMenu() then
    return 
  end
  local teamData = nil
  if wcCtrl.state == (eWarChessEnum.eWarChessState).play then
    teamData = (wcCtrl.curState):GetCurSelectedTeamData()
  end
  if teamData == nil then
    if isGameDev then
      warn("need select a Team")
    end
    return 
  end
  teamData:ClearWCLastAP()
  local wid, tid = (wcCtrl.teamCtrl):GetWCTeamIdentify(teamData)
  local identify = {wid = wid, tid = tid}
  ;
  (wcCtrl.wcNetworkCtrl):CS_WarChess_GlobalInteractTrigger(identify, function(args)
    -- function num : 0_3_0 , upvalues : _ENV
    if args.Count == 0 then
      return 
    end
    local isSuccess = args[0]
    if not isSuccess then
      warn("Trigger item not enough")
    end
  end
)
end

UINWarChessLevelTrigger.OnDelete = function(self)
  -- function num : 0_4 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.WC_TeamAPChange, self.__refreshCouldUse)
  MsgCenter:RemoveListener(eMsgEventId.WC_SelectTeam, self.__refreshCouldUse)
  MsgCenter:RemoveListener(eMsgEventId.WC_ItemNumChange, self.__refreshCouldUse)
  MsgCenter:RemoveListener(eMsgEventId.WC_TimeRewind, self.__refreshCouldUse)
  ;
  (base.OnDelete)(self)
end

return UINWarChessLevelTrigger

