// Data that is return to front end along with response.
var contactDetails = {contact_id:"",fname:"",mname:"",lname:"",address:"",phone:"",date:""};

// this function fetches all the date details of the particular contact with contact_id
function fetchAllDates(id,conn,response){
	// console.log("cdates d")
	var sqlQuery = "SELECT * FROM db_class.date WHERE contact_id = ?;";
	conn.query(sqlQuery,id,(err,result) =>{
		if(err) throw err;
		var dates = [];
		Object.keys(result).forEach(key => {
            var a = result[key];
            var obj = {type:a.date_type ,date:a.date};
            dates.push(obj);
	});
		contactDetails.date = dates;
		console.log(contactDetails)
		response.write(JSON.stringify(contactDetails));
		response.end();

	})
}

// this function fetches all the phone details of the particular contact with contact_id
function fetchAllPhones(id,conn,response){
	// console.log("cphone id")
	var sqlQuery = "SELECT * FROM db_class.phone WHERE contact_id = ? ;";
	conn.query(sqlQuery,id,(err,result) =>{
		if(err) throw err;
		var phones = [];
		Object.keys(result).forEach(key => {
            var a = result[key];
            var obj = {type: a.phone_type,phonenumber: a.number,area:a.area_code };
            phones.push(obj);
        });
        contactDetails.phone = phones;
        fetchAllDates(id,conn,response);
	})

}


// this function fetches all the address details of the particular contact with contact_id
function fetchAddressOfContact(id,conn,response){
	console.log("address id")
	var sqlQuery = "SELECT * from db_class.address WHERE contact_id = ? ;";
	conn.query(sqlQuery,id, (err,result) =>{
		if(err) throw err;
		var addresses = [];
		Object.keys(result).forEach(key =>{
			var temp = result[key];
			var obj = {type:temp.address_type , street:temp.address , apt: temp.apt , city:temp.city ,state: temp.state,zipcode:temp.zip};
			addresses.push(obj);
		});
		contactDetails.address = addresses;
		fetchAllPhones(id,conn,response)
	})
}


// this function fetches all the name details of the particular contact with contact_id
function fetchContact_id(id,conn,response){
	console.log(id)
	var sqlQuery = "SELECT * from db_class.contact where contact_id="+id+" ;";
	conn.query(sqlQuery,(err,result)=>{
		if(err) throw err;
		console.log("contact id");
		console.log(result);
		Object.keys(result).forEach(key =>{
			var contact = result[key];
			contactDetails.contact_id = contact.contact_id.toString();
			contactDetails.fname = contact.fname;
			contactDetails.mname =contact.mname;
			contactDetails.lname = contact.lname;
			console.log("contact id");
			console.log(contactDetails);
			fetchAddressOfContact(id,conn,response)
		})
	})

}

// this function fetches all the name details and contact_id of all contacts that satisfies the search condition
function fetchAllContacts(criteria, conn, response){
	var sqlQuery = "select * from db_class.contact c "+" JOIN "+
	"(SELECT DISTINCT contact_id FROM db_class.ADDRESS "+
	"WHERE ADDRESS like ? or city like ? or state like ? or zip like ? "+
	"UNION "+
	"SELECT DISTINCT contact_id from db_class.phone "+
	"WHERE area_code like ? or 'number' like ? "+
	"UNION "+
	"SELECT contact_id from db_class.contact "+
	"WHERE fname like ? or mname like ? or lname like ?) cl "+
	"on cl.contact_id = c.contact_id; ";
	var crit = "%"+criteria.search+"%";
	conn.query(sqlQuery,[crit,crit,crit,crit,crit,crit,crit,crit, crit], (err,result) =>{
		if(err) throw err;
		var allContacts = []
		Object.keys(result).forEach(key =>{
			var row = result[key];
			var name = {contact_id:row.contact_id.toString(),fname:row.fname,mname:row.mname,lname:row.lname};
			allContacts.push(name);
		});
		console.log(allContacts);
		response.write(JSON.stringify(allContacts));
		response.end();
	});
}


// search word defines that HTTP GET is made based on search bar condition.
//Contact_id word defines that HTTP GET request is made to fetch all the details of a particular contact.
function fetchContact(url,conn,response){
	if('search' in url.query){
		fetchAllContacts(url.query,conn,response);
	}else if('contact_id' in url.query){
		fetchContact_id(url.query.contact_id,conn ,response);
	}
}


module.exports = fetchContact;