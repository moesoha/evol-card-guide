require("load")
require("data/tag_info_data")

local ids={}
for key,_ in pairs(tag_info_data.data) do
	table.insert(ids,key)
end
table.sort(ids)

extractData={}
for _,value in pairs(ids) do
	thisCardData={
		id=value,
		name=MTagData.GetName(value),
		icon=MTagData.GetIcon(value)
	}

	table.insert(extractData,thisCardData)
end

wo=(JSON:encode(extractData))
print(wo)

file=io.open("../data/tag.json","w")
file:write(wo)
file:close()
