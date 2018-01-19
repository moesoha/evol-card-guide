require("load")
require("data/task_info_data")

local ids={}
for key,_ in pairs(task_info_data.data) do
	table.insert(ids,key)
end
table.sort(ids)

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
		type=trans.taskType[MTaskInfoData.GetTaskType(value)],
		role=MTaskInfoData.GetMaleRoleId(value),
		tasklineId=tasklineID,
		need=need
		-- 先搞这么点，有点儿懒 _(:3
	}

	table.insert(extractData,thisCardData)
end

wo=(JSON:encode(extractData))
print(wo)

file=io.open("../data/task.json","w")
file:write(wo)
file:close()
