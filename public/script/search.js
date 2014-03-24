function debounce(key, interval, callback){
	window.bouncing = window.bouncing || {};

	if(window.bouncing[key]){
		clearTimeout(window.bouncing[key]);
		delete window.bouncing[key];
	}

	window.bouncing[key] = setTimeout(callback, interval);
}

function setupSearch(){
	$('input[type=search]')
		.off('input')
		.on('input', function(){
			var term = this.value;

			if(term){
				debounce('search', 300, function(){
					search(term);
				});	
			}
			else {
				$.ajax({
					url: '/blog',
					success: function(data){
						exitSearchMode();
						$('.js-blog-content').replaceWith(data);
					}
				});
			}
		});

	$('.js-clear-search')
		.off('click')
		.on('click', function(evt){
			$(this)
				.siblings('input[type=search]')
				.val('')
				.trigger('input');

			evt.preventDefault();
		});
}

function search(term){
	$.ajax({
		url: '/blog/search/'+encodeURIComponent(term.toLowerCase()),
		success: function(data){

			enterSearchMode();

			$('.js-blog-content').replaceWith(data);
		}
	});
}

function enterSearchMode(){
	$('body').addClass('searching');
}

function exitSearchMode(){
	$('body').removeClass('searching');
}