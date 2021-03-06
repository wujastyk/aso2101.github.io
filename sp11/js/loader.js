// This script uses jQuery.
var text = "śṛṅgāraprakāśa_11-dn.xml";
var xslt = "sarit-base.xsl";
var tablexslt = "sarit-table.xsl";

function initialize() {
  $(".panel-group").remove();
  $.when($.get(text),$.get(xslt),$.get(tablexslt)).done(function(x, y, z) {
    outline(x[0],y[0],z[0]);
  });
}

function outline(text,xslt,tablexslt) {
  sanskritText = transformSanskrit(text,xslt);
  $("#root").append(sanskritText);
  indexLocorum = transformSanskrit(text,tablexslt);
  $("#root").append(indexLocorum);
  $('#indexlocorum').DataTable( {
    "order": [[ 0, "asc" ]],
    "paging": false,
    "aoColumns": [
      { "type": "num", "bVisible": false },
      { "type": "html" },
      { "type": "html" }
    ]
  });
  var navSelector = '#toc';  
  var $myNav = $(navSelector);
  Toc.init($myNav);
  $('body').scrollspy({
    target: navSelector
  });
  $myNav.append('<ul class="nav"><li><a href="#index-locorum">Index locorum</a></li></ul>');
}

function transformSanskrit(node,xsl) {
  xsltProcessor = new XSLTProcessor();
  xsltProcessor.importStylesheet(xsl);
  return xsltProcessor.transformToFragment(node,document);
}
