import Vue from 'vue'
import Router from 'vue-router'
import Home from '@/components/home'
import CardShow from '@/components/card/show'
import CardSearch from '@/components/card/search'
import CardList from '@/components/card/list'
import StaffShow from '@/components/staff/show'
import StaffList from '@/components/staff/list'

Vue.use(Router)

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
	}]
})
