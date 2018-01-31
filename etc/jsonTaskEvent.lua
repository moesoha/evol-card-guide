require("load")
require("data/task_event_info_data")

local ids={}
for key,_ in pairs(task_event_info_data.data) do
	table.insert(ids,key)
end
table.sort(ids)

extractData={}
for _,value in pairs(ids) do
	thisCardData={
		id=value,
		type=task_event_info_data.data[value].task_event_type, -- 1 choose experts, 2 choose answer
		weight=task_event_info_data.data[value].task_event_weight,
		description={
			event=task_event_info_data.data[value].task_event_desc,
			role=task_event_info_data.data[value].role_desc,
		},
		-- event_option_cnt 用来限制选择的数量，暂时没啥用，都是1
	}

	if(thisCardData.type==1) then -- 选择专家
		local feedbackArr=trans.extractColonStrToNumberArray(task_event_info_data.data[value].task_event_feedback)
		local tagArr=trans.extractColonStrToNumberArray(task_event_info_data.data[value].task_event_cond)
		thisCardData.feedback={
			ak=feedbackArr[1], -- 全对
			wa=feedbackArr[4], -- 全错
			tag=feedbackArr[3], -- 标签对
			ability=feedbackArr[2], -- 特长对
			null=task_event_info_data.data[value].task_event_null
		}
		thisCardData.effect=trans.extractColonStrToNumberArray(task_event_info_data.data[value].task_event_effect) -- not chose, chose, correct ability, correct tag
		thisCardData.tag=tagArr
		-- if(tagArr[1]==-1) then
		-- 	thisCardData.tag={
		-- 		tagArr[2]
		-- 	}
		-- elseif(tagArr[2]==-1) then
		-- 	thisCardData.tag={
		-- 		tagArr[1]
		-- 	}
		-- else
		-- 	thisCardData.tag=tagArr
		-- end
	elseif(thisCardData.type==2) then -- 做选择题
		thisCardData.feedback=trans.extractColonStrToNumberArray(task_event_info_data.data[value].task_event_feedback)
		thisCardData.selection=trans.extractColonStrToNumberArray(task_event_info_data.data[value].task_event_choose)
		thisCardData.effect=trans.extractColonStrToNumberArray(task_event_info_data.data[value].task_event_effect)
	elseif(thisCardData.type==3) then -- 副本中的对应羁绊
		local feedbackArr=trans.extractColonStrToNumberArray(task_event_info_data.data[value].task_event_feedback)
		thisCardData.feedback={
			ac=feedbackArr[1], -- 对
			wa=feedbackArr[2], -- 错
		}
		thisCardData.effect=trans.extractColonStrToNumberArray(task_event_info_data.data[value].task_event_effect) -- not chose, chose, correct
		thisCardData.tag=trans.extractColonStrToNumberArray(task_event_info_data.data[value].task_event_cond)
	else
		error('unknown event type '..thisCardData.type..'! @'..value)
	end

	table.insert(extractData,thisCardData)
end

wo=(JSON:encode(extractData))
print(wo)

file=io.open("../data/task.json","w")
file:write(wo)
file:close()
