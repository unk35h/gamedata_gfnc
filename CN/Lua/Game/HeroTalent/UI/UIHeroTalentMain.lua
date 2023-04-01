-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHeroTalentMain = class("UIHeroTalentMain", UIBaseWindow)
local base = UIBaseWindow
local cs_MessageCommon = CS.MessageCommon
local talentShowRes = {1901, 1902, 1903, 1900}
local scaleRange = {0.5, 1}
local defaultScale = (Vector3.New)(0.87, 0.87, 1)
local UINHeroTalentHeroInfo = require("Game.HeroTalent.UI.UINHeroTalentHeroInfo")
local UINHeroTalentMap = require("Game.HeroTalent.UI.UINHeroTalentMap")
local UINHeroTalentNodeDetail = require("Game.HeroTalent.UI.UINHeroTalentNodeDetail")
local CS_LeanTouch = ((CS.Lean).Touch).LeanTouch
local CS_DOTween = ((CS.DG).Tweening).DOTween
local waitRecorverNUM = 0
UIHeroTalentMain.OnInit = function(self)
  -- function num : 0_0 , upvalues : UINHeroTalentHeroInfo, UINHeroTalentMap, UINHeroTalentNodeDetail, _ENV, CS_LeanTouch, defaultScale
  self._heroInfoUI = (UINHeroTalentHeroInfo.New)()
  ;
  (self._heroInfoUI):Init((self.ui).heroNode)
  self._mapUI = (UINHeroTalentMap.New)()
  ;
  (self._mapUI):Init((self.ui).map)
  self._nodeDetailUI = (UINHeroTalentNodeDetail.New)()
  ;
  (self._nodeDetailUI):Init((self.ui).talentDetailNode)
  ;
  (self._nodeDetailUI):BindLvUpClickCallback(BindCallback(self, self.__OnLvUpClick))
  ;
  (self._nodeDetailUI):BindBranchCallback(BindCallback(self, self.__OnBranchSelectClick))
  ;
  (self._mapUI):InitHeroTalentMap(BindCallback(self, self.OnSelectTalentNode), ((((self.ui).talentDetailNode).transform).rect).width, BindCallback(self, self.OnSelectTalentNodeMain), BindCallback(self, self.OnSelectTalentNodeCancle))
  self.__TalentLvListenEvent = BindCallback(self, self.__TalentLvListen)
  MsgCenter:AddListener(eMsgEventId.HeroTalentLvUp, self.__TalentLvListenEvent)
  self.__HeroLvUpListenEvent = BindCallback(self, self.__HeroLvUpListen)
  MsgCenter:AddListener(eMsgEventId.UpdateHero, self.__HeroLvUpListenEvent)
  self.__ItemUpdateEvent = BindCallback(self, self.__ItemUpdate)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__ItemUpdateEvent)
  self.__OnGesture = BindCallback(self, self.OnGesture)
  ;
  (CS_LeanTouch.OnGesture)("+", self.__OnGesture)
  self._infoFunc = nil
  if (ConfigData.game_config).heroTalentTipsId or 0 > 0 then
    self._infoFunc = function()
    -- function num : 0_0_0 , upvalues : _ENV
    local GuidePicture = require("Game.Guide.GuidePicture.GuidePicture")
    ;
    (GuidePicture.OpenGuidePicture)((ConfigData.game_config).heroTalentTipsId, nil, true)
  end

  end
  ;
  (self._mapUI):SetTouchAreaScale(defaultScale)
  self._materialTable = {}
end

UIHeroTalentMain.GenCoverJumpReturnCallback = function(self)
  -- function num : 0_1 , upvalues : waitRecorverNUM
  local dataTable = {closeCallback = self._closeCallback, heroData = self._heroInfo}
  waitRecorverNUM = waitRecorverNUM + 1
  return function()
    -- function num : 0_1_0 , upvalues : waitRecorverNUM, self, dataTable
    waitRecorverNUM = waitRecorverNUM - 1
    self:Show()
    self._closeCallback = dataTable.closeCallback
    self._heroInfo = dataTable.heroData
    self:__Init()
  end

end

UIHeroTalentMain.InitHeroTalentMain = function(self, heroData, closeCallback)
  -- function num : 0_2 , upvalues : _ENV, talentShowRes
  (UIUtil.SetTopStatus)(self, self.OnTalentClose, talentShowRes, self._infoFunc)
  self._closeCallback = closeCallback
  self._heroInfo = heroData
  self:__Init()
end

