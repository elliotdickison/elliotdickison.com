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
				abortSearch();

				search_xhr = $.ajax({
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
	abortSearch();

	search_xhr = $.ajax({
		url: '/blog/search/'+encodeURIComponent(term),
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

function abortSearch(){

	// Kill any abortable xhr
	if(typeof(search_xhr) != 'undefined' && search_xhr.abort){
		search_xhr.abort();
		search_xhr = undefined;
	}

	// Make sure we aren't debouncing anything
	debounce('search', 0, $.noop);
}