<template>
	<div>
		<h1>[<span v-if="thisTask.type=='male'">{{evol.trans.role[thisTask.role]}}的</span>{{evol.trans.task[thisTask.type]}}]({{thisTask.stringid}}) {{ thisTask.name }}</h1>
		
	</div>
</template>

<script>
export default {
	name: 'TaskShow',
	data(){
		let that=this;
		let thisTask=this.evol.task[this.evol.index.task[this.$route.params.id.toString()]];
		console.log(thisTask);
		
		return {
			evol: this.evol,
			appConfig: this.appConfig,
			thisTask: thisTask
		}
	}
}
</script>
