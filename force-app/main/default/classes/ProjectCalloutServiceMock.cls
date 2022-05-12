@isTest
public class ProjectCalloutServiceMock implements HttpCalloutMock {
   //Implement http mock callout here
   public HttpResponse respond(HttpRequest request){
      HttpResponse response = new HttpResponse();
      response.setHeader('Content-Type', 'application/json');
      response.setHeader('token', '29730b7c-16f3-40bc-9ef7-6a1e05d82c10');
      response.setStatusCode(201);
      return response;
   }
}