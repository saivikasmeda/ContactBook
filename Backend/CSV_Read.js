// This file inserts the Contacts.csv file into MySQL database.

const csv = require('csv-parser');
const fs = require('fs');
var MYSQL = require('mysql');
var config = require('./Config.js');
var URL_PARSER = require("url")
var ADD_CONTACT = require('./AddContact.js');
var FETCH_CONTACT = require('./FetchContacts.js');
var DELETE_CONTACT = require("./DeleteContact.js");
var UPDATE_CONTACT = require("./UpdateContact.js");

var count = 0
var sqlConn = MYSQL.createConnection(config);
sqlConn.connect(function(error){
	if(error) throw error;
	console.log("MYSQL is connectted !.")
})



var data = [];
fs.createReadStream('Contacts.csv')
  .pipe(csv())
  .on('data', (row) => {
  	data.push(row);
    // console.log(row);
  })
  .on('end', () => {
  	// console.log(data[1][1]);
  	insertData(data,sqlConn);
  });


// Condition that satisfies the database scheme gets inserted into database.
function insertSecondaryContactDetails(data,conn){
	if(data[6] != "" && data[6] != null && data[7] != "" && data[7] != null && data[8] != "" && data[8] != null && data[9] != "" && data[9] != null ){
	contactDetailsQuery = "INSERT INTO db_class.address (contact_id,address_type,address,city,state,zip) values (?,?,?,?,?,?);";
		conn.query(contactDetailsQuery,[data[0],'Home',data[6],data[7],data[8],data[9]], (err,result)=>{
			if(err) throw err;
			console.log("Home_Address inserted");		
		});
	}
	if(data[11] != "" && data[11] != null && data[12] != "" && data[12] != null && data[13] != "" && data[13] != null && data[14] != "" && data[14] != null ){
	contactDetailsQuery = "INSERT INTO db_class.address (contact_id,address_type,address,city,state,zip) values (?,?,?,?,?,?);";
		conn.query(contactDetailsQuery,[data[0],'Work',data[11],data[12],data[13],data[14]], (err,result)=>{
			if(err) throw err;
			console.log("Work_Address inserted");		
		});
	}
	if(data[5] != "" && data[5] != null){
		contactDetailsQuery = "INSERT INTO db_class.phone (contact_id,phone_type,area_code,number) values(?,?,?,?);";
		conn.query(contactDetailsQuery,[data[0],'Cell',data[5].substring(0,3),data[5].substring(4)], (err,result) =>{
			if(err) throw err;
		});
	}
	if(data[4] != "" && data[4] != null){
		contactDetailsQuery = "INSERT INTO db_class.phone (contact_id,phone_type,area_code,number) values(?,?,?,?);";
		conn.query(contactDetailsQuery,[data[0],'Home',data[4].substring(0,3),data[4].substring(4)], (err,result) =>{
			if(err) throw err;
		});
	}
	if(data[10] != "" && data[10] != null){
		contactDetailsQuery = "INSERT INTO db_class.phone (contact_id,phone_type,area_code,number) values(?,?,?,?);";
		conn.query(contactDetailsQuery,[data[0],'Work',data[10].substring(0,3),data[10].substring(4)], (err,result) =>{
			if(err) throw err;
		});
	}

	if(data[15] != "" && data[15] != null){
		contactDetailsQuery = "INSERT INTO db_class.date (contact_id,date_type,date) values(?,?,?);";
		conn.query(contactDetailsQuery,[data[0],'Birthday', data[15]], (err,result) =>{
			if(err) throw err;
		});
	}
	
} 



function  insertContactDetails(data,conn){
	// console.log(data[1]);
	var contactQuery = "INSERT INTO db_class.contact (contact_id,fname,mname,lname) values (?,?,?,?);";
			sqlConn.query(contactQuery,[data[0],data[1],data[2],data[3]], function (err, result){
				if(err) throw err;
				// consoline.log("contact is inserted " +result.toString());
				insertSecondaryContactDetails(data,conn);
				
				})
}

// Contacts who has both first name and last name gets inserted into database.
function insertData(data,conn){
  	for (var i in data){
  		if(data[i][1] != "" &&  data[i][3] != "" && data[i][1] != null && data[i][3] != null){
  			insertContactDetails(data[i],conn);
  			
  		}
  	
  	}
  	
}


  	
  



