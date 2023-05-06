-- params : ...
-- function num : 0 , upvalues : _ENV
local UIEventAngelaGiftMain = class("UIEventAngelaGiftMain", UIBaseWindow)
local base = UIBaseWindow
local UINEventAngelaGiftSmallNode = require("Game.EventAngelaGift.UI.UINEventAngelaGiftSmallNode")
local UINEventAngelaGiftBigNode = require("Game.EventAngelaGift.UI.UINEventAngelaGiftBigNode")
local JumpManager = require("Game.Jump.JumpManager")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local CS_DOTweenAnimation = ((CS.DG).Tweening).DOTweenAnimation
UIEventAngelaGiftMain.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, JumpManager, CS_DOTweenAnimation
  (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
  self.angelaGiftController = ControllerManager:GetController(ControllerTypeId.EventAngelaGift, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_close, self, self.OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.OnClickClose)
  self._lastCouldUseItemJump = JumpManager.couldUseItemJump
  JumpManager.couldUseItemJump = false
  self._RefreshAllGift = BindCallback(self, self.RefreshAllGift)
  self.TweenDic = (self.transform):GetComponentsInChildren(typeof(CS_DOTweenAnimation))
end

UIEventAngelaGiftMain.InitEventAngelaGiftMain = function(self, actId, isPop)
  -- function num : 0_1 , upvalues : _ENV, UINEventAngelaGiftSmallNode, UINEventAngelaGiftBigNode
  self.isPop = isPop
  self.angelaGiftData = (self.angelaGiftController):GetAngelaGiftDataByActId(actId)
  if self.angelaGiftData == nil then
    return 
  end
  if not giftSteps then
    local giftSteps = {}
  end
  for index,giftInfo in ipairs((self.angelaGiftData).groupGiftInfos) do
    local giftItem = giftSteps[index]
    if giftItem == nil then
      if index >= 3 or not (UINEventAngelaGiftSmallNode.New)() then
        giftItem = (UINEventAngelaGiftBigNode.New)()
      end
      giftItem:Init(((self.ui).array_gifts)[index])
      giftSteps[index] = giftItem
    end
    giftItem:InitAngelaGiftNode(giftInfo, self._RefreshAllGift)
  end
  self.giftSteps = giftSteps
  if isPop then
    (((self.ui).tog_popup).gameObject):SetActive(true)
    ;
    (((self.ui).btn_close).gameObject):SetActive(true)
    ;
    (((self.ui).btn_background).gameObject):SetActive(true)
    local scale = (((self.ui).obj_main).transform).localScale
    scale.x = 0.9
    scale.y = 0.9
    -- DECOMPILER ERROR at PC73: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (((self.ui).obj_main).transform).localScale = scale
  else
    do
      ;
      (((self.ui).tog_popup).gameObject):SetActive(false)
      ;
      (((self.ui).btn_close).gameObject):SetActive(false)
      ;
      (((self.ui).btn_background).gameObject):SetActive(false)
      local scale = (((self.ui).obj_main).transform).localScale
      scale.x = 1
      scale.y = 1
      -- DECOMPILER ERROR at PC102: Confused about usage of register: R5 in 'UnsetPending'

      ;
      (((self.ui).obj_main).transform).localScale = scale
      ;
      (self.angelaGiftData):SetAngelaGiftDataLooked()
      for i = 0, (self.TweenDic).Length - 1 do
        local tween = (self.TweenDic)[i]
        tween:DOComplete()
      end
      do
        self:RefreshAllGift()
      end
    end
  end
end

UIEventAngelaGiftMain.SetCloseCallback = function(self, closeCallback)
  -- function num : 0_2
  self._closeCallback = closeCallback
end

UIEventAngelaGiftMain.OnStepChange = function(self, step)
  -- function num : 0_3 , upvalues : _ENV
  (((self.ui).tex_des).gameObject):SetActive(true)
  ;
  (((self.ui).tex_subDes).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  if step == 1 then
    ((self.ui).tex_des).text = ConfigData:GetTipContent(7900)
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_subDes).text = ConfigData:GetTipContent(7903)
  else
    -- DECOMPILER ERROR at PC37: Confused about usage of register: R2 in 'UnsetPending'

    if step == 2 then
      ((self.ui).tex_des).text = ConfigData:GetTipContent(7901)
      -- DECOMPILER ERROR at PC44: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.ui).tex_subDes).text = ConfigData:GetTipContent(7904)
    else
      -- DECOMPILER ERROR at PC54: Confused about usage of register: R2 in 'UnsetPending'

      if step == 3 then
        ((self.ui).tex_des).text = ConfigData:GetTipContent(7902)
        ;
        (((self.ui).tex_subDes).gameObject):SetActive(false)
      else
        -- DECOMPILER ERROR at PC68: Confused about usage of register: R2 in 'UnsetPending'

        ;
        ((self.ui).tex_des).text = ConfigData:GetTipContent(7902)
        ;
        (((self.ui).tex_subDes).gameObject):SetActive(false)
        if self.isPop then
          self:OnClickClose()
        end
      end
    end
  end
end

UIEventAngelaGiftMain.RefreshAllGift = function(self)
  -- function num : 0_4 , upvalues : _ENV, UINEventAngelaGiftSmallNode
  local currentStep = (self.angelaGiftData):GetGroupGiftCurrentStep()
  for step,giftItem in ipairs(self.giftSteps) do
    if step < currentStep then
      giftItem:SetAngelaGiftState((UINEventAngelaGiftSmallNode.eGiftState).Picked)
    else
      if currentStep < step then
        giftItem:SetAngelaGiftState((UINEventAngelaGiftSmallNode.eGiftState).Locked)
      else
        giftItem:SetAngelaGiftState((UINEventAngelaGiftSmallNode.eGiftState).CanBuy)
      end
    end
  end
  self:OnStepChange(currentStep)
end

UIEventAngelaGiftMain.BackAction = function(self)
  -- function num : 0_5
  self:Delete()
end

UIEventAngelaGiftMain.OnClickClose = function(self)
  -- function num : 0_6 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIEventAngelaGiftMain.OnDelete = function(self)
  -- function num : 0_7 , upvalues : JumpManager, base
  JumpManager.couldUseItemJump = self._lastCouldUseItemJump
  if ((self.ui).tog_popup).isOn then
    (self.angelaGiftData):SetAngelaGiftDataCantPopToday()
  end
  if self._closeCallback ~= nil then
    (self._closeCallback)()
  end
  ;
  (base.OnDelete)(self)
end

return UIEventAngelaGiftMain

