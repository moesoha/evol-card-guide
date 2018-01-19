// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'


import data_card from '../data/card.json'
import data_goods from '../data/goods.json'
import data_tag from '../data/tag.json'
import data_howToGet from '../data/howToGet.json'

Vue.config.productionTip = false

Vue.prototype.evol={
	card: data_card,
	goods: data_goods,
	howToGet: data_howToGet,
	tag: data_tag,
	index: {}
};

let index={};
data_card.forEach(function (data,i){
	index[data.id.toString()]=i;
});
Vue.prototype.evol.index.card=index;
index={};
data_goods.forEach(function (data,i){
	index[data.id.toString()]=i;
});
Vue.prototype.evol.index.goods=index;
index={};
data_tag.forEach(function (data,i){
	index[data.id.toString()]=i;
});
Vue.prototype.evol.index.tag=index;

/* eslint-disable no-new */
new Vue({
	el: '#app',
	router,
	components: { App },
	template: '<App/>'
})
