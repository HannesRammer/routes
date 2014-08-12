library routing.server;
import "dart:io";
import 'dart:async';
import "package:route/server.dart";
import 'package:params/server.dart';

initRouter(String rootPath,server,serverRoutes){
  List urls = [];
  serverRoutes.forEach((k,v){
    urls.add(serverRoutes[k]['url']);
  }); 
  
  var router = new Router(server);
  //router.filter(matchesAny(urls), authFilter);
  
  serverRoutes.forEach((String routeName,Map route){
    
    String method = ""; 
    if(route['method'] == 'GET' || route['method'] == 'POST'){
      method = route['method'];
    }
    
    Stream<HttpRequest> serve = null;
    if(method == ""){
      serve = router.serve(route['url']);  
    }else{
      serve = router.serve(route['url'], method: route['method']);
    }
    
    serve.listen((HttpRequest req){
        initParams(req);
        HttpResponse res = req.response;
        print("${req.method}: ${req.uri.path}");
        String path = req.uri.path;
        addCorsHeaders(res);
        route['action'](params,res);
    });
  });
  router.defaultStream.listen(defaultHandler);
}

/**
 * Add Cross-site headers to enable accessing this server from pages
 * not served by this server
 * 
 * See: http://www.html5rocks.com/en/tutorials/cors/ 
 * and http://enable-cors.org/server.html
 */
void addCorsHeaders(HttpResponse res) {
  res.headers.add("Access-Control-Allow-Origin", "*, ");
  res.headers.add("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
  res.headers.add("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
}

void defaultHandler(HttpRequest req) {
  HttpResponse res = req.response;
  addCorsHeaders(res);
  res.statusCode = HttpStatus.NOT_FOUND;
  closeResWith(res,"Not found: ${req.method}, ${req.uri.path}");
}

closeResWith(HttpResponse res,String object){
  res.write(object);
  res.close();
}