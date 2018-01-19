require("load")
require("data/goods_info_data")

local ids={}
for key,_ in pairs(goods_info_data.data) do
	table.insert(ids,key)
end
table.sort(ids)

extractData={}
for _,value in pairs(ids) do
	thisCardData={
		id=value,
		name=MGoodsInfoData.GetNameById(value),
		description=MGoodsInfoData.GetDescById(value),
		type={
			main=MGoodsInfoData.GetTypeById(value),
			sub=MGoodsInfoData.GetSubTypeById(value)
		},
		icon=MGoodsInfoData.GetIconById(value)
	}

	table.insert(extractData,thisCardData)
end

wo=(JSON:encode(extractData))
print(wo)

file=io.open("../data/goods.json","w")
file:write(wo)
file:close()
