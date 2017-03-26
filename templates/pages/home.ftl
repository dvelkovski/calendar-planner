<!DOCTYPE html>
<html xml:lang="${cmsfn.language()}" lang="${cmsfn.language()}">
  <head>
    [@cms.page /]
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>${content.windowTitle!content.title!}</title>
    <meta name="description" content="${content.description!""}" />
    <meta name="keywords" content="${content.keywords!""}" />

    
    [#--${resfn.css(["/planner/.*css"])!}--]
        <link rel="stylesheet" href="${ctx.contextPath}/.resources/magnolia-calendar-planner/webresources/css/bootstrap.min.css">
        <link rel="stylesheet" href="${ctx.contextPath}/.resources/magnolia-calendar-planner/webresources/css/bootstrap-datetimepicker.min.css">
        <link rel="stylesheet" href="${ctx.contextPath}/.resources/magnolia-calendar-planner/webresources/css/fullcalendar.min.css">
        <link rel="stylesheet" href="${ctx.contextPath}/.resources/magnolia-calendar-planner/webresources/css/fullcalendar.print.css">
        <link rel="stylesheet" href="${ctx.contextPath}/.resources/magnolia-calendar-planner/webresources/css/planner.css">
  </head>
<body>



    <div class="container">
        <div class="row">
        [@cms.area name="main"/]
        </div>
    </div>

    [#--${resfn.js(["/planner/.*js"])!}--]
    <script src="${ctx.contextPath}/.resources/magnolia-calendar-planner/webresources/js/jquery-3.2.0.min.js"></script>
    <script src="${ctx.contextPath}/.resources/magnolia-calendar-planner/webresources/js/bootstrap.min.js"></script>
    <script src="${ctx.contextPath}/.resources/magnolia-calendar-planner/webresources/js/moment.js"></script>
    <script src="${ctx.contextPath}/.resources/magnolia-calendar-planner/webresources/js/bootstrap-datetimepicker.js"></script>
    <script src="${ctx.contextPath}/.resources/magnolia-calendar-planner/webresources/js/fullcalendar.min.js"></script>
    <script src="${ctx.contextPath}/.resources/magnolia-calendar-planner/webresources/js/functionality.js"></script>
  </body>
</html>