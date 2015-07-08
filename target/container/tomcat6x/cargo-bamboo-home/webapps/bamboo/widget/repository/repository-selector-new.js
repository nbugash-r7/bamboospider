define('widget/repository-selector-new', [
    'jquery',
    'underscore',
    'brace',
    'util/events'
], function(
    $,
    _,
    Brace,
    events
) {

    'use strict';

    var RepositorySelectorNew = Brace.View.extend({

        mixins: [
            events.EventBusMixin
        ],

        initialize: function(options) {
            this.$selectedRepository = $('#selectedRepository');

            this.$el.find('li.option').on('click', _.bind(this.onSelectRepository, this));
            this.$el.find('li').tooltip({ gravity: 's' });

            this.$forms = $('#repository-forms');
            this.$dropdown = $('#repository-other-dropdown');
            this.$staticElements = $('#repository-display-name').add(
                $('#repository-access-option')
            );

            this.onEvent('repository:selector:form', this.onFormChanged);
            this.selectByKey(this.getSelectedKey());
        },

        onFormChanged: function(instance, type) {
            if (type === 'NEW') {
                this.selectByKey(this.getSelectedKey());
            }
        },

        onSelectRepository: function(event) {
            event.preventDefault();

            var $element = $(event.target).parents('li:first');
            var key = $element.data('key');
            var isNullRepository = (key === 'nullRepository');

            if (isNullRepository) {
                this.$staticElements.hide();
            }
            else if (!this.$staticElements.is(':visible')) {
                this.$staticElements.show();
            }

            this.$selectedRepository.val(key);
            this.$selectedRepository.trigger('change');

            var id = ['repository', key].join('-');
            var $container = $('div[id="' + id + '"]');
            var $selected = this.$forms.find('.repository:visible').not($container);

            if ($selected && $selected.length) {
                $selected.hide();
            }

            this.$el.find('li.selected').removeClass('selected');
            $element.addClass('selected');
            $container.show();

            if (this.$dropdown.find($element).length) {
                this.$el.find('a[aria-owns="' + this.$dropdown.attr('id') + '"]')
                    .parents('li').addClass('selected');
            }
        },

        getSelectedKey: function() {
            var selectedKey = this.$selectedRepository.val();
            if (/^\d+$/.test(selectedKey)) { //test if selected repository is a number
                selectedKey = '';
            }

            if (!selectedKey.length) {
                var $elements = this.$el.find('li.option.selected')
                    .add(this.$dropdown.find('li.option.selected'));

                var key = $elements.first().data('key');

                if (key && key.length) {
                    selectedKey = key;
                }
            }

            return selectedKey;
        },

        selectByKey: function(key) {
            if (key && key.length) {
                var keySelector = 'li[data-key="' + key + '"] a';
                var $items = this.$el.find(keySelector).add(this.$dropdown.find(keySelector));

                if ($items.length) {
                    $items.trigger('click');
                }
            }
            else {
                this.$selectedRepository.val('');
                this.$selectedRepository.trigger('change');
            }
        }

    });

    return RepositorySelectorNew;
});
