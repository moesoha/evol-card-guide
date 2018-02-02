<template>
	<div>
		<div v-if="isLoading">
			<i><b>正在加载…</b></i>
		</div>
		<div v-else><!-- 因为坑爹的数据结构（要特殊判断key是不是male），加上vue的渲染方式，所以这里手动分开各个种类比下面那个用v-for的注释掉的垃圾代码要靠谱，时间复杂度要小 -->
			<div class="task-datas"><!-- 普通 -->
				<h3>{{evol.trans.task['day']}}</h3>
				<table border="1">
					<tr v-for="taskGroup in data.task['day']">
						<td v-for="task in taskGroup">
							<router-link :to="'/task/show/'+task.id"><small><i>({{task.stringid}})</i></small>{{task.name}}</router-link>
						</td>
					</tr>
				</table>
			</div><!-- 普通 -->
			<div class="task-datas"><!-- 精英 -->
				<h3>{{evol.trans.task['night']}}</h3>
				<table border="1">
					<tr v-for="taskGroup in data.task['night']">
						<td v-for="task in taskGroup">
							<router-link :to="'/task/show/'+task.id"><small><i>({{task.stringid}})</i></small>{{task.name}}</router-link>
						</td>
					</tr>
				</table>
			</div><!-- 精英 -->
			<h3>{{evol.trans.task['male']}}</h3><!-- 副本角色枚举 -->
			<div class="task-datas" v-for="taskGroups,key in data.task['male']">
				<h5>{{evol.trans.role[key]}}</h5>
				<table border="1">
					<tr v-for="taskGroup in taskGroups">
						<td v-for="task in taskGroup">
							<router-link :to="'/task/show/'+task.id"><small><i>({{task.stringid}})</i></small>{{task.name}}</router-link>
						</td>
					</tr>
				</table>
			</div><!-- 副本角色枚举 -->
			<h3>{{evol.trans.task['special']}}</h3><!-- 活动枚举 -->
			<div class="task-datas" v-for="taskGroups,key in data.task['special']">
				<h5>{{evol.trans.task[key]}}</h5>
				<table border="1">
					<tr v-for="taskGroup in taskGroups">
						<td v-for="task in taskGroup">
							<router-link :to="'/task/show/'+task.id"><small><i>({{task.stringid}})</i></small>{{task.name}}</router-link>
						</td>
					</tr>
				</table>
			</div>
		</div><!-- 活动枚举 -->
		<!-- <div v-for="taskGroups,key in data.task" v-else>
			<h3>{{evol.trans.task[key]}}</h3>
			<div v-if="key=='male'" v-for="taskGroups1,key1 in taskGroups">
				<h5>{{evol.trans.role[key1]}}</h5>
				<table>
					<tr v-for="taskGroup in taskGroups1">
						<td v-for="task in taskGroup">
							<router-link :to="'/task/show/'+task.id"><small><i>({{task.stringid}})</i></small>{{task.name}}</router-link>
						</td>
					</tr>
				</table>
			</div>
			<div v-else>
				<table>
					<tr v-for="taskGroup in taskGroups">
						<td v-for="task in taskGroup">
							<router-link :to="'/task/show/'+task.id"><small><i>({{task.stringid}})</i></small>{{task.name}}</router-link>
						</td>
					</tr>
				</table>
			</div>
		</div> -->
	</div>
</template>

<script>
import _ from "lodash";

export default {
	name: 'TaskList',
	data(){
		return {
			isLoading: false,
			data: {
				task: {}
			}
		}
	},
	mounted(){
		let that=this;
		console.log(this.specialTask,this.data);
		// this.setLoading();
		this.loadData();
		// setTimeout(function (){
		// 	that.unsetLoading(); // 加载所有关卡数据会因为数据量大而卡顿，这里用点奇怪的方法提高用户体验 // 这里的问题是上面那个注释掉的垃圾代码引起的，原因写在了上面某个div边上
		// },66);
	},
	methods: {
		setLoading(){
			this.isLoading=true;
		},
		unsetLoading(){
			this.isLoading=false;
		},
		loadData(){
			let that=this;
			let tableChunkSize=5;
			let tasks=_.groupBy(this.evol.task,function (o){
				return that.evol.type.task(o.type/*o.id.toString().substr(0,1)*/);
			});
			tasks.male=_.groupBy(tasks.male,'role');
			tasks.special=_.groupBy(tasks['special'],'type');
			for(var k in tasks){
				if(tasks.hasOwnProperty(k)&&['male','special'].indexOf(k)==-1){
					tasks[k]=_.chunk(tasks[k],tableChunkSize);
				}
			}
			for(var k in tasks.male){
				if(tasks.male.hasOwnProperty(k)){
					tasks.male[k]=_.chunk(tasks.male[k],tableChunkSize);
				}
			}
			for(var k in tasks.special){
				if(tasks.special.hasOwnProperty(k)){
					tasks.special[k]=_.chunk(tasks.special[k],tableChunkSize);
				}
			}
			this.data.task=tasks
		},
		group(data,num){
			// console.log(data,num)
			return _.chunk(data,num);
		}
	}
}
</script>

<style scoped>
	.task-datas a {
		color: rgb(85, 152, 230);
		text-decoration: none;
	}
</style>
