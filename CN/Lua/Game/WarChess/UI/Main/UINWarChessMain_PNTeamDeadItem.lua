-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessMain_PNTeamDeadItem = class("UINWarChessMain_PNTeamDeadItem", base)
UINWarChessMain_PNTeamDeadItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWarChessMain_PNTeamDeadItem.InitWCPlayTeamItem = function(self, teamData, wcCtrl, resloader)
  -- function num : 0_1 , upvalues : _ENV
  self.teamData = teamData
  self.resloader = resloader
  self.wcCtrl = wcCtrl
  local index = (self.teamData):GetWCTeamIndex()
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.gameObject).name = tostring(index)
  self:RefreshTeamLeaderPic()
  self:RefreshTeamPower()
end

UINWarChessMain_PNTeamDeadItem.RefreshTeamLeaderPic = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local firstHeroId = (self.teamData):GetFirstHeroId()
  local dynHeroData = ((self.wcCtrl).teamCtrl):GetHeroDynDataById(firstHeroId)
  if dynHeroData == nil then
    error("team leader data not exist")
    return 
  end
  ;
  (self.resloader):LoadABAssetAsync(PathConsts:GetCharacterPicPath(dynHeroData:GetResPicName()), function(texture)
    -- function num : 0_2_0 , upvalues : _ENV, self
    if IsNull(self.transform) or IsNull(texture) then
      return 
    end
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_TeamHeroPic).texture = texture
  end
)
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_TeamName).text = (self.teamData):GetWCTeamName()
end

UINWarChessMain_PNTeamDeadItem.RefreshTeamPower = function(self)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_Power).text = tostring(0)
end

UINWarChessMain_PNTeamDeadItem.OnDelete = function(self)
  -- function num : 0_4
end

return UINWarChessMain_PNTeamDeadItem

