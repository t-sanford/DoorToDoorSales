<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:import url="/WEB-INF/jsp/header.jsp" />

<h2><c:out value="Sales Data" /></h2>

<c:url var="formAction" value="/salesData" />
<form method = "GET" action = "${formAction }">
		<label for="sort"><c:out value="Sort By:" /></label> 
		<select name="sort"	id="sort">
			<option value="resident"><c:out value="Resident" /></option>
			<option value="userId"><c:out value="Salesman" /></option>
			<option value="status"><c:out value="Status" /></option>
		</select>
<input type = "submit" value = "Get Data"/>

</form>

<div class = "teamTable">
<table class="table">
<tr>
	<th><c:out value="Resident" /></th>
	<th><c:out value="Address" /></th>
	<th><c:out value="Salesman" /></th>
	<th><c:out value="Current Status" /></th>
</tr>

	<c:forEach var = "house" items = "${houses }">
	
	<c:url var = "houseDetail" value = "/houseDetail?houseId=${house.houseId }"/>
	<c:if test = "${house.assignmentId != null}">
		<tr>
		<td><a class = "nameLink" href = "${houseDetail}"><c:out value = "${house.resident }"/></a></td>
		<td><c:out value = "${house.address} ${house.city }, ${house.state } "/></td>
		<td><a class = "nameLink" href ="#"><c:out value = "${house.assignmentId }"/></a></td>
		<td>
			<c:choose>
				<c:when test="${house.status == 'NV'}"><c:out value="Not Visited" /></c:when>
				<c:when test="${house.status == 'NI'}"><c:out value="Not Interested" /></c:when>
				<c:when test="${house.status == 'O'}"><c:out value="Order Placed" /></c:when>
				<c:when test="${house.status == 'CL'}"><c:out value="Closed" /></c:when>
				<c:when test="${house.status == 'FU'}"><c:out value="Follow Up Required" /></c:when>
			</c:choose>
		</td>
		</tr>
		</c:if>

	</c:forEach>
</table>

<table class="table">
	<tr>
	<th>Product</th>
		<c:forEach var="product" items="${products}">
			<td><c:out value="${product.name}"/></td>
		</c:forEach>
	</tr>
	<tr>
		<th>Units Sold</th>
		<c:forEach var="quantity" items="${quantities}">
			<td><c:out value="${quantity}"/></td>
		</c:forEach>
	</tr>
	<tr>
	<th>Total Revenue</th>
		<c:forEach var="total" items="${totals}">
			<td>$<c:out value="${total}"/></td>
		</c:forEach>
	</tr>
</table>





</div>

<c:import url="/WEB-INF/jsp/footer.jsp" />