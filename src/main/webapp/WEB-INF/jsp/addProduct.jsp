<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:import url="/WEB-INF/jsp/header.jsp" />

<div class="row">
	<div class="col-sm-4"></div>
	<div class="col-sm-4">
	<div>
	<c:url var="addProductUrl" value="/addProduct"/>
	<form action="${addProductUrl}" method="POST">
	<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}"/>
		
			Product Name: *<br><input type="text" name="name" class="form-control" required><br>
			Price: *<br>$<input type="number" name="price" min="0" value="0" step=".01" class="form-control" required><br>

			<button type = "submit" class = "btn btn-default"><c:out value = "Submit"/></button>
		
	</form></div>
	
	</div>
	<div class="col-sm-4"></div> 
</div> 

<c:import url="/WEB-INF/jsp/footer.jsp" />