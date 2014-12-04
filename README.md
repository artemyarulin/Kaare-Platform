# Kaare-Platform
Kaare wrappers around native platform API

# Functionality
`httpRequest(url,[requestOptions])  -> Rx.Observable`
```
  Kaare.platform.httpRequest(url,{method:'POST',body:'Hello=world'}).subscribe(
    function(response) { console.log(response.statusCode, response.body) },
    function(error)    { console.error(error) },
    function()         { console.log('Done') })
```

`xPath(documentString,xpathQuery,isHTML) -> Rx.Observable`
```
  Kaare.platform.xPath(doc,xpath,[true]).subscribe(
    function(foundOccurrence) { console.log(foundOccurrence) },
    function(error)           { console.error(error) },
    function()                { console.log('Done') })
```

Both API combined:
```
Kaare.platform.httpRequest('http://google.com')
  .map(function(response)       { return response.body })
  .map(function(body)           { return Kaare.platform.xPath(body,'//input/@value') })
  .map(function(inputValue)     { return 'Found name with value: ' + inputValue })
  .subscribe(function(logEntry) { console.log(logEntry) })
```  
