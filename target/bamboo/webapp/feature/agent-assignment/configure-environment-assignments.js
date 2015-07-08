define('feature/entity-assignment-multi-select', [
    'jquery',
    'underscore',
    'brace',
    'backbone',
    'widget/single-select',
    'widget/selected-list',
    'widget/autocomplete-ajax',
    'util/events',
    'util/ajax'
], function(
    $,
    _,
    Brace,
    Backbone,
    SingleSelect,
    SelectedList,
    AutocompleteAjax,
    events,
    ajax
) {

    'use strict';

    var AssignmentsTypeSingleSelect = Brace.View.extend({

        mixins: [
            events.EventBusMixin
        ],

        initialize: function(options) {
            options || (options = {});

            this.singleSelect = new SingleSelect({
                el: this.$el,
                bootstrap: options.bootstrap || [],
                maxResults: options.maxResults || 5,
                matcher: _.bind(this.matcher, this),
                resultItemTemplate: bamboo.feature.agent.assignment.assignmentTypeItemResult
            });

            this.singleSelect.on('selected', this.handleSelection, this);
            this.onEvent('agent:dedicate:added', this.onAgentDedicated);
        },

        containsMatch: function(str, find) {
            return (str.toLowerCase().indexOf(find.toLowerCase()) > -1);
        },

        matcher: function(assignment, query) {
            return this.containsMatch(assignment.get('label'), query);
        },

        handleSelection: function(model) {
            this.trigger('selected', model);
        },

        onAgentDedicated: function(e) {}

    });

    var AssignmentSingleSelect = AutocompleteAjax.extend({

        mixins: [
            events.EventBusMixin
        ],

        initialize: function(options) {
            this.params = $.extend({
                url: AJS.contextPath() + '/rest/api/latest/agent/assignment/search',
                cache: false
            }, options.params || {});

            this.query = $.extend({}, options.query || {});

            var dataCallback = _.bind(function(term, entityType, cache) {
                var query = $.extend({
                    searchTerm: term,
                    entityType: entityType,
                    executorType:options.options.executableType,
                    executorId:options.options.agentId
                }, this.query);
                return query;
            }, this);

            var settings = {
                minimumInputLength: 0,
                ajax: {
                    cache: false,
                    url: this.params.url,
                    dataType: 'json',
                    data: dataCallback,
                    results: _.bind(function(data, page) {
                        return this.processData({
                            results: data.searchResults
                        });
                    }, this)
                },
                id: function(object) {
                    return object.searchEntity.id;
                }
            };

            this.onEvent('unbind', this.onUnbind);
            this.onEvent('agent:dedicate:entity:change', this.onEntityChange);
            this.onEvent('agent:dedicate:added', this.onAgentDedicated);

            this.$fieldGroup = this.$el.parents('.field-group:first');

            AutocompleteAjax.prototype.initialize.apply(
                this, [$.extend(settings, this.params)]
            );

            this.disable();
        },

        onUnbind: function() {
            this.undelegateEvents();
            this.$el.removeData().unbind();
            this.offEventNamespace('agent');
        },

        onEntityChange: function(instance, item, isInit) {
            this.clearQueryCache().disable();
            this.query.entityType = instance;

            this.query = _.omit(_.defaults(
                    this.query,
                    this.config
            ), 'entity');

            if (isInit !== true) {
                this.$el.select2('val', '');
            }

            if (this.query.entityType) {
                var value = this.$el.val();

                this.toggleContainer(true).promise().done(_.bind(function() {
                    this.addLoadingIcon();
                }, this));

                if (!value.length) {
                    this.getRemoteData(this.settings.ajax.url, {
                        dataType: this.settings.ajax.dataType,
                        data: this.settings.ajax.data('', instance, false)
                    })
                    .done(_.bind(function(data) {
                        if (!data.searchResults || !data.searchResults.length) {
                            this.removeLoadingIcon();
                        }

                        this.processData({ results: data.searchResults || [] });
                        this.removeLoadingIcon().enable();
                    }, this));
                }
                else {
                    this.config.entity = value;
                    this.getRemoteData(this.params.url, {
                        dataType: this.settings.ajax.dataType,
                        data: this.config
                    })
                    .done(_.bind(function(data) {
                        this.triggerEvent('agent:dedicate:change', data);
                        this.$el.auiSelect2('data', data);
                        this.removeLoadingIcon().enable();
                    }, this));
                }
            }
        },

        onAgentDedicated: function() {
            this.$el.val('');
            this.clearValue();
        },

        onRegisterEvents: function() {
            this.$el.on('change', _.bind(function(event) {
                if (event.val.length > 0) {
                    this.triggerEvent('agent:dedicate:change', event.val);
                }
            }, this));
        },

        onFormatResult: function(item) {
            if (!_.isEmpty(item)) {
                return bamboo.feature.agent.assignment.entityItemResult({
                    item: item.searchEntity
                });
            }
        },

        onFormatSelection: function(item) {
            if (!_.isEmpty(item)) {
                return bamboo.feature.agent.assignment.entityItemLabel({
                    item: item.searchEntity
                });
            }
        },

        onRemoteError: function(xhr) {},

        toggleContainer: function(show, selector) {
            var $container = selector ? selector : this.$fieldGroup.parent();

            if (!_.isUndefined(show)) {
                return show ? $container.slideDown() : $container.slideUp();
            }
            else {
                return $container.slideToogle();
            }
        },

        getRemoteData: function(url, params) {
            return ajax(_.defaults({
                url: url,
                type: 'GET',
                dataType: 'json',
                cache: false
            }, params))
                .fail(_.bind(this.onRemoteError, this))
                .complete(_.bind(function() {
                    this.$el.data('ajax-completed', (new Date()).getTime());
                }, this));
        }

    });

    var EntityAssignmentsSelectedList = SelectedList.extend({

        initialize: function(options) {
            this.capabilitiesTooltipUrl = options.capabilitiesTooltipUrl;

            var CollectionClass = Backbone.Collection.extend({
                url: AJS.contextPath() + options.assignmentsBaseUrl
                    + '?executorType=' + options.executableType
                    + '&executorId=' + options.agentId
                    + '&_=' + (new Date()).getTime()
            });

            options = _.extend({
                bootstrap: new CollectionClass()
            }, options || {});

            SelectedList.prototype.initialize.call(this, options);
        },

        init: function() {
            this.model.collection.fetch({
                success: _.bind(this.render, this)
            });
            this.listenTo(this.model.collection,
                'remove', this.render, this
            );
        },

        render: function(addedItem) {
            this.$el.html(bamboo.feature.agent.assignment.entitiesList({
                entities: this.model.collection.toJSON(),
                addedEntity: addedItem ? addedItem.attributes : null,
                executableType: this.options.executableType,
                agentId: this.options.agentId,
                capabilitiesTooltipUrl: this.capabilitiesTooltipUrl
            }));
        },

        removeItem: function(event) {
            var $item = $(event.target).parents('tr:first');

            $.ajax({
                type: 'DELETE',
                url: [
                    AJS.contextPath(), this.options.assignmentsBaseUrl,
                    '?executorType=', this.options.executableType,
                    '&executorId=', this.options.agentId,
                    '&assignmentType=', $item.data('executabletype'),
                    '&entityId=', $item.data('id')
                ].join(''),
                success: _.bind(function() {
                    this.model.collection.remove($item.data('id'));
                }, this)
            });

            event.preventDefault();
            event.stopPropagation();
        }

    });

    var EntityAssignmentMultiSelect = Brace.View.extend({

        mixins: [
            events.EventBusMixin
        ],

        initialize: function(options) {
            $(options.typeSelector)
                .auiSelect2({minimumResultsForSearch: -1})
                .on('change', _.bind(this.handleTypeSelection, this));

            this.onEvent('agent:dedicate:change', this.enableAddButton);
            this.assignmentSelect = new AssignmentSingleSelect({
                el: this.$el,
                options: this.options
            });

            this.selectedAssignments = new EntityAssignmentsSelectedList({
                el: options.selectedAssignmentsEl,
                executableType: options.executableType,
                agentId: options.agentId,
                assignmentsBaseUrl: options.assignmentsBaseUrl,
                capabilitiesTooltipUrl: options.capabilitiesTooltipUrl
            });

            this.selectedAssignments.init();

            options.addButton.on('click', _.bind(this.handleAdd, this));
            options.addButton.attr('disabled', true);
        },

        handleTypeSelection: function(e) {
            this.entityType = e.val;
            events.EventBus.trigger('agent:dedicate:entity:change', this.entityType);
        },

        handleAdd: function(e) {
            e.preventDefault();
            $.post(AJS.contextPath() + this.options.assignmentsBaseUrl
                + '?executorType=' + this.options.executableType
                + '&executorId=' + this.options.agentId
                + '&assignmentType='
                + this.entityType
                + '&entityId=' + this.entityId,
            _.bind(this.updateTable, this));
        },

        updateTable: function(data) {
            this.selectedAssignments.addItem(data);
            this.options.addButton.attr('disabled', true);
            events.EventBus.trigger('agent:dedicate:added');
        },

        enableAddButton: function(val) {
            this.entityId = val.el.value;
            this.options.addButton.attr('disabled', false);
        }

    });

    return EntityAssignmentMultiSelect;
});
