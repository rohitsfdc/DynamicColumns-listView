public class RG_RestAPIFromSalesforce {
    
    //This class will call salesforce rest apis to get listviews details to show inside pageBlockTable
    
    String objectApiName='Account'; //change this to the API name of your object
    String listViewId = '00B90000001pvnc'; //i am hard-coding for the example, you can query this from listView object
    //Example
    //SELECT Id FROM ListView where SobjectType='Account' and isSoqlCompatible=true and DeveloperName='AllAccounts'
    String restApiURL = URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v32.0/sobjects/'+objectApiName+'/listviews/'+listViewId+'/describe';
    String query ='';
    public list<String> listOfFields {get;set;}
    
    public list<sObject> queryResults {get;set;}
   
    public void createConnection(){
       // system.debug('restApiURL'+restApiURL);
       
       
         HttpRequest Httprequest = new HTTPRequest();
         Httprequest.setMethod('GET');
         HttpRequest.setHeader('Authorization','OAuth '+UserInfo.getSessionId());
          HttpRequest.setHeader('Authorization','Bearer '+UserInfo.getSessionId());
          HttpRequest.setEndPoint(restApiURL);
          String response='';
          
          try{
              
           Http http = new Http();   
		 HttpResponse httpResponse = http.send(httpRequest);  
		 if (httpResponse.getStatusCode() == 200 ) {  
	        Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(httpResponse.getBody());
	        query=(String)root.get('query'); //get the query from response
	       // system.debug('query=='+query);
	      //  system.debug('columns=='+root.get('columns')); 
	        list<object> column = (list<object>)root.get('columns');
	       
	        
	        for(object s : column){
	            map<String,object> i = (map<String,object>)s;
	            listOfFields.add((String)i.get('fieldNameOrPath'));
	        }
		 } else {  
			   System.debug(' httpResponse ' + httpResponse.getBody() );  
			   throw new CalloutException( httpResponse.getBody() );  
		 }   
            } catch( System.Exception e) {  
	        	 System.debug('ERROR: '+ e);  
		         throw e;  
            }  
     //   System.debug(' ** response ** : ' + response );  
        
        
    }
    
    
   public RG_RestAPIFromSalesforce(){
      listOfFields= new list<String>();
        queryResults = new list<sObject>();
        createConnection();
        
        if(String.isNotBlank(query))
        queryResults = database.query(query);
    }


}