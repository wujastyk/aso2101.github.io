var inventory = loadXMLDoc('textInventory.xml');
var authorform = document.getElementById('authorselector');
var workform =  document.getElementById('workselector');
var editorform =  document.getElementById('editorselector');

// this is a general-purpose function for loading XML
// documents into the DOM.
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

// this is the function called by viewer.html,
// which builds the forms at the top of the page.
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
    // this passes the URN of the author name to the
    // loadWorks function
    loadWorks(this.form.authorName.value);
  });
}

function loadWorks(urn) {
  works = $(inventory).find('textgroup[urn="'+urn+'"]').find('work');
  selector = $("[id=workselector]").find("select");
  $(selector).find('option').remove();  
  $(selector).append('<option disabled selected> -- select a work -- </option>');
  for (i = 0; i < works.length; i++) {
    urn = $(works[i]).attr('urn');
    name = $(works[i]).find('title').text();
    $(selector).append('<option value="'+urn+'">'+name+"</option>");
  }
  $(selector).change(function() {
    // this passes the URN of the work name to the
    // loadEditions function.
    loadEditions(this.form.workName.value);
  });
}

function loadEditions(urn) {
  editions = $(inventory).find('work[urn="'+urn+'"]').find('edition');
  selector = $("[id=editionselector]").find("select");
  $(selector).find('option').remove(); 
  $(selector).append('<option disabled selected> -- select an edition -- </option>');
  for (i = 0; i < editions.length; i++) {
    name = $(editions[i]).find('label').text();
    urn = $(editions[i]).attr('urn');
    $(selector).append('<option value="'+urn+'">'+name+'</option>');
  }
  $(selector).change(function() {
    // this passes the URN of the edition to the
    // loadVerse function.
    loadVerse(this.form.editionName.value);
  });
}

function loadVerse(urn) {
  // removes existing versions on the page
  $(".version").remove();
  // this function will suggest the available
  // verses with a jquery autocomplete box.
  // PROBLEM: currently this only works with single-level
  // contexts.
  edition = $(inventory).find('edition[urn="'+urn+'"]');
  scopepath = $(edition).find('citation').attr('scope');
  $("[id=verseselector]").append('<input name="editionName" value="'+urn+'" type="hidden"></input>');
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
     urn = $('[id=verseselector] input[name=editionName]').val().concat($('[id=verseselector] input[name=verseNo]').val());
     displayVerseClear(urn);
  });
}

function displayVerseClear(urn) {
  $(".version").remove();
  displayVerse(urn);
}

function displayVerse(urn) {
  // first check if the element already exists on the page
  if ( $('div[id="'+urn+'"]').length ) { }
  else {
    // use GetPassagePlus to get the relevant details
    thisElement = GetPassagePlus(urn);
    // construct the heading
    heading = thisElement.title;
    $("body").append('<div id="'+urn+'" class="version"></div>');
    $('div[id="'+urn+'"]').append('<h2>'+heading+'</h2>');
    // also a button to close it
    $('div[id="'+urn+'"]').append('<div class="close">x</div>');
    // construct the previous element navigator
    thisval = thisElement.currentElement.attr('n');
    prevval = thisElement.previousElement.attr('n');
    nextval = thisElement.nextElement.attr('n');
    if (typeof prevval !== 'undefined') {
      $('div[id="'+urn+'"]').append('<span class="prevSelect">Previous verse: <a href="javascript:void(0);">'+prevval+'</a></span>');
      prevurn = urn.replace(thisval,prevval);
      $('.prevSelect a').click( function(e) {
        displayVerseClear(prevurn);
      });
    }
    // construct the subsequent element navigator
    if (typeof nextval !== 'undefined') {
      $('div[id="'+urn+'"]').append('<span class="nextSelect">Next verse: <a href="#">'+nextval+'</a></span>');
      nexturn = urn.replace(thisval,nextval);
      $('.nextSelect a').click( function(e) {
        displayVerseClear(nexturn);
      });
    }
    xslfile = 'xsl/sarit-base.xsl';
    xsl = loadXMLDoc(xslfile);
    xsltProcessor = new XSLTProcessor();
    xsltProcessor.importStylesheet(xsl);
    result = xsltProcessor.transformToFragment(thisElement.currentElement[0], document);
    $('div[id="'+urn+'"]').append(result);
    // construct a div for "other sources" if not already available
    if ( $('.related').length ) { }
    else { relatedTexts(urn); }
    // at the end, scroll to the div
    $('html, body').animate({
        scrollTop: $('div[id="'+urn+'"]').offset().top
    }, 2000)
    // close the box when you click on the x
    $(document).on('click','.close',function(){
        $(this).parent().fadeTo(300,0,function(){
            $(this).remove();
        });
    });
  }
}

