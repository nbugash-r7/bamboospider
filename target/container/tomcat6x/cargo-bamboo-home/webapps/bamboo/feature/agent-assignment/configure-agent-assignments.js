define('feature/agent-assignment-multi-select', [
    'jquery',
    'underscore',
    'backbone',
    'widget/single-select',
    'widget/selected-list'
], function(
    $,
    _,
    Backbone,
    SingleSelect,
    SelectedList
) {

    'use strict';

    var AgentAssignmentSingleSelect = Backbone.View.extend({
        initialize: function(options) {
            options || (options = {});
            this.singleSelect = new SingleSelect({
                el: this.$el,
                bootstrap: options.bootstrap || [],
                maxResults: options.maxResults || 5,
                matcher: _.bind(this.matcher, this),
                resultItemTemplate: bamboo.feature.agent.assignment.agentItemResult
            });
            this.singleSelect.on('selected', this.handleSelection, this);
        },
        containsMatch: function(str, find) {
            return (str.toLowerCase().indexOf(find.toLowerCase()) > -1);
        },
        matcher: function(assignment, query) {
            var matches = false;
            matches = matches || this.containsMatch(assignment.get('name'), query);
            return matches;
        },
        handleSelection: function(model) {
            this.trigger('selected', model);
        }
    });

    var AgentSelectedList = SelectedList.extend({
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
            
            SelectedList.prototype.initialize.apply(this, arguments);
        },
        render: function(addedItem) {
            this.$el.html(bamboo.feature.agent.assignment.agentList({
                agentAssignmentExecutors: this.model.collection.toJSON(),
                addedAssignment: addedItem ? addedItem.attributes : null,
                capabilitiesTooltipUrl: this.capabilitiesTooltipUrl
            }));
        }
    });

    var AgentAssignmentMultiSelect = Backbone.View.extend({
          initialize: function(options) {
              this.assignmentSelect = new AgentAssignmentSingleSelect({
               el: this.$el,
               bootstrap: options.bootstrap || [],
               maxResults: 10
              });
              this.assignmentSelect.on('selected', this.handleSelection, this);
              this.selectedAssignments = new AgentSelectedList({
               el: options.selectedAssignmentsEl,
               capabilitiesTooltipUrl: options.capabilitiesTooltipUrl,
               bootstrap: options.selectedAssignments || []
              });
          },
          handleSelection: function(model) {
              this.selectedAssignments.addItem(model);
              this.assignmentSelect.singleSelect.setValue('');
          }
     });

    return AgentAssignmentMultiSelect;
});
