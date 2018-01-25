// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'

import _config from '../appConfig'
import _evol from './evol'
Vue.prototype.evol=_evol;
Vue.prototype.appConfig=_config;

Vue.config.productionTip=(process.env.NODE_ENV==='production');

router.afterEach(function (to){
	// console.log(to);
	if(process.env.NODE_ENV==='production' && window && window.gtag){
		// console.log(_config);
		window.gtag('config',_config.GATrackID,{
			"page_path": to.fullPath
		});
	}
});

/* eslint-disable no-new */
new Vue({
	el: '#app',
	router,
	components: { App },
	template: '<App/>'
})
