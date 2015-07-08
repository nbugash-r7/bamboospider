define('feature/release-autocomplete', [
    'jquery',
    'underscore',
    'widget/autocomplete-ajax',
    'util/events',
    'util/ajax'
], function(
    $,
    _,
    AutocompleteAjax,
    events,
    ajax
) {

    'use strict';

    var ReleaseAutocomplete = AutocompleteAjax.extend({

        mixins: [events.EventBusMixin],

        initialize: function(options) {
            this.params = options.params || {};

            if (options.params) {
                delete options.params;
            }

            var dataCallback = _.bind(function(term, page) {
                return $.extend({
                    searchTerm: term,
                    'start-index': Math.max(
                        (page - 1) * this.params['max-results'], 0
                    ),
                    chronologicalOrder: true
                }, this.params);
            }, this);

            var settings = {
                minimumInputLength: 0,
                ajax: {
                    url: AJS.contextPath() + '/rest/api/latest/search/versions',
                    dataType: 'json',
                    data: dataCallback,
                    results: _.bind(function(data, page) {
                        return this.processData({
                            results: data.searchResults,
                            more: data.size ? data.size > (page * this.params['max-results']) : false
                        });
                    }, this)
                }
            };

            AutocompleteAjax.prototype.initialize.apply(
                this, [$.extend(settings, options || {})]
            );
        },

        onRegisterEvents: function() {
            this.proxyEvents('release', ['change'], this.$el);
            var events = ['branch:change'];

            if (!this.$el.val()) {
                events.push('branch:change:initial');
            }

            this.onEvent(events, this.onMasterChange);
        },

        onLoadAndProcess: function(element, callback) {
            var settings = _.defaults({
                data: this.settings.ajax.data('', 1)
            }, this.settings.ajax);

            ajax(settings)
                .done(_.bind(function(data) {
                    var selected = data.searchResults[0];

                    if (selected && selected.id) {
                        this.$el.val(selected.id);
                        this.$el.select2('data', selected);
                    }

                    this.processData({
                        results: data.searchResults,
                        more: data.size ? data.size > this.params['max-results'] : false
                    });

                    this.triggerEvent('release:change');

                    if (callback) {
                        callback(selected);
                    }
                }, this));
        },

        onFormatResult: function(item) {
            if (!_.isEmpty(item)) {
                return bamboo.widget.autocomplete.result({
                    name: item.searchEntity.name
                });
            }
        },

        onFormatSelection: function(item) {
            if (!_.isEmpty(item)) {
                return bamboo.widget.autocomplete.selection({
                    name: item.searchEntity.name
                });
            }
        },

        onMasterChange: function(instance) {
            if (
                this.settings.masterPickerId &&
                instance.$el.attr('id') !== this.settings.masterPickerId
            ) {
                return;
            }

            this.params.branchKey = '';
            this.clearValue();

            var value = instance.getSelectedData();

            if (value) {
                this.params.branchKey = value.searchEntity.key;
                this.onLoadAndProcess();
            }
        }

    });

    return ReleaseAutocomplete;
});
