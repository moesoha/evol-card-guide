<template>
	<div style="text-align: center;">
		<h2>羁绊</h2>
		<div id="cardsearch-form">
			<input type="text" v-on:keyup.enter="search" v-model="q">
			<button v-on:click="search">搜索</button>
		</div>
		<hr>
		<div id="aboutthis">
			<h3>关于这个</h3>
			<p>因为喜欢肝这款游戏，为了提供帮助，在业余做了这个工具。本工具是在GitHub上开源的(<a href="https://github.com/moesoha/evol-card-guide">moesoha/evol-card-guide</a>)，因为没用lint，用的是自己的风格，代码格式不符合主流规范，希望不会被打。</p>
			<p>因为高三时间也并不很轻松，网页界面并没有设计过，就这么先凑合着吧。我还有很多想法暂时还没实现，不过已经在准备了。如果有dalao愿意pr、有哪位玩家想要提建议的请至上面给出的GitHub提交pr或issue。也可以邮箱联系我(soha@lohu.info)。</p>
			<p><small>顺便soha欢迎投食，投食可以在一定程度上提升soha的生产力<code>_(:3</code> （给soha的小钱钱会拿来买零食、养<a href="https://soha.moe/post/found-some-interesting-after-unpacked-com_papegames_evol.html#quick-wzn">王志南</a>，本图鉴服务完全免费） 支付宝账号: <code>i@soha.moe</code></small></p>
			<p>本项目所有数据均来自《恋与制作人》官方Android APK。如果制作公司认为本项目有侵权行为的，我也乐意一同沟通。</p>
		</div>
	</div>
</template>

<script>
export default {
	name: 'Home',
	data () {
		//this.$router.push('/card/search/Search')
		return {
			q: ''
		}
	},
	methods: {
		search(event){
			if(event){
				if((this.q) && (this.q.trim()!="")){
					this.$router.push('/card/search/'+encodeURIComponent(this.q));
				}
			}
		}
	}
}
</script>
