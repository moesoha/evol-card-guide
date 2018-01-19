require("load")
require("data/source_info")

d=source_info.data

function g(n)
	if(d[n]) then
		return tonumber(d[n].source_value)
	else
		return 2147483647
	end
end

extractData={
	[0]="special",
	[g("Achv")]="成就",
	[g("Advance")]="羁绊升星",
	[g("Activity")]="活动",
	[g("Arena")]="票房争夺战",
	[g("CardDestory")]="羁绊流逝",
	[g("Composite")]="碎片合成",
	[g("DailyTask")]="每日任务",
	[g("Engagement")]="约会",
	[g("Evolve")]="羁绊进化",
	[g("LoopTask")]="城市漫步",
	[g("LotteryDiamond")]="星光许愿池",
	[g("LotteryGold")]="曙光许愿池",
	[g("Mainline")]="主线剧情",
	[g("Map")]="关卡",
	[g("PvpExchange")]="票房奖章兑换",
	[g("StarExchange")]="许愿兑换",
	[g("TrackTask")]="城市新闻",
	[g("TrackTaskExchange")]="调查勋章兑换",
	[g("Upgrade")]="羁绊升级"
}

wo=(JSON:encode(extractData))
print(wo)

file=io.open("../data/howToGet.json","w")
file:write(wo)
file:close()
