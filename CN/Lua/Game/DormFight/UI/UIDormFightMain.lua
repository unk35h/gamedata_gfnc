-- params : ...
-- function num : 0 , upvalues : _ENV
local cs_ResLoader = CS.ResLoader
local UIDormFightMain = class("UIDormFightMain", UIBaseWindow)
local UIDormFighterInfoNode = require("Game.DormFight.UI.UIDormFighterInfoNode")
local CS_pvpFightManager_ins = (CS.PvpFightManager).Instance
local equipWeaponState = CS.EquipWeaponState
UIDormFightMain.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_ResLoader, _ENV, UIDormFighterInfoNode
  self._resLoader = (cs_ResLoader.Create)()
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_attack, self, self.OnAttackBtnClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_weapon, self, self.OnWeaponBtnClick)
  ;
  (((self.ui).btn_run).onPressDown):AddListener(BindCallback(self, self.OnRunBtnPressDown))
  ;
  (((self.ui).btn_run).onPressUp):AddListener(BindCallback(self, self.OnRunBtnPressUp))
  ;
  ((self.ui).joystick):onTouchMove("+", BindCallback(self, self.OnJoyStickMove))
  ;
  ((self.ui).joystick):onTouchUp("+", BindCallback(self, self.OnJoyStickUp))
  self.selfInfoItemNode = (UIDormFighterInfoNode.New)()
  ;
  (self.selfInfoItemNode):Init((self.ui).userInfoItem)
  self.enemyInfoItemNode = (UIDormFighterInfoNode.New)()
  ;
  (self.enemyInfoItemNode):Init((self.ui).friendInfoItem)
end

UIDormFightMain.InitDormFightMain = function(self, roomInfo, resLoader)
  -- function num : 0_1 , upvalues : CS_pvpFightManager_ins, _ENV
  ((self.ui).obj_gamePanel):SetActive(true)
  self.CS_pvpController = CS_pvpFightManager_ins.PvpFightController
  ;
  (((self.ui).btn_weapon).gameObject):SetActive(false)
  local selfFightersSkinId = {300200, 302200, 301303}
  local enemyFightersSkinId = {300200, 302200, 301303}
  local selfFightersHeadSpriteList = {}
  for i = 1, #selfFightersSkinId do
    local skinId = selfFightersSkinId[i]
    local headResName = self:GetFighterHeadPath(skinId)
    if (string.IsNullOrEmpty)(headResName) ~= nil then
      local sprite = CRH:GetSprite(headResName, CommonAtlasType.HeroHeadIcon)
      ;
      (table.insert)(selfFightersHeadSpriteList, sprite)
    end
  end
  ;
  (self.selfInfoItemNode):InitUIDormFighterInfoNode("玩家1", selfFightersHeadSpriteList)
  ;
  (self.enemyInfoItemNode):InitUIDormFighterInfoNode("玩家2", selfFightersHeadSpriteList)
end

UIDormFightMain.GetFighterHeadPath = function(self, skinId)
  -- function num : 0_2 , upvalues : _ENV
  local heroId = ((PlayerDataCenter.skinData):GetHeroIdBySkinId(skinId))
  -- DECOMPILER ERROR at PC5: Overwrote pending register: R3 in 'AssignReg'

  local heroCfg = .end
  if PlayerDataCenter:ContainsHeroData(heroId) then
    heroCfg = PlayerDataCenter:GetHeroData(heroId)
  end
  local resName = nil
  do
    if skinId or 0 ~= 0 then
      local skinCfg = (ConfigData.skin)[skinId]
      if skinCfg ~= nil and not (string.IsNullOrEmpty)(skinCfg.src_id_icon) then
        resName = skinCfg.src_id_icon
      end
    end
    do
      if (string.IsNullOrEmpty)(resName) and heroCfg.fragment ~= nil then
        local itemCfg = (ConfigData.item)[heroCfg.fragment]
        if itemCfg ~= nil then
          resName = itemCfg.icon
        end
      end
      return resName
    end
  end
end

UIDormFightMain.FighterRetired = function(self, isSelf, index)
  -- function num : 0_3
  if isSelf then
    (self.selfInfoItemNode):FighterRetired(index)
  else
    ;
    (self.enemyInfoItemNode):FighterRetired(index)
  end
end

UIDormFightMain.UpDateCountDown = function(self, count, limit)
  -- function num : 0_4 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).tex_CountDown).text = TimeUtil:TimestampToTime(limit - count)
end

UIDormFightMain.SetMainFighterController = function(self, fighterController)
  -- function num : 0_5 , upvalues : _ENV
  if not IsNull(fighterController) then
    self.netCharacter = fighterController.NetCharacter
    self.fighterController = fighterController
    self.weaponController = (self.netCharacter):GetComponent(typeof(CS.WeaponController))
  end
end

UIDormFightMain.ExitButtonClicked = function(self)
  -- function num : 0_6
end

UIDormFightMain.OnAttackBtnClick = function(self)
  -- function num : 0_7 , upvalues : _ENV, equipWeaponState
  if IsNull(self.netCharacter) or IsNull(self.fighterController) then
    return 
  end
  if (self.fighterController).IsDead then
    (self.fighterController):NetRevive()
    return 
  end
  do
    if not IsNull(self.weaponController) then
      local weaponState = (self.weaponController).weaponState
      if weaponState == equipWeaponState.EquipWeapon then
        (self.weaponController):NetThrowWeapon()
        return 
      end
    end
    local animator = (self.fighterController).FighterAnimator
    local isAttacking = (animator:GetCurrentAnimatorStateInfo(0)):IsTag("attack")
    local time = (animator:GetCurrentAnimatorStateInfo(0)).normalizedTime
    if (animator:GetCurrentAnimatorStateInfo(0)):IsTag("Default") or isAttacking and time > 0.5 then
      (self.fighterController):FindTarget()
      if (self.fighterController).IsRun then
        return 
      end
      local roleEntity = (self.netCharacter).roleEntity
      if roleEntity.ep < roleEntity.epReduceByAttack then
        return 
      end
      ;
      (self.fighterController):NetAttack()
    end
  end
