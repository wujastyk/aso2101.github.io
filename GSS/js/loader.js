var inventory = loadXMLDoc('textInventory.xml');
var authorform = document.getElementById('authorselector');
var workform =  document.getElementById('workselector');
var editorform =  document.getElementById('editorselector');

function loadXMLDoc(dname) {
  if (window.XMLHttpRequest) {
    xhttp = new XMLHttpRequest();
  } else {
    xhttp = new ActiveXObject("Microsoft.XMLHTTP");
  }
  xhttp.open("GET", dname, false);
  xhttp.send("");
  return xhttp.responseXML;
}

function loadForms() {
  $("[id=authorselector]").append("<label>Author: </label><select name='authorName'></select><noscript><input type='button' value='Submit' onclick='loadWorks(authorName)'></input></noscript>");
  loadAuthors();
  $("[id=workselector]").append("<label>Work: </label><select name='workName'><option disabled selected> -- select a work -- </option></select><noscript><input type='button' value='Submit' onclick='loadEditions(workName)'></input></noscript>");
  $("[id=editionselector]").append("<label>Edition: </label><select name='editionName'><option disabled selected> -- select an edition -- </option></select><noscript><input type='button' value='Submit' onclick='loadVerse(editionName)'></input></noscript>");
  $("[id=verseselector]").append("<label>Verse: </label><input name='verseNo' id='verseNumber'></input><input type='button' value='Submit'></input>");
}

function loadAuthors() {
  authors = $(inventory).find('textgroup');
  selector = $("[id=authorselector]").find("select");
  $(selector).find('option').remove(); 
  $(selector).append('<option disabled selected> -- select an author -- </option>');
  for (i = 0; i < authors.length; i++) {
    author = authors[i];
    urn = $(authors[i]).attr('urn');
    name = $(authors[i]).find('groupname').text();
    $(selector).append('<option value="'+urn+'">'+name+"</option>");
  }
  $(selector).change(function() {
    loadWorks(this.form.authorName);
  });
}

function loadWorks(urn) {
  works = $(inventory).find('textgroup[urn="'+urn.value+'"]').find('work');
  selector = $("[id=workselector]").find("select");
  $(selector).find('option').remove();  
  $(selector).append('<option disabled selected> -- select a work -- </option>');
  for (i = 0; i < works.length; i++) {
    urn = $(works[i]).attr('urn');
    name = $(works[i]).find('title').text();
    $(selector).append('<option value="'+urn+'">'+name+"</option>");
  }
  $(selector).change(function() {
    loadEditions(this.form.workName);
  });
}

function loadEditions(urn) {
  editions = $(inventory).find('work[urn="'+urn.value+'"]').find('edition');
  selector = $("[id=editionselector]").find("select");
  $(selector).find('option').remove(); 
  $(selector).append('<option disabled selected> -- select an edition -- </option>');
  for (i = 0; i < editions.length; i++) {
    name = $(editions[i]).find('label').text();
    urn = $(editions[i]).attr('urn');
    $(selector).append('<option value="'+urn+'">'+name+'</option>');
  }
  $(selector).change(function() {
    loadVerse(this.form.editionName);
  });
}

function loadVerse(urn) {
  // removes existing versions on the page
  $(".version").remove();
  edition = $(inventory).find('edition[urn="'+urn.value+'"]');
  scopepath = $(edition).find('citation').attr('scope');
  $("[id=verseselector]").append('<input name="editionName" value="'+urn.value+'" type="hidden"></input>');
  path = $(edition).find('citation').attr('xpath');
  newpath = path.replace("='?'","");
  xml = loadXMLDoc($(edition).find('online').attr('docname'));
  scope = $(xml).xpath(scopepath, function(prefix) {
    if (prefix == "tei")
        return "http://www.tei-c.org/ns/1.0";
     });
  validRefs = $(scope).xpath(newpath, function(prefix) {
    if (prefix == "tei")
        return "http://www.tei-c.org/ns/1.0";
     });
  var RefList = []
  for (i = 0; i < validRefs.length; i++) {
    urn = $(validRefs[i]).attr('n');
    RefList.push(urn);
  }
  $("[name=verseNo]").autocomplete({
      source: RefList,
      focus: function (event, ui) {
                $(".ui-helper-hidden-accessible").hide();
                event.preventDefault();
      }
  });
  $("[id=verseselector] input[value='Submit']").click(function() {
     urn = $('[id=verseselector] input[name=editionName]').val();
     no = $('[id=verseselector] input[name=verseNo]').val();
     displayVerseClear(urn,no);
  });
}

function displayVerseClear(urn,no) {
  $(".version").remove();
  displayVerse(urn,no);
}

