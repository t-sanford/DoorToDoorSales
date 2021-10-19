<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:import url="/WEB-INF/jsp/header.jsp" />

<script type="text/javascript">
	$(document).ready(function () {
		$.validator.addMethod('capitals', function(thing){
			return thing.match(/[A-Z]/);
		});
		$("form.changePassForm").validate({
			
			rules : {
				newPassword : {
					required : true,
					minlength: 10,
					capitals: true,
				},
				confirmNewPassword : {
					required : true,		
					equalTo : "#newPassword"  
				}
			},
			messages : {			
				newPassword: {
					minlength: "Password too short, make it at least 10 characters",
					capitals: "Field must contain a capital letter",
				},
				confirmNewPassword : {
					equalTo : "Passwords do not match"
				}
			},
			errorClass : "error"
		});
	});
</script>

<c:url var="formAction" value="/changePassword"/>

<form class="changePassForm" action="${formAction}" method="POST">
		<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}"/>
	<div class="row">
		<div class="col-sm-4"></div>
		<div class="col-sm-4">
		<div class="form-group">
			<label for="oldPassword">Current password: </label>
			<input type="password" name="oldPassword" id="oldPassword" placeHolder="Confirm Old Password" class="form-control" required>
		</div>
		<div class="form-group">
			<label for="newPassword">New Password: </label>
			<input type="password" id="newPassword" name="newPassword" placeHolder="New Password (at least 10 characters and 1 capital)" class="form-control" required/>
		</div>
		<div class="form-group">
			<label for="confirmNewPassword">Confirm New Password: </label>
			<input type="password" id="confirmNewPassword" name="confirmNewPassword" placeHolder="Re-Type Password" class="form-control" required                                                                                                                                        />	
		</div>
		<button type="submit" class="btn btn-default"><c:out value="Change password" /></button>
	</div>
	<div class="col-sm-4"></div>
	</div>
</form>

<c:import url="/WEB-INF/jsp/footer.jsp" />