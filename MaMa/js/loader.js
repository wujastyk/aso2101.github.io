var xml = "malatimadhava.xml";
var xslt = "sarit-base.xsl";

function initialize(script,version) {
  $(".panel-group").remove();
  setVersion();
  setScript();
  outline();
}

function setVersion() {
  var ver = localStorage.getItem("version");
  if (ver == null) {
    $("#versionselector").val("orig.xsl");
    localStorage.setItem("version","orig.xsl");  
  } else {
    $("#versionselector").val(ver);
  }
  $("#versionselector").on("change",function() {
    localStorage.setItem("version",this.value);
    location.reload();
  });
}

function setScript() {
  var val = localStorage.getItem("script");
  if (val == "Deva") {
    $("input[name='script'][value='Deva']").prop("checked",true);
    $("input[name='script'][value='Deva']").parent().addClass("active");
  }
  else {
    $("input[name='script'][value='Latn']").prop("checked",true);
    $("input[name='script'][value='Latn']").parent().addClass("active");
  }
  $("input[name='script']").on("change",function() {
    localStorage.setItem("script",this.value);
    location.reload();
  });
};

function outline() {
  var ver = localStorage.getItem("version");
  $.when($.get(xml),$.get(ver),$.get(xslt)).done(function(x,y,z) {
    var textVersion = transformSanskrit(x[0],y[0]),
	panelGroup = $('<div class="panel-group"></div>'),
	chapternumber = '';
    $(textVersion).find('div[type="aṅka"]').each(function(index) {
      var panelHeading = $('<div class="panel-heading clearfix"></div>'),
	  chapter = $(this);
          chapternumber = chapter.attr('n'),
          chaptertitle = chapter.children('head').text(),
          chapterlink = $('<div class="panel-title pull-left"><a class="skt" data-toggle="collapse" href="#'+chapternumber+'">'+chaptertitle+'</a></div>'),
          panelContent = $('<div class="panel-collapse collapse in" id="#"></div>').attr("id",chapternumber),
          chapterPanel = $('<div class="panel panel-default chapter"></div>'),
	  fragment = document.createDocumentFragment();
      // the namespace is necessary to ge the XSLT working
      chapter.attr("xmlns","http://www.tei-c.org/ns/1.0");
      chapter.appendTo(fragment);
      content = transformSanskrit(fragment,z[0]),
      $(panelHeading).append(chapterlink);
      $('<div class="panel-body"></div>').append(content).appendTo(panelContent);
      $(chapterPanel).append(panelHeading);
      $(chapterPanel).append(panelContent);
      $(panelGroup).append(chapterPanel);
    });
    $("#root").append(panelGroup);
    activateModals();
    activateChaya();
    translit();
  });
}

function activateModals() {
  $(".modal").modal({
    backdrop:'static',
    show: false
  });
  $(".hasModal").hover(function() {
    $(this).children('span').css('background','#F0F0F0');
    $(this).css('background','#F0F0F0');
  }, function() {
    $(this).children('span').css('background','#FFF');
    $(this).css('background','#FFF');
  });
  $(".hasModal").css('cursor','pointer');
  $(".hasModal").on('click',function(){
    var id = $(this).attr('id'),
        modalid = "modal-"+id.replace(/\./g,'\\.');
    $("#"+modalid).modal('toggle');
  });
}

function activateChaya() {
  $("#root").find(".prakrit").each(function() {
    toggle = $(this).find(".chaya-toggle");
    toggle.css('cursor','pointer');
    toggle.on('click',function() {
      $(this).parent().find('.sanskritword').toggle('fast');
    });
  });
}

function translit() {
  var script = localStorage.getItem("script");
  if (script == "Deva") {
    $("#root").find(".skt, .skt").each(function() {
      $(this).contents().filter(function() {
        return this.nodeType == 3;
      }).each(function() {
        q = $(this).text();
	r = preprocess(q);
        y = Sanscript.t(r,'iast','devanagari').replace(/\s+([।॥])/g,'\u00a0$1');
        z = $('<span class="transliterated Deva"></span>').append(y)
        $(this).replaceWith(z);
      });
    });
  } else {
    $("#root").find(".skt").not('.l').each(function() {
      $(this).contents().filter(function() {
        return this.nodeType == 3;
      }).each(function() {
        var q = $(this).text(),
            r = q.replace(/\s+\u007c\u007c/g,'. ~')
	         .replace(/\s+\u007c/g,'.');
        $(this).replaceWith(r);
      });
    });
    $("#root").find(".l.skt, .l.skt").each(function() {
      $(this).contents().filter(function() {
        return this.nodeType == 3;
      }).each(function() {
        var q = $(this).text(),
            r = q.replace(/\u007c\u007c/g,'~')
	         .replace(/\u007c/g,'');
        $(this).replaceWith(r);
      });
    });
  }
}

// Preprocess strings from IAST to Devanāgarī. 
function preprocess(x) {
  return x.replace(" ’","'")
    .replace(/([rnmd]) ([gṅjñḍṇdnbmhyvrlaāiīuūeo])/g,"$1$2")
    .replace("aï","a####i")
    .replace("aü","a####u")
    //.replace(/n ([gṅjñḍṇdnbmhyvrlaāiīuūeo])/g,"n$1")
    //.replace(/m ([gṅjñḍṇdnbmhyvrlaāiīuūeo])/g,"m$1")
    //.replace(/([śs]) ([ct])/g,"$1$2")
    //.replace(/d ([gṅjñḍṇdnbmhyvrlaāiīuūeo])/g,"d$1")
    .replace(/([kcṭtpśsṣ]) ([kcṭtpśsṣ])/g,"$1$2")
    .replace(/([vy]) ([aāiīuūeo])/,"$1$2")
    .replace(/ḷ([aāiīuūṛṝ])/,"ḻ$1");
}

function transformSanskrit(node,xsl) {
  xsltProcessor = new XSLTProcessor();
  xsltProcessor.importStylesheet(xsl);
  return xsltProcessor.transformToFragment(node,document);
}

