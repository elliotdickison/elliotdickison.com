function toggleMenu(evt) {
	var menu = document.getElementById('js-menu');

	menu.className = menu.className == 'show' ? '' : 'show';

	evt.preventDefault();
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

$(document).ready(function(){
	$('a.js-ajax-replace').on('click', function(evt){
		var $link = $(this);

		$link.text('Loading...').addClass('loading');
		
		$.ajax({
			"type": "GET",
			"url": $link.attr('href')
		})
		.done(function(data){
			$link.replaceWith(data);
		});

		evt.preventDefault();
	});
});