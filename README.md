ROUTES

simple server routing via simple routes.dart map file

builds on route and params package 

1.add dependencies to pubspec

  route: ">=0.4.6 <0.5.0"
  routes: ">=0.0.1 <0.1.0"

2. create the simple server  

      HttpServer.bind("127.0.0.1", 8079).then((server) {
      
        //here is the magic
        var router = initRouter(server, serverRoutes);
      
        print("Listening for GET and POST on http://127.0.0.1:8079");
      }, onError: printError);
      
     
     initRouter(rootPath, server, serverRoutes); 
     generates a router using the serverRoutes specified inside the routes.dart file
     
      
ROUTES
------

  projectRootFolder/routes.dart
 
      part of sampleServerGui;
      
      final Map serverRoutes={
        'byeJs':{'url':new UrlPattern(r'/byeJs'),'action': byeJs },
        'helloDart':{'url':new UrlPattern(r'/helloDart'),'method':'GET','action': helloDart }
      };
  
        

SERVER
------

  projectRootFolder/bin/simpleServer.dart

      library sampleServerGui;
      
      import "dart:io";
      import 'dart:convert';
      import 'package:route/url_pattern.dart';
      import 'package:routes/server.dart';
      
      part '../routes.dart';
      
      void main() {
        HttpServer.bind("127.0.0.1", 8079).then((server) {
          var router = initRouter(server, serverRoutes);
          print("Listening for GET and POST on http://$HOST:$PORT");
        }, onError: printError);
      }
      
      void printError(error) => print(error);
      
      helloDart(Map params, HttpResponse res){
        Map map = {"language":params["language"]};
        if(params["language"] == "Dart"){
          map["text"]="Hello";
        }else{
          map["text"]="GOODBYE";
        }
        print(map.toString());
        res.write(JSON.encode(map));
        res.close();
      }

