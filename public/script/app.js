// function debounce(key, interval, callback){
// 	window.bouncing = window.bouncing || {};

// 	if(window.bouncing[key]){
// 		clearTimeout(window.bouncing[key]);
// 		delete window.bouncing[key];
// 	}

// 	window.bouncing[key] = setTimeout(callback, interval);
// }

Event.prototype.preventDefault = Event.prototype.preventDefault || function(){ this.returnValue = false; };

function toggleMenu(evt){
	var menu = document.getElementById('js-menu');

	menu.className = menu.className == 'show' ? '' : 'show';

	evt.preventDefault();
}

function enforceSlug(inputElement, outputElement, trim) {
	var friendly = getSlug(inputElement.value, trim);

	if (outputElement.value !== friendly) {
		outputElement.value = friendly;
	}
}

function getSlug(text, trim){
	text = text.toLowerCase().replace(/(')/g, '').replace(/([^a-z0-9])/g, '-').replace(/(--+)/g, '-');

	if (typeof trim == 'undefined' || trim) {
		text = text.replace(/^(-*)|(-*)$/g, '');
	}

	return text;
}