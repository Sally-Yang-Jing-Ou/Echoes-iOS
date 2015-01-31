var json;

   $.ajax({
   		type: "GET",
   		url:"https://echoes-ios.herokuapp.com/messages?callback=?",
   		dataType:"jsonp",
   		success: function(data) {
   		     console.log(data);
      	     locations = data;
      	    	
   	    }
   });

	var cityCircle;
	var map;

	function initialize() {
	  	var initialPoint = new google.maps.LatLng(locations[0].latitude, locations[0].longitude);
	  	var infowindow = null;
	  	var bounds = new google.maps.LatLngBounds();
	  	var mapOptions = {
	    	zoom: 10,
	    	center: initialPoint
	  	}
	  	// Initialize the map
	  	map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
	  	map.setMapTypeId(google.maps.MapTypeId.ROADMAP);

	   	// Draw circles on the screen
	  	for (var i = 0; i < locations.length; i++) {
	  	// Add the circle for this city to the map.
	  		var centerPoint = new google.maps.LatLng(locations[i].latitude, locations[i].longitude);
	   		var populationOptions = {
	      		strokeColor: '#FF0000',
	      		strokeOpacity: 0.8,
	      		strokeWeight: 2,
	      		fillColor: '#FF0000',
	      		fillOpacity: 0.35,
	      		map: map,
	      		center: centerPoint,
	      		radius: locations[i].radius
	    	};
	    	cityCircle = new google.maps.Circle(populationOptions);
	  		
	  		var marker = new google.maps.Marker({
	      		position: centerPoint,
	      		map: map,
	      	// the display text when the marker is on hover
	      		title: locations[i].body
	  		});

	  	// render the info window
	  	  	infowindow = new google.maps.InfoWindow({
      			content: locations[i].body
  			 });
			listenMarker(marker,infowindow);
			//createMarkerButton(marker);
	  	}
	  	//map.fitBounds(bounds);
	}
	// function createMarker(map, centerPoint){
	// 	cityCircle = new google.maps.Circle(populationOptions);
	//   	var marker = new google.maps.Marker({
	//     position: centerPoint,
	//     map: map
	// }


	// deal with infowindow and autocenter
	function listenMarker (marker, infowindow){
	    google.maps.event.addListener(marker, 'click', function() {
	                        infowindow.open(map, marker);
	                        var bounds = new google.maps.LatLngBounds();
	                        bounds.extend(marker.position);
	                        map.fitBounds(bounds);
	                    });
	}

	//Creates a sidebar button
	function createMarkerButton(marker) {
	  var ul = document.getElementById("marker_list");
	  console.log(ul);
	  var li = document.createElement("li");
	  var title = marker.getTitle();
	  li.innerHTML = title;
	  ul.appendChild(li);
	  
	  //Trigger a click event to marker when the button is clicked.
	  google.maps.event.addDomListener(li, "click", function(){
	    google.maps.event.trigger(marker, "click");
	  });
	}


	google.maps.event.addDomListener(window, 'load', initialize);
