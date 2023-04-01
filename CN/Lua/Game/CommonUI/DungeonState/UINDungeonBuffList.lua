-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDungeonBuffList = class("UINDungeonBuffList", UIBaseNode)
local base = UIBaseNode
local UINDungeonBuffItem = require("Game.CommonUI.DungeonState.UINDungeonBuffItem")
local FloatAlignEnum = require("Game.CommonUI.FloatWin.FloatAlignEnum")
local HAType = FloatAlignEnum.HAType
local VAType = FloatAlignEnum.VAType
UINDungeonBuffList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINDungeonBuffItem
  self.AbleToBuffItemPointer = true
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.itemPool = (UIItemPool.New)(UINDungeonBuffItem, (self.ui).obj_buffItem)
  ;
  ((self.ui).obj_buffItem):SetActive(false)
  self.__ShowBuffDescription = BindCallback(self, self.ShowBuffDescription)
  self.__HideBuffDetail = BindCallback(self, self.HideBuffDetail)
  self.__onEpBuffListChange = BindCallback(self, self.RefrshBuffList)
  MsgCenter:AddListener(eMsgEventId.OnEpBuffListChange, self.__onEpBuffListChange)
  self.__changeBuffListDisplay = BindCallback(self, self.ChangeBuffListDisplay)
  MsgCenter:AddListener(eMsgEventId.OnEpBuffListDisplay, self.__changeBuffListDisplay)
  self.buffHideList = {}
  self.__btnBufDescActive = (((self.ui).btn_BuffDescriptionPage).gameObject).activeSelf
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_BuffDescriptionPage, self, self._OnBuffDescriptionClick)
end

UINDungeonBuffList.SetBuffListAbleToPointer = function(self, able)
  -- function num : 0_1
  self.AbleToBuffItemPointer = able
end

