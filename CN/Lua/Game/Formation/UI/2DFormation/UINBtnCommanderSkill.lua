-- params : ...
-- function num : 0 , upvalues : _ENV
local UINBtnCommanderSkill = class("UINBtnCommanderSkill", UIBaseNode)
local base = UIBaseNode
local cs_MessageCommon = CS.MessageCommon
local UINCommanderSkill = require("Game.Formation.UI.2DFormation.UINCommanderSkill")
local CommanderSkillTreeData = require("Game.CommanderSkill.CommanderSkillTreeData")
UINBtnCommanderSkill.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINCommanderSkill
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_CommanderSkill, self, self.OnClickItem)
  ;
  ((self.ui).skillItem):SetActive(false)
  self.itemPool = (UIItemPool.New)(UINCommanderSkill, (self.ui).skillItem)
  ;
  ((self.ui).redDot):SetActive(false)
end

UINBtnCommanderSkill.InitBtnCommanderSkill = function(self, resloader, clickFunc)
  -- function num : 0_1
  self.resloader = resloader
  self.clickFunc = clickFunc
end

UINBtnCommanderSkill.InitBtnCommanderSkill4FmtCtrl = function(self, fmtCtrl, enterFmtData)
  -- function num : 0_2
  self.fmtCtrl = fmtCtrl
  self.enterFmtData = enterFmtData
  self.resloader = fmtCtrl:GetFmtCtrlResloader()
end

UINBtnCommanderSkill.RefreshCstByTreeInfo = function(self, cstTreeData)
  -- function num : 0_3
  self.cstTreeData = cstTreeData
  self.treeId = cstTreeData.treeId
  self.skills = cstTreeData:GetUsingCmdSkillList()
  self.isFixed = false
  self:__RefreshCstBtnUI()
end

UINBtnCommanderSkill.RefreshCstByIdAndList = function(self, treeId, skills, isFixed)
  -- function num : 0_4 , upvalues : CommanderSkillTreeData
  do
    if not isFixed and treeId ~= 0 then
      local fmtCSTData = (CommanderSkillTreeData.New)(treeId)
      fmtCSTData:ApplySavingData(skills)
      self.cstTreeData = fmtCSTData
    end
    self.treeId = treeId
    self.skills = skills
    self.isFixed = isFixed
    self:__RefreshCstBtnUI()
  end
end

UINBtnCommanderSkill.__RefreshCstBtnUI = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local treeCfg = (ConfigData.commander_skill)[self.treeId]
  if treeCfg == nil or self.isFixed then
    (((self.ui).img_ComSkillIcon).gameObject):SetActive(false)
    ;
    ((self.ui).tex_ComSkillName):SetIndex(1)
  else
    local treeName = (LanguageUtil.GetLocaleText)(treeCfg.name)
    ;
    ((self.ui).tex_ComSkillName):SetIndex(0, treeName)
    ;
    (((self.ui).img_ComSkillIcon).gameObject):SetActive(false)
    ;
    (self.resloader):LoadABAssetAsync(PathConsts:GetAtlasAssetPath("CommanderSkillIcons"), function(spriteAtlas)
    -- function num : 0_5_0 , upvalues : self, _ENV, treeCfg
    if spriteAtlas == nil then
      return 
    end
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_ComSkillIcon).sprite = (AtlasUtil.GetResldSprite)(spriteAtlas, treeCfg.icon)
    ;
    (((self.ui).img_ComSkillIcon).gameObject):SetActive(true)
  end
)
  end
  do
    ;
    (self.itemPool):HideAll()
    local cstUnlockCfg = (ConfigData.commander_skill_unlock)[self.treeId or 0]
    if cstUnlockCfg ~= nil then
      (table.sort)(self.skills, function(a, b)
    -- function num : 0_5_1 , upvalues : cstUnlockCfg, _ENV
    local aCfg = cstUnlockCfg[a]
    local bCfg = cstUnlockCfg[b]
    local aPlace = math.maxinteger
    local bPlace = math.maxinteger
    if aCfg ~= nil then
      aPlace = aCfg.place
    end
    if bCfg ~= nil then
      bPlace = bCfg.place
    end
    if aPlace >= bPlace then
      do return aPlace == bPlace end
      do return a < b end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
    end
    if self.skills ~= nil and #self.skills > 0 then
      for index,skillId in ipairs(self.skills) do
        if cstUnlockCfg ~= nil and cstUnlockCfg[skillId] ~= nil then
          local item = (self.itemPool):GetOne()
          -- DECOMPILER ERROR at PC85: Confused about usage of register: R9 in 'UnsetPending'

          ;
          (item.gameObject).name = tostring(index)
          item:InitCommanderSkill(skillId, self.resloader)
        end
      end
    end
    do
      if not self.isFixed then
        local hasOverloadSkill2Install = (self.cstTreeData):CSTHasOverloadSkill2Install()
        ;
        ((self.ui).redDot):SetActive(hasOverloadSkill2Install)
      end
    end
  end
end

UINBtnCommanderSkill.GetCmderSkillItemByIndex = function(self, index)
  -- function num : 0_6
  return ((self.itemPool).listItem)[index]
end

UINBtnCommanderSkill.SetCmderRootRaycastActive = function(self, active)
  -- function num : 0_7
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).cg_CmderSkill).blocksRaycasts = active
end

UINBtnCommanderSkill.OnClickItem = function(self)
  -- function num : 0_8 , upvalues : cs_MessageCommon, _ENV
  if self.clickFunc ~= nil then
    (self.clickFunc)(self.cstTreeData)
    return 
  end
  local isFixed, skills = (self.enterFmtData):GetFixedCstSkills()
  if isFixed then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.CstFixed))
    return 
  end
  local cmdSkillData = (self.fmtCtrl):GetFmtCtrlFmtCSTData()
  local commanderSkillCtrl = ControllerManager:GetController(ControllerTypeId.CommanderSkill, true)
  commanderSkillCtrl:InitCmdSkillCtrl(cmdSkillData, function()
    -- function num : 0_8_0 , upvalues : self
    (self.fmtCtrl):OnFmtCloseCSTUI()
  end
, function(saveData)
    -- function num : 0_8_1 , upvalues : self
    (self.fmtCtrl):SaveFmtCSTChange(saveData)
  end
, function()
    -- function num : 0_8_2 , upvalues : self
    (self.fmtCtrl):OnFmtOpenCSTUI()
  end
)
end

return UINBtnCommanderSkill

