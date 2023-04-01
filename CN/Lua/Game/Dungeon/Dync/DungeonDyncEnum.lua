-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonDyncEnum = {}
DungeonDyncEnum.DgDyncType = {None = 0, DailyDungeon = 1, WinterChallenge = 2}
DungeonDyncEnum.DgDyncType2DungeonTypeDic = {[(DungeonDyncEnum.DgDyncType).DailyDungeon] = proto_csmsg_DungeonType.DungeonType_Daily, [(DungeonDyncEnum.DgDyncType).WinterChallenge] = proto_csmsg_DungeonType.DungeonType_WinterHard}
return DungeonDyncEnum

