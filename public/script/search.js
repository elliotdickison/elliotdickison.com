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
				enterSearchMode();

				debounce('search', 300, function(){
					search(term);
				});	
			}
			else {
				exitSearchMode();
			}
		});
}

function search(term){
	$.ajax({
		url: '/blog/search/'+encodeURIComponent(term.toLowerCase()),
		success: function(data){
			$('.js-blog-content').html(data);
		}
	});
}

function enterSearchMode(){
	$('body').addClass('search-mode');
}

function exitSearchMode(){
	$('body').removeClass('search-mode');
}