<template>
	<div id="app">
		<div>
			<p>
				<router-link to="/">主页</router-link> | 羁绊
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
</style>
