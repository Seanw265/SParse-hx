# SParse-hx

NOTE: Parse has announced they are discontinuing their services. The Parse server is now available for download and this code should work with that. 

SParse uses Parse's REST API to communicate with Parse's servers.

I named it SParse because:
- It does not conform to any specific Parse API structure
- It is currently sparsely populated, it doesn't have a lot of the features you might typically have in an official Parse API
- My first name starts with S

No documentation really. I made it just for my own purposes. Look through the code I think it's pretty self explanatory.

If you have any questions just ask!

ALSO, I'm sure there's a ton of bugs. So uh beware of that, it hasn't been fully tested yet.

I won't be held responsible for any intended/unintended consequences of your use of this API.

## Dependencies
Currently one:
-https://github.com/yupswing/akifox-asynchttp

## Example
	var parse = new SParse("YOUR-APP-ID","YOUR-API-KEY");
	
	parse.login("username","password",myCallback);
	
	parse.saveObject("ClassName",{highscore:222,playerName:"Sean"},myCallback);
