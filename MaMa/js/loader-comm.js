// This script uses jQuery.
var version = "purnasarasvati.xml";
var xslt = "sarit-base.xsl";
// By default, the unanalyzed text is loaded. But
// if the user selects the analyzed text from the drop-down
// menu, then it is loaded instead.
function getVersion(sel) {
  var version = sel.value;
  $(".panel-group").remove();
  $.when($.get(version),$.get(xslt)).done(function(x, y) {
    outline(x[0],y[0]);
  });
}

// The following function is called either on load, or
// when a different version is selected. It loads the XML
// document and begins to outline it.
function initialize() {
  $(".panel-group").remove();
  $.when($.get(version),$.get(xslt)).done(function(x, y) {
    outline(x[0],y[0]);
  });
}

// This function will load an outline of the text.
function outline(text,xsl) {
  $text = $(text);
  panelGroup = $('<div class="panel-group"></div>');
  $text.find('div[type="aṅka"]').each(function(index) {
    // Now find the corresponding portion of the text:
    chapter = $(this);
    chapternumber = $(this).attr('n');
    // Now we form the heading:
    // Sanskrit on the left, English on the right.
    leftside = $(this).children("head").text();
    leftlink = $('<div class="panel-title pull-left"><a data-toggle="collapse" href="#'+chapternumber+'">'+leftside+'</a></div>');
    panelHeading = $('<div class="panel-heading clearfix"></div>');
    $(panelHeading).append(leftlink);
    panelContent = $('<div class="panel-collapse collapse" id="#"></div>').attr("id",chapternumber);
    sanskritSection = $(text).find("div[type='aṅka'][n='"+chapternumber+"']")[0];
    content = transformSanskrit(sanskritSection,xsl);
    $('<div class="panel-body"></div>').append(content).appendTo(panelContent);
    // Now the parts are all put together.
    chapterPanel = $('<div class="panel panel-default chapter"></div>');
    $(chapterPanel).append(panelHeading);
    $(chapterPanel).append(panelContent);
    $(panelGroup).append(chapterPanel);
  });
  $("#root").append(panelGroup);
}

function transformSanskrit(node,xsl) {
  console.log(node);
  xsltProcessor = new XSLTProcessor();
  xsltProcessor.importStylesheet(xsl);
  return xsltProcessor.transformToFragment(node,document);
}
