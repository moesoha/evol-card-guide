<template>
	<div>
		<div style="position: relative;">
			<div style="position: absolute;" v-if="parseInt(picShow)==1">
				<img :src="appConfig.path.getImagePath('staff',thisStaff.pic.happy)">
			</div>
			<div style="position: absolute;" v-if="parseInt(picShow)==2">
				<img :src="appConfig.path.getImagePath('staff',thisStaff.pic.sad)">
			</div>
			<img :src="appConfig.path.getImagePath('staff',thisStaff.pic.bg)">
		</div>

		<div>
			<span>
				<input type="radio" id="picshow-0" value="0" v-model="picShow">
				<label for="picshow-0">正常</label>
			</span>
			<span>
				<input type="radio" id="picshow-1" value="1" v-model="picShow">
				<label for="picshow-1">开心</label>
			</span>
			<span>
				<input type="radio" id="picshow-2" value="2" v-model="picShow">
				<label for="picshow-2">伤心</label>
			</span>
		</div>
		<br />

		<h1>[专家] {{ thisStaff.name }}</h1>
		<h3>{{evol.trans.property[thisStaff.property]}}</h3>
		<h4>{{str.ability}}</h4>
		<div id="tags">
			<span v-for="item in thisStaff.tag" class="one-tag" :style="'background-color: '+evol.trans.color[evol.tag[item].icon]">{{evol.tag[item].name}}</span>
		</div><br />
		<b>雇佣</b>&nbsp;&nbsp;<span v-if="thisStaff.price.hire>0">{{thisStaff.price.hire}} <i>调查勋章</i></span><span v-else><i>无法从人才市场获得，剧情内掉落</i></span><br />
		<b>特聘</b>&nbsp;&nbsp;<span>{{thisStaff.price.deploy}} <i>金币</i></span><br />
		<hr>
		<p>
			{{thisStaff.school}} {{thisStaff.subject}}
		</p>
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
import _ from 'lodash';

export default {
	name: 'StaffShow',
	data(){
		let data=this.loadData();
		data.picShow=0; // 0-normal backgroung 1-happy layer 2-sad layer 
		return data;
	},
	watch: {
		'$route.params.id'(){
			let data=this.loadData();
			for(let k in data){
				if(data.hasOwnProperty(k)){
					this[k]=data[k];
				}
			}
		}
	},
	methods: {
		loadData(){
			let that=this;
			let thisStaff=_.cloneDeep(this.evol.staff[this.evol.index.staff[this.$route.params.id.toString()]]);
			let ability=[];
			thisStaff.ability.forEach(function (value,i){
				ability.push(that.evol.tag[value.toString()].name);
			});
			return {
				thisStaff: thisStaff,
				str: {
					ability: ability.join(' / ')
				}
			};
		}
	}
}
</script>