UIHeroTalentMain.__Init = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self._talent = (self._heroInfo):GetHeroDataTalent()
  ;
  (self._nodeDetailUI):Hide()
  if self._talent == nil then
    error("talent is NIL")
    return 
  end
  local campId = (self._heroInfo).career
  local particleColor = ((self.ui).particleColorArray)[campId]
  for _,material in ipairs(self._materialTable) do
    DestroyUnityObject(material)
  end
  ;
  (table.removeall)(self._materialTable)
  for _,particleReder in ipairs((self.ui).particleCampArray) do
    local mat = particleReder:GetMaterial()
    if not IsNull(mat) then
      local newMat = (((CS.UnityEngine).Object).Instantiate)(mat)
      newMat:SetColor("_Color", particleColor)
      particleReder.material = newMat
      ;
      (table.insert)(self._materialTable, newMat)
    end
  end
  local color = ((self.ui).campColorArray)[campId]
  ;
  (self._mapUI):SetCampColor(color)
  ;
  (self._mapUI):UpdateHeroTalentMap(self._talent)
  ;
  (self._heroInfoUI):UpdateHeroTalentHeroInfo(self._heroInfo)
  local careerCfg = (self._heroInfo):GetCareerCfg()
  -- DECOMPILER ERROR at PC88: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_career).sprite = CRH:GetSprite(careerCfg.icon, CommonAtlasType.CareerCamp)
  local campCfg = (self._heroInfo):GetCampCfg()
  -- DECOMPILER ERROR at PC100: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).img_Camp).sprite = CRH:GetSprite(campCfg.icon, CommonAtlasType.CareerCamp)
end

UIHeroTalentMain.OnSelectTalentNode = function(self, talentNode)
  -- function num : 0_4
  if talentNode == nil then
    return 
  end
  self._talentNode = talentNode
  ;
  (self._nodeDetailUI):Show()
  ;
  (self._nodeDetailUI):UpdateHeroTalentDetailNode(self._talentNode)
  ;
  (self._heroInfoUI):SetHeroTalentNode(self._talentNode)
end

UIHeroTalentMain.OnSelectTalentNodeMain = function(self)
  -- function num : 0_5
  self._talentNode = nil
  ;
  (self._nodeDetailUI):Hide()
  ;
  (self._heroInfoUI):ShowHeroTalentAllAddtion(self._talent)
end

UIHeroTalentMain.OnSelectTalentNodeCancle = function(self)
  -- function num : 0_6
  self._talentNode = nil
  ;
  (self._nodeDetailUI):Hide()
  ;
  (self._heroInfoUI):CancleHeroTalentShow()
end

UIHeroTalentMain.__TalentLvListen = function(self, heroId)
  -- function num : 0_7
  if self._talentNode == nil or (self._heroInfo).dataId ~= heroId then
    return 
  end
  ;
  (self._nodeDetailUI):RefreshHeroTalentDetailUI()
  ;
  (self._heroInfoUI):RefreshHeroTalentHeroInfoUI()
  ;
  (self._mapUI):LvUpHeroTalentMap((self._heroInfo).dataId, (self._talentNode):GetHeroTalentNodeId())
end

UIHeroTalentMain.__HeroLvUpListen = function(self)
  -- function num : 0_8
  (self._heroInfoUI):RefreshHeroTalentHeroInfoUI()
end

UIHeroTalentMain.__ItemUpdate = function(self)
  -- function num : 0_9
  if (self._nodeDetailUI).active then
    (self._nodeDetailUI):RefreshHeroTalentDetailUI()
  end
  ;
  (self._mapUI):UpdateItemTalentMap()
end

UIHeroTalentMain.OnGesture = function(self, fingerList)
  -- function num : 0_10 , upvalues : _ENV, scaleRange
  if fingerList.Count ~= 2 then
    return 
  end
  local touch1 = fingerList[0]
  local touch2 = fingerList[1]
  local lastDiffX = (touch1.LastScreenPosition).x - (touch2.LastScreenPosition).x
  local lastDiffY = (touch1.LastScreenPosition).y - (touch2.LastScreenPosition).y
  local curDiffX = (touch1.ScreenPosition).x - (touch2.ScreenPosition).x
  local curDiffY = (touch1.ScreenPosition).y - (touch2.ScreenPosition).y
  local diff = (Mathf.Sqrt)((Mathf.Pow)(curDiffX, 2) + (Mathf.Pow)(curDiffY, 2)) - (Mathf.Sqrt)((Mathf.Pow)(lastDiffX, 2) + (Mathf.Pow)(lastDiffY, 2))
  local touchAreaX = (self._mapUI):GetTouchAreaScaleX()
  local scale = touchAreaX + diff / 100
  scale = (math.clamp)(scale, scaleRange[1], scaleRange[2])
  ;
  (self._mapUI):SetTouchAreaScale((Vector3.New)(scale, scale, scale))
