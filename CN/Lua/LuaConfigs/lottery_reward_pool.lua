-- params : ...
-- function num : 0 , upvalues : _ENV
local __rt_1 = {}
local __rt_2 = {4}
local __rt_3 = {1002}
local __rt_4 = {3}
local __rt_5 = {5}
local __rt_6 = {2110}
local __rt_7 = {1112}
local __rt_8 = {2106}
local __rt_9 = {3106}
local __rt_10 = {4103}
local __rt_11 = {5103}
local lottery_reward_pool = {
[101] = {
[8] = {id = 8, item_reward = 2008, type = 101}
, 
[10] = {item_reward = 2010, type = 101}
, 
[21] = {id = 21, item_reward = 2016, type = 101}
, 
[27] = {id = 27, item_reward = 2018, type = 101}
, 
[36] = {id = 36, item_reward = 2028, type = 101}
, 
[39] = {id = 39, item_reward = 2025, type = 101}
, 
[40] = {id = 40, item_reward = 2026, type = 101}
, 
[49] = {id = 49, item_reward = 2037, type = 101}
, 
[51] = {id = 51, item_reward = 2039, type = 101}
, 
[53] = {id = 53, item_reward = 2022, type = 101}
, 
[54] = {id = 54, item_reward = 2041, type = 101}
, 
[55] = {id = 55, item_reward = 2042, type = 101}
, 
[56] = {id = 56, item_reward = 2043, type = 101}
, 
[57] = {id = 57, item_reward = 2044, type = 101}
, 
[58] = {id = 58, item_reward = 2045, type = 101}
, 
[59] = {id = 59, item_reward = 2046, type = 101}
, 
[60] = {id = 60, item_reward = 2048, type = 101}
, 
[61] = {id = 61, item_reward = 2049, type = 101}
, 
[62] = {id = 62, item_reward = 2052, type = 101}
, 
[63] = {id = 63, item_reward = 2051, type = 101}
, 
[64] = {id = 64, item_reward = 2050, type = 101}
, 
[65] = {id = 65, item_reward = 2053, type = 101}
, 
[66] = {id = 66, item_reward = 2054, type = 101}
, 
[67] = {id = 67, item_reward = 2055, type = 101}
, 
[68] = {id = 68, item_reward = 2057, type = 101}
, 
[69] = {id = 69, item_reward = 2059, type = 101}
, 
[70] = {id = 70, item_reward = 2060, type = 101}
, 
[71] = {id = 71, item_reward = 2061, type = 101}
}
, 
[102] = {
[2] = {id = 2, item_reward = 2002, type = 102}
, 
[6] = {id = 6, item_reward = 2006, type = 102}
, 
[12] = {id = 12, item_reward = 2011, type = 102}
, 
[16] = {id = 16, item_reward = 2013, type = 102}
, 
[20] = {id = 20, item_reward = 2015, type = 102}
, 
[23] = {id = 23, item_reward = 2017, type = 102}
, 
[31] = {id = 31, item_reward = 2019, type = 102}
, 
[38] = {id = 38, item_reward = 2024, type = 102}
, 
[42] = {id = 42, item_reward = 2030, type = 102}
, 
[43] = {id = 43, item_reward = 2031, type = 102}
, 
[44] = {id = 44, item_reward = 2032, type = 102}
, 
[45] = {id = 45, item_reward = 2033, type = 102}
, 
[50] = {id = 50, item_reward = 2038, type = 102}
, 
[52] = {id = 52, item_reward = 2040, type = 102}
}
, 
[103] = {
[4] = {id = 4, item_reward = 2004, type = 103}
, 
[7] = {id = 7, item_reward = 2007, type = 103}
, 
[9] = {id = 9, type = 103}
, 
[13] = {id = 13, item_reward = 2012, type = 103}
, 
[17] = {id = 17, item_reward = 2014, type = 103}
, 
[34] = {id = 34, item_reward = 2020, type = 103}
, 
[35] = {id = 35, item_reward = 2021, type = 103}
, 
[37] = {id = 37, item_reward = 2023, type = 103}
, 
[41] = {id = 41, item_reward = 2027, type = 103}
, 
[46] = {id = 46, item_reward = 2034, type = 103}
, 
[47] = {id = 47, item_reward = 2035, type = 103}
, 
[48] = {id = 48, item_reward = 2036, type = 103}
}
, 
[201] = {
{id = 1, type = 201}
, 
{id = 2, item_reward = 2023, type = 201}
, 
{id = 3, item_reward = 2035, type = 201}
, 
{id = 4, item_reward = 2031, pre_condition = __rt_2, pre_para1 = __rt_3, pre_para2 = __rt_4, type = 201}
, 
{id = 5, item_reward = 2013, pre_condition = __rt_2, pre_para1 = __rt_3, pre_para2 = __rt_4, type = 201}
, 
{id = 6, item_reward = 2017, pre_condition = __rt_2, pre_para1 = __rt_3, pre_para2 = __rt_2, type = 201}
, 
{id = 7, item_reward = 2024, pre_condition = __rt_2, pre_para1 = __rt_3, pre_para2 = __rt_2, type = 201}
, 
{id = 8, item_reward = 2016, pre_condition = __rt_2, pre_para1 = __rt_3, pre_para2 = __rt_5, type = 201}
, 
{id = 9, item_reward = 2008, pre_condition = __rt_2, pre_para1 = __rt_3, pre_para2 = __rt_5, type = 201}
}
, 
[202] = {
[10] = {item_reward = 1006}
, 
[11] = {id = 11, item_reward = 1006}
, 
[12] = {id = 12, item_reward = 1006}
, 
[13] = {id = 13, item_reward = 1006}
, 
[84] = {id = 84, item_reward = 2502}
, 
[85] = {id = 85, item_reward = 2503}
, 
[86] = {id = 86, item_reward = 2504}
, 
[87] = {id = 87, item_reward = 2505}
, 
[88] = {id = 88, item_reward = 2506}
, 
[89] = {id = 89, item_reward = 2507}
, 
[90] = {id = 90, item_reward = 2508}
, 
[91] = {id = 91, item_reward = 2509}
, 
[92] = {id = 92, item_reward = 2510}
, 
[93] = {id = 93, item_reward = 2511}
, 
[94] = {id = 94, item_reward = 2512}
, 
[95] = {id = 95, item_reward = 2513}
, 
[96] = {id = 96, item_reward = 2514}
, 
[97] = {id = 97, item_reward = 2515}
, 
[98] = {id = 98, item_reward = 2516}
, 
[99] = {id = 99, item_reward = 2517}
, 
[100] = {id = 100, item_reward = 2518}
, 
[101] = {id = 101, item_reward = 2519}
, 
[102] = {id = 102, item_reward = 2520}
, 
[103] = {id = 103, item_reward = 2521}
, 
[104] = {id = 104, item_reward = 2523}
, 
[105] = {id = 105, item_reward = 2524}
, 
[106] = {id = 106, item_reward = 2525}
, 
[107] = {id = 107, item_reward = 2526}
, 
[108] = {id = 108, item_reward = 2527}
, 
[109] = {id = 109, item_reward = 2528}
, 
[110] = {id = 110, item_reward = 2529}
, 
[111] = {id = 111, item_reward = 2530}
, 
[112] = {id = 112, item_reward = 2531}
, 
[113] = {id = 113, item_reward = 2532}
, 
[114] = {id = 114, item_reward = 2533}
, 
[115] = {id = 115, item_reward = 2534}
, 
[116] = {id = 116, item_reward = 2535}
, 
[117] = {id = 117, item_reward = 2536}
, 
[118] = {id = 118, item_reward = 2537}
, 
[119] = {id = 119, item_reward = 2538}
, 
[120] = {id = 120, item_reward = 2539}
, 
[121] = {id = 121, item_reward = 2540}
}
, 
[203] = {
[14] = {id = 14, item_reward = 5001, type = 203}
, 
[15] = {id = 15, item_reward = 5001, pre_condition = __rt_4, 
pre_para1 = {2101}
, type = 203}
, 
[16] = {id = 16, item_reward = 5002, pre_condition = __rt_4, 
pre_para1 = {3101}
, type = 203}
, 
[17] = {id = 17, item_reward = 5002, pre_condition = __rt_4, 
pre_para1 = {3105}
, type = 203}
, 
[18] = {id = 18, item_reward = 5002, pre_condition = __rt_4, 
pre_para1 = {3110}
, type = 203}
, 
[19] = {id = 19, item_reward = 5007, pre_condition = __rt_4, 
pre_para1 = {4101}
, type = 203}
, 
[20] = {id = 20, item_reward = 1101, pre_condition = __rt_4, pre_para1 = __rt_6, type = 203}
, 
[21] = {id = 21, item_reward = 1102, pre_condition = __rt_4, pre_para1 = __rt_6, type = 203}
, 
[22] = {id = 22, item_reward = 1103, pre_condition = __rt_4, pre_para1 = __rt_6, type = 203}
, 
[23] = {id = 23, item_reward = 1107, pre_condition = __rt_4, pre_para1 = __rt_6, type = 203}
, 
[24] = {id = 24, item_reward = 1108, pre_condition = __rt_4, pre_para1 = __rt_6, type = 203}
, 
[25] = {id = 25, item_reward = 1109, pre_condition = __rt_4, pre_para1 = __rt_6, type = 203}
, 
[26] = {id = 26, item_reward = 1113, pre_condition = __rt_4, pre_para1 = __rt_6, type = 203}
, 
[27] = {id = 27, item_reward = 1114, pre_condition = __rt_4, pre_para1 = __rt_6, type = 203}
, 
[28] = {id = 28, item_reward = 1115, pre_condition = __rt_4, pre_para1 = __rt_6, type = 203}
, 
[29] = {id = 29, item_reward = 3100, type = 203}
, 
[30] = {id = 30, item_reward = 3101, type = 203}
, 
[31] = {id = 31, item_reward = 3102, type = 203}
, 
[32] = {id = 32, item_reward = 3103, type = 203}
, 
[33] = {id = 33, item_reward = 3104, type = 203}
, 
[34] = {id = 34, item_reward = 3105, type = 203}
, 
[35] = {id = 35, item_reward = 3106, type = 203}
, 
[36] = {id = 36, item_reward = 3107, type = 203}
, 
[37] = {id = 37, item_reward = 3108, type = 203}
, 
[38] = {id = 38, item_reward = 3109, type = 203}
, 
[39] = {id = 39, item_reward = 3110, type = 203}
, 
[40] = {id = 40, item_reward = 3111, type = 203}
, 
[41] = {id = 41, item_reward = 3112, type = 203}
, 
[42] = {id = 42, item_reward = 3113, type = 203}
, 
[43] = {id = 43, item_reward = 3114, type = 203}
, 
[44] = {id = 44, item_reward = 3115, type = 203}
, 
[45] = {id = 45, item_reward = 3116, type = 203}
, 
[46] = {id = 46, item_reward = 3117, type = 203}
, 
[47] = {id = 47, item_reward = 3118, type = 203}
, 
[48] = {id = 48, item_reward = 3119, type = 203}
, 
[49] = {id = 49, item_reward = 3120, type = 203}
, 
[50] = {id = 50, item_reward = 3121, type = 203}
, 
[51] = {id = 51, item_reward = 3122, type = 203}
, 
[52] = {id = 52, item_reward = 3123, type = 203}
}
, 
[204] = {
[53] = {id = 53, item_reward = 1801, type = 204}
, 
[54] = {id = 54, item_reward = 1802, type = 204}
, 
[55] = {id = 55, item_reward = 1803, type = 204}
, 
[56] = {id = 56, item_reward = 1804, type = 204}
, 
[57] = {id = 57, item_reward = 1805, type = 204}
, 
[58] = {id = 58, item_reward = 1806, pre_condition = __rt_4, pre_para1 = __rt_7, type = 204}
, 
[59] = {id = 59, item_reward = 1807, pre_condition = __rt_4, pre_para1 = __rt_7, type = 204}
, 
[60] = {id = 60, item_reward = 1808, pre_condition = __rt_4, pre_para1 = __rt_7, type = 204}
, 
[61] = {id = 61, item_reward = 1809, pre_condition = __rt_4, pre_para1 = __rt_7, type = 204}
, 
[62] = {id = 62, item_reward = 1810, pre_condition = __rt_4, pre_para1 = __rt_7, type = 204}
, 
[63] = {id = 63, item_reward = 1811, pre_condition = __rt_4, pre_para1 = __rt_8, type = 204}
, 
[64] = {id = 64, item_reward = 1812, pre_condition = __rt_4, pre_para1 = __rt_8, type = 204}
, 
[65] = {id = 65, item_reward = 1813, pre_condition = __rt_4, pre_para1 = __rt_8, type = 204}
, 
[66] = {id = 66, item_reward = 1814, pre_condition = __rt_4, pre_para1 = __rt_8, type = 204}
, 
[67] = {id = 67, item_reward = 1815, pre_condition = __rt_4, pre_para1 = __rt_8, type = 204}
, 
[68] = {id = 68, item_reward = 1816, pre_condition = __rt_4, pre_para1 = __rt_9, type = 204}
, 
[69] = {id = 69, item_reward = 1817, pre_condition = __rt_4, pre_para1 = __rt_9, type = 204}
, 
[70] = {id = 70, item_reward = 1818, pre_condition = __rt_4, pre_para1 = __rt_9, type = 204}
, 
[71] = {id = 71, item_reward = 1819, pre_condition = __rt_4, pre_para1 = __rt_9, type = 204}
, 
[72] = {id = 72, item_reward = 1820, pre_condition = __rt_4, pre_para1 = __rt_9, type = 204}
, 
[73] = {id = 73, item_reward = 1821, pre_condition = __rt_4, pre_para1 = __rt_10, type = 204}
, 
[74] = {id = 74, item_reward = 1822, pre_condition = __rt_4, pre_para1 = __rt_10, type = 204}
, 
[75] = {id = 75, item_reward = 1823, pre_condition = __rt_4, pre_para1 = __rt_10, type = 204}
, 
[76] = {id = 76, item_reward = 1824, pre_condition = __rt_4, pre_para1 = __rt_10, type = 204}
, 
[77] = {id = 77, item_reward = 1825, pre_condition = __rt_4, pre_para1 = __rt_10, type = 204}
, 
[78] = {id = 78, item_reward = 1821, pre_condition = __rt_4, pre_para1 = __rt_11, type = 204}
, 
[79] = {id = 79, item_reward = 1822, pre_condition = __rt_4, pre_para1 = __rt_11, type = 204}
, 
[80] = {id = 80, item_reward = 1823, pre_condition = __rt_4, pre_para1 = __rt_11, type = 204}
, 
[81] = {id = 81, item_reward = 1824, pre_condition = __rt_4, pre_para1 = __rt_11, type = 204}
, 
[82] = {id = 82, item_reward = 1825, pre_condition = __rt_4, pre_para1 = __rt_11, type = 204}
, 
[83] = {id = 83, item_reward = 2501, type = 204}
}
, 
[401] = {
[6] = {id = 6, item_reward = 2010, type = 401}
, 
[12] = {id = 12, item_reward = 2016, type = 401}
, 
[14] = {id = 14, item_reward = 2018, type = 401}
, 
[20] = {id = 20, item_reward = 2025, type = 401}
, 
[21] = {id = 21, item_reward = 2026, type = 401}
, 
[23] = {id = 23, item_reward = 2028, type = 401}
, 
[31] = {id = 31, item_reward = 2037, type = 401}
, 
[33] = {id = 33, item_reward = 2039, type = 401}
}
, 
[402] = {
{id = 1, item_reward = 2002, type = 402}
; 
[3] = {id = 3, item_reward = 2006, type = 402}
, 
[7] = {id = 7, item_reward = 2011, type = 402}
, 
[9] = {id = 9, item_reward = 2013, type = 402}
, 
[11] = {id = 11, item_reward = 2015, type = 402}
, 
[13] = {id = 13, item_reward = 2017, type = 402}
, 
[15] = {id = 15, item_reward = 2019, type = 402}
, 
[19] = {id = 19, item_reward = 2024, type = 402}
, 
[24] = {id = 24, item_reward = 2030, type = 402}
, 
[25] = {id = 25, item_reward = 2031, type = 402}
, 
[26] = {id = 26, item_reward = 2032, type = 402}
, 
[27] = {id = 27, item_reward = 2033, type = 402}
, 
[32] = {id = 32, item_reward = 2038, type = 402}
, 
[34] = {id = 34, item_reward = 2040, type = 402}
}
, 
[403] = {
[2] = {id = 2, item_reward = 2004, type = 403}
, 
[4] = {id = 4, item_reward = 2007, type = 403}
, 
[5] = {id = 5, type = 403}
, 
[8] = {id = 8, item_reward = 2012, type = 403}
, 
[10] = {item_reward = 2014, type = 403}
, 
[16] = {id = 16, item_reward = 2020, type = 403}
, 
[17] = {id = 17, item_reward = 2021, type = 403}
, 
[18] = {id = 18, item_reward = 2023, type = 403}
, 
[22] = {id = 22, item_reward = 2027, type = 403}
, 
[28] = {id = 28, item_reward = 2034, type = 403}
, 
[29] = {id = 29, item_reward = 2035, type = 403}
, 
[30] = {id = 30, item_reward = 2036, type = 403}
}
, 
[501] = {
[5] = {id = 5, item_reward = 2008, type = 501}
, 
[7] = {id = 7, item_reward = 2010, type = 501}
, 
[13] = {id = 13, item_reward = 2016, type = 501}
, 
[15] = {id = 15, item_reward = 2018, type = 501}
, 
[21] = {id = 21, item_reward = 2025, type = 501}
, 
[22] = {id = 22, item_reward = 2026, type = 501}
, 
[24] = {id = 24, item_reward = 2028, type = 501}
, 
[32] = {id = 32, item_reward = 2037, type = 501}
, 
[34] = {id = 34, item_reward = 2039, type = 501}
}
, 
[502] = {
{id = 1, item_reward = 2002, type = 502}
; 
[3] = {id = 3, item_reward = 2006, type = 502}
, 
[8] = {id = 8, item_reward = 2011, type = 502}
, 
[10] = {item_reward = 2013, type = 502}
, 
[12] = {id = 12, item_reward = 2015, type = 502}
, 
[14] = {id = 14, item_reward = 2017, type = 502}
, 
[16] = {id = 16, item_reward = 2019, type = 502}
, 
[20] = {id = 20, item_reward = 2024, type = 502}
, 
[25] = {id = 25, item_reward = 2030, type = 502}
, 
[26] = {id = 26, item_reward = 2031, type = 502}
, 
[27] = {id = 27, item_reward = 2032, type = 502}
, 
[28] = {id = 28, item_reward = 2033, type = 502}
, 
[33] = {id = 33, item_reward = 2038, type = 502}
, 
[35] = {id = 35, item_reward = 2040, type = 502}
}
, 
[503] = {
[2] = {id = 2, item_reward = 2004, type = 503}
, 
[4] = {id = 4, item_reward = 2007, type = 503}
, 
[6] = {id = 6, type = 503}
, 
[9] = {id = 9, item_reward = 2012, type = 503}
, 
[11] = {id = 11, item_reward = 2014, type = 503}
, 
[17] = {id = 17, item_reward = 2020, type = 503}
, 
[18] = {id = 18, item_reward = 2021, type = 503}
, 
[19] = {id = 19, item_reward = 2023, type = 503}
, 
[23] = {id = 23, item_reward = 2027, type = 503}
, 
[29] = {id = 29, item_reward = 2034, type = 503}
, 
[30] = {id = 30, item_reward = 2035, type = 503}
, 
[31] = {id = 31, item_reward = 2036, type = 503}
}
, 
[601] = {
[5] = {id = 5, item_reward = 2008, type = 601}
, 
[7] = {id = 7, item_reward = 2010, type = 601}
, 
[14] = {id = 14, item_reward = 2018, type = 601}
, 
[18] = {id = 18, item_reward = 2022, type = 601}
, 
[21] = {id = 21, item_reward = 2025, type = 601}
, 
[22] = {id = 22, item_reward = 2026, type = 601}
, 
[24] = {id = 24, item_reward = 2028, type = 601}
, 
[33] = {id = 33, item_reward = 2039, type = 601}
}
, 
[602] = {
{id = 1, item_reward = 2002, type = 602}
; 
[3] = {id = 3, item_reward = 2006, type = 602}
, 
[8] = {id = 8, item_reward = 2011, type = 602}
, 
[10] = {item_reward = 2013, type = 602}
, 
[12] = {id = 12, item_reward = 2015, type = 602}
, 
[13] = {id = 13, item_reward = 2017, type = 602}
, 
[15] = {id = 15, item_reward = 2019, type = 602}
, 
[20] = {id = 20, item_reward = 2024, type = 602}
, 
[25] = {id = 25, item_reward = 2030, type = 602}
, 
[26] = {id = 26, item_reward = 2031, type = 602}
, 
[27] = {id = 27, item_reward = 2032, type = 602}
, 
[28] = {id = 28, item_reward = 2033, type = 602}
, 
[32] = {id = 32, item_reward = 2038, type = 602}
, 
[34] = {id = 34, item_reward = 2040, type = 602}
}
, 
[603] = {
[2] = {id = 2, item_reward = 2004, type = 603}
, 
[4] = {id = 4, item_reward = 2007, type = 603}
, 
[6] = {id = 6, type = 603}
, 
[9] = {id = 9, item_reward = 2012, type = 603}
, 
[11] = {id = 11, item_reward = 2014, type = 603}
, 
[16] = {id = 16, item_reward = 2020, type = 603}
, 
[17] = {id = 17, item_reward = 2021, type = 603}
, 
[19] = {id = 19, item_reward = 2023, type = 603}
, 
[23] = {id = 23, item_reward = 2027, type = 603}
, 
[29] = {id = 29, item_reward = 2034, type = 603}
, 
[30] = {id = 30, item_reward = 2035, type = 603}
, 
[31] = {id = 31, item_reward = 2036, type = 603}
}
, 
[801] = {
[61] = {id = 61, item_reward = 2041, type = 801}
, 
[62] = {id = 62, item_reward = 2016, type = 801}
, 
[63] = {id = 63, item_reward = 2010, type = 801}
, 
[64] = {id = 64, item_reward = 2018, type = 801}
, 
[65] = {id = 65, item_reward = 2037, type = 801}
, 
[66] = {id = 66, item_reward = 2026, type = 801}
, 
[67] = {id = 67, item_reward = 2028, type = 801}
, 
[68] = {id = 68, item_reward = 2039, type = 801}
}
, 
[802] = {
[35] = {id = 35, item_reward = 2002, type = 802}
, 
[37] = {id = 37, item_reward = 2006, type = 802}
, 
[40] = {id = 40, item_reward = 2011, type = 802}
, 
[42] = {id = 42, item_reward = 2013, type = 802}
, 
[44] = {id = 44, item_reward = 2015, type = 802}
, 
[45] = {id = 45, item_reward = 2017, type = 802}
, 
[46] = {id = 46, item_reward = 2019, type = 802}
, 
[50] = {id = 50, item_reward = 2024, type = 802}
, 
[52] = {id = 52, item_reward = 2030, type = 802}
, 
[53] = {id = 53, item_reward = 2031, type = 802}
, 
[54] = {id = 54, item_reward = 2032, type = 802}
, 
[55] = {id = 55, item_reward = 2033, type = 802}
, 
[59] = {id = 59, item_reward = 2038, type = 802}
, 
[60] = {id = 60, item_reward = 2040, type = 802}
}
, 
[803] = {
[36] = {id = 36, item_reward = 2004, type = 803}
, 
[38] = {id = 38, item_reward = 2007, type = 803}
, 
[39] = {id = 39, type = 803}
, 
[41] = {id = 41, item_reward = 2012, type = 803}
, 
[43] = {id = 43, item_reward = 2014, type = 803}
, 
[47] = {id = 47, item_reward = 2020, type = 803}
, 
[48] = {id = 48, item_reward = 2021, type = 803}
, 
[49] = {id = 49, item_reward = 2023, type = 803}
, 
[51] = {id = 51, item_reward = 2027, type = 803}
, 
[56] = {id = 56, item_reward = 2034, type = 803}
, 
[57] = {id = 57, item_reward = 2035, type = 803}
, 
[58] = {id = 58, item_reward = 2036, type = 803}
}
, 
[901] = {
[95] = {id = 95, item_reward = 2042, type = 901}
, 
[96] = {id = 96, item_reward = 2016, type = 901}
, 
[97] = {id = 97, item_reward = 2010, type = 901}
, 
[98] = {id = 98, item_reward = 2018, type = 901}
, 
[99] = {id = 99, item_reward = 2037, type = 901}
, 
[100] = {id = 100, item_reward = 2026, type = 901}
, 
[101] = {id = 101, item_reward = 2028, type = 901}
, 
[102] = {id = 102, item_reward = 2039, type = 901}
}
, 
[902] = {
[69] = {id = 69, item_reward = 2002, type = 902}
, 
[71] = {id = 71, item_reward = 2006, type = 902}
, 
[74] = {id = 74, item_reward = 2011, type = 902}
, 
[76] = {id = 76, item_reward = 2013, type = 902}
, 
[78] = {id = 78, item_reward = 2015, type = 902}
, 
[79] = {id = 79, item_reward = 2017, type = 902}
, 
[80] = {id = 80, item_reward = 2019, type = 902}
, 
[84] = {id = 84, item_reward = 2024, type = 902}
, 
[86] = {id = 86, item_reward = 2030, type = 902}
, 
[87] = {id = 87, item_reward = 2031, type = 902}
, 
[88] = {id = 88, item_reward = 2032, type = 902}
, 
[89] = {id = 89, item_reward = 2033, type = 902}
, 
[93] = {id = 93, item_reward = 2038, type = 902}
, 
[94] = {id = 94, item_reward = 2040, type = 902}
}
, 
[903] = {
[70] = {id = 70, item_reward = 2004, type = 903}
, 
[72] = {id = 72, item_reward = 2007, type = 903}
, 
[73] = {id = 73, type = 903}
, 
[75] = {id = 75, item_reward = 2012, type = 903}
, 
[77] = {id = 77, item_reward = 2014, type = 903}
, 
[81] = {id = 81, item_reward = 2020, type = 903}
, 
[82] = {id = 82, item_reward = 2021, type = 903}
, 
[83] = {id = 83, item_reward = 2023, type = 903}
, 
[85] = {id = 85, item_reward = 2027, type = 903}
, 
[90] = {id = 90, item_reward = 2034, type = 903}
, 
[91] = {id = 91, item_reward = 2035, type = 903}
, 
[92] = {id = 92, item_reward = 2036, type = 903}
}
, 
[1001] = {
[129] = {id = 129, item_reward = 2025, type = 1001}
, 
[130] = {id = 130, item_reward = 2016, type = 1001}
, 
[131] = {id = 131, item_reward = 2010, type = 1001}
, 
[132] = {id = 132, item_reward = 2018, type = 1001}
, 
[133] = {id = 133, item_reward = 2037, type = 1001}
, 
[134] = {id = 134, item_reward = 2026, type = 1001}
, 
[135] = {id = 135, item_reward = 2028, type = 1001}
, 
[136] = {id = 136, item_reward = 2039, type = 1001}
}
, 
[1002] = {
[103] = {id = 103, item_reward = 2002, type = 1002}
, 
[105] = {id = 105, item_reward = 2006, type = 1002}
, 
[108] = {id = 108, item_reward = 2011, type = 1002}
, 
[110] = {id = 110, item_reward = 2013, type = 1002}
, 
[112] = {id = 112, item_reward = 2015, type = 1002}
, 
[113] = {id = 113, item_reward = 2017, type = 1002}
, 
[114] = {id = 114, item_reward = 2019, type = 1002}
, 
[118] = {id = 118, item_reward = 2024, type = 1002}
, 
[120] = {id = 120, item_reward = 2030, type = 1002}
, 
[121] = {id = 121, item_reward = 2031, type = 1002}
, 
[122] = {id = 122, item_reward = 2032, type = 1002}
, 
[123] = {id = 123, item_reward = 2033, type = 1002}
, 
[127] = {id = 127, item_reward = 2038, type = 1002}
, 
[128] = {id = 128, item_reward = 2040, type = 1002}
}
, 
[1003] = {
[104] = {id = 104, item_reward = 2004, type = 1003}
, 
[106] = {id = 106, item_reward = 2007, type = 1003}
, 
[107] = {id = 107, type = 1003}
, 
[109] = {id = 109, item_reward = 2012, type = 1003}
, 
[111] = {id = 111, item_reward = 2014, type = 1003}
, 
[115] = {id = 115, item_reward = 2020, type = 1003}
, 
[116] = {id = 116, item_reward = 2021, type = 1003}
, 
[117] = {id = 117, item_reward = 2023, type = 1003}
, 
[119] = {id = 119, item_reward = 2027, type = 1003}
, 
[124] = {id = 124, item_reward = 2034, type = 1003}
, 
[125] = {id = 125, item_reward = 2035, type = 1003}
, 
[126] = {id = 126, item_reward = 2036, type = 1003}
}
, 
[1101] = {
[61] = {id = 61, item_reward = 2008, type = 1101}
, 
[62] = {id = 62, item_reward = 2018, type = 1101}
, 
[63] = {id = 63, item_reward = 2022, type = 1101}
, 
[64] = {id = 64, item_reward = 2025, type = 1101}
, 
[65] = {id = 65, item_reward = 2016, type = 1101}
, 
[66] = {id = 66, item_reward = 2028, type = 1101}
, 
[67] = {id = 67, item_reward = 2037, type = 1101}
, 
[68] = {id = 68, item_reward = 2043, type = 1101}
}
, 
[1102] = {
[35] = {id = 35, item_reward = 2002, type = 1102}
, 
[37] = {id = 37, item_reward = 2006, type = 1102}
, 
[40] = {id = 40, item_reward = 2011, type = 1102}
, 
[42] = {id = 42, item_reward = 2013, type = 1102}
, 
[44] = {id = 44, item_reward = 2015, type = 1102}
, 
[45] = {id = 45, item_reward = 2017, type = 1102}
, 
[46] = {id = 46, item_reward = 2019, type = 1102}
, 
[50] = {id = 50, item_reward = 2024, type = 1102}
, 
[52] = {id = 52, item_reward = 2030, type = 1102}
, 
[53] = {id = 53, item_reward = 2031, type = 1102}
, 
[54] = {id = 54, item_reward = 2032, type = 1102}
, 
[55] = {id = 55, item_reward = 2033, type = 1102}
, 
[59] = {id = 59, item_reward = 2038, type = 1102}
, 
[60] = {id = 60, item_reward = 2040, type = 1102}
}
, 
[1103] = {
[36] = {id = 36, item_reward = 2004, type = 1103}
, 
[38] = {id = 38, item_reward = 2007, type = 1103}
, 
[39] = {id = 39, type = 1103}
, 
[41] = {id = 41, item_reward = 2012, type = 1103}
, 
[43] = {id = 43, item_reward = 2014, type = 1103}
, 
[47] = {id = 47, item_reward = 2020, type = 1103}
, 
[48] = {id = 48, item_reward = 2021, type = 1103}
, 
[49] = {id = 49, item_reward = 2023, type = 1103}
, 
[51] = {id = 51, item_reward = 2027, type = 1103}
, 
[56] = {id = 56, item_reward = 2034, type = 1103}
, 
[57] = {id = 57, item_reward = 2035, type = 1103}
, 
[58] = {id = 58, item_reward = 2036, type = 1103}
}
, 
[1201] = {
[163] = {id = 163, item_reward = 2025, type = 1201}
, 
[164] = {id = 164, item_reward = 2016, type = 1201}
, 
[165] = {id = 165, item_reward = 2010, type = 1201}
, 
[166] = {id = 166, item_reward = 2018, type = 1201}
, 
[167] = {id = 167, item_reward = 2037, type = 1201}
, 
[168] = {id = 168, item_reward = 2026, type = 1201}
, 
[169] = {id = 169, item_reward = 2028, type = 1201}
, 
[170] = {id = 170, item_reward = 2039, type = 1201}
}
, 
[1202] = {
[137] = {id = 137, item_reward = 2002, type = 1202}
, 
[139] = {id = 139, item_reward = 2006, type = 1202}
, 
[142] = {id = 142, item_reward = 2011, type = 1202}
, 
[144] = {id = 144, item_reward = 2013, type = 1202}
, 
[146] = {id = 146, item_reward = 2015, type = 1202}
, 
[147] = {id = 147, item_reward = 2017, type = 1202}
, 
[148] = {id = 148, item_reward = 2019, type = 1202}
, 
[152] = {id = 152, item_reward = 2024, type = 1202}
, 
[154] = {id = 154, item_reward = 2030, type = 1202}
, 
[155] = {id = 155, item_reward = 2031, type = 1202}
, 
[156] = {id = 156, item_reward = 2032, type = 1202}
, 
[157] = {id = 157, item_reward = 2033, type = 1202}
, 
[161] = {id = 161, item_reward = 2038, type = 1202}
, 
[162] = {id = 162, item_reward = 2040, type = 1202}
}
, 
[1203] = {
[138] = {id = 138, item_reward = 2004, type = 1203}
, 
[140] = {id = 140, item_reward = 2007, type = 1203}
, 
[141] = {id = 141, type = 1203}
, 
[143] = {id = 143, item_reward = 2012, type = 1203}
, 
[145] = {id = 145, item_reward = 2014, type = 1203}
, 
[149] = {id = 149, item_reward = 2020, type = 1203}
, 
[150] = {id = 150, item_reward = 2021, type = 1203}
, 
[151] = {id = 151, item_reward = 2023, type = 1203}
, 
[153] = {id = 153, item_reward = 2027, type = 1203}
, 
[158] = {id = 158, item_reward = 2034, type = 1203}
, 
[159] = {id = 159, item_reward = 2035, type = 1203}
, 
[160] = {id = 160, item_reward = 2036, type = 1203}
}
, 
[1301] = {
[62] = {id = 62, item_reward = 2008, type = 1301}
, 
[63] = {id = 63, item_reward = 2010, type = 1301}
, 
[64] = {id = 64, item_reward = 2016, type = 1301}
, 
[65] = {id = 65, item_reward = 2018, type = 1301}
, 
[66] = {id = 66, item_reward = 2025, type = 1301}
, 
[67] = {id = 67, item_reward = 2026, type = 1301}
, 
[68] = {id = 68, item_reward = 2028, type = 1301}
, 
[69] = {id = 69, item_reward = 2037, type = 1301}
, 
[70] = {id = 70, item_reward = 2039, type = 1301}
, 
[71] = {id = 71, item_reward = 2022, type = 1301}
, 
[72] = {id = 72, item_reward = 2041, type = 1301}
}
, 
[1302] = {
[36] = {id = 36, item_reward = 2002, type = 1302}
, 
[38] = {id = 38, item_reward = 2006, type = 1302}
, 
[41] = {id = 41, item_reward = 2011, type = 1302}
, 
[43] = {id = 43, item_reward = 2013, type = 1302}
, 
[45] = {id = 45, item_reward = 2015, type = 1302}
, 
[46] = {id = 46, item_reward = 2017, type = 1302}
, 
[47] = {id = 47, item_reward = 2019, type = 1302}
, 
[51] = {id = 51, item_reward = 2024, type = 1302}
, 
[53] = {id = 53, item_reward = 2030, type = 1302}
, 
[54] = {id = 54, item_reward = 2031, type = 1302}
, 
[55] = {id = 55, item_reward = 2032, type = 1302}
, 
[56] = {id = 56, item_reward = 2033, type = 1302}
, 
[60] = {id = 60, item_reward = 2038, type = 1302}
, 
[61] = {id = 61, item_reward = 2040, type = 1302}
}
, 
[1303] = {
[37] = {id = 37, item_reward = 2004, type = 1303}
, 
[39] = {id = 39, item_reward = 2007, type = 1303}
, 
[40] = {id = 40, type = 1303}
, 
[42] = {id = 42, item_reward = 2012, type = 1303}
, 
[44] = {id = 44, item_reward = 2014, type = 1303}
, 
[48] = {id = 48, item_reward = 2020, type = 1303}
, 
[49] = {id = 49, item_reward = 2021, type = 1303}
, 
[50] = {id = 50, item_reward = 2023, type = 1303}
, 
[52] = {id = 52, item_reward = 2027, type = 1303}
, 
[57] = {id = 57, item_reward = 2034, type = 1303}
, 
[58] = {id = 58, item_reward = 2035, type = 1303}
, 
[59] = {id = 59, item_reward = 2036, type = 1303}
}
, 
[1401] = {
[197] = {id = 197, item_reward = 2025, type = 1401}
, 
[198] = {id = 198, item_reward = 2016, type = 1401}
, 
[199] = {id = 199, item_reward = 2010, type = 1401}
, 
[200] = {id = 200, item_reward = 2018, type = 1401}
, 
[201] = {id = 201, item_reward = 2037, type = 1401}
, 
[202] = {id = 202, item_reward = 2026, type = 1401}
, 
[203] = {id = 203, item_reward = 2028, type = 1401}
, 
[204] = {id = 204, item_reward = 2041, type = 1401}
}
, 
[1402] = {
[171] = {id = 171, item_reward = 2002, type = 1402}
, 
[173] = {id = 173, item_reward = 2006, type = 1402}
, 
[176] = {id = 176, item_reward = 2011, type = 1402}
, 
[178] = {id = 178, item_reward = 2013, type = 1402}
, 
[180] = {id = 180, item_reward = 2015, type = 1402}
, 
[181] = {id = 181, item_reward = 2017, type = 1402}
, 
[182] = {id = 182, item_reward = 2019, type = 1402}
, 
[186] = {id = 186, item_reward = 2024, type = 1402}
, 
[188] = {id = 188, item_reward = 2030, type = 1402}
, 
[189] = {id = 189, item_reward = 2031, type = 1402}
, 
[190] = {id = 190, item_reward = 2032, type = 1402}
, 
[191] = {id = 191, item_reward = 2033, type = 1402}
, 
[195] = {id = 195, item_reward = 2038, type = 1402}
, 
[196] = {id = 196, item_reward = 2040, type = 1402}
}
, 
[1403] = {
[172] = {id = 172, item_reward = 2004, type = 1403}
, 
[174] = {id = 174, item_reward = 2007, type = 1403}
, 
[175] = {id = 175, type = 1403}
, 
[177] = {id = 177, item_reward = 2012, type = 1403}
, 
[179] = {id = 179, item_reward = 2014, type = 1403}
, 
[183] = {id = 183, item_reward = 2020, type = 1403}
, 
[184] = {id = 184, item_reward = 2021, type = 1403}
, 
[185] = {id = 185, item_reward = 2023, type = 1403}
, 
[187] = {id = 187, item_reward = 2027, type = 1403}
, 
[192] = {id = 192, item_reward = 2034, type = 1403}
, 
[193] = {id = 193, item_reward = 2035, type = 1403}
, 
[194] = {id = 194, item_reward = 2036, type = 1403}
}
, 
[1501] = {
[231] = {id = 231, item_reward = 2025, type = 1501}
, 
[232] = {id = 232, item_reward = 2016, type = 1501}
, 
[233] = {id = 233, item_reward = 2039, type = 1501}
, 
[234] = {id = 234, item_reward = 2018, type = 1501}
, 
[235] = {id = 235, item_reward = 2037, type = 1501}
, 
[236] = {id = 236, item_reward = 2026, type = 1501}
, 
[237] = {id = 237, item_reward = 2028, type = 1501}
, 
[238] = {id = 238, item_reward = 2041, type = 1501}
}
, 
[1502] = {
[205] = {id = 205, item_reward = 2002, type = 1502}
, 
[207] = {id = 207, item_reward = 2006, type = 1502}
, 
[210] = {id = 210, item_reward = 2011, type = 1502}
, 
[212] = {id = 212, item_reward = 2013, type = 1502}
, 
[214] = {id = 214, item_reward = 2015, type = 1502}
, 
[215] = {id = 215, item_reward = 2017, type = 1502}
, 
[216] = {id = 216, item_reward = 2019, type = 1502}
, 
[220] = {id = 220, item_reward = 2024, type = 1502}
, 
[222] = {id = 222, item_reward = 2030, type = 1502}
, 
[223] = {id = 223, item_reward = 2031, type = 1502}
, 
[224] = {id = 224, item_reward = 2032, type = 1502}
, 
[225] = {id = 225, item_reward = 2033, type = 1502}
, 
[229] = {id = 229, item_reward = 2038, type = 1502}
, 
[230] = {id = 230, item_reward = 2040, type = 1502}
}
, 
[1503] = {
[206] = {id = 206, item_reward = 2004, type = 1503}
, 
[208] = {id = 208, item_reward = 2007, type = 1503}
, 
[209] = {id = 209, type = 1503}
, 
[211] = {id = 211, item_reward = 2012, type = 1503}
, 
[213] = {id = 213, item_reward = 2014, type = 1503}
, 
[217] = {id = 217, item_reward = 2020, type = 1503}
, 
[218] = {id = 218, item_reward = 2021, type = 1503}
, 
[219] = {id = 219, item_reward = 2023, type = 1503}
, 
[221] = {id = 221, item_reward = 2027, type = 1503}
, 
[226] = {id = 226, item_reward = 2034, type = 1503}
, 
[227] = {id = 227, item_reward = 2035, type = 1503}
, 
[228] = {id = 228, item_reward = 2036, type = 1503}
}
, 
[1601] = {
[265] = {id = 265, item_reward = 2025, type = 1601}
, 
[266] = {id = 266, item_reward = 2016, type = 1601}
, 
[267] = {id = 267, item_reward = 2044, type = 1601}
, 
[268] = {id = 268, item_reward = 2018, type = 1601}
, 
[269] = {id = 269, item_reward = 2010, type = 1601}
, 
[270] = {id = 270, item_reward = 2026, type = 1601}
, 
[271] = {id = 271, item_reward = 2028, type = 1601}
, 
[272] = {id = 272, item_reward = 2042, type = 1601}
}
, 
[1602] = {
[239] = {id = 239, item_reward = 2002, type = 1602}
, 
[241] = {id = 241, item_reward = 2006, type = 1602}
, 
[244] = {id = 244, item_reward = 2011, type = 1602}
, 
[246] = {id = 246, item_reward = 2013, type = 1602}
, 
[248] = {id = 248, item_reward = 2015, type = 1602}
, 
[249] = {id = 249, item_reward = 2017, type = 1602}
, 
[250] = {id = 250, item_reward = 2019, type = 1602}
, 
[254] = {id = 254, item_reward = 2024, type = 1602}
, 
[256] = {id = 256, item_reward = 2030, type = 1602}
, 
[257] = {id = 257, item_reward = 2031, type = 1602}
, 
[258] = {id = 258, item_reward = 2032, type = 1602}
, 
[259] = {id = 259, item_reward = 2033, type = 1602}
, 
[263] = {id = 263, item_reward = 2038, type = 1602}
, 
[264] = {id = 264, item_reward = 2040, type = 1602}
}
, 
[1603] = {
[240] = {id = 240, item_reward = 2004, type = 1603}
, 
[242] = {id = 242, item_reward = 2007, type = 1603}
, 
[243] = {id = 243, type = 1603}
, 
[245] = {id = 245, item_reward = 2012, type = 1603}
, 
[247] = {id = 247, item_reward = 2014, type = 1603}
, 
[251] = {id = 251, item_reward = 2020, type = 1603}
, 
[252] = {id = 252, item_reward = 2021, type = 1603}
, 
[253] = {id = 253, item_reward = 2023, type = 1603}
, 
[255] = {id = 255, item_reward = 2027, type = 1603}
, 
[260] = {id = 260, item_reward = 2034, type = 1603}
, 
[261] = {id = 261, item_reward = 2035, type = 1603}
, 
[262] = {id = 262, item_reward = 2036, type = 1603}
}
, 
[1701] = {
[95] = {id = 95, item_reward = 2008, type = 1701}
, 
[96] = {id = 96, item_reward = 2010, type = 1701}
, 
[97] = {id = 97, item_reward = 2022, type = 1701}
, 
[98] = {id = 98, item_reward = 2025, type = 1701}
, 
[99] = {id = 99, item_reward = 2016, type = 1701}
, 
[100] = {id = 100, item_reward = 2042, type = 1701}
, 
[101] = {id = 101, item_reward = 2039, type = 1701}
, 
[102] = {id = 102, item_reward = 2041, type = 1701}
}
, 
[1702] = {
[69] = {id = 69, item_reward = 2002, type = 1702}
, 
[71] = {id = 71, item_reward = 2006, type = 1702}
, 
[74] = {id = 74, item_reward = 2011, type = 1702}
, 
[76] = {id = 76, item_reward = 2013, type = 1702}
, 
[78] = {id = 78, item_reward = 2015, type = 1702}
, 
[79] = {id = 79, item_reward = 2017, type = 1702}
, 
[80] = {id = 80, item_reward = 2019, type = 1702}
, 
[84] = {id = 84, item_reward = 2024, type = 1702}
, 
[86] = {id = 86, item_reward = 2030, type = 1702}
, 
[87] = {id = 87, item_reward = 2031, type = 1702}
, 
[88] = {id = 88, item_reward = 2032, type = 1702}
, 
[89] = {id = 89, item_reward = 2033, type = 1702}
, 
[93] = {id = 93, item_reward = 2038, type = 1702}
, 
[94] = {id = 94, item_reward = 2040, type = 1702}
}
, 
[1703] = {
[70] = {id = 70, item_reward = 2004, type = 1703}
, 
[72] = {id = 72, item_reward = 2007, type = 1703}
, 
[73] = {id = 73, type = 1703}
, 
[75] = {id = 75, item_reward = 2012, type = 1703}
, 
[77] = {id = 77, item_reward = 2014, type = 1703}
, 
[81] = {id = 81, item_reward = 2020, type = 1703}
, 
[82] = {id = 82, item_reward = 2021, type = 1703}
, 
[83] = {id = 83, item_reward = 2023, type = 1703}
, 
[85] = {id = 85, item_reward = 2027, type = 1703}
, 
[90] = {id = 90, item_reward = 2034, type = 1703}
, 
[91] = {id = 91, item_reward = 2035, type = 1703}
, 
[92] = {id = 92, item_reward = 2036, type = 1703}
}
, 
[1801] = {
[99] = {id = 99, item_reward = 2008, type = 1801}
, 
[100] = {id = 100, item_reward = 2010, type = 1801}
, 
[101] = {id = 101, item_reward = 2016, type = 1801}
, 
[102] = {id = 102, item_reward = 2018, type = 1801}
, 
[103] = {id = 103, item_reward = 2025, type = 1801}
, 
[104] = {id = 104, item_reward = 2026, type = 1801}
, 
[105] = {id = 105, item_reward = 2028, type = 1801}
, 
[106] = {id = 106, item_reward = 2037, type = 1801}
, 
[107] = {id = 107, item_reward = 2039, type = 1801}
, 
[108] = {id = 108, item_reward = 2022, type = 1801}
, 
[109] = {id = 109, item_reward = 2041, type = 1801}
, 
[110] = {id = 110, item_reward = 2042, type = 1801}
, 
[111] = {id = 111, item_reward = 2043, type = 1801}
}
, 
[1802] = {
[73] = {id = 73, item_reward = 2002, type = 1802}
, 
[75] = {id = 75, item_reward = 2006, type = 1802}
, 
[78] = {id = 78, item_reward = 2011, type = 1802}
, 
[80] = {id = 80, item_reward = 2013, type = 1802}
, 
[82] = {id = 82, item_reward = 2015, type = 1802}
, 
[83] = {id = 83, item_reward = 2017, type = 1802}
, 
[84] = {id = 84, item_reward = 2019, type = 1802}
, 
[88] = {id = 88, item_reward = 2024, type = 1802}
, 
[90] = {id = 90, item_reward = 2030, type = 1802}
, 
[91] = {id = 91, item_reward = 2031, type = 1802}
, 
[92] = {id = 92, item_reward = 2032, type = 1802}
, 
[93] = {id = 93, item_reward = 2033, type = 1802}
, 
[97] = {id = 97, item_reward = 2038, type = 1802}
, 
[98] = {id = 98, item_reward = 2040, type = 1802}
}
, 
[1803] = {
[74] = {id = 74, item_reward = 2004, type = 1803}
, 
[76] = {id = 76, item_reward = 2007, type = 1803}
, 
[77] = {id = 77, type = 1803}
, 
[79] = {id = 79, item_reward = 2012, type = 1803}
, 
[81] = {id = 81, item_reward = 2014, type = 1803}
, 
[85] = {id = 85, item_reward = 2020, type = 1803}
, 
[86] = {id = 86, item_reward = 2021, type = 1803}
, 
[87] = {id = 87, item_reward = 2023, type = 1803}
, 
[89] = {id = 89, item_reward = 2027, type = 1803}
, 
[94] = {id = 94, item_reward = 2034, type = 1803}
, 
[95] = {id = 95, item_reward = 2035, type = 1803}
, 
[96] = {id = 96, item_reward = 2036, type = 1803}
}
, 
[1901] = {
[129] = {id = 129, item_reward = 2008, type = 1901}
, 
[130] = {id = 130, item_reward = 2010, type = 1901}
, 
[131] = {id = 131, item_reward = 2022, type = 1901}
, 
[132] = {id = 132, item_reward = 2045, type = 1901}
, 
[133] = {id = 133, item_reward = 2043, type = 1901}
, 
[134] = {id = 134, item_reward = 2028, type = 1901}
, 
[135] = {id = 135, item_reward = 2026, type = 1901}
, 
[136] = {id = 136, item_reward = 2041, type = 1901}
}
, 
[1902] = {
[103] = {id = 103, item_reward = 2002, type = 1902}
, 
[105] = {id = 105, item_reward = 2006, type = 1902}
, 
[108] = {id = 108, item_reward = 2011, type = 1902}
, 
[110] = {id = 110, item_reward = 2013, type = 1902}
, 
[112] = {id = 112, item_reward = 2015, type = 1902}
, 
[113] = {id = 113, item_reward = 2017, type = 1902}
, 
[114] = {id = 114, item_reward = 2019, type = 1902}
, 
[118] = {id = 118, item_reward = 2024, type = 1902}
, 
[120] = {id = 120, item_reward = 2030, type = 1902}
, 
[121] = {id = 121, item_reward = 2031, type = 1902}
, 
[122] = {id = 122, item_reward = 2032, type = 1902}
, 
[123] = {id = 123, item_reward = 2033, type = 1902}
, 
[127] = {id = 127, item_reward = 2038, type = 1902}
, 
[128] = {id = 128, item_reward = 2040, type = 1902}
}
, 
[1903] = {
[104] = {id = 104, item_reward = 2004, type = 1903}
, 
[106] = {id = 106, item_reward = 2007, type = 1903}
, 
[107] = {id = 107, type = 1903}
, 
[109] = {id = 109, item_reward = 2012, type = 1903}
, 
[111] = {id = 111, item_reward = 2014, type = 1903}
, 
[115] = {id = 115, item_reward = 2020, type = 1903}
, 
[116] = {id = 116, item_reward = 2021, type = 1903}
, 
[117] = {id = 117, item_reward = 2023, type = 1903}
, 
[119] = {id = 119, item_reward = 2027, type = 1903}
, 
[124] = {id = 124, item_reward = 2034, type = 1903}
, 
[125] = {id = 125, item_reward = 2035, type = 1903}
, 
[126] = {id = 126, item_reward = 2036, type = 1903}
}
, 
[2001] = {
[299] = {id = 299, item_reward = 2025, type = 2001}
, 
[300] = {id = 300, item_reward = 2016, type = 2001}
, 
[301] = {id = 301, item_reward = 2037, type = 2001}
, 
[302] = {id = 302, item_reward = 2018, type = 2001}
, 
[303] = {id = 303, item_reward = 2010, type = 2001}
, 
[304] = {id = 304, item_reward = 2026, type = 2001}
, 
[305] = {id = 305, item_reward = 2039, type = 2001}
, 
[306] = {id = 306, item_reward = 2042, type = 2001}
}
, 
[2002] = {
[273] = {id = 273, item_reward = 2002, type = 2002}
, 
[275] = {id = 275, item_reward = 2006, type = 2002}
, 
[278] = {id = 278, item_reward = 2011, type = 2002}
, 
[280] = {id = 280, item_reward = 2013, type = 2002}
, 
[282] = {id = 282, item_reward = 2015, type = 2002}
, 
[283] = {id = 283, item_reward = 2017, type = 2002}
, 
[284] = {id = 284, item_reward = 2019, type = 2002}
, 
[288] = {id = 288, item_reward = 2024, type = 2002}
, 
[290] = {id = 290, item_reward = 2030, type = 2002}
, 
[291] = {id = 291, item_reward = 2031, type = 2002}
, 
[292] = {id = 292, item_reward = 2032, type = 2002}
, 
[293] = {id = 293, item_reward = 2033, type = 2002}
, 
[297] = {id = 297, item_reward = 2038, type = 2002}
, 
[298] = {id = 298, item_reward = 2040, type = 2002}
}
, 
[2003] = {
[274] = {id = 274, item_reward = 2004, type = 2003}
, 
[276] = {id = 276, item_reward = 2007, type = 2003}
, 
[277] = {id = 277, type = 2003}
, 
[279] = {id = 279, item_reward = 2012, type = 2003}
, 
[281] = {id = 281, item_reward = 2014, type = 2003}
, 
[285] = {id = 285, item_reward = 2020, type = 2003}
, 
[286] = {id = 286, item_reward = 2021, type = 2003}
, 
[287] = {id = 287, item_reward = 2023, type = 2003}
, 
[289] = {id = 289, item_reward = 2027, type = 2003}
, 
[294] = {id = 294, item_reward = 2034, type = 2003}
, 
[295] = {id = 295, item_reward = 2035, type = 2003}
, 
[296] = {id = 296, item_reward = 2036, type = 2003}
}
, 
[2101] = {
[333] = {id = 333, item_reward = 2025, type = 2101}
, 
[334] = {id = 334, item_reward = 2046, type = 2101}
, 
[335] = {id = 335, item_reward = 2044, type = 2101}
, 
[336] = {id = 336, item_reward = 2028, type = 2101}
, 
[337] = {id = 337, item_reward = 2041, type = 2101}
, 
[338] = {id = 338, item_reward = 2026, type = 2101}
, 
[339] = {id = 339, item_reward = 2039, type = 2101}
, 
[340] = {id = 340, item_reward = 2042, type = 2101}
}
, 
[2102] = {
[307] = {id = 307, item_reward = 2002, type = 2102}
, 
[309] = {id = 309, item_reward = 2006, type = 2102}
, 
[312] = {id = 312, item_reward = 2011, type = 2102}
, 
[314] = {id = 314, item_reward = 2013, type = 2102}
, 
[316] = {id = 316, item_reward = 2015, type = 2102}
, 
[317] = {id = 317, item_reward = 2017, type = 2102}
, 
[318] = {id = 318, item_reward = 2019, type = 2102}
, 
[322] = {id = 322, item_reward = 2024, type = 2102}
, 
[324] = {id = 324, item_reward = 2030, type = 2102}
, 
[325] = {id = 325, item_reward = 2031, type = 2102}
, 
[326] = {id = 326, item_reward = 2032, type = 2102}
, 
[327] = {id = 327, item_reward = 2033, type = 2102}
, 
[331] = {id = 331, item_reward = 2038, type = 2102}
, 
[332] = {id = 332, item_reward = 2040, type = 2102}
}
, 
[2103] = {
[308] = {id = 308, item_reward = 2004, type = 2103}
, 
[310] = {id = 310, item_reward = 2007, type = 2103}
, 
[311] = {id = 311, type = 2103}
, 
[313] = {id = 313, item_reward = 2012, type = 2103}
, 
[315] = {id = 315, item_reward = 2014, type = 2103}
, 
[319] = {id = 319, item_reward = 2020, type = 2103}
, 
[320] = {id = 320, item_reward = 2021, type = 2103}
, 
[321] = {id = 321, item_reward = 2023, type = 2103}
, 
[323] = {id = 323, item_reward = 2027, type = 2103}
, 
[328] = {id = 328, item_reward = 2034, type = 2103}
, 
[329] = {id = 329, item_reward = 2035, type = 2103}
, 
[330] = {id = 330, item_reward = 2036, type = 2103}
}
, 
[2201] = {
[367] = {id = 367, item_reward = 2044, type = 2201}
, 
[368] = {id = 368, item_reward = 2016, type = 2201}
, 
[369] = {id = 369, item_reward = 2037, type = 2201}
, 
[370] = {id = 370, item_reward = 2018, type = 2201}
, 
[371] = {id = 371, item_reward = 2010, type = 2201}
, 
[372] = {id = 372, item_reward = 2026, type = 2201}
, 
[373] = {id = 373, item_reward = 2039, type = 2201}
, 
[374] = {id = 374, item_reward = 2042, type = 2201}
}
, 
[2202] = {
[341] = {id = 341, item_reward = 2002, type = 2202}
, 
[343] = {id = 343, item_reward = 2006, type = 2202}
, 
[346] = {id = 346, item_reward = 2011, type = 2202}
, 
[348] = {id = 348, item_reward = 2013, type = 2202}
, 
[350] = {id = 350, item_reward = 2015, type = 2202}
, 
[351] = {id = 351, item_reward = 2017, type = 2202}
, 
[352] = {id = 352, item_reward = 2019, type = 2202}
, 
[356] = {id = 356, item_reward = 2024, type = 2202}
, 
[358] = {id = 358, item_reward = 2030, type = 2202}
, 
[359] = {id = 359, item_reward = 2031, type = 2202}
, 
[360] = {id = 360, item_reward = 2032, type = 2202}
, 
[361] = {id = 361, item_reward = 2033, type = 2202}
, 
[365] = {id = 365, item_reward = 2038, type = 2202}
, 
[366] = {id = 366, item_reward = 2040, type = 2202}
}
, 
[2203] = {
[342] = {id = 342, item_reward = 2004, type = 2203}
, 
[344] = {id = 344, item_reward = 2007, type = 2203}
, 
[345] = {id = 345, type = 2203}
, 
[347] = {id = 347, item_reward = 2012, type = 2203}
, 
[349] = {id = 349, item_reward = 2014, type = 2203}
, 
[353] = {id = 353, item_reward = 2020, type = 2203}
, 
[354] = {id = 354, item_reward = 2021, type = 2203}
, 
[355] = {id = 355, item_reward = 2023, type = 2203}
, 
[357] = {id = 357, item_reward = 2027, type = 2203}
, 
[362] = {id = 362, item_reward = 2034, type = 2203}
, 
[363] = {id = 363, item_reward = 2035, type = 2203}
, 
[364] = {id = 364, item_reward = 2036, type = 2203}
}
, 
[2301] = {
[401] = {id = 401, item_reward = 2044, type = 2301}
, 
[402] = {id = 402, item_reward = 2016, type = 2301}
, 
[403] = {id = 403, item_reward = 2025, type = 2301}
, 
[404] = {id = 404, item_reward = 2018, type = 2301}
, 
[405] = {id = 405, item_reward = 2028, type = 2301}
, 
[406] = {id = 406, item_reward = 2026, type = 2301}
, 
[407] = {id = 407, item_reward = 2041, type = 2301}
, 
[408] = {id = 408, item_reward = 2042, type = 2301}
}
, 
[2302] = {
[375] = {id = 375, item_reward = 2002, type = 2302}
, 
[377] = {id = 377, item_reward = 2006, type = 2302}
, 
[380] = {id = 380, item_reward = 2011, type = 2302}
, 
[382] = {id = 382, item_reward = 2013, type = 2302}
, 
[384] = {id = 384, item_reward = 2015, type = 2302}
, 
[385] = {id = 385, item_reward = 2017, type = 2302}
, 
[386] = {id = 386, item_reward = 2019, type = 2302}
, 
[390] = {id = 390, item_reward = 2024, type = 2302}
, 
[392] = {id = 392, item_reward = 2030, type = 2302}
, 
[393] = {id = 393, item_reward = 2031, type = 2302}
, 
[394] = {id = 394, item_reward = 2032, type = 2302}
, 
[395] = {id = 395, item_reward = 2033, type = 2302}
, 
[399] = {id = 399, item_reward = 2038, type = 2302}
, 
[400] = {id = 400, item_reward = 2040, type = 2302}
}
, 
[2303] = {
[376] = {id = 376, item_reward = 2004, type = 2303}
, 
[378] = {id = 378, item_reward = 2007, type = 2303}
, 
[379] = {id = 379, type = 2303}
, 
[381] = {id = 381, item_reward = 2012, type = 2303}
, 
[383] = {id = 383, item_reward = 2014, type = 2303}
, 
[387] = {id = 387, item_reward = 2020, type = 2303}
, 
[388] = {id = 388, item_reward = 2021, type = 2303}
, 
[389] = {id = 389, item_reward = 2023, type = 2303}
, 
[391] = {id = 391, item_reward = 2027, type = 2303}
, 
[396] = {id = 396, item_reward = 2034, type = 2303}
, 
[397] = {id = 397, item_reward = 2035, type = 2303}
, 
[398] = {id = 398, item_reward = 2036, type = 2303}
}
, 
[2401] = {
[163] = {id = 163, item_reward = 2008, type = 2401}
, 
[164] = {id = 164, item_reward = 2010, type = 2401}
, 
[165] = {id = 165, item_reward = 2022, type = 2401}
, 
[166] = {id = 166, item_reward = 2037, type = 2401}
, 
[167] = {id = 167, item_reward = 2043, type = 2401}
, 
[168] = {id = 168, item_reward = 2044, type = 2401}
, 
[169] = {id = 169, item_reward = 2039, type = 2401}
, 
[170] = {id = 170, item_reward = 2041, type = 2401}
}
, 
[2402] = {
[137] = {id = 137, item_reward = 2002, type = 2402}
, 
[139] = {id = 139, item_reward = 2006, type = 2402}
, 
[142] = {id = 142, item_reward = 2011, type = 2402}
, 
[144] = {id = 144, item_reward = 2013, type = 2402}
, 
[146] = {id = 146, item_reward = 2015, type = 2402}
, 
[147] = {id = 147, item_reward = 2017, type = 2402}
, 
[148] = {id = 148, item_reward = 2019, type = 2402}
, 
[152] = {id = 152, item_reward = 2024, type = 2402}
, 
[154] = {id = 154, item_reward = 2030, type = 2402}
, 
[155] = {id = 155, item_reward = 2031, type = 2402}
, 
[156] = {id = 156, item_reward = 2032, type = 2402}
, 
[157] = {id = 157, item_reward = 2033, type = 2402}
, 
[161] = {id = 161, item_reward = 2038, type = 2402}
, 
[162] = {id = 162, item_reward = 2040, type = 2402}
}
, 
[2403] = {
[138] = {id = 138, item_reward = 2004, type = 2403}
, 
[140] = {id = 140, item_reward = 2007, type = 2403}
, 
[141] = {id = 141, type = 2403}
, 
[143] = {id = 143, item_reward = 2012, type = 2403}
, 
[145] = {id = 145, item_reward = 2014, type = 2403}
, 
[149] = {id = 149, item_reward = 2020, type = 2403}
, 
[150] = {id = 150, item_reward = 2021, type = 2403}
, 
[151] = {id = 151, item_reward = 2023, type = 2403}
, 
[153] = {id = 153, item_reward = 2027, type = 2403}
, 
[158] = {id = 158, item_reward = 2034, type = 2403}
, 
[159] = {id = 159, item_reward = 2035, type = 2403}
, 
[160] = {id = 160, item_reward = 2036, type = 2403}
}
, 
[2501] = {
[435] = {id = 435, item_reward = 2037, type = 2501}
, 
[436] = {id = 436, item_reward = 2016, type = 2501}
, 
[437] = {id = 437, item_reward = 2025, type = 2501}
, 
[438] = {id = 438, item_reward = 2018, type = 2501}
, 
[439] = {id = 439, item_reward = 2028, type = 2501}
, 
[440] = {id = 440, item_reward = 2026, type = 2501}
, 
[441] = {id = 441, item_reward = 2048, type = 2501}
, 
[442] = {id = 442, item_reward = 2042, type = 2501}
}
, 
[2502] = {
[409] = {id = 409, item_reward = 2002, type = 2502}
, 
[411] = {id = 411, item_reward = 2006, type = 2502}
, 
[414] = {id = 414, item_reward = 2011, type = 2502}
, 
[416] = {id = 416, item_reward = 2013, type = 2502}
, 
[418] = {id = 418, item_reward = 2015, type = 2502}
, 
[419] = {id = 419, item_reward = 2017, type = 2502}
, 
[420] = {id = 420, item_reward = 2019, type = 2502}
, 
[424] = {id = 424, item_reward = 2024, type = 2502}
, 
[426] = {id = 426, item_reward = 2030, type = 2502}
, 
[427] = {id = 427, item_reward = 2031, type = 2502}
, 
[428] = {id = 428, item_reward = 2032, type = 2502}
, 
[429] = {id = 429, item_reward = 2033, type = 2502}
, 
[433] = {id = 433, item_reward = 2038, type = 2502}
, 
[434] = {id = 434, item_reward = 2040, type = 2502}
}
, 
[2503] = {
[410] = {id = 410, item_reward = 2004, type = 2503}
, 
[412] = {id = 412, item_reward = 2007, type = 2503}
, 
[413] = {id = 413, type = 2503}
, 
[415] = {id = 415, item_reward = 2012, type = 2503}
, 
[417] = {id = 417, item_reward = 2014, type = 2503}
, 
[421] = {id = 421, item_reward = 2020, type = 2503}
, 
[422] = {id = 422, item_reward = 2021, type = 2503}
, 
[423] = {id = 423, item_reward = 2023, type = 2503}
, 
[425] = {id = 425, item_reward = 2027, type = 2503}
, 
[430] = {id = 430, item_reward = 2034, type = 2503}
, 
[431] = {id = 431, item_reward = 2035, type = 2503}
, 
[432] = {id = 432, item_reward = 2036, type = 2503}
}
, 
[2601] = {
[469] = {id = 469, item_reward = 2037, type = 2601}
, 
[470] = {id = 470, item_reward = 2016, type = 2601}
, 
[471] = {id = 471, item_reward = 2010, type = 2601}
, 
[472] = {id = 472, item_reward = 2018, type = 2601}
, 
[473] = {id = 473, item_reward = 2028, type = 2601}
, 
[474] = {id = 474, item_reward = 2026, type = 2601}
, 
[475] = {id = 475, item_reward = 2044, type = 2601}
, 
[476] = {id = 476, item_reward = 2039, type = 2601}
}
, 
[2602] = {
[443] = {id = 443, item_reward = 2002, type = 2602}
, 
[445] = {id = 445, item_reward = 2006, type = 2602}
, 
[448] = {id = 448, item_reward = 2011, type = 2602}
, 
[450] = {id = 450, item_reward = 2013, type = 2602}
, 
[452] = {id = 452, item_reward = 2015, type = 2602}
, 
[453] = {id = 453, item_reward = 2017, type = 2602}
, 
[454] = {id = 454, item_reward = 2019, type = 2602}
, 
[458] = {id = 458, item_reward = 2024, type = 2602}
, 
[460] = {id = 460, item_reward = 2030, type = 2602}
, 
[461] = {id = 461, item_reward = 2031, type = 2602}
, 
[462] = {id = 462, item_reward = 2032, type = 2602}
, 
[463] = {id = 463, item_reward = 2033, type = 2602}
, 
[467] = {id = 467, item_reward = 2038, type = 2602}
, 
[468] = {id = 468, item_reward = 2040, type = 2602}
}
, 
[2603] = {
[444] = {id = 444, item_reward = 2004, type = 2603}
, 
[446] = {id = 446, item_reward = 2007, type = 2603}
, 
[447] = {id = 447, type = 2603}
, 
[449] = {id = 449, item_reward = 2012, type = 2603}
, 
[451] = {id = 451, item_reward = 2014, type = 2603}
, 
[455] = {id = 455, item_reward = 2020, type = 2603}
, 
[456] = {id = 456, item_reward = 2021, type = 2603}
, 
[457] = {id = 457, item_reward = 2023, type = 2603}
, 
[459] = {id = 459, item_reward = 2027, type = 2603}
, 
[464] = {id = 464, item_reward = 2034, type = 2603}
, 
[465] = {id = 465, item_reward = 2035, type = 2603}
, 
[466] = {id = 466, item_reward = 2036, type = 2603}
}
, 
[2701] = {
[138] = {id = 138, item_reward = 2008, type = 2701}
, 
[139] = {id = 139, item_reward = 2010, type = 2701}
, 
[140] = {id = 140, item_reward = 2016, type = 2701}
, 
[141] = {id = 141, item_reward = 2018, type = 2701}
, 
[142] = {id = 142, item_reward = 2025, type = 2701}
, 
[143] = {id = 143, item_reward = 2026, type = 2701}
, 
[144] = {id = 144, item_reward = 2028, type = 2701}
, 
[145] = {id = 145, item_reward = 2037, type = 2701}
, 
[146] = {id = 146, item_reward = 2039, type = 2701}
, 
[147] = {id = 147, item_reward = 2022, type = 2701}
, 
[148] = {id = 148, item_reward = 2041, type = 2701}
, 
[149] = {id = 149, item_reward = 2042, type = 2701}
, 
[150] = {id = 150, item_reward = 2043, type = 2701}
, 
[151] = {id = 151, item_reward = 2048, type = 2701}
}
, 
[2702] = {
[112] = {id = 112, item_reward = 2002, type = 2702}
, 
[114] = {id = 114, item_reward = 2006, type = 2702}
, 
[117] = {id = 117, item_reward = 2011, type = 2702}
, 
[119] = {id = 119, item_reward = 2013, type = 2702}
, 
[121] = {id = 121, item_reward = 2015, type = 2702}
, 
[122] = {id = 122, item_reward = 2017, type = 2702}
, 
[123] = {id = 123, item_reward = 2019, type = 2702}
, 
[127] = {id = 127, item_reward = 2024, type = 2702}
, 
[129] = {id = 129, item_reward = 2030, type = 2702}
, 
[130] = {id = 130, item_reward = 2031, type = 2702}
, 
[131] = {id = 131, item_reward = 2032, type = 2702}
, 
[132] = {id = 132, item_reward = 2033, type = 2702}
, 
[136] = {id = 136, item_reward = 2038, type = 2702}
, 
[137] = {id = 137, item_reward = 2040, type = 2702}
}
, 
[2703] = {
[113] = {id = 113, item_reward = 2004, type = 2703}
, 
[115] = {id = 115, item_reward = 2007, type = 2703}
, 
[116] = {id = 116, type = 2703}
, 
[118] = {id = 118, item_reward = 2012, type = 2703}
, 
[120] = {id = 120, item_reward = 2014, type = 2703}
, 
[124] = {id = 124, item_reward = 2020, type = 2703}
, 
[125] = {id = 125, item_reward = 2021, type = 2703}
, 
[126] = {id = 126, item_reward = 2023, type = 2703}
, 
[128] = {id = 128, item_reward = 2027, type = 2703}
, 
[133] = {id = 133, item_reward = 2034, type = 2703}
, 
[134] = {id = 134, item_reward = 2035, type = 2703}
, 
[135] = {id = 135, item_reward = 2036, type = 2703}
}
, 
[2801] = {
[503] = {id = 503, item_reward = 2041, type = 2801}
, 
[504] = {id = 504, item_reward = 2016, type = 2801}
, 
[505] = {id = 505, item_reward = 2010, type = 2801}
, 
[506] = {id = 506, item_reward = 2025, type = 2801}
, 
[507] = {id = 507, item_reward = 2042, type = 2801}
, 
[508] = {id = 508, item_reward = 2026, type = 2801}
, 
[509] = {id = 509, item_reward = 2044, type = 2801}
, 
[510] = {id = 510, item_reward = 2039, type = 2801}
}
, 
[2802] = {
[477] = {id = 477, item_reward = 2002, type = 2802}
, 
[479] = {id = 479, item_reward = 2006, type = 2802}
, 
[482] = {id = 482, item_reward = 2011, type = 2802}
, 
[484] = {id = 484, item_reward = 2013, type = 2802}
, 
[486] = {id = 486, item_reward = 2015, type = 2802}
, 
[487] = {id = 487, item_reward = 2017, type = 2802}
, 
[488] = {id = 488, item_reward = 2019, type = 2802}
, 
[492] = {id = 492, item_reward = 2024, type = 2802}
, 
[494] = {id = 494, item_reward = 2030, type = 2802}
, 
[495] = {id = 495, item_reward = 2031, type = 2802}
, 
[496] = {id = 496, item_reward = 2032, type = 2802}
, 
[497] = {id = 497, item_reward = 2033, type = 2802}
, 
[501] = {id = 501, item_reward = 2038, type = 2802}
, 
[502] = {id = 502, item_reward = 2040, type = 2802}
}
, 
[2803] = {
[478] = {id = 478, item_reward = 2004, type = 2803}
, 
[480] = {id = 480, item_reward = 2007, type = 2803}
, 
[481] = {id = 481, type = 2803}
, 
[483] = {id = 483, item_reward = 2012, type = 2803}
, 
[485] = {id = 485, item_reward = 2014, type = 2803}
, 
[489] = {id = 489, item_reward = 2020, type = 2803}
, 
[490] = {id = 490, item_reward = 2021, type = 2803}
, 
[491] = {id = 491, item_reward = 2023, type = 2803}
, 
[493] = {id = 493, item_reward = 2027, type = 2803}
, 
[498] = {id = 498, item_reward = 2034, type = 2803}
, 
[499] = {id = 499, item_reward = 2035, type = 2803}
, 
[500] = {id = 500, item_reward = 2036, type = 2803}
}
, 
[2901] = {
[537] = {id = 537, item_reward = 2037, type = 2901}
, 
[538] = {id = 538, item_reward = 2049, type = 2901}
, 
[539] = {id = 539, item_reward = 2010, type = 2901}
, 
[540] = {id = 540, item_reward = 2018, type = 2901}
, 
[541] = {id = 541, item_reward = 2028, type = 2901}
, 
[542] = {id = 542, item_reward = 2026, type = 2901}
, 
[543] = {id = 543, item_reward = 2042, type = 2901}
, 
[544] = {id = 544, item_reward = 2046, type = 2901}
}
, 
[2902] = {
[511] = {id = 511, item_reward = 2002, type = 2902}
, 
[513] = {id = 513, item_reward = 2006, type = 2902}
, 
[516] = {id = 516, item_reward = 2011, type = 2902}
, 
[518] = {id = 518, item_reward = 2013, type = 2902}
, 
[520] = {id = 520, item_reward = 2015, type = 2902}
, 
[521] = {id = 521, item_reward = 2017, type = 2902}
, 
[522] = {id = 522, item_reward = 2019, type = 2902}
, 
[526] = {id = 526, item_reward = 2024, type = 2902}
, 
[528] = {id = 528, item_reward = 2030, type = 2902}
, 
[529] = {id = 529, item_reward = 2031, type = 2902}
, 
[530] = {id = 530, item_reward = 2032, type = 2902}
, 
[531] = {id = 531, item_reward = 2033, type = 2902}
, 
[535] = {id = 535, item_reward = 2038, type = 2902}
, 
[536] = {id = 536, item_reward = 2040, type = 2902}
}
, 
[2903] = {
[512] = {id = 512, item_reward = 2004, type = 2903}
, 
[514] = {id = 514, item_reward = 2007, type = 2903}
, 
[515] = {id = 515, type = 2903}
, 
[517] = {id = 517, item_reward = 2012, type = 2903}
, 
[519] = {id = 519, item_reward = 2014, type = 2903}
, 
[523] = {id = 523, item_reward = 2020, type = 2903}
, 
[524] = {id = 524, item_reward = 2021, type = 2903}
, 
[525] = {id = 525, item_reward = 2023, type = 2903}
, 
[527] = {id = 527, item_reward = 2027, type = 2903}
, 
[532] = {id = 532, item_reward = 2034, type = 2903}
, 
[533] = {id = 533, item_reward = 2035, type = 2903}
, 
[534] = {id = 534, item_reward = 2036, type = 2903}
}
, 
[3001] = {
[178] = {id = 178, item_reward = 2008, type = 3001}
, 
[179] = {id = 179, item_reward = 2044, type = 3001}
, 
[180] = {id = 180, item_reward = 2016, type = 3001}
, 
[181] = {id = 181, item_reward = 2018, type = 3001}
, 
[182] = {id = 182, item_reward = 2025, type = 3001}
, 
[183] = {id = 183, item_reward = 2045, type = 3001}
, 
[184] = {id = 184, item_reward = 2028, type = 3001}
, 
[185] = {id = 185, item_reward = 2037, type = 3001}
, 
[186] = {id = 186, item_reward = 2039, type = 3001}
, 
[187] = {id = 187, item_reward = 2022, type = 3001}
, 
[188] = {id = 188, item_reward = 2041, type = 3001}
, 
[189] = {id = 189, item_reward = 2042, type = 3001}
, 
[190] = {id = 190, item_reward = 2043, type = 3001}
, 
[191] = {id = 191, item_reward = 2049, type = 3001}
}
, 
[3002] = {
[152] = {id = 152, item_reward = 2002, type = 3002}
, 
[154] = {id = 154, item_reward = 2006, type = 3002}
, 
[157] = {id = 157, item_reward = 2011, type = 3002}
, 
[159] = {id = 159, item_reward = 2013, type = 3002}
, 
[161] = {id = 161, item_reward = 2015, type = 3002}
, 
[162] = {id = 162, item_reward = 2017, type = 3002}
, 
[163] = {id = 163, item_reward = 2019, type = 3002}
, 
[167] = {id = 167, item_reward = 2024, type = 3002}
, 
[169] = {id = 169, item_reward = 2030, type = 3002}
, 
[170] = {id = 170, item_reward = 2031, type = 3002}
, 
[171] = {id = 171, item_reward = 2032, type = 3002}
, 
[172] = {id = 172, item_reward = 2033, type = 3002}
, 
[176] = {id = 176, item_reward = 2038, type = 3002}
, 
[177] = {id = 177, item_reward = 2040, type = 3002}
}
, 
[3003] = {
[153] = {id = 153, item_reward = 2004, type = 3003}
, 
[155] = {id = 155, item_reward = 2007, type = 3003}
, 
[156] = {id = 156, type = 3003}
, 
[158] = {id = 158, item_reward = 2012, type = 3003}
, 
[160] = {id = 160, item_reward = 2014, type = 3003}
, 
[164] = {id = 164, item_reward = 2020, type = 3003}
, 
[165] = {id = 165, item_reward = 2021, type = 3003}
, 
[166] = {id = 166, item_reward = 2023, type = 3003}
, 
[168] = {id = 168, item_reward = 2027, type = 3003}
, 
[173] = {id = 173, item_reward = 2034, type = 3003}
, 
[174] = {id = 174, item_reward = 2035, type = 3003}
, 
[175] = {id = 175, item_reward = 2036, type = 3003}
}
, 
[3101] = {
[27] = {id = 27, item_reward = 2037, type = 3101}
, 
[28] = {id = 28, item_reward = 2049, type = 3101}
, 
[29] = {id = 29, item_reward = 2010, type = 3101}
, 
[30] = {id = 30, item_reward = 2018, type = 3101}
, 
[31] = {id = 31, item_reward = 2028, type = 3101}
, 
[32] = {id = 32, item_reward = 2026, type = 3101}
, 
[33] = {id = 33, item_reward = 2042, type = 3101}
, 
[34] = {id = 34, item_reward = 2046, type = 3101}
}
, 
[3102] = {
{id = 1, item_reward = 2002, type = 3102}
; 
[3] = {id = 3, item_reward = 2006, type = 3102}
, 
[6] = {id = 6, item_reward = 2011, type = 3102}
, 
[8] = {id = 8, item_reward = 2013, type = 3102}
, 
[10] = {item_reward = 2015, type = 3102}
, 
[11] = {id = 11, item_reward = 2017, type = 3102}
, 
[12] = {id = 12, item_reward = 2019, type = 3102}
, 
[16] = {id = 16, item_reward = 2024, type = 3102}
, 
[18] = {id = 18, item_reward = 2030, type = 3102}
, 
[19] = {id = 19, item_reward = 2031, type = 3102}
, 
[20] = {id = 20, item_reward = 2032, type = 3102}
, 
[21] = {id = 21, item_reward = 2033, type = 3102}
, 
[25] = {id = 25, item_reward = 2038, type = 3102}
, 
[26] = {id = 26, item_reward = 2040, type = 3102}
}
, 
[3103] = {
[2] = {id = 2, item_reward = 2004, type = 3103}
, 
[4] = {id = 4, item_reward = 2007, type = 3103}
, 
[5] = {id = 5, type = 3103}
, 
[7] = {id = 7, item_reward = 2012, type = 3103}
, 
[9] = {id = 9, item_reward = 2014, type = 3103}
, 
[13] = {id = 13, item_reward = 2020, type = 3103}
, 
[14] = {id = 14, item_reward = 2021, type = 3103}
, 
[15] = {id = 15, item_reward = 2023, type = 3103}
, 
[17] = {id = 17, item_reward = 2027, type = 3103}
, 
[22] = {id = 22, item_reward = 2034, type = 3103}
, 
[23] = {id = 23, item_reward = 2035, type = 3103}
, 
[24] = {id = 24, item_reward = 2036, type = 3103}
}
, 
[3201] = {
[571] = {id = 571, item_reward = 2025, type = 3201}
, 
[572] = {id = 572, item_reward = 2016, type = 3201}
, 
[573] = {id = 573, item_reward = 2037, type = 3201}
, 
[574] = {id = 574, item_reward = 2018, type = 3201}
, 
[575] = {id = 575, item_reward = 2041, type = 3201}
, 
[576] = {id = 576, item_reward = 2044, type = 3201}
, 
[577] = {id = 577, item_reward = 2039, type = 3201}
, 
[578] = {id = 578, item_reward = 2046, type = 3201}
}
, 
[3202] = {
[545] = {id = 545, item_reward = 2002, type = 3202}
, 
[547] = {id = 547, item_reward = 2006, type = 3202}
, 
[550] = {id = 550, item_reward = 2011, type = 3202}
, 
[552] = {id = 552, item_reward = 2013, type = 3202}
, 
[554] = {id = 554, item_reward = 2015, type = 3202}
, 
[555] = {id = 555, item_reward = 2017, type = 3202}
, 
[556] = {id = 556, item_reward = 2019, type = 3202}
, 
[560] = {id = 560, item_reward = 2024, type = 3202}
, 
[562] = {id = 562, item_reward = 2030, type = 3202}
, 
[563] = {id = 563, item_reward = 2031, type = 3202}
, 
[564] = {id = 564, item_reward = 2032, type = 3202}
, 
[565] = {id = 565, item_reward = 2033, type = 3202}
, 
[569] = {id = 569, item_reward = 2038, type = 3202}
, 
[570] = {id = 570, item_reward = 2040, type = 3202}
}
, 
[3203] = {
[546] = {id = 546, item_reward = 2004, type = 3203}
, 
[548] = {id = 548, item_reward = 2007, type = 3203}
, 
[549] = {id = 549, type = 3203}
, 
[551] = {id = 551, item_reward = 2012, type = 3203}
, 
[553] = {id = 553, item_reward = 2014, type = 3203}
, 
[557] = {id = 557, item_reward = 2020, type = 3203}
, 
[558] = {id = 558, item_reward = 2021, type = 3203}
, 
[559] = {id = 559, item_reward = 2023, type = 3203}
, 
[561] = {id = 561, item_reward = 2027, type = 3203}
, 
[566] = {id = 566, item_reward = 2034, type = 3203}
, 
[567] = {id = 567, item_reward = 2035, type = 3203}
, 
[568] = {id = 568, item_reward = 2036, type = 3203}
}
, 
[3301] = {
[605] = {id = 605, item_reward = 2025, type = 3301}
, 
[606] = {id = 606, item_reward = 2010, type = 3301}
, 
[607] = {id = 607, item_reward = 2026, type = 3301}
, 
[608] = {id = 608, item_reward = 2018, type = 3301}
, 
[609] = {id = 609, item_reward = 2041, type = 3301}
, 
[610] = {id = 610, item_reward = 2044, type = 3301}
, 
[611] = {id = 611, item_reward = 2028, type = 3301}
, 
[612] = {id = 612, item_reward = 2046, type = 3301}
}
, 
[3302] = {
[579] = {id = 579, item_reward = 2002, type = 3302}
, 
[581] = {id = 581, item_reward = 2006, type = 3302}
, 
[584] = {id = 584, item_reward = 2011, type = 3302}
, 
[586] = {id = 586, item_reward = 2013, type = 3302}
, 
[588] = {id = 588, item_reward = 2015, type = 3302}
, 
[589] = {id = 589, item_reward = 2017, type = 3302}
, 
[590] = {id = 590, item_reward = 2019, type = 3302}
, 
[594] = {id = 594, item_reward = 2024, type = 3302}
, 
[596] = {id = 596, item_reward = 2030, type = 3302}
, 
[597] = {id = 597, item_reward = 2031, type = 3302}
, 
[598] = {id = 598, item_reward = 2032, type = 3302}
, 
[599] = {id = 599, item_reward = 2033, type = 3302}
, 
[603] = {id = 603, item_reward = 2038, type = 3302}
, 
[604] = {id = 604, item_reward = 2040, type = 3302}
}
, 
[3303] = {
[580] = {id = 580, item_reward = 2004, type = 3303}
, 
[582] = {id = 582, item_reward = 2007, type = 3303}
, 
[583] = {id = 583, type = 3303}
, 
[585] = {id = 585, item_reward = 2012, type = 3303}
, 
[587] = {id = 587, item_reward = 2014, type = 3303}
, 
[591] = {id = 591, item_reward = 2020, type = 3303}
, 
[592] = {id = 592, item_reward = 2021, type = 3303}
, 
[593] = {id = 593, item_reward = 2023, type = 3303}
, 
[595] = {id = 595, item_reward = 2027, type = 3303}
, 
[600] = {id = 600, item_reward = 2034, type = 3303}
, 
[601] = {id = 601, item_reward = 2035, type = 3303}
, 
[602] = {id = 602, item_reward = 2036, type = 3303}
}
, 
[3401] = {
[639] = {id = 639, item_reward = 2037, type = 3401}
, 
[640] = {id = 640, item_reward = 2010, type = 3401}
, 
[641] = {id = 641, item_reward = 2042, type = 3401}
, 
[642] = {id = 642, item_reward = 2018, type = 3401}
, 
[643] = {id = 643, item_reward = 2039, type = 3401}
, 
[644] = {id = 644, item_reward = 2044, type = 3401}
, 
[645] = {id = 645, item_reward = 2028, type = 3401}
, 
[646] = {id = 646, item_reward = 2016, type = 3401}
}
, 
[3402] = {
[613] = {id = 613, item_reward = 2002, type = 3402}
, 
[615] = {id = 615, item_reward = 2006, type = 3402}
, 
[618] = {id = 618, item_reward = 2011, type = 3402}
, 
[620] = {id = 620, item_reward = 2013, type = 3402}
, 
[622] = {id = 622, item_reward = 2015, type = 3402}
, 
[623] = {id = 623, item_reward = 2017, type = 3402}
, 
[624] = {id = 624, item_reward = 2019, type = 3402}
, 
[628] = {id = 628, item_reward = 2024, type = 3402}
, 
[630] = {id = 630, item_reward = 2030, type = 3402}
, 
[631] = {id = 631, item_reward = 2031, type = 3402}
, 
[632] = {id = 632, item_reward = 2032, type = 3402}
, 
[633] = {id = 633, item_reward = 2033, type = 3402}
, 
[637] = {id = 637, item_reward = 2038, type = 3402}
, 
[638] = {id = 638, item_reward = 2040, type = 3402}
}
, 
[3403] = {
[614] = {id = 614, item_reward = 2004, type = 3403}
, 
[616] = {id = 616, item_reward = 2007, type = 3403}
, 
[617] = {id = 617, type = 3403}
, 
[619] = {id = 619, item_reward = 2012, type = 3403}
, 
[621] = {id = 621, item_reward = 2014, type = 3403}
, 
[625] = {id = 625, item_reward = 2020, type = 3403}
, 
[626] = {id = 626, item_reward = 2021, type = 3403}
, 
[627] = {id = 627, item_reward = 2023, type = 3403}
, 
[629] = {id = 629, item_reward = 2027, type = 3403}
, 
[634] = {id = 634, item_reward = 2034, type = 3403}
, 
[635] = {id = 635, item_reward = 2035, type = 3403}
, 
[636] = {id = 636, item_reward = 2036, type = 3403}
}
, 
[3501] = {
[218] = {id = 218, item_reward = 2010, type = 3501}
, 
[219] = {id = 219, item_reward = 2044, type = 3501}
, 
[220] = {id = 220, item_reward = 2048, type = 3501}
, 
[221] = {id = 221, item_reward = 2046, type = 3501}
, 
[222] = {id = 222, item_reward = 2025, type = 3501}
, 
[223] = {id = 223, item_reward = 2045, type = 3501}
, 
[224] = {id = 224, item_reward = 2028, type = 3501}
, 
[225] = {id = 225, item_reward = 2026, type = 3501}
, 
[226] = {id = 226, item_reward = 2039, type = 3501}
, 
[227] = {id = 227, item_reward = 2022, type = 3501}
, 
[228] = {id = 228, item_reward = 2041, type = 3501}
, 
[229] = {id = 229, item_reward = 2042, type = 3501}
, 
[230] = {id = 230, item_reward = 2043, type = 3501}
, 
[231] = {id = 231, item_reward = 2052, type = 3501}
}
, 
[3502] = {
[192] = {id = 192, item_reward = 2002, type = 3502}
, 
[194] = {id = 194, item_reward = 2006, type = 3502}
, 
[197] = {id = 197, item_reward = 2011, type = 3502}
, 
[199] = {id = 199, item_reward = 2013, type = 3502}
, 
[201] = {id = 201, item_reward = 2015, type = 3502}
, 
[202] = {id = 202, item_reward = 2017, type = 3502}
, 
[203] = {id = 203, item_reward = 2019, type = 3502}
, 
[207] = {id = 207, item_reward = 2024, type = 3502}
, 
[209] = {id = 209, item_reward = 2030, type = 3502}
, 
[210] = {id = 210, item_reward = 2031, type = 3502}
, 
[211] = {id = 211, item_reward = 2032, type = 3502}
, 
[212] = {id = 212, item_reward = 2033, type = 3502}
, 
[216] = {id = 216, item_reward = 2038, type = 3502}
, 
[217] = {id = 217, item_reward = 2040, type = 3502}
}
, 
[3503] = {
[193] = {id = 193, item_reward = 2004, type = 3503}
, 
[195] = {id = 195, item_reward = 2007, type = 3503}
, 
[196] = {id = 196, type = 3503}
, 
[198] = {id = 198, item_reward = 2012, type = 3503}
, 
[200] = {id = 200, item_reward = 2014, type = 3503}
, 
[204] = {id = 204, item_reward = 2020, type = 3503}
, 
[205] = {id = 205, item_reward = 2021, type = 3503}
, 
[206] = {id = 206, item_reward = 2023, type = 3503}
, 
[208] = {id = 208, item_reward = 2027, type = 3503}
, 
[213] = {id = 213, item_reward = 2034, type = 3503}
, 
[214] = {id = 214, item_reward = 2035, type = 3503}
, 
[215] = {id = 215, item_reward = 2036, type = 3503}
}
, 
[3601] = {
[673] = {id = 673, item_reward = 2037, type = 3601}
, 
[674] = {id = 674, item_reward = 2025, type = 3601}
, 
[675] = {id = 675, item_reward = 2052, type = 3601}
, 
[676] = {id = 676, item_reward = 2026, type = 3601}
, 
[677] = {id = 677, item_reward = 2039, type = 3601}
, 
[678] = {id = 678, item_reward = 2041, type = 3601}
, 
[679] = {id = 679, item_reward = 2048, type = 3601}
, 
[680] = {id = 680, item_reward = 2046, type = 3601}
}
, 
[3602] = {
[647] = {id = 647, item_reward = 2002, type = 3602}
, 
[649] = {id = 649, item_reward = 2006, type = 3602}
, 
[652] = {id = 652, item_reward = 2011, type = 3602}
, 
[654] = {id = 654, item_reward = 2013, type = 3602}
, 
[656] = {id = 656, item_reward = 2015, type = 3602}
, 
[657] = {id = 657, item_reward = 2017, type = 3602}
, 
[658] = {id = 658, item_reward = 2019, type = 3602}
, 
[662] = {id = 662, item_reward = 2024, type = 3602}
, 
[664] = {id = 664, item_reward = 2030, type = 3602}
, 
[665] = {id = 665, item_reward = 2031, type = 3602}
, 
[666] = {id = 666, item_reward = 2032, type = 3602}
, 
[667] = {id = 667, item_reward = 2033, type = 3602}
, 
[671] = {id = 671, item_reward = 2038, type = 3602}
, 
[672] = {id = 672, item_reward = 2040, type = 3602}
}
, 
[3603] = {
[648] = {id = 648, item_reward = 2004, type = 3603}
, 
[650] = {id = 650, item_reward = 2007, type = 3603}
, 
[651] = {id = 651, type = 3603}
, 
[653] = {id = 653, item_reward = 2012, type = 3603}
, 
[655] = {id = 655, item_reward = 2014, type = 3603}
, 
[659] = {id = 659, item_reward = 2020, type = 3603}
, 
[660] = {id = 660, item_reward = 2021, type = 3603}
, 
[661] = {id = 661, item_reward = 2023, type = 3603}
, 
[663] = {id = 663, item_reward = 2027, type = 3603}
, 
[668] = {id = 668, item_reward = 2034, type = 3603}
, 
[669] = {id = 669, item_reward = 2035, type = 3603}
, 
[670] = {id = 670, item_reward = 2036, type = 3603}
}
, 
[3701] = {
[163] = {id = 163, item_reward = 2008, type = 3701}
, 
[164] = {id = 164, item_reward = 2028, type = 3701}
, 
[165] = {id = 165, item_reward = 2022, type = 3701}
, 
[166] = {id = 166, item_reward = 2037, type = 3701}
, 
[167] = {id = 167, item_reward = 2043, type = 3701}
, 
[168] = {id = 168, item_reward = 2042, type = 3701}
, 
[169] = {id = 169, item_reward = 2039, type = 3701}
, 
[170] = {id = 170, item_reward = 2045, type = 3701}
}
, 
[3702] = {
[137] = {id = 137, item_reward = 2002, type = 3702}
, 
[139] = {id = 139, item_reward = 2006, type = 3702}
, 
[142] = {id = 142, item_reward = 2011, type = 3702}
, 
[144] = {id = 144, item_reward = 2013, type = 3702}
, 
[146] = {id = 146, item_reward = 2015, type = 3702}
, 
[147] = {id = 147, item_reward = 2017, type = 3702}
, 
[148] = {id = 148, item_reward = 2019, type = 3702}
, 
[152] = {id = 152, item_reward = 2024, type = 3702}
, 
[154] = {id = 154, item_reward = 2030, type = 3702}
, 
[155] = {id = 155, item_reward = 2031, type = 3702}
, 
[156] = {id = 156, item_reward = 2032, type = 3702}
, 
[157] = {id = 157, item_reward = 2033, type = 3702}
, 
[161] = {id = 161, item_reward = 2038, type = 3702}
, 
[162] = {id = 162, item_reward = 2040, type = 3702}
}
, 
[3703] = {
[138] = {id = 138, item_reward = 2004, type = 3703}
, 
[140] = {id = 140, item_reward = 2007, type = 3703}
, 
[141] = {id = 141, type = 3703}
, 
[143] = {id = 143, item_reward = 2012, type = 3703}
, 
[145] = {id = 145, item_reward = 2014, type = 3703}
, 
[149] = {id = 149, item_reward = 2020, type = 3703}
, 
[150] = {id = 150, item_reward = 2021, type = 3703}
, 
[151] = {id = 151, item_reward = 2023, type = 3703}
, 
[153] = {id = 153, item_reward = 2027, type = 3703}
, 
[158] = {id = 158, item_reward = 2034, type = 3703}
, 
[159] = {id = 159, item_reward = 2035, type = 3703}
, 
[160] = {id = 160, item_reward = 2036, type = 3703}
}
, 
[3801] = {
[258] = {id = 258, item_reward = 2049, type = 3801}
, 
[259] = {id = 259, item_reward = 2044, type = 3801}
, 
[260] = {id = 260, item_reward = 2048, type = 3801}
, 
[261] = {id = 261, item_reward = 2046, type = 3801}
, 
[262] = {id = 262, item_reward = 2016, type = 3801}
, 
[263] = {id = 263, item_reward = 2045, type = 3801}
, 
[264] = {id = 264, item_reward = 2008, type = 3801}
, 
[265] = {id = 265, item_reward = 2026, type = 3801}
, 
[266] = {id = 266, item_reward = 2039, type = 3801}
, 
[267] = {id = 267, item_reward = 2022, type = 3801}
, 
[268] = {id = 268, item_reward = 2018, type = 3801}
, 
[269] = {id = 269, item_reward = 2043, type = 3801}
, 
[270] = {id = 270, item_reward = 2037, type = 3801}
, 
[271] = {id = 271, item_reward = 2051, type = 3801}
}
, 
[3802] = {
[232] = {id = 232, item_reward = 2002, type = 3802}
, 
[234] = {id = 234, item_reward = 2006, type = 3802}
, 
[237] = {id = 237, item_reward = 2011, type = 3802}
, 
[239] = {id = 239, item_reward = 2013, type = 3802}
, 
[241] = {id = 241, item_reward = 2015, type = 3802}
, 
[242] = {id = 242, item_reward = 2017, type = 3802}
, 
[243] = {id = 243, item_reward = 2019, type = 3802}
, 
[247] = {id = 247, item_reward = 2024, type = 3802}
, 
[249] = {id = 249, item_reward = 2030, type = 3802}
, 
[250] = {id = 250, item_reward = 2031, type = 3802}
, 
[251] = {id = 251, item_reward = 2032, type = 3802}
, 
[252] = {id = 252, item_reward = 2033, type = 3802}
, 
[256] = {id = 256, item_reward = 2038, type = 3802}
, 
[257] = {id = 257, item_reward = 2040, type = 3802}
}
, 
[3803] = {
[233] = {id = 233, item_reward = 2004, type = 3803}
, 
[235] = {id = 235, item_reward = 2007, type = 3803}
, 
[236] = {id = 236, type = 3803}
, 
[238] = {id = 238, item_reward = 2012, type = 3803}
, 
[240] = {id = 240, item_reward = 2014, type = 3803}
, 
[244] = {id = 244, item_reward = 2020, type = 3803}
, 
[245] = {id = 245, item_reward = 2021, type = 3803}
, 
[246] = {id = 246, item_reward = 2023, type = 3803}
, 
[248] = {id = 248, item_reward = 2027, type = 3803}
, 
[253] = {id = 253, item_reward = 2034, type = 3803}
, 
[254] = {id = 254, item_reward = 2035, type = 3803}
, 
[255] = {id = 255, item_reward = 2036, type = 3803}
}
, 
[3901] = {
[707] = {id = 707, item_reward = 2051, type = 3901}
, 
[708] = {id = 708, item_reward = 2049, type = 3901}
, 
[709] = {id = 709, item_reward = 2025, type = 3901}
, 
[710] = {id = 710, item_reward = 2018, type = 3901}
, 
[711] = {id = 711, item_reward = 2048, type = 3901}
, 
[712] = {id = 712, item_reward = 2044, type = 3901}
, 
[713] = {id = 713, item_reward = 2028, type = 3901}
, 
[714] = {id = 714, item_reward = 2016, type = 3901}
}
, 
[3902] = {
[681] = {id = 681, item_reward = 2002, type = 3902}
, 
[683] = {id = 683, item_reward = 2006, type = 3902}
, 
[686] = {id = 686, item_reward = 2011, type = 3902}
, 
[688] = {id = 688, item_reward = 2013, type = 3902}
, 
[690] = {id = 690, item_reward = 2015, type = 3902}
, 
[691] = {id = 691, item_reward = 2017, type = 3902}
, 
[692] = {id = 692, item_reward = 2019, type = 3902}
, 
[696] = {id = 696, item_reward = 2024, type = 3902}
, 
[698] = {id = 698, item_reward = 2030, type = 3902}
, 
[699] = {id = 699, item_reward = 2031, type = 3902}
, 
[700] = {id = 700, item_reward = 2032, type = 3902}
, 
[701] = {id = 701, item_reward = 2033, type = 3902}
, 
[705] = {id = 705, item_reward = 2038, type = 3902}
, 
[706] = {id = 706, item_reward = 2040, type = 3902}
}
, 
[3903] = {
[682] = {id = 682, item_reward = 2004, type = 3903}
, 
[684] = {id = 684, item_reward = 2007, type = 3903}
, 
[685] = {id = 685, type = 3903}
, 
[687] = {id = 687, item_reward = 2012, type = 3903}
, 
[689] = {id = 689, item_reward = 2014, type = 3903}
, 
[693] = {id = 693, item_reward = 2020, type = 3903}
, 
[694] = {id = 694, item_reward = 2021, type = 3903}
, 
[695] = {id = 695, item_reward = 2023, type = 3903}
, 
[697] = {id = 697, item_reward = 2027, type = 3903}
, 
[702] = {id = 702, item_reward = 2034, type = 3903}
, 
[703] = {id = 703, item_reward = 2035, type = 3903}
, 
[704] = {id = 704, item_reward = 2036, type = 3903}
}
, 
[4001] = {
[741] = {id = 741, item_reward = 2044, type = 4001}
, 
[742] = {id = 742, item_reward = 2010, type = 4001}
, 
[743] = {id = 743, item_reward = 2042, type = 4001}
, 
[744] = {id = 744, item_reward = 2041, type = 4001}
, 
[745] = {id = 745, item_reward = 2039, type = 4001}
, 
[746] = {id = 746, item_reward = 2046, type = 4001}
, 
[747] = {id = 747, item_reward = 2028, type = 4001}
, 
[748] = {id = 748, item_reward = 2026, type = 4001}
}
, 
[4002] = {
[715] = {id = 715, item_reward = 2002, type = 4002}
, 
[717] = {id = 717, item_reward = 2006, type = 4002}
, 
[720] = {id = 720, item_reward = 2011, type = 4002}
, 
[722] = {id = 722, item_reward = 2013, type = 4002}
, 
[724] = {id = 724, item_reward = 2015, type = 4002}
, 
[725] = {id = 725, item_reward = 2017, type = 4002}
, 
[726] = {id = 726, item_reward = 2019, type = 4002}
, 
[730] = {id = 730, item_reward = 2024, type = 4002}
, 
[732] = {id = 732, item_reward = 2030, type = 4002}
, 
[733] = {id = 733, item_reward = 2031, type = 4002}
, 
[734] = {id = 734, item_reward = 2032, type = 4002}
, 
[735] = {id = 735, item_reward = 2033, type = 4002}
, 
[739] = {id = 739, item_reward = 2038, type = 4002}
, 
[740] = {id = 740, item_reward = 2040, type = 4002}
}
, 
[4003] = {
[716] = {id = 716, item_reward = 2004, type = 4003}
, 
[718] = {id = 718, item_reward = 2007, type = 4003}
, 
[719] = {id = 719, type = 4003}
, 
[721] = {id = 721, item_reward = 2012, type = 4003}
, 
[723] = {id = 723, item_reward = 2014, type = 4003}
, 
[727] = {id = 727, item_reward = 2020, type = 4003}
, 
[728] = {id = 728, item_reward = 2021, type = 4003}
, 
[729] = {id = 729, item_reward = 2023, type = 4003}
, 
[731] = {id = 731, item_reward = 2027, type = 4003}
, 
[736] = {id = 736, item_reward = 2034, type = 4003}
, 
[737] = {id = 737, item_reward = 2035, type = 4003}
, 
[738] = {id = 738, item_reward = 2036, type = 4003}
}
, 
[4101] = {
[298] = {id = 298, item_reward = 2050, type = 4101}
, 
[299] = {id = 299, item_reward = 2052, type = 4101}
, 
[300] = {id = 300, item_reward = 2043, type = 4101}
, 
[301] = {id = 301, item_reward = 2025, type = 4101}
, 
[302] = {id = 302, item_reward = 2037, type = 4101}
, 
[303] = {id = 303, item_reward = 2046, type = 4101}
, 
[304] = {id = 304, item_reward = 2042, type = 4101}
, 
[305] = {id = 305, item_reward = 2022, type = 4101}
, 
[306] = {id = 306, item_reward = 2016, type = 4101}
, 
[307] = {id = 307, item_reward = 2049, type = 4101}
, 
[308] = {id = 308, item_reward = 2045, type = 4101}
, 
[309] = {id = 309, item_reward = 2018, type = 4101}
, 
[310] = {id = 310, item_reward = 2041, type = 4101}
, 
[311] = {id = 311, item_reward = 2008, type = 4101}
}
, 
[4102] = {
[272] = {id = 272, item_reward = 2002, type = 4102}
, 
[274] = {id = 274, item_reward = 2006, type = 4102}
, 
[277] = {id = 277, item_reward = 2011, type = 4102}
, 
[279] = {id = 279, item_reward = 2013, type = 4102}
, 
[281] = {id = 281, item_reward = 2015, type = 4102}
, 
[282] = {id = 282, item_reward = 2017, type = 4102}
, 
[283] = {id = 283, item_reward = 2019, type = 4102}
, 
[287] = {id = 287, item_reward = 2024, type = 4102}
, 
[289] = {id = 289, item_reward = 2030, type = 4102}
, 
[290] = {id = 290, item_reward = 2031, type = 4102}
, 
[291] = {id = 291, item_reward = 2032, type = 4102}
, 
[292] = {id = 292, item_reward = 2033, type = 4102}
, 
[296] = {id = 296, item_reward = 2038, type = 4102}
, 
[297] = {id = 297, item_reward = 2040, type = 4102}
}
, 
[4103] = {
[273] = {id = 273, item_reward = 2004, type = 4103}
, 
[275] = {id = 275, item_reward = 2007, type = 4103}
, 
[276] = {id = 276, type = 4103}
, 
[278] = {id = 278, item_reward = 2012, type = 4103}
, 
[280] = {id = 280, item_reward = 2014, type = 4103}
, 
[284] = {id = 284, item_reward = 2020, type = 4103}
, 
[285] = {id = 285, item_reward = 2021, type = 4103}
, 
[286] = {id = 286, item_reward = 2023, type = 4103}
, 
[288] = {id = 288, item_reward = 2027, type = 4103}
, 
[293] = {id = 293, item_reward = 2034, type = 4103}
, 
[294] = {id = 294, item_reward = 2035, type = 4103}
, 
[295] = {id = 295, item_reward = 2036, type = 4103}
}
, 
[4201] = {
[775] = {id = 775, item_reward = 2050, type = 4201}
, 
[776] = {id = 776, item_reward = 2052, type = 4201}
, 
[777] = {id = 777, item_reward = 2010, type = 4201}
, 
[778] = {id = 778, item_reward = 2037, type = 4201}
, 
[779] = {id = 779, item_reward = 2049, type = 4201}
, 
[780] = {id = 780, item_reward = 2046, type = 4201}
, 
[781] = {id = 781, item_reward = 2048, type = 4201}
, 
[782] = {id = 782, item_reward = 2041, type = 4201}
}
, 
[4202] = {
[749] = {id = 749, item_reward = 2002, type = 4202}
, 
[751] = {id = 751, item_reward = 2006, type = 4202}
, 
[754] = {id = 754, item_reward = 2011, type = 4202}
, 
[756] = {id = 756, item_reward = 2013, type = 4202}
, 
[758] = {id = 758, item_reward = 2015, type = 4202}
, 
[759] = {id = 759, item_reward = 2017, type = 4202}
, 
[760] = {id = 760, item_reward = 2019, type = 4202}
, 
[764] = {id = 764, item_reward = 2024, type = 4202}
, 
[766] = {id = 766, item_reward = 2030, type = 4202}
, 
[767] = {id = 767, item_reward = 2031, type = 4202}
, 
[768] = {id = 768, item_reward = 2032, type = 4202}
, 
[769] = {id = 769, item_reward = 2033, type = 4202}
, 
[773] = {id = 773, item_reward = 2038, type = 4202}
, 
[774] = {id = 774, item_reward = 2040, type = 4202}
}
, 
[4203] = {
[750] = {id = 750, item_reward = 2004, type = 4203}
, 
[752] = {id = 752, item_reward = 2007, type = 4203}
, 
[753] = {id = 753, type = 4203}
, 
[755] = {id = 755, item_reward = 2012, type = 4203}
, 
[757] = {id = 757, item_reward = 2014, type = 4203}
, 
[761] = {id = 761, item_reward = 2020, type = 4203}
, 
[762] = {id = 762, item_reward = 2021, type = 4203}
, 
[763] = {id = 763, item_reward = 2023, type = 4203}
, 
[765] = {id = 765, item_reward = 2027, type = 4203}
, 
[770] = {id = 770, item_reward = 2034, type = 4203}
, 
[771] = {id = 771, item_reward = 2035, type = 4203}
, 
[772] = {id = 772, item_reward = 2036, type = 4203}
}
, 
[4301] = {
[809] = {id = 809, item_reward = 2010, type = 4301}
, 
[810] = {id = 810, item_reward = 2025, type = 4301}
, 
[811] = {id = 811, item_reward = 2044, type = 4301}
, 
[812] = {id = 812, item_reward = 2042, type = 4301}
, 
[813] = {id = 813, item_reward = 2039, type = 4301}
, 
[814] = {id = 814, item_reward = 2016, type = 4301}
, 
[815] = {id = 815, item_reward = 2018, type = 4301}
, 
[816] = {id = 816, item_reward = 2026, type = 4301}
}
, 
[4302] = {
[783] = {id = 783, item_reward = 2002, type = 4302}
, 
[785] = {id = 785, item_reward = 2006, type = 4302}
, 
[788] = {id = 788, item_reward = 2011, type = 4302}
, 
[790] = {id = 790, item_reward = 2013, type = 4302}
, 
[792] = {id = 792, item_reward = 2015, type = 4302}
, 
[793] = {id = 793, item_reward = 2017, type = 4302}
, 
[794] = {id = 794, item_reward = 2019, type = 4302}
, 
[798] = {id = 798, item_reward = 2024, type = 4302}
, 
[800] = {id = 800, item_reward = 2030, type = 4302}
, 
[801] = {id = 801, item_reward = 2031, type = 4302}
, 
[802] = {id = 802, item_reward = 2032, type = 4302}
, 
[803] = {id = 803, item_reward = 2033, type = 4302}
, 
[807] = {id = 807, item_reward = 2038, type = 4302}
, 
[808] = {id = 808, item_reward = 2040, type = 4302}
}
, 
[4303] = {
[784] = {id = 784, item_reward = 2004, type = 4303}
, 
[786] = {id = 786, item_reward = 2007, type = 4303}
, 
[787] = {id = 787, type = 4303}
, 
[789] = {id = 789, item_reward = 2012, type = 4303}
, 
[791] = {id = 791, item_reward = 2014, type = 4303}
, 
[795] = {id = 795, item_reward = 2020, type = 4303}
, 
[796] = {id = 796, item_reward = 2021, type = 4303}
, 
[797] = {id = 797, item_reward = 2023, type = 4303}
, 
[799] = {id = 799, item_reward = 2027, type = 4303}
, 
[804] = {id = 804, item_reward = 2034, type = 4303}
, 
[805] = {id = 805, item_reward = 2035, type = 4303}
, 
[806] = {id = 806, item_reward = 2036, type = 4303}
}
, 
[4401] = {
[843] = {id = 843, item_reward = 2025, type = 4401}
, 
[844] = {id = 844, item_reward = 2044, type = 4401}
, 
[845] = {id = 845, item_reward = 2028, type = 4401}
, 
[846] = {id = 846, item_reward = 2042, type = 4401}
, 
[847] = {id = 847, item_reward = 2049, type = 4401}
, 
[848] = {id = 848, item_reward = 2046, type = 4401}
, 
[849] = {id = 849, item_reward = 2041, type = 4401}
, 
[850] = {id = 850, item_reward = 2026, type = 4401}
}
, 
[4402] = {
[817] = {id = 817, item_reward = 2002, type = 4402}
, 
[819] = {id = 819, item_reward = 2006, type = 4402}
, 
[822] = {id = 822, item_reward = 2011, type = 4402}
, 
[824] = {id = 824, item_reward = 2013, type = 4402}
, 
[826] = {id = 826, item_reward = 2015, type = 4402}
, 
[827] = {id = 827, item_reward = 2017, type = 4402}
, 
[828] = {id = 828, item_reward = 2019, type = 4402}
, 
[832] = {id = 832, item_reward = 2024, type = 4402}
, 
[834] = {id = 834, item_reward = 2030, type = 4402}
, 
[835] = {id = 835, item_reward = 2031, type = 4402}
, 
[836] = {id = 836, item_reward = 2032, type = 4402}
, 
[837] = {id = 837, item_reward = 2033, type = 4402}
, 
[841] = {id = 841, item_reward = 2038, type = 4402}
, 
[842] = {id = 842, item_reward = 2040, type = 4402}
}
, 
[4403] = {
[818] = {id = 818, item_reward = 2004, type = 4403}
, 
[820] = {id = 820, item_reward = 2007, type = 4403}
, 
[821] = {id = 821, type = 4403}
, 
[823] = {id = 823, item_reward = 2012, type = 4403}
, 
[825] = {id = 825, item_reward = 2014, type = 4403}
, 
[829] = {id = 829, item_reward = 2020, type = 4403}
, 
[830] = {id = 830, item_reward = 2021, type = 4403}
, 
[831] = {id = 831, item_reward = 2023, type = 4403}
, 
[833] = {id = 833, item_reward = 2027, type = 4403}
, 
[838] = {id = 838, item_reward = 2034, type = 4403}
, 
[839] = {id = 839, item_reward = 2035, type = 4403}
, 
[840] = {id = 840, item_reward = 2036, type = 4403}
}
, 
[4501] = {
[338] = {id = 338, item_reward = 2053, type = 4501}
, 
[339] = {id = 339, item_reward = 2043, type = 4501}
, 
[340] = {id = 340, item_reward = 2037, type = 4501}
, 
[341] = {id = 341, item_reward = 2044, type = 4501}
, 
[342] = {id = 342, item_reward = 2042, type = 4501}
, 
[343] = {id = 343, item_reward = 2022, type = 4501}
, 
[344] = {id = 344, item_reward = 2039, type = 4501}
, 
[345] = {id = 345, item_reward = 2049, type = 4501}
, 
[346] = {id = 346, item_reward = 2016, type = 4501}
, 
[347] = {id = 347, item_reward = 2046, type = 4501}
, 
[348] = {id = 348, item_reward = 2045, type = 4501}
, 
[349] = {id = 349, item_reward = 2018, type = 4501}
, 
[350] = {id = 350, item_reward = 2026, type = 4501}
, 
[351] = {id = 351, item_reward = 2052, type = 4501}
}
, 
[4502] = {
[312] = {id = 312, item_reward = 2002, type = 4502}
, 
[314] = {id = 314, item_reward = 2006, type = 4502}
, 
[317] = {id = 317, item_reward = 2011, type = 4502}
, 
[319] = {id = 319, item_reward = 2013, type = 4502}
, 
[321] = {id = 321, item_reward = 2015, type = 4502}
, 
[322] = {id = 322, item_reward = 2017, type = 4502}
, 
[323] = {id = 323, item_reward = 2019, type = 4502}
, 
[327] = {id = 327, item_reward = 2024, type = 4502}
, 
[329] = {id = 329, item_reward = 2030, type = 4502}
, 
[330] = {id = 330, item_reward = 2031, type = 4502}
, 
[331] = {id = 331, item_reward = 2032, type = 4502}
, 
[332] = {id = 332, item_reward = 2033, type = 4502}
, 
[336] = {id = 336, item_reward = 2038, type = 4502}
, 
[337] = {id = 337, item_reward = 2040, type = 4502}
}
, 
[4503] = {
[313] = {id = 313, item_reward = 2004, type = 4503}
, 
[315] = {id = 315, item_reward = 2007, type = 4503}
, 
[316] = {id = 316, type = 4503}
, 
[318] = {id = 318, item_reward = 2012, type = 4503}
, 
[320] = {id = 320, item_reward = 2014, type = 4503}
, 
[324] = {id = 324, item_reward = 2020, type = 4503}
, 
[325] = {id = 325, item_reward = 2021, type = 4503}
, 
[326] = {id = 326, item_reward = 2023, type = 4503}
, 
[328] = {id = 328, item_reward = 2027, type = 4503}
, 
[333] = {id = 333, item_reward = 2034, type = 4503}
, 
[334] = {id = 334, item_reward = 2035, type = 4503}
, 
[335] = {id = 335, item_reward = 2036, type = 4503}
}
, 
[4601] = {
[877] = {id = 877, item_reward = 2053, type = 4601}
, 
[878] = {id = 878, item_reward = 2010, type = 4601}
, 
[879] = {id = 879, item_reward = 2028, type = 4601}
, 
[880] = {id = 880, item_reward = 2049, type = 4601}
, 
[881] = {id = 881, item_reward = 2016, type = 4601}
, 
[882] = {id = 882, item_reward = 2046, type = 4601}
, 
[883] = {id = 883, item_reward = 2041, type = 4601}
, 
[884] = {id = 884, item_reward = 2052, type = 4601}
}
, 
[4602] = {
[851] = {id = 851, item_reward = 2002, type = 4602}
, 
[853] = {id = 853, item_reward = 2006, type = 4602}
, 
[856] = {id = 856, item_reward = 2011, type = 4602}
, 
[858] = {id = 858, item_reward = 2013, type = 4602}
, 
[860] = {id = 860, item_reward = 2015, type = 4602}
, 
[861] = {id = 861, item_reward = 2017, type = 4602}
, 
[862] = {id = 862, item_reward = 2019, type = 4602}
, 
[866] = {id = 866, item_reward = 2024, type = 4602}
, 
[868] = {id = 868, item_reward = 2030, type = 4602}
, 
[869] = {id = 869, item_reward = 2031, type = 4602}
, 
[870] = {id = 870, item_reward = 2032, type = 4602}
, 
[871] = {id = 871, item_reward = 2033, type = 4602}
, 
[875] = {id = 875, item_reward = 2038, type = 4602}
, 
[876] = {id = 876, item_reward = 2040, type = 4602}
}
, 
[4603] = {
[852] = {id = 852, item_reward = 2004, type = 4603}
, 
[854] = {id = 854, item_reward = 2007, type = 4603}
, 
[855] = {id = 855, type = 4603}
, 
[857] = {id = 857, item_reward = 2012, type = 4603}
, 
[859] = {id = 859, item_reward = 2014, type = 4603}
, 
[863] = {id = 863, item_reward = 2020, type = 4603}
, 
[864] = {id = 864, item_reward = 2021, type = 4603}
, 
[865] = {id = 865, item_reward = 2023, type = 4603}
, 
[867] = {id = 867, item_reward = 2027, type = 4603}
, 
[872] = {id = 872, item_reward = 2034, type = 4603}
, 
[873] = {id = 873, item_reward = 2035, type = 4603}
, 
[874] = {id = 874, item_reward = 2036, type = 4603}
}
, 
[4701] = {
[911] = {id = 911, item_reward = 2048, type = 4701}
, 
[912] = {id = 912, item_reward = 2010, type = 4701}
, 
[913] = {id = 913, item_reward = 2039, type = 4701}
, 
[914] = {id = 914, item_reward = 2037, type = 4701}
, 
[915] = {id = 915, item_reward = 2016, type = 4701}
, 
[916] = {id = 916, item_reward = 2018, type = 4701}
, 
[917] = {id = 917, item_reward = 2042, type = 4701}
, 
[918] = {id = 918, item_reward = 2026, type = 4701}
}
, 
[4702] = {
[885] = {id = 885, item_reward = 2002, type = 4702}
, 
[887] = {id = 887, item_reward = 2006, type = 4702}
, 
[890] = {id = 890, item_reward = 2011, type = 4702}
, 
[892] = {id = 892, item_reward = 2013, type = 4702}
, 
[894] = {id = 894, item_reward = 2015, type = 4702}
, 
[895] = {id = 895, item_reward = 2017, type = 4702}
, 
[896] = {id = 896, item_reward = 2019, type = 4702}
, 
[900] = {id = 900, item_reward = 2024, type = 4702}
, 
[902] = {id = 902, item_reward = 2030, type = 4702}
, 
[903] = {id = 903, item_reward = 2031, type = 4702}
, 
[904] = {id = 904, item_reward = 2032, type = 4702}
, 
[905] = {id = 905, item_reward = 2033, type = 4702}
, 
[909] = {id = 909, item_reward = 2038, type = 4702}
, 
[910] = {id = 910, item_reward = 2040, type = 4702}
}
, 
[4703] = {
[886] = {id = 886, item_reward = 2004, type = 4703}
, 
[888] = {id = 888, item_reward = 2007, type = 4703}
, 
[889] = {id = 889, type = 4703}
, 
[891] = {id = 891, item_reward = 2012, type = 4703}
, 
[893] = {id = 893, item_reward = 2014, type = 4703}
, 
[897] = {id = 897, item_reward = 2020, type = 4703}
, 
[898] = {id = 898, item_reward = 2021, type = 4703}
, 
[899] = {id = 899, item_reward = 2023, type = 4703}
, 
[901] = {id = 901, item_reward = 2027, type = 4703}
, 
[906] = {id = 906, item_reward = 2034, type = 4703}
, 
[907] = {id = 907, item_reward = 2035, type = 4703}
, 
[908] = {id = 908, item_reward = 2036, type = 4703}
}
, 
[4801] = {
[945] = {id = 945, item_reward = 2016, type = 4801}
, 
[946] = {id = 946, item_reward = 2037, type = 4801}
, 
[947] = {id = 947, item_reward = 2042, type = 4801}
, 
[948] = {id = 948, item_reward = 2039, type = 4801}
, 
[949] = {id = 949, item_reward = 2049, type = 4801}
, 
[950] = {id = 950, item_reward = 2048, type = 4801}
, 
[951] = {id = 951, item_reward = 2041, type = 4801}
, 
[952] = {id = 952, item_reward = 2052, type = 4801}
}
, 
[4802] = {
[919] = {id = 919, item_reward = 2002, type = 4802}
, 
[921] = {id = 921, item_reward = 2006, type = 4802}
, 
[924] = {id = 924, item_reward = 2011, type = 4802}
, 
[926] = {id = 926, item_reward = 2013, type = 4802}
, 
[928] = {id = 928, item_reward = 2015, type = 4802}
, 
[929] = {id = 929, item_reward = 2017, type = 4802}
, 
[930] = {id = 930, item_reward = 2019, type = 4802}
, 
[934] = {id = 934, item_reward = 2024, type = 4802}
, 
[936] = {id = 936, item_reward = 2030, type = 4802}
, 
[937] = {id = 937, item_reward = 2031, type = 4802}
, 
[938] = {id = 938, item_reward = 2032, type = 4802}
, 
[939] = {id = 939, item_reward = 2033, type = 4802}
, 
[943] = {id = 943, item_reward = 2038, type = 4802}
, 
[944] = {id = 944, item_reward = 2040, type = 4802}
}
, 
[4803] = {
[920] = {id = 920, item_reward = 2004, type = 4803}
, 
[922] = {id = 922, item_reward = 2007, type = 4803}
, 
[923] = {id = 923, type = 4803}
, 
[925] = {id = 925, item_reward = 2012, type = 4803}
, 
[927] = {id = 927, item_reward = 2014, type = 4803}
, 
[931] = {id = 931, item_reward = 2020, type = 4803}
, 
[932] = {id = 932, item_reward = 2021, type = 4803}
, 
[933] = {id = 933, item_reward = 2023, type = 4803}
, 
[935] = {id = 935, item_reward = 2027, type = 4803}
, 
[940] = {id = 940, item_reward = 2034, type = 4803}
, 
[941] = {id = 941, item_reward = 2035, type = 4803}
, 
[942] = {id = 942, item_reward = 2036, type = 4803}
}
, 
[4901] = {
[378] = {id = 378, item_reward = 2054, type = 4901}
, 
[379] = {id = 379, item_reward = 2051, type = 4901}
, 
[380] = {id = 380, item_reward = 2043, type = 4901}
, 
[381] = {id = 381, item_reward = 2025, type = 4901}
, 
[382] = {id = 382, item_reward = 2044, type = 4901}
, 
[383] = {id = 383, item_reward = 2022, type = 4901}
, 
[384] = {id = 384, item_reward = 2028, type = 4901}
, 
[385] = {id = 385, item_reward = 2049, type = 4901}
, 
[386] = {id = 386, item_reward = 2046, type = 4901}
, 
[387] = {id = 387, item_reward = 2048, type = 4901}
, 
[388] = {id = 388, item_reward = 2045, type = 4901}
, 
[389] = {id = 389, item_reward = 2041, type = 4901}
, 
[390] = {id = 390, item_reward = 2008, type = 4901}
, 
[391] = {id = 391, item_reward = 2052, type = 4901}
}
, 
[4902] = {
[352] = {id = 352, item_reward = 2002, type = 4902}
, 
[354] = {id = 354, item_reward = 2006, type = 4902}
, 
[357] = {id = 357, item_reward = 2011, type = 4902}
, 
[359] = {id = 359, item_reward = 2013, type = 4902}
, 
[361] = {id = 361, item_reward = 2015, type = 4902}
, 
[362] = {id = 362, item_reward = 2017, type = 4902}
, 
[363] = {id = 363, item_reward = 2019, type = 4902}
, 
[367] = {id = 367, item_reward = 2024, type = 4902}
, 
[369] = {id = 369, item_reward = 2030, type = 4902}
, 
[370] = {id = 370, item_reward = 2031, type = 4902}
, 
[371] = {id = 371, item_reward = 2032, type = 4902}
, 
[372] = {id = 372, item_reward = 2033, type = 4902}
, 
[376] = {id = 376, item_reward = 2038, type = 4902}
, 
[377] = {id = 377, item_reward = 2040, type = 4902}
}
, 
[4903] = {
[353] = {id = 353, item_reward = 2004, type = 4903}
, 
[355] = {id = 355, item_reward = 2007, type = 4903}
, 
[356] = {id = 356, type = 4903}
, 
[358] = {id = 358, item_reward = 2012, type = 4903}
, 
[360] = {id = 360, item_reward = 2014, type = 4903}
, 
[364] = {id = 364, item_reward = 2020, type = 4903}
, 
[365] = {id = 365, item_reward = 2021, type = 4903}
, 
[366] = {id = 366, item_reward = 2023, type = 4903}
, 
[368] = {id = 368, item_reward = 2027, type = 4903}
, 
[373] = {id = 373, item_reward = 2034, type = 4903}
, 
[374] = {id = 374, item_reward = 2035, type = 4903}
, 
[375] = {id = 375, item_reward = 2036, type = 4903}
}
, 
[5001] = {
[979] = {id = 979, item_reward = 2054, type = 5001}
, 
[980] = {id = 980, item_reward = 2051, type = 5001}
, 
[981] = {id = 981, item_reward = 2010, type = 5001}
, 
[982] = {id = 982, item_reward = 2044, type = 5001}
, 
[983] = {id = 983, item_reward = 2028, type = 5001}
, 
[984] = {id = 984, item_reward = 2046, type = 5001}
, 
[985] = {id = 985, item_reward = 2018, type = 5001}
, 
[986] = {id = 986, item_reward = 2026, type = 5001}
}
, 
[5002] = {
[953] = {id = 953, item_reward = 2002, type = 5002}
, 
[955] = {id = 955, item_reward = 2006, type = 5002}
, 
[958] = {id = 958, item_reward = 2011, type = 5002}
, 
[960] = {id = 960, item_reward = 2013, type = 5002}
, 
[962] = {id = 962, item_reward = 2015, type = 5002}
, 
[963] = {id = 963, item_reward = 2017, type = 5002}
, 
[964] = {id = 964, item_reward = 2019, type = 5002}
, 
[968] = {id = 968, item_reward = 2024, type = 5002}
, 
[970] = {id = 970, item_reward = 2030, type = 5002}
, 
[971] = {id = 971, item_reward = 2031, type = 5002}
, 
[972] = {id = 972, item_reward = 2032, type = 5002}
, 
[973] = {id = 973, item_reward = 2033, type = 5002}
, 
[977] = {id = 977, item_reward = 2038, type = 5002}
, 
[978] = {id = 978, item_reward = 2040, type = 5002}
}
, 
[5003] = {
[954] = {id = 954, item_reward = 2004, type = 5003}
, 
[956] = {id = 956, item_reward = 2007, type = 5003}
, 
[957] = {id = 957, type = 5003}
, 
[959] = {id = 959, item_reward = 2012, type = 5003}
, 
[961] = {id = 961, item_reward = 2014, type = 5003}
, 
[965] = {id = 965, item_reward = 2020, type = 5003}
, 
[966] = {id = 966, item_reward = 2021, type = 5003}
, 
[967] = {id = 967, item_reward = 2023, type = 5003}
, 
[969] = {id = 969, item_reward = 2027, type = 5003}
, 
[974] = {id = 974, item_reward = 2034, type = 5003}
, 
[975] = {id = 975, item_reward = 2035, type = 5003}
, 
[976] = {id = 976, item_reward = 2036, type = 5003}
}
, 
[5101] = {
[197] = {id = 197, item_reward = 2022, type = 5101}
, 
[198] = {id = 198, item_reward = 2008, type = 5101}
, 
[199] = {id = 199, item_reward = 2010, type = 5101}
, 
[200] = {id = 200, item_reward = 2043, type = 5101}
, 
[201] = {id = 201, item_reward = 2025, type = 5101}
, 
[202] = {id = 202, item_reward = 2044, type = 5101}
, 
[203] = {id = 203, item_reward = 2045, type = 5101}
, 
[204] = {id = 204, item_reward = 2018, type = 5101}
}
, 
[5102] = {
[171] = {id = 171, item_reward = 2002, type = 5102}
, 
[173] = {id = 173, item_reward = 2006, type = 5102}
, 
[176] = {id = 176, item_reward = 2011, type = 5102}
, 
[178] = {id = 178, item_reward = 2013, type = 5102}
, 
[180] = {id = 180, item_reward = 2015, type = 5102}
, 
[181] = {id = 181, item_reward = 2017, type = 5102}
, 
[182] = {id = 182, item_reward = 2019, type = 5102}
, 
[186] = {id = 186, item_reward = 2024, type = 5102}
, 
[188] = {id = 188, item_reward = 2030, type = 5102}
, 
[189] = {id = 189, item_reward = 2031, type = 5102}
, 
[190] = {id = 190, item_reward = 2032, type = 5102}
, 
[191] = {id = 191, item_reward = 2033, type = 5102}
, 
[195] = {id = 195, item_reward = 2038, type = 5102}
, 
[196] = {id = 196, item_reward = 2040, type = 5102}
}
, 
[5103] = {
[172] = {id = 172, item_reward = 2004, type = 5103}
, 
[174] = {id = 174, item_reward = 2007, type = 5103}
, 
[175] = {id = 175, type = 5103}
, 
[177] = {id = 177, item_reward = 2012, type = 5103}
, 
[179] = {id = 179, item_reward = 2014, type = 5103}
, 
[183] = {id = 183, item_reward = 2020, type = 5103}
, 
[184] = {id = 184, item_reward = 2021, type = 5103}
, 
[185] = {id = 185, item_reward = 2023, type = 5103}
, 
[187] = {id = 187, item_reward = 2027, type = 5103}
, 
[192] = {id = 192, item_reward = 2034, type = 5103}
, 
[193] = {id = 193, item_reward = 2035, type = 5103}
, 
[194] = {id = 194, item_reward = 2036, type = 5103}
}
, 
[5201] = {
[1013] = {id = 1013, item_reward = 2055, type = 5201}
, 
[1014] = {id = 1014, item_reward = 2051, type = 5201}
, 
[1015] = {id = 1015, item_reward = 2041, type = 5201}
, 
[1016] = {id = 1016, item_reward = 2044, type = 5201}
, 
[1017] = {id = 1017, item_reward = 2025, type = 5201}
, 
[1018] = {id = 1018, item_reward = 2049, type = 5201}
, 
[1019] = {id = 1019, item_reward = 2048, type = 5201}
, 
[1020] = {id = 1020, item_reward = 2026, type = 5201}
}
, 
[5202] = {
[987] = {id = 987, item_reward = 2002, type = 5202}
, 
[989] = {id = 989, item_reward = 2006, type = 5202}
, 
[992] = {id = 992, item_reward = 2011, type = 5202}
, 
[994] = {id = 994, item_reward = 2013, type = 5202}
, 
[996] = {id = 996, item_reward = 2015, type = 5202}
, 
[997] = {id = 997, item_reward = 2017, type = 5202}
, 
[998] = {id = 998, item_reward = 2019, type = 5202}
, 
[1002] = {id = 1002, item_reward = 2024, type = 5202}
, 
[1004] = {id = 1004, item_reward = 2030, type = 5202}
, 
[1005] = {id = 1005, item_reward = 2031, type = 5202}
, 
[1006] = {id = 1006, item_reward = 2032, type = 5202}
, 
[1007] = {id = 1007, item_reward = 2033, type = 5202}
, 
[1011] = {id = 1011, item_reward = 2038, type = 5202}
, 
[1012] = {id = 1012, item_reward = 2040, type = 5202}
}
, 
[5203] = {
[988] = {id = 988, item_reward = 2004, type = 5203}
, 
[990] = {id = 990, item_reward = 2007, type = 5203}
, 
[991] = {id = 991, type = 5203}
, 
[993] = {id = 993, item_reward = 2012, type = 5203}
, 
[995] = {id = 995, item_reward = 2014, type = 5203}
, 
[999] = {id = 999, item_reward = 2020, type = 5203}
, 
[1000] = {id = 1000, item_reward = 2021, type = 5203}
, 
[1001] = {id = 1001, item_reward = 2023, type = 5203}
, 
[1003] = {id = 1003, item_reward = 2027, type = 5203}
, 
[1008] = {id = 1008, item_reward = 2034, type = 5203}
, 
[1009] = {id = 1009, item_reward = 2035, type = 5203}
, 
[1010] = {id = 1010, item_reward = 2036, type = 5203}
}
, 
[5301] = {
[1047] = {id = 1047, item_reward = 2055, type = 5301}
, 
[1048] = {id = 1048, item_reward = 2051, type = 5301}
, 
[1049] = {id = 1049, item_reward = 2041, type = 5301}
, 
[1050] = {id = 1050, item_reward = 2044, type = 5301}
, 
[1051] = {id = 1051, item_reward = 2025, type = 5301}
, 
[1052] = {id = 1052, item_reward = 2049, type = 5301}
, 
[1053] = {id = 1053, item_reward = 2048, type = 5301}
, 
[1054] = {id = 1054, item_reward = 2026, type = 5301}
}
, 
[5302] = {
[1021] = {id = 1021, item_reward = 2002, type = 5302}
, 
[1023] = {id = 1023, item_reward = 2006, type = 5302}
, 
[1026] = {id = 1026, item_reward = 2011, type = 5302}
, 
[1028] = {id = 1028, item_reward = 2013, type = 5302}
, 
[1030] = {id = 1030, item_reward = 2015, type = 5302}
, 
[1031] = {id = 1031, item_reward = 2017, type = 5302}
, 
[1032] = {id = 1032, item_reward = 2019, type = 5302}
, 
[1036] = {id = 1036, item_reward = 2024, type = 5302}
, 
[1038] = {id = 1038, item_reward = 2030, type = 5302}
, 
[1039] = {id = 1039, item_reward = 2031, type = 5302}
, 
[1040] = {id = 1040, item_reward = 2032, type = 5302}
, 
[1041] = {id = 1041, item_reward = 2033, type = 5302}
, 
[1045] = {id = 1045, item_reward = 2038, type = 5302}
, 
[1046] = {id = 1046, item_reward = 2040, type = 5302}
}
, 
[5303] = {
[1022] = {id = 1022, item_reward = 2004, type = 5303}
, 
[1024] = {id = 1024, item_reward = 2007, type = 5303}
, 
[1025] = {id = 1025, type = 5303}
, 
[1027] = {id = 1027, item_reward = 2012, type = 5303}
, 
[1029] = {id = 1029, item_reward = 2014, type = 5303}
, 
[1033] = {id = 1033, item_reward = 2020, type = 5303}
, 
[1034] = {id = 1034, item_reward = 2021, type = 5303}
, 
[1035] = {id = 1035, item_reward = 2023, type = 5303}
, 
[1037] = {id = 1037, item_reward = 2027, type = 5303}
, 
[1042] = {id = 1042, item_reward = 2034, type = 5303}
, 
[1043] = {id = 1043, item_reward = 2035, type = 5303}
, 
[1044] = {id = 1044, item_reward = 2036, type = 5303}
}
, 
[5401] = {
[418] = {id = 418, item_reward = 2055, type = 5401}
, 
[419] = {id = 419, item_reward = 2043, type = 5401}
, 
[420] = {id = 420, item_reward = 2037, type = 5401}
, 
[421] = {id = 421, item_reward = 2046, type = 5401}
, 
[422] = {id = 422, item_reward = 2042, type = 5401}
, 
[423] = {id = 423, item_reward = 2022, type = 5401}
, 
[424] = {id = 424, item_reward = 2049, type = 5401}
, 
[425] = {id = 425, item_reward = 2051, type = 5401}
, 
[426] = {id = 426, item_reward = 2016, type = 5401}
, 
[427] = {id = 427, item_reward = 2045, type = 5401}
, 
[428] = {id = 428, item_reward = 2050, type = 5401}
, 
[429] = {id = 429, item_reward = 2018, type = 5401}
, 
[430] = {id = 430, item_reward = 2026, type = 5401}
, 
[431] = {id = 431, item_reward = 2052, type = 5401}
}
, 
[5402] = {
[392] = {id = 392, item_reward = 2002, type = 5402}
, 
[394] = {id = 394, item_reward = 2006, type = 5402}
, 
[397] = {id = 397, item_reward = 2011, type = 5402}
, 
[399] = {id = 399, item_reward = 2013, type = 5402}
, 
[401] = {id = 401, item_reward = 2015, type = 5402}
, 
[402] = {id = 402, item_reward = 2017, type = 5402}
, 
[403] = {id = 403, item_reward = 2019, type = 5402}
, 
[407] = {id = 407, item_reward = 2024, type = 5402}
, 
[409] = {id = 409, item_reward = 2030, type = 5402}
, 
[410] = {id = 410, item_reward = 2031, type = 5402}
, 
[411] = {id = 411, item_reward = 2032, type = 5402}
, 
[412] = {id = 412, item_reward = 2033, type = 5402}
, 
[416] = {id = 416, item_reward = 2038, type = 5402}
, 
[417] = {id = 417, item_reward = 2040, type = 5402}
}
, 
[5403] = {
[393] = {id = 393, item_reward = 2004, type = 5403}
, 
[395] = {id = 395, item_reward = 2007, type = 5403}
, 
[396] = {id = 396, type = 5403}
, 
[398] = {id = 398, item_reward = 2012, type = 5403}
, 
[400] = {id = 400, item_reward = 2014, type = 5403}
, 
[404] = {id = 404, item_reward = 2020, type = 5403}
, 
[405] = {id = 405, item_reward = 2021, type = 5403}
, 
[406] = {id = 406, item_reward = 2023, type = 5403}
, 
[408] = {id = 408, item_reward = 2027, type = 5403}
, 
[413] = {id = 413, item_reward = 2034, type = 5403}
, 
[414] = {id = 414, item_reward = 2035, type = 5403}
, 
[415] = {id = 415, item_reward = 2036, type = 5403}
}
, 
[5501] = {
[1081] = {id = 1081, item_reward = 2046, type = 5501}
, 
[1082] = {id = 1082, item_reward = 2025, type = 5501}
, 
[1083] = {id = 1083, item_reward = 2028, type = 5501}
, 
[1084] = {id = 1084, item_reward = 2039, type = 5501}
, 
[1085] = {id = 1085, item_reward = 2016, type = 5501}
, 
[1086] = {id = 1086, item_reward = 2018, type = 5501}
, 
[1087] = {id = 1087, item_reward = 2026, type = 5501}
, 
[1088] = {id = 1088, item_reward = 2052, type = 5501}
}
, 
[5502] = {
[1055] = {id = 1055, item_reward = 2002, type = 5502}
, 
[1057] = {id = 1057, item_reward = 2006, type = 5502}
, 
[1060] = {id = 1060, item_reward = 2011, type = 5502}
, 
[1062] = {id = 1062, item_reward = 2013, type = 5502}
, 
[1064] = {id = 1064, item_reward = 2015, type = 5502}
, 
[1065] = {id = 1065, item_reward = 2017, type = 5502}
, 
[1066] = {id = 1066, item_reward = 2019, type = 5502}
, 
[1070] = {id = 1070, item_reward = 2024, type = 5502}
, 
[1072] = {id = 1072, item_reward = 2030, type = 5502}
, 
[1073] = {id = 1073, item_reward = 2031, type = 5502}
, 
[1074] = {id = 1074, item_reward = 2032, type = 5502}
, 
[1075] = {id = 1075, item_reward = 2033, type = 5502}
, 
[1079] = {id = 1079, item_reward = 2038, type = 5502}
, 
[1080] = {id = 1080, item_reward = 2040, type = 5502}
}
, 
[5503] = {
[1056] = {id = 1056, item_reward = 2004, type = 5503}
, 
[1058] = {id = 1058, item_reward = 2007, type = 5503}
, 
[1059] = {id = 1059, type = 5503}
, 
[1061] = {id = 1061, item_reward = 2012, type = 5503}
, 
[1063] = {id = 1063, item_reward = 2014, type = 5503}
, 
[1067] = {id = 1067, item_reward = 2020, type = 5503}
, 
[1068] = {id = 1068, item_reward = 2021, type = 5503}
, 
[1069] = {id = 1069, item_reward = 2023, type = 5503}
, 
[1071] = {id = 1071, item_reward = 2027, type = 5503}
, 
[1076] = {id = 1076, item_reward = 2034, type = 5503}
, 
[1077] = {id = 1077, item_reward = 2035, type = 5503}
, 
[1078] = {id = 1078, item_reward = 2036, type = 5503}
}
, 
[5601] = {
[1115] = {id = 1115, item_reward = 2010, type = 5601}
, 
[1116] = {id = 1116, item_reward = 2037, type = 5601}
, 
[1117] = {id = 1117, item_reward = 2044, type = 5601}
, 
[1118] = {id = 1118, item_reward = 2039, type = 5601}
, 
[1119] = {id = 1119, item_reward = 2051, type = 5601}
, 
[1120] = {id = 1120, item_reward = 2048, type = 5601}
, 
[1121] = {id = 1121, item_reward = 2041, type = 5601}
, 
[1122] = {id = 1122, item_reward = 2026, type = 5601}
}
, 
[5602] = {
[1089] = {id = 1089, item_reward = 2002, type = 5602}
, 
[1091] = {id = 1091, item_reward = 2006, type = 5602}
, 
[1094] = {id = 1094, item_reward = 2011, type = 5602}
, 
[1096] = {id = 1096, item_reward = 2013, type = 5602}
, 
[1098] = {id = 1098, item_reward = 2015, type = 5602}
, 
[1099] = {id = 1099, item_reward = 2017, type = 5602}
, 
[1100] = {id = 1100, item_reward = 2019, type = 5602}
, 
[1104] = {id = 1104, item_reward = 2024, type = 5602}
, 
[1106] = {id = 1106, item_reward = 2030, type = 5602}
, 
[1107] = {id = 1107, item_reward = 2031, type = 5602}
, 
[1108] = {id = 1108, item_reward = 2032, type = 5602}
, 
[1109] = {id = 1109, item_reward = 2033, type = 5602}
, 
[1113] = {id = 1113, item_reward = 2038, type = 5602}
, 
[1114] = {id = 1114, item_reward = 2040, type = 5602}
}
, 
[5603] = {
[1090] = {id = 1090, item_reward = 2004, type = 5603}
, 
[1092] = {id = 1092, item_reward = 2007, type = 5603}
, 
[1093] = {id = 1093, type = 5603}
, 
[1095] = {id = 1095, item_reward = 2012, type = 5603}
, 
[1097] = {id = 1097, item_reward = 2014, type = 5603}
, 
[1101] = {id = 1101, item_reward = 2020, type = 5603}
, 
[1102] = {id = 1102, item_reward = 2021, type = 5603}
, 
[1103] = {id = 1103, item_reward = 2023, type = 5603}
, 
[1105] = {id = 1105, item_reward = 2027, type = 5603}
, 
[1110] = {id = 1110, item_reward = 2034, type = 5603}
, 
[1111] = {id = 1111, item_reward = 2035, type = 5603}
, 
[1112] = {id = 1112, item_reward = 2036, type = 5603}
}
, 
[5701] = {
[1149] = {id = 1149, item_reward = 2010, type = 5701}
, 
[1150] = {id = 1150, item_reward = 2037, type = 5701}
, 
[1151] = {id = 1151, item_reward = 2044, type = 5701}
, 
[1152] = {id = 1152, item_reward = 2039, type = 5701}
, 
[1153] = {id = 1153, item_reward = 2051, type = 5701}
, 
[1154] = {id = 1154, item_reward = 2048, type = 5701}
, 
[1155] = {id = 1155, item_reward = 2041, type = 5701}
, 
[1156] = {id = 1156, item_reward = 2026, type = 5701}
}
, 
[5702] = {
[1123] = {id = 1123, item_reward = 2002, type = 5702}
, 
[1125] = {id = 1125, item_reward = 2006, type = 5702}
, 
[1128] = {id = 1128, item_reward = 2011, type = 5702}
, 
[1130] = {id = 1130, item_reward = 2013, type = 5702}
, 
[1132] = {id = 1132, item_reward = 2015, type = 5702}
, 
[1133] = {id = 1133, item_reward = 2017, type = 5702}
, 
[1134] = {id = 1134, item_reward = 2019, type = 5702}
, 
[1138] = {id = 1138, item_reward = 2024, type = 5702}
, 
[1140] = {id = 1140, item_reward = 2030, type = 5702}
, 
[1141] = {id = 1141, item_reward = 2031, type = 5702}
, 
[1142] = {id = 1142, item_reward = 2032, type = 5702}
, 
[1143] = {id = 1143, item_reward = 2033, type = 5702}
, 
[1147] = {id = 1147, item_reward = 2038, type = 5702}
, 
[1148] = {id = 1148, item_reward = 2040, type = 5702}
}
, 
[5703] = {
[1124] = {id = 1124, item_reward = 2004, type = 5703}
, 
[1126] = {id = 1126, item_reward = 2007, type = 5703}
, 
[1127] = {id = 1127, type = 5703}
, 
[1129] = {id = 1129, item_reward = 2012, type = 5703}
, 
[1131] = {id = 1131, item_reward = 2014, type = 5703}
, 
[1135] = {id = 1135, item_reward = 2020, type = 5703}
, 
[1136] = {id = 1136, item_reward = 2021, type = 5703}
, 
[1137] = {id = 1137, item_reward = 2023, type = 5703}
, 
[1139] = {id = 1139, item_reward = 2027, type = 5703}
, 
[1144] = {id = 1144, item_reward = 2034, type = 5703}
, 
[1145] = {id = 1145, item_reward = 2035, type = 5703}
, 
[1146] = {id = 1146, item_reward = 2036, type = 5703}
}
, 
[5801] = {
[458] = {id = 458, item_reward = 2057, type = 5801}
, 
[459] = {id = 459, item_reward = 2043, type = 5801}
, 
[460] = {id = 460, item_reward = 2037, type = 5801}
, 
[461] = {id = 461, item_reward = 2053, type = 5801}
, 
[462] = {id = 462, item_reward = 2042, type = 5801}
, 
[463] = {id = 463, item_reward = 2022, type = 5801}
, 
[464] = {id = 464, item_reward = 2039, type = 5801}
, 
[465] = {id = 465, item_reward = 2049, type = 5801}
, 
[466] = {id = 466, item_reward = 2051, type = 5801}
, 
[467] = {id = 467, item_reward = 2048, type = 5801}
, 
[468] = {id = 468, item_reward = 2045, type = 5801}
, 
[469] = {id = 469, item_reward = 2041, type = 5801}
, 
[470] = {id = 470, item_reward = 2008, type = 5801}
, 
[471] = {id = 471, item_reward = 2026, type = 5801}
}
, 
[5802] = {
[432] = {id = 432, item_reward = 2002, type = 5802}
, 
[434] = {id = 434, item_reward = 2006, type = 5802}
, 
[437] = {id = 437, item_reward = 2011, type = 5802}
, 
[439] = {id = 439, item_reward = 2013, type = 5802}
, 
[441] = {id = 441, item_reward = 2015, type = 5802}
, 
[442] = {id = 442, item_reward = 2017, type = 5802}
, 
[443] = {id = 443, item_reward = 2019, type = 5802}
, 
[447] = {id = 447, item_reward = 2024, type = 5802}
, 
[449] = {id = 449, item_reward = 2030, type = 5802}
, 
[450] = {id = 450, item_reward = 2031, type = 5802}
, 
[451] = {id = 451, item_reward = 2032, type = 5802}
, 
[452] = {id = 452, item_reward = 2033, type = 5802}
, 
[456] = {id = 456, item_reward = 2038, type = 5802}
, 
[457] = {id = 457, item_reward = 2040, type = 5802}
}
, 
[5803] = {
[433] = {id = 433, item_reward = 2004, type = 5803}
, 
[435] = {id = 435, item_reward = 2007, type = 5803}
, 
[436] = {id = 436, type = 5803}
, 
[438] = {id = 438, item_reward = 2012, type = 5803}
, 
[440] = {id = 440, item_reward = 2014, type = 5803}
, 
[444] = {id = 444, item_reward = 2020, type = 5803}
, 
[445] = {id = 445, item_reward = 2021, type = 5803}
, 
[446] = {id = 446, item_reward = 2023, type = 5803}
, 
[448] = {id = 448, item_reward = 2027, type = 5803}
, 
[453] = {id = 453, item_reward = 2034, type = 5803}
, 
[454] = {id = 454, item_reward = 2035, type = 5803}
, 
[455] = {id = 455, item_reward = 2036, type = 5803}
}
, 
[5901] = {
[1183] = {id = 1183, item_reward = 2057, type = 5901}
, 
[1184] = {id = 1184, item_reward = 2025, type = 5901}
, 
[1185] = {id = 1185, item_reward = 2042, type = 5901}
, 
[1186] = {id = 1186, item_reward = 2028, type = 5901}
, 
[1187] = {id = 1187, item_reward = 2049, type = 5901}
, 
[1188] = {id = 1188, item_reward = 2016, type = 5901}
, 
[1189] = {id = 1189, item_reward = 2018, type = 5901}
, 
[1190] = {id = 1190, item_reward = 2052, type = 5901}
}
, 
[5902] = {
[1157] = {id = 1157, item_reward = 2002, type = 5902}
, 
[1159] = {id = 1159, item_reward = 2006, type = 5902}
, 
[1162] = {id = 1162, item_reward = 2011, type = 5902}
, 
[1164] = {id = 1164, item_reward = 2013, type = 5902}
, 
[1166] = {id = 1166, item_reward = 2015, type = 5902}
, 
[1167] = {id = 1167, item_reward = 2017, type = 5902}
, 
[1168] = {id = 1168, item_reward = 2019, type = 5902}
, 
[1172] = {id = 1172, item_reward = 2024, type = 5902}
, 
[1174] = {id = 1174, item_reward = 2030, type = 5902}
, 
[1175] = {id = 1175, item_reward = 2031, type = 5902}
, 
[1176] = {id = 1176, item_reward = 2032, type = 5902}
, 
[1177] = {id = 1177, item_reward = 2033, type = 5902}
, 
[1181] = {id = 1181, item_reward = 2038, type = 5902}
, 
[1182] = {id = 1182, item_reward = 2040, type = 5902}
}
, 
[5903] = {
[1158] = {id = 1158, item_reward = 2004, type = 5903}
, 
[1160] = {id = 1160, item_reward = 2007, type = 5903}
, 
[1161] = {id = 1161, type = 5903}
, 
[1163] = {id = 1163, item_reward = 2012, type = 5903}
, 
[1165] = {id = 1165, item_reward = 2014, type = 5903}
, 
[1169] = {id = 1169, item_reward = 2020, type = 5903}
, 
[1170] = {id = 1170, item_reward = 2021, type = 5903}
, 
[1171] = {id = 1171, item_reward = 2023, type = 5903}
, 
[1173] = {id = 1173, item_reward = 2027, type = 5903}
, 
[1178] = {id = 1178, item_reward = 2034, type = 5903}
, 
[1179] = {id = 1179, item_reward = 2035, type = 5903}
, 
[1180] = {id = 1180, item_reward = 2036, type = 5903}
}
, 
[6001] = {
[1217] = {id = 1217, item_reward = 2057, type = 6001}
, 
[1218] = {id = 1218, item_reward = 2025, type = 6001}
, 
[1219] = {id = 1219, item_reward = 2042, type = 6001}
, 
[1220] = {id = 1220, item_reward = 2028, type = 6001}
, 
[1221] = {id = 1221, item_reward = 2049, type = 6001}
, 
[1222] = {id = 1222, item_reward = 2016, type = 6001}
, 
[1223] = {id = 1223, item_reward = 2018, type = 6001}
, 
[1224] = {id = 1224, item_reward = 2052, type = 6001}
}
, 
[6002] = {
[1191] = {id = 1191, item_reward = 2002, type = 6002}
, 
[1193] = {id = 1193, item_reward = 2006, type = 6002}
, 
[1196] = {id = 1196, item_reward = 2011, type = 6002}
, 
[1198] = {id = 1198, item_reward = 2013, type = 6002}
, 
[1200] = {id = 1200, item_reward = 2015, type = 6002}
, 
[1201] = {id = 1201, item_reward = 2017, type = 6002}
, 
[1202] = {id = 1202, item_reward = 2019, type = 6002}
, 
[1206] = {id = 1206, item_reward = 2024, type = 6002}
, 
[1208] = {id = 1208, item_reward = 2030, type = 6002}
, 
[1209] = {id = 1209, item_reward = 2031, type = 6002}
, 
[1210] = {id = 1210, item_reward = 2032, type = 6002}
, 
[1211] = {id = 1211, item_reward = 2033, type = 6002}
, 
[1215] = {id = 1215, item_reward = 2038, type = 6002}
, 
[1216] = {id = 1216, item_reward = 2040, type = 6002}
}
, 
[6003] = {
[1192] = {id = 1192, item_reward = 2004, type = 6003}
, 
[1194] = {id = 1194, item_reward = 2007, type = 6003}
, 
[1195] = {id = 1195, type = 6003}
, 
[1197] = {id = 1197, item_reward = 2012, type = 6003}
, 
[1199] = {id = 1199, item_reward = 2014, type = 6003}
, 
[1203] = {id = 1203, item_reward = 2020, type = 6003}
, 
[1204] = {id = 1204, item_reward = 2021, type = 6003}
, 
[1205] = {id = 1205, item_reward = 2023, type = 6003}
, 
[1207] = {id = 1207, item_reward = 2027, type = 6003}
, 
[1212] = {id = 1212, item_reward = 2034, type = 6003}
, 
[1213] = {id = 1213, item_reward = 2035, type = 6003}
, 
[1214] = {id = 1214, item_reward = 2036, type = 6003}
}
, 
[6101] = {
[231] = {id = 231, item_reward = 2043, type = 6101}
, 
[232] = {id = 232, item_reward = 2025, type = 6101}
, 
[233] = {id = 233, item_reward = 2046, type = 6101}
, 
[234] = {id = 234, item_reward = 2042, type = 6101}
, 
[235] = {id = 235, item_reward = 2022, type = 6101}
, 
[236] = {id = 236, item_reward = 2039, type = 6101}
, 
[237] = {id = 237, item_reward = 2045, type = 6101}
, 
[238] = {id = 238, item_reward = 2008, type = 6101}
}
, 
[6102] = {
[205] = {id = 205, item_reward = 2002, type = 6102}
, 
[207] = {id = 207, item_reward = 2006, type = 6102}
, 
[210] = {id = 210, item_reward = 2011, type = 6102}
, 
[212] = {id = 212, item_reward = 2013, type = 6102}
, 
[214] = {id = 214, item_reward = 2015, type = 6102}
, 
[215] = {id = 215, item_reward = 2017, type = 6102}
, 
[216] = {id = 216, item_reward = 2019, type = 6102}
, 
[220] = {id = 220, item_reward = 2024, type = 6102}
, 
[222] = {id = 222, item_reward = 2030, type = 6102}
, 
[223] = {id = 223, item_reward = 2031, type = 6102}
, 
[224] = {id = 224, item_reward = 2032, type = 6102}
, 
[225] = {id = 225, item_reward = 2033, type = 6102}
, 
[229] = {id = 229, item_reward = 2038, type = 6102}
, 
[230] = {id = 230, item_reward = 2040, type = 6102}
}
, 
[6103] = {
[206] = {id = 206, item_reward = 2004, type = 6103}
, 
[208] = {id = 208, item_reward = 2007, type = 6103}
, 
[209] = {id = 209, type = 6103}
, 
[211] = {id = 211, item_reward = 2012, type = 6103}
, 
[213] = {id = 213, item_reward = 2014, type = 6103}
, 
[217] = {id = 217, item_reward = 2020, type = 6103}
, 
[218] = {id = 218, item_reward = 2021, type = 6103}
, 
[219] = {id = 219, item_reward = 2023, type = 6103}
, 
[221] = {id = 221, item_reward = 2027, type = 6103}
, 
[226] = {id = 226, item_reward = 2034, type = 6103}
, 
[227] = {id = 227, item_reward = 2035, type = 6103}
, 
[228] = {id = 228, item_reward = 2036, type = 6103}
}
, 
[6301] = {
[1251] = {id = 1251, item_reward = 2058, type = 6301}
, 
[1252] = {id = 1252, item_reward = 2053, type = 6301}
, 
[1253] = {id = 1253, item_reward = 2028, type = 6301}
, 
[1254] = {id = 1254, item_reward = 2049, type = 6301}
, 
[1255] = {id = 1255, item_reward = 2016, type = 6301}
, 
[1256] = {id = 1256, item_reward = 2050, type = 6301}
, 
[1257] = {id = 1257, item_reward = 2018, type = 6301}
, 
[1258] = {id = 1258, item_reward = 2052, type = 6301}
}
, 
[6302] = {
[1225] = {id = 1225, item_reward = 2002, type = 6302}
, 
[1227] = {id = 1227, item_reward = 2006, type = 6302}
, 
[1230] = {id = 1230, item_reward = 2011, type = 6302}
, 
[1232] = {id = 1232, item_reward = 2013, type = 6302}
, 
[1234] = {id = 1234, item_reward = 2015, type = 6302}
, 
[1235] = {id = 1235, item_reward = 2017, type = 6302}
, 
[1236] = {id = 1236, item_reward = 2019, type = 6302}
, 
[1240] = {id = 1240, item_reward = 2024, type = 6302}
, 
[1242] = {id = 1242, item_reward = 2030, type = 6302}
, 
[1243] = {id = 1243, item_reward = 2031, type = 6302}
, 
[1244] = {id = 1244, item_reward = 2032, type = 6302}
, 
[1245] = {id = 1245, item_reward = 2033, type = 6302}
, 
[1249] = {id = 1249, item_reward = 2038, type = 6302}
, 
[1250] = {id = 1250, item_reward = 2040, type = 6302}
}
, 
[6303] = {
[1226] = {id = 1226, item_reward = 2004, type = 6303}
, 
[1228] = {id = 1228, item_reward = 2007, type = 6303}
, 
[1229] = {id = 1229, type = 6303}
, 
[1231] = {id = 1231, item_reward = 2012, type = 6303}
, 
[1233] = {id = 1233, item_reward = 2014, type = 6303}
, 
[1237] = {id = 1237, item_reward = 2020, type = 6303}
, 
[1238] = {id = 1238, item_reward = 2021, type = 6303}
, 
[1239] = {id = 1239, item_reward = 2023, type = 6303}
, 
[1241] = {id = 1241, item_reward = 2027, type = 6303}
, 
[1246] = {id = 1246, item_reward = 2034, type = 6303}
, 
[1247] = {id = 1247, item_reward = 2035, type = 6303}
, 
[1248] = {id = 1248, item_reward = 2036, type = 6303}
}
, 
[6401] = {
[1285] = {id = 1285, item_reward = 2058, type = 6401}
, 
[1286] = {id = 1286, item_reward = 2053, type = 6401}
, 
[1287] = {id = 1287, item_reward = 2028, type = 6401}
, 
[1288] = {id = 1288, item_reward = 2049, type = 6401}
, 
[1289] = {id = 1289, item_reward = 2016, type = 6401}
, 
[1290] = {id = 1290, item_reward = 2050, type = 6401}
, 
[1291] = {id = 1291, item_reward = 2018, type = 6401}
, 
[1292] = {id = 1292, item_reward = 2052, type = 6401}
}
, 
[6402] = {
[1259] = {id = 1259, item_reward = 2002, type = 6402}
, 
[1261] = {id = 1261, item_reward = 2006, type = 6402}
, 
[1264] = {id = 1264, item_reward = 2011, type = 6402}
, 
[1266] = {id = 1266, item_reward = 2013, type = 6402}
, 
[1268] = {id = 1268, item_reward = 2015, type = 6402}
, 
[1269] = {id = 1269, item_reward = 2017, type = 6402}
, 
[1270] = {id = 1270, item_reward = 2019, type = 6402}
, 
[1274] = {id = 1274, item_reward = 2024, type = 6402}
, 
[1276] = {id = 1276, item_reward = 2030, type = 6402}
, 
[1277] = {id = 1277, item_reward = 2031, type = 6402}
, 
[1278] = {id = 1278, item_reward = 2032, type = 6402}
, 
[1279] = {id = 1279, item_reward = 2033, type = 6402}
, 
[1283] = {id = 1283, item_reward = 2038, type = 6402}
, 
[1284] = {id = 1284, item_reward = 2040, type = 6402}
}
, 
[6403] = {
[1260] = {id = 1260, item_reward = 2004, type = 6403}
, 
[1262] = {id = 1262, item_reward = 2007, type = 6403}
, 
[1263] = {id = 1263, type = 6403}
, 
[1265] = {id = 1265, item_reward = 2012, type = 6403}
, 
[1267] = {id = 1267, item_reward = 2014, type = 6403}
, 
[1271] = {id = 1271, item_reward = 2020, type = 6403}
, 
[1272] = {id = 1272, item_reward = 2021, type = 6403}
, 
[1273] = {id = 1273, item_reward = 2023, type = 6403}
, 
[1275] = {id = 1275, item_reward = 2027, type = 6403}
, 
[1280] = {id = 1280, item_reward = 2034, type = 6403}
, 
[1281] = {id = 1281, item_reward = 2035, type = 6403}
, 
[1282] = {id = 1282, item_reward = 2036, type = 6403}
}
, 
[6501] = {
[1319] = {id = 1319, item_reward = 2039, type = 6501}
, 
[1320] = {id = 1320, item_reward = 2037, type = 6501}
, 
[1321] = {id = 1321, item_reward = 2053, type = 6501}
, 
[1322] = {id = 1322, item_reward = 2051, type = 6501}
, 
[1323] = {id = 1323, item_reward = 2048, type = 6501}
, 
[1324] = {id = 1324, item_reward = 2050, type = 6501}
, 
[1325] = {id = 1325, item_reward = 2041, type = 6501}
, 
[1326] = {id = 1326, item_reward = 2054, type = 6501}
}
, 
[6502] = {
[1293] = {id = 1293, item_reward = 2002, type = 6502}
, 
[1295] = {id = 1295, item_reward = 2006, type = 6502}
, 
[1298] = {id = 1298, item_reward = 2011, type = 6502}
, 
[1300] = {id = 1300, item_reward = 2013, type = 6502}
, 
[1302] = {id = 1302, item_reward = 2015, type = 6502}
, 
[1303] = {id = 1303, item_reward = 2017, type = 6502}
, 
[1304] = {id = 1304, item_reward = 2019, type = 6502}
, 
[1308] = {id = 1308, item_reward = 2024, type = 6502}
, 
[1310] = {id = 1310, item_reward = 2030, type = 6502}
, 
[1311] = {id = 1311, item_reward = 2031, type = 6502}
, 
[1312] = {id = 1312, item_reward = 2032, type = 6502}
, 
[1313] = {id = 1313, item_reward = 2033, type = 6502}
, 
[1317] = {id = 1317, item_reward = 2038, type = 6502}
, 
[1318] = {id = 1318, item_reward = 2040, type = 6502}
}
, 
[6503] = {
[1294] = {id = 1294, item_reward = 2004, type = 6503}
, 
[1296] = {id = 1296, item_reward = 2007, type = 6503}
, 
[1297] = {id = 1297, type = 6503}
, 
[1299] = {id = 1299, item_reward = 2012, type = 6503}
, 
[1301] = {id = 1301, item_reward = 2014, type = 6503}
, 
[1305] = {id = 1305, item_reward = 2020, type = 6503}
, 
[1306] = {id = 1306, item_reward = 2021, type = 6503}
, 
[1307] = {id = 1307, item_reward = 2023, type = 6503}
, 
[1309] = {id = 1309, item_reward = 2027, type = 6503}
, 
[1314] = {id = 1314, item_reward = 2034, type = 6503}
, 
[1315] = {id = 1315, item_reward = 2035, type = 6503}
, 
[1316] = {id = 1316, item_reward = 2036, type = 6503}
}
, 
[6601] = {
[1353] = {id = 1353, item_reward = 2052, type = 6601}
, 
[1354] = {id = 1354, item_reward = 2010, type = 6601}
, 
[1355] = {id = 1355, item_reward = 2025, type = 6601}
, 
[1356] = {id = 1356, item_reward = 2037, type = 6601}
, 
[1357] = {id = 1357, item_reward = 2039, type = 6601}
, 
[1358] = {id = 1358, item_reward = 2050, type = 6601}
, 
[1359] = {id = 1359, item_reward = 2053, type = 6601}
, 
[1360] = {id = 1360, item_reward = 2042, type = 6601}
}
, 
[6602] = {
[1327] = {id = 1327, item_reward = 2002, type = 6602}
, 
[1329] = {id = 1329, item_reward = 2006, type = 6602}
, 
[1332] = {id = 1332, item_reward = 2011, type = 6602}
, 
[1334] = {id = 1334, item_reward = 2013, type = 6602}
, 
[1336] = {id = 1336, item_reward = 2015, type = 6602}
, 
[1337] = {id = 1337, item_reward = 2017, type = 6602}
, 
[1338] = {id = 1338, item_reward = 2019, type = 6602}
, 
[1342] = {id = 1342, item_reward = 2024, type = 6602}
, 
[1344] = {id = 1344, item_reward = 2030, type = 6602}
, 
[1345] = {id = 1345, item_reward = 2031, type = 6602}
, 
[1346] = {id = 1346, item_reward = 2032, type = 6602}
, 
[1347] = {id = 1347, item_reward = 2033, type = 6602}
, 
[1351] = {id = 1351, item_reward = 2038, type = 6602}
, 
[1352] = {id = 1352, item_reward = 2040, type = 6602}
}
, 
[6603] = {
[1328] = {id = 1328, item_reward = 2004, type = 6603}
, 
[1330] = {id = 1330, item_reward = 2007, type = 6603}
, 
[1331] = {id = 1331, type = 6603}
, 
[1333] = {id = 1333, item_reward = 2012, type = 6603}
, 
[1335] = {id = 1335, item_reward = 2014, type = 6603}
, 
[1339] = {id = 1339, item_reward = 2020, type = 6603}
, 
[1340] = {id = 1340, item_reward = 2021, type = 6603}
, 
[1341] = {id = 1341, item_reward = 2023, type = 6603}
, 
[1343] = {id = 1343, item_reward = 2027, type = 6603}
, 
[1348] = {id = 1348, item_reward = 2034, type = 6603}
, 
[1349] = {id = 1349, item_reward = 2035, type = 6603}
, 
[1350] = {id = 1350, item_reward = 2036, type = 6603}
}
, 
[6701] = {
[498] = {id = 498, item_reward = 2059, type = 6701}
, 
[499] = {id = 499, item_reward = 2053, type = 6701}
, 
[500] = {id = 500, item_reward = 2052, type = 6701}
, 
[501] = {id = 501, item_reward = 2028, type = 6701}
, 
[502] = {id = 502, item_reward = 2050, type = 6701}
, 
[503] = {id = 503, item_reward = 2016, type = 6701}
, 
[504] = {id = 504, item_reward = 2026, type = 6701}
, 
[505] = {id = 505, item_reward = 2018, type = 6701}
, 
[506] = {id = 506, item_reward = 2041, type = 6701}
, 
[507] = {id = 507, item_reward = 2025, type = 6701}
, 
[508] = {id = 508, item_reward = 2022, type = 6701}
, 
[509] = {id = 509, item_reward = 2010, type = 6701}
, 
[510] = {id = 510, item_reward = 2043, type = 6701}
, 
[511] = {id = 511, item_reward = 2008, type = 6701}
}
, 
[6702] = {
[472] = {id = 472, item_reward = 2002, type = 6702}
, 
[474] = {id = 474, item_reward = 2006, type = 6702}
, 
[477] = {id = 477, item_reward = 2011, type = 6702}
, 
[479] = {id = 479, item_reward = 2013, type = 6702}
, 
[481] = {id = 481, item_reward = 2015, type = 6702}
, 
[482] = {id = 482, item_reward = 2017, type = 6702}
, 
[483] = {id = 483, item_reward = 2019, type = 6702}
, 
[487] = {id = 487, item_reward = 2024, type = 6702}
, 
[489] = {id = 489, item_reward = 2030, type = 6702}
, 
[490] = {id = 490, item_reward = 2031, type = 6702}
, 
[491] = {id = 491, item_reward = 2032, type = 6702}
, 
[492] = {id = 492, item_reward = 2033, type = 6702}
, 
[496] = {id = 496, item_reward = 2038, type = 6702}
, 
[497] = {id = 497, item_reward = 2040, type = 6702}
}
, 
[6703] = {
[473] = {id = 473, item_reward = 2004, type = 6703}
, 
[475] = {id = 475, item_reward = 2007, type = 6703}
, 
[476] = {id = 476, type = 6703}
, 
[478] = {id = 478, item_reward = 2012, type = 6703}
, 
[480] = {id = 480, item_reward = 2014, type = 6703}
, 
[484] = {id = 484, item_reward = 2020, type = 6703}
, 
[485] = {id = 485, item_reward = 2021, type = 6703}
, 
[486] = {id = 486, item_reward = 2023, type = 6703}
, 
[488] = {id = 488, item_reward = 2027, type = 6703}
, 
[493] = {id = 493, item_reward = 2034, type = 6703}
, 
[494] = {id = 494, item_reward = 2035, type = 6703}
, 
[495] = {id = 495, item_reward = 2036, type = 6703}
}
, 
[6801] = {
[1387] = {id = 1387, item_reward = 2059, type = 6801}
, 
[1388] = {id = 1388, item_reward = 2028, type = 6801}
, 
[1389] = {id = 1389, item_reward = 2016, type = 6801}
, 
[1390] = {id = 1390, item_reward = 2018, type = 6801}
, 
[1391] = {id = 1391, item_reward = 2037, type = 6801}
, 
[1392] = {id = 1392, item_reward = 2041, type = 6801}
, 
[1393] = {id = 1393, item_reward = 2026, type = 6801}
, 
[1394] = {id = 1394, item_reward = 2044, type = 6801}
}
, 
[6802] = {
[1361] = {id = 1361, item_reward = 2002, type = 6802}
, 
[1363] = {id = 1363, item_reward = 2006, type = 6802}
, 
[1366] = {id = 1366, item_reward = 2011, type = 6802}
, 
[1368] = {id = 1368, item_reward = 2013, type = 6802}
, 
[1370] = {id = 1370, item_reward = 2015, type = 6802}
, 
[1371] = {id = 1371, item_reward = 2017, type = 6802}
, 
[1372] = {id = 1372, item_reward = 2019, type = 6802}
, 
[1376] = {id = 1376, item_reward = 2024, type = 6802}
, 
[1378] = {id = 1378, item_reward = 2030, type = 6802}
, 
[1379] = {id = 1379, item_reward = 2031, type = 6802}
, 
[1380] = {id = 1380, item_reward = 2032, type = 6802}
, 
[1381] = {id = 1381, item_reward = 2033, type = 6802}
, 
[1385] = {id = 1385, item_reward = 2038, type = 6802}
, 
[1386] = {id = 1386, item_reward = 2040, type = 6802}
}
, 
[6803] = {
[1362] = {id = 1362, item_reward = 2004, type = 6803}
, 
[1364] = {id = 1364, item_reward = 2007, type = 6803}
, 
[1365] = {id = 1365, type = 6803}
, 
[1367] = {id = 1367, item_reward = 2012, type = 6803}
, 
[1369] = {id = 1369, item_reward = 2014, type = 6803}
, 
[1373] = {id = 1373, item_reward = 2020, type = 6803}
, 
[1374] = {id = 1374, item_reward = 2021, type = 6803}
, 
[1375] = {id = 1375, item_reward = 2023, type = 6803}
, 
[1377] = {id = 1377, item_reward = 2027, type = 6803}
, 
[1382] = {id = 1382, item_reward = 2034, type = 6803}
, 
[1383] = {id = 1383, item_reward = 2035, type = 6803}
, 
[1384] = {id = 1384, item_reward = 2036, type = 6803}
}
, 
[6901] = {
[265] = {id = 265, item_reward = 2045, type = 6901}
, 
[266] = {id = 266, item_reward = 2018, type = 6901}
, 
[267] = {id = 267, item_reward = 2025, type = 6901}
, 
[268] = {id = 268, item_reward = 2026, type = 6901}
, 
[269] = {id = 269, item_reward = 2043, type = 6901}
, 
[270] = {id = 270, item_reward = 2050, type = 6901}
, 
[271] = {id = 271, item_reward = 2054, type = 6901}
, 
[272] = {id = 272, item_reward = 2022, type = 6901}
}
, 
[6902] = {
[239] = {id = 239, item_reward = 2002, type = 6902}
, 
[241] = {id = 241, item_reward = 2006, type = 6902}
, 
[244] = {id = 244, item_reward = 2011, type = 6902}
, 
[246] = {id = 246, item_reward = 2013, type = 6902}
, 
[248] = {id = 248, item_reward = 2015, type = 6902}
, 
[249] = {id = 249, item_reward = 2017, type = 6902}
, 
[250] = {id = 250, item_reward = 2019, type = 6902}
, 
[254] = {id = 254, item_reward = 2024, type = 6902}
, 
[256] = {id = 256, item_reward = 2030, type = 6902}
, 
[257] = {id = 257, item_reward = 2031, type = 6902}
, 
[258] = {id = 258, item_reward = 2032, type = 6902}
, 
[259] = {id = 259, item_reward = 2033, type = 6902}
, 
[263] = {id = 263, item_reward = 2038, type = 6902}
, 
[264] = {id = 264, item_reward = 2040, type = 6902}
}
, 
[6903] = {
[240] = {id = 240, item_reward = 2004, type = 6903}
, 
[242] = {id = 242, item_reward = 2007, type = 6903}
, 
[243] = {id = 243, type = 6903}
, 
[245] = {id = 245, item_reward = 2012, type = 6903}
, 
[247] = {id = 247, item_reward = 2014, type = 6903}
, 
[251] = {id = 251, item_reward = 2020, type = 6903}
, 
[252] = {id = 252, item_reward = 2021, type = 6903}
, 
[253] = {id = 253, item_reward = 2023, type = 6903}
, 
[255] = {id = 255, item_reward = 2027, type = 6903}
, 
[260] = {id = 260, item_reward = 2034, type = 6903}
, 
[261] = {id = 261, item_reward = 2035, type = 6903}
, 
[262] = {id = 262, item_reward = 2036, type = 6903}
}
, 
[7001] = {
[1421] = {id = 1421, item_reward = 2049, type = 7001}
, 
[1422] = {id = 1422, item_reward = 2028, type = 7001}
, 
[1423] = {id = 1423, item_reward = 2016, type = 7001}
, 
[1424] = {id = 1424, item_reward = 2037, type = 7001}
, 
[1425] = {id = 1425, item_reward = 2039, type = 7001}
, 
[1426] = {id = 1426, item_reward = 2025, type = 7001}
, 
[1427] = {id = 1427, item_reward = 2041, type = 7001}
, 
[1428] = {id = 1428, item_reward = 2050, type = 7001}
}
, 
[7002] = {
[1395] = {id = 1395, item_reward = 2002, type = 7002}
, 
[1397] = {id = 1397, item_reward = 2006, type = 7002}
, 
[1400] = {id = 1400, item_reward = 2011, type = 7002}
, 
[1402] = {id = 1402, item_reward = 2013, type = 7002}
, 
[1404] = {id = 1404, item_reward = 2015, type = 7002}
, 
[1405] = {id = 1405, item_reward = 2017, type = 7002}
, 
[1406] = {id = 1406, item_reward = 2019, type = 7002}
, 
[1410] = {id = 1410, item_reward = 2024, type = 7002}
, 
[1412] = {id = 1412, item_reward = 2030, type = 7002}
, 
[1413] = {id = 1413, item_reward = 2031, type = 7002}
, 
[1414] = {id = 1414, item_reward = 2032, type = 7002}
, 
[1415] = {id = 1415, item_reward = 2033, type = 7002}
, 
[1419] = {id = 1419, item_reward = 2038, type = 7002}
, 
[1420] = {id = 1420, item_reward = 2040, type = 7002}
}
, 
[7003] = {
[1396] = {id = 1396, item_reward = 2004, type = 7003}
, 
[1398] = {id = 1398, item_reward = 2007, type = 7003}
, 
[1399] = {id = 1399, type = 7003}
, 
[1401] = {id = 1401, item_reward = 2012, type = 7003}
, 
[1403] = {id = 1403, item_reward = 2014, type = 7003}
, 
[1407] = {id = 1407, item_reward = 2020, type = 7003}
, 
[1408] = {id = 1408, item_reward = 2021, type = 7003}
, 
[1409] = {id = 1409, item_reward = 2023, type = 7003}
, 
[1411] = {id = 1411, item_reward = 2027, type = 7003}
, 
[1416] = {id = 1416, item_reward = 2034, type = 7003}
, 
[1417] = {id = 1417, item_reward = 2035, type = 7003}
, 
[1418] = {id = 1418, item_reward = 2036, type = 7003}
}
, 
[7101] = {
[538] = {id = 538, item_reward = 2060, type = 7101}
, 
[539] = {id = 539, item_reward = 2049, type = 7101}
, 
[540] = {id = 540, item_reward = 2054, type = 7101}
, 
[541] = {id = 541, item_reward = 2048, type = 7101}
, 
[542] = {id = 542, item_reward = 2022, type = 7101}
, 
[543] = {id = 543, item_reward = 2037, type = 7101}
, 
[544] = {id = 544, item_reward = 2039, type = 7101}
, 
[545] = {id = 545, item_reward = 2025, type = 7101}
, 
[546] = {id = 546, item_reward = 2018, type = 7101}
, 
[547] = {id = 547, item_reward = 2016, type = 7101}
, 
[548] = {id = 548, item_reward = 2041, type = 7101}
, 
[549] = {id = 549, item_reward = 2026, type = 7101}
, 
[550] = {id = 550, item_reward = 2028, type = 7101}
, 
[551] = {id = 551, item_reward = 2043, type = 7101}
}
, 
[7102] = {
[512] = {id = 512, item_reward = 2002, type = 7102}
, 
[514] = {id = 514, item_reward = 2006, type = 7102}
, 
[517] = {id = 517, item_reward = 2011, type = 7102}
, 
[519] = {id = 519, item_reward = 2013, type = 7102}
, 
[521] = {id = 521, item_reward = 2015, type = 7102}
, 
[522] = {id = 522, item_reward = 2017, type = 7102}
, 
[523] = {id = 523, item_reward = 2019, type = 7102}
, 
[527] = {id = 527, item_reward = 2024, type = 7102}
, 
[529] = {id = 529, item_reward = 2030, type = 7102}
, 
[530] = {id = 530, item_reward = 2031, type = 7102}
, 
[531] = {id = 531, item_reward = 2032, type = 7102}
, 
[532] = {id = 532, item_reward = 2033, type = 7102}
, 
[536] = {id = 536, item_reward = 2038, type = 7102}
, 
[537] = {id = 537, item_reward = 2040, type = 7102}
}
, 
[7103] = {
[513] = {id = 513, item_reward = 2004, type = 7103}
, 
[515] = {id = 515, item_reward = 2007, type = 7103}
, 
[516] = {id = 516, type = 7103}
, 
[518] = {id = 518, item_reward = 2012, type = 7103}
, 
[520] = {id = 520, item_reward = 2014, type = 7103}
, 
[524] = {id = 524, item_reward = 2020, type = 7103}
, 
[525] = {id = 525, item_reward = 2021, type = 7103}
, 
[526] = {id = 526, item_reward = 2023, type = 7103}
, 
[528] = {id = 528, item_reward = 2027, type = 7103}
, 
[533] = {id = 533, item_reward = 2034, type = 7103}
, 
[534] = {id = 534, item_reward = 2035, type = 7103}
, 
[535] = {id = 535, item_reward = 2036, type = 7103}
}
, 
[7201] = {
[299] = {id = 299, item_reward = 2060, type = 7201}
, 
[300] = {id = 300, item_reward = 2026, type = 7201}
, 
[301] = {id = 301, item_reward = 2025, type = 7201}
, 
[302] = {id = 302, item_reward = 2016, type = 7201}
, 
[303] = {id = 303, item_reward = 2018, type = 7201}
, 
[304] = {id = 304, item_reward = 2041, type = 7201}
, 
[305] = {id = 305, item_reward = 2042, type = 7201}
, 
[306] = {id = 306, item_reward = 2053, type = 7201}
}
, 
[7202] = {
[273] = {id = 273, item_reward = 2002, type = 7202}
, 
[275] = {id = 275, item_reward = 2006, type = 7202}
, 
[278] = {id = 278, item_reward = 2011, type = 7202}
, 
[280] = {id = 280, item_reward = 2013, type = 7202}
, 
[282] = {id = 282, item_reward = 2015, type = 7202}
, 
[283] = {id = 283, item_reward = 2017, type = 7202}
, 
[284] = {id = 284, item_reward = 2019, type = 7202}
, 
[288] = {id = 288, item_reward = 2024, type = 7202}
, 
[290] = {id = 290, item_reward = 2030, type = 7202}
, 
[291] = {id = 291, item_reward = 2031, type = 7202}
, 
[292] = {id = 292, item_reward = 2032, type = 7202}
, 
[293] = {id = 293, item_reward = 2033, type = 7202}
, 
[297] = {id = 297, item_reward = 2038, type = 7202}
, 
[298] = {id = 298, item_reward = 2040, type = 7202}
}
, 
[7203] = {
[274] = {id = 274, item_reward = 2004, type = 7203}
, 
[276] = {id = 276, item_reward = 2007, type = 7203}
, 
[277] = {id = 277, type = 7203}
, 
[279] = {id = 279, item_reward = 2012, type = 7203}
, 
[281] = {id = 281, item_reward = 2014, type = 7203}
, 
[285] = {id = 285, item_reward = 2020, type = 7203}
, 
[286] = {id = 286, item_reward = 2021, type = 7203}
, 
[287] = {id = 287, item_reward = 2023, type = 7203}
, 
[289] = {id = 289, item_reward = 2027, type = 7203}
, 
[294] = {id = 294, item_reward = 2034, type = 7203}
, 
[295] = {id = 295, item_reward = 2035, type = 7203}
, 
[296] = {id = 296, item_reward = 2036, type = 7203}
}
, 
[7301] = {
[1455] = {id = 1455, item_reward = 2016, type = 7301}
, 
[1456] = {id = 1456, item_reward = 2054, type = 7301}
, 
[1457] = {id = 1457, item_reward = 2044, type = 7301}
, 
[1458] = {id = 1458, item_reward = 2041, type = 7301}
, 
[1459] = {id = 1459, item_reward = 2026, type = 7301}
, 
[1460] = {id = 1460, item_reward = 2025, type = 7301}
, 
[1461] = {id = 1461, item_reward = 2028, type = 7301}
, 
[1462] = {id = 1462, item_reward = 2039, type = 7301}
}
, 
[7302] = {
[1429] = {id = 1429, item_reward = 2002, type = 7302}
, 
[1431] = {id = 1431, item_reward = 2006, type = 7302}
, 
[1434] = {id = 1434, item_reward = 2011, type = 7302}
, 
[1436] = {id = 1436, item_reward = 2013, type = 7302}
, 
[1438] = {id = 1438, item_reward = 2015, type = 7302}
, 
[1439] = {id = 1439, item_reward = 2017, type = 7302}
, 
[1440] = {id = 1440, item_reward = 2019, type = 7302}
, 
[1444] = {id = 1444, item_reward = 2024, type = 7302}
, 
[1446] = {id = 1446, item_reward = 2030, type = 7302}
, 
[1447] = {id = 1447, item_reward = 2031, type = 7302}
, 
[1448] = {id = 1448, item_reward = 2032, type = 7302}
, 
[1449] = {id = 1449, item_reward = 2033, type = 7302}
, 
[1453] = {id = 1453, item_reward = 2038, type = 7302}
, 
[1454] = {id = 1454, item_reward = 2040, type = 7302}
}
, 
[7303] = {
[1430] = {id = 1430, item_reward = 2004, type = 7303}
, 
[1432] = {id = 1432, item_reward = 2007, type = 7303}
, 
[1433] = {id = 1433, type = 7303}
, 
[1435] = {id = 1435, item_reward = 2012, type = 7303}
, 
[1437] = {id = 1437, item_reward = 2014, type = 7303}
, 
[1441] = {id = 1441, item_reward = 2020, type = 7303}
, 
[1442] = {id = 1442, item_reward = 2021, type = 7303}
, 
[1443] = {id = 1443, item_reward = 2023, type = 7303}
, 
[1445] = {id = 1445, item_reward = 2027, type = 7303}
, 
[1450] = {id = 1450, item_reward = 2034, type = 7303}
, 
[1451] = {id = 1451, item_reward = 2035, type = 7303}
, 
[1452] = {id = 1452, item_reward = 2036, type = 7303}
}
, 
[7401] = {
[1489] = {id = 1489, item_reward = 2037, type = 7401}
, 
[1490] = {id = 1490, item_reward = 2050, type = 7401}
, 
[1491] = {id = 1491, item_reward = 2054, type = 7401}
, 
[1492] = {id = 1492, item_reward = 2052, type = 7401}
, 
[1493] = {id = 1493, item_reward = 2010, type = 7401}
, 
[1494] = {id = 1494, item_reward = 2028, type = 7401}
, 
[1495] = {id = 1495, item_reward = 2026, type = 7401}
, 
[1496] = {id = 1496, item_reward = 2039, type = 7401}
}
, 
[7402] = {
[1463] = {id = 1463, item_reward = 2002, type = 7402}
, 
[1465] = {id = 1465, item_reward = 2006, type = 7402}
, 
[1468] = {id = 1468, item_reward = 2011, type = 7402}
, 
[1470] = {id = 1470, item_reward = 2013, type = 7402}
, 
[1472] = {id = 1472, item_reward = 2015, type = 7402}
, 
[1473] = {id = 1473, item_reward = 2017, type = 7402}
, 
[1474] = {id = 1474, item_reward = 2019, type = 7402}
, 
[1478] = {id = 1478, item_reward = 2024, type = 7402}
, 
[1480] = {id = 1480, item_reward = 2030, type = 7402}
, 
[1481] = {id = 1481, item_reward = 2031, type = 7402}
, 
[1482] = {id = 1482, item_reward = 2032, type = 7402}
, 
[1483] = {id = 1483, item_reward = 2033, type = 7402}
, 
[1487] = {id = 1487, item_reward = 2038, type = 7402}
, 
[1488] = {id = 1488, item_reward = 2040, type = 7402}
}
, 
[7403] = {
[1464] = {id = 1464, item_reward = 2004, type = 7403}
, 
[1466] = {id = 1466, item_reward = 2007, type = 7403}
, 
[1467] = {id = 1467, type = 7403}
, 
[1469] = {id = 1469, item_reward = 2012, type = 7403}
, 
[1471] = {id = 1471, item_reward = 2014, type = 7403}
, 
[1475] = {id = 1475, item_reward = 2020, type = 7403}
, 
[1476] = {id = 1476, item_reward = 2021, type = 7403}
, 
[1477] = {id = 1477, item_reward = 2023, type = 7403}
, 
[1479] = {id = 1479, item_reward = 2027, type = 7403}
, 
[1484] = {id = 1484, item_reward = 2034, type = 7403}
, 
[1485] = {id = 1485, item_reward = 2035, type = 7403}
, 
[1486] = {id = 1486, item_reward = 2036, type = 7403}
}
, 
[7501] = {
[578] = {id = 578, item_reward = 2061, type = 7501}
, 
[579] = {id = 579, item_reward = 2042, type = 7501}
, 
[580] = {id = 580, item_reward = 2050, type = 7501}
, 
[581] = {id = 581, item_reward = 2054, type = 7501}
, 
[582] = {id = 582, item_reward = 2055, type = 7501}
, 
[583] = {id = 583, item_reward = 2052, type = 7501}
, 
[584] = {id = 584, item_reward = 2037, type = 7501}
, 
[585] = {id = 585, item_reward = 2043, type = 7501}
, 
[586] = {id = 586, item_reward = 2010, type = 7501}
, 
[587] = {id = 587, item_reward = 2018, type = 7501}
, 
[588] = {id = 588, item_reward = 2025, type = 7501}
, 
[589] = {id = 589, item_reward = 2039, type = 7501}
, 
[590] = {id = 590, item_reward = 2026, type = 7501}
, 
[591] = {id = 591, item_reward = 2028, type = 7501}
}
, 
[7502] = {
[552] = {id = 552, item_reward = 2002, type = 7502}
, 
[554] = {id = 554, item_reward = 2006, type = 7502}
, 
[557] = {id = 557, item_reward = 2011, type = 7502}
, 
[559] = {id = 559, item_reward = 2013, type = 7502}
, 
[561] = {id = 561, item_reward = 2015, type = 7502}
, 
[562] = {id = 562, item_reward = 2017, type = 7502}
, 
[563] = {id = 563, item_reward = 2019, type = 7502}
, 
[567] = {id = 567, item_reward = 2024, type = 7502}
, 
[569] = {id = 569, item_reward = 2030, type = 7502}
, 
[570] = {id = 570, item_reward = 2031, type = 7502}
, 
[571] = {id = 571, item_reward = 2032, type = 7502}
, 
[572] = {id = 572, item_reward = 2033, type = 7502}
, 
[576] = {id = 576, item_reward = 2038, type = 7502}
, 
[577] = {id = 577, item_reward = 2040, type = 7502}
}
, 
[7503] = {
[553] = {id = 553, item_reward = 2004, type = 7503}
, 
[555] = {id = 555, item_reward = 2007, type = 7503}
, 
[556] = {id = 556, type = 7503}
, 
[558] = {id = 558, item_reward = 2012, type = 7503}
, 
[560] = {id = 560, item_reward = 2014, type = 7503}
, 
[564] = {id = 564, item_reward = 2020, type = 7503}
, 
[565] = {id = 565, item_reward = 2021, type = 7503}
, 
[566] = {id = 566, item_reward = 2023, type = 7503}
, 
[568] = {id = 568, item_reward = 2027, type = 7503}
, 
[573] = {id = 573, item_reward = 2034, type = 7503}
, 
[574] = {id = 574, item_reward = 2035, type = 7503}
, 
[575] = {id = 575, item_reward = 2036, type = 7503}
}
, 
[7601] = {
[1523] = {id = 1523, item_reward = 2061, type = 7601}
, 
[1524] = {id = 1524, item_reward = 2042, type = 7601}
, 
[1525] = {id = 1525, item_reward = 2050, type = 7601}
, 
[1526] = {id = 1526, item_reward = 2055, type = 7601}
, 
[1527] = {id = 1527, item_reward = 2010, type = 7601}
, 
[1528] = {id = 1528, item_reward = 2025, type = 7601}
, 
[1529] = {id = 1529, item_reward = 2039, type = 7601}
, 
[1530] = {id = 1530, item_reward = 2018, type = 7601}
}
, 
[7602] = {
[1497] = {id = 1497, item_reward = 2002, type = 7602}
, 
[1499] = {id = 1499, item_reward = 2006, type = 7602}
, 
[1502] = {id = 1502, item_reward = 2011, type = 7602}
, 
[1504] = {id = 1504, item_reward = 2013, type = 7602}
, 
[1506] = {id = 1506, item_reward = 2015, type = 7602}
, 
[1507] = {id = 1507, item_reward = 2017, type = 7602}
, 
[1508] = {id = 1508, item_reward = 2019, type = 7602}
, 
[1512] = {id = 1512, item_reward = 2024, type = 7602}
, 
[1514] = {id = 1514, item_reward = 2030, type = 7602}
, 
[1515] = {id = 1515, item_reward = 2031, type = 7602}
, 
[1516] = {id = 1516, item_reward = 2032, type = 7602}
, 
[1517] = {id = 1517, item_reward = 2033, type = 7602}
, 
[1521] = {id = 1521, item_reward = 2038, type = 7602}
, 
[1522] = {id = 1522, item_reward = 2040, type = 7602}
}
, 
[7603] = {
[1498] = {id = 1498, item_reward = 2004, type = 7603}
, 
[1500] = {id = 1500, item_reward = 2007, type = 7603}
, 
[1501] = {id = 1501, type = 7603}
, 
[1503] = {id = 1503, item_reward = 2012, type = 7603}
, 
[1505] = {id = 1505, item_reward = 2014, type = 7603}
, 
[1509] = {id = 1509, item_reward = 2020, type = 7603}
, 
[1510] = {id = 1510, item_reward = 2021, type = 7603}
, 
[1511] = {id = 1511, item_reward = 2023, type = 7603}
, 
[1513] = {id = 1513, item_reward = 2027, type = 7603}
, 
[1518] = {id = 1518, item_reward = 2034, type = 7603}
, 
[1519] = {id = 1519, item_reward = 2035, type = 7603}
, 
[1520] = {id = 1520, item_reward = 2036, type = 7603}
}
, 
[7701] = {
[1557] = {id = 1557, item_reward = 2057, type = 7701}
, 
[1558] = {id = 1558, item_reward = 2048, type = 7701}
, 
[1559] = {id = 1559, item_reward = 2042, type = 7701}
, 
[1560] = {id = 1560, item_reward = 2052, type = 7701}
, 
[1561] = {id = 1561, item_reward = 2050, type = 7701}
, 
[1562] = {id = 1562, item_reward = 2010, type = 7701}
, 
[1563] = {id = 1563, item_reward = 2026, type = 7701}
, 
[1564] = {id = 1564, item_reward = 2025, type = 7701}
}
, 
[7702] = {
[1531] = {id = 1531, item_reward = 2002, type = 7702}
, 
[1533] = {id = 1533, item_reward = 2006, type = 7702}
, 
[1536] = {id = 1536, item_reward = 2011, type = 7702}
, 
[1538] = {id = 1538, item_reward = 2013, type = 7702}
, 
[1540] = {id = 1540, item_reward = 2015, type = 7702}
, 
[1541] = {id = 1541, item_reward = 2017, type = 7702}
, 
[1542] = {id = 1542, item_reward = 2019, type = 7702}
, 
[1546] = {id = 1546, item_reward = 2024, type = 7702}
, 
[1548] = {id = 1548, item_reward = 2030, type = 7702}
, 
[1549] = {id = 1549, item_reward = 2031, type = 7702}
, 
[1550] = {id = 1550, item_reward = 2032, type = 7702}
, 
[1551] = {id = 1551, item_reward = 2033, type = 7702}
, 
[1555] = {id = 1555, item_reward = 2038, type = 7702}
, 
[1556] = {id = 1556, item_reward = 2040, type = 7702}
}
, 
[7703] = {
[1532] = {id = 1532, item_reward = 2004, type = 7703}
, 
[1534] = {id = 1534, item_reward = 2007, type = 7703}
, 
[1535] = {id = 1535, type = 7703}
, 
[1537] = {id = 1537, item_reward = 2012, type = 7703}
, 
[1539] = {id = 1539, item_reward = 2014, type = 7703}
, 
[1543] = {id = 1543, item_reward = 2020, type = 7703}
, 
[1544] = {id = 1544, item_reward = 2021, type = 7703}
, 
[1545] = {id = 1545, item_reward = 2023, type = 7703}
, 
[1547] = {id = 1547, item_reward = 2027, type = 7703}
, 
[1552] = {id = 1552, item_reward = 2034, type = 7703}
, 
[1553] = {id = 1553, item_reward = 2035, type = 7703}
, 
[1554] = {id = 1554, item_reward = 2036, type = 7703}
}
, 
[7801] = {
[1591] = {id = 1591, item_reward = 2044, type = 7801}
, 
[1592] = {id = 1592, item_reward = 2054, type = 7801}
, 
[1593] = {id = 1593, item_reward = 2055, type = 7801}
, 
[1594] = {id = 1594, item_reward = 2049, type = 7801}
, 
[1595] = {id = 1595, item_reward = 2046, type = 7801}
, 
[1596] = {id = 1596, item_reward = 2026, type = 7801}
, 
[1597] = {id = 1597, item_reward = 2025, type = 7801}
, 
[1598] = {id = 1598, item_reward = 2028, type = 7801}
}
, 
[7802] = {
[1565] = {id = 1565, item_reward = 2002, type = 7802}
, 
[1567] = {id = 1567, item_reward = 2006, type = 7802}
, 
[1570] = {id = 1570, item_reward = 2011, type = 7802}
, 
[1572] = {id = 1572, item_reward = 2013, type = 7802}
, 
[1574] = {id = 1574, item_reward = 2015, type = 7802}
, 
[1575] = {id = 1575, item_reward = 2017, type = 7802}
, 
[1576] = {id = 1576, item_reward = 2019, type = 7802}
, 
[1580] = {id = 1580, item_reward = 2024, type = 7802}
, 
[1582] = {id = 1582, item_reward = 2030, type = 7802}
, 
[1583] = {id = 1583, item_reward = 2031, type = 7802}
, 
[1584] = {id = 1584, item_reward = 2032, type = 7802}
, 
[1585] = {id = 1585, item_reward = 2033, type = 7802}
, 
[1589] = {id = 1589, item_reward = 2038, type = 7802}
, 
[1590] = {id = 1590, item_reward = 2040, type = 7802}
}
, 
[7803] = {
[1566] = {id = 1566, item_reward = 2004, type = 7803}
, 
[1568] = {id = 1568, item_reward = 2007, type = 7803}
, 
[1569] = {id = 1569, type = 7803}
, 
[1571] = {id = 1571, item_reward = 2012, type = 7803}
, 
[1573] = {id = 1573, item_reward = 2014, type = 7803}
, 
[1577] = {id = 1577, item_reward = 2020, type = 7803}
, 
[1578] = {id = 1578, item_reward = 2021, type = 7803}
, 
[1579] = {id = 1579, item_reward = 2023, type = 7803}
, 
[1581] = {id = 1581, item_reward = 2027, type = 7803}
, 
[1586] = {id = 1586, item_reward = 2034, type = 7803}
, 
[1587] = {id = 1587, item_reward = 2035, type = 7803}
, 
[1588] = {id = 1588, item_reward = 2036, type = 7803}
}
, 
[7901] = {
[618] = {id = 618, item_reward = 2062, type = 7901}
, 
[619] = {id = 619, item_reward = 2046, type = 7901}
, 
[620] = {id = 620, item_reward = 2044, type = 7901}
, 
[621] = {id = 621, item_reward = 2052, type = 7901}
, 
[622] = {id = 622, item_reward = 2054, type = 7901}
, 
[623] = {id = 623, item_reward = 2039, type = 7901}
, 
[624] = {id = 624, item_reward = 2045, type = 7901}
, 
[625] = {id = 625, item_reward = 2026, type = 7901}
, 
[626] = {id = 626, item_reward = 2018, type = 7901}
, 
[627] = {id = 627, item_reward = 2022, type = 7901}
, 
[628] = {id = 628, item_reward = 2008, type = 7901}
, 
[629] = {id = 629, item_reward = 2025, type = 7901}
, 
[630] = {id = 630, item_reward = 2028, type = 7901}
, 
[631] = {id = 631, item_reward = 2016, type = 7901}
}
, 
[7902] = {
[592] = {id = 592, item_reward = 2002, type = 7902}
, 
[594] = {id = 594, item_reward = 2006, type = 7902}
, 
[597] = {id = 597, item_reward = 2011, type = 7902}
, 
[599] = {id = 599, item_reward = 2013, type = 7902}
, 
[601] = {id = 601, item_reward = 2015, type = 7902}
, 
[602] = {id = 602, item_reward = 2017, type = 7902}
, 
[603] = {id = 603, item_reward = 2019, type = 7902}
, 
[607] = {id = 607, item_reward = 2024, type = 7902}
, 
[609] = {id = 609, item_reward = 2030, type = 7902}
, 
[610] = {id = 610, item_reward = 2031, type = 7902}
, 
[611] = {id = 611, item_reward = 2032, type = 7902}
, 
[612] = {id = 612, item_reward = 2033, type = 7902}
, 
[616] = {id = 616, item_reward = 2038, type = 7902}
, 
[617] = {id = 617, item_reward = 2040, type = 7902}
}
, 
[7903] = {
[593] = {id = 593, item_reward = 2004, type = 7903}
, 
[595] = {id = 595, item_reward = 2007, type = 7903}
, 
[596] = {id = 596, type = 7903}
, 
[598] = {id = 598, item_reward = 2012, type = 7903}
, 
[600] = {id = 600, item_reward = 2014, type = 7903}
, 
[604] = {id = 604, item_reward = 2020, type = 7903}
, 
[605] = {id = 605, item_reward = 2021, type = 7903}
, 
[606] = {id = 606, item_reward = 2023, type = 7903}
, 
[608] = {id = 608, item_reward = 2027, type = 7903}
, 
[613] = {id = 613, item_reward = 2034, type = 7903}
, 
[614] = {id = 614, item_reward = 2035, type = 7903}
, 
[615] = {id = 615, item_reward = 2036, type = 7903}
}
, 
[8001] = {
[1625] = {id = 1625, item_reward = 2062, type = 8001}
, 
[1626] = {id = 1626, item_reward = 2050, type = 8001}
, 
[1627] = {id = 1627, item_reward = 2046, type = 8001}
, 
[1628] = {id = 1628, item_reward = 2053, type = 8001}
, 
[1629] = {id = 1629, item_reward = 2055, type = 8001}
, 
[1630] = {id = 1630, item_reward = 2018, type = 8001}
, 
[1631] = {id = 1631, item_reward = 2039, type = 8001}
, 
[1632] = {id = 1632, item_reward = 2016, type = 8001}
}
, 
[8002] = {
[1599] = {id = 1599, item_reward = 2002, type = 8002}
, 
[1601] = {id = 1601, item_reward = 2006, type = 8002}
, 
[1604] = {id = 1604, item_reward = 2011, type = 8002}
, 
[1606] = {id = 1606, item_reward = 2013, type = 8002}
, 
[1608] = {id = 1608, item_reward = 2015, type = 8002}
, 
[1609] = {id = 1609, item_reward = 2017, type = 8002}
, 
[1610] = {id = 1610, item_reward = 2019, type = 8002}
, 
[1614] = {id = 1614, item_reward = 2024, type = 8002}
, 
[1616] = {id = 1616, item_reward = 2030, type = 8002}
, 
[1617] = {id = 1617, item_reward = 2031, type = 8002}
, 
[1618] = {id = 1618, item_reward = 2032, type = 8002}
, 
[1619] = {id = 1619, item_reward = 2033, type = 8002}
, 
[1623] = {id = 1623, item_reward = 2038, type = 8002}
, 
[1624] = {id = 1624, item_reward = 2040, type = 8002}
}
, 
[8003] = {
[1600] = {id = 1600, item_reward = 2004, type = 8003}
, 
[1602] = {id = 1602, item_reward = 2007, type = 8003}
, 
[1603] = {id = 1603, type = 8003}
, 
[1605] = {id = 1605, item_reward = 2012, type = 8003}
, 
[1607] = {id = 1607, item_reward = 2014, type = 8003}
, 
[1611] = {id = 1611, item_reward = 2020, type = 8003}
, 
[1612] = {id = 1612, item_reward = 2021, type = 8003}
, 
[1613] = {id = 1613, item_reward = 2023, type = 8003}
, 
[1615] = {id = 1615, item_reward = 2027, type = 8003}
, 
[1620] = {id = 1620, item_reward = 2034, type = 8003}
, 
[1621] = {id = 1621, item_reward = 2035, type = 8003}
, 
[1622] = {id = 1622, item_reward = 2036, type = 8003}
}
, 
[8101] = {
[1659] = {id = 1659, item_reward = 2051, type = 8101}
, 
[1660] = {id = 1660, item_reward = 2053, type = 8101}
, 
[1661] = {id = 1661, item_reward = 2052, type = 8101}
, 
[1662] = {id = 1662, item_reward = 2048, type = 8101}
, 
[1663] = {id = 1663, item_reward = 2018, type = 8101}
, 
[1664] = {id = 1664, item_reward = 2039, type = 8101}
, 
[1665] = {id = 1665, item_reward = 2037, type = 8101}
, 
[1666] = {id = 1666, item_reward = 2010, type = 8101}
}
, 
[8102] = {
[1633] = {id = 1633, item_reward = 2002, type = 8102}
, 
[1635] = {id = 1635, item_reward = 2006, type = 8102}
, 
[1638] = {id = 1638, item_reward = 2011, type = 8102}
, 
[1640] = {id = 1640, item_reward = 2013, type = 8102}
, 
[1642] = {id = 1642, item_reward = 2015, type = 8102}
, 
[1643] = {id = 1643, item_reward = 2017, type = 8102}
, 
[1644] = {id = 1644, item_reward = 2019, type = 8102}
, 
[1648] = {id = 1648, item_reward = 2024, type = 8102}
, 
[1650] = {id = 1650, item_reward = 2030, type = 8102}
, 
[1651] = {id = 1651, item_reward = 2031, type = 8102}
, 
[1652] = {id = 1652, item_reward = 2032, type = 8102}
, 
[1653] = {id = 1653, item_reward = 2033, type = 8102}
, 
[1657] = {id = 1657, item_reward = 2038, type = 8102}
, 
[1658] = {id = 1658, item_reward = 2040, type = 8102}
}
, 
[8103] = {
[1634] = {id = 1634, item_reward = 2004, type = 8103}
, 
[1636] = {id = 1636, item_reward = 2007, type = 8103}
, 
[1637] = {id = 1637, type = 8103}
, 
[1639] = {id = 1639, item_reward = 2012, type = 8103}
, 
[1641] = {id = 1641, item_reward = 2014, type = 8103}
, 
[1645] = {id = 1645, item_reward = 2020, type = 8103}
, 
[1646] = {id = 1646, item_reward = 2021, type = 8103}
, 
[1647] = {id = 1647, item_reward = 2023, type = 8103}
, 
[1649] = {id = 1649, item_reward = 2027, type = 8103}
, 
[1654] = {id = 1654, item_reward = 2034, type = 8103}
, 
[1655] = {id = 1655, item_reward = 2035, type = 8103}
, 
[1656] = {id = 1656, item_reward = 2036, type = 8103}
}
, 
[8201] = {
[1693] = {id = 1693, item_reward = 2055, type = 8201}
, 
[1694] = {id = 1694, item_reward = 2057, type = 8201}
, 
[1695] = {id = 1695, item_reward = 2048, type = 8201}
, 
[1696] = {id = 1696, item_reward = 2054, type = 8201}
, 
[1697] = {id = 1697, item_reward = 2018, type = 8201}
, 
[1698] = {id = 1698, item_reward = 2037, type = 8201}
, 
[1699] = {id = 1699, item_reward = 2039, type = 8201}
, 
[1700] = {id = 1700, item_reward = 2016, type = 8201}
}
, 
[8202] = {
[1667] = {id = 1667, item_reward = 2002, type = 8202}
, 
[1669] = {id = 1669, item_reward = 2006, type = 8202}
, 
[1672] = {id = 1672, item_reward = 2011, type = 8202}
, 
[1674] = {id = 1674, item_reward = 2013, type = 8202}
, 
[1676] = {id = 1676, item_reward = 2015, type = 8202}
, 
[1677] = {id = 1677, item_reward = 2017, type = 8202}
, 
[1678] = {id = 1678, item_reward = 2019, type = 8202}
, 
[1682] = {id = 1682, item_reward = 2024, type = 8202}
, 
[1684] = {id = 1684, item_reward = 2030, type = 8202}
, 
[1685] = {id = 1685, item_reward = 2031, type = 8202}
, 
[1686] = {id = 1686, item_reward = 2032, type = 8202}
, 
[1687] = {id = 1687, item_reward = 2033, type = 8202}
, 
[1691] = {id = 1691, item_reward = 2038, type = 8202}
, 
[1692] = {id = 1692, item_reward = 2040, type = 8202}
}
, 
[8203] = {
[1668] = {id = 1668, item_reward = 2004, type = 8203}
, 
[1670] = {id = 1670, item_reward = 2007, type = 8203}
, 
[1671] = {id = 1671, type = 8203}
, 
[1673] = {id = 1673, item_reward = 2012, type = 8203}
, 
[1675] = {id = 1675, item_reward = 2014, type = 8203}
, 
[1679] = {id = 1679, item_reward = 2020, type = 8203}
, 
[1680] = {id = 1680, item_reward = 2021, type = 8203}
, 
[1681] = {id = 1681, item_reward = 2023, type = 8203}
, 
[1683] = {id = 1683, item_reward = 2027, type = 8203}
, 
[1688] = {id = 1688, item_reward = 2034, type = 8203}
, 
[1689] = {id = 1689, item_reward = 2035, type = 8203}
, 
[1690] = {id = 1690, item_reward = 2036, type = 8203}
}
, 
[8301] = {
[658] = {id = 658, item_reward = 2063, type = 8301}
, 
[659] = {id = 659, item_reward = 2055, type = 8301}
, 
[660] = {id = 660, item_reward = 2057, type = 8301}
, 
[661] = {id = 661, item_reward = 2049, type = 8301}
, 
[662] = {id = 662, item_reward = 2048, type = 8301}
, 
[663] = {id = 663, item_reward = 2041, type = 8301}
, 
[664] = {id = 664, item_reward = 2054, type = 8301}
, 
[665] = {id = 665, item_reward = 2053, type = 8301}
, 
[666] = {id = 666, item_reward = 2052, type = 8301}
, 
[667] = {id = 667, item_reward = 2045, type = 8301}
, 
[668] = {id = 668, item_reward = 2022, type = 8301}
, 
[669] = {id = 669, item_reward = 2008, type = 8301}
, 
[670] = {id = 670, item_reward = 2039, type = 8301}
, 
[671] = {id = 671, item_reward = 2025, type = 8301}
}
, 
[8302] = {
[632] = {id = 632, item_reward = 2002, type = 8302}
, 
[634] = {id = 634, item_reward = 2006, type = 8302}
, 
[637] = {id = 637, item_reward = 2011, type = 8302}
, 
[639] = {id = 639, item_reward = 2013, type = 8302}
, 
[641] = {id = 641, item_reward = 2015, type = 8302}
, 
[642] = {id = 642, item_reward = 2017, type = 8302}
, 
[643] = {id = 643, item_reward = 2019, type = 8302}
, 
[647] = {id = 647, item_reward = 2024, type = 8302}
, 
[649] = {id = 649, item_reward = 2030, type = 8302}
, 
[650] = {id = 650, item_reward = 2031, type = 8302}
, 
[651] = {id = 651, item_reward = 2032, type = 8302}
, 
[652] = {id = 652, item_reward = 2033, type = 8302}
, 
[656] = {id = 656, item_reward = 2038, type = 8302}
, 
[657] = {id = 657, item_reward = 2040, type = 8302}
}
, 
[8303] = {
[633] = {id = 633, item_reward = 2004, type = 8303}
, 
[635] = {id = 635, item_reward = 2007, type = 8303}
, 
[636] = {id = 636, type = 8303}
, 
[638] = {id = 638, item_reward = 2012, type = 8303}
, 
[640] = {id = 640, item_reward = 2014, type = 8303}
, 
[644] = {id = 644, item_reward = 2020, type = 8303}
, 
[645] = {id = 645, item_reward = 2021, type = 8303}
, 
[646] = {id = 646, item_reward = 2023, type = 8303}
, 
[648] = {id = 648, item_reward = 2027, type = 8303}
, 
[653] = {id = 653, item_reward = 2034, type = 8303}
, 
[654] = {id = 654, item_reward = 2035, type = 8303}
, 
[655] = {id = 655, item_reward = 2036, type = 8303}
}
, 
[8401] = {
[1727] = {id = 1727, item_reward = 2063, type = 8401}
, 
[1728] = {id = 1728, item_reward = 2041, type = 8401}
, 
[1729] = {id = 1729, item_reward = 2049, type = 8401}
, 
[1730] = {id = 1730, item_reward = 2054, type = 8401}
, 
[1731] = {id = 1731, item_reward = 2010, type = 8401}
, 
[1732] = {id = 1732, item_reward = 2025, type = 8401}
, 
[1733] = {id = 1733, item_reward = 2026, type = 8401}
, 
[1734] = {id = 1734, item_reward = 2028, type = 8401}
}
, 
[8402] = {
[1701] = {id = 1701, item_reward = 2002, type = 8402}
, 
[1703] = {id = 1703, item_reward = 2006, type = 8402}
, 
[1706] = {id = 1706, item_reward = 2011, type = 8402}
, 
[1708] = {id = 1708, item_reward = 2013, type = 8402}
, 
[1710] = {id = 1710, item_reward = 2015, type = 8402}
, 
[1711] = {id = 1711, item_reward = 2017, type = 8402}
, 
[1712] = {id = 1712, item_reward = 2019, type = 8402}
, 
[1716] = {id = 1716, item_reward = 2024, type = 8402}
, 
[1718] = {id = 1718, item_reward = 2030, type = 8402}
, 
[1719] = {id = 1719, item_reward = 2031, type = 8402}
, 
[1720] = {id = 1720, item_reward = 2032, type = 8402}
, 
[1721] = {id = 1721, item_reward = 2033, type = 8402}
, 
[1725] = {id = 1725, item_reward = 2038, type = 8402}
, 
[1726] = {id = 1726, item_reward = 2040, type = 8402}
}
, 
[8403] = {
[1702] = {id = 1702, item_reward = 2004, type = 8403}
, 
[1704] = {id = 1704, item_reward = 2007, type = 8403}
, 
[1705] = {id = 1705, type = 8403}
, 
[1707] = {id = 1707, item_reward = 2012, type = 8403}
, 
[1709] = {id = 1709, item_reward = 2014, type = 8403}
, 
[1713] = {id = 1713, item_reward = 2020, type = 8403}
, 
[1714] = {id = 1714, item_reward = 2021, type = 8403}
, 
[1715] = {id = 1715, item_reward = 2023, type = 8403}
, 
[1717] = {id = 1717, item_reward = 2027, type = 8403}
, 
[1722] = {id = 1722, item_reward = 2034, type = 8403}
, 
[1723] = {id = 1723, item_reward = 2035, type = 8403}
, 
[1724] = {id = 1724, item_reward = 2036, type = 8403}
}
, 
[8501] = {
[1761] = {id = 1761, item_reward = 2046, type = 8501}
, 
[1762] = {id = 1762, item_reward = 2044, type = 8501}
, 
[1763] = {id = 1763, item_reward = 2041, type = 8501}
, 
[1764] = {id = 1764, item_reward = 2049, type = 8501}
, 
[1765] = {id = 1765, item_reward = 2037, type = 8501}
, 
[1766] = {id = 1766, item_reward = 2028, type = 8501}
, 
[1767] = {id = 1767, item_reward = 2026, type = 8501}
, 
[1768] = {id = 1768, item_reward = 2016, type = 8501}
}
, 
[8502] = {
[1735] = {id = 1735, item_reward = 2002, type = 8502}
, 
[1737] = {id = 1737, item_reward = 2006, type = 8502}
, 
[1740] = {id = 1740, item_reward = 2011, type = 8502}
, 
[1742] = {id = 1742, item_reward = 2013, type = 8502}
, 
[1744] = {id = 1744, item_reward = 2015, type = 8502}
, 
[1745] = {id = 1745, item_reward = 2017, type = 8502}
, 
[1746] = {id = 1746, item_reward = 2019, type = 8502}
, 
[1750] = {id = 1750, item_reward = 2024, type = 8502}
, 
[1752] = {id = 1752, item_reward = 2030, type = 8502}
, 
[1753] = {id = 1753, item_reward = 2031, type = 8502}
, 
[1754] = {id = 1754, item_reward = 2032, type = 8502}
, 
[1755] = {id = 1755, item_reward = 2033, type = 8502}
, 
[1759] = {id = 1759, item_reward = 2038, type = 8502}
, 
[1760] = {id = 1760, item_reward = 2040, type = 8502}
}
, 
[8503] = {
[1736] = {id = 1736, item_reward = 2004, type = 8503}
, 
[1738] = {id = 1738, item_reward = 2007, type = 8503}
, 
[1739] = {id = 1739, type = 8503}
, 
[1741] = {id = 1741, item_reward = 2012, type = 8503}
, 
[1743] = {id = 1743, item_reward = 2014, type = 8503}
, 
[1747] = {id = 1747, item_reward = 2020, type = 8503}
, 
[1748] = {id = 1748, item_reward = 2021, type = 8503}
, 
[1749] = {id = 1749, item_reward = 2023, type = 8503}
, 
[1751] = {id = 1751, item_reward = 2027, type = 8503}
, 
[1756] = {id = 1756, item_reward = 2034, type = 8503}
, 
[1757] = {id = 1757, item_reward = 2035, type = 8503}
, 
[1758] = {id = 1758, item_reward = 2036, type = 8503}
}
, 
[8601] = {
[1795] = {id = 1795, item_reward = 2065, type = 8601}
, 
[1796] = {id = 1796, item_reward = 2059, type = 8601}
, 
[1797] = {id = 1797, item_reward = 2053, type = 8601}
, 
[1798] = {id = 1798, item_reward = 2052, type = 8601}
, 
[1799] = {id = 1799, item_reward = 2039, type = 8601}
, 
[1800] = {id = 1800, item_reward = 2010, type = 8601}
, 
[1801] = {id = 1801, item_reward = 2026, type = 8601}
, 
[1802] = {id = 1802, item_reward = 2016, type = 8601}
}
, 
[8602] = {
[1769] = {id = 1769, item_reward = 2002, type = 8602}
, 
[1771] = {id = 1771, item_reward = 2006, type = 8602}
, 
[1774] = {id = 1774, item_reward = 2011, type = 8602}
, 
[1776] = {id = 1776, item_reward = 2013, type = 8602}
, 
[1778] = {id = 1778, item_reward = 2015, type = 8602}
, 
[1779] = {id = 1779, item_reward = 2017, type = 8602}
, 
[1780] = {id = 1780, item_reward = 2019, type = 8602}
, 
[1784] = {id = 1784, item_reward = 2024, type = 8602}
, 
[1786] = {id = 1786, item_reward = 2030, type = 8602}
, 
[1787] = {id = 1787, item_reward = 2031, type = 8602}
, 
[1788] = {id = 1788, item_reward = 2032, type = 8602}
, 
[1789] = {id = 1789, item_reward = 2033, type = 8602}
, 
[1793] = {id = 1793, item_reward = 2038, type = 8602}
, 
[1794] = {id = 1794, item_reward = 2040, type = 8602}
}
, 
[8603] = {
[1770] = {id = 1770, item_reward = 2004, type = 8603}
, 
[1772] = {id = 1772, item_reward = 2007, type = 8603}
, 
[1773] = {id = 1773, type = 8603}
, 
[1775] = {id = 1775, item_reward = 2012, type = 8603}
, 
[1777] = {id = 1777, item_reward = 2014, type = 8603}
, 
[1781] = {id = 1781, item_reward = 2020, type = 8603}
, 
[1782] = {id = 1782, item_reward = 2021, type = 8603}
, 
[1783] = {id = 1783, item_reward = 2023, type = 8603}
, 
[1785] = {id = 1785, item_reward = 2027, type = 8603}
, 
[1790] = {id = 1790, item_reward = 2034, type = 8603}
, 
[1791] = {id = 1791, item_reward = 2035, type = 8603}
, 
[1792] = {id = 1792, item_reward = 2036, type = 8603}
}
, 
[8701] = {
[1829] = {id = 1829, item_reward = 2065, type = 8701}
, 
[1830] = {id = 1830, item_reward = 2059, type = 8701}
, 
[1831] = {id = 1831, item_reward = 2053, type = 8701}
, 
[1832] = {id = 1832, item_reward = 2052, type = 8701}
, 
[1833] = {id = 1833, item_reward = 2039, type = 8701}
, 
[1834] = {id = 1834, item_reward = 2010, type = 8701}
, 
[1835] = {id = 1835, item_reward = 2026, type = 8701}
, 
[1836] = {id = 1836, item_reward = 2016, type = 8701}
}
, 
[8702] = {
[1803] = {id = 1803, item_reward = 2002, type = 8702}
, 
[1805] = {id = 1805, item_reward = 2006, type = 8702}
, 
[1808] = {id = 1808, item_reward = 2011, type = 8702}
, 
[1810] = {id = 1810, item_reward = 2013, type = 8702}
, 
[1812] = {id = 1812, item_reward = 2015, type = 8702}
, 
[1813] = {id = 1813, item_reward = 2017, type = 8702}
, 
[1814] = {id = 1814, item_reward = 2019, type = 8702}
, 
[1818] = {id = 1818, item_reward = 2024, type = 8702}
, 
[1820] = {id = 1820, item_reward = 2030, type = 8702}
, 
[1821] = {id = 1821, item_reward = 2031, type = 8702}
, 
[1822] = {id = 1822, item_reward = 2032, type = 8702}
, 
[1823] = {id = 1823, item_reward = 2033, type = 8702}
, 
[1827] = {id = 1827, item_reward = 2038, type = 8702}
, 
[1828] = {id = 1828, item_reward = 2040, type = 8702}
}
, 
[8703] = {
[1804] = {id = 1804, item_reward = 2004, type = 8703}
, 
[1806] = {id = 1806, item_reward = 2007, type = 8703}
, 
[1807] = {id = 1807, type = 8703}
, 
[1809] = {id = 1809, item_reward = 2012, type = 8703}
, 
[1811] = {id = 1811, item_reward = 2014, type = 8703}
, 
[1815] = {id = 1815, item_reward = 2020, type = 8703}
, 
[1816] = {id = 1816, item_reward = 2021, type = 8703}
, 
[1817] = {id = 1817, item_reward = 2023, type = 8703}
, 
[1819] = {id = 1819, item_reward = 2027, type = 8703}
, 
[1824] = {id = 1824, item_reward = 2034, type = 8703}
, 
[1825] = {id = 1825, item_reward = 2035, type = 8703}
, 
[1826] = {id = 1826, item_reward = 2036, type = 8703}
}
, 
[8801] = {
[1863] = {id = 1863, item_reward = 2049, type = 8801}
, 
[1864] = {id = 1864, item_reward = 2044, type = 8801}
, 
[1865] = {id = 1865, item_reward = 2052, type = 8801}
, 
[1866] = {id = 1866, item_reward = 2055, type = 8801}
, 
[1867] = {id = 1867, item_reward = 2018, type = 8801}
, 
[1868] = {id = 1868, item_reward = 2025, type = 8801}
, 
[1869] = {id = 1869, item_reward = 2039, type = 8801}
, 
[1870] = {id = 1870, item_reward = 2010, type = 8801}
}
, 
[8802] = {
[1837] = {id = 1837, item_reward = 2002, type = 8802}
, 
[1839] = {id = 1839, item_reward = 2006, type = 8802}
, 
[1842] = {id = 1842, item_reward = 2011, type = 8802}
, 
[1844] = {id = 1844, item_reward = 2013, type = 8802}
, 
[1846] = {id = 1846, item_reward = 2015, type = 8802}
, 
[1847] = {id = 1847, item_reward = 2017, type = 8802}
, 
[1848] = {id = 1848, item_reward = 2019, type = 8802}
, 
[1852] = {id = 1852, item_reward = 2024, type = 8802}
, 
[1854] = {id = 1854, item_reward = 2030, type = 8802}
, 
[1855] = {id = 1855, item_reward = 2031, type = 8802}
, 
[1856] = {id = 1856, item_reward = 2032, type = 8802}
, 
[1857] = {id = 1857, item_reward = 2033, type = 8802}
, 
[1861] = {id = 1861, item_reward = 2038, type = 8802}
, 
[1862] = {id = 1862, item_reward = 2040, type = 8802}
}
, 
[8803] = {
[1838] = {id = 1838, item_reward = 2004, type = 8803}
, 
[1840] = {id = 1840, item_reward = 2007, type = 8803}
, 
[1841] = {id = 1841, type = 8803}
, 
[1843] = {id = 1843, item_reward = 2012, type = 8803}
, 
[1845] = {id = 1845, item_reward = 2014, type = 8803}
, 
[1849] = {id = 1849, item_reward = 2020, type = 8803}
, 
[1850] = {id = 1850, item_reward = 2021, type = 8803}
, 
[1851] = {id = 1851, item_reward = 2023, type = 8803}
, 
[1853] = {id = 1853, item_reward = 2027, type = 8803}
, 
[1858] = {id = 1858, item_reward = 2034, type = 8803}
, 
[1859] = {id = 1859, item_reward = 2035, type = 8803}
, 
[1860] = {id = 1860, item_reward = 2036, type = 8803}
}
, 
[8901] = {
[1897] = {id = 1897, item_reward = 2053, type = 8901}
, 
[1898] = {id = 1898, item_reward = 2052, type = 8901}
, 
[1899] = {id = 1899, item_reward = 2055, type = 8901}
, 
[1900] = {id = 1900, item_reward = 2025, type = 8901}
, 
[1901] = {id = 1901, item_reward = 2039, type = 8901}
, 
[1902] = {id = 1902, item_reward = 2010, type = 8901}
, 
[1903] = {id = 1903, item_reward = 2026, type = 8901}
, 
[1904] = {id = 1904, item_reward = 2016, type = 8901}
}
, 
[8902] = {
[1871] = {id = 1871, item_reward = 2002, type = 8902}
, 
[1873] = {id = 1873, item_reward = 2006, type = 8902}
, 
[1876] = {id = 1876, item_reward = 2011, type = 8902}
, 
[1878] = {id = 1878, item_reward = 2013, type = 8902}
, 
[1880] = {id = 1880, item_reward = 2015, type = 8902}
, 
[1881] = {id = 1881, item_reward = 2017, type = 8902}
, 
[1882] = {id = 1882, item_reward = 2019, type = 8902}
, 
[1886] = {id = 1886, item_reward = 2024, type = 8902}
, 
[1888] = {id = 1888, item_reward = 2030, type = 8902}
, 
[1889] = {id = 1889, item_reward = 2031, type = 8902}
, 
[1890] = {id = 1890, item_reward = 2032, type = 8902}
, 
[1891] = {id = 1891, item_reward = 2033, type = 8902}
, 
[1895] = {id = 1895, item_reward = 2038, type = 8902}
, 
[1896] = {id = 1896, item_reward = 2040, type = 8902}
}
, 
[8903] = {
[1872] = {id = 1872, item_reward = 2004, type = 8903}
, 
[1874] = {id = 1874, item_reward = 2007, type = 8903}
, 
[1875] = {id = 1875, type = 8903}
, 
[1877] = {id = 1877, item_reward = 2012, type = 8903}
, 
[1879] = {id = 1879, item_reward = 2014, type = 8903}
, 
[1883] = {id = 1883, item_reward = 2020, type = 8903}
, 
[1884] = {id = 1884, item_reward = 2021, type = 8903}
, 
[1885] = {id = 1885, item_reward = 2023, type = 8903}
, 
[1887] = {id = 1887, item_reward = 2027, type = 8903}
, 
[1892] = {id = 1892, item_reward = 2034, type = 8903}
, 
[1893] = {id = 1893, item_reward = 2035, type = 8903}
, 
[1894] = {id = 1894, item_reward = 2036, type = 8903}
}
, 
[9001] = {
[698] = {id = 698, item_reward = 2066, type = 9001}
, 
[699] = {id = 699, item_reward = 2053, type = 9001}
, 
[700] = {id = 700, item_reward = 2052, type = 9001}
, 
[701] = {id = 701, item_reward = 2055, type = 9001}
, 
[702] = {id = 702, item_reward = 2045, type = 9001}
, 
[703] = {id = 703, item_reward = 2060, type = 9001}
, 
[704] = {id = 704, item_reward = 2025, type = 9001}
, 
[705] = {id = 705, item_reward = 2039, type = 9001}
, 
[706] = {id = 706, item_reward = 2010, type = 9001}
, 
[707] = {id = 707, item_reward = 2026, type = 9001}
, 
[708] = {id = 708, item_reward = 2016, type = 9001}
}
, 
[9002] = {
[672] = {id = 672, item_reward = 2002, type = 9002}
, 
[674] = {id = 674, item_reward = 2006, type = 9002}
, 
[677] = {id = 677, item_reward = 2011, type = 9002}
, 
[679] = {id = 679, item_reward = 2013, type = 9002}
, 
[681] = {id = 681, item_reward = 2015, type = 9002}
, 
[682] = {id = 682, item_reward = 2017, type = 9002}
, 
[683] = {id = 683, item_reward = 2019, type = 9002}
, 
[687] = {id = 687, item_reward = 2024, type = 9002}
, 
[689] = {id = 689, item_reward = 2030, type = 9002}
, 
[690] = {id = 690, item_reward = 2031, type = 9002}
, 
[691] = {id = 691, item_reward = 2032, type = 9002}
, 
[692] = {id = 692, item_reward = 2033, type = 9002}
, 
[696] = {id = 696, item_reward = 2038, type = 9002}
, 
[697] = {id = 697, item_reward = 2040, type = 9002}
}
, 
[9003] = {
[673] = {id = 673, item_reward = 2004, type = 9003}
, 
[675] = {id = 675, item_reward = 2007, type = 9003}
, 
[676] = {id = 676, type = 9003}
, 
[678] = {id = 678, item_reward = 2012, type = 9003}
, 
[680] = {id = 680, item_reward = 2014, type = 9003}
, 
[684] = {id = 684, item_reward = 2020, type = 9003}
, 
[685] = {id = 685, item_reward = 2021, type = 9003}
, 
[686] = {id = 686, item_reward = 2023, type = 9003}
, 
[688] = {id = 688, item_reward = 2027, type = 9003}
, 
[693] = {id = 693, item_reward = 2034, type = 9003}
, 
[694] = {id = 694, item_reward = 2035, type = 9003}
, 
[695] = {id = 695, item_reward = 2036, type = 9003}
}
, 
[9101] = {
[1931] = {id = 1931, item_reward = 2066, type = 9101}
, 
[1932] = {id = 1932, item_reward = 2052, type = 9101}
, 
[1933] = {id = 1933, item_reward = 2055, type = 9101}
, 
[1934] = {id = 1934, item_reward = 2025, type = 9101}
, 
[1935] = {id = 1935, item_reward = 2039, type = 9101}
, 
[1936] = {id = 1936, item_reward = 2010, type = 9101}
, 
[1937] = {id = 1937, item_reward = 2026, type = 9101}
, 
[1938] = {id = 1938, item_reward = 2016, type = 9101}
}
, 
[9102] = {
[1905] = {id = 1905, item_reward = 2002, type = 9102}
, 
[1907] = {id = 1907, item_reward = 2006, type = 9102}
, 
[1910] = {id = 1910, item_reward = 2011, type = 9102}
, 
[1912] = {id = 1912, item_reward = 2013, type = 9102}
, 
[1914] = {id = 1914, item_reward = 2015, type = 9102}
, 
[1915] = {id = 1915, item_reward = 2017, type = 9102}
, 
[1916] = {id = 1916, item_reward = 2019, type = 9102}
, 
[1920] = {id = 1920, item_reward = 2024, type = 9102}
, 
[1922] = {id = 1922, item_reward = 2030, type = 9102}
, 
[1923] = {id = 1923, item_reward = 2031, type = 9102}
, 
[1924] = {id = 1924, item_reward = 2032, type = 9102}
, 
[1925] = {id = 1925, item_reward = 2033, type = 9102}
, 
[1929] = {id = 1929, item_reward = 2038, type = 9102}
, 
[1930] = {id = 1930, item_reward = 2040, type = 9102}
}
, 
[9103] = {
[1906] = {id = 1906, item_reward = 2004, type = 9103}
, 
[1908] = {id = 1908, item_reward = 2007, type = 9103}
, 
[1909] = {id = 1909, type = 9103}
, 
[1911] = {id = 1911, item_reward = 2012, type = 9103}
, 
[1913] = {id = 1913, item_reward = 2014, type = 9103}
, 
[1917] = {id = 1917, item_reward = 2020, type = 9103}
, 
[1918] = {id = 1918, item_reward = 2021, type = 9103}
, 
[1919] = {id = 1919, item_reward = 2023, type = 9103}
, 
[1921] = {id = 1921, item_reward = 2027, type = 9103}
, 
[1926] = {id = 1926, item_reward = 2034, type = 9103}
, 
[1927] = {id = 1927, item_reward = 2035, type = 9103}
, 
[1928] = {id = 1928, item_reward = 2036, type = 9103}
}
, 
[9201] = {
[1965] = {id = 1965, item_reward = 2050, type = 9201}
, 
[1966] = {id = 1966, item_reward = 2051, type = 9201}
, 
[1967] = {id = 1967, item_reward = 2042, type = 9201}
, 
[1968] = {id = 1968, item_reward = 2037, type = 9201}
, 
[1969] = {id = 1969, item_reward = 2010, type = 9201}
, 
[1970] = {id = 1970, item_reward = 2018, type = 9201}
, 
[1971] = {id = 1971, item_reward = 2025, type = 9201}
, 
[1972] = {id = 1972, item_reward = 2026, type = 9201}
}
, 
[9202] = {
[1939] = {id = 1939, item_reward = 2002, type = 9202}
, 
[1941] = {id = 1941, item_reward = 2006, type = 9202}
, 
[1944] = {id = 1944, item_reward = 2011, type = 9202}
, 
[1946] = {id = 1946, item_reward = 2013, type = 9202}
, 
[1948] = {id = 1948, item_reward = 2015, type = 9202}
, 
[1949] = {id = 1949, item_reward = 2017, type = 9202}
, 
[1950] = {id = 1950, item_reward = 2019, type = 9202}
, 
[1954] = {id = 1954, item_reward = 2024, type = 9202}
, 
[1956] = {id = 1956, item_reward = 2030, type = 9202}
, 
[1957] = {id = 1957, item_reward = 2031, type = 9202}
, 
[1958] = {id = 1958, item_reward = 2032, type = 9202}
, 
[1959] = {id = 1959, item_reward = 2033, type = 9202}
, 
[1963] = {id = 1963, item_reward = 2038, type = 9202}
, 
[1964] = {id = 1964, item_reward = 2040, type = 9202}
}
, 
[9203] = {
[1940] = {id = 1940, item_reward = 2004, type = 9203}
, 
[1942] = {id = 1942, item_reward = 2007, type = 9203}
, 
[1943] = {id = 1943, type = 9203}
, 
[1945] = {id = 1945, item_reward = 2012, type = 9203}
, 
[1947] = {id = 1947, item_reward = 2014, type = 9203}
, 
[1951] = {id = 1951, item_reward = 2020, type = 9203}
, 
[1952] = {id = 1952, item_reward = 2021, type = 9203}
, 
[1953] = {id = 1953, item_reward = 2023, type = 9203}
, 
[1955] = {id = 1955, item_reward = 2027, type = 9203}
, 
[1960] = {id = 1960, item_reward = 2034, type = 9203}
, 
[1961] = {id = 1961, item_reward = 2035, type = 9203}
, 
[1962] = {id = 1962, item_reward = 2036, type = 9203}
}
, 
[9301] = {
[1999] = {id = 1999, item_reward = 2067, type = 9301}
, 
[2000] = {id = 2000, item_reward = 2061, type = 9301}
, 
[2001] = {id = 2001, item_reward = 2055, type = 9301}
, 
[2002] = {id = 2002, item_reward = 2025, type = 9301}
, 
[2003] = {id = 2003, item_reward = 2039, type = 9301}
, 
[2004] = {id = 2004, item_reward = 2010, type = 9301}
, 
[2005] = {id = 2005, item_reward = 2018, type = 9301}
, 
[2006] = {id = 2006, item_reward = 2028, type = 9301}
}
, 
[9302] = {
[1973] = {id = 1973, item_reward = 2002, type = 9302}
, 
[1975] = {id = 1975, item_reward = 2006, type = 9302}
, 
[1978] = {id = 1978, item_reward = 2011, type = 9302}
, 
[1980] = {id = 1980, item_reward = 2013, type = 9302}
, 
[1982] = {id = 1982, item_reward = 2015, type = 9302}
, 
[1983] = {id = 1983, item_reward = 2017, type = 9302}
, 
[1984] = {id = 1984, item_reward = 2019, type = 9302}
, 
[1988] = {id = 1988, item_reward = 2024, type = 9302}
, 
[1990] = {id = 1990, item_reward = 2030, type = 9302}
, 
[1991] = {id = 1991, item_reward = 2031, type = 9302}
, 
[1992] = {id = 1992, item_reward = 2032, type = 9302}
, 
[1993] = {id = 1993, item_reward = 2033, type = 9302}
, 
[1997] = {id = 1997, item_reward = 2038, type = 9302}
, 
[1998] = {id = 1998, item_reward = 2040, type = 9302}
}
, 
[9303] = {
[1974] = {id = 1974, item_reward = 2004, type = 9303}
, 
[1976] = {id = 1976, item_reward = 2007, type = 9303}
, 
[1977] = {id = 1977, type = 9303}
, 
[1979] = {id = 1979, item_reward = 2012, type = 9303}
, 
[1981] = {id = 1981, item_reward = 2014, type = 9303}
, 
[1985] = {id = 1985, item_reward = 2020, type = 9303}
, 
[1986] = {id = 1986, item_reward = 2021, type = 9303}
, 
[1987] = {id = 1987, item_reward = 2023, type = 9303}
, 
[1989] = {id = 1989, item_reward = 2027, type = 9303}
, 
[1994] = {id = 1994, item_reward = 2034, type = 9303}
, 
[1995] = {id = 1995, item_reward = 2035, type = 9303}
, 
[1996] = {id = 1996, item_reward = 2036, type = 9303}
}
, 
[9401] = {
[735] = {id = 735, item_reward = 2067, type = 9401}
, 
[736] = {id = 736, item_reward = 2052, type = 9401}
, 
[737] = {id = 737, item_reward = 2061, type = 9401}
, 
[738] = {id = 738, item_reward = 2055, type = 9401}
, 
[739] = {id = 739, item_reward = 2053, type = 9401}
, 
[740] = {id = 740, item_reward = 2026, type = 9401}
, 
[741] = {id = 741, item_reward = 2043, type = 9401}
, 
[742] = {id = 742, item_reward = 2022, type = 9401}
, 
[743] = {id = 743, item_reward = 2018, type = 9401}
, 
[744] = {id = 744, item_reward = 2008, type = 9401}
, 
[745] = {id = 745, item_reward = 2039, type = 9401}
, 
[746] = {id = 746, item_reward = 2016, type = 9401}
, 
[747] = {id = 747, item_reward = 2037, type = 9401}
, 
[748] = {id = 748, item_reward = 2010, type = 9401}
}
, 
[9402] = {
[709] = {id = 709, item_reward = 2002, type = 9402}
, 
[711] = {id = 711, item_reward = 2006, type = 9402}
, 
[714] = {id = 714, item_reward = 2011, type = 9402}
, 
[716] = {id = 716, item_reward = 2013, type = 9402}
, 
[718] = {id = 718, item_reward = 2015, type = 9402}
, 
[719] = {id = 719, item_reward = 2017, type = 9402}
, 
[720] = {id = 720, item_reward = 2019, type = 9402}
, 
[724] = {id = 724, item_reward = 2024, type = 9402}
, 
[726] = {id = 726, item_reward = 2030, type = 9402}
, 
[727] = {id = 727, item_reward = 2031, type = 9402}
, 
[728] = {id = 728, item_reward = 2032, type = 9402}
, 
[729] = {id = 729, item_reward = 2033, type = 9402}
, 
[733] = {id = 733, item_reward = 2038, type = 9402}
, 
[734] = {id = 734, item_reward = 2040, type = 9402}
}
, 
[9403] = {
[710] = {id = 710, item_reward = 2004, type = 9403}
, 
[712] = {id = 712, item_reward = 2007, type = 9403}
, 
[713] = {id = 713, type = 9403}
, 
[715] = {id = 715, item_reward = 2012, type = 9403}
, 
[717] = {id = 717, item_reward = 2014, type = 9403}
, 
[721] = {id = 721, item_reward = 2020, type = 9403}
, 
[722] = {id = 722, item_reward = 2021, type = 9403}
, 
[723] = {id = 723, item_reward = 2023, type = 9403}
, 
[725] = {id = 725, item_reward = 2027, type = 9403}
, 
[730] = {id = 730, item_reward = 2034, type = 9403}
, 
[731] = {id = 731, item_reward = 2035, type = 9403}
, 
[732] = {id = 732, item_reward = 2036, type = 9403}
}
, 
[9501] = {
[2033] = {id = 2033, item_reward = 2052, type = 9501}
, 
[2034] = {id = 2034, item_reward = 2053, type = 9501}
, 
[2035] = {id = 2035, item_reward = 2055, type = 9501}
, 
[2036] = {id = 2036, item_reward = 2025, type = 9501}
, 
[2037] = {id = 2037, item_reward = 2039, type = 9501}
, 
[2038] = {id = 2038, item_reward = 2010, type = 9501}
, 
[2039] = {id = 2039, item_reward = 2026, type = 9501}
, 
[2040] = {id = 2040, item_reward = 2016, type = 9501}
}
, 
[9502] = {
[2007] = {id = 2007, item_reward = 2002, type = 9502}
, 
[2009] = {id = 2009, item_reward = 2006, type = 9502}
, 
[2012] = {id = 2012, item_reward = 2011, type = 9502}
, 
[2014] = {id = 2014, item_reward = 2013, type = 9502}
, 
[2016] = {id = 2016, item_reward = 2015, type = 9502}
, 
[2017] = {id = 2017, item_reward = 2017, type = 9502}
, 
[2018] = {id = 2018, item_reward = 2019, type = 9502}
, 
[2022] = {id = 2022, item_reward = 2024, type = 9502}
, 
[2024] = {id = 2024, item_reward = 2030, type = 9502}
, 
[2025] = {id = 2025, item_reward = 2031, type = 9502}
, 
[2026] = {id = 2026, item_reward = 2032, type = 9502}
, 
[2027] = {id = 2027, item_reward = 2033, type = 9502}
, 
[2031] = {id = 2031, item_reward = 2038, type = 9502}
, 
[2032] = {id = 2032, item_reward = 2040, type = 9502}
}
, 
[9503] = {
[2008] = {id = 2008, item_reward = 2004, type = 9503}
, 
[2010] = {id = 2010, item_reward = 2007, type = 9503}
, 
[2011] = {id = 2011, type = 9503}
, 
[2013] = {id = 2013, item_reward = 2012, type = 9503}
, 
[2015] = {id = 2015, item_reward = 2014, type = 9503}
, 
[2019] = {id = 2019, item_reward = 2020, type = 9503}
, 
[2020] = {id = 2020, item_reward = 2021, type = 9503}
, 
[2021] = {id = 2021, item_reward = 2023, type = 9503}
, 
[2023] = {id = 2023, item_reward = 2027, type = 9503}
, 
[2028] = {id = 2028, item_reward = 2034, type = 9503}
, 
[2029] = {id = 2029, item_reward = 2035, type = 9503}
, 
[2030] = {id = 2030, item_reward = 2036, type = 9503}
}
}
local __default_values = {id = 10, item_reward = 2009, pre_condition = __rt_1, pre_para1 = __rt_1, pre_para2 = __rt_1, type = 202}
local base = {__index = __default_values, __newindex = function()
  -- function num : 0_0 , upvalues : _ENV
  error("Attempt to modify read-only table")
end
}
for k,v in (_ENV.pairs)(lottery_reward_pool) do
  for k1,v1 in (_ENV.pairs)(v) do
    (_ENV.setmetatable)(v1, base)
  end
end
local __rawdata = {__basemetatable = base}
;
(_ENV.setmetatable)(lottery_reward_pool, {__index = __rawdata})
return lottery_reward_pool

