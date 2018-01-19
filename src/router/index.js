import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '@/components/HelloWorld'
import CardShow from '@/components/card/show'

Vue.use(Router)

export default new Router({
	routes: [{
		path: '/',
		name: 'HelloWorld',
		component: HelloWorld
	},{
		path: '/card/show/:id',
		name: 'CardShow',
		component: CardShow
	}]
})
