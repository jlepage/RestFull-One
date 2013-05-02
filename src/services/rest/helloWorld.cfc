component {

	/**
	* @uri /helloWorld/sayHello/:name
	* @method GET
	**/
	function helloWorld(params, ids) {
		local.add = '';
		if (isDefined('params.author'))	local.add = ' by ' & params.author  ;
		return 'Hello World, ' & ids.name & '!' & add  ;
	}
	
}