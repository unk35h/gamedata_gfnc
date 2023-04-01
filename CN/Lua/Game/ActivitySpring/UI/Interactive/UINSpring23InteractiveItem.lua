-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSpring23InteractiveItem = class("UINAthItem", UIBaseNode)
local base = UIBaseNode
local ActivitySpringStoryEnum = require("Game.ActivitySpring.Data.ActivitySpringStoryEnum")
local CS_EventTriggerListener = CS.EventTriggerListener
UINSpring23InteractiveItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self._OnClickRoot)
end

UINSpring23InteractiveItem.SetSpring23InteractiveItemEntt = function(self, actLbEntt)
  -- function num : 0_1
  self._actLbEntt = actLbEntt
end

UINSpring23InteractiveItem.RefreshSpring23InteractiveItem = function(self, interactCfg, costNum, CloseAni)
  -- function num : 0_2 , upvalues : _ENV, ActivitySpringStoryEnum
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R4 in 'UnsetPending'

  ((self.ui).img).color = (self.ui).normal_color
  ;
  (((self.ui).img_Interactiveglow).gameObject):SetActive(false)
  if not CloseAni then
    ((self.ui).ani):Play("UI_Spring23Interactive")
    local aniState = ((self.ui).ani):get_Item("UI_Spring23Interactive")
    local length = aniState.length
    local setTime = Time.time % length
    aniState.time = setTime
  end
  do
    -- DECOMPILER ERROR at PC35: Confused about usage of register: R4 in 'UnsetPending'

    if costNum < interactCfg.need_exp then
      ((self.ui).img).color = (self.ui).dark_color
    end
    if interactCfg.stage_id == (ActivitySpringStoryEnum.stageEnum).main then
      ((self.ui).img_type):SetIndex(0)
      if interactCfg.need_exp <= costNum and not CloseAni then
        self:_StartSEAni()
        ;
        ((self.ui).img_Interactiveglow):SetIndex(0)
      end
    else
      if interactCfg.stage_id == (ActivitySpringStoryEnum.stageEnum).side then
        ((self.ui).img_type):SetIndex(1)
        if interactCfg.need_exp <= costNum and not CloseAni then
          self:_StartSEAni()
          ;
          ((self.ui).img_Interactiveglow):SetIndex(1)
        end
      else
        if interactCfg.stage_id == (ActivitySpringStoryEnum.stageEnum).fixReward then
          ((self.ui).img_type):SetIndex(2)
        end
      end
    end
  end
end

UINSpring23InteractiveItem._StartSEAni = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (((self.ui).img_Interactiveglow).gameObject):SetActive(true)
  local length = ((self.ui).tweenAni_pick).duration * 2
  local setTime = Time.time % length
  ;
  (((self.ui).tweenAni_pick).tween):Goto(setTime, true)
end

UINSpring23InteractiveItem.SetArrowOpen = function(self, arrowDir)
  -- function num : 0_4 , upvalues : _ENV
  (((self.ui).img_Arrow_trans).gameObject):SetActive(true)
  local angle = (Vector3.Angle)(Vector3.up, arrowDir)
  local norDir = (Vector3.Cross)(Vector3.up, arrowDir)
  if norDir.z > 0 then
    angle = angle * -1
  end
  angle = angle + 45
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_Arrow_trans).rotation = (Quaternion.AngleAxis)(angle, Vector3.back)
end

UINSpring23InteractiveItem.SetArrowClose = function(self)
  -- function num : 0_5
  (((self.ui).img_Arrow_trans).gameObject):SetActive(false)
end

UINSpring23InteractiveItem.CloseAllAni = function(self)
  -- function num : 0_6 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  (((self.ui).btn_root).transform).anchoredPosition = Vector2.zero
  ;
  (((self.ui).img_Interactiveglow).gameObject):SetActive(false)
  ;
  ((self.ui).tweenAni_pick):DOPause()
  ;
  ((self.ui).ani):Stop()
end

UINSpring23InteractiveItem._OnClickRoot = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local actLbCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
  if actLbCtrl == nil then
    return 
  end
  ;
  (actLbCtrl.actLbCmderCtrl):LbCmdMove2Entt(self._actLbEntt)
end

UINSpring23InteractiveItem.OnHide = function(self)
  -- function num : 0_8
end

UINSpring23InteractiveItem.OnDelete = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnDelete)(self)
end

return UINSpring23InteractiveItem