function relatedTexts(urn) {
   xml = loadXMLDoc('linkgroup.xml');
   links = $(xml).find("link");
   for (i = 0; i < links.length; i++) {
     target = $(links[i]).attr('target');
     if (target.indexOf(urn) >= 0) {
       targets = target.replace(urn,'');
       related = targets.split(/\s+/);
       break;
     }
   }
   if (related != '') {
     $('div[id="'+urn+'"]').append('<div class="related"><h3>Related texts</h3><ul></ul></div>');
     for (i = 0; i < related.length; i++) {
       relUrn = related[i];
       // this gets the title of the related text
       relEd = relUrn.slice(0, related[i].lastIndexOf(':')+1);
       title = $(inventory).find('edition[urn="'+relEd+'"]').find('label').text();
       // this gets the number of the related text
       relNo = relUrn.slice(related[i].lastIndexOf(':')+1, related[i].length);
       if (title != '') {
         $('div[id="'+urn+'"] div[class=related] ul').append('<li><a id="'+relUrn+'" href="#">'+title+', verse '+relNo+'</a></li>');
         $('div[id="'+urn+'"] div[class=related] a[id="'+relUrn+'"]').click( 
	     clickCallBack(relUrn));
       }
     }
   }
}

function clickCallBack(urn) {
  return function(){
    displayVerse(urn);
  }
}

function scrollTo(hash) {
  location.hash = "#" + hash;
}

// This is my clumsy implementation of the CITE Architecture's
// GetPassage request. It takes a CTN URN, and returns XML data.
function GetPassagePlus(urn) {
  // first parse the urn
  // we can split the urn into sections divided by ":"
  spliturn = urn.split(':');
  // the last element is the location
  reference = spliturn.pop();
  // the one before that is the author, work and edition
  authorworkedition = spliturn.pop();
  // the one before that is "urn:cts:indic:", which
  // i'm not using right now.
  // same thing for author, work and edition, which
  // are separated by ".":
  splitawe = authorworkedition.split('.');
  edition = splitawe.pop();
  work = splitawe.pop();
  author = splitawe.pop();
  // now we need to match the 'location' with the citation 
  // scheme specified in the textinventory file. basically,
  // we separate it into levels: X.Y.Z looks for the first 
  // level numbered X, the second level numbered Y, etc.
  // first, find out what level is desired?
  levels = reference.split('.');
  editionTI = $(inventory).find('edition[urn="urn:cts:indic:'+authorworkedition+':"]');
  citationMapping = $(editionTI).find('citationMapping');
  xml = loadXMLDoc($(editionTI).find('online').attr('docname'));
  title =  $(xml).find('titleStmt title').text();
  levelOne = levels[0];
  levelOnescheme = $(citationMapping).children('citation').attr('xpath');
  levelOnepath = levelOnescheme.replace('?',levelOne);
  levelOneresult = $(xml).xpath(levelOnepath, function(prefix) {
      if (prefix == "tei")
        return "http://www.tei-c.org/ns/1.0";
    });
  // if there is nothing else in the URN, our job is done.
  // otherwise we go on to level two.
  if (typeof levels[1] === 'undefined') {
    current = levelOneresult;
    context = levelOnepath;
  } else {
    levelTwo = levels[1];
    levelTwoscheme = $(citationMapping).children('citation').children('citation').attr('xpath');
    levelTwopath = levelTwoscheme.replace('?',levelTwo);
    levelTworesult = $(levelOneresult).xpath(levelTwopath, function(prefix) {
      if (prefix == "tei")
        return "http://www.tei-c.org/ns/1.0";
    });
    // if there is nothing else in the URN, our job is done.
    if (levels[2] === 'undefined') {
      current = levelTworesult;
      context = levelTwopath;
    // otherwise we go on to level three (not implemented yet)
    } else { 
      current = levelTworesult;
      context = levelTwopath;
    }
  }
  prev = $(xml).xpath(context, function(prefix) {
    if (prefix == "tei")
      return "http://www.tei-c.org/ns/1.0";
  }).prev();
  next = $(xml).xpath(context, function(prefix) {
    if (prefix == "tei")
      return "http://www.tei-c.org/ns/1.0";
  }).next();
  // return the current node and the next and previous nodes
  return {
    currentElement: current, 
    previousElement: prev,
    nextElement: next,
    title: title
  }
}
