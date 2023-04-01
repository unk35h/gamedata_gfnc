-- params : ...
-- function num : 0 , upvalues : _ENV
local UIAvgNounDes = class("UIAvgNounDes", UIBaseWindow)
local base = UIBaseWindow
local UINAvgNounTypeTog = require("Game.Avg.UI.NounDes.UINAvgNounTypeTog")
local UINAvgNounItem = require("Game.Avg.UI.NounDes.UINAvgNounItem")
local UINAvgNounDetailNode = require("Game.Avg.UI.NounDes.UINAvgNounDetailNode")
local cs_Ease = ((CS.DG).Tweening).Ease
UIAvgNounDes.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINAvgNounTypeTog, UINAvgNounItem, UINAvgNounDetailNode
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ReadAll, self, self.OnBtnNounReadAll)
  self.typePool = (UIItemPool.New)(UINAvgNounTypeTog, (self.ui).obj_tog_NounType)
  ;
  ((self.ui).obj_tog_NounType):SetActive(false)
  self.__selectedTogItem = nil
  self.nounItemPool = (UIItemPool.New)(UINAvgNounItem, (self.ui).obj_nounItem)
  ;
  ((self.ui).obj_nounItem):SetActive(false)
  self.ItemClickDesId = 0
  self.__onOneNounStateRead = BindCallback(self, self.OnOneNounStateRead)
  self.__onClickTypeTog = BindCallback(self, self.OnClickTypeTog)
  self._SetDetailNodeActive = BindCallback(self, self.SetDetailNodeActive)
  self._SetSelect = BindCallback(self, self.SetSelect)
  self.DetailNode = (UINAvgNounDetailNode.New)()
  ;
  (self.DetailNode):Init((self.ui).obj_nounDetailNode)
  self.avgwindow = UIManager:GetWindow(UIWindowTypeID.Avg)
  self.DesListMoveAni = (self.ui).Ani_DesList
  self.DetailMoveAni = (self.ui).Ani_Detail
  self.DesListCanvas = (self.ui).Canvas_DesList
  self.DetailCanvas = (self.ui).Canvas_Detail
  self.__closeEvent = nil
end

UIAvgNounDes.InitAvgNounDes = function(self, IsOpenOnAvgPerformer, desId, defaultTypeId)
  -- function num : 0_1 , upvalues : _ENV
  self.DetailID = desId or 0
  self:SetDetailNodeActive(false)
  ;
  (self.typePool):HideAll()
  local item = (self.typePool):GetOne()
  item:InitAvgNounTypeTog((ConfigData.noun_des_type)[0], self.__onClickTypeTog, 0)
  for typeId,cfg in ipairs(ConfigData.noun_des_type) do
    local item = (self.typePool):GetOne()
    item:InitAvgNounTypeTog(cfg, self.__onClickTypeTog, typeId, desId)
  end
  do
    self:SelectSpecificNounType(defaultTypeId or 0)
    ;
    (self.DesListMoveAni):DOPlay()
    local orginpos = ((self.ui).Rct_Detail).anchoredPosition
    -- DECOMPILER ERROR at PC54: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).Rct_Detail).anchoredPosition = (Vector2.New)(700.7, orginpos.y)
    if IsOpenOnAvgPerformer then
      self.IsDoPlay = true
      ;
      ((self.ui).obj_expand):SetActive(true)
      ;
      ((self.ui).obj_ListNode):SetActive(false)
      local orginpos = ((self.ui).Rct_Detail).anchoredPosition
      -- DECOMPILER ERROR at PC78: Confused about usage of register: R7 in 'UnsetPending'

      ;
      ((self.ui).Rct_Detail).anchoredPosition = (Vector2.New)(73.5, orginpos.y)
      self:SetDetailNodeActive(true)
      ;
      (self.DetailNode):InitInfo(desId)
    end
  end
end

UIAvgNounDes.BindAvgNounCloseEvent = function(self, continueAutoPlay)
  -- function num : 0_2
  self.__closeEvent = continueAutoPlay
end