end

UIDormFightMain.OnUpdateBtnWeapon = function(self, netCharacter)
  -- function num : 0_8 , upvalues : _ENV, equipWeaponState
  if IsNull(self.netCharacter) or IsNull(self.fighterController) then
    return 
  end
  if not (self.netCharacter).IsOwnedBySelf or self.netCharacter ~= netCharacter then
    return 
  end
  local TouchingWeapons = (self.weaponController).TouchingWeapons
  local weaponState = (self.weaponController).weaponState
  if TouchingWeapons.Count > 0 or weaponState == equipWeaponState.EquipWeapon then
    (((self.ui).btn_weapon).gameObject):SetActive(true)
  else
    ;
    (((self.ui).btn_weapon).gameObject):SetActive(false)
  end
  if weaponState == equipWeaponState.NoWeapon and TouchingWeapons.Count > 0 then
    ((self.ui).img_weaponImage):SetIndex(0)
  else
    if weaponState == equipWeaponState.EquipWeapon and TouchingWeapons.Count == 0 then
      ((self.ui).img_weaponImage):SetIndex(1)
    else
      if weaponState == equipWeaponState.EquipWeapon and TouchingWeapons.Count > 0 then
        ((self.ui).img_weaponImage):SetIndex(2)
      end
    end
  end
end

UIDormFightMain.OnWeaponBtnClick = function(self)
  -- function num : 0_9 , upvalues : _ENV, equipWeaponState
  if IsNull(self.netCharacter) or IsNull(self.fighterController) then
    return 
  end
  if (self.fighterController).IsDead then
    return 
  end
  local touchingWeapons = (self.weaponController).TouchingWeapons
  local weaponState = (self.weaponController).weaponState
  if (((self.weaponController).animator):GetCurrentAnimatorStateInfo(0)):IsTag("Default") then
    if weaponState == equipWeaponState.NoWeapon and touchingWeapons.Count > 0 then
      (self.weaponController):NetPickUpWeapon(touchingWeapons[0])
    else
      if weaponState == equipWeaponState.EquipWeapon and touchingWeapons.Count == 0 then
        (self.weaponController):NetThrowWeapon()
      else
        if weaponState == equipWeaponState.EquipWeapon and touchingWeapons.Count > 0 then
          (self.weaponController):NetThrowWeapon()
          ;
          (self.weaponController):NetPickUpWeapon(touchingWeapons[0])
        end
      end
    end
  end
end

UIDormFightMain.OnUpdateBtnRun = function(self, netCharacter)
  -- function num : 0_10 , upvalues : _ENV
  if IsNull(self.netCharacter) or IsNull(self.fighterController) then
    return 
  end
  if not (self.netCharacter).IsOwnedBySelf or self.netCharacter ~= netCharacter then
    return 
  end
  local roleEntity = (self.netCharacter).roleEntity
  local isInteractable = roleEntity.epReduceByRunPerSecond <= roleEntity.ep
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).btn_run).interactable = isInteractable
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIDormFightMain.OnRunBtnPressDown = function(self)
  -- function num : 0_11 , upvalues : _ENV
  if IsNull(self.netCharacter) or IsNull(self.fighterController) then
    return 
  end
  local roleEntity = (self.netCharacter).roleEntity
  if roleEntity.ep <= 0 then
    return false
  end
  ;
  (self.fighterController):NetRun()
end

UIDormFightMain.OnRunBtnPressUp = function(self)
  -- function num : 0_12 , upvalues : _ENV
  if IsNull(self.netCharacter) or IsNull(self.fighterController) then
    return 
  end
  self:OnUpdateBtnRun(self.netCharacter)
  if (self.fighterController).IsDead then
    return 
  end
  ;
  (self.fighterController):NetStopRun()
end

UIDormFightMain.OnJoyStickMove = function(self, joyStickData)
  -- function num : 0_13 , upvalues : _ENV
  if IsNull(self.netCharacter) or IsNull(self.fighterController) then
    return 
  end
  local radians = joyStickData.radians
  local radius = joyStickData.power
  local dir = Vector3.zero
  if radius >= 0.1 then
    local axisH = (math.cos)(radians) * radius
    local axisV = (math.sin)(radians) * radius
    dir = (Vector3.New)(axisH, 0, axisV)
  end
  do
    ;
    (self.fighterController):SetMoveVector(dir, radius)
  end
end

UIDormFightMain.OnJoyStickUp = function(self)
  -- function num : 0_14 , upvalues : _ENV
  if IsNull(self.netCharacter) or IsNull(self.fighterController) then
    return 
  end
  ;
  (self.fighterController):SetMoveVector(Vector3.zero, 0)
end

UIDormFightMain.OnDelete = function(self)
  -- function num : 0_15 , upvalues : _ENV
  (UIBaseWindow.OnDelete)(self)
  if self._resLoader ~= nil then
    (self._resLoader):Put2Pool()
    self._resLoader = nil
  end
end

return UIDormFightMain

