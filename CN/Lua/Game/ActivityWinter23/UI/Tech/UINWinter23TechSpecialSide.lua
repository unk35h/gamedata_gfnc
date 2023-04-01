-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivitySpring.UI.Tech.UINSpring23TechSpeicalSide")
local UINWinter23TechSpecialSide = class("UINWinter23TechSpecialSide", base)
local UINWinter23TechSpItem = require("Game.ActivityWinter23.UI.Tech.UINWinter23TechSpItem")
local UINChristmasBuffItem = require("Game.ActivityChristmas.UI.Tech.UINChristmasBuffItem")
local UINWinter23TechSpSidePageItem = require("Game.ActivityWinter23.UI.Tech.UINWinter23TechSpSidePageItem")
UINWinter23TechSpecialSide.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINChristmasBuffItem, UINWinter23TechSpSidePageItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._buffItemPool = (UIItemPool.New)(UINChristmasBuffItem, (self.ui).infoItem)
  ;
  ((self.ui).infoItem):SetActive(false)
  self._pagePool = (UIItemPool.New)(UINWinter23TechSpSidePageItem, (self.ui).item)
  ;
  ((self.ui).item):SetActive(false)
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scroll).onInstantiateItem = BindCallback(self, self.__OnInstantiateItem)
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scroll).onChangeItem = BindCallback(self, self.__OnChangeItem)
  self.__OnSpecialLvCallback = BindCallback(self, self.OnSpecialLv)
  self.__ClickSpItemCallback = BindCallback(self, self.__ClickSpItem)
  self._goItem = {}
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Refresh, self, self.OnClickReset)
  ;
  (self._pagePool):HideAll()
  local sortList = {(self.ePageEnum).strategyInfoNode, (self.ePageEnum).buffList}
  local pageClickFunc = BindCallback(self, self.OnClickPage)
  for i,v in ipairs(sortList) do
    local item = (self._pagePool):GetOne()
    item:InitWinter23TechSpSidePageItem(v, pageClickFunc)
  end
  ;
  (((self.ui).scroll).onValueChanged):AddListener(BindCallback(self, self.OnValueChange))
end

UINWinter23TechSpecialSide.SetSpItemClick = function(self, func)
  -- function num : 0_1
  self._spItemFunc = func
end

UINWinter23TechSpecialSide.SetTechInfoHideFunc = function(self, func)
  -- function num : 0_2
  self._hideTechFunc = func
end

UINWinter23TechSpecialSide.__ClickSpItem = function(self, techItem, techData)
  -- function num : 0_3
  if self._spItemFunc ~= nil then
    (self._spItemFunc)(techItem, techData)
  end
end

UINWinter23TechSpecialSide.__SetUIPageState = function(self, pageEnumId)
  -- function num : 0_4 , upvalues : _ENV
  if self._curShowPage == (self.ePageEnum).buffList then
    for i,v in ipairs((self._buffItemPool).listItem) do
      v:SetBuffItemNew(false)
    end
  end
  do
    self._curShowPage = pageEnumId
    ;
    ((self.ui).buffList):SetActive(pageEnumId == (self.ePageEnum).buffList)
    ;
    ((self.ui).strategyInfoNode):SetActive(pageEnumId == (self.ePageEnum).strategyInfoNode)
    if pageEnumId == (self.ePageEnum).buffList and self._needRefreshBuffNode then
      self:RefreshTechSpeicalSideBuffList()
    elseif self._needRefreshInfoNode then
      self:RefreshTechSpeicalSideInfoNode()
    end
    for i,v in ipairs((self._pagePool).listItem) do
      v:SetWinter23TechSpSidePageSelect(self._curShowPage)
    end
    -- DECOMPILER ERROR: 5 unprocessed JMP targets
  end
end

UINWinter23TechSpecialSide.RefreshTechSpeicalSideBuffList = function(self)
  -- function num : 0_5 , upvalues : base
  (base.RefreshTechSpeicalSideBuffList)(self)
  ;
  ((self.ui).empty):SetActive(((self._buffItemPool).listItem)[1] == nil)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINWinter23TechSpecialSide.RefreshTechSpeicalSideInfoNode = function(self)
  -- function num : 0_6 , upvalues : _ENV
  self._needRefreshInfoNode = false
  if self._techList == nil then
    local techDic = ((self._data):GetTechDataDic())[self._branchId]
    if techDic == nil then
      error("tech list error")
      return 
    end
    local techList = {}
    for k,techData in pairs(techDic) do
      (table.insert)(techList, techData)
    end
    ;
    (table.sort)(techList, function(a, b)
    -- function num : 0_6_0
    do return a:GetTechId() < b:GetTechId() end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
    self._techList = techList
    -- DECOMPILER ERROR at PC37: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).scroll).totalCount = #self._techList
    ;
    ((self.ui).scroll):RefillCells()
  else
    do
      for k,v in pairs(self._goItem) do
        v:RefreshWin23TechSpItem()
      end
      do
        local targetIndex = 0
        for i,v in ipairs(self._techList) do
          if v:GetIsUnlock() then
            do
              targetIndex = i
              -- DECOMPILER ERROR at PC61: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC61: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
        if targetIndex > 0 then
          ((self.ui).scroll):SrollToCell(targetIndex - 1, 500)
        end
      end
    end
  end
end

UINWinter23TechSpecialSide.__OnInstantiateItem = function(self, go)
  -- function num : 0_7 , upvalues : UINWinter23TechSpItem
  local item = (UINWinter23TechSpItem.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._goItem)[go] = item
end

UINWinter23TechSpecialSide.__OnChangeItem = function(self, go, index)
  -- function num : 0_8
  local item = (self._goItem)[go]
  local techData = (self._techList)[index + 1]
  item:SetWin23LogicDesType(self._desType)
  item:InitWin23TechSpItem(techData, self._resloader, self.__OnSpecialLvCallback, self.__ClickSpItemCallback)
end

UINWinter23TechSpecialSide.OnSpecialLv = function(self, techData)
  -- function num : 0_9
  if self._hideTechFunc ~= nil then
    (self._hideTechFunc)()
  end
  if self._lvCallback then
    (self._lvCallback)(techData)
  end
end

UINWinter23TechSpecialSide.OnClickPage = function(self, index)
  -- function num : 0_10
  self:__SetUIPageState(index)
  if self._hideTechFunc ~= nil then
    (self._hideTechFunc)()
  end
end

UINWinter23TechSpecialSide.OnValueChange = function(self, vecPos)
  -- function num : 0_11 , upvalues : _ENV
  local vecPointY = vecPos.y
  if self._lastPointY ~= nil and (math.abs)(vecPointY - self._lastPointY) < 0.001 then
    self._lastPointY = vecPointY
    return 
  end
  self._lastPointY = vecPointY
  if self._hideTechFunc ~= nil then
    (self._hideTechFunc)()
  end
end

return UINWinter23TechSpecialSide

