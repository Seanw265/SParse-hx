import com.akifox.asynchttp.*;

class SUser {
	public var objectId:String;
	public var sessionToken:String;
	public var createdAt:String;
	public var username:String;
	public var content:Dynamic;

	public function new(){}
}

class SParse{

	public var currentUser:SUser;
	public var currentSession:String;
	public var applicationId:String = "";
	public var apiKey:String = "";

	public function new(applicationId:String, apiKey:String){
		this.applicationId = applicationId;
		this.apiKey = apiKey;
		currentUser = new SUser();
	}

	public function login(username:String, password:String, ?onComplete:Dynamic->Void=null){
		var request = new HttpRequest({
				url : "https://api.parse.com/1/login?username=" + username + "&password=" + password,
		   callback : function(response:HttpResponse):Void {
		                if (response.isOK) {
		                	if(response.isJson){
		                		var theContent = haxe.Json.parse(response.content);
		                		// trace(theContent.sessionToken);
		                		this.currentUser.objectId = theContent.objectId;
		                		this.currentUser.sessionToken = theContent.sessionToken;
		                		this.currentUser.createdAt = theContent.createdAt;
		                		this.currentUser.username = username;
		                		// this.currentUser.content = theContent;
		                		this.currentSession = theContent.sessionToken;
		                		if(onComplete != null){
			                		onComplete(theContent);
		                		}
		                	}
		                	trace(response.content);
		                	trace('DONE ${response.status}');
		                	
		                } else {
		                	trace('ERROR ${response.status} ${response.error}');
		                }
		              },
		    headers : new HttpHeaders({
		     			"X-Parse-Application-Id": this.applicationId,
		     			"X-Parse-REST-API-Key": this.apiKey
		              }),
		     method : HttpMethod.GET
		});
		request.send();
	}

	public function signUp(params:Dynamic, ?onComplete:Dynamic->Void=null){
		var request = new HttpRequest({
				url : "https://api.parse.com/1/users",
		   callback : function(response:HttpResponse):Void {
		                if (response.isOK) {
		                	if(response.isJson){
		                		var theContent = haxe.Json.parse(response.content);
		                		this.currentUser.objectId = theContent.objectId;
		                		this.currentUser.sessionToken = theContent.sessionToken;
		                		this.currentUser.createdAt = theContent.createdAt;
		                		this.currentUser.username = theContent.username;
		                		this.currentUser.content = theContent;
		                		this.currentSession = theContent.sessionToken;
		                		if(onComplete != null){
			                		onComplete(theContent);
		                		}
		                	}
		                	trace(response.content);
		                	trace('DONE ${response.status}');
		                	
		                } else {
		                	trace('ERROR ${response.status} ${response.error}  \n${haxe.Json.parse(response.content).error}');
		                }
		              },
		    headers : new HttpHeaders({
		     			"X-Parse-Application-Id": this.applicationId,
		     			"X-Parse-REST-API-Key": this.apiKey
		              }),
		     method : HttpMethod.POST,
		    content : haxe.Json.stringify(params)

		});
		
		request.send();
	}

	public function getObject(className:String, objectId:String, ?onComplete:Dynamic->Void=null){
		var request = new HttpRequest({
				url : "https://api.parse.com/1/classes/"+className+"/"+objectId,
		   callback : function(response:HttpResponse):Void {
		                if (response.isOK) {
		                	if(response.isJson){
		                		var theContent = haxe.Json.parse(response.content);
		                		if(onComplete != null){
			                		onComplete(theContent);
		                		}
		                	}
		                	trace(response.content);
		                	trace('DONE ${response.status}');
		                	
		                } else {
		                	trace('ERROR ${response.status} ${response.error}  \n${haxe.Json.parse(response.content).error}');
		                }
		              },
		    headers : new HttpHeaders({
		     			"X-Parse-Application-Id": this.applicationId,
		     			"X-Parse-REST-API-Key": this.apiKey,
		     			"X-Parse-Session-Token": this.currentSession
		     			//"Content-Type": "application/json"
		              })

		});
		
		request.send();
	}

	public function query(className:String, ?params:Dynamic=null, ?onComplete:Dynamic->Void=null){
		var request = new HttpRequest({
				url : "https://api.parse.com/1/classes/"+className+"?"+encodeAnonymousStructureToURL(params),
		   callback : function(response:HttpResponse):Void {
		                if (response.isOK) {
		                	if(response.isJson){
		                		var theContent = haxe.Json.parse(response.content);
								if(onComplete != null){
			                		onComplete(theContent);
		                		}		                	}
		                	trace(response.content);
		                	trace('DONE ${response.status}');
		                	
		                } else {
		                	trace('ERROR ${response.status} ${response.error}  \n${haxe.Json.parse(response.content).error}');
		                }
		              },
		    headers : new HttpHeaders({
		     			"X-Parse-Application-Id": this.applicationId,
		     			"X-Parse-REST-API-Key": this.apiKey,
		     			"X-Parse-Session-Token": this.currentSession
		     			//"Content-Type": "application/json"
		              }),
		    content : haxe.Json.stringify(params)

		});
		
		request.send();
	}

	public function saveObject(className:String, anonymousStructure:Dynamic, ?onComplete:Dynamic->Void=null):Void{
		// This is a basic Post example
		var request = new HttpRequest({
				url : "https://api.parse.com/1/classes/" + className,
		   callback : function(response:HttpResponse):Void {
		                if (response.isOK) {
		                	if(response.isJson){
		                		var theContent = haxe.Json.parse(response.content);
		                		if(onComplete != null){
			                		onComplete(theContent);
		                		}
		                	}
		                	trace(response.content);
		                	trace('DONE ${response.status}');
		                	
		                } else {
		                	trace('ERROR ${response.status} ${response.error}  \n${haxe.Json.parse(response.content).error}');
		                }
		              },
		    headers : new HttpHeaders({
		     			"X-Parse-Application-Id": this.applicationId,
		     			"X-Parse-REST-API-Key": this.apiKey,
						"X-Parse-Session-Token": this.currentSession
		              }),
		     method : HttpMethod.POST,
		    content : haxe.Json.stringify(anonymousStructure)

		});
		
		request.send();
	}

	private function encodeAnonymousStructureToURL(anonymousStructure):String{
		var fields = Reflect.fields(anonymousStructure);
		var strings = new Array();
		for(field in fields){
			var newString = "";
			newString = field + "=" + Reflect.field(anonymousStructure,field);
			strings.push(newString);
		}
		return strings.join("&");
	}
}