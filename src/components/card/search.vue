<template>
	<div>
		<div id="cardsearch-form">
			<input type="text" v-on:keyup.enter="search" v-model="q">
			<button v-on:click="search">搜索</button>
		</div>
		<hr>
		<div id="cardsearch-result" v-if="data.length>0">
			<div v-for="item in data">
				<p>
					[{{evol.card[evol.index.card[item.id.toString()]].rare}}] <router-link v-bind:to="'/card/show/'+item.id">{{item.name}}</router-link>
				</p>
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
};

export default {
	name: 'CardSearch',
	data(){
		// console.log(this.$route.params);
		// console.log(this.evol);
		
		return {
			evol: this.evol,
			q: this.$route.params.q,
			q_last: this.$route.params.q,
			data: searchInArray(this.$route.params.q,this.evol.index.card_name)
		};
	},
	methods: {
		search(event){
			if(event){
				if((this.q) && (this.q.trim()!="")){
					this.$router.replace(encodeURIComponent(this.q));
					this.q_last=this.q;
					this.data=searchInArray(this.q,this.evol.index.card_name);
				}
			}
		}
	}
}
</script>
