var ADD_CONTACT = require("./AddContact.js");
var id ;

// The contact other details (address, data, phone ) are updated in this method.
function UpdateOtherTables(data,conn,res){
	var sqlQuery = "DELETE from db_class.address WHERE contact_id = "+id+" ;";
	conn.query(sqlQuery,(err,result) =>{
		if (err) throw err;
		sqlQuery = "DELETE from db_class.phone WHERE contact_id = "+id+" ;";
		conn.query(sqlQuery,(err,result) => {
			if(err) throw err;
			sqlQuery = "DELETE  from db_class.date WHERE contact_id = "+id+" ;";
			conn.query(sqlQuery,(err,result) => {
				if (err) throw err;
					ADD_CONTACT.insertContactDetails(data, conn, res);
			})
		})
	})
}


// The contact name details are updated in this method.
function updateContact(url,data,conn,res){
	console.log("***Update Contact***");
	id = url.query.contact_id
	var sqlQuery = "UPDATE db_class.contact SET fname = ?, mname = ?, lname = ? WHERE contact_id = "+id+" ;";
	conn.query(sqlQuery,[data.fname , data.mname , data.lname], (err, result) => {
		if(err) throw err;
		UpdateOtherTables(data, conn, res);
	})
}


module.exports = updateContact;