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
		var text_length;
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
	  		text_length = locations[i].body.length;
	  		var plainText = true;
	  		if(text_length >= 10000){
	  			plainText = false;
	  		}
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
	  		
	  		var marker;
	  		if(Boolean(plainText) == true){
	  			marker = new google.maps.Marker({
	      			position: centerPoint,
	      			map: map,
	      		// the display text when the marker is on hover
	      			title: locations[i].body
	  			});
	  			
	  			infowindow = new google.maps.InfoWindow({
      				content: '<br> Loaction: ('+ locations[i].latitude + ', ' + locations[i].longitude + ')' + '</br>'
      						+ '<br>'+ locations[i].body + '</br>'
  			 	});
	  		}
	  		else {
	  			marker = new google.maps.Marker({
	      			position: centerPoint,
	      			map: map,
	      		// the display text when the marker is on hover
	      			title: "Image"
	  			});
	  			// decode the string first
	  			infowindow = new google.maps.InfoWindow({
      				content: '<br> Loaction: ('+ locations[i].latitude + ', ' + locations[i].longitude + ')' + '</br>'
      						+ '<br>'+ '<IMG BORDER="0" ALIGN="Left" SRC="data:image/png;base64,'+ locations[i].body + '"/>' + '</br>'

  			 	});
	  		}
	  	// render the info window

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

	function deserialize(data, canvas) {
	    var img = new Image();
	    img.onload = function() {
	        canvas.width = img.width;
	        canvas.height = img.height;
	        canvas.getContext("2d").drawImage(img, 0, 0);
	    };

	    img.src = data;
	}

	// deal with infowindow and autocenter
	function listenMarker (marker, infowindow){
	    google.maps.event.addListener(marker, 'click', function() {
	                        infowindow.open(map, marker);
	                     //   var bounds = new google.maps.LatLngBounds();
	                     //   bounds.extend(marker.position);
	                     //   map.fitBounds(bounds);
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
