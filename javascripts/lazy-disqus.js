// https://gist.github.com/nternetinspired/7482445
$(document).ready(function() {
  $('.show-comments').on('click', function(){
    var disqus_shortname = 'kevinjalbert';

    // ajax request to load the disqus javascript
    $.ajax({
      type: "GET",
      url: "https://" + disqus_shortname + ".disqus.com/embed.js",
      dataType: "script",
      cache: true
    });

    // hide the button once comments load
    $(this).fadeOut();
  });
});
