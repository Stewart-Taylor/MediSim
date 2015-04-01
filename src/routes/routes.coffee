module.exports = (app) ->
	require("./index") app

	# 404 redirect, leave this at the bottom.
	app.use (req, res) ->
		res.redirect "/"
