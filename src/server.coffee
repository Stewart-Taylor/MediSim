# server.coffee
#
# This is used to start the web service
#

console.log ""
console.log ""
console.log "-------------------------------------------"
console.log "       STARTING PLAY SERVICE"
console.log "-------------------------------------------"
console.log ""

flash = require("connect-flash")
express = require("express")
app = express()
less = require("less")
fs = require("fs")
http = require("http")
pjson = require("../package.json")

app.configure ->
	app.use express.cookieParser()
	app.use flash()
	app.use express.bodyParser()
	app.use express.session(secret: "splicerSecret")
	app.use app.router
	app.use express.logger("dev")
	app.use "/output", express.static("../output")
	app.use "/", express.static("../public")
	app.use "/tmp", express.static("../tmp")
	app.use "/levels", express.static("../levels")


app.set "view engine", "ejs"
app.set "view options",
    layout: false

app.disable "x-powered-by"

require("./routes/routes") app

port = 8080
app.listen(port)
console.log "Listening on port " + port
console.log "Version: " + pjson.version
console.log ""
