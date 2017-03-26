[#include "/magnolia-calendar-planner/templates/macros/fieldsMacro.ftl"/]
[#assign events = content.events!/]
[#assign categoriesCM = []/]
[#assign pathToEventCategories = def.parameters.rootPathForEventsCategories/]
[#assign availableCategories = content.categories!/]
<div class="mt100"><h1 class="content-sub-heading">${content.title!"Public Planner"}</h1></div>
<input type="hidden" value="${content.@path}" id="urlSettings" data-context-path="${ctx.contextPath}" data-current-user="${ctx.getUser().getName()!}">
[#if availableCategories?has_content]
    <div id="events-categories">
        [#list availableCategories as category]
            [#assign catPath = pathToEventCategories + category/]
            [#assign eventCategory = cmsfn.contentByPath(catPath, "category")]
            [#assign categoriesCM = categoriesCM + [eventCategory]/]
            <span class="event-category" data-catname="${category}" data-color="${eventCategory["color"]!"blue"}" style="background-color: ${eventCategory["color"]!"blue"}">${eventCategory.displayName!}</span>
        [/#list]
    </div>
[/#if]
[#if events?has_content]
<div id="events-wrapper" class="events-wrapper">
    [#list cmsfn.asContentMapList(events?children) as event]
        [#assign cssClass="other-events"/]
        [#if (ctx.getUser().getName() == event['mgnl:createdBy'])]
            [#assign cssClass = "my-event"/]
        [/#if]
        <span class="event" data-start="[#if event.startDate?has_content]${event.startDate?string["yyyy-MM-dd HH:mm:ss"]}"[/#if]
              data-nodename="${event.@name}" data-end="[#if event.endDate?has_content]${event.endDate?string["yyyy-MM-dd HH:mm:ss"]}"[/#if] data-color="${event.color!}" data-title="${event.title!}" data-category="${event.category!}" data-class-name="${cssClass}" data-description="${event.description!}"></span>
    [/#list]
</div>
[/#if]


[@alert class="alert-success" id="success-new-event" title="Success" text="Event has been created"/]
[@alert class="alert-success" id="success-remove-event" title="Success" text="Event has been remove"/]
[@alert class="alert-success" id="success-update-event" title="Success" text="Event has been updated"/]
[@alert class="alert-danger" id="error-action" title="" text="Error"/]
<div id='calendar' data-allow-actions="${(content.allowActions!false)?c}"></div>

<div class="modal fade" id="doc_create_new_event">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-success">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">Create new event</h4>
            </div>
            <div class="modal-body">
                <div class="modal-inner">
                    [@textField name="eventTitle" id="eventTitle" label="Event title" hint="Enter event title" type="text"/]
                    [@textField name="eventStartDate" id="eventStartDate" label="Event start date" class="datePicker" hint="Enter event start date" type="text"/]
                    [@textField name="eventEndDate" id="eventEndDate" label="Event end date" class="datePicker" hint="Enter event end date" type="text"/]
                    [@selectField name="category" id="eventCategory" label="Category" options=categoriesCM hint="asd" propValue="name" propLabel="displayName" attributes=['color']/]
                    [@textArea id="eventDescription" label="Description" name="" hint="" rows="5"/]


                </div>
            </div>
            <div class="modal-footer">
                <p class="text-right">
                    <button class="btn" data-dismiss="modal" type="button">Close</button>
                    <button class="btn btn-success" data-dismiss="modal" id="createEventFromCal" type="button">OK</button>
                </p>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->




<div class="modal fade" id="doc_update_event">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">Update event</h4>
            </div>
            <div class="modal-body">
                <div class="modal-inner">
                    <input type="hidden" value="" id="existingEventNodeName">
                    <input type="hidden" value="" id="existingEventId">
                    [@textField name="eventTitle" id="existingEventTitle" label="Event title" hint="Enter event title" type="text"/]
                    [@textField name="eventStartDate" id="existingEventStartDate" label="Event start date" class="datePicker" hint="Enter event start date" type="text"/]
                    [@textField name="eventEndDate" id="existingEventEndDate" label="Event end date" class="datePicker" hint="Enter event end date" type="text"/]
                    [@selectField name="category" id="existingEventCategory" label="Category" options=categoriesCM  propValue="name" propLabel="displayName" attributes=['color']/]
                    [@textArea id="existingEventDescription" label="Description" name="" hint="" rows="5"/]
                </div>
            </div>
            <div class="modal-footer">
                <p class="text-right update-buttons-wrapper">
                    <button class="btn" data-dismiss="modal" type="button">Close</button>
                    <button class="btn btn-success" data-dismiss="modal" id="updateEventFromCal" type="button">OK</button>
                    <button class="btn btn-danger" data-dismiss="modal" id="removeEvent" type="button">Remove event</button>
                </p>
            </div>
        </div>
    </div>
</div>