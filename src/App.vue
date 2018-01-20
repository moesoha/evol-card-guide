<template>
	<div id="app">
		<div>
			<p>
				羁绊 | <router-link to="/card/search">搜索</router-link>
			</p>
		</div>
		<hr>
		<router-view/>
	</div>
</template>

<script>
export default {
	name: 'App'
}
</script>

<style>

</style>
