require("load")
require("data/staff_info_data")

local cardIds={}
for key,_ in pairs(staff_info_data.data) do
	table.insert(cardIds,key)
end
table.sort(cardIds)

--[[
	staff_name		专家名字
	staff_quality		不知道干啥的，这里暂时都是2，和 `CONST_SPRITE_NAME_LINE` 有关
	staff_ability		专家的能力标签（纪录片、综艺、etc）
	staff_tag		专家的能力标签（细心、音乐、etc）
	staff_property_type		专家属性 [null,决策力,创造力,亲和力,行动力]
	staff_property_base		属性初始值
	staff_property_inc		已废弃
	staff_hire_price		聘用需要啥 extractGoodsStr
	staff_icon1		专家图片id normal background
	staff_icon2		专家图片id happy layer
	staff_icon3		专家图片id sad layer
	school		毕业学校
	subject		毕业专业
	desc		专家描述
	self_intro		专家自述
	resume		专家简历, array joined with :
	staff_fire_price		已废弃，解雇需要啥 extractGoodsStr
	staff_refresh_prob		没找到引用，来自注释：专家刷新概率
]]

cardExtractedData={}
for _,value in pairs(cardIds) do
	thisCardData={ -- 部分没啥用没加入
		id=value,
		name=MStaffData.GetName(value),
		ability=trans.extractColonStrToNumberArray(staff_info_data.data[value].staff_ability),
		tag=trans.extractColonStrToNumberArray(staff_info_data.data[value].staff_tag),
		price={
			hire=pcall(MStaffData.GetHirePrice,value) and MStaffData.GetHirePrice(value) or (-1), -- 调查勋章的数量来雇佣
			deploy=MStaffData.GetDeployedPrice(value) -- 特聘要花的金币
		},
		school=MStaffData.GetSchool(value),
		subject=MStaffData.GetSubject(value),
		property=trans.property[MStaffData.GetAttrType(value)],
		description=staff_info_data.data[value].desc,
		selfIntroduction=staff_info_data.data[value].self_intro,
		resume=trans.extractColonStrToNumberArray(staff_info_data.data[value].resume),
		pic={
			bg=staff_info_data.data[value].staff_icon1,
			happy=staff_info_data.data[value].staff_icon2,
			sad=staff_info_data.data[value].staff_icon3
		}
	}
	table.insert(cardExtractedData,thisCardData)
end

wo=(JSON:encode(cardExtractedData))
print(wo)

file=io.open("../data/staff.json","w")
file:write(wo)
file:close()
