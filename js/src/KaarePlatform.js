Kaare = Kaare || {} //jshint ignore:line

Kaare.Platform = function (kaare) {
  var _prefix = 'platform.',
    _kaare = kaare

  this.httpRequest = (url, options) => {
  	if (typeof url !== 'string')
  		return Rx.Observable.throw(new Error('httpRequest: url is required parameter and has to be string'))

    let params = options ? [url, options] : [url]
    return _kaare.executeCommand(`${_prefix}httpRequest`, params)
  }
  this.xPath = (doc, query, isHTML) => {
  	if (typeof doc !== 'string' || typeof query !== 'string')
  		return Rx.Observable.throw(new Error('xPath: doc and query are required parameters and have to be strings'))
  	
  	let params = [doc,query, isHTML === 'undefined' ? true : isHTML]
  	return _kaare.executeCommand(`${_prefix}xPath`, [doc, query, isHTML])
  }
}
