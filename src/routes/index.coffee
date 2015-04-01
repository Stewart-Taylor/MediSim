endpoint = "/"
layout = "../../views/index.ejs"

module.exports = (app) ->
    app.get endpoint, (req, res) ->
        res.render(layout)
