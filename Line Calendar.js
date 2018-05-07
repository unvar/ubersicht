command: "echo 'Lauching LineCalendar...'",

dayNames: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
monthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
offdayIndices: [0, 6], // Saturday & Sunday
 
refreshFrequency: 50000,
displayedDate: null,

render: function () {
  return "<div class=\"cal-container\">\
  <table>\
  <tr class=\"weekday\"></tr>\
  <tr class=\"midline\"></tr>\
  <tr class=\"date\"></tr>\
  </table>\
  <div class=\"title\"></div>\
  </div>";
},
 
style: "                              \n\
  bottom: 17px                        \n\
  right: 30px                         \n\
  left: 25px \n\
  font-family: -apple-system          \n\
  font-size: 13px                     \n\
  font-weight: 500                    \n\
  color: #fff                         \n\
                                      \n\
  .cal-container                      \n\
    border-radius: 10px               \n\
    background: rgba(#000, 0)         \n\
    padding: 0px                      \n\
    display: flex                     \n\
    flex-direction: row               \n\
                                      \n\
  .title                              \n\
    color: rgba(#fff, .3)             \n\
    font-size: 20px                   \n\
    font-weight: 500                  \n\
    padding-top: 5px                  \n\
    text-transform uppercase          \n\
    text-align: center				        \n\
    width: 75px				                \n\
                                      \n\
  table                               \n\
    border-collapse: collapse         \n\
    table-layout: fixed 			        \n\
    width: calc(100% - 75px)    		  \n\
    margin-right: 20px                \n\
                                      \n\
  td                                  \n\
    text-align: center                \n\
                                      \n\
  .weekday td                         \n\
    padding-top: 6px                  \n\
    padding-bottom: 6px				  \n\
                                      \n\
  .date td                            \n\
    padding-top: 6px                  \n\
    padding-bottom: 6px               \n\
                                      \n\
  .today, .off-today                  \n\
    background: rgba(#fff, 0.2)       \n\
                                      \n\
  .weekday .today,                    \n\
  .weekday .off-today                 \n\
    border-radius: 3px 3px 0 0        \n\
    padding-bottom: 6px 			  \n\
                                      \n\
  .date .today,                       \n\
  .date .off-today                    \n\
    border-radius: 0 0 3px 3px        \n\
    padding-top: 6px 				  \n\
                                      \n\
  .midline                            \n\
    height: 3px                       \n\
    background: rgba(#fff, .5)        \n\
                                      \n\
  .midline .today                     \n\
    background: rgba(#0bf, .8)        \n\
                                      \n\
  .midline .offday                    \n\
    background: rgba(#f77, .5)        \n\
                                      \n\
  .midline .off-today                 \n\
    background: rgba(#fc3, .8)        \n\
                                      \n\
  .offday, .off-today                 \n\
    color: rgba(#f77, 1)              \n\
",

update: function (output, domEl) {
  // var date = output.split("\n"), firstWeekDay = date[0], lastDate = date[1], today = date[2], m = date[3]-1, y = date[4];
  
  // // DON'T MANUPULATE DOM IF NOT NEEDED
  // if(this.displayedDate != null && this.displayedDate == output) return;
  // else this.displayedDate = output;

  var date = new Date(), y = date.getFullYear(), m = date.getMonth(), today = date.getDate();
  
  // DON'T MANUPULATE DOM IF NOT NEEDED
  var newDate = [today, m, y].join("/");
  if(this.displayedDate != null && this.displayedDate == newDate) return;
  else this.displayedDate = newDate;

  var firstWeekDay = new Date(y, m, 1).getDay();
  var lastDate = new Date(y, m + 1, 0).getDate();
  
  var weekdays = "", midlines = "", dates = "";

  for (var i = 1, w = firstWeekDay; i <= lastDate; i++, w++) {
    w %= 7;
    var isToday = (i == today), isOffday = (this.offdayIndices.indexOf(w) != -1);
    var className = "ordinary";
    if(isToday && isOffday) className = "off-today";
    else if(isToday) className = "today";
    else if(isOffday) className = "offday";

    weekdays += "<td class=\""+className+"\">" + this.dayNames[w] + "</td>";
    midlines += "<td class=\""+className+"\"></td>";
    dates += "<td class=\""+className+"\">" + i + "</td>";
  };

  $(domEl).find(".title").html(this.monthNames[m]+" <span style='color:lightgray'>"+y+"</span>");
  $(domEl).find(".weekday").html(weekdays);
  $(domEl).find(".midline").html(midlines);
  $(domEl).find(".date").html(dates);
}