import data_card from '../data/card.json';
import data_goods from '../data/goods.json';
import data_tag from '../data/tag.json';
import data_howToGet from '../data/howToGet.json';
import data_task from '../data/task.json';

let evol={
	howToGet: data_howToGet,
	index: {
		rich: {}
	},
	role: [
		null,
		"李泽言",
		"许墨",
		"周棋洛",
		"白起"
	],
	property: {
		"decision": "决策力",
		"creativity": "创造力",
		"affinity": "亲和力",
		"execution": "行动力"
	},
	methods: []
};

// 本来想用WebSQL，主要还是担心compatibility，顺便心疼用户内存
let index={},nameIndex={};
let roleIndex=[null,{},{},{},{}];
// let propertyIndex={};
data_card.forEach(function (data,i){
	let id=data.id.toString();
	let role=parseInt(id[1]);
	if(!((role>=1)&&(role<=4))){
		return; // 非四个野男人的卡暂时就不要管了，给用户省点内存  // 不对啊流量还是照样跑
	}

	index[id]=i; // 方便快速根据card id查找
	nameIndex[id]=data.name; // 给搜索用的 羁绊名 => card id

	// 计算每个羁绊的每个属性在最高等级的情况下的分数
	// 公式来自官方客户端代码 →_→ (基础值 + 等级*基础成长值/100*(100 + 20*(星级-1))/100)*(100 + 进化加成)/100
	// (property.base[k]+levelLimit.evolved*property.inc[k]/100*(100+20*(maxRank-1))/100)*(100+property.evolutionBonus)/100
	let maxCardPoint={},maxCardPointSum=0;
	for(var key in data.property.base){
		if(data.property.base.hasOwnProperty(key)){
			let pnt=Math.floor((data.property.base[key]+Math.floor(data.levelLimit.evolved*data.property.inc[key]/100*(100+20*(data.maxRank-1))/100))*(100+data.property.evolutionBonus)/100);
			maxCardPoint[key]=pnt;
			maxCardPointSum+=pnt;
		}
	}
	data_card[i].property.max=maxCardPoint;
	data_card[i].property.maxSum=maxCardPointSum;
	// propertyIndex[role][id]={
	// 	index: i,
	// 	propertyMax: maxCardPoint,
	// 	propertyMaxSum: maxCardPointSum,
	// 	pic: data_card.pic
	// };
	roleIndex[role][id]=i;
});
evol.card=data_card;
evol.index.card=index;
evol.index.card_name=nameIndex;
evol.index.card_role=roleIndex;

index={};
data_goods.forEach(function (data,i){
	index[data.id.toString()]=i; // 方便快速根据道具id查找
});
evol.goods=data_goods;
evol.index.goods=index;

index={};
data_task.forEach(function (data,i){
	index[data.id.toString()]=i; // 方便快速根据关卡任务id查找
});
evol.task=data_task;
evol.index.task=index;

index={};
data_tag.forEach(function (data,i){
	index[data.id.toString()]=i; // 方便快速根据标签id查找
});
evol.tag=data_tag;
evol.index.tag=index;

index=roleIndex=nameIndex=null;

export default evol;
