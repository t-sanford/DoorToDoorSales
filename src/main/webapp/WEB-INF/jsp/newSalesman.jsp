<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:import url="/WEB-INF/jsp/header.jsp" />


<script type="text/javascript">
	$(document).ready(function () {
		$.validator.addMethod('capitals', function(thing){
			return thing.match(/[A-Z]/);
		});
		$("#newSalesmanForm").validate({
			
			rules : {
				firstName : {
					required : true
				},
				lastName : {
					required : true
				},
				userName : {
					required : true
				},
				password : {
					required : true,
					minlength: 10,
					capitals: true,
				},
				confirmPassword : {
					required : true,		
					equalTo : "#password"  
				}
			},
			messages : {	
				firstName: {
					required: "First Name is required."
				},
				lastName: {
					required: "Last Name is required."
				},
				userName: {
					required: "Username is required."
				},
				password: {
					minlength: "Password too short, make it at least 10 characters",
					capitals: "Field must contain a capital letter",
				},
				confirmPassword : {
					equalTo : "Passwords do not match"
				}
			},
			errorClass : "error"
		});
	});
</script>

<c:url var="formAction" value="/newSalesman" />
<form id="newSalesmanForm" method="POST" action="${formAction}">
<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}"/>
	<div class="row">
		<div class="col-sm-4"></div>
		<div class="col-sm-4">
			<div class="form-group">
				<label for="firstName"><c:out value="First Name:" /></label>
				<input type="text" id="firstName" name="firstName" placeHolder="First Name" class="form-control" required />	
			</div>
			<div class="form-group">
				<label for="lastName"><c:out value="Last Name:" /></label>
				<input type="text" id="lastName" name="lastName" placeHolder="Last Name" class="form-control" required />	
			</div>
			<div class="form-group">
				<label for="userName"><c:out value="User Name:" /></label>
				<input type="text" id="userName" name="userName" placeHolder="User Name" class="form-control" required />
			</div>
			<div class="form-group">
				<label for="password"><c:out value="Password:" /></label>
				<input type="password" id="password" name="password" placeHolder="Password (at least 10 characters and 1 capital)" class="form-control" required />
			</div>
			<div class="form-group">
				<label for="confirmPassword"><c:out value="Confirm Password:" /></label>
				<input type="password" id="confirmPassword" name="confirmPassword" placeHolder="Re-Type Password" class="form-control" required />	
			</div>
			<div class="form-group">
				<label for="email"><c:out value="Email:" /></label>
				<input type="email" id="email" name="email" placeHolder="Email" class="form-control" required />	
			</div>
			<div class="form-group">
				<input type="hidden" id="role" name="role" value="Salesman"/>	
			</div>
			<button type="submit" class="btn btn-default"><c:out value="Create Salesman" /></button>
		</div>
		<div class="col-sm-4"></div>
	</div>
</form>


<c:import url="/WEB-INF/jsp/footer.jsp" />