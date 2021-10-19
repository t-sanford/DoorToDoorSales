<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://sargue.net/jsptags/time" prefix="javatime"%>

<c:import url="/WEB-INF/jsp/header.jsp" />

<div class="houseDetailWrapper">
	<h2 class="houseDetailHeader">
		<c:out value="Information on ${house.resident}'s House:" />
	</h2>
	<div class="detailTable">
		<table class="table table-striped">
			<tr>
				<td><c:out value="Address" /></td>
				<td><c:out value="${house.address}" /></td>
			</tr>
			<tr>
				<td><c:out value="Resident" /></td>
				<td><c:out value="${house.resident}" /></td>
			</tr>
			<tr>
				<td><c:out value="Phone Number" /></td>
				<td><c:out value="${house.phoneNumber}" /></td>
			</tr>
			<tr>
				<td><c:out value="Created By" /></td>
				<td><c:out value="${house.creatorId}" /></td>
			</tr>
			<tr>
				<td><c:out value="Assigned To" /></td>
				<td><c:out value="${house.assignmentId}" /></td>
			</tr>

			<tr>
				<td><c:out value="Current Status: " /> <strong> <c:choose>
							<c:when test="${house.status == 'NV'}">
								<c:out value="Not Visited" />
							</c:when>
							<c:when test="${house.status == 'NI'}">
								<c:out value="Not Interested" />
							</c:when>
							<c:when test="${house.status == 'O'}">
								<c:out value="Order Placed" />
							</c:when>
							<c:when test="${house.status == 'CL'}">
								<c:out value="Closed" />
							</c:when>
							<c:when test="${house.status == 'FU'}">
								<c:out value="Follow Up Required" />
							</c:when>
						</c:choose>
				</strong></td>
				<td><c:url var="formAction" value="/updateStatus" />
					<form action="${formAction}" method="POST">
						<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}" /> <input
							type="hidden" name="houseId" value="${house.houseId}" /> <input
							type="hidden" name="username" value="${currentUser.userName}" />
						<select name="status">
							<option disabled selected>
								<c:out value="-- Update Status --" />
							</option>
							 
							<c:if test="${house.status != 'FU'}">
								<option value="FU"><c:out value="Follow Up" /></option>
							</c:if>
							<c:if test="${house.status != 'NV'}">
								<option value="NV"><c:out value="Not Visited" /></option>
							</c:if>
							<c:if test="${house.status != 'NI'}">
								<option value="NI"><c:out value="Not Interested" /></option>
							</c:if>
							<c:if test="${house.status != 'O'}">
								<option value="O"><c:out value="Ordered" /></option>
							</c:if>
							<c:if test="${house.status != 'CL'}">
								<option value="CL"><c:out value="Closed" /></option>
							</c:if>
						</select>
						<button type="submit" class="btn btn-submit">
							<c:out value="Update" />
						</button>
					</form></td>
			</tr>
		</table>
	</div>

	<div class="mapouter">
		<div class="gmap_canvas">
			<iframe width="100%" height="400px" id="gmap_canvas"
				src="https://maps.google.com/maps?q=${house.address}${house.city}${house.state}&t=&z=13&iwloc=&output=embed"
				frameborder="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
			<a href="https://www.pureblack.de">webdesigner</a>
		</div>
		<style>
.mapouter {
	text-align: right;
	height: 500px;
	width: 600px;
}

.gmap_canvas {
	overflow: hidden;
	background: none !important;
	height: 500px;
	width: 600px;
}
</style>

</div>
<div class = "noteTable">
<table  >
	<tr>
		<th><c:out value="Note" /></th>
		<th><c:out value="Timestamp" /></th>
	</tr>
	<c:forEach var="note" items="${notes}">
		<tr class = "noteTableRow">
			<td id = "noteText"><c:out value="${note.text}" /></td>
			
			<td><c:out value="${note.formattedTimestamp}" /></td>
		</tr>
		
	</c:forEach>
</table>
<c:url var="addNoteUrl" value="/addNote"/>
<form action="${addNoteUrl}" method="POST">
	<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}"/>
	<input type ="hidden" name = "creatorId" value = "${currentUser.userName}"/>
	<input type="hidden" name="houseId" id="houseId" value="${house.houseId}"/>
	
		<label for="text"><c:out value="Note: " /></label>
		<textarea  name="text" class="form-control" required></textarea>
		<input type="submit" value="Submit Note"class="btn btn-primary" />

</form>
<c:url var="sellProductUrl" value="/newSale"/>
<form action="${sellProductUrl}" method="POST">
	<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}"/>
	<table class="table">
	<tr>
		<th><c:out value="Product" /></th>
		<th><c:out value="Price" /></th>
		<th><c:out value="Quantity" /></th>
	</tr>
	<c:forEach var="product" items="${products}">
	<tr>
		<td><c:out value="${product.name}"/></td>
		<td>$<c:out value="${product.price}"/></td>
		<td><input type="hidden" name="productId" value="${product.id}"><input type="number" name="quantity" min="0" value="0" required></td>
	</tr>
	</c:forEach>
	<tr>
		<th><c:out value="Total:" /></th>
	</tr>
	</table>
	<input type="hidden" name="houseId" id="houseId" value="${house.houseId}"/>
	<input type="submit" value="Finalize Sale" class="btn btn-primary">
</form>
</div>

	</div>
	

<c:import url="/WEB-INF/jsp/footer.jsp" />