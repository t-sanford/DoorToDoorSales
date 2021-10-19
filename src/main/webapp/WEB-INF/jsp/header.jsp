<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
	<head>
		<title><c:out value="Team Hat Capstone" /></title>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
		<meta name="viewport" content="width=device-width, initial-scale=1">
	    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
	    <script src="https://cdn.jsdelivr.net/jquery.validation/1.15.0/jquery.validate.min.js"></script>
	    <script src="https://cdn.jsdelivr.net/jquery.validation/1.15.0/additional-methods.js "></script>
	    <script src="https://cdn.jsdelivr.net/jquery.timeago/1.4.1/jquery.timeago.min.js"></script>
	    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
	    <c:url var="cssHref" value="/css/site.css" />
		<link rel="stylesheet" type="text/css" href="${cssHref}">
		
	<c:if test="${message != null}">
		<div class="alert alert-success alert-dismissible" role="alert">
			<c:out value="${message}"/>
		</div>
	</c:if>
	<c:if test="${errorMessage != null}">
		<div class="alert alert-danger alert-dismissible fade in" role="alert">
			<c:out value="${errorMessage}"/>
		</div>
	</c:if>
		
<script type="text/javascript">
			$(document).ready(function() {
				$("time.timeago").timeago();
				
				$("#logoutLink").click(function(event){
					$("#logoutForm").submit();
				});
				
				var pathname = window.location.pathname;
				$("nav a[href='"+pathname+"']").parent().addClass("active");
				
			});
			
			
</script>
		
		
	</head>
	<body>
		<header class = "header">
		<div class = "headerContents">
			
			
		</div>
		<c:url var = "bunny" value = "/img/Bunny.png"/>
		<div id = "headerTextDiv"><h1 id = "headerText" ><c:out value="Maximus Sales" /><a target = "blank" href = "https://www.petfinder.com/search/rabbits-for-adoption/?sort%5B0%5D=recently_added"><img class = "bunnyImg" src = "${bunny }"></a></h1></div>
		<c:if test="${not empty currentUser}">
			<p id="currentUser"><c:out value="Current User: ${currentUser.userName}"/></p>
		</c:if>	
		</header>
		<div>
		<nav class="navbar navbar-default">
		
			<button class = "navbar-toggle" data-toggle ="collapse" data-target = ".navHeaderCollapse">
			<span class = "icon-bar"></span>
			<span class = "icon-bar"></span>
			<span class = "icon-bar"></span>
			
			</button>
			<div class="container-fluid collapse navbar-collapse navHeaderCollapse">
			
				<ul class="nav navbar-nav">
					
					<c:if test="${not empty currentUser}">
					<c:choose>	
						<c:when test ="${currentUser.role == 'Admin' }">
							<c:url var="homePageHref" value="/admin" />
							<li><a href="${homePageHref}">Home</a></li>
							<c:url var = "viewHouses" value = "/viewHouses"/>
							<li><a href = "${viewHouses }">View Houses</a></li>
							<c:url var = "salesData" value = "/salesData"/>
							<li><a href = "${salesData }">Sales Data</a></li>
						</c:when>
						<c:when test = "${currentUser.role == 'Salesman' }">
							<c:url var="homePageHref" value="/salesman" />
						<li><a href="${homePageHref}">Home</a></li>
						</c:when>	
					</c:choose>
					</c:if>
				</ul>
				<ul class="nav navbar-nav navbar-right">
					<c:choose>
						<c:when test="${empty currentUser}">
							<c:url var="newUserHref" value="/users/new" />
							<li><a href="${newUserHref}">Sign Up</a></li>
							<c:url var="loginHref" value="/login" />
							<li><a href="${loginHref}">Log In</a></li>
						</c:when>
						<c:otherwise>
							<c:url var="logoutAction" value="/logout" />
							<form id="logoutForm" action="${logoutAction}" method="POST">
							<input type="hidden" name="CSRF_TOKEN" value="${CSRF_TOKEN}"/>
							</form>
							<li><a id="logoutLink" href="#">Log Out</a></li>
						</c:otherwise>
					</c:choose>
				
				</ul>
				 
			</div>
		</nav>
	</div>	
		<div class="container">
		
			<div class ="main-content">

		