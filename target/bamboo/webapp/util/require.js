(function (window) {

    'use strict';

    // almond claims to be AMD compatible, but isn't
    delete define.amd;

    function fnFactory(fn) {
        return function () {
            return fn;
        };
    }

    var oldRequire = require;
    var logged = false;

    require = function (modules, cb) {
        if (typeof modules === 'string' && typeof cb === 'function') {
            if (!logged) {
                logged = true;
                /* [logging] */
                console.log('WARN: require() use with string an function has been deprecated in 2.11 and will throw an error in 3.0. Use an array of dependencies. (requiring ' + modules + ')');
                /* [logging] end */
            }
            modules = [ modules ];
        }

        //explicitly disallow use of Almond internal params.
        if (cb && typeof cb !== 'function') {
            throw new Error('Callback was not a function');
        }

        return oldRequire.call(window, modules, cb);
    };

    // predefined shims
    define('jquery', fnFactory(window.AJS ? window.AJS.$ : window.jQuery));
    define('underscore', fnFactory(window._));
    define('backbone', fnFactory(window.Backbone));
    define('brace', fnFactory(window.Brace));
    define('aui', fnFactory(window.AJS));

})(window || this);
