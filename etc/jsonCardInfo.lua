require("load")
require("data/card_info_data")

local cardIds={}
for key,_ in pairs(card_info_data.data) do
	table.insert(cardIds,key)
end
table.sort(cardIds)

--[[
	卡牌参数
	card_name		卡名字
	card_rare		稀有度		1-N 2-NH 3-R 4-SR 5-SSR
	card_level_limit	卡级别限制	进化前:进化后
	card_type		卡类别		2-粉 3-绿
	card_property_base	卡基础属性	见 `MCardInfoData.lua` 中 `GetAttr` 的算法
	card_property_inc	卡增加属性	见 `MCardInfoData.lua` 中 `GetAttr` 的算法
	card_resolve_price	卡流逝得到	100028,28,1应该是1x回忆星砂
	male_role_id		角色id		1-李泽言 2-许墨 3-周棋洛 4-w志南 5-npc
	card_get		获得路径	值暂不明确
	card_achieve_rewards	获得卡的奖励	值暂不明确
	card_tag		卡标签		用途暂不明确
	Share_tips		显示炫耀按钮	1-是
	tag_desc_id		标签描述id	用途暂不明确
	card_talk_id		卡说话id	一句话
	card_icon		卡图片id	进化前对应`/card[_h]`下的图片id
	evolution_icon		卡进化后图片id	进化后对应`/card[_h]`下的图片id
	exchange_only		仅限交换	用途暂不明确
	card_no			卡编号		
	card_character		卡中人物	仅主角，m[1-4]对应李泽言、许墨、周棋洛、w志南
]]

cardExtractedData={}
for _,value in pairs(cardIds) do
	thisCardData={
		id=value,
		sn=MCardInfoData.GetSNByID(value),
		name=MCardInfoData.GetNameById(value),
		rare=trans.rare[MCardInfoData.GetRareById(value)],
		levelLimit={
			normal=tonumber(MCardInfoData.GetLevelLimitById(value,false)),
			evolved=tonumber(MCardInfoData.GetLevelLimitById(value,true))
		},
		type=MCardInfoData.GetTypeById(value),
		property={ -- attract,power,IQ,EQ // from MCardInfoData.lua
			base=trans.extractAttrStr(card_info_data.data[value].card_property_base),
			inc=trans.extractAttrStr(card_info_data.data[value].card_property_inc)
		},
		role=MCardInfoData.GetCharacterById(value),
		howToGet=trans.howToGet(MCardInfoData.GetHowGetById(value)),
		rewards={
			resolve=trans.extractGoodsStr(card_info_data.data[value].card_resolve_price),
		},
		composition={},
		tag=MCardInfoData.GetFriendTagById(value),
		sentence={
			tag=MTextData.GetText(MCardInfoData.GetFriendTagDescById(value)),
			talk=MTextData.GetText(MCardInfoData.GetFriendDescById(value)),
			shout=MTextData.GetText(MCardInfoData.GetFriendShoutById(value))
		},
		pic={
			normal=card_info_data.data[value].card_icon,
			evolved=card_info_data.data[value].evolution_icon
		},
		price={}
	}
	local designr=MCardInfoData.GetDraftRowById(value)
	thisCardData.composition.howToGet=trans.howToGet(designr.card_design_get)
	thisCardData.composition.price=trans.extractGoodsStr(designr.card_design_price)
	local rewards={}
	local rewardStrArr=string.split(MCardInfoData.GetAchieveRewards(value),":")
	if(rewardStrArr) then
		for _,v in pairs(rewardStrArr) do
			table.insert(rewards,trans.getRewardData(v))
		end
		thisCardData.rewards.achieve=rewards
	end
	if(MCardEvolutionInfoData.HasId(value)) then
		if(MCardEvolutionInfoData.GetEvolutionReward(value)) then
			local rewards={}
			local rewardStrArr=string.split(MCardEvolutionInfoData.GetEvolutionReward(value),":")
			if(rewardStrArr) then
				for _,v in pairs(rewardStrArr) do
					table.insert(rewards,trans.getRewardData(v))
				end
				thisCardData.rewards.evolution=rewards
			end
		end
		thisCardData.price.evolution=trans.extractGoodsStr(MCardEvolutionInfoData.GetEvolutionNeed(value))
		thisCardData.property.evolutionBonus=MCardEvolutionInfoData.GetEvolutionPercent(value)
		thisCardData.levelLimit.toEvolve=MCardEvolutionInfoData.GetEvolutionLimitLevel(value)
	end
	if(MCardAdvanceInfoData.GetCardAdvanceData(value,1)) then
		local maxRank=MCardAdvanceInfoData.GetMaxRank(value)
		thisCardData.maxRank=maxRank
		local advanceInfo={}
		for currentRank=1,maxRank do
			local advData=MCardAdvanceInfoData.GetCardAdvanceData(value,currentRank)
			if(advData) then
				local price={}
				if(advData.card_advance_price) then
					price=trans.extractGoodsStr(advData.card_advance_price)
				end
				table.insert(advanceInfo,{
					currentRank=currentRank,
					price=price,
					level=advData.card_advance_level,
					rewards=advData.card_advance_goods_rewards
				})
			end
		end
		thisCardData.advance=advanceInfo
	end
	table.insert(cardExtractedData,thisCardData)
end

wo=(JSON:encode(cardExtractedData))
print(wo)

file=io.open("../data/card.json","w")
file:write(wo)
file:close()
