[#import "/fragments/decorator/decorators.ftl" as decorators/]

[@decorators.displayHtmlHeader requireResourcesForContext=["atl.general", "bamboo.ec2wizard", "bamboo.configuration"] bodyClass="ec2-wizard aui-page-focused" activeNavKey='create' /]
[#include "/fragments/showAdminErrors.ftl"]
[#assign step = page.properties["meta.tab"]!/]
[#assign prefix = page.properties["meta.prefix"]!"plan"/]
[#assign headerMainContent]
<h1>[@ww.text name="dashboard.ec2wizard.heading" /]</h1>
[/#assign]

${soy.render("bamboo.layout.focused", {
    "headerMainContent": headerMainContent,
    "progressTrackerSteps": [
        {
            "text": action.getText("dashboard.ec2wizard.buttons.configure"),
            "isCurrent": (step == "0")
        },
        {
            "text": action.getText("${prefix}.create.step.one.description"),
            "isCurrent": (step == "1")
        },
        {
            "text": action.getText("${prefix}.create.step.two.description"),
            "isCurrent": (step == "2")
        }
    ],
    "content": body
})}
<script type="application/javascript">
    var steps = ['CONFIGURE_AWS', 'CONFIGURE_PLAN', 'CONFIGURE_TASKS'];
    AJS.trigger('analyticsEvent', {
        name: 'bamboo.config.elastic.wizard.load',
        data: {
            wizardStep: steps[${step}]
        }
    });
</script>
[#include "/fragments/decorator/footer.ftl"]