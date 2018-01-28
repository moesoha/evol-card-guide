require("load")
require("data/task_text_data")

function saveJSONTo(filename,data)
	local wo=(JSON:encode(data))
	print(filename,wo)

	local file=io.open("../data/text_"..filename..".json","w")
	file:write(wo)
	file:close()
end

local ids={}
for key,_ in pairs(task_text_data.data) do
	table.insert(ids,key)
end
table.sort(ids)

extractData={
}
local typeidv
for _,value in pairs(ids) do
	if(task_text_data.data[value].desc) then
		-- extractData[value]=task_text_data.data[value].desc
		local thisData={
			id=value,
			text=task_text_data.data[value].desc
		}
		local typeid=tonumber(string.sub(tostring(value),1,2))
		local type=trans.textType[typeid]
		if(type) then
			if(extractData[type]==nil) then
				extractData[type]={}
			end
			table.insert(extractData[type],thisData)
		else
			print('[WARNING] No type '..tostring(typeid).."!")
		end
	end
end

ids={}
for key,_ in pairs(extractData) do
	table.insert(ids,key)
end
for _,value in pairs(ids) do
	saveJSONTo(value,extractData[value])
end
