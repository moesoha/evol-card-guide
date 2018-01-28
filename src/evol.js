import data_card from '../data/card.json';
import data_goods from '../data/goods.json';
import data_tag from '../data/tag.json';
import data_howToGet from '../data/howToGet.json';
import data_task from '../data/task.json';
let data_text={
	card: require('../data/text_card.json')
};

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

// 本来想用WebSQL，主要还是担心compatibility
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


// 下面都是将各个数据按(string)id存进object
evol.goods={};
data_goods.forEach(function (data,i){
	evol.goods[data.id.toString()]=data;
});

evol.task={};
data_task.forEach(function (data,i){
	evol.task[data.id.toString()]=data;
});

evol.tag={};
data_tag.forEach(function (data,i){
	evol.tag[data.id.toString()]=data;
});

evol.text={
	get(id){
		let textType={ // same as `etc/load.lua`>trans.textType
			"11": "taskDay",
			"12": "taskNight",
			"13": "taskMale",
			"14": "investigate",
			"18": "taskSpecial",
			// "20": "", -- 20 is unknown, maybe for test
			"21": "taskDayComment",
			"22": "taskNightComment",
			"23": "taskMaleComment",
			"28": "taskSpecialComment",
			"30": "card",
			"31": "expert",
		};
		let type=id.toString().substr(0,2);
		if(textType.hasOwnProperty(type) && this.hasOwnProperty(textType[type])){
			return this[textType[type]][id.toString()];
		}else{
			return id+"'s type unknown.";
		}
	}
};
for(var key in data_text){
	if(data_text.hasOwnProperty){
		evol.text[key]={};
		data_text[key].forEach(function (data,i){
			evol.text[key][data.id.toString()]=data.text;
		});
	}
}

index=roleIndex=nameIndex=null;

export default evol;