UIAvgNounDes.SelectSpecificNounType = function(self, typeId)
  -- function num : 0_3 , upvalues : _ENV
  for _,tyoeTogItem in pairs((self.typePool).listItem) do
    if (tyoeTogItem.noun_des_typeCfg).id == typeId then
      tyoeTogItem:SetAvgNonTypeTogIsOn(true)
    end
  end
end

UIAvgNounDes.OnClickTypeTog = function(self, tyoeTogItem, bool, typeId, desId)
  -- function num : 0_4
  if bool then
    self.__selectedTogItem = tyoeTogItem
    self.__selectedTypeId = typeId
    ;
    ((self.ui).obj_isSelect):SetActive(false)
    ;
    ((self.ui).obj_IsEmpty):SetActive(false)
    self:RefreshNounItemList(typeId, desId)
  end
end

local NounDesSortFunc = function(a, b)
  -- function num : 0_5 , upvalues : _ENV
  local anounCfg = (ConfigData.noun_des)[a]
  local bnounCfg = (ConfigData.noun_des)[b]
  if anounCfg.avg_order >= bnounCfg.avg_order then
    do return anounCfg.avg_order == bnounCfg.avg_order end
    do return a < b end
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

UIAvgNounDes.RefreshNounItemList = function(self, typeId, desId)
  -- function num : 0_6 , upvalues : _ENV, NounDesSortFunc
  (self.nounItemPool):HideAll()
  local newNounList = {}
  local readedNounList = {}
  self.__unreadDesDic = {}
  self.__unreadDesCount = 0
  if typeId == 0 then
    for typeId,_ in pairs((ConfigData.noun_des).typeListDic) do
      self:__GenOneNounItemList(typeId, newNounList, readedNounList)
    end
  else
    do
      self:__GenOneNounItemList(typeId, newNounList, readedNounList)
      ;
      (((self.ui).btn_ReadAll).gameObject):SetActive(self.__unreadDesCount > 0)
      if #newNounList == 0 and #readedNounList == 0 then
        ((self.ui).obj_IsEmpty):SetActive(true)
        return 
      end
      ;
      (table.sort)(newNounList, NounDesSortFunc)
      ;
      (table.sort)(readedNounList, NounDesSortFunc)
      for i,desId in pairs(newNounList) do
        local nounItem = (self.nounItemPool):GetOne()
        nounItem:InitNounItem(desId, self._SetDetailNodeActive, self._SetSelect)
        nounItem:BindNounStateReadEvent(self.__onOneNounStateRead)
        if self.DetailID == desId then
          self.DesItemIndex = i
        end
      end
      for i,desId in pairs(readedNounList) do
        local nounItem = (self.nounItemPool):GetOne()
        nounItem:InitNounItem(desId, self._SetDetailNodeActive, self._SetSelect)
        nounItem:BindNounStateReadEvent(self.__onOneNounStateRead)
        if self.DetailID == desId then
          self.DesItemIndex = i + #newNounList
        end
      end
      -- DECOMPILER ERROR: 4 unprocessed JMP targets
    end
  end
end

UIAvgNounDes.__GenOneNounItemList = function(self, typeId, newNounList, readedNounList)
  -- function num : 0_7 , upvalues : _ENV
  local nounTypeList = ((ConfigData.noun_des).typeListDic)[typeId]
  if nounTypeList == nil then
    return 
  end
  local userSaveData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  for _,id in pairs(nounTypeList) do
    local nounDesCfg = (ConfigData.noun_des)[id]
    if (CheckCondition.CheckLua)(nounDesCfg.pre_condition, nounDesCfg.pre_para1, nounDesCfg.pre_para2) or self:IsReadThisDes(id) then
      if userSaveData:GetAvgNounIsRead(id) then
        (table.insert)(readedNounList, id)
      else
        ;
        (table.insert)(newNounList, id)
        -- DECOMPILER ERROR at PC50: Confused about usage of register: R12 in 'UnsetPending'

        ;
        (self.__unreadDesDic)[id] = true
        self.__unreadDesCount = self.__unreadDesCount + 1
      end
    end
  end
