var xml = "sandesarasaka.xml";
var xslt = "sarit-base.xsl";
var modalxslt = "modals.xsl";

function initialize(script,version) {
  $(".panel-group").remove();
  setScript();
  outline();
}

function setScript() {
  var val = localStorage.getItem("script");
  if (val == "Deva") {
    $("input[name='script'][value='Deva']").prop("checked",true);
    $("input[name='script'][value='Deva']").parent().addClass("active");
  } else if (val == "Guru") {
    $("input[name='script'][value='Guru']").prop("checked",true);
    $("input[name='script'][value='Guru']").parent().addClass("active");
  } else if (val == "Gujr") {
    $("input[name='script'][value='Gujr']").prop("checked",true);
    $("input[name='script'][value='Gujr']").parent().addClass("active");
  } else {
    $("input[name='script'][value='Latn']").prop("checked",true);
    $("input[name='script'][value='Latn']").parent().addClass("active");
  }
  $("input[name='script']").on("change",function() {
    localStorage.setItem("script",this.value);
    location.reload();
  });
};

function outline() {
  $.when($.get(xml),$.get(xslt),$.get(modalxslt)).done(function(x,y,z) {
    var text = transformSanskrit(x[0],y[0]);
        modals = transformSanskrit(x[0],z[0]);
    console.log(modals);
    $("#root").append(text);
    $("#modals").append(modals);
    activateModals();
    activateChaya();
    translit();
  });
}

function activateModals() {
  $('.modal').on('shown.bs.modal',function(e){
    var tab = e.relatedTarget.hash;
    console.log(tab);
    $('.nav-tabs a[href="' + tab + '"]').tab('show');
  });
 // $(".hasModal").hover(function() {
 //   $(this).children('span :not(.chaya-toggle)').css('background','#F0F0F0');
 //   $(this).css('background','#F0F0F0');
 // }, function() {
 //   $(this).children('span :not(.chaya-toggle)').css('background','#FFF');
 //   $(this).css('background','#FFF');
 // });
 // $(".hasModal").css('cursor','pointer');
 // $(".hasModal").on('click',function(e){
 //   if(e.target.class == "chaya-toggle")
 //       return;
 //   var id = $(this).attr('id'),
 //       modalid = "modal-"+id.replace(/\./g,'\\.');
 //   $("#"+modalid).modal('toggle');
 // });
  $(".modal-close").on('click',function(e){
    $(this).closest('.modal').modal('toggle');
  });
  $(".chaya-toggle").on('click',function(e){
    e.stopPropagation();
  });
  $(".app-note, .app-lem").popover({
    html: true,
    content: function() {
      idtarget = $(this).attr("data-target");
      console.log(idtarget);
      return $(idtarget).html();
    }
  });
  $(".app-note, .app-lem").on('click', function(e) {
      e.preventDefault(); return true;
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
    $("#root, #modals").find(".san").each(function() {
      $(this).contents().filter(function() {
        return this.nodeType == 3;
      }).each(function() {
        q = $(this).text();
	r = preprocess(q);
	console.log(r);
        y = Sanscript.t(r,'iast','devanagari').replace(/\s+([।॥])/g,'\u00a0$1');
        z = $('<span class="transliterated Deva"></span>').append(y)
        $(this).replaceWith(z);
      });
    });
  } else if (script == "Guru") {
    $("#root, #modals").find(".san").each(function() {
      $(this).contents().filter(function() {
        return this.nodeType == 3;
      }).each(function() {
        q = $(this).text();
	r = preprocess(q);
	console.log(r);
        y = Sanscript.t(r,'iast','gurmukhi').replace(/\s+([।॥])/g,'\u00a0$1');
        z = $('<span class="transliterated Deva"></span>').append(y)
        $(this).replaceWith(z);
      });
    });
  } else if (script == "Gujr") {
    $("#root, #modals").find(".san").each(function() {
      $(this).contents().filter(function() {
        return this.nodeType == 3;
      }).each(function() {
        q = $(this).text();
	r = preprocess(q);
	console.log(r);
        y = Sanscript.t(r,'iast','gujarati').replace(/\s+([।॥])/g,'\u00a0$1');
        z = $('<span class="transliterated Deva"></span>').append(y)
        $(this).replaceWith(z);
      });
    });
  } else {
    $("#root, #modals").find(".san").not('.l').each(function() {
      $(this).contents().filter(function() {
        return this.nodeType == 3;
      }).each(function() {
        var q = $(this).text(),
            r = q.replace(/\s+\u007c\u007c/g,'. ~')
	         .replace(/\s+\u007c/g,'.');
        $(this).replaceWith(r);
      });
    });
    $("#root, #modals").find(".l.san").each(function() {
      $(this).contents().filter(function() {
        return this.nodeType == 3;
      }).each(function() {
        var q = $(this).text(),
            r = q.replace(/\u007c\u007c/g,'~')
	         .replace(/\u007c/g,'~');
        $(this).replaceWith(r);
      });
    });
  }
}

// Preprocess strings from IAST to Devanāgarī. 
function preprocess(x) {
  return x.replace(" ’","'")
    .replace(/aï/g,"a####i")
    .replace(/aü/g,"a####u")
    .replace(/([rnmd]) ([gṅjñḍṇdnbmhyvrlaāiīuūeo])/g,"$1$2")
    .replace(/([kcṭtpśsṣ]) ([kcṭtpśsṣ])/g,"$1$2")
    .replace(/([vy]) ([aāiīuūeo])/g,"$1$2")
    .replace(/ḷ([aāiīuūṛṝ])/g,"ḻ$1")
    .replace(/ṁ/g,"ँ")
}

function transformSanskrit(node,xsl) {
  xsltProcessor = new XSLTProcessor();
  xsltProcessor.importStylesheet(xsl);
  return xsltProcessor.transformToFragment(node,document);
}

