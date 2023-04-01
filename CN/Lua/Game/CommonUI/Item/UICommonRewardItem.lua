-- params : ...
-- function num : 0 , upvalues : _ENV
local UICommonRewardItem = class("UICommonRewardItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local cs_DoTween = ((CS.DG).Tweening).DOTween
local cs_LoopTypeYoyo = (((CS.DG).Tweening).LoopType).Yoyo
local CS_CanvasGroup = (CS.UnityEngine).CanvasGroup
UICommonRewardItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.baseItem = (UINBaseItemWithCount.New)()
  ;
  (self.baseItem):Init((self.ui).obj_BaseItemWithCount)
  local obj = ((self.ui).obj_BaseItemWithCount):Instantiate((((self.ui).obj_BaseItemWithCount).transform).parent)
  self.convertItemPool = (UIItemPool.New)(UINBaseItemWithCount, obj, false)
end

UICommonRewardItem.SetIsConvertHeroFrag = function(self)
  -- function num : 0_1
  self._isConvertHeroFrag = true
end

UICommonRewardItem.SetItemTranNum = function(self, num)
  -- function num : 0_2
  self._itemTransNum = num
end

UICommonRewardItem.SetItemNameShow = function(self, isShow)
  -- function num : 0_3
  (((self.ui).tex_ItemName).gameObject):SetActive(isShow)
end

UICommonRewardItem.LoopRecycleInit = function(self)
  -- function num : 0_4 , upvalues : _ENV, CS_CanvasGroup
  if self.tweenSeq ~= nil then
    (self.tweenSeq):Kill()
    self.tweenSeq = nil
  end
  local component = ((self.baseItem).gameObject):GetComponent(typeof(CS_CanvasGroup))
  if not IsNull(component) then
    component.alpha = 1
  end
  ;
  (self.convertItemPool):HideAll()
end

UICommonRewardItem.InitCommonRewardItem = function(self, itemCfg, rewardNum, heroIdSnapshoot, clickEvent)
  -- function num : 0_5 , upvalues : _ENV
  self:LoopRecycleInit()
  if itemCfg == nil then
    return 
  end
  self.itemCfg = itemCfg
  ;
  (self.baseItem):InitItemWithCount(itemCfg, rewardNum, clickEvent)
  ;
  (self.baseItem):SetNotNeedAnyJump(true)
  ;
  (((self.ui).tex_ItemName).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_ItemName).text = tostring((LanguageUtil.GetLocaleText)(itemCfg.name))
  local hasHero = false
  local heroId = itemCfg.heroId
  hasHero = heroId == nil or heroIdSnapshoot == nil or (heroIdSnapshoot[heroId] and true) or false
  local extraIds, extraNums = nil, nil
  local canTrans, extraIds, extraNums = self:__HeroTrans(itemCfg, hasHero, heroId)
  if not canTrans then
    canTrans = self:__ItemTrans(itemCfg)
  end
  if not canTrans then
    return 
  end
  local itemList = {self.baseItem}
  for k,id in ipairs(extraIds) do
    local num = extraNums[k]
    local itemCfg = (ConfigData.item)[id]
    if itemCfg == nil then
      error("Cant get itemCfg, id = " .. tostring(id))
    else
      local item = (self.convertItemPool):GetOne(true)
      item:InitItemWithCount(itemCfg, num)
      ;
      (item.transform):SetAsFirstSibling()
      ;
      (table.insert)(itemList, item)
      -- DECOMPILER ERROR at PC106: Confused about usage of register: R21 in 'UnsetPending'

      ;
      ((self.ui).tex_ItemName).text = tostring((LanguageUtil.GetLocaleText)(itemCfg.name))
    end
  end
  self:_PlayTween(itemList)
end

UICommonRewardItem.__HeroTrans = function(self, itemCfg, hasHero, heroId)
  -- function num : 0_6 , upvalues : _ENV
  if itemCfg.type ~= eItemType.HeroCard or not hasHero then
    return false
  end
  local heroData = PlayerDataCenter:GetHeroData(heroId)
  local rankCfg = (ConfigData.hero_rank)[(heroData.heroCfg).rank]
  if rankCfg == nil then
    error("Can\'t find rankCfg, id = " .. tostring(heroId))
    return false
  end
  if self._isConvertHeroFrag then
    return true, {heroData.fragId}, {rankCfg.repeat_frag_trans}
  end
  return true, rankCfg.repeat_extra_trans_id, rankCfg.repeat_extra_trans_num
end

UICommonRewardItem.__ItemTrans = function(self, itemCfg)
  -- function num : 0_7 , upvalues : _ENV
  if self._itemTransNum then
    local trans_id = {}
    local trans_num = {}
    local transPara = {}
    if itemCfg.overflow_type == eItemTransType.actItemOverFlow then
      for index,value in ipairs(itemCfg.overflow_para) do
        if index % 3 ~= 1 then
          (table.insert)(transPara, value)
        end
      end
    else
      do
        do
          transPara = itemCfg.overflow_para
          if not (#transPara % 2) == 0 then
            error("this overflow type has error para")
          end
          for i,v in ipairs(transPara) do
            if i % 2 == 1 then
              (table.insert)(trans_id, v)
            else
              ;
              (table.insert)(trans_num, v * self._itemTransNum)
            end
          end
          do return true, trans_id, trans_num end
          return false
        end
      end
    end
  end
end

UICommonRewardItem.BindRewardItemAthUid = function(self, uid)
  -- function num : 0_8
  (self.baseItem):BindAthItemUid(uid)
end

UICommonRewardItem.BindRewardClickCustomArg = function(self, arg)
  -- function num : 0_9
  (self.baseItem):BindClickCustomArg(arg)
end

UICommonRewardItem.BindRewardResloader = function(self, resloader)
  -- function num : 0_10
  (self.baseItem):BindBaseItemResloader(resloader)
end

UICommonRewardItem._PlayTween = function(self, itemList)
  -- function num : 0_11 , upvalues : cs_DoTween, _ENV, CS_CanvasGroup, cs_LoopTypeYoyo
  if self.tweenSeq ~= nil then
    (self.tweenSeq):Kill()
    self.tweenSeq = nil
  end
  local tweenSeq = (cs_DoTween.Sequence)()
  for index,item in ipairs(itemList) do
    if item.fade == nil then
      item.fade = (item.gameObject):AddComponent(typeof(CS_CanvasGroup))
      -- DECOMPILER ERROR at PC24: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (item.fade).alpha = 1
    else
      -- DECOMPILER ERROR at PC27: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (item.fade).alpha = 1
    end
    if index == 1 then
      tweenSeq:Append(((item.fade):DOFade(0, 0.9)):SetDelay(0.9))
    else
      tweenSeq:Join((((item.fade):DOFade(0, 0.9)):From()):SetDelay(index * 0.35))
    end
  end
  tweenSeq:SetLoops(-1, cs_LoopTypeYoyo)
  self.tweenSeq = tweenSeq
end

UICommonRewardItem.OnDelete = function(self)
  -- function num : 0_12 , upvalues : base
  if self.tweenSeq ~= nil then
    (self.tweenSeq):Kill()
    self.tweenSeq = nil
  end
  ;
  (base.OnDelete)(self)
end

return UICommonRewardItem

