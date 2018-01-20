// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'

//import _config from '../appConfig'
const _config=require('../appConfig');
import data_card from '../data/card.json'
import data_goods from '../data/goods.json'
import data_tag from '../data/tag.json'
import data_howToGet from '../data/howToGet.json'
import data_task from '../data/task.json'

Vue.config.productionTip=(process.env.NODE_ENV==='production');

Vue.prototype.evol={
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

let index={},nameIndex={};
data_card.forEach(function (data,i){
	index[data.id.toString()]=i;
	nameIndex[data.id.toString()]=data.name;
});
Vue.prototype.evol.index.card=index;
Vue.prototype.evol.index.card_name=nameIndex;
index={};
data_goods.forEach(function (data,i){
	index[data.id.toString()]=i;
});
Vue.prototype.evol.index.goods=index;
index={};
data_task.forEach(function (data,i){
	index[data.id.toString()]=i;
});
Vue.prototype.evol.index.task=index;
index={};
data_tag.forEach(function (data,i){
	index[data.id.toString()]=i;
});
Vue.prototype.evol.index.tag=index;
index=nameIndex=null;

Vue.prototype.appConfig=_config;

router.afterEach(function (to){
	// console.log(to);
	if(process.env.NODE_ENV==='production' && window && window.gtag){
		// console.log(_config);
		window.gtag('config',_config.GATrackID,{
			"page_path": to.fullPath
		});
	}
});

/* eslint-disable no-new */
new Vue({
	el: '#app',
	router,
	components: { App },
	template: '<App/>'
})
