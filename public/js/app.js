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

function setupHeader(){
	var $header = $('.js-cool-header'),
		$nav = $header.find('nav'),
		header_height = $header.outerHeight(),
		nav_height = $nav.outerHeight(),
		bg_offset_initial = -header_height * 1.1,
		hidden = null;

	window.onscroll = function(){
	   	var offset = window.pageYOffset,
	   		nav_opacity = 1 - (offset / (header_height - (nav_height * 2)));

	   	// Show/hide the navigation, but don't do it more often than necessary
		if(nav_opacity < 0 && !hidden){
			$nav.hide();
			hidden = true;
		}
		else if(nav_opacity > 0 && (hidden == null || hidden)){
			$nav.show();
			hidden = false;
		}

		if(nav_opacity > 0 && !hidden){
			$nav.css('opacity', nav_opacity);
		}

		// Parallax it!
		if(offset < header_height){
			$header.css('background-position', 'center '+(bg_offset_initial + (offset / 2))+'px');
		}
	}

	$(window).scroll();
}

function setupLinks(){
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
}

$(function(){

	setupHeader();

	setupLinks();
});