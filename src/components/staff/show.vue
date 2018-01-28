<template>
	<div>
		<h1>[专家] {{ thisStaff.name }}</h1>
		<h3>{{evol.property[thisStaff.property]}}</h3>
		<h4>{{str.ability}}</h4>
		<div id="tags">
			<span v-for="item in thisStaff.tag" class="one-tag" :style="'background-color: '+evol.color[evol.tag[item].icon]">{{evol.tag[item].name}}</span>
		</div><br />
		<b>雇佣</b>&nbsp;&nbsp;<span v-if="thisStaff.price.hire>0">{{thisStaff.price.hire}} <i>调查勋章</i></span><span v-else><i>无法从人才市场获得，剧情内掉落</i></span><br />
		<b>特聘</b>&nbsp;&nbsp;<span>{{thisStaff.price.deploy}} <i>金币</i></span><br />
		<hr>
		<p>
			{{evol.text.get(thisStaff.description)}}
		</p>
		<h5>自我介绍</h5>
		<p>
			{{evol.text.get(thisStaff.selfIntroduction)}}
		</p>
		<h5>简历</h5>
		<li v-for="id in thisStaff.resume">
			{{evol.text.get(id)}}
		</li>

	</div>
</template>

<script>
export default {
	name: 'StaffShow',
	data(){
		let that=this;
		let thisStaff=this.evol.staff[this.evol.index.staff[this.$route.params.id.toString()]];
		console.log(thisStaff);
		// let tag=[];
		// thisStaff.tag.forEach(function (value,i){
		// 	tag.push(that.evol.tag[value.toString()]);
		// });
		let ability=[];
		thisStaff.ability.forEach(function (value,i){
			ability.push(that.evol.tag[value.toString()].name);
		});
		return {
			evol: this.evol,
			appConfig: this.appConfig,
			thisStaff: thisStaff,
			str: {
				ability: ability.join(' / ')
			}
		}
	}
}
</script>
