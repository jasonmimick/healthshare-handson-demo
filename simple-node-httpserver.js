var http = require('http');

var server = http.createServer(function(request, response) {
		if (request.method == 'POST') {
            var postData= '';
            request.on('data', function (data) {
                postData += data;
            });
            request.on('end', function () {
                 console.log(postData);
				console.dir( request.headers );
   				response.writeHead(200, { "content-type" : "text/html" });
				response.write("Read:" + postData.length + " characters\n");
				response.write("TimeStamp: " + (new Date()));
				response.end();
         });
        }

	//console.dir(request);
});

var port = 9292;
server.listen( port );
console.dir("Server listening on " + port);

