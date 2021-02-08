// This is server file.

var MYSQL = require('mysql');
var config = require('./Config.js');
var URL_PARSER = require("url")
var ADD_CONTACT = require('./AddContact.js');
var FETCH_CONTACT = require('./FetchContacts.js');
var DELETE_CONTACT = require("./DeleteContact.js");
var UPDATE_CONTACT = require("./UpdateContact.js");

var sqlConn = MYSQL.createConnection(config);
sqlConn.connect(function(error){
	if(error) throw error;
	console.log("MYSQL is connectted !.")
})


// Server connection properties.
const http = require('http');
const hostname = '127.0.0.1';
const port = 3000;

// HTTP POST request are handled in this method. (ADD and UPDATE)
function processHttpRequest(data, url, res){
	var parsedURL = URL_PARSER.parse(url,true);
	console.log(parsedURL.pathname);
	var actionPath = parsedURL.pathname;
	if(actionPath == "/add"){
		res.write("Add Contact");
		ADD_CONTACT.addContact(data,sqlConn,res);

	}else if (actionPath == "/update"){
		res.write("Modify COntact");
		console.log("update");
		UPDATE_CONTACT(parsedURL,data,sqlConn,res);

	}
}

// This method parse the JSON data and call processHTTPRequest method for handling.
function handlePostRequest(req,res){
	var data = [];
	req.on("data",(chunk) =>{
		data.push(chunk);
	})
	.on('end',() =>{
		data = JSON.parse(data);
		console.log(data);
		processHttpRequest(data,req.url,res);
	})
}


// This method handles GET request 
function handleGetRequest(req,res){
	var parsedURL = URL_PARSER.parse(req.url,true);
	console.log(parsedURL.pathname);
	console.log(parsedURL.query);
	FETCH_CONTACT(parsedURL,sqlConn,res)
}

//This method Handles HTTP DELETE request.

function handleDeleteRequest(req,res){
	var parsedURL = URL_PARSER.parse(req.url,true);
	DELETE_CONTACT(parsedURL, sqlConn,res);
}


// This method create the node js server and receives all the HTTP requests.
const server = http.createServer((req, res) => {
	if(req.method == "POST"){
		console.log("POST request has been made");
		handlePostRequest(req,res);
	}else if(req.method == "GET"){
		console.log("GET request has been made");
		handleGetRequest(req,res);
	}else if (req.method == "DELETE"){
		console.log("DELETE request has been made");
		handleDeleteRequest(req,res);
	}
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});