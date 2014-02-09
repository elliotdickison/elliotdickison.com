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
	var $window = $(window),
		window_width = $window.width(),
		$header = $('.js-cool-header'),
		$nav = $header.find('nav'),
		$footer,
		header_height, footer_height, nav_height,
		footer_threshold, header_bg_offset, footer_bg_offset,
		nav_hidden;

	$window.unbind('scroll');

	if(window_width < 860){
		$nav.css('position', 'relative');
	}
	else {
		$footer = $('.js-cool-footer');
		
		header_height = $header.outerHeight();
		footer_height = $footer.height();
		nav_height = $nav.outerHeight();

		footer_threshold = $(document).height() - $window.height() - footer_height;
		
		// These'll fix the background image at the same location behind the main nav regardless of window size
		header_bg_offset = -420 * (window_width / 1280);
		footer_bg_offset = -250 * (window_width / 1280); 
		
		nav_hidden = false;

		$nav.css('position', 'fixed');

		$window
			.bind('scroll', function(){
			   	var offset = window.pageYOffset,
			   		nav_opacity = 1 - (offset / (header_height - (nav_height * 2)));

			   	// Show/hide the navigation, but don't do it more often than necessary (DOM changes are sloow)
				if(nav_opacity < 0 && !nav_hidden){
					$nav.hide();
					nav_hidden = true;
				}
				else if(nav_opacity > 0 && nav_hidden){
					$nav.show();
					nav_hidden = false;
				}

				// Animate the header
				if(offset < header_height){

					// Update the navigation opacity
					if(nav_opacity > 0 && !nav_hidden){
						$nav.css('opacity', nav_opacity);
					}	

					// Parallax the header
					$header.css('background-position', 'center '+(header_bg_offset + (offset / 2))+'px');
				}

				// Animate the footer
				if(offset > footer_threshold){
					
					// Parallax the footer
					$footer.css('background-position', 'center '+(footer_bg_offset + (offset / 2))+'px');
				}
			})
			.trigger('scroll');
	}
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
	var setup_header_timeout;

	$(window)
		.bind('resize', function(){
			clearTimeout(setup_header_timeout);
			setup_header_timeout = setTimeout(function(){
				setupHeader();
			}, 100);
		})
		.trigger('resize');

	setupLinks();
});