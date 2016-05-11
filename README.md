##ROUTES 0.1.3
-------

Is a simple server routing via a single routes.dart file

routes builds on route and params package 
[route](https://pub.dartlang.org/packages/route)
and
[params](https://pub.dartlang.org/packages/params)

1. add dependencies to pubspec

       route: "^0.4.6"
       
       routes: "^0.1.4"

2. create a routes file
###ROUTES

 inside projectRootFolder/routes.dart
 
       part of sampleServerGui;
      
       final Map serverRoutes={
         'byeJs':{'url':new UrlPattern(r'/byeJs'),'action': byeJs,'async':true },
         'helloDart':{'url':new UrlPattern(r'/helloDart'),'method':'GET','action': helloDart }
       };
  
  here we see 2 routes **'byeJs'** and **'helloDart'**
  
  routes always have a 
  
  **url -> url pattern** and an 
  
  **action -> called method** and an optional
  
  **method -> that currently handels 'PUT' and 'GET'**

3. create the simple server with functions for each specified action (helloDart,byeJs)
###SERVER

  projectRootFolder/bin/simpleServer.dart

       library sampleServerGui;
       
       import "dart:io";
       import 'dart:convert';
       import 'package:route/url_pattern.dart';
       import 'package:routes/server.dart';
      
       part '../routes.dart';
       
       final String HOST = "127.0.0.1"; // eg: localhost
       
       final num PORT = 8079;
       
       main() async {
           var server = await HttpServer.bind(HOST, PORT);
           var router = initRouter(server, serverRoutes);
           print("Listening for GET and POST on http://$HOST:$PORT");
       }
      
       void printError(error) => print(error);
      
       helloDart(Map params, HttpResponse res){
         Map newMap = {"language":params["language"]};
         if(params["language"] == "Dart"){
           newMap["text"]="Hello";
         }else{
           newMap["text"]="GOODBYE";
         }
         res.write(JSON.encode(newMap));
         res.close();
       }

       byeJs(Map params, HttpResponse res){
         //do stuff
       }


now you can talk to the server eg with 
**http://127.0.0.1:8079/helloDart?language=Dart**

------------------
###WHATS HAPPENING
------------------
the Magic happens here
      
      var router = initRouter(server, serverRoutes);
      
it automatically generates a router that will use the specified routes in routes.dart

the action specified inside the routes will recieve 2 parameters 

**a Map params **-> including the parameters send in the request
**a HTTPResponse res **

------

Download a working example [here](https://github.com/HannesRammer/dart-server-client-sample-code)
