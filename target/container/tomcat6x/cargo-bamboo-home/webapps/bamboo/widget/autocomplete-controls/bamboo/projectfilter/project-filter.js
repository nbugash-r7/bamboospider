define('widget/filter-project-select', [
    'jquery',
    'underscore',
    'backbone',
    'widget/project-single-select',
    'widget/selected-list'
], function(
    $,
    _,
    Backbone,
    ProjectSingleSelect,
    SelectedList
) {

    'use strict';

    var FilterProjectSelect = Backbone.View.extend({
        initialize: function(options) {
            this.projectSelect = new ProjectSingleSelect({
                el: this.$el,
                bootstrap: options.bootstrap || [],
                maxResults: 10
            });
            this.projectSelect.on('selected', this.handleSelection, this);

            this.selectedProjects = new SelectedList({
                el: options.selectedPlansEl,
                bootstrap: options.bootstrap || [],
                itemTemplate: bamboo.widget.autocomplete.projectFilter.item
            });
        },
        handleSelection: function(model) {
            this.selectedProjects.addItem(model);
            this.projectSelect.singleSelect.setValue('');
        }
    });

    return FilterProjectSelect;
});
