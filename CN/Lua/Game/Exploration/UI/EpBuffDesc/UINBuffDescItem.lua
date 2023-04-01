-- params : ...
-- function num : 0 , upvalues : _ENV
local UINBuffDescItem = class("UINBuffDescItem", UIBaseNode)
local base = UIBaseNode
local cs_Ease = ((CS.DG).Tweening).Ease
local cs_MessageCommon = CS.MessageCommon
UINBuffDescItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Root, self, self._OnClickBtnRoot)
end

UINBuffDescItem.InitBuffDescItem = function(self, epBuff)
  -- function num : 0_1
  if epBuff == nil then
    return 
  end
  local cfg = epBuff:GetBuffCfg()
  self:InitBuffDescItemByCfg(cfg)
end

UINBuffDescItem.InitBuffDescItemForWCBuff = function(self, wcBuff)
  -- function num : 0_2
  if wcBuff == nil then
    return 
  end
  local cfg = wcBuff:GetBuffCfg()
  self:InitBuffDescItemByCfg(cfg)
end

UINBuffDescItem.InitBuffDescItemByCfg = function(self, cfg)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).img_Buff).sprite = CRH:GetSprite(cfg.icon, CommonAtlasType.ExplorationIcon)
  local colIndex = cfg.buff_type + 1
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Col).color = ((self.ui).array_Col)[colIndex]
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_BuffName).text = (LanguageUtil.GetLocaleText)(cfg.name)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Desc).text = (LanguageUtil.GetLocaleText)(cfg.describe)
end

UINBuffDescItem.InitBuffDescItemSelect = function(self, epBuff, lock, onClickFunc)
  -- function num : 0_4
  self._onClickFunc = onClickFunc
  self._epBuff = epBuff
  self:SetBuffDescItemSelect(false)
  self:InitBuffDescItem(epBuff)
  ;
  ((self.ui).obj_lock):SetActive(lock)
  self._lock = lock
end

UINBuffDescItem.SetBuffDescItemSelect = function(self, select)
  -- function num : 0_5
  ((self.ui).obj_selectFrame):SetActive(select)
end

UINBuffDescItem._OnClickBtnRoot = function(self)
  -- function num : 0_6 , upvalues : cs_MessageCommon, _ENV
  if self._lock then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(409))
    return 
  end
  if self._onClickFunc ~= nil then
    (self._onClickFunc)(self, self._epBuff)
  end
end

UINBuffDescItem.StartBuffDescFlySeq = function(self, seq, pos, curPos)
  -- function num : 0_7 , upvalues : cs_Ease
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R4 in 'UnsetPending'

  ((self.ui).ly_Item).ignoreLayout = true
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.transform).localPosition = curPos
  seq:Join((((self.ui).fade):DOFade(0, 0.5)):SetEase(cs_Ease.InOutQuad))
  seq:Join(((self.transform):DOScale(0.5, 0.5)):SetEase(cs_Ease.InQuad))
  seq:Join(((self.transform):DOMove(pos, 0.5)):SetEase(cs_Ease.InQuad))
end

UINBuffDescItem.OnDelete = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnDelete)(self)
end

return UINBuffDescItem

