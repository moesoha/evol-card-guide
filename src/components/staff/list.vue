<template>
	<div>
		<div id="list-options">
			<b>属性</b><br />
			<span v-for="item,key in evol.property" v-if="item">
				<input type="checkbox" :id="'property-'+key" v-model="options.property[key]">
				<label :for="'property-'+key">{{item}}</label>
			</span>
			<br />
			<details>
				<summary>能力</summary>
				<span v-for="tag in evol.tag" v-if="tag.id.toString()[0]=='1'">
					<input type="checkbox" :id="'tag-'+tag.id" :data-tag-id="tag.id" v-on:click="checkTag">
					<label :for="'tag-'+tag.id">{{tag.name}}</label>
				</span>
			</details>
			<details>
				<summary>标签</summary>
				<span v-for="tag in evol.tag" v-if="tag.id.toString()[0]=='2'">
					<input type="checkbox" :id="'tag-'+tag.id" :data-tag-id="tag.id" v-on:click="checkTag">
					<label :for="'tag-'+tag.id" :style="'color: '+evol.color[tag.icon]">{{tag.name}}</label>
				</span>
			</details>
			<br />
			<button v-on:click="reload">确认</button>
			<br /><p><small><a href="https://github.com/moesoha/evol-card-guide/issues/1">为什么没有专家的图片？</a></small></p>
			<!-- <b>排序</b><br />
			<span v-for="property,i in evol.property" v-if="property">
				<input type="radio" :id="'property-'+i" :value="i" v-model="options.sortBy" v-on:click="reload">
				<label :for="'property-'+i">{{property}}</label>
			</span>
			<br /> -->
		</div>
		<hr>
		<div v-if="isLoading">
			<b><i>正在处理...</i></b>
		</div>
		<div v-else>
			<div v-for="item in data.staffId">
				<h3><router-link :to="'/staff/show/'+evol.staff[item].id">{{evol.staff[item].name}}</router-link></h3>
				<b>{{evol.property[evol.staff[item].property]}} <span v-for="a in evol.staff[item].ability">/ {{evol.tag[a].name}} </span></b>
				<br /><br />
				<div id="tags">
					<span v-for="item in evol.staff[item].tag" class="one-tag" :style="'background-color: '+evol.color[evol.tag[item].icon]">{{evol.tag[item].name}}</span>
				</div><br />
			</div>
		</div>
	</div>
</template>

<script>
import _ from "lodash";

let inArray=function (arr,val){
	for(var i in arr){
		if(arr.hasOwnProperty(i) && arr[i]===val){
			return true;
		}
	}
	return false;
};

let _defaultOptions={
	property: {
		decision: true,
		creativity: true,
		affinity: true,
		execution: true
	},
	tagsChecked: []
};

export default {
	name: 'StaffList',
	data(){
		return {
			evol: this.evol,
			appConfig: this.appConfig,
			isLoading: true,
			options: _defaultOptions,
			data: {
				staffId: []
			}
		}
	},
	mounted(){
		this.reload();
	},
	methods: {
		setLoading(){
			this.isLoading=true;
		},
		unsetLoading(){
			this.isLoading=false;
		},
		checkTag(e){
			if(e.target.checked){
				this.options.tagsChecked.push(parseInt(e.target.dataset.tagId));
			}else{
				_.remove(this.options.tagsChecked,function (id){
					return id==parseInt(e.target.dataset.tagId);
				})
			}
			_.uniq(this.options.tagsChecked);
			// console.log(this.options.tagsChecked);
		},
		hitStaff(){
			let property=[],tag=this.options.tagsChecked,that=this;
			for(var key in this.options.property){
				if(this.options.property.hasOwnProperty(key) && this.options.property[key]){
					property.push(key);
				}
			}
			let staffs=[];
			let tagTypeCount=_.countBy(tag,function (i){
				return i.toString()[0];
			});
			_.filter(this.evol.staff,function (o){
				return inArray(property,o.property);
			}).forEach(function (data,index){
				if(tag.length>0){
					let i_t=_.intersection(data.tag,tag).length==0;
					let i_a=_.intersection(data.ability,tag).length==0;
					if(i_t && i_a){
						return;// 过滤完全不符合
					}
					if(tagTypeCount['1'] && tagTypeCount['2'] && (i_t || i_a)){
						return;// ability和tag之间的&&关系
					}
				}
				
				staffs.push(that.evol.index.staff[data.id]);
			});
			this.data.staffId=staffs;
		},
		reload(){
			let that=this;
			this.setLoading();
			setTimeout(function (){
				that.hitStaff();
				that.unsetLoading();
			},66);
		}
	}
}
</script>
