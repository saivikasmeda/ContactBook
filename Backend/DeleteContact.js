// This function remove the contact from the contact table. Using cascade property the details will be removed from other tables too.
function delete_ContactDetails(url,conn,response){
	console.log(url.query);
	var id = url.query.contact_id
	var sqlQuery = "DELETE FROM db_class.contact WHERE contact_id = "+id+"  ;";
	conn.query(sqlQuery, id,(err, result) =>{
		if(err) throw err;
		response.write("deleted");
		response.end();
	}) 
}


module.exports = delete_ContactDetails;