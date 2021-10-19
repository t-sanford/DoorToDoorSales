<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:import url="/WEB-INF/jsp/header.jsp" />
<link rel="stylesheet"
	href="https://unpkg.com/leaflet@1.3.3/dist/leaflet.css"
	integrity="sha512-Rksm5RenBEKSKFjgI3a41vrjkw4EVPlJ3+OiI65vTjIdo9brlAacEuKOiQ5OFh7cOI1bkDwLqdLw3Zg0cRJAAQ=="
	crossorigin="" />
<script src="https://unpkg.com/leaflet@1.3.3/dist/leaflet.js"
	integrity="sha512-tAGcCfR4Sc5ZP5ZoVz0quoZDYX5aCtEm/eu1KhSLj2c9eFrylXZknQYmxUssFaVJKvvc0dJQixhGjG2yXWiV9Q=="
	crossorigin=""></script>

<div class="tableDiv">
<table id="houseTable" class="table">
	<tr>
		<th><c:out value="Resident Name" /></th>
		<th><c:out value="Address" /></th>
		<th><c:out value="Phone Number" /></th>
		<th><c:out value="Assigned To" /></th>
		<th><c:out value="Change Assignment"></c:out></th>
		<th></th>

	</tr>

	<c:forEach var="house" items="${houses}">
	<c:url var = "houseDetail" value = "/houseDetail?houseId=${house.houseId}"/>
		<tr class="table-row">
			<td><a href="${houseDetail}"><c:out value = "${house.resident}"/></a></td>
			<td class="address"><a href="${houseDetail}"><c:out value="${house.address} ${house.city}, ${house.state} " /></a></td>
			<td><a href="${houseDetail}"><c:out value="${house.phoneNumber}" /></a></td>
			<td><c:choose>
					<c:when test="${house.assignmentId == null }">
						<c:out value="Not Assigned" />
					</c:when>
					<c:otherwise>
						<c:out value="${house.assignmentId }" />
					</c:otherwise>
				</c:choose></td> 
			<td><c:url var="formAction" value="/updateAssignment" />
				<form action="${formAction }" method="POST">
					<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}" /> <input
						type="hidden" name="houseId" value="${house.houseId}" /> <select
						name="assignmentId">
						<option value="null"  selected><c:out
								value="-----SELECT AN OPTION-----" /></option>
						<c:forEach var="team" items="${teamMembers }">
							<c:if test="${team.role == 'Salesman' }">
								<c:if test="${house.assignmentId != team.userName }">
									<option value="${team.userName }"><c:out
											value="${team.userName }" />
									</option>
								</c:if>
							</c:if>
						</c:forEach>
						<c:if test="${house.assignmentId != null }">
							<option value=""><c:out value="Remove Assignment" /></option>
						</c:if>
					</select>
					<button type="submit" class="btn">
						<c:out value="Update" />
					</button>
				</form></td>
		</tr>
	</c:forEach>
	
</table>
</div>
<br>
<br>
<div class='my-legend'>
<div class='legend-scale'>
  <ul class='legend-labels'>
    <li><span style='background:#D50000;'></span>Not Visited</li>
    <li><span style='background:#00D500;'></span>User Location</li>
    <li><span style='background:#699bea;'></span>Ordered</li>
    <li><span style='background:#8a2be2;'></span>Follow Up</li>
    <li><span style='background:#000000;'></span>Not Interested</li>
    <li><span style='background:#808080;'></span>Closed</li>
  </ul>
</div>
</div>

<style type='text/css'>
  .my-legend .legend-title {
    text-align: left;
    margin-bottom: 5px;
    font-weight: bold;
    font-size: 90%;
    }
  .my-legend .legend-scale ul {
    margin: 0;
    margin-bottom: 5px;
    padding: 0;
    float: left;
    list-style: none;
    }
  .my-legend .legend-scale ul li {
    font-size: 90%;
    list-style: none;
    margin-left: 0;
    line-height: 18px;
    margin-bottom: 2px;
    }
  .my-legend ul.legend-labels li span {
    display: block;
    float: left;
    height: 16px;
    width: 30px;
    margin-right: 5px;
    margin-left: 0;
    border: 1px solid #999;
    }
  .my-legend .legend-source {
    font-size: 70%;
    color: #999;
    clear: both;
    }
  .my-legend a {
    color: #777;
    }
