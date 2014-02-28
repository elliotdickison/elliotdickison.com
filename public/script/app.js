function toggleMenu(evt) {
	var menu = document.getElementById('js-menu');

	menu.className = menu.className == 'show' ? '' : 'show';

	evt.preventDefault();
}

function enforceUrlFriendly(inputElement, outputElement, trim) {
	var friendly = getUrlFriendly(inputElement.value, trim);

	if (outputElement.value !== friendly) {
		outputElement.value = friendly;
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
		windowWidth = $window.width(),
		$header = $('.js-cool-header'),
		$nav = $header.find('nav'),
		navIsHidden = false,
		headerHeight, navHeight;

	// Get rid of whatever is currently bound two window.onScroll
	$window.unbind('scroll');

	// Ensure that the nav is visible and positioned absolutely (so it doesn't jump down over any content)
	$nav.css({
		"display": "block",
		"opacity": "1",
		"position": "absolute"
	});

	// 840 is the minimum width for the layout that uses this header... can be found in app.scss
	if(windowWidth >= 840){
		headerHeight = $header.outerHeight();
		navHeight = $nav.outerHeight();

		$nav.css('position', 'fixed');

		$window
			.bind('scroll', function(){
				var offset = window.pageYOffset,
					navOpacity = 1 - (offset / (headerHeight - (navHeight * 2)));

				// Show/hide the navigation, but don't do it more often than necessary (DOM changes are sloow)
				if(navOpacity < 0 && !navIsHidden){
					$nav.hide();
					navIsHidden = true;
				}
				else if(navOpacity > 0 && navIsHidden){
					$nav.show();
					navIsHidden = false;
				}

				// Animate the header
				if(offset < headerHeight){

					// Update the navigation opacity
					if(navOpacity > 0 && !navIsHidden){
						$nav.css('opacity', navOpacity);
					}

					// Parallax the header
					$header.css('background-position', '50% '+(offset / 2)+'px');
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
				.html('<img src="/img/tomato.gif" alt="Look ma, a tomato!" />Look ma, a tomato!'),
			delay = true,
			data;

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
	var setupHeaderTimeout;

	$(window)
		.bind('resize', function(){
			clearTimeout(setupHeaderTimeout);
			setupHeaderTimeout = setTimeout(function(){
				setupHeader();
			}, 100);
		})
		.trigger('resize');

	setupLinks();
});