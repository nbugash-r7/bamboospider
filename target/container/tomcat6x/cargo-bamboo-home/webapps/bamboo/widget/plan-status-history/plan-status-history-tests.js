define([
    'jquery',
    'underscore',
    'widget/plan-status-history'
], function(
    $,
    _,
    PlanStatusHistory
) {

    'use strict';

    module('Bamboo.PlanStatusHistory', {
        setup: function() {
            this.Navigator = PlanStatusHistory.extend({
                scheduleNextUpdate: function() {}
            });

            this.navigator = new this.Navigator({
                el: $('#qunit-fixture')
            });

            this.navigator.render = sinon.spy(this.navigator, 'render');
        },
        teardown: function() {
            this.navigator.render.restore();
        }
    });

    test('is called on init', function() {
        var Navigator = PlanStatusHistory.extend({
            scheduleNextUpdate: sinon.spy()
        });

        var nav = new Navigator();

        ok(
            nav.scheduleNextUpdate.calledOnce,
            'should be called on init'
        );
    });

    test('is called when #updateReturnUrls is called', function() {
        this.navigator.updateReturnUrls(null, '');

        ok(
            this.navigator.render.calledOnce,
            'should render when updateReturnUrls is called'
        );
    });

});
