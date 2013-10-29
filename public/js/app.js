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

$(function(){
	$('a.js-ajax-replace').on('click', function(evt){
		var $link = $(this),
			href = $link.attr('href'),
			$div = 
				$('<div />', {
					"class": $link.attr('class')+" loading"
				})
				.html('<img src="/img/tomato.gif" alt="look ma, a tomato!" />Just a moment, please...'),
			data,
			delay = true;

		// Show the loading for a minimum of 1 second (w/o delaying the ajax request)
		setTimeout(function(){
			if(data){
				$div.replaceWith(data);	
			}
			delay = false;
		}, 1000);

		$link.replaceWith($div);

		$.ajax({
			"type": "GET",
			"url": href
		})
		.done(function(response){
			data = response;
			if(!delay){
				$div.replaceWith(data);	
			}
		});

		evt.preventDefault();
	});

	$('a.js-close').on('click', function(evt){
		$(this).parent().remove();

		evt.preventDefault();
	});
});