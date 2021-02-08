
function insertContactDetails(data,conn, response){
	var contactDetailsQuery ;
	var addressLength  = data.address.length, insertedSize = 0;
	console.log(addressLength);
	contactDetailsQuery = "INSERT INTO db_class.address (contact_id,address_type,address,city,state,zip,apt) values (?,?,?,?,?,?,?);";
	for(var i in data.address){
		var addObj = data.address[i];
		conn.query(contactDetailsQuery,[data.contact_id,addObj.type,addObj.street,addObj.city,addObj.state,addObj.zipcode,addObj.apt], (err,result)=>{
			if(err) throw err;

			insertedSize++;
			console.log("total "+addressLength+" inserted size "+insertedSize);
			// if(insertedSize == addressLength){
			// 	// response.write("done");
			// 	response.end();
			// }
		});
	} 

	// Insert Phones
	var phoneLength = data.phone.length, insertedPhoneSize = 0;
	contactDetailsQuery = "INSERT INTO db_class.phone (contact_id,phone_type,area_code,number) values(?,?,?,?);";
	for (var i in data.phone){
		var phoneObj = data.phone[i];
		conn.query(contactDetailsQuery,[data.contact_id,phoneObj.type,phoneObj.area,phoneObj.phonenumber], (err,result) =>{
			if(err) throw err;
			insertedPhoneSize++;
			console.log("total" + phoneLength+"insertedsize" +insertedPhoneSize);
			// if(insertedPhoneSize == phoneLength){
			// 	response.end();
			// }
		});

	}


	// Insert Dates
	var datesLength = data.date.length ,  insertedDateSize = 0 ;
	contactDetailsQuery = "INSERT INTO db_class.date (contact_id,date_type,date) values(?,?,?);";
	for(var i in data.date){
		dateObj = data.date[i];
		conn.query(contactDetailsQuery,[data.contact_id,dateObj.type, dateObj.date], (err,result) =>{
			if(err) throw err;
			insertedDateSize++;
			console.log("totaldate"+datesLength+"inserteddate "+insertedDateSize);
		});
	}

}


// Fetch the contact_id of the last inserted contact.
function fetchContactID(data, sqlConn,response){
	var lastIDQuery = "Select last_insert_id() as ID;"
	sqlConn.query(lastIDQuery,(err,result) => {
		if(err) throw err;
		Object.keys(result).forEach(key => {
			data.contact_id = result[key].ID;
		})
		insertContactDetails(data,sqlConn,response)
	})
}




// In this fucntion we insert the data into contact table.
function addContact(data, sqlConn, response){
	var contactQuery = "INSERT INTO db_class.contact (fname,mname,lname) values (?,?,?);";
	sqlConn.query(contactQuery,[data.fname,data.mname,data.lname], function (err, result){
		if(err) throw err;
		console.log("contact is inserted " +result.toString());
		fetchContactID(data, sqlConn,response)
	})

}

// Exports property makes the functions mentioned visible for other .js files

var exporter = { addContact : addContact, insertContactDetails: insertContactDetails };
module.exports = exporter;