UINDungeonBuffList.ChangeBuffListDisplay = function(self, isShow)
  -- function num : 0_2 , upvalues : _ENV
  if isShow then
    (table.remove)(self.buffHideList, #self.buffHideList)
  else
    ;
    (table.insert)(self.buffHideList, isShow)
  end
  if self.buffHideList == nil or #self.buffHideList <= 0 then
    self:Show()
  else
    self:Hide()
  end
end

UINDungeonBuffList.InitBuffList = function(self, buffList)
  -- function num : 0_3
  self:RefrshBuffList(buffList)
end

UINDungeonBuffList.RefrshBuffList = function(self, buffList)
  -- function num : 0_4 , upvalues : _ENV
  self.buffList = buffList
  local buffCount = 0
  ;
  (self.itemPool):HideAll()
  if WarChessManager:GetIsInWarChess() then
    self.buffList = {}
    local buffDic = ((WarChessManager:GetWarChessCtrl()).backPackCtrl):GetWCBuffDic()
    for k,wcBuff in pairs(buffDic) do
      if wcBuff:GetWCBuffIsNeedShow() then
        buffCount = buffCount + 1
        local buffItem = (self.itemPool):GetOne()
        buffItem:InitWcDunBuff(wcBuff, self.__ShowBuffDescription, self.__HideBuffDetail)
        ;
        (table.insert)(self.buffList, wcBuff)
      end
    end
  else
    do
      for index,epBuff in ipairs(buffList) do
        if epBuff:IsBuffNeedShowOnBuffList() then
          buffCount = buffCount + 1
          local item = (self.itemPool):GetOne(true)
          item:InitBuffByCfg(epBuff, epBuff:GetBuffCfg(), self.__ShowBuffDescription, self.__HideBuffDetail)
        end
      end
      do
        if buffCount <= 0 then
          self:Hide()
        else
          self:Show()
        end
        local maxShowBuffNum = (math.floor)(((((self.ui).buffListScrollRect).transform).sizeDelta).x / (((self.ui).buffList).spacing + ((((self.ui).obj_buffItem).transform).sizeDelta).x))
        if maxShowBuffNum <= buffCount then
          ((self.ui).obj_BuffCount):SetActive(true)
          -- DECOMPILER ERROR at PC102: Confused about usage of register: R4 in 'UnsetPending'

          ;
          ((self.ui).tex_BuffNum).text = tostring(buffCount)
        else
          ;
          ((self.ui).obj_BuffCount):SetActive(false)
        end
        if buffCount > 0 and not self.__btnBufDescActive then
          (((self.ui).btn_BuffDescriptionPage).gameObject):SetActive(true)
          self.__btnBufDescActive = true
        else
          if buffCount == 0 and self.__btnBufDescActive then
            (((self.ui).btn_BuffDescriptionPage).gameObject):SetActive(false)
            self.__btnBufDescActive = false
          end
        end
      end
    end
  end
end

UINDungeonBuffList.ShowBuffDescription = function(self, item, buffCfg)
  -- function num : 0_5 , upvalues : _ENV, HAType, VAType
  if not self.AbleToBuffItemPointer then
    return 
  end
  local win = (UIManager:ShowWindow(UIWindowTypeID.FloatingFrame))
  local des = nil
  if WarChessManager:GetIsInWarChess() then
    des = buffCfg.description
  else
    des = buffCfg.describe
  end
  if not self.__eHAType then
    self.__eHAType = HAType.autoCenter
  end
  if not self.__eVAtype then
    self.__eVAtype = VAType.up
  end
  if not self.__shiftX then
    self.__shiftX = 0
  end
  if not self.__shiftY then
    self.__shiftY = 0.5
  end
  win:SetTitleAndContext((LanguageUtil.GetLocaleText)(buffCfg.name), (LanguageUtil.GetLocaleText)(des))
  win:FloatTo(item.transform, self.__eHAType, self.__eVAtype, self.__shiftX, self.__shiftY)
  win:Copy3DModifier((self.ui).comp_3dModifier)
end

UINDungeonBuffList.SetBuffDetailFloatAlign = function(self, eHAType, eVAtype, shiftX, shiftY)
  -- function num : 0_6
  self.__eHAType = eHAType
  self.__eVAtype = eVAtype
  self.__shiftX = shiftX
  self.__shiftY = shiftY
end

UINDungeonBuffList.HideBuffDetail = function(self, skillData)
  -- function num : 0_7 , upvalues : _ENV
  local win = UIManager:GetWindow(UIWindowTypeID.FloatingFrame)
  if win ~= nil then
    win:Hide()
    win:Clean3DModifier()
  end
end

UINDungeonBuffList._OnBuffDescriptionClick = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local battleWin = UIManager:GetWindow(UIWindowTypeID.Battle)
  local pauseSuc = false
  if battleWin ~= nil then
    pauseSuc = battleWin:TrySmallBattlePause()
    battleWin:HideMonsterOrNeutralRoleInfo()
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.EpBuffDesc, function(buffDescWin)
    -- function num : 0_8_0 , upvalues : self, pauseSuc, _ENV
    buffDescWin:InitDescriptPageEpBuffShow(self.buffList, function()
      -- function num : 0_8_0_0 , upvalues : pauseSuc, _ENV
      if pauseSuc then
        local battleWin = UIManager:GetWindow(UIWindowTypeID.Battle)
        if battleWin then
          battleWin:TryCancelBattlePause()
        end
      end
    end
)
  end
)
end

UINDungeonBuffList.OnShow = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnShow)(self)
  ;
  (((self.ui).btn_BuffDescriptionPage).gameObject):SetActive(true)
end

UINDungeonBuffList.OnHide = function(self)
  -- function num : 0_10 , upvalues : base
  (base.OnHide)(self)
  ;
  (((self.ui).btn_BuffDescriptionPage).gameObject):SetActive(false)
end

UINDungeonBuffList.OnDelete = function(self)
  -- function num : 0_11 , upvalues : _ENV, base
  self.buffHideList = nil
  MsgCenter:RemoveListener(eMsgEventId.OnEpBuffListChange, self.__onEpBuffListChange)
  MsgCenter:RemoveListener(eMsgEventId.OnEpBuffListDisplay, self.__changeBuffListDisplay)
  self:HideBuffDetail()
  ;
  (base.OnDelete)(self)
end

return UINDungeonBuffList

