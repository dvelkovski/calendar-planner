[#include "/planner/templates/macros/fieldsMacro.ftl"/]
[#assign events = content.events!/]
[#assign categoriesCM = []/]
[#assign availableCategories = content.categories!/]
<div class="mt100"><h1 class="content-sub-heading">${content.title!"Public Planner"}</h1></div>
<div id="events-wrapper" class="events-wrapper">
    <input type="hidden" value="${content.@path}" id="urlSettings" data-context-path="${ctx.contextPath}">
[#if availableCategories?has_content]
    [#list availableCategories as category]
        [#assign catPath = "/events/" +category/]
        [#assign eventCategory = cmsfn.contentByPath(catPath, "category")]
        [#assign categoriesCM = categoriesCM + [eventCategory]/]
        <span class="event-category" data-catName="${category}" data-color="${eventCategory["color"]!"blue"}"></span>
    [/#list]
[/#if]
[#if events?has_content]
    [#list cmsfn.asContentMapList(events?children) as event]
        <span class="event" data-start="[#if event.startDate?has_content]${event.startDate?string["yyyy-MM-dd HH:mm:ss"]}"[/#if]
              data-nodename="${event.@name}" data-end="[#if event.endDate?has_content]${event.endDate?string["yyyy-MM-dd HH:mm:ss"]}"[/#if] data-color="${event.color!}" data-title="${event.title!}" data-category="${event.category!}"></span>
    [/#list]
[/#if]

</div>
<div id='calendar'></div>
<div aria-hidden="true" class="modal fade" id="doc_create_new_event" role="dialog" tabindex="-1" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-heading">
                <a class="modal-close" data-dismiss="modal">×</a>
                <h2 class="modal-title">Modal Title</h2>
            </div>
            <div class="modal-inner">
            [@textField name="eventTitle" id="eventTitle" label="Event title" hint="Enter event title" type="text"/]
                [@textField name="eventStartDate" id="eventStartDate" label="Event start date" class="datePicker" hint="Enter event start date" type="text"/]
                [@textField name="eventEndDate" id="eventEndDate" label="Event end date" class="datePicker" hint="Enter event end date" type="text"/]
                [@selectField name="category" id="eventCategory" label="Category" options=categoriesCM hint="asd" propValue="name" propLabel="displayName" attributes=['color']/]
            </div>
            <div class="modal-footer">
                <p class="text-right"><button class="btn btn-flat btn-brand waves-attach waves-button waves-effect" data-dismiss="modal" type="button">Close</button><button class="btn btn-flat btn-brand waves-attach waves-button waves-effect" data-dismiss="modal" id="createEventFromCal" type="button">OK</button></p>
            </div>
        </div>
    </div>
</div>

<div aria-hidden="true" class="modal fade" id="doc_update_event" role="dialog" tabindex="-1" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-heading">
                <a class="modal-close" data-dismiss="modal">×</a>
                <h2 class="modal-title">Modal Title</h2>
            </div>
            <div class="modal-inner">
                <input type="hidden" value="" id="existingEventNodeName">
                <input type="hidden" value="" id="existingEventId">
            [@textField name="eventTitle" id="existingEventTitle" label="Event title" hint="Enter event title" type="text"/]
            [@textField name="eventStartDate" id="existingEventStartDate" label="Event start date" class="datePicker" hint="Enter event start date" type="text"/]
            [@textField name="eventEndDate" id="existingEventEndDate" label="Event end date" class="datePicker" hint="Enter event end date" type="text"/]
            [@selectField name="category" id="existingEventCategory" label="Category" options=categoriesCM  propValue="name" propLabel="displayName" attributes=['color']/]

            </div>
            <div class="modal-footer">
                <p class="text-right">
                    <button class="btn btn-flat btn-brand waves-attach waves-button waves-effect" data-dismiss="modal" type="button">Close</button>
                    <button class="btn btn-flat btn-brand waves-attach waves-button waves-effect" data-dismiss="modal" id="updateEventFromCal" type="button">OK</button>
                    <button class="btn btn-flat btn-brand waves-attach waves-button waves-effect" data-dismiss="modal" id="removeEvent" type="button">Remove event</button>
                </p>
            </div>
        </div>
    </div>
</div>

<div class="snackbar"></div>