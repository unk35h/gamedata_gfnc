-- params : ...
-- function num : 0 , upvalues : _ENV
local UINBattleBuffStatusItem = class("UINBattleBuffStatusItem", UIBaseNode)
UINBattleBuffStatusItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINBattleBuffStatusItem.InitCSBattleBuff = function(self, csBattleBuff)
  -- function num : 0_1 , upvalues : _ENV
  local battleBuffCfg = (ConfigData.battle_buff)[csBattleBuff.dataId]
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).image).sprite = CRH:GetSprite(battleBuffCfg.icon, CommonAtlasType.ExplorationIcon)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Title).text = (LanguageUtil.GetLocaleText)(battleBuffCfg.name)
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)(battleBuffCfg.describe)
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R3 in 'UnsetPending'

  if battleBuffCfg.buff_type ~= eBuffType.Debeneficial or not (self.ui).red then
    ((self.ui).title).color = (self.ui).green
    local curDurationTime = csBattleBuff.curDurationTime
    if curDurationTime > 0 then
      ((self.ui).time):SetActive(true)
      ;
      ((self.ui).tex_Time):SetIndex(0, tostring((BattleUtil.FrameToTime)(curDurationTime)))
    else
      ;
      ((self.ui).time):SetActive(false)
    end
  end
end

return UINBattleBuffStatusItem

