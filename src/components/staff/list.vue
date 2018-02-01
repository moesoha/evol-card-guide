<template>
	<div>
		<div id="list-options">
			<b>属性</b><br />
			<span v-for="item,key in evol.trans.property" v-if="item">
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
					<label :for="'tag-'+tag.id" :style="'color: '+evol.trans.color[tag.icon]">{{tag.name}}</label>
				</span>
			</details>
			<br />
			<button v-on:click="reload">确认</button>
			<br /><p><small><a href="https://github.com/moesoha/evol-card-guide/issues/1">为什么没有专家的图片？</a></small></p>
			<!-- <b>排序</b><br />
			<span v-for="property,i in evol.trans.property" v-if="property">
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
			<input type="text" placeholder="在结果中查找" v-model="filterInResults" /><br />
			<br />
			<div v-for="item in data.staffs">
				<h3><router-link :to="'/staff/show/'+item.id">{{item.name}}</router-link></h3>
				<b>{{evol.trans.property[item.property]}} <span v-for="a in item.ability">/ {{evol.tag[a].name}} </span></b>
				<br /><br />
				<div id="tags">
					<span v-for="item in item.tag" class="one-tag" :style="'background-color: '+evol.trans.color[evol.tag[item].icon]">{{evol.tag[item].name}}</span>
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
			filterInResults: "",
			filterInResultsExecute: false,
			data: {
				staffs: []
			}
		}
	},
	watch: {
		filterInResults(newer,older){
			let that=this;
			this.filterInResultsDash();
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
		filterInResultsDash: _.debounce(function (){
			if(this.filterInResults.trim()==""){
				this.filterInResultsExecute=false;
			}else{
				this.filterInResultsExecute=this.filterInResults.trim();
			}
			let filterInResultsExecute=this.filterInResultsExecute;
			this.data.staffs=_.filter(this.data.staffs,function (o){
				return(!filterInResultsExecute||o.name.indexOf(filterInResultsExecute)>=0);
			});
			// this.sortDataWithCardsId_sortBy();
		},666),
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
				return inArray(property,o.property)&&(!that.filterInResultsExecute||o.name.indexOf(that.filterInResultsExecute)>=0);
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
				
				staffs.push(data);
			});
			this.data.staffs=staffs;
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
