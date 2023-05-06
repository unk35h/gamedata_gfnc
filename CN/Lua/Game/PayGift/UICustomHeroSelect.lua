-- params : ...
-- function num : 0 , upvalues : _ENV
local UICustomHeroSelect = class("UICustomHeroSelect", UIBaseWindow)
local base = UIBaseWindow
local UINCustomHeroSelectItem = require("Game.PayGift.UINCustomHeroSelectItem")
local cs_ResLoader = CS.ResLoader
local eSelfSelectGift = require("Game.PayGift.eSelfSelectGift")
UICustomHeroSelect.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, cs_ResLoader
  (((UIUtil.CreateNewTopStatusData)(self)):SetTopStatusBackAction(self.Delete)):PushTopStatusDataToBackStack()
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickBack)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancle, self, self.OnClickBack)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.OnClickConfirmSelect)
  self.__OnSelectHeroCallback = BindCallback(self, self.__OnSelectHero)
  self._resloader = (cs_ResLoader.Create)()
  self._itemDic = {}
  -- DECOMPILER ERROR at PC46: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).onInstantiateItem = BindCallback(self, self.OnInstantiateItem)
  -- DECOMPILER ERROR at PC53: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).onChangeItem = BindCallback(self, self.OnChangeItem)
  -- DECOMPILER ERROR at PC60: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_SkillName).text = ConfigData:GetTipContent(410)
  local itemInfos = (ConfigData.game_config).customHeroGiftConvert
  -- DECOMPILER ERROR at PC80: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_HeadAttri).text = (string.format)(ConfigData:GetTipContent(411), tostring(itemInfos[2]), ConfigData:GetItemName(itemInfos[1]))
end

UICustomHeroSelect.InitCustomHeroSelect = function(self, selfSelectCfg, selectHeroId, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._callback = callback
  self._selectHeroId = selectHeroId
  self._heroCfgList = {}
  for _,id in ipairs(selfSelectCfg.param1) do
    local heroCfg = (ConfigData.hero_data)[id]
    if not heroCfg.is_locked then
      (table.insert)(self._heroCfgList, heroCfg)
    end
  end
  ;
  (table.sort)(self._heroCfgList, function(a, b)
    -- function num : 0_1_0 , upvalues : _ENV
    local aHas = PlayerDataCenter:ContainsHeroData(a.id)
    local bHas = PlayerDataCenter:ContainsHeroData(b.id)
    if aHas ~= bHas then
      return not aHas
    end
    if b.rank >= a.rank then
      do return a.rank == b.rank end
      do return b.id < a.id end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).totalCount = #self._heroCfgList
  ;
  ((self.ui).scrollRect):RefillCells()
end

UICustomHeroSelect.OnInstantiateItem = function(self, go)
  -- function num : 0_2 , upvalues : UINCustomHeroSelectItem
  local item = (UINCustomHeroSelectItem.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._itemDic)[go] = item
end

UICustomHeroSelect.OnChangeItem = function(self, go, index)
  -- function num : 0_3
  local item = (self._itemDic)[go]
  local heroCfg = (self._heroCfgList)[index + 1]
  item:InitCustomHeroItem(heroCfg, self.__OnSelectHeroCallback, self._resloader)
  item:RefreshCustomHeroState(self._selectHeroId)
end

UICustomHeroSelect.__OnSelectHero = function(self, heroId)
  -- function num : 0_4 , upvalues : _ENV
  self._selectHeroId = heroId
  for k,v in pairs(self._itemDic) do
    v:RefreshCustomHeroState(heroId)
  end
end

UICustomHeroSelect.OnClickConfirmSelect = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self._selectHeroId == nil then
    return 
  end
  ;
  (UIUtil.OnClickBackByUiTab)(self)
  if self._callback ~= nil then
    (self._callback)(self._selectHeroId)
  end
end

UICustomHeroSelect.OnClickBack = function(self)
  -- function num : 0_6 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UICustomHeroSelect.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnDelete)(self)
end

return UICustomHeroSelect

