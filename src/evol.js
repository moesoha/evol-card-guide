import data_card from '../data/card.json';
import data_goods from '../data/goods.json';
import data_tag from '../data/tag.json';
import data_howToGet from '../data/howToGet.json';
import data_task from '../data/task.json';

let evol={
	card: data_card,
	goods: data_goods,
	howToGet: data_howToGet,
	tag: data_tag,
	task: data_task,
	index: {},
	role: [
		null,
		"李泽言",
		"许墨",
		"周棋洛",
		"白起"
	]
};

// 本来想用WebSQL，主要还是担心compatibility，顺便心疼用户内存
let index={},nameIndex={};
data_card.forEach(function (data,i){
	let id=data.id.toString();
	let role=parseInt(id[1]);
	if(!((role>=1)&&(role<=4))){
		return; // 非四个野男人的卡暂时就不要管了，给用户省点内存  // 不对啊流量还是照样跑
	}
	index[id]=i; // 方便快速根据card id查找
	nameIndex[id]=data.name; // 给搜索用的 羁绊名 => card id
});
evol.index.card=index;
evol.index.card_name=nameIndex;

index={};
data_goods.forEach(function (data,i){
	index[data.id.toString()]=i; // 方便快速根据道具id查找
});
evol.index.goods=index;

index={};
data_task.forEach(function (data,i){
	index[data.id.toString()]=i; // 方便快速根据关卡任务id查找
});
evol.index.task=index;

index={};
data_tag.forEach(function (data,i){
	index[data.id.toString()]=i; // 方便快速根据标签id查找
});
evol.index.tag=index;

index=nameIndex=null;

export default evol;
