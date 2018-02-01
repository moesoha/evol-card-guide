<template>
	<div id="app">
		<div>
			<p>
				<router-link to="/">主页</router-link> | 羁绊 <router-link to="/card/list">列表</router-link> | <router-link to="/task/list">关卡</router-link> | <router-link to="/staff/list">专家</router-link>
			</p>
		</div>
		<hr>
		<router-view/>
		<hr>
		<footer>
			<p><small>Powered by <a href="https://github.com/moesoha/evol-card-guide">moesoha/evol-card-guide</a>. Made with love by <a href="https://sohaj.in">Soha Jin</a>.</small></p>
		</footer>
	</div>
</template>

<script>
export default {
	name: 'App'
}
</script>

<style>
	footer a{
		text-decoration: none;
	}

	.one-tag {
		color: white;
		font-weight: bold;
		padding: 0.25em 0.5em;
		margin: 0 0.32em;
	}
</style>
