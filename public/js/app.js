function toggleMenu(evt) {
	var menu = document.getElementById('js-menu');

	menu.className = menu.className == 'show' ? '' : 'show';

	preventDefault(evt);
}

function preventDefault(evt) {
    evt = evt || window.event;

    if (evt.preventDefault) {
        evt.preventDefault();
    } else {
        evt.returnValue = false;
    }
}

function enforceUrlFriendly(input_elem, output_elem, trim) {
	var friendly = getUrlFriendly(input_elem.value, trim);

	if (output_elem.value !== friendly) {
		output_elem.value = friendly;
	}
}

function getUrlFriendly(text, trim) {
	text = text.toLowerCase().replace(/(')/g, '').replace(/([^a-z0-9])/g, '-').replace(/(--+)/g, '-');

	if (typeof trim == 'undefined' || trim) {
		text = text.replace(/^(-*)|(-*)$/g, '');
	}

	return text;
}