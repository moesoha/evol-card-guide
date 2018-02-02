require("load")
require("data/task_info_data")

local ids={}
for key,_ in pairs(task_info_data.data) do
	table.insert(ids,key)
end
table.sort(ids)

--[[
	task_name		任务名称
	task_type		任务类型，0day1night2male，还有其他的
	male_role_id	男主，仅限male，-1为没有
	task_line_id	似乎是拿来计算关卡号的
	daily_challenge_times		每日挑战次数限制，0为不限
	heart_need		拍摄的代价，extractGoodStr，到item里面去找
	task_event_ids		拍摄会遇到的紧急事件，task_event id，冒号数组
	male_role_restrict		选卡限制，冒号数组，对应到role里面去，仅限male
	male_role_event		事件中显示哪些卡，因为是一个int
	firm_props_rate		公司的property所占的权重
	task_score_standard		分数段，3星，2星，1星
	task_virtual_score_prop		不知道，未找到引用
	task_rewards_money		完成奖励1
	task_rewards_firm_exp		完成奖励2
	task_rewards_card_exp		完成奖励3
	sweep_rewards_card_exp		重拍获得的卡片奖励
	task_item_drop_a		不知道，未找到引用
	task_item_drop_s		不知道，未找到引用
	task_item_icon		完成后可能掉落的
	type		节目类型，tagid
	task_background		背景图id
	tv_desc		节目介绍，textid
	task_start_desc		选羁绊时候的说辞，textid
	task_end_desc		拍摄结束时候的说辞，textid
	task_comment_f		失败时候的毒舌，task_comment id，冒号数组
	task_comment_b		一星时候的毒舌，task_comment id，冒号数组
	task_comment_a		二星时候的评论，task_comment id，冒号数组
	task_comment_s		三星时候的赞美，task_comment id，冒号数组
	share_num		分享id，似乎没什么卵用
	comment_num		评论id，似乎没什么卵用
]]

extractData={}
for _,value in pairs(ids) do
	local tasklineID=MTaskInfoData.GetLineID(value)
	local cid=math.modf(tasklineID/100)%100
	local sectionID=tasklineID%100
	local name=cid.."-"..sectionID
	local need={}
	if(task_info_data.data[value].heart_need) then
		need=trans.extractGoodsStr(task_info_data.data[value].heart_need)
	end
	thisCardData={
		id=value,
		name=MTaskInfoData.GetNameById(value),
		stringid=name,
		type=trans.taskType(MTaskInfoData.GetTaskType(value)),
		role=MTaskInfoData.GetMaleRoleId(value),
		tasklineId=tasklineID,
		need=need,
		limit={
			daily=MTaskInfoData.GetEliteById(value)
		},
		event=trans.extractColonStrToNumberArray(task_info_data.data[value].task_event_ids),
		score={
			grade=trans.extractColonStrToNumberArray(task_info_data.data[value].task_score_standard),
			propertyRate=trans.extractAttrStr(task_info_data.data[value].firm_props_rate),
		},
		reward={
			money=trans.extractGoodsStr(task_info_data.data[value].task_rewards_money),
			firmExp=trans.extractGoodsStr(task_info_data.data[value].task_rewards_firm_exp),
			cardExp=trans.extractGoodsStr(task_info_data.data[value].task_rewards_card_exp),
			sweepExp=trans.extractGoodsStr(task_info_data.data[value].sweep_rewards_card_exp),
			item=trans.extractGoodsStr(task_info_data.data[value].task_item_icon),
		},
		program={
			type=MTaskInfoData.GetTaskShowType(value),
			description=MTaskInfoData.GetTVDescId(value)
		}
		-- 还有些似乎没什么卵用的就算了
	}

	if(task_info_data.data[value].male_role_restrict) then
		thisCardData.limit.chooseCard=trans.extractColonStrToNumberArray(task_info_data.data[value].male_role_restrict)
	end

	table.insert(extractData,thisCardData)
end

wo=(JSON:encode(extractData))
print(wo)

file=io.open("../data/task.json","w")
file:write(wo)
file:close()
