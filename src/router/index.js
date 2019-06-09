import Vue from 'vue'
import Router from 'vue-router'
import NotFound from '@/components/notFound'
// import ErrorHandler from '@/components/error'
import Home from '@/components/home'
import CardShow from '@/components/card/show'
import CardSearch from '@/components/card/search'
import CardList from '@/components/card/list'
import StaffShow from '@/components/staff/show'
import StaffList from '@/components/staff/list'
import TaskShow from '@/components/task/show'
import TaskList from '@/components/task/list'

Vue.use(Router)

Vue.config.errorHandler=(err,vm,info)=>{
	console.log(vm,info);
	console.error(err);
	alert(vm.$vnode.tag+'出错，请将错误报告给开发者\n'+err.message+'\n\n'+err.stack);
}

export default new Router({
	routes: [{
		path: '/',
		name: 'Home',
		component: Home
	},{
		path: '/card/show/:id',
		name: 'CardShow',
		component: CardShow
	},{
		path: '/card/search/:q',
		name: 'CardSearch',
		component: CardSearch
	},{
		path: '/card/list',
		name: 'CardList',
		component: CardList
	},{
		path: '/staff/show/:id',
		name: 'StaffShow',
		component: StaffShow
	},{
		path: '/staff/list',
		name: 'StaffList',
		component: StaffList
	},{
		path: '/task/show/:id',
		name: 'TaskShow',
		component: TaskShow
	},{
		path: '/task/list',
		name: 'TaskList',
		component: TaskList
	},{
		path: '*',
		name: 'NotFound',
		component: NotFound
	}]
})