</style>
<div class="container-fluid">
<div id="mapid"></div>
</div>
<style>
#mapid {
	height: 50rem;
	width: 100rem;
	margin: auto;
	border: .25rem gray solid;
}
</style>
<script>
let house = document.getElementsByClassName("address"); 																					
let houses=[];
let z=0;
	<c:forEach var="house" items="${houses}">
		houses[z]=
		{
					address:"${house.address}"+", "+"${house.city}"+", "+"${house.state}",
					status:"${house.status}",
					resident:"${house.resident }",
					phoneNumber:"${house.phoneNumber}",
		}
		z+=1;	
		
		</c:forEach>

	// variables
	// map from leaflet
	var mymap = L.map('mapid').setView([ 41.4993, -81.6944 ], 9); 																				// map from leaflet
	let marker = []; 																															// array for marker variables

	//marker Icon colors																														// usage is: L.marker([location]], {icon: greenIcon}).addTo(map);
	let markerColor={
	red : new L.Icon({																														
		  iconUrl: 'https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png',
		  shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
		  iconSize: [25, 41],
		  iconAnchor: [12, 41],
		  popupAnchor: [1, -34],
		  shadowSize: [41, 41]
		}),
	
	green : new L.Icon({
		  iconUrl: 'https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-green.png',
		  shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
		  iconSize: [25, 41],
		  iconAnchor: [12, 41],
		  popupAnchor: [1, -34],
		  shadowSize: [41, 41]
		}),
	
	
	black : new L.Icon({
		  iconUrl: 'https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-black.png',
		  shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
		  iconSize: [25, 41],
		  iconAnchor: [12, 41],
		  popupAnchor: [1, -34],
		  shadowSize: [41, 41]
		}),
	
	orange : new L.Icon({																														
		  iconUrl: 'https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-orange.png',
		  shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
		  iconSize: [25, 41],
		  iconAnchor: [12, 41],
		  popupAnchor: [1, -34],
		  shadowSize: [41, 41]
		}),
	
	yellow : new L.Icon({																														
		  iconUrl: 'https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-yellow.png',
		  shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
		  iconSize: [25, 41],
		  iconAnchor: [12, 41],
		  popupAnchor: [1, -34],
		  shadowSize: [41, 41]
		}),
	
	violet : new L.Icon({																														
		  iconUrl: 'https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-violet.png',
		  shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
		  iconSize: [25, 41],
		  iconAnchor: [12, 41],
		  popupAnchor: [1, -34],
		  shadowSize: [41, 41]
		}),
	
	grey : new L.Icon({																														
		  iconUrl: 'https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-grey.png',
		  shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
		  iconSize: [25, 41],
		  iconAnchor: [12, 41],
		  popupAnchor: [1, -34],
		  shadowSize: [41, 41]
		})
	};
	
	// map and layers
	L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}',
					{
						attribution : 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>,Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
						maxZoom : 18,
						id : 'mapbox.streets',
						accessToken : 'pk.eyJ1IjoiZXRhY2FscGhhIiwiYSI6ImNqbDJ4M2w5bTF2ODQzcHA0bzlxMDc3dzQifQ.nGrjnJwmCl7mG46Fy01_LQ'
					}).addTo(mymap);

	//geocoding
	for (var i = 0; i < houses.length; i++) { 																									// loop to reverse geocode address and add marker 
	let resident=houses[i].resident;
	let phoneNumber=houses[i].phoneNumber;
	let address=houses[i].address;
	let status=houses[i].status;
		var request = new XMLHttpRequest(); 																									// front end API call object
		request.open('GET','http://www.mapquestapi.com/geocoding/v1/address?key=Mtbu18nHxlnliiqzIQuzjPlbm3zUrdQk&location='+ houses[i].address, true); 	// api call
		request.onload = function() {																											// function to get data from api and parse as JSON

			// Begin accessing JSON data here
			var data = JSON.parse(this.response);
			let lat = (data.results[0].locations[0].displayLatLng.lat); 																		// assign latitude from api jason
			let lng = (data.results[0].locations[0].displayLatLng.lng);																			// assign longitude form api json

			//address markers
			// status are NV, O, FU, CL, NI
			switch (status) {
			  case 'NV':
					marker[i] = L.marker([ lat, lng ],{icon: markerColor.red}).addTo(mymap); 
				break;
			  case 'O':
					marker[i] = L.marker([ lat, lng ]).addTo(mymap); 
				break;
			  case 'FU':
					marker[i] = L.marker([ lat, lng ],{icon: markerColor.violet}).addTo(mymap); 
				break;
			  case 'CL':
					marker[i] = L.marker([ lat, lng ],{icon: markerColor.grey}).addTo(mymap); 
				break;
			  case 'NI':
					marker[i] = L.marker([ lat, lng ],{icon: markerColor.black}).addTo(mymap); 
				break;
			}
			
																				// place marker

			//popups
			marker[i].bindPopup(resident+"<BR>"+address+"<BR>"+phoneNumber+"<BR>"+status).openPopup(); 											// create popup on each marker that says address
		}
		request.send();																													 // I assume that this is sending the request to API and the above works on a promise

	}
	
	//user Location
	let userLocation="";
	var watchID = navigator.geolocation.watchPosition(function(location) {																		// watch for location of user time to update ???
		 	userLocation=location.coords.latitude, location.coords.longitude;																	//set user location
			let userLocationMarker=L.marker([location.coords.latitude, location.coords.longitude],{icon: markerColor.green}).addTo(mymap);								// place marker for user on map
			userLocationMarker.bindPopup("I am You");																							// pop for user marker
	});
	
	//send location to database
	$( '#submit_btn' ).click( function( data ){ 																								//method to auto send user location
    locationForm = document.getElementById( 'locationForm' );
    $("location").val()=userLocation; 
    locationForm.submit();
});

</script> 

<c:import url="/WEB-INF/jsp/footer.jsp" />
