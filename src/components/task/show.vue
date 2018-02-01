<template>
	<div>
		<h1>[<span v-if="thisTask.type=='male'">{{evol.trans.role[thisTask.role]}}的</span>{{evol.trans.task[thisTask.type]}}]({{thisTask.stringid}}) {{ thisTask.name }}</h1>
		<span class="one-tag" :style="'background-color: '+evol.trans.color[evol.tag[thisTask.program.type].icon]">{{evol.tag[thisTask.program.type].name}}</span><br />
		<p>{{evol.text.get(thisTask.program.description)}}</p>
		<p>进行拍摄需要消耗<span v-for="item in thisTask.need">{{evol.goods.get(item).name}}x{{item.count}} </span></p>
		<p>拍摄结束后，你将(可能)得到以下物品</p>
		<ul>
			<li v-for="item in thisTaskReward">{{evol.goods.get(item).name}}x{{item.count}}</li>
		</ul>
		<div>
			<h3>属性权重</h3>
			<table border="1">
				<thead>
					<tr>
						<th>决策力</th>
						<th>创造力</th>
						<th>亲和力</th>
						<th>行动力</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>{{thisTask.score.propertyRate.decision/100}}</td>
						<td>{{thisTask.score.propertyRate.creativity/100}}</td>
						<td>{{thisTask.score.propertyRate.affinity/100}}</td>
						<td>{{thisTask.score.propertyRate.execution/100}}</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div>
			<h3>星级得分</h3>
			<table border="1">
				<thead>
					<tr>
						<th>三星</th>
						<th>二星</th>
						<th>一星</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>{{thisTask.score.grade[0]}}</td>
						<td>{{thisTask.score.grade[1]}}</td>
						<td>{{thisTask.score.grade[2]}}</td>
					</tr>
				</tbody>
			</table>
		</div>
		<hr>
		<h3>事件</h3>
		<details v-for="event,eid in thisTaskEvent">
			<summary>{{event.description.event}}</summary>
			<p v-if="[1,3].indexOf(event.type)!=-1"><span v-for="item in event.tag" v-if="item!=-1" class="one-tag" :style="'background-color: '+evol.trans.color[evol.tag[item].icon]">{{evol.tag[item].name}}</span></p>
			<div v-if="event.type==2">
				<ul>
					<li v-for="item,iid in event.selection"><span :style="'color: '+(showAnswerId.indexOf(eid)>=0?(event.effect[iid]>90?'green':(event.effect[iid]<10?'#aaa':'orange')):'black')+';'">{{item}}</span></li>
				</ul>
			</div>
			<div v-if="event.type==1 && showAnswerId.indexOf(eid)>=0">
				<h5>符合条件的专家</h5>
				<div v-if="event.staffMatched['2']">
					<h6>两个条件符合</h6>
					<p class="list-experts"><span v-for="staff in event.staffMatched['2']"><router-link :to="'/staff/show/'+staff.id">{{staff.name}}</router-link></span></p>
				</div>
				<div v-if="event.staffMatched['1']">
					<h6>一个条件符合</h6>
					<p class="list-experts"><span v-for="staff in event.staffMatched['1']"><router-link :to="'/staff/show/'+staff.id">{{staff.name}}</router-link></span></p>
				</div>
			</div>
			<div v-if="event.type==3 && showAnswerId.indexOf(eid)>=0 && event.cardMatched && event.cardMatched.length>0">
				<h5>符合条件的羁绊</h5>
				<div>
					<p class="list-experts" v-for="card in event.cardMatched"><span><router-link :to="'/card/show/'+card.id">[{{card.rare}}] {{card.name}}</router-link></span></p>
				</div>
			</div>
			<button :data-eid="eid" v-if="showAnswerId.indexOf(eid)<0" v-on:click="showAnswer">显示提示</button>
			<br />
			<br />
		</details>
		<hr>
		<p v-if="thisTask.limit.daily>0">你一天只有{{thisTask.limit.daily}}次免费拍摄机会。</p>
		<p v-if="chooseCardLimit">在进行这次拍摄时，你只可以召唤<b>{{chooseCardLimit}}</b>的羁绊</p>
	</div>
</template>

