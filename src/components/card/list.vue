<template>
	<div>
		<div id="list-options">
			<b>角色</b><br />
			<span v-for="role,i in evol.role" v-if="role">
				<input type="checkbox" :id="'role-'+i" v-model="options.role[i]">
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
				<input type="radio" :id="'property-'+i" :value="i" v-model="options.sortBy">
				<label :for="'property-'+i">{{property}}</label>
			</span>
			<br />

			<br /><b>说明</b>
			<ul>
				<li>羁绊下方的属性值排序为“决策力 / 创造力 / 亲和力 / 行动力”</li>
			</ul>
		</div>
		<hr>
		<div v-if="isLoading">
			<b><i>正在处理...</i></b>
		</div>
		<div v-else>
		</div>
	</div>
</template>

<script>
export default {
	name: 'CardList',
	data(){
		return {
			evol: this.evol,
			appConfig: this.appConfig,
			isLoading: true,
			options: {
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
				sortBy: "affinity" // 值看上面
			}
		}
	}
}
</script>