end

UIAvgNounDes.OnBtnNounReadAll = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local userSaveData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  for desId,_ in pairs(self.__unreadDesDic) do
    userSaveData:SaveAvgNoun(desId)
  end
  self.__unreadDesDic = {}
  self.__unreadDesCount = 0
  ;
  (((self.ui).btn_ReadAll).gameObject):SetActive(false)
  for k,nounItem in pairs((self.nounItemPool).listItem) do
    nounItem:SetNounItemAsRead()
  end
end

UIAvgNounDes.OnOneNounStateRead = function(self, desId)
  -- function num : 0_9
  if not (self.__unreadDesDic)[desId] then
    return 
  end
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.__unreadDesDic)[desId] = nil
  self.__unreadDesCount = self.__unreadDesCount - 1
  if self.__unreadDesCount <= 0 then
    self:OnBtnNounReadAll()
  end
end

UIAvgNounDes.SetDetailNodeActive = function(self, active)
  -- function num : 0_10
  if active ~= nil then
    ((self.ui).obj_nounDetailNode):SetActive(active)
  end
end

UIAvgNounDes.SetSelect = function(self, parent)
  -- function num : 0_11 , upvalues : _ENV
  ((self.ui).obj_isSelect):SetActive(true)
  ;
  (((self.ui).obj_isSelect).transform):SetParent(parent)
  local temppos = (Vector3.New)(206.5, -37.5, 0)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (((self.ui).obj_isSelect).transform).localPosition = temppos
end

UIAvgNounDes.InitDetatilNode = function(self)
  -- function num : 0_12
  (self.DetailNode):InitInfo(self.ItemClickDesId)
end

UIAvgNounDes.IsReadThisDes = function(self, DesID)
  -- function num : 0_13 , upvalues : _ENV
  if self.avgwindow == nil then
    return false
  end
  local DesIdDic = ((((self.avgwindow).dialogNode).ui).text_Dialog).GetInfoDic
  if IsNull(DesIdDic) == false and DesIdDic:ContainsKey(DesID) then
    return true
  end
  return false
end

UIAvgNounDes.OnClickExpand = function(self)
  -- function num : 0_14 , upvalues : cs_Ease, _ENV
  ((self.ui).obj_ListNode):SetActive(true)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.DesListCanvas).alpha = 0
  ;
  ((self.DesListCanvas):DOFade(1, 0.25)):SetEase(cs_Ease.OutQuad)
  ;
  (self.DetailMoveAni):DOPlay()
  if self.DesItemIndex ~= nil then
    ((self.ui).obj_isSelect):SetActive(true)
    local itemparent = ((self.ui).rct_Scroll):GetChild(self.DesItemIndex)
    ;
    (((self.ui).obj_isSelect).transform):SetParent(itemparent)
    local temppos = (Vector3.New)(206.5, -37.5, 0)
    -- DECOMPILER ERROR at PC46: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).obj_isSelect).transform).localPosition = temppos
    local orginanpos = ((self.ui).rct_Scroll).anchoredPosition
    local anchorposy = (self.DesItemIndex - 1) * 96 > 983 and (self.DesItemIndex - 1) * 96 or 0
    -- DECOMPILER ERROR at PC69: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).rct_Scroll).anchoredPosition = (Vector3.New)(orginanpos.x, anchorposy, 0)
  end
end

UIAvgNounDes.IsNewNoun = function(self, nounID)
  -- function num : 0_15 , upvalues : _ENV
  return (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetAvgNounIsRead(nounID)
end

UIAvgNounDes.OnClickClose = function(self)
  -- function num : 0_16
  do
    if self.__closeEvent ~= nil then
      local callback = self.__closeEvent
      self.__closeEvent = nil
      callback()
    end
    self:Delete()
  end
end

UIAvgNounDes.OnDelete = function(self)
  -- function num : 0_17 , upvalues : base
  (base.OnDelete)(self)
end

return UIAvgNounDes

