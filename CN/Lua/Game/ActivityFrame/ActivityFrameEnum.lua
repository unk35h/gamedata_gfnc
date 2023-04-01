-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityFrameEnum = {}
ActivityFrameEnum.eActivityState = {None = 0, WaitState = 1, PreviewState = 2, OpenState = 3, RewardState = 4, DestroyState = 5}
ActivityFrameEnum.eActivityType = {BattlePass = 1, StarUp = 2, SevenDayLogin = 4, Lotter = 5, Tickets = 6, DungeonDouble = 7, HeroBackOff = 8, SectorI = 9, HeroGrow = 10, SectorII = 11, WhiteDay = 12, RefreshDun = 13, Comeback = 14, Task = 15, Round = 16, Carnival = 17, HistoryTinyGame = 18, DailyChallenge = 19, SectorIII = 20, SignInMiniGame = 21, Hallowmas = 22, KeyExertion = 23, Spring = 24, Winter23 = 25, Invitation = 26, EventWeeklyQA = 27, EventAngelaGift = 28, Gift = 29, ActvtLimitTask = 30, dailySignIn = "dailySignIn"}
ActivityFrameEnum.eActivityLiftType = {FixedTime = 1, ServerTime = 2, RoleTime = 3}
ActivityFrameEnum.eActivityEnterType = {LimitTime = 1, Novice = 2, Comeback = 3, KeyExertion = 4}
ActivityFrameEnum.eActivityEnterTypePriority = {[1] = (ActivityFrameEnum.eActivityEnterType).Novice, [2] = (ActivityFrameEnum.eActivityEnterType).LimitTime, [3] = (ActivityFrameEnum.eActivityEnterType).Comeback, [4] = (ActivityFrameEnum.eActivityEnterType).KeyExertion}
ActivityFrameEnum.eActivityUIType = {StarUp = 1, BattlePass = 2, EventGrowBag = 3, SevenDayLogin = 4, Tickets = 5, BattlePassV2 = 6, FestivalSign = 100, LimitTask = 101, SignInMiniGame = 102, EventInvitation = 103, EventWeeklyQA = 104, EventAngelaGift = 105, Gift = 106, dailySignIn = "dailySignIn"}
ActivityFrameEnum.eActiveityFakeId = {dailySignIn = 999999, Tickets = 6001}
return ActivityFrameEnum

