// submit-form-data.js
/*
   Copyright (c) 2011 3 Round Stones Inc., Some Rights Reserved
   Licensed under the Apache License, Version 2.0, http://www.apache.org/licenses/LICENSE-2.0
*/

(function($){

var calli = window.calli = window.calli || {};

calli.submitForm = function(event) {
    event = calli.fixEvent(event);
    event.preventDefault();
    var form = $(event.target).closest('form')[0];
    var finalTarget = form.target;
    return calli.postForm(form).then(function(redirect){
        if (finalTarget && window.frames[finalTarget]) {
            window.frames[finalTarget].location.href = redirect;
        } else {
            if (window.parent != window && parent.postMessage) {
                parent.postMessage('PUT src\n\n' + redirect, '*');
            }
            window.location.href = redirect;
        }
    });
};

calli.postForm = function(form) {
    return calli.resolve($(form)[0]).then(function(form){
        var iframe = document.createElement("iframe");
        iframe.name = newIframeName();
        iframe.style.display = "none";
        $('body').append(iframe);
        return new Promise(function(resolve){
            var finalTarget = form.target;
            iframe.bind('load', function(event){
                var doc = event.target.contentWindow.document;
                if (doc.URL != "about:blank") {
                    resolve($(doc).text());
                    $(iframe).remove();
                }
            });
            form.target = iframe.name;
            form.submit();
            form.target = finalTarget;
        }).then(function(redirect){
            if (redirect && redirect.indexOf('http') === 0) {
                return redirect;
            } else {
                var doc = this.contentWindow.document;
                var h1 = $(doc).find('h1').clone();
                var frag = document.createDocumentFragment();
                h1.contents().each(function() {
                    frag.appendChild(this);
                });
                var pre = $(doc).find('pre').text();
                return calli.reject({message: frag, stack: pre});
            }
        });
    });
};

jQuery(function($){
    $('form[method="POST"][enctype="multipart/form-data"],form[method="POST"][enctype="application/x-www-form-urlencoded"]').submit(function(event) {
        var form = $(this);
        var resource = form.attr('about') || form.attr('resource');
        if (!resource || resource.indexOf(':') < 0 && resource.indexOf('/') !== 0 && resource.indexOf('?') !== 0)
            return true; // resource attribute not set yet
        if (!this.target || this.target.indexOf('iframe-redirect-') !== 0) {
            var iname = newIframeName();
            createIframeRedirect(iname, this.target, resource, event);
            this.target = iname;
        }
        return true;
    });
});

var iframe_counter = 0;
function newIframeName() {
    var iname = null;
    while (window.frames[iname = 'iframe-redirect-' + (++iframe_counter)]);
    return iname;
}

function createIframeRedirect(iname, finalTarget, resource, cause) {
    var iframe = $('<iframe></iframe>');
    iframe.attr('name', iname);
    iframe.bind('load', function() {
        var doc = this.contentWindow.document;
        if (doc.URL == "about:blank")
            return true;
        var redirect = $(doc).text();
        if (redirect && redirect.indexOf('http') === 0) {
            var event = $.Event("calliRedirect");
            event.cause = cause;
            event.resource = resource;
            event.location = redirect + '?view';
            $(this).trigger(event);
            if (!event.isDefaultPrevented()) {
                if (finalTarget && window.frames[finalTarget]) {
                    window.frames[finalTarget].location.href = event.location;
                } else {
                    if (window.parent != window && parent.postMessage) {
                        parent.postMessage('PUT src\n\n' + event.location, '*');
                    }
                    window.location.replace(event.location);
                }
            }
        } else {
            var h1 = $(doc).find('h1').clone();
            var frag = document.createDocumentFragment();
            h1.contents().each(function() {
                frag.appendChild(this);
            });
            var pre = $(doc).find('pre').text();
            calli.error(frag, pre);
        }
    });
    iframe.css('display', 'none');
    $('body').append(iframe);
    return iframe;
}

})(jQuery);
