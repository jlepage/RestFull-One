component {

	function init(fw) {
		variables.fw = arguments.fw;
		variables.restPath = '';
		variables.defaultView = '';
		variables.pathInfo = CGI.PATH_INFO;
		variables.processed = false;
		variables.idName = '';
		variables.idValue = '';
		variables.uriBean = '';
		variables.beanName = '';
		variables.pathArray = arrayNew(1);
		variables.trace = arrayNew(1);
		variables.results = '';
		variables.count = 0;
		variables.error = false;
		variables.message = '';
		variables.debug = true;
		variables.callback = '';
		
	}

	function before(rc) {
	
		// INIT VARS
		variables.restPath = variables.fw.getSection();
		variables.defaultView = variables.restPath & '.default';
		
		if (isDefined('URL.callback'))	variables.callback = URL.callback;
		if (isDefined('FORM.callback'))	variables.callback = FORM.callback;
		
		if (variables.pathInfo eq '') {
			variables.pathInfo = '/' & URL[variables.fw.getAction()];
			variables.pathInfo = replace(variables.pathInfo, '.', '/', 'ALL');
		}
		
		variables.pathInfo = reReplaceNoCase(variables.pathInfo, '^/' & variables.restPath, '');
		variables.pathArray = listToArray(variables.pathInfo, '/');
		
		if (arrayLen(variables.pathArray) >= 3) {
			variables.idValue = variables.pathArray[3];
		}
		
		if (arrayLen(variables.pathArray) >= 2) {
			variables.uriBean = '/' & variables.pathArray[1] & '/' & variables.pathArray[2];
			variables.beanName = variables.pathArray[1];
			
		} else if (arrayLen(variables.pathArray) == 1) {
			variables.uriBean = '/' & variables.pathArray[1] ;
			variables.beanName = variables.pathArray[1];
			
		}
		
		variables.uriBean = uCase(variables.uriBean);
		
		// Try to process bean
		
		if (variables.beanName neq '' && variables.fw.getBeanFactory().containsBean(variables.beanName & 'Rest')) {
			_log('Process with bean ' & variables.beanName);
			oBean = variables.fw.getBeanFactory().getBean(variables.beanName & 'Rest');
			_processBean(oBean); 
			
		} else if (variables.fw.getBeanFactory().containsBean('defaultRest')) {
			_log('Process with bean defaultRest');
			oBean = variables.fw.getBeanFactory().getBean('defaultRest');
			_processBean(oBean); 
			
		}
		
	}
	
	private function _methodMatch(method) {
	
		_log('Method Match ' & uCase(arguments.method) & ' = ' & CGI.REQUEST_METHOD);
		
		if (uCase(arguments.method) eq CGI.REQUEST_METHOD) {
			return true;
		}
		
		return false;
	}
	
	private function _uriMatch(URI) {
	
		sURI = uCase(arguments.URI);
		sURI = reReplace(sURI, ':(.*)', '');
		sURI = reReplace(sURI, '/$', '');
		variables.idName = reMatch(':(.*)', arguments.URI);
		_log('URI Match ' & sURI & ' = ' & variables.uriBean);
		
		if (sURI eq variables.uriBean) {
			return true;
		}
		
		return false;
	}
	
	private function _getParameters() {
	
		if (uCase(CGI.REQUEST_METHOD) eq 'POST') {
			return FROM;
			
		} else {
			return URL;
			
		}
	}
	
	private function _log(message) {
		arrayAppend(variables.trace, message);
	}
	
	private function _processBean(oBean) {
	
		stDatas = getMetaData(arguments.oBean);
		_log('call _processBean with a ' & stDatas.name & ' object');
		aFunctions = stDatas.functions;
		
		for (i = 1 ; i <= arrayLen(aFunctions); i++) {
			_log('Test Match function ' & aFunctions[i].name);
			
			if (structKeyExists(aFunctions[i], 'URI') && structKeyExists(aFunctions[i], 'METHOD')) {
			
				if (_uriMatch(aFunctions[i].URI) && _methodMatch(aFunctions[i].METHOD)) {
					_processMethod(oBean, aFunctions[i].name); 
				}
			}
		}
	
	
	}
	
	private function _processMethod(bean, functionName) {
	
		_log('call _processMethod with function ' & functionName & '');
		variables.processed = true;
		
		try {
		
			funcInstance = arguments.bean[arguments.functionName];
			
			if (arrayLen(variables.idName) > 0) {
				stTemp = {};
				variables.idName = replace(variables.idName[1], ':', '');
				stTemp[variables.idName] = variables.idValue ;
				variables.results = funcInstance(_getParameters(), stTemp);
				
			} else {
				variables.results = funcInstance(_getParameters());
			}
			
		} catch(any e) {
		
			variables.error = true;
			variables.message = e.message;
			_log('Erreur ' & e.message);
			
			for (i = 1; i <= arrayLen(e.tagContext); i++) {
				_log(e.tagContext[i].template & ' at line ' & e.tagContext[i].line);
				
			}
		}
	}
	
	private function _prepareResults() {
	
		if (isSimpleValue(variables.results)) {
			variables.count = 1;
			
		} else if (isObject(variables.results)) {
			variables.count = 1;
			
		} else if (isArray(variables.results)) {
			variables.count = arrayLen(variables.results);
			
		} else if (isStruct(variables.results)) {
			variables.count = 1;
			
		} else if (isQuery(variables.results)) {
			variables.count = variables.results.recordCount;
			
		}
	}

	function after(rc) {
	
		variables.fw.setView(variables.defaultView);
		_prepareResults();
		
		if (!variables.processed) {
			variables.error = true;
			variables.message = 'No object or function found for this URL';
		}
	
		rc.callback = variables.callback;
		rc.results = variables.results;
		rc.count = variables.count;
		rc.error = variables.error;
		rc.message = variables.message;
		
		if (variables.debug) {
			rc.trace = variables.trace;
		}
	}
	
}