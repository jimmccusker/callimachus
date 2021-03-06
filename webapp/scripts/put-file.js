// put-file.js
/*
 * Copyright (c) 2014 3 Round Stones Inc., Some Rights Reserved
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
 
jQuery(function($){

$('form[method="PUT"]').each(function(event){
    var form = this;
    var enctype = form.getAttribute("enctype");
    var fileInput = $(form).find('input[type="file"][accept*="' + enctype + '"]');
    if (!enctype || fileInput.length != 1)
        return;
    $(form).submit(function(event, onlyHandlers){
        var form = this;
        var enctype = form.getAttribute("enctype");
        if (!enctype)
            return true;
        var fileInput = $(form).find('input[type="file"][accept*="' + enctype + '"]');
        if (fileInput.length != 1 || !fileInput[0].files || fileInput[0].files.length != 1)
            return true;
        if (!onlyHandlers && !event.isDefaultPrevented()) {
            event.preventDefault();
            event.stopImmediatePropagation();
            $(form).triggerHandler(event.type, true);
        } else if (onlyHandlers) {
            setTimeout(function(){
                if (!event.isDefaultPrevented()) {
                    var se = $.Event("calliSubmit");
                    se.resource = calli.getFormAction(form).replace(/\?.*/,'');
                    se.payload = fileInput[0].files[0];
                    $(form).trigger(se);
                    if (!se.isDefaultPrevented()) {
                        var action = calli.getFormAction(form);
                        var xhr = $.ajax({
                            type: form.getAttribute("method"),
                            url: action,
                            contentType: form.getAttribute("enctype"),
                            processData: false,
                            data: se.payload,
                            xhrFields: {withCredentials: true},
                            beforeSend: function(xhr) {
                                var lastModified = calli.lastModified(action);
                                if (lastModified) {
                                    xhr.setRequestHeader('If-Unmodified-Since', lastModified);
                                }
                            }
                        });
                        return calli.resolve(xhr).then(function() {
                            calli.lastModified(action, xhr.getResponseHeader('Last-Modified'));
                            var redirect = null;
                            var contentType = xhr.getResponseHeader('Content-Type');
                            if (contentType !== null && contentType.indexOf('text/uri-list') === 0) {
                                redirect = xhr.responseText;
                            }
                            if (!redirect) {
                                redirect = calli.getFormAction(form);
                                if (redirect.indexOf('?') > 0) {
                                    redirect = redirect.substring(0, redirect.indexOf('?'));
                                }
                            }
                            var event = $.Event("calliRedirect");
                            event.cause = se;
                            event.resource = se.resource;
                            event.location = redirect + "?view";
                            $(form).trigger(event);
                            if (!event.isDefaultPrevented()) {
                                if (window.parent != window && parent.postMessage) {
                                    parent.postMessage('PUT src\n\n' + event.location, '*');
                                }
                                window.location.replace(event.location);
                            }
                        }).then(undefined, calli.error);
                    }
                }
            }, 0);
        }
    });
});


});
