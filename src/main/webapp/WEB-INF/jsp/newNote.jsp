<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:import url="/WEB-INF/jsp/header.jsp" />

<c:url var="addNoteUrl" value="/addNote"/>
<form action="${addNoteUrl}" method="POST">
	<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}"/>
	<input type ="hidden" name = "creatorId" value = "${currentUser.userName}"/>
	<input type="hidden" name="houseId" id="houseId" value="${house.houseId}"/>
	
		<label for="text"><c:out value="Note: " /></label>
		<textarea  name="text" class="form-control" required></textarea>
		<input type="submit" value="Submit Note!" />

</form>



<c:import url="/WEB-INF/jsp/footer.jsp" />