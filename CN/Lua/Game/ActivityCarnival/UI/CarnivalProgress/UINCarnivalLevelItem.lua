-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINCarnivalLevelItem = class("UINCarnivalLevelItem", base)
local UINCarnivalLevelRewardItem = require("Game.ActivityCarnival.UI.CarnivalProgress.UINCarnivalLevelRewardItem")
UINCarnivalLevelItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINCarnivalLevelRewardItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_RewardBg, self, self._OnClickPickReward)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Unlock, self, self.OnClickJump)
  self.rewardItemPool = (UIItemPool.New)(UINCarnivalLevelRewardItem, (self.ui).rewardItem, false)
end

UINCarnivalLevelItem.InitCarnivalLevelItem = function(self, carnivalData, levelData, isPicked, pickRewardFunc, jumpFunc)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R6 in 'UnsetPending'

  ((self.ui).tex_Level).text = tostring(levelData.level)
  self._carnivalData = carnivalData
  self._pickRewardFunc = pickRewardFunc
  self._jumpFunc = jumpFunc
  self._levelData = levelData
  local unlock = levelData.level <= levelData.curLevel
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).canvasGroup).alpha = unlock and 1 or 0.5
  local pickable = (not isPicked and unlock)
  self._pickable = pickable
  ;
  (self.rewardItemPool):HideAll()
  for k,itemId in ipairs((levelData.carnivalExpCfg).rewardIds) do
    local itemNum = ((levelData.carnivalExpCfg).rewardNums)[k]
    local rewardItem = (self.rewardItemPool):GetOne()
    local clickEvent = pickable and BindCallback(self, self._OnClickPickReward) or nil
    rewardItem:InitCarnivalLevelRewardItem(itemId, itemNum, clickEvent, isPicked, pickable)
  end
  -- DECOMPILER ERROR at PC74: Confused about usage of register: R8 in 'UnsetPending'

  if not pickable or not (self.ui).color_pickable then
    ((self.ui).img_RewardBg).color = (self.ui).color_cantPick
    self:_UpdExpBar(levelData)
    self:_UpdUnlock(levelData)
    -- DECOMPILER ERROR: 10 unprocessed JMP targets
  end
end

UINCarnivalLevelItem._UpdExpBar = function(self, levelData)
  -- function num : 0_2 , upvalues : _ENV
  local showExpBar = true
  if levelData.maxLevel <= levelData.level then
    showExpBar = false
  else
    if levelData.curLevel == levelData.level then
      local curExp = levelData.curExp
      local totalExp = (levelData.carnivalExpCfg).need_exp
      -- DECOMPILER ERROR at PC17: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.ui).img_ExpProgress).fillAmount = curExp / totalExp
      ;
      ((self.ui).tex_ExpProgress):SetIndex(0, tostring(curExp), tostring(totalExp))
      ;
      (((self.ui).tex_ExpProgress).gameObject):SetActive(true)
    else
      do
        if levelData.level < levelData.curLevel then
          (((self.ui).tex_ExpProgress).gameObject):SetActive(false)
          -- DECOMPILER ERROR at PC48: Confused about usage of register: R3 in 'UnsetPending'

          ;
          ((self.ui).img_ExpProgress).fillAmount = 1
        else
          ;
          (((self.ui).tex_ExpProgress).gameObject):SetActive(false)
          -- DECOMPILER ERROR at PC58: Confused about usage of register: R3 in 'UnsetPending'

          ;
          ((self.ui).img_ExpProgress).fillAmount = 0
        end
        ;
        ((self.ui).obj_Exp):SetActive(showExpBar)
      end
    end
  end
end

UINCarnivalLevelItem._UpdUnlock = function(self, levelData)
  -- function num : 0_3 , upvalues : _ENV
  local hasUnlock = true
  local levelEnvDic = ((ConfigData.activity_carnival_env).levelEnvDic)[(self._carnivalData):GetActId()]
  if (levelData.carnivalExpCfg).unlock_story > 0 then
    local storyCfg = (ConfigData.story_avg)[(levelData.carnivalExpCfg).unlock_story]
    ;
    ((self.ui).obj_StoryIcon):SetActive(true)
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(storyCfg.name)
    ;
    ((self.ui).tex_Number):SetIndex(0, tostring(storyCfg.number))
    ;
    ((self.ui).tex_Title):SetIndex(0)
  else
    do
      if (levelData.carnivalExpCfg).unlock_sector_stage > 0 then
        local stageCfg = (ConfigData.sector_stage)[(levelData.carnivalExpCfg).unlock_sector_stage]
        ;
        ((self.ui).obj_StoryIcon):SetActive(true)
        -- DECOMPILER ERROR at PC63: Confused about usage of register: R5 in 'UnsetPending'

        ;
        ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(stageCfg.name)
        ;
        ((self.ui).tex_Number):SetIndex(0, tostring(stageCfg.num))
        ;
        ((self.ui).tex_Title):SetIndex(0)
      else
        do
          if levelEnvDic[levelData.level] ~= nil then
            local envCfg = (self._carnivalData):GetCarnivalEnvCfgById(levelEnvDic[levelData.level])
            ;
            ((self.ui).obj_StoryIcon):SetActive(false)
            -- DECOMPILER ERROR at PC98: Confused about usage of register: R5 in 'UnsetPending'

            ;
            ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(envCfg.env_name)
            ;
            ((self.ui).tex_Number):SetIndex(1, tostring(envCfg.id))
            ;
            ((self.ui).tex_Title):SetIndex(1)
          else
            do
              hasUnlock = false
              ;
              ((self.ui).obj_Unlock):SetActive(hasUnlock)
            end
          end
        end
      end
    end
  end
end

UINCarnivalLevelItem._OnClickPickReward = function(self)
  -- function num : 0_4
  if self._pickable and self._pickRewardFunc ~= nil then
    (self._pickRewardFunc)((self._levelData).level)
  end
end

UINCarnivalLevelItem.OnClickJump = function(self)
  -- function num : 0_5
  if self._jumpFunc ~= nil then
    (self._jumpFunc)(self._levelData)
  end
end

UINCarnivalLevelItem.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (self.rewardItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINCarnivalLevelItem

