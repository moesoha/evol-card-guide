<template>
	<div>
		<img :src="appConfig.cardPicPath+thisCard.pic.normal+'_h.jpg'">
		<img :src="appConfig.cardPicPath+thisCard.pic.evolved+'_h.jpg'">
		<h1>[{{thisCard.rare}}] {{ thisCard.name }}</h1>
		<p id="cardshow-maxrank">
			<span v-for="n in thisCard.maxRank">★</span>
		</p>
		<h2>{{evol.text.get(thisCard.sentence.talk)}}</h2>
		<h3 v-if="evol.text.get(thisCard.sentence.talk)!=evol.text.get(thisCard.sentence.shout)">{{evol.text.get(thisCard.sentence.shout)}}</h3>
		<span class="one-tag" :style="'background-color: '+evol.trans.color[evol.tag[thisCard.tag.toString()].icon]">{{evol.tag[thisCard.tag.toString()].name}}</span> <span>{{evol.text.get(thisCard.sentence.tag)}}</span>
		<div id="cardshow-property">
			<hr>
			<h3>属性</h3>
			<table border="1">
				<thead>
					<tr>
						<th></th>
						<th>决策力</th>
						<th>创造力</th>
						<th>亲和力</th>
						<th>行动力</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>基础值</td>
						<td>{{thisCard.property.base.decision}}</td>
						<td>{{thisCard.property.base.creativity}}</td>
						<td>{{thisCard.property.base.affinity}}</td>
						<td>{{thisCard.property.base.execution}}</td>
					</tr>
					<tr>
						<td>基础成长值</td>
						<td>{{thisCard.property.inc.decision}}</td>
						<td>{{thisCard.property.inc.creativity}}</td>
						<td>{{thisCard.property.inc.affinity}}</td>
						<td>{{thisCard.property.inc.execution}}</td>
					</tr>
					<tr>
						<td>最高可达</td>
						<td>{{thisCard.property.max.decision}}</td>
						<td>{{thisCard.property.max.creativity}}</td>
						<td>{{thisCard.property.max.affinity}}</td>
						<td>{{thisCard.property.max.execution}}</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div id="cardshow-level">
			<hr>
			<h3>等级</h3>
			<table border="1">
				<thead>
					<tr>
						<th>进化前最高</th>
						<th>进化后最高</th>
						<th>进化所需等级</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>{{thisCard.levelLimit.normal}}</td>
						<td>{{thisCard.levelLimit.evolved}}</td>
						<td>{{thisCard.levelLimit.toEvolve}}</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div id="cardshow-howtoget">
			<hr>
			<h3>获得方式</h3>
			<div>
				<p v-for="item in thisCard.howToGet">
					<span v-if="item.type!=3">{{getGetMethodType(item.type)}}</span>
					<span v-if="item.value.toString()!=0">
						<span v-if="item.type==3">
							<span v-if="evol.task[evol.index.task[item.value.toString()]].type=='day'">
								普通关卡
							</span>
							<span v-if="evol.task[evol.index.task[item.value.toString()]].type=='night'">
								精英关卡
							</span>
							<span v-if="evol.task[evol.index.task[item.value.toString()]].type=='male'">
								{{evol.trans.role[evol.task[evol.index.task[item.value.toString()]].role]}}副本
							</span>
							{{evol.task[evol.index.task[item.value.toString()]].stringid}} {{evol.task[evol.index.task[item.value.toString()]].name}}
						</span>
						<span v-else>{{item.value}}</span>
					</span>
				</p>
			</div>
		</div>
		<div id="cardshow-howtoget">
			<hr>
			<h3>升星</h3>
			<div>
				<p v-for="item in thisCard.advance" v-if="item.price.length>0">
					<span v-for="n in item.currentRank">★</span> ► <span v-for="n in item.currentRank+1">★</span>
					(LV {{item.level}})&nbsp;&nbsp;&nbsp;
					<span v-for="value in item.price">
						{{evol.goods[value.item.toString()].name}}x{{value.count}}
					</span>
				</p>
			</div>
		</div>
		<div id="cardshow-howtoget">
			<hr>
			<h3>进化</h3>
			<h4>材料</h4>
			<div>
				<p>
					<span v-for="item in thisCard.price.evolution">
						{{evol.goods[item.item.toString()].name}}x{{item.count}} &nbsp;
					</span>
				</p>
			</div>
			<h5>属性值 +{{thisCard.property.evolutionBonus}}%</h5>
		</div>
		<div id="cardshow-howtoget">
			<hr>
			<h3>碎片合成</h3>
			<!-- <h4>获得方式</h4>
			<div>
				<p v-for="item in thisCard.composition.howToGet">
					<span>{{getGetMethodType(item.type)}}</span>
					<span v-if="item.value.toString()!=0">{{item.value}}</span>
				</p>
			</div> -->
			<h4>材料</h4>
			<div>
				<p>
					<span v-for="item in thisCard.composition.price">
						{{evol.goods[item.item.toString()].name}}x{{item.count}} &nbsp;
					</span>
				</p>
			</div>
		</div>
		<div id="cardshow-rewards">
			<hr>
			<h3>奖励</h3>
			<div v-if="thisCard.rewards.achieve">
				<h4>获得</h4>
				<p v-for="item in thisCard.rewards.achieve">{{item.whose}}的{{item.type}}“{{item.name}}”</p>
			</div>
			<div v-if="thisCard.rewards.evolution">
				<h4>进化</h4>
				<p v-for="item in thisCard.rewards.evolution">{{item.whose}}的{{item.type}}“{{item.name}}”</p>
			</div>
			<div v-if="thisCard.rewards.resolve">
				<h4>流逝</h4>
				<p v-for="item in thisCard.rewards.resolve">{{evol.goods[item.item.toString()].name}}x{{item.count}}</p>
			</div>
		</div>
	</div>
</template>

<script>
export default {
	name: 'CardShow',
	data(){
		return {
			thisCard: this.evol.card[this.evol.index.card[this.$route.params.id.toString()]],
			getGetMethodType: function (type){
				type=type.toString();
				if(this.evol.howToGet.hasOwnProperty(type) && type!="0"){
					return this.evol.howToGet[type];
				}else{
					return "";
				}
			}
		}
	},
	watch: {
		'$route.params.id'(){
			this.thisCard=this.evol.card[this.evol.index.card[this.$route.params.id.toString()]];
		}
	}
}
</script>

<style scoped>
img {
	max-width: 30vw;
}
</style>