function displayVerse(urn,no) {
  // first check if the element already exists on the page
  id = urn+no;
  if ( $('div[id="'+id+'"]').length ) { }
  else {
    // load edition
    edition = $(inventory).find('edition[urn="'+urn+'"]');
    xml = loadXMLDoc($(edition).find('online').attr('docname'))
    // construct a div for the text from the teiHeader
    $("body").append('<div id="'+id+'" class="version"></div>');
    // find the node corresponding to the verse number and load it into the div
    path = $(edition).find('citation').attr('xpath');
    newpath = path.replace("?",no);
    xml = loadXMLDoc($(edition).find('online').attr('docname'))
    node = $(xml).xpath(newpath, function(prefix) {
      if (prefix == "tei")
        return "http://www.tei-c.org/ns/1.0";
    })[0];
    createHeading(id,xml,newpath,path,urn);
    xslfile = 'xsl/sarit-base.xsl';
    xsl = loadXMLDoc(xslfile);
    xsltProcessor = new XSLTProcessor();
    xsltProcessor.importStylesheet(xsl);
    result = xsltProcessor.transformToFragment(node, document);
    $('div[id="'+id+'"]').append(result);
    // construct a div for "other sources" if not already available
    if ( $('.related').length ) { }
    else { relatedTexts(id); }
    // at the end, scroll to the div
    $('html, body').animate({
        scrollTop: $('div[id="'+id+'"]').offset().top
    }, 2000);
  }
}

function createHeading(id,document,path,pathstring,urn) {
    xmldoc = document;
    validpath = pathstring.replace("='?'","");
    heading = $(xmldoc).find('titleStmt title').text();
    // construct the previous element navigator
    previous = $(xmldoc).xpath(path, function(prefix) {
      if (prefix == "tei")
        return "http://www.tei-c.org/ns/1.0";
    }).xpath("preceding-sibling::*[1]");
    prevval = $(previous).attr('n');
    if (typeof prevval !== 'undefined') {
      $('div[id="'+id+'"]').append('<span class="prevSelect">Previous verse: <a href="javascript:void(0);">'+prevval+'</a></span>');
      $('.prevSelect a').click( function(e) {
        displayVerseClear(urn,prevval);
      });
    }
    // construct the subsequent element navigator
    next = $(xmldoc).xpath(path, function(prefix) {
      if (prefix == "tei")
        return "http://www.tei-c.org/ns/1.0";
    }).xpath("following-sibling::*[1]");
    nextval = $(next).attr('n');
    if (typeof nextval !== 'undefined') {
      $('div[id="'+id+'"]').append('<span class="nextSelect">Next verse: <a href="#">'+nextval+'</a></span>');
      $('.nextSelect a').click( function(e) {
        displayVerseClear(urn,nextval);
      });
    }
    // construct the heading
    $('div[id="'+id+'"]').append('<h2>'+heading+'</h2>');
}

function relatedTexts(uri) {
   xml = loadXMLDoc('linkgroup.xml');
   links = $(xml).find("link");
   for (i = 0; i < links.length; i++) {
     target = $(links[i]).attr('target');
     if (target.indexOf(uri) >= 0) {
       targets = target.replace(uri,'');
       related = targets.split(/\s+/);
       break;
     }
   }
   if (related != '') {
     $('div[id="'+id+'"]').append('<div class="related"><h3>Related texts</h3><ul></ul></div>');
     for (i = 0; i < related.length; i++) {
       urn = related[i].slice(0, related[i].lastIndexOf(':')+1);
       no = related[i].slice(related[i].lastIndexOf(':')+1, related[i].length);
       aid = related[i];
       title = $(inventory).find('edition[urn="'+urn+'"]').find('label').text();
       if (title != '') {
         $('div[id="'+id+'"] div[class=related] ul').append('<li><a id="'+aid+'" href="#">'+title+', verse '+no+'</a></li>');
         $('div[id="'+id+'"] div[class=related] a[id="'+aid+'"]').click( 
	     clickCallBack(urn,no));
       }
     }
   }
}

function clickCallBack(urn,no) {
  return function(){
    id = urn+no;
    displayVerse(urn,no);
  }
}

function displayResult(fd) {
  selvalue = fd.value;
  n = selvalue.lastIndexOf('.');
  id = selvalue.substring(0,n);
  xslfile = 'xsl/sarit-base.xsl';
  xml = loadXMLDoc(selvalue);
  xsl = loadXMLDoc(xslfile);
  $("body").append('<div id="'+id+'" class="edition"><h1>'+heading+'</div>');

  // set a &nbsp to make prevent FF to append the text by double click
  document.getElementById("text").innerHTML = '&nbsp;';

  // code for IE
  if (window.ActiveXObject || xhttp.responseType == "msxml-document")
  {
    ex = textnode.transformNode(xsl);
    document.getElementById("text").innerHTML = ex;
  }

  // code for Mozilla, Firefox, etc.
  else if (document.implementation && document.implementation.createDocument) 
  {
    xsltProcessor = new XSLTProcessor();
    xsltProcessor.importStylesheet(xsl);
    result = xsltProcessor.transformToFragment(xml, document);
    $('div[id='+id+']').append(result);
  } 
}

function scrollTo(hash) {
  location.hash = "#" + hash;
}
