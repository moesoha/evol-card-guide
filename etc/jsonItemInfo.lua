require("load")
require("data/common_config_data")

local ids={}
for key,_ in pairs(common_config_data.data) do
	if(string.find(key,"ItemType")) then
		table.insert(ids,key)
	end
end
table.sort(ids)

extractData={}
for _,value in pairs(ids) do
	thisCardData={
		id=common_config_data.data[value].common_config_value,
		type=common_config_data.data[value].common_config_type,
		name=common_config_data.data[value].common_config_name,
		description=common_config_data.data[value].common_config_desc,
		icon=common_config_data.data[value].common_config_icon
	}

	table.insert(extractData,thisCardData)
end

wo=(JSON:encode(extractData))
print(wo)

file=io.open("../data/item.json","w")
file:write(wo)
file:close()