<script>
export default {
	name: 'TaskShow',
	data(){
		let that=this;
		let thisTask=_.cloneDeep(this.evol.task[this.evol.index.task[this.$route.params.id.toString()]]);
		// console.log(thisTask);
		let chooseCardLimit=false;
		if(thisTask.limit.chooseCard && thisTask.limit.chooseCard.length>0){
			let a=[];
			thisTask.limit.chooseCard.forEach(function (v){
				a.push(that.evol.trans.role[v]);
			});
			chooseCardLimit=a.join('、');
		}
		let prop=[];
		_.forEach(thisTask.score.propertyRate,function (v,k){
			prop.push({
				v: v,
				k: k
			});
		});
		let propa=[];
		_.reverse(_.sortBy(prop,['v'])).forEach(function(d){
			propa.push(d.k);
		});
		thisTask.advantageProperty=propa;
		prop=propa=null;
		
		return {
			evol: this.evol,
			appConfig: this.appConfig,
			thisTask: thisTask,
			chooseCardLimit: chooseCardLimit,
			showAnswerId: []
		}
	},
	methods: {
		getStaff(tags){
			if(tags.length<=0){
				return;
			}
			let that=this;
			let tag=[];
			tags.forEach(function (v){
				if(v!=-1){
					tag.push(v);
				}
			});
			let expertHit={};
			this.evol.staff.forEach(function (data,index){
				let sAbility=_.cloneDeep((data.ability));
				let sTag=_.cloneDeep((data.tag));
				let i_t=_.intersection(_.concat(sAbility,sTag),tag).length;
				if(i_t>0){
					// console.log(_.concat(sAbility,sTag),tag,i_t);
					if(!expertHit[i_t.toString()]){
						expertHit[i_t.toString()]=[data];
					}else{
						expertHit[i_t.toString()].push(data);
					}
				}
			});
			let expertHitId={};
			for(var i in expertHit){
				if(expertHit.hasOwnProperty(i)){
					_.sortBy(expertHit[i],[ // 排序关键字：聘用价格（-1为剧情获得），属性，部署价格
						'price.hire',
						function (o){
							return that.thisTask.advantageProperty.indexOf(o.property);
						},
						'price.deploy'
					]).forEach(function (data){
						// console.log(i,data.name,data.property,data.price.deploy,data.price.hire)
						if(!expertHitId[i]){
							expertHitId[i]=[data];
						}else{
							expertHitId[i].push(data);
						}
					});
				}
			}
			// console.log(expertHit);
			return expertHitId;
		},
		getCard(role,tag){
			let that=this;
			let hit=[];
			_.forEach(this.evol.index.card_role[role],function (i){
				let card=that.evol.card[i];
				// console.log(i,card)
				if(card.tag==tag){
					hit.push({
						rare: card.rare,
						id: card.id,
						index: i,
						name: card.name
					});
				}
			});
			// console.log(hit)
			return hit;
		},
		showAnswer(e){
			// console.log(e.target.dataset);
			let a=this.showAnswerId;
			a.push(parseInt(e.target.dataset.eid));
			this.showAnswerId=a;
		}
	},
	computed: {
		thisTaskReward(){
			let a=[];
			for(var i in this.thisTask.reward){
				if(this.thisTask.reward.hasOwnProperty(i)){
					for(var j in this.thisTask.reward[i]){
						if(this.thisTask.reward[i].hasOwnProperty(j)){
							a.push(this.thisTask.reward[i][j]);
						}
					}
				}
			}
			return a;
		},
		thisTaskEvent(){
			let a=[],that=this;
			this.thisTask.event.forEach(function (id){
				let o=_.cloneDeep((that.evol.taskEvent[id]));
				let nowKey;

				nowKey="description";
				for(var k in o[nowKey]){
					if(o[nowKey].hasOwnProperty(k)){
						o[nowKey][k]=that.evol.text.get(o[nowKey][k]);
					}
				}
				nowKey="feedback";
				for(var k in o[nowKey]){
					if(o[nowKey].hasOwnProperty(k)){
						o[nowKey][k]=that.evol.text.get(o[nowKey][k]);
					}
				}
				nowKey="selection";
				if(o.hasOwnProperty(nowKey)){
					for(var k in o[nowKey]){
						if(o[nowKey].hasOwnProperty(k)){
							o[nowKey][k]=that.evol.text.get(o[nowKey][k]);
						}
					}
				}

				if(o.type==1){
					o.staffMatched=that.getStaff(o.tag);
				}
				if(o.type==3){
					o.cardMatched=that.getCard(that.thisTask.role,o.tag);
				}

				a.push(o);
			});
			// console.log(a);
			return a;
		},
	}
}
</script>

<style scoped>
	.list-experts span {
		margin: 0 0.4em;
	}
	.list-experts a {
		color: rgb(18, 117, 231);
		text-decoration: none;
	}
</style>
