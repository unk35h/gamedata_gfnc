-- params : ...
-- function num : 0 , upvalues : _ENV
local UITipsCacheItem = class("UISideTipsItem", UIBaseNode)
local base = UIBaseNode
local eCacheState = require("Game.Message.Side.eCacheState")
local cs_DoTween = ((CS.DG).Tweening).DOTween
UITipsCacheItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._onFadeOut = BindCallback(self, self._FadeOutTween)
  self._onFadeIn = BindCallback(self, self._FadeInTween)
  self._onSeqComplete = BindCallback(self, self._SeqComplete)
  self._offsetY = ((self.transform).rect).height
  self._halfOffsetY = self._offsetY / 2
  self._showTime = 0.3
  self._oriposition = (self.transform).position
end

UITipsCacheItem.InitTipsCacheItem = function(self, msgData, uiMessageSide)
  -- function num : 0_1
  self.msgData = msgData
  self.uiMessageSide = uiMessageSide
  self:_InitData(msgData)
  self:_InitUI(msgData)
  self:_InitTweenSeq()
end

UITipsCacheItem._InitData = function(self, msgData)
  -- function num : 0_2 , upvalues : eCacheState
  self._waitSecond = msgData.waitTime
  self.curState = eCacheState.FadeIn
end

UITipsCacheItem._InitUI = function(self, msgData)
  -- function num : 0_3 , upvalues : _ENV
  (self.transform):SetAsLastSibling()
  ;
  ((self.ui).obj_efficiency):SetActive(false)
  ;
  ((self.ui).obj_normal):SetActive(false)
  ;
  ((self.ui).obj_isCommonMessage):SetActive(false)
  local content = msgData.content
  if msgData.tipsType == eMessageSideType.normal or msgData.tipsType == nil then
    ((self.ui).obj_normal):SetActive(true)
    -- DECOMPILER ERROR at PC34: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Content).text = content
  else
    if msgData.tipsType == eMessageSideType.efficiency then
      ((self.ui).obj_efficiency):SetActive(true)
      local class = type(content)
      do
        do
          if class == "number" then
            local color = Color.white
            if content > 0 then
              color = (self.ui).col_orange
              content = "+" .. tostring(content)
            else
              color = (self.ui).col_red
              content = tostring(content)
            end
            -- DECOMPILER ERROR at PC71: Confused about usage of register: R5 in 'UnsetPending'

            ;
            ((self.ui).tex_EfficiencyNum).color = color
          end
          -- DECOMPILER ERROR at PC74: Confused about usage of register: R4 in 'UnsetPending'

          ;
          ((self.ui).tex_EfficiencyNum).text = content
          if msgData.tipsType == eMessageSideType.ecParameter then
            ((self.ui).obj_isCommonMessage):SetActive(true)
            local itemId = content.itemId
            local addNum = content.num
            if itemId == nil or addNum == nil then
              error("ecParameter cfg is wrong itemId:" .. tostring(itemId))
              return 
            end
            local itemCfg = (ConfigData.item)[itemId]
            if itemCfg == nil then
              error("ecParameter itemCfg cfg is wrong itemId:" .. tostring(itemId))
              return 
            end
            -- DECOMPILER ERROR at PC119: Confused about usage of register: R6 in 'UnsetPending'

            ;
            ((self.ui).img_common).sprite = CRH:GetSprite(itemCfg.icon)
            -- DECOMPILER ERROR at PC126: Confused about usage of register: R6 in 'UnsetPending'

            ;
            ((self.ui).tex_commonName).text = (LanguageUtil.GetLocaleText)(itemCfg.name)
            -- DECOMPILER ERROR at PC134: Confused about usage of register: R6 in 'UnsetPending'

            ;
            ((self.ui).tex_commonNum).text = "+" .. tostring(addNum)
          end
        end
      end
    end
  end
end

UITipsCacheItem._InitTweenSeq = function(self)
  -- function num : 0_4 , upvalues : cs_DoTween, eCacheState
  if self._tweenSeq ~= nil then
    (self._tweenSeq):Restart(false)
  else
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).fade).alpha = 0
    local tweenSeq = (cs_DoTween.Sequence)()
    tweenSeq:SetAutoKill(false)
    tweenSeq:SetUpdate(true)
    tweenSeq:InsertCallback(0, self._onFadeIn)
    tweenSeq:AppendInterval(self._showTime)
    tweenSeq:AppendCallback(function()
    -- function num : 0_4_0 , upvalues : self, eCacheState
    self.curState = eCacheState.Show
  end
)
    tweenSeq:AppendInterval(self._waitSecond)
    tweenSeq:AppendCallback(self._onFadeOut)
    tweenSeq:AppendInterval(self._showTime)
    tweenSeq:OnComplete(self._onSeqComplete)
    self._tweenSeq = tweenSeq
  end
end

UITipsCacheItem._FadeInTween = function(self)
  -- function num : 0_5
  ((self.ui).fade):DOKill()
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).fade).alpha = 1
  ;
  (((self.ui).fade):DOFade(0, self._showTime)):From()
  ;
  (self.transform):DOKill()
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R1 in 'UnsetPending'

  if not (self.IsLayout)(self.msgData) then
    (self.transform).position = self._oriposition
  end
  ;
  (((self.transform):DOLocalMoveX(((self.transform).sizeDelta).x * 1.1, self._showTime)):From(true)):SetRelative(true)
end

UITipsCacheItem._FadeOutTween = function(self)
  -- function num : 0_6 , upvalues : eCacheState
  if self.curState == eCacheState.Show then
    self.curState = eCacheState.FadeOut
    ;
    ((self.ui).fade):DOKill()
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).fade).alpha = 1
    ;
    ((self.ui).fade):DOFade(0, self._showTime)
    if (self.IsLayout)(self.msgData) then
      (self.transform):SetParent(((self.uiMessageSide).ui).NormalParent)
      ;
      (((self.uiMessageSide).ui).layout):SetLayoutVertical()
    end
    ;
    (self.transform):DOAnchorPosY(self._halfOffsetY, self._showTime)
  end
end

UITipsCacheItem._SeqComplete = function(self)
  -- function num : 0_7 , upvalues : eCacheState
  if self.curState == eCacheState.Useless then
    return 
  end
  ;
  (self._tweenSeq):Complete(false)
  ;
  (self.transform):DOKill()
  ;
  ((self.ui).fade):DOKill()
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).fade).alpha = 0
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.transform).position = self._oriposition
  self.curState = eCacheState.Useless
end

UITipsCacheItem.IsLayout = function(msgData)
  -- function num : 0_8 , upvalues : _ENV
  if msgData.tipsType == eMessageSideType.ecParameter then
    return true
  end
end

UITipsCacheItem.OnDelete = function(self)
  -- function num : 0_9 , upvalues : base
  if self._tweenSeq ~= nil then
    (self._tweenSeq):Kill(true)
    self._tweenSeq = nil
  end
  ;
  (self.transform):DOKill()
  ;
  ((self.ui).fade):DOKill()
  ;
  (base.OnDelete)(self)
end

return UITipsCacheItem

