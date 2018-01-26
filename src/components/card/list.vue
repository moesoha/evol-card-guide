<template>
	<div>
		<div id="list-options">
			<b>角色</b><br />
			<span v-for="role,i in evol.role" v-if="role">
				<input type="checkbox" :id="'role-'+i" v-model="options.role[i]" v-on:click="reload">
				<label :for="'role-'+i">{{role}}</label>
			</span>
			<!-- <br />
			<b>排序</b><br />
			<span v-for="property,i in evol.property" v-if="property">
				<input type="checkbox" :id="'property-'+i" v-model="options.sort[i]">
				<label :for="'property-'+i">{{property}}</label>
			</span> -->
			<br />
			<b>排序</b><br />
			<span v-for="property,i in evol.property" v-if="property">
				<input type="radio" :id="'property-'+i" :value="i" v-model="options.sortBy" v-on:click="reload">
				<label :for="'property-'+i">{{property}}</label>
			</span>
			<br />
			<span id="other-options">
				<input type="checkbox" id="showEvolved" v-model="options.showEvolved">
				<label for="showEvolved">显示进化后图片</label>
			</span>
		</div>
		<hr>
		<div v-if="isLoading">
			<b><i>正在处理...</i></b>
		</div>
		<div v-else>
			<div v-for="item in data.cardSorted">
				<img v-if="options.showEvolved" :src="appConfig.cardSmallPicPath+item.pic.evolved+'.jpg'">
				<img v-else :src="appConfig.cardSmallPicPath+item.pic.normal+'.jpg'">
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
	sort: { // 综合多个指数进行排序，暂时没想好怎么搞，先留着
		decision: true,
		creativity: true,
		affinity: true,
		execution: true
	},
	showEvolved: false,
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
		loadDataByRole(){
			let a=[],that=this;
			this.options.role.forEach(function (v,i){
				if(v){
					// console.log(i,v);
					a=_.concat(a,_.values(that.evol.index.card_role[i]));
				}
			});
			// console.log(a);
			this.data.cardsId=a;
		},
		sortDataWithCardsId_sortBy(){
			let key=this.options.sortBy,that=this;
			let dataFields=[];
			this.data.cardsId.forEach(function (v){
				dataFields.push(that.evol.card[v]);
			});
			dataFields=_.reverse(_.sortBy(dataFields,['property.max.'+key]));
			
			this.data.cardSorted=dataFields;
		},
		reload(){
			let that=this;
			this.setLoading();
			setTimeout(function (){
				that.loadDataByRole();
				that.sortDataWithCardsId_sortBy();
				that.unsetLoading();
			},233);
		}
	}
}
</script>
