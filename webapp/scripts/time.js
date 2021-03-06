// time.js
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

(function($){

$(document).ready(function() {
    var now = new Date();
    $(document.getElementsByTagName('time')).each(function() {
        changeDateLocale(this, now);
    });
});
$(document).bind("DOMNodeInserted", handle);

function handle(event) {
    var now = new Date();
    var target = event.target ? event.target : document;
    if (target.getElementsByTagName) {
        var time = $(target.getElementsByTagName('time'));
        if ($(target).is('time')) {
            time = time.add(target);
        }
        time.each(function(i, node) {
            changeDateLocale(node, now);
        });
    }
}

function changeDateLocale(node, now) {
    node = $(node);
    var text = node.text();
    var datetime = node.attr("datetime");
    if (!datetime || text == datetime) {
        var ie8 = false;
        if (!text && node[0].nextSibling && node[0].nextSibling.nodeValue) {
            text = node[0].nextSibling.nodeValue;
            ie8 = true;
        }
        if (!text) return;
        var timestamp = calli.parseDateTime(text).valueOf();
        if (!isNaN(timestamp)) {
            node.attr("content", text);
            node.attr("datetime", text);
            var date = new Date(timestamp);
            if ((date.getHours() > 0 || date.getMinutes() > 0) && /^\s*(\d{4})-?(\d{2})-?(\d{2})\s*$/.exec(text)) {
                date = new Date(calli.parseDateTime(text + "T00:00:00"));
            }
            var formatted = null;
            if (node.is(".abbreviated")) {
                formatted = local(date, now, node);
            } else if (node.is(".datetime")) {
                formatted =  date.toLocaleString();
            } else if (node.is(".datetime-local")) {
                formatted = local(date, now);
            } else if (node.is(".date")) {
                formatted = date.toDateString();
            } else if (node.is(".month")) {
                formatted = month(date);
            } else if (node.is(".year")) {
                formatted = date.getFullYear();
            } else if (node.is(".time")) {
                formatted = date.toLocaleTimeString();
            } else if (text.indexOf('T') < 0) {
                formatted = date.toDateString();
            } else {
                formatted = date.toString();
            }
            if (ie8) {
                node[0].nextSibling.nodeValue = formatted;
            } else {
                node.text(formatted);
            }
        }
    }
}

function local(date, now, node) {
    var locale = '';
    var minutes = '';
    if (!node || !node.is('.date') && !node.is('.month')) {
        if (date.getMinutes() >= 10) {
            minutes = ':' + date.getMinutes();
        } else if (!node || date.getHours() > 0 || date.getMinutes() > 0) {
            minutes = ':0' + date.getMinutes();
        }
        if (date.getHours() >= 10) {
            locale = date.getHours() + minutes;
        } else if (date.getHours() > 0) {
            locale = "0" + date.getHours() + minutes;
        } else if (minutes) {
            locale = "00" + minutes;
        }
    }
    if (!node || !node.is('.time')) {
        if (!node || locale === '' || date.getDate() != now.getDate() || date.getMonth() != now.getMonth() || date.getFullYear() != now.getFullYear()) {
            if (locale) {
                locale += ", ";
            }
            var month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][date.getMonth()];
            if (!node || !node.is('.month')) {
                locale += date.getDate() + ' ';
            }
            locale += month;
            if (!node || date.getFullYear() != now.getFullYear()) {
                locale += ' ' + date.getFullYear();
            }
        }
    }
    return locale;
}

function month(date) {
    var month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][date.getMonth()];
    return month + ' ' + date.getFullYear();
}

})(window.jQuery);

