<template>
	<div>
		<h1>[{{thisCard.rare}}] {{ thisCard.name }}</h1>
		<p id="cardshow-maxrank">
			<span v-for="n in thisCard.maxRank">★</span>
		</p>
		<h2>{{thisCard.sentence.talk}}</h2>
		<h3 v-if="thisCard.sentence.talk!=thisCard.sentence.shout">{{thisCard.sentece.shout}}</h3>
		<div id="cardshow-level">
			<hr>
			<h3>等级</h3>
			<table border="1">
				<thead>
					<tr>
						<th>进化前最高</th>
						<th>进化后最高</th>
						<th>进化等级</th>
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
					<span v-if="((parseInt(item.type)).toString())!=item.type">{{item.type}}</span>
					 - 
					<span>{{item.value}}</span>
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
						{{evol.goods[evol.index.goods[value.item]].name}}x{{value.count}}
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
						{{evol.goods[evol.index.goods[item.item]].name}}x{{item.count}} &nbsp;
					</span>
				</p>
			</div>
			<h5>属性值 +{{thisCard.property.evolutionBonus}}%</h5>
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
				<p v-for="item in thisCard.rewards.resolve">{{evol.goods[evol.index.goods[item.item]].name}}x{{item.count}}</p>
			</div>
		</div>
	</div>
</template>

<script>
export default {
	name: 'CardShow',
	data(){
		console.log(this.$route.params);
		console.log(this.evol);
		console.log(this.evol.card[this.evol.index.card[this.$route.params.id.toString()]]);
		return {
			evol: this.evol,
			thisCard: this.evol.card[this.evol.index.card[this.$route.params.id.toString()]]
		}
	}
}
</script>
