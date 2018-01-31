<template>
	<div>
		<div id="list-options">
			<b>角色</b><br />
			<span v-for="role,i in evol.trans.role" v-if="role">
				<input type="checkbox" :id="'role-'+i" v-model="options.role[i]" v-on:click="">
				<label :for="'role-'+i">{{role}}</label>
			</span>
			<!-- <br />
			<b>排序</b><br />
			<span v-for="property,i in evol.trans.property" v-if="property">
				<input type="checkbox" :id="'property-'+i" v-model="options.sort[i]">
				<label :for="'property-'+i">{{property}}</label>
			</span> -->
			<br />
			<b>排序</b><br />
			<span v-for="property,i in evol.trans.property" v-if="property">
				<input type="radio" :id="'property-'+i" :value="i" v-model="options.sortBy" v-on:click="">
				<label :for="'property-'+i">{{property}}</label>
			</span>
			<br />
			<b>稀有度</b><br />
			<span v-for="rare,i in evol.trans.rare" v-if="rare">
				<input type="checkbox" :id="'rare-'+i" v-model="options.rare[i]" v-on:click="">
				<label :for="'rare-'+i">{{rare}}</label>
			</span>
			<br />
			<span id="other-options">
				<input type="checkbox" id="showCannotGet" v-model="options.showCardCannotGet">
				<label for="showEvolved">显示“暂无来源”</label><br />
				<button v-on:click="reload">筛选!</button>
				<br />
				<br />
				<input type="checkbox" id="showEvolved" v-model="options.showEvolved">
				<label for="showEvolved">显示进化后图片</label><br />
			</span>
		</div>
		<hr>
		<div v-if="isLoading">
			<b><i>正在处理...</i></b>
		</div>
		<div v-else>
			<div v-for="item in data.cardSorted">
				<img :src="appConfig.cardSmallPicPath+(options.showEvolved?item.pic.evolved:item.pic.normal)+'.jpg'">
				<p>
					[{{item.rare}}] <router-link v-bind:to="'/card/show/'+item.id">{{item.name}}</router-link>
				</p>
				<p>
					<small>决策</small> <b>{{item.property.max.decision}}</b> <small>创造</small> <b>{{item.property.max.creativity}}</b> <small>亲和</small> <b>{{item.property.max.affinity}}</b> <small>行动</small> <b>{{item.property.max.execution}}</b>
				</p>
			</div>
		</div>
	</div>
</template>

<script>
import _ from "lodash";

let _defaultOptions={
	role: [
		null,
		true,
		true,
		true,
		true
	],
	rare: [
		null,
		null,
		true,
		true,
		true
	],
	sort: { // 综合多个指数进行排序，暂时没想好怎么搞，先留着
		decision: true,
		creativity: true,
		affinity: true,
		execution: true
	},
	showEvolved: false,
	showCardCannotGet: false,
	sortBy: "affinity" // 值看上面
};

export default {
	name: 'CardList',
	data(){
		return {
			evol: this.evol,
			appConfig: this.appConfig,
			isLoading: true,
			options: _defaultOptions,
			data: {
				cardsId: []
			}
		}
	},
	mounted(){
		this.reload();
	},
	methods: {
		setLoading(){
			this.isLoading=true;
		},
		unsetLoading(){
			this.isLoading=false;
		},
		sortDataWithCardsId_sortBy(){
			let key=this.options.sortBy,that=this;
			let dataFields=[];
			let roleFilter=[],rareFilter=[];
			this.options.role.forEach(function (v,i){
				if(v){
					roleFilter.push(i);
				}
			});
			this.options.rare.forEach(function (v,i){
				if(v){
					rareFilter.push(that.evol.trans.rare[i]);
				}
			});
			_.filter(this.evol.card,function (o){
				return ((_.indexOf(roleFilter,o.role))!=-1)&&((_.indexOf(rareFilter,o.rare))!=-1)&&(that.options.showCardCannotGet||(o.howToGet[0].value!="暂无来源"));
			}).forEach(function (v){
				dataFields.push(v);
			});
			dataFields=_.reverse(_.sortBy(dataFields,['property.max.'+key]));
			
			this.data.cardSorted=dataFields;
		},
		reload(){
			let that=this;
			this.setLoading();
			setTimeout(function (){
				that.sortDataWithCardsId_sortBy();
				that.unsetLoading();
			},233);
		}
	}
}
</script>

<style scoped>
	img {
		width: 128px;
	}
</style>
