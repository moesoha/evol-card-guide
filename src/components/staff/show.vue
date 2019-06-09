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
		<hr>
		<div>
			<h3>工具</h3>
			<div>
				<h4>关卡</h4>
				<p v-if="!useful.calculated"><i>因为数据查询时间可能较长，需要手动启动。</i></p>
				<button v-if="!useful.calculated" v-on:click="calcUseful">开始</button>
				<div v-if="useful.calculated">
					<p>游戏共有<b>{{useful.data.event.total}}</b>个专家事件，该角色可在<b>{{useful.data.event.hit}}</b>个事件中完全匹配标签。</p>
					<!-- <details>
						<summary>可应用的关卡</summary>
					</details> -->
				</div>
			</div>
		</div>
	</div>
</template>

<script>
import _ from 'lodash';

export default {
	name: 'StaffShow',
	data(){
		let data=this.loadData();
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
			let thisStaff=_.cloneDeep(this.evol.staff[this.evol.index.staff[this.$route.params.id.toString()]]);
			let ability=[];
			thisStaff.ability.forEach(value=>ability.push(this.evol.tag[value.toString()].name));
			return {
				thisStaff: thisStaff,
				str: {
					ability: ability.join(' / ')
				},
				picShow: 0, // 0-normal backgroung 1-happy layer 2-sad layer 
				useful: {
					calculated: false,
					data: {
						event: {
							total: 0,
							hit: 0
						},
						tasksGrouped: []
					}
				}
			};
		},
		calcUseful(e){
			// console.log(e);
			let mytag=_.concat(_.cloneDeep(this.thisStaff.ability),_.cloneDeep(this.thisStaff.tag));
			let data=this.evol._.task.getUseful(mytag);
			this.useful.data.event.total=data.total;
			this.useful.data.event.hit=data.hit;

			this.useful.calculated=true;
		}
	}
}
</script>
