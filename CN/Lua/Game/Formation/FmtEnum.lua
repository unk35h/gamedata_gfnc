-- params : ...
-- function num : 0 , upvalues : _ENV
local FmtEnum = {}
FmtEnum.FmtCtrlSate = {none = 0, parpare = 1, normal = 2, editing = 3}
FmtEnum.eFmtFromModule = {None = 0, SectorLevel = 1, FriendshipDungeon = 2, MaterialDungeon = 3, Infinity = 4, ATHDungeon = 5, PeriodicChallenge = 6, WeeklyChallenge = 7, DailyDungeon = 8, DailyDungeonLevel = 9, DungeonTower = 10, SectorIIDun = 11, SctIIDunChallenge = 12, ARDDun = 13, DungeonTwinTower = 14, CarnivalEp = 15, CarnivalDungeon = 16, ADCDungeon = 17, ActSectorIIIDun = 18, WarChess = 20, HeroGrow = 21, Season = 22, Spring = 23, SpringEp = 24, ActSeasonDun = 25}
FmtEnum.eFmtGamePlayType = {None = 0, Exploration = 1, Dungeon = 2, WarChess = 3}
local fmtModule2PlayType = {[(FmtEnum.eFmtFromModule).SectorLevel] = (FmtEnum.eFmtGamePlayType).Exploration, [(FmtEnum.eFmtFromModule).FriendshipDungeon] = (FmtEnum.eFmtGamePlayType).Dungeon, [(FmtEnum.eFmtFromModule).MaterialDungeon] = (FmtEnum.eFmtGamePlayType).Dungeon, [(FmtEnum.eFmtFromModule).Infinity] = (FmtEnum.eFmtGamePlayType).Exploration, [(FmtEnum.eFmtFromModule).ATHDungeon] = (FmtEnum.eFmtGamePlayType).Dungeon, [(FmtEnum.eFmtFromModule).PeriodicChallenge] = (FmtEnum.eFmtGamePlayType).Exploration, [(FmtEnum.eFmtFromModule).WeeklyChallenge] = (FmtEnum.eFmtGamePlayType).Exploration, [(FmtEnum.eFmtFromModule).DungeonTower] = (FmtEnum.eFmtGamePlayType).Dungeon, [(FmtEnum.eFmtFromModule).SectorIIDun] = (FmtEnum.eFmtGamePlayType).Dungeon, [(FmtEnum.eFmtFromModule).SctIIDunChallenge] = (FmtEnum.eFmtGamePlayType).Dungeon, [(FmtEnum.eFmtFromModule).ARDDun] = (FmtEnum.eFmtGamePlayType).Dungeon, [(FmtEnum.eFmtFromModule).DungeonTwinTower] = (FmtEnum.eFmtGamePlayType).Dungeon, [(FmtEnum.eFmtFromModule).CarnivalEp] = (FmtEnum.eFmtGamePlayType).Exploration, [(FmtEnum.eFmtFromModule).CarnivalDungeon] = (FmtEnum.eFmtGamePlayType).Dungeon, [(FmtEnum.eFmtFromModule).ActSectorIIIDun] = (FmtEnum.eFmtGamePlayType).Dungeon, [(FmtEnum.eFmtFromModule).HeroGrow] = (FmtEnum.eFmtGamePlayType).Dungeon, [(FmtEnum.eFmtFromModule).Season] = (FmtEnum.eFmtGamePlayType).Dungeon, [(FmtEnum.eFmtFromModule).Spring] = (FmtEnum.eFmtGamePlayType).Dungeon, [(FmtEnum.eFmtFromModule).SpringEp] = (FmtEnum.eFmtGamePlayType).Exploration, [(FmtEnum.eFmtFromModule).ActSeasonDun] = (FmtEnum.eFmtGamePlayType).Dungeon}
FmtEnum.eFmtEvaluationAdvant = {advContain = 1, advantage = 2, inferior = 3}
FmtEnum.eFmtHeroDetailState = {Lock = 1, Empty = 2, HasHero = 3}
FmtEnum.eFmtSpecialSector = {Copley = 6}
FmtEnum.eFmtSpecialSectorTip = {
[(FmtEnum.eFmtSpecialSector).Copley] = {9001}
}
FmtEnum.GetFmtGameTypeByModuleId = function(modId)
  -- function num : 0_0 , upvalues : fmtModule2PlayType, FmtEnum
  local gameType = fmtModule2PlayType[modId]
  if not gameType then
    return (FmtEnum.eFmtGamePlayType).None
  end
end

return FmtEnum

