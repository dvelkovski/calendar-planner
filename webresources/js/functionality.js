$(document).ready(function() {
    const EVENTS_NODE_NAME = "events";
    $urlSettings = $("#urlSettings");

    $eventStartDate = $("#eventStartDate");
    $eventEndDate = $("#eventEndDate");
    $eventCategory = $("#eventCategory");
    $eventTitle = $("#eventTitle");
    $eventDescription = $("#eventDescription");

    $existingEventStartDate = $("#existingEventStartDate");
    $existingEventEndDate = $("#existingEventEndDate");
    $existingEventTitle = $("#existingEventTitle");
    $existingEventCategory = $("#existingEventCategory");
    $existingEventDescription = $("#existingEventDescription");

    setEventDateAlwaysAfterStartDate($eventStartDate, $eventEndDate);
    setEventDateAlwaysAfterStartDate($existingEventStartDate, $existingEventEndDate);



	var calendar = $('#calendar').fullCalendar({
        eventSources: buildEventSourceOptions(),
        dayClick: function(date, jsEvent, view) {
            updateTextField($eventStartDate, moment(date).toISOString() + "T00:00:00");
            updateTextField($eventEndDate, moment(date).toISOString() + "T01:00:00");

            $("#doc_create_new_event").modal("show");
        },
        eventClick: function(calEvent, jsEvent, view) {

            $("#doc_update_event").modal("show");
            updateTextField($existingEventStartDate, moment(calEvent.start).toISOString());
            updateTextField($existingEventEndDate, moment(calEvent.end).toISOString());
            updateTextField($existingEventTitle, calEvent.title);
            updateTextField($existingEventCategory, calEvent.category);
            updateTextField($existingEventDescription, calEvent.description)
            if(calEvent.className == "my-event"){
                $(".update-buttons-wrapper").show();
            }else{
                $(".update-buttons-wrapper").hide();
            }
            $("#existingEventNodeName").val(calEvent.nodeName);
            $("#existingEventId").val(calEvent._id);
        }
    });
    //remove event
    $("#removeEvent").click(function(){
        var nodeName = $("#existingEventNodeName").val();
        var eventID = $("#existingEventId").val();
        var path = $urlSettings.val();
        var contextPath = $urlSettings.data("contextPath");

        $.ajax

        ({
            url: '/magnoliaAuthor/.rest/nodes/v1/website' + path + "/"+ EVENTS_NODE_NAME + "/" + nodeName,
            data: JSON.stringify({
                "name": nodeName,
                "type": "mgnl:contentNode",
                "path": path + "/" + EVENTS_NODE_NAME +"/" + nodeName
            }),
            type: 'DELETE',
            contentType: 'application/json',
            success: function()
            {
                calendar.fullCalendar('removeEvents',eventID);
                showNotification($("#success-remove-event"));
            },
            error: function(error){
                console.log(error.responseText);
                showNotification($("#error-action"));
            }
        });
    });
    //update event
    $("#updateEventFromCal").click(function(){

        var nodeName = $("#existingEventNodeName").val()
        var path = $urlSettings.val();
        var contextPath = $urlSettings.data("contextPath");
        var eventID = $("#existingEventId").val();
        $.ajax

        ({
            url: '/magnoliaAuthor/.rest/nodes/v1/website' + path + "/"+ EVENTS_NODE_NAME + "/" + nodeName,
            data: JSON.stringify({
                "name": nodeName,
                "type": "mgnl:contentNode",
                "path": path + "/" + EVENTS_NODE_NAME +"/" + nodeName,
                "property":buildEventProperties($existingEventStartDate.val(),$existingEventEndDate.val(), $existingEventCategory.val(), $existingEventTitle.val(), $existingEventDescription.val())
            }),
            type: 'POST',
            contentType: 'application/json',
            success: function()
            {
                var event={title: $existingEventTitle.val(), start:  moment($existingEventStartDate.val()), end:  moment($existingEventEndDate.val()), color:$('#existingEventCategory option:selected').data('color')};
                var event={
                    title: $existingEventTitle.val(),
                    start:  $existingEventStartDate.val(),
                    end: $existingEventEndDate.val(),
                    color:$('#existingEventCategory option:selected').data('color'),
                    nodeName: nodeName,
                    category: $existingEventCategory.val(),
                    description: $existingEventDescription.val(),
                    className:"my-event"
                };
                calendar.fullCalendar( 'renderEvent', event, true);
                calendar.fullCalendar('removeEvents',eventID);
                showNotification($("#success-update-event"));
            },
            error: function(error){
                console.log(error.responseText);
                showNotification($("#error-action"));
            }
        });
    });

    //create event
    $("#createEventFromCal").click(function(){
        var nodeName = moment().unix();
        var path = $urlSettings.val();
        var contextPath = $urlSettings.data("context-path");
        $.ajax
        ({
            url: '/magnoliaAuthor/.rest/nodes/v1/website' + path + "/"+ EVENTS_NODE_NAME,
            data: JSON.stringify({
                "name": nodeName,
                "type": "mgnl:contentNode",
                "path": path + "/" + EVENTS_NODE_NAME +"/" + nodeName,
                "property": buildEventProperties($eventStartDate.val(), $eventEndDate.val(), $eventCategory.val(), $eventTitle.val(),$eventDescription.val())
            }),
            type: 'PUT',
            contentType: 'application/json',
            success: function()
            {
                var event={
                    title: $eventTitle.val(),
                    start:  $eventStartDate.val(),
                    end: $eventEndDate.val(),
                    color:$('#eventCategory option:selected').data('color'),
                    nodeName: nodeName,
                    category: $eventCategory.val(),
                    description: $eventDescription.val(),
                    className:"my-event"
                };
                calendar.fullCalendar( 'renderEvent', event, true);
                showNotification($("#success-new-event"));
            },
            error: function(error){
                console.log(error.responseText);
                showNotification($("#error-action"));
            }
        });
    });

});
function getEventsFromCategory(category){
    var arr = [];
    $("#events-wrapper span.event").each(function(index, elem){
        if($(elem).data("category") == category){
            var eventObj = {
                title : $(elem).data("title"),
                start : $(elem).data("start"),
                end: $(elem).data("end"),
                nodeName: $(elem).data("nodename"),
                category: $(elem).data("category"),
                description: $(elem).data("description"),
                className: $(elem).data("class-name")
            }
            arr.push(eventObj);
        }
    });
    return arr;
}
function buildEventSourceOptions(){
    var arr = [];
    $("#events-wrapper span.event-category").each(function(index, elem){
        var catName = $(elem).data("catname");
            var eventFromCatObj = {
                events : getEventsFromCategory(catName),
                color: $(elem).data("color")
            }
            arr.push(eventFromCatObj);

    });
    return arr;
}
function updateTextField($field, value){
    $field.val(value);
}
function buildEventProperties(startDateVal, endDateVal, eventCategoryVal, eventTitleVal, descriptionVal){
    var props = [
        {
            "name": "startDate",
            "type": "Date",
            "multiple": false,
            "value": [startDateVal]
        },
        {
            "name": "endDate",
            "type": "Date",
            "multiple": false,
            "value": [endDateVal]
        },
        {
            "name": "category",
            "type": "String",
            "multiple": false,
            "value": [eventCategoryVal]
        },
        {
            "name": "title",
            "type": "String",
            "multiple": false,
            "value": [eventTitleVal]
        },{
            "name": "description",
            "type": "String",
            "multiple": false,
            "value": [descriptionVal]
        }
    ]
    return props;
}
function setEventDateAlwaysAfterStartDate($startDateField, $endDateField){
    $startDateField.datetimepicker({
        format: 'YYYY-MM-DDTHH:mm:ss',
        keepOpen : false
    });
    $endDateField.datetimepicker({
        useCurrent: false, //Important! See issue #1075
        format: 'YYYY-MM-DDTHH:mm:ss',
        keepOpen : false
    });
    $startDateField.on("dp.change", function (e) {
        $endDateField.data("DateTimePicker").minDate(e.date);
    });
    $endDateField.on("dp.change", function (e) {
        $startDateField.data("DateTimePicker").maxDate(e.date);
    });
}
function showNotification($alert){
    $alert.alert();
    $alert.fadeTo(2000, 500).slideUp(500, function(){
        $alert.slideUp(500);
    });
}