[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.author.AdministerAuthors" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.author.AdministerAuthors" --]
[@ww.form action='linkUserToAuthor' namespace='/admin/ajax' submitLabelKey="global.buttons.add" cancelUri="${currentUrl}"]
    [@ww.hidden name='authorId' /]
    [@ww.textfield labelKey="Username" name='userName' template='userPicker' multiSelect=false /]
[/@ww.form]
