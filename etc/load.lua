officialCodeBase="../../com.papegames.evol_lua/" -- the path of lua scripts extracted from official APK build
package.path=package.path..";"..officialCodeBase.."?.lua"

require("sys/Sys")

require("module/MCommonConfigData")
require("module/MTextData")
require("module/MCardInfoData")
require("module/MGoodsInfoData")
require("module/MTaskInfoData")
require("module/MPhoneContactData")
require("module/MPhoneMsgData")
require("module/MFriendMsgData")
require("module/MShortMsgData")
require("module/MTagData")
require("module/MTextData")
require("module/MCardEvolutionInfoData")
require("module/MCardAdvanceInfoData")
require("module/MCardDesignInfoData")
JSON=assert(loadfile(officialCodeBase.."lib/JSON.lua"))()

trans={
	rare={"N","NH","R","SR","SSR"},
	taskType={[0]="day","night","male"},
	howToGet=function (s)
		local getMethod={[0]="special","coin_lottery","diamond_lottery","map","star_exchange","composite",[30]="许愿兑换",[31]="交易所"}
		local a=string.split(s,':')
		local r={}
		for _,v in pairs(a) do
			local i=string.split(v,",")
			table.insert(r,{
				-- type=getMethod[tonumber(i[1])],
				type=i[1],
				value=i[2]
			})
		end
		return r
	end,
	getRewardData=function (strReward)
		local reward=strReward:split(",")
		local itemID=tonumber(reward[1])
		local itemType=tonumber(reward[2])
		local itemNu=tonumber(reward[3])
		local maleID=0
		local itemName=""
		local itemTypeName=MCommonConfigData.GetItemName(itemType)
	
		if itemType==MCommonConfigData.ItemTypePhoneMsgValue then
			maleID=MPhoneMsgData.GetContactID(itemID)
			itemName=MPhoneMsgData.GetTitle(itemID)
		elseif itemType == MCommonConfigData.ItemTypeShortMsgValue then
			maleID=MShortMsgData.GetContactID(itemID)
			itemName=MShortMsgData.GetName(itemID)
			favorNeed=MShortMsgData.GetFavorNeed(itemID)
		elseif itemType == MCommonConfigData.ItemTypeFriendMsgValue then
			maleID=MFriendMsgData.GetPublisher(itemID)
			itemName=MFriendMsgData.GetTitle(itemID)
			favorNeed=MFriendMsgData.GetFavorNeed(itemID)
		end
		local ret={
			whose=MPhoneContactData.GetName(maleID),
			type=itemTypeName,
			name=itemName,
		}
		return ret
	end,
	extractGoodsStr=function (s)
		a1=string.split(s,":")
		r={}
		for _,v in pairs(a1) do
			a2=string.split(v,",")
			table.insert(r,{
				item=a2[1],
				type=a2[2],
				count=a2[3]
			})
		end
		return r
	end,
	extractAttrStr=function (s)
		a=string.split(s,":")
		return {
			decision=a[1],
			creativity=a[2],
			affinity=a[3],
			execution=a[4]
		}
	end
}