end

UIHeroTalentMain.__OnLvUpClick = function(self, nodeData)
  -- function num : 0_11 , upvalues : cs_MessageCommon, _ENV
  if not nodeData:IsHeroTalentNodeCanLeveUp() then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(44))
    return 
  end
  local heroId = nodeData:GetHeroTalentNodeHeroId()
  local heroData = (PlayerDataCenter.heroDic)[heroId]
  if heroData == nil then
    return 
  end
  self._tempPower = heroData:GetFightingPower()
  local heroNetCtrl = NetworkManager:GetNetwork(NetworkTypeID.Hero)
  heroNetCtrl:CS_HERO_TALENT_Upgrade(heroId, nodeData:GetHeroTalentNodeId(), function()
    -- function num : 0_11_0 , upvalues : self, heroId, nodeData
    self:__LvUpEffectShow(heroId, nodeData:GetHeroTalentNodeId())
  end
)
end

UIHeroTalentMain.__LvUpEffectShow = function(self, heroId, nodeId)
  -- function num : 0_12 , upvalues : _ENV, CS_DOTween
  (self._mapUI):ShowHeroTalentMapLvupEffect(nodeId)
  if self._delayShowPowerTween ~= nil then
    (self._delayShowPowerTween):Kill()
    self._delayShowPowerTween = nil
  end
  local heroData = (PlayerDataCenter.heroDic)[heroId]
  if heroData ~= self._heroInfo then
    self._tempPower = nil
    return 
  end
  local newPower = heroData:GetFightingPower()
  if newPower == self._tempPower then
    self._tempPower = nil
    return 
  end
  self._delayShowPowerTween = (CS_DOTween.Sequence)()
  ;
  (self._delayShowPowerTween):AppendInterval(0.8)
  ;
  (self._delayShowPowerTween):AppendCallback(function()
    -- function num : 0_12_0 , upvalues : _ENV, self, newPower
    UIManager:ShowWindowAsync(UIWindowTypeID.HeroPowerUpSuccess, function(win)
      -- function num : 0_12_0_0 , upvalues : self, newPower
      if win == nil then
        return 
      end
      win:InitHeroPowerUpSuccess(self._tempPower, newPower)
      self._tempPower = nil
    end
)
    self._delayShowPowerTween = nil
  end
)
  ;
  (self._delayShowPowerTween):SetAutoKill(true)
end

UIHeroTalentMain.__OnBranchSelectClick = function(self, branchId)
  -- function num : 0_13 , upvalues : _ENV
  if self._talentNode == nil then
    return 
  end
  local flag, selectId = (self._talentNode):GetHeroTalentNodeBranchId()
  if not flag then
    return 
  end
  local heroId = (self._talentNode):GetHeroTalentNodeHeroId()
  local heroData = (PlayerDataCenter.heroDic)[heroId]
  if heroData ~= self._heroInfo then
    return 
  end
  local heroNetCtrl = NetworkManager:GetNetwork(NetworkTypeID.Hero)
  heroNetCtrl:CS_HERO_TALENT_CHOICE(heroId, (self._talentNode):GetHeroTalentNodeId(), branchId)
end

UIHeroTalentMain.OnTalentClose = function(self)
  -- function num : 0_14 , upvalues : waitRecorverNUM
  if waitRecorverNUM <= 0 then
    self:Delete()
  else
    self:Hide()
  end
  if self._closeCallback ~= nil then
    (self._closeCallback)()
  end
end

UIHeroTalentMain.OnDelete = function(self)
  -- function num : 0_15 , upvalues : base, _ENV, CS_LeanTouch
  (base.OnDelete)(self)
  MsgCenter:RemoveListener(eMsgEventId.UpdateHero, self.__HeroLvUpListenEvent)
  MsgCenter:RemoveListener(eMsgEventId.HeroTalentLvUp, self.__TalentLvListenEvent)
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__ItemUpdateEvent)
  ;
  (CS_LeanTouch.OnGesture)("-", self.__OnGesture)
  if self._delayShowPowerTween ~= nil then
    (self._delayShowPowerTween):Kill()
    self._delayShowPowerTween = nil
  end
  ;
  (self._mapUI):OnDelete()
  ;
  (self._nodeDetailUI):OnDelete()
  ;
  (self._heroInfoUI):OnDelete()
end

UIHeroTalentMain.OnDeleteEntity = function(self)
  -- function num : 0_16 , upvalues : base, _ENV
  (base.OnDeleteEntity)(self)
  for _,material in ipairs(self._materialTable) do
    DestroyUnityObject(material)
  end
  ;
  (table.removeall)(self._materialTable)
end

return UIHeroTalentMain

