<template>
	<div>
		<div id="cardsearch-form">
			<input type="text" v-on:keyup.enter="search" v-model="q">
			<button v-on:click="search">搜索</button>
			<span id="other-options">
				<input type="checkbox" id="showEvolved" v-model="showEvolved">
				<label for="showEvolved">显示进化后图片</label>
			</span>
		</div>
		<hr>
		<div id="cardsearch-result" v-if="data.length>0">
			<div v-for="item in data">
				<img :src="appConfig.path.getImagePath('card_s',(showEvolved?item.pic.evolved:item.pic.normal))">
				<p>
					[{{item.rare}}] <router-link v-bind:to="'/card/show/'+item.id">{{item.name}}</router-link>
				</p>
				<p>
					<small>决策</small> <b>{{item.property.max.decision}}</b> <small>创造</small> <b>{{item.property.max.creativity}}</b> <small>亲和</small> <b>{{item.property.max.affinity}}</b> <small>行动</small> <b>{{item.property.max.execution}}</b>
				</p>
				<br />
			</div>
		</div>
		<div v-else>
			<p><i>没有搜索到有关“{{q_last}}”的内容，请尝试修改关键词后重试。</i></p>
		</div>
	</div>
</template>

<script>

let searchInArray=function (str,arr){
	let result=[],q=str;
	if(q && q.trim().length>0){
		for(var key in arr){
			if(arr.hasOwnProperty(key)){
				if(arr[key].indexOf(q)!=-1){
					result.push({
						id: key,
						name: arr[key]
					});
				}
			}
		}
		return(result);
	}else{
		return([]);
	}
},getCardsDetail=function (datafield,indexfield,idfield){
	// evol.card[evol.index.card[item.id.toString()]]
	let a=[];
	idfield.forEach(function (data){
		a.push(datafield[indexfield[data.id.toString()]]);
	});
	return a;
};

export default {
	name: 'CardSearch',
	data(){
		// console.log(this.$route.params);
		// console.log(this.evol);
		let searchResult=searchInArray(this.$route.params.q,this.evol.index.card_name);
		return {
			q: this.$route.params.q,
			q_last: this.$route.params.q,
			showEvolved: false,
			data: getCardsDetail(this.evol.card,this.evol.index.card,searchResult?searchResult:[])
		};
	},
	methods: {
		search(event){
			if(event){
				if((this.q) && (this.q.trim()!="")){
					this.$router.replace(encodeURIComponent(this.q));
					this.q_last=this.q;
					let searchResult=searchInArray(this.$route.params.q,this.evol.index.card_name);
					this.data=getCardsDetail(this.evol.card,this.evol.index.card,searchResult?searchResult:[])
				}
			}
		}
	}
}
</script>

<style scoped>
	img {
		width: 128px;
	}
</style>
