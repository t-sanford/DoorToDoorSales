<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:import url="/WEB-INF/jsp/header.jsp" />

<c:url var="customScriptUrl" value="/js/custom-methods.js"/>
<script src="${customScriptUrl}"></script>


<div class="row">
	<div class="col-sm-4"></div>
	<div class="col-sm-4">
		<c:out value="How would you like to add houses?" /><br>
		<form>
		<select id="formToggler" class="form-control">
			<option><c:out value="--Select one--" /></option>
			<option value="individual" ><c:out value="Individually" /></option>
			<option  value="csv"><c:out value="Enter multiple" /></option>
		</select>
		</form>
	</div>
	<div class="col-sm-4"></div>
</div>
<div class="row">
	<div class="col-sm-4"></div>
	<div class="col-sm-4">
	<div  style="display:none" id="individualHouseForm">
	<c:url var="addHouseUrl" value="/addHouses"/>
	<form action="${addHouseUrl}" method="POST">
	<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}"/>
	<input type ="hidden" name = "creatorId" value = "${currentUser.userName}"/>
		
			<c:out value="Address: *" /><br><input type="text" name="address" class="form-control" required><br>
			<c:out value="City: *" /><br><input type="text" name="city" class="form-control" required><br>
			
			<br><label for="state"><c:out value="State:" /></label>
			<select name="state" id="state" class="form-control" required>
				<option value="Alabama"><c:out value="Alabama" /></option>
				<option value="Alaska"><c:out value="Alaska" /></option>
				<option value="Arizona"><c:out value="Arizona" /></option>
				<option value="Arkansas"><c:out value="Arkansas" /></option>
				<option value="California"><c:out value="California" /></option>
				<option value="Colorado"><c:out value="Colorado" /></option>
				<option value="Connecticut"><c:out value="Connecticut" /></option>
				<option value="Delaware"><c:out value="Delaware" /></option>
				<option value="District of Columbia"><c:out value="District Of Columbia" /></option>
				<option value="Florida"><c:out value="Florida" /></option>
				<option value="Georgia"><c:out value="Georgia" /></option>
				<option value="Hawaii"><c:out value="Hawaii" /></option>
				<option value="Idaho"><c:out value="Idaho" /></option>
				<option value="Illinois"><c:out value="Illinois" /></option>
				<option value="Indiana"><c:out value="Indiana" /></option>
				<option value="Iowa"><c:out value="Iowa" /></option>
				<option value="Kansas"><c:out value="Kansas" /></option>
				<option value="Kentucky"><c:out value="Kentucky" /></option>
				<option value="Louisiana"><c:out value="Louisiana" /></option>
				<option value="Maine"><c:out value="Maine" /></option>
				<option value="Maryland"><c:out value="Maryland" /></option>
				<option value="Massachusetts"><c:out value="Massachusetts" /></option>
				<option value="Michigan"><c:out value="Michigan" /></option>
				<option value="Minnesota"><c:out value="Minnesota" /></option>
				<option value="Mississippi"><c:out value="Mississippi" /></option>
				<option value="Missouri"><c:out value="Missouri" /></option>
				<option value="Montana"><c:out value="Montana" /></option>
				<option value="Nebraska"><c:out value="Nebraska" /></option>
				<option value="Nevada"><c:out value="Nevada" /></option>
				<option value="New Hampshire"><c:out value="New Hampshire" /></option>
				<option value="New Jersey"><c:out value="New Jersey" /></option>
				<option value="New Mexico"><c:out value="New Mexico" /></option>
				<option value="New York"><c:out value="New York" /></option>
				<option value="North Carolina"><c:out value="North Carolina" /></option>
				<option value="North Dakota"><c:out value="North Dakota" /></option>
				<option value="Ohio"><c:out value="Ohio" /></option>
				<option value="Oklahoma"><c:out value="Oklahoma" /></option>
				<option value="Oregon"><c:out value="Oregon" /></option>
				<option value="Pennsylvania"><c:out value="Pennsylvania" /></option>
				<option value="Rhode Island"><c:out value="Rhode Island" /></option>
				<option value="South Carolina"><c:out value="South Carolina" /></option>
				<option value="South Dakota"><c:out value="South Dakota" /></option>
				<option value="Tennessee"><c:out value="Tennessee" /></option>
				<option value="Texas"><c:out value="Texas" /></option>
				<option value="Utah"><c:out value="Utah" /></option>
				<option value="Vermont"><c:out value="Vermont" /></option>
				<option value="Virginia"><c:out value="Virginia" /></option>
				<option value="Washington"><c:out value="Washington" /></option>
				<option value="West Virginia"><c:out value="West Virginia" /></option>
				<option value="Wisconsin"><c:out value="Wisconsin" /></option>
				<option value="Wyoming"><c:out value="Wyoming" /></option>
			</select><br><br>
			<c:out value="Resident Name: *" /><br><input type="text" name="resident" class="form-control" required><br>
			<c:out value="Phone: *" /><br><input type="tel" name="phoneNumber" class="form-control" ><br>
			<c:out value="Status: *" /><br><select name="status" class="form-control" required>
				<option disabled selected ><c:out value="--Select a status--" /></option>
				<option value="NV"><c:out value="Not Visited" /></option>
				<option value="NI"><c:out value="Not Interested" /></option>
				<option value="O"><c:out value="Ordered" /></option>
				<option value="CL"><c:out value="Closed" /></option>
				<option value="FU"><c:out value="Follow Up" /></option>
			</select><br>
			<c:out value="Notes:" /><br>
			<textarea  name="note" class="form-control"></textarea>

			<button type = "submit" class = "btn btn-default"><c:out value = "Submit"/></button>
		
	</form></div>
	<div style="display: none" id="MultipleInput">
	<c:url var="importCsvUrl" value="/textArea"/>
	<form action="${importCsvUrl}" method="POST">
				<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}" /> 
				<input type="file" class="form-control" id="fileInput"/>
				<input type="hidden" value="" id="textInput" name='textArea'>
				<h3>Please format CSV as follows:</h3>
				<h4><c:out value="address | city | state | resident | phone_number | status" /></h4>
						
				<script>
				 document.getElementById('fileInput').addEventListener('change', readFile, false);
					var text="";
				   function readFile (evt) {
				       var files = evt.target.files;
				       var file = files[0];           
				       var reader = new FileReader();
				       reader.onload = function(event) {
				         console.log("This is the file data:\n", event.target.result);
					       document.getElementById('textInput').value=event.target.result;				        
				       }
				       reader.readAsText(file)
				    }
				</script>
				<input type="submit" value="Submit" id="submit" class="form-control"/>


			</form></div>
	 
	</div>
	<div class="col-sm-4"></div> 
</div> 


<c:import url="/WEB-INF/jsp/footer.jsp" /> 