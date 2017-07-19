<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="1.0" exclude-result-prefixes="tei xi fn">
  <xsl:output method="html" indent="no" encoding="UTF-8" version="4.0" doctype-system="http://www.w3.org/TR/html4/strict.dtd" doctype-public="-//W3C//DTD HTML 4.01//EN"/>
  <xsl:strip-space elements="tei:name tei:surname tei:forename"/>

  <xsl:key name="id" match="tei:witness | tei:biblStruct" use="@xml:id"/>

  <xsl:template match="tei:teiHeader/tei:fileDesc/tei:titleStmt"/>
  <xsl:template match="tei:teiHeader/tei:fileDesc/tei:publicationStmt"/>
  <xsl:template match="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct"/>
  <xsl:template match="tei:teiHeader/tei:encodingDesc/tei:p"/>
  <xsl:template match="tei:teiHeader/tei:encodingDesc/tei:variantEncoding"/>
  <xsl:template match="tei:teiHeader/tei:revisionDesc"/>
  <xsl:template match="tei:div/tei:head"/>
  <xsl:template match="tei:div/tei:label"/>

  <!-- one for each manuscript witness !-->
  <xsl:template match="tei:witness">
    <xsl:element name="div">
      <xsl:attribute name="id"><xsl:value-of select="concat('modal-',@xml:id)"/></xsl:attribute>
      <xsl:attribute name="class">modal fade text-left</xsl:attribute>
      <xsl:attribute name="tabindex">-1</xsl:attribute>
      <xsl:attribute name="role">dialog</xsl:attribute>
      <xsl:attribute name="aria-labelledby">
        <xsl:value-of select="concat(concat('modal-',@xml:id),'-label')"/>
      </xsl:attribute>
      <div class="modal-dialog modal-lg" role="document">
	<div class="modal-content">
	  <div class="modal-header">
	    <button type="button" class="close modal-close"  aria-label="Close"><span aria-hidden="true"><xsl:text>×</xsl:text></span></button>
	    <h3 id="modal-{@xml:id}-label">
	      <xsl:call-template name="bibl-short-title">
		<xsl:with-param name="id" select="@xml:id"/>
	      </xsl:call-template>
	    </h3>
	  </div>
	  <div class="modal-body">
	    <xsl:apply-templates/>
	  </div>
	  <div class="modal-footer">
	    <button type="button" class="btn btn-primary modal-close">Close</button>
	  </div>
	</div>
      </div>
    </xsl:element>
  </xsl:template>

  <!-- one for each bibliography item !-->
  <xsl:template match="tei:biblStruct">
    <xsl:element name="div">
      <xsl:attribute name="id"><xsl:value-of select="concat('modal-',@xml:id)"/></xsl:attribute>
      <xsl:attribute name="class">modal fade text-left</xsl:attribute>
      <xsl:attribute name="tabindex">-1</xsl:attribute>
      <xsl:attribute name="role">dialog</xsl:attribute>
      <xsl:attribute name="aria-labelledby">
        <xsl:value-of select="concat(concat('modal-',@xml:id),'-label')"/>
      </xsl:attribute>
      <div class="modal-dialog modal-lg" role="document">
	<div class="modal-content">
	  <div class="modal-header">
	    <button type="button" class="close modal-close"  aria-label="Close"><span aria-hidden="true"><xsl:text>×</xsl:text></span></button>
	    <h3 id="modal-{@xml:id}-label">
	      <xsl:call-template name="bibl-short-title">
		<xsl:with-param name="id" select="@xml:id"/>
	      </xsl:call-template>
	    </h3>
	  </div>
	  <div class="modal-body">
	    <xsl:call-template name="bibl-full-entry">
	      <xsl:with-param name="id" select="@xml:id"/>
	    </xsl:call-template>
	  </div>
	  <div class="modal-footer">
	    <button type="button" class="btn btn-primary modal-close">Close</button>
	  </div>
	</div>
      </div>
    </xsl:element>
  </xsl:template>

  <!-- one for each metrical pattern witness !-->
  <xsl:template match="tei:metDecl/tei:p">
    <xsl:element name="div">
      <xsl:attribute name="id"><xsl:value-of select="concat('modal-',@xml:id)"/></xsl:attribute>
      <xsl:attribute name="class">modal fade text-left</xsl:attribute>
      <xsl:attribute name="tabindex">-1</xsl:attribute>
      <xsl:attribute name="role">dialog</xsl:attribute>
      <xsl:attribute name="aria-labelledby">
        <xsl:value-of select="concat(concat('modal-',@xml:id),'-label')"/>
      </xsl:attribute>
      <div class="modal-dialog modal-lg" role="document">
	<div class="modal-content">
	  <div class="modal-header">
	    <button type="button" class="close modal-close"  aria-label="Close"><span aria-hidden="true"><xsl:text>×</xsl:text></span></button>
	    <h3 id="modal-{@xml:id}-label"><xsl:text>The </xsl:text><xsl:value-of select="@xml:id"/><xsl:text> meter</xsl:text></h3>
	  </div>
	  <div class="modal-body">
	    <xsl:apply-templates/>
	  </div>
	  <div class="modal-footer">
	    <button type="button" class="btn btn-primary modal-close">Close</button>
	  </div>
	</div>
      </div>
    </xsl:element>
  </xsl:template>

  <!-- draw the main modal for each verse !-->
  <xsl:template match="tei:div/tei:lg">
    <xsl:if test=".//tei:note[@type='commentary'] or .//tei:note[@type='translation'] or .//tei:note[@type='notes']">
      <xsl:variable name="id">
	<xsl:choose>
	  <xsl:when test="@xml:id">
	    <xsl:value-of select="string(@xml:id)"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:variable name="parent-div-n"
			  select="string(./ancestor::tei:div[@type='prakrama']/@n)"/>
	    <xsl:variable name="this-n"
			  select="string(./parent::tei:*/@n)"/>
	    <xsl:value-of select="concat('SaRa.',concat(concat($parent-div-n,'-'),$this-n))"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:variable>
      <xsl:variable name="reference"><xsl:value-of select="substring-after($id,'.')"/></xsl:variable>
      <xsl:variable name="newId"><xsl:value-of select="concat('SaRa-',$reference)"/></xsl:variable>
      <xsl:element name="div">
	<xsl:attribute name="id">
          <xsl:value-of select="concat('modal-',$newId)"/>
	</xsl:attribute>
	<xsl:attribute name="class">modal fade text-left</xsl:attribute>
	<xsl:attribute name="tabindex">-1</xsl:attribute>
	<xsl:attribute name="role">dialog</xsl:attribute>
	<xsl:attribute name="aria-labelledby">
          <xsl:value-of select="concat(concat('modal-',$newId),'-label')"/>
	</xsl:attribute>
	<div class="modal-dialog modal-lg" role="document">
	  <div class="modal-content">
	    <div class="modal-header">
	      <button type="button" class="close modal-close"  aria-label="Close"><span aria-hidden="true"><xsl:text>×</xsl:text></span></button>
	      <h3 id="modal-{$newId}-label"><em>Sandeśarāsaka</em><xsl:text> </xsl:text><xsl:value-of select="$reference"/></h3>
	    </div>
	    <div class="modal-body">
	      <div class="lg modal-quote san">
		<xsl:apply-templates select="*[not(self::tei:note)]"/>
	      </div>
	      <div class="tabbable">
		<ul class="nav nav-tabs modalTab" data-tabs="tabs">
		  <xsl:for-each select="./tei:note">
		    <xsl:variable name="title">
		      <xsl:choose>
			<xsl:when test="@type='translation'">Translation</xsl:when>
			<xsl:when test="@subtype='ṭippanaka'">Ṭippanaka</xsl:when>
			<xsl:when test="@subtype='avacūrikā'">Avacūrikā</xsl:when>
			<xsl:when test="@type='notes'">Notes</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		      </xsl:choose>
		    </xsl:variable>
		    <xsl:variable name="type-of">
		      <xsl:choose>
			<xsl:when test="@type='translation'">translation</xsl:when>
			<xsl:when test="@subtype='ṭippanaka'">tippanaka</xsl:when>
			<xsl:when test="@subtype='avacūrikā'">avacurika</xsl:when>
			<xsl:when test="@type='notes'">notes</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		      </xsl:choose>
		    </xsl:variable>
		    <xsl:element name="li">
		      <xsl:if test="position()=1">
			<xsl:attribute name="class">active</xsl:attribute>
		      </xsl:if>
		      <xsl:element name="a">
			<xsl:attribute name="href">
			  <xsl:value-of select="concat(concat(concat('#modal-',$newId),'-'),$type-of)"/>
			</xsl:attribute>
			<xsl:attribute name="data-toggle">tab</xsl:attribute>
			<xsl:value-of select="$title"/>
		      </xsl:element>
		    </xsl:element>
		  </xsl:for-each>
		</ul>
		<div class="tab-content">
		  <xsl:apply-templates select="tei:note"/>
		</div>
	      </div>
	    </div>
	    <div class="modal-footer">
	      <button type="button" class="btn btn-primary modal-close">Close</button>
	    </div>
	  </div>
	</div>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:div/tei:lg//tei:note">
    <xsl:variable name="type-of">
      <xsl:if test="@type='translation'">translation</xsl:if>
      <xsl:if test="@subtype='ṭippanaka'">tippanaka</xsl:if>
      <xsl:if test="@subtype='avacūrikā'">avacurika</xsl:if>
      <xsl:if test="@type='notes'">notes</xsl:if>
    </xsl:variable>
    <xsl:variable name="id">
      <xsl:choose>
	<xsl:when test="./parent::tei:lg/@xml:id">
	  <xsl:value-of select="string(./parent::tei:lg/@xml:id)"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:variable name="parent-div"
			select="string(./ancestor::tei:div[@type='prakrama']/@n)"/>
	  <xsl:variable name="this-ref"
			select="string(./parent::tei:lg/@n)"/>
	  <xsl:value-of select="concat(concat(concat('SaRā-',$parent-div),'.'),$this-ref)"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="reference"><xsl:value-of select="substring-after($id,'.')"/></xsl:variable>
    <xsl:variable name="newId"><xsl:value-of select="concat('SaRa-',$reference)"/></xsl:variable>
    <xsl:variable name="thisId">
      <xsl:value-of select="concat(concat(concat('modal-',$newId),'-'),$type-of)"/>
    </xsl:variable>
    <xsl:element name="div">
      <xsl:attribute name="class">tab-pane<xsl:if test="count(preceding-sibling::tei:note) = 0"> active</xsl:if></xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="$thisId"/></xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="tei:label[not(parent::tei:witness)]">
    <xsl:element name="span">
      <xsl:attribute name="class"><xsl:text>san</xsl:text><xsl:if test="@rend='squarebrackets'"> squarebrackets</xsl:if></xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- from here to the end, the code is shared !-->
  <xsl:template match="tei:quote/tei:lg">
    <div class="lg">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xsl:template match="tei:*[@xml:lang='eng']/tei:p">
    <p><xsl:apply-templates/></p>
  </xsl:template>
  <xsl:template match="tei:p">
    <p class="san"><xsl:apply-templates/></p>
  </xsl:template>
  <xsl:template match="tei:*[@xml:lang='eng']/tei:ab">
    <p><xsl:apply-templates/></p>
  </xsl:template>
  <xsl:template match="tei:ab">
    <p class="san"><xsl:apply-templates/></p>
  </xsl:template>
  <xsl:template match="tei:s">
    <xsl:variable name="class"><xsl:text>san</xsl:text><xsl:if test=".//tei:choice[@type='chaya']"> prakrit</xsl:if></xsl:variable>
    <span class="{$class}">
      <xsl:if test="@n">
	<xsl:attribute name="id">
	  <xsl:variable name="parent-div"
			select="string(./ancestor::tei:div[@type='prakrama']/@n)"/>
	  <xsl:variable name="this-ref"
			select="string(@n)"/>
	  <xsl:value-of select="concat('SaRā.',concat(concat($parent-div,'.'),$this-ref))"/>
	</xsl:attribute>
	
      </xsl:if>
      <xsl:if test=".//tei:choice[@type='chaya']">
	<span class="badge chaya-toggle">c</span>
      </xsl:if>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  <xsl:template match="tei:choice[@type='chaya']">
    <span class="prakritword san">
      <xsl:apply-templates select="tei:orig"/>
    </span>
    <span class="sanskritword san">
      <xsl:apply-templates select="tei:reg"/>
    </span>
  </xsl:template>
  <xsl:template match="tei:title">
    <span class="title san"><xsl:apply-templates/></span>
  </xsl:template>
  <xsl:template match="tei:name">
    <span class="name san"><xsl:apply-templates/></span>
  </xsl:template>
  <xsl:template match="tei:ref">
    <span class="san reference"><xsl:apply-templates/></span>
  </xsl:template>
  <xsl:template match="tei:note[@type='reference']">
    <span class="san ref"><xsl:apply-templates/></span>
  </xsl:template>
  <xsl:template match="tei:foreign">
    <span class="foreign"><xsl:apply-templates/></span>
  </xsl:template>
  <!--
  <xsl:template match="tei:quote">	  
    <span class="quote">
      <xsl:attribute name="class">
	<xsl:value-of select="./@rend"/>
	<xsl:text> quote</xsl:text>
	<xsl:if test="not(descendant::tei:lg)"><xsl:text> san</xsl:text></xsl:if>
      </xsl:attribute>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  !-->
  <xsl:template match="tei:lb">
    <br></br>
  </xsl:template>
  <xsl:template match="tei:l">
    <span class="l san">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  <xsl:template match="tei:caesura">
    <span class="caesura"/>
  </xsl:template>
  <xsl:template match="tei:supplied">
    <span class="san supplied"><xsl:apply-templates/></span>
  </xsl:template>
  <xsl:template match="tei:hi[@rend='bold']">
    <b><xsl:apply-templates/></b>
  </xsl:template>
  <xsl:template match="tei:hi">
    <em><xsl:apply-templates/></em>
  </xsl:template>
  <xsl:template match="tei:em">
    <em><xsl:apply-templates/></em>
  </xsl:template>
  <xsl:template match="tei:list[not(@type='gloss')]">
    <ul class="note-list">
      <xsl:apply-templates/>
    </ul>
  </xsl:template>
  <xsl:template match="tei:item[parent::tei:list[not(@type='gloss')]]">
    <li><xsl:apply-templates/></li>
  </xsl:template>
  <xsl:template match="tei:list[@type='gloss']">
    <dl class="dl-horizontal">
      <xsl:apply-templates/>
    </dl>
  </xsl:template>
  <xsl:template match="tei:label[parent::tei:list[@type='gloss']]">
    <dt class="san"><xsl:apply-templates/></dt>
  </xsl:template>
  <xsl:template match="tei:item[parent::tei:list[@type='gloss']]">
    <dd><xsl:apply-templates/></dd>
  </xsl:template>
  <xsl:template match="tei:app">
    <xsl:variable name="apparatus">
      <span class="app-reading san"><xsl:value-of select="tei:lem"/></span>
      <xsl:for-each select="tei:lem/@wit | tei:lem/@source">
	<xsl:text> </xsl:text>
	<xsl:call-template name="app-witness">
	  <xsl:with-param name="type" select="name(.)"/>
	  <xsl:with-param name="value" select="."/>
	</xsl:call-template>
      </xsl:for-each>
      <xsl:text>] </xsl:text>
      <xsl:for-each select="tei:rdg">
        <xsl:if test="@type='gloss'">
          <xsl:text> = </xsl:text>
        </xsl:if>
	<xsl:choose>
	  <xsl:when test="./text()">
	    <span class="app-reading san"><xsl:apply-templates /></span>
	  </xsl:when>
	  <xsl:otherwise>
	    <span>om. </span>
	  </xsl:otherwise>
	</xsl:choose>
        <xsl:if test="tei:note">
          <span class="appnote"><xsl:value-of select="./note"/></span>
        </xsl:if>
	<xsl:for-each select="@wit | @source">
	  <xsl:text> </xsl:text>
	  <xsl:call-template name="app-witness">
	    <xsl:with-param name="type" select="name(.)"/>
	    <xsl:with-param name="value" select="."/>
	  </xsl:call-template>
	</xsl:for-each>
        <xsl:if test="@type='conj'">
          <xsl:text> conj. </xsl:text><xsl:value-of select="translate(translate(@resp,' ',''),'#','')"/>
        </xsl:if>
	<xsl:if test="position()!=last()">
          <xsl:text>, </xsl:text>
	</xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <a tabindex="0" href="#" class="app-lem" data-html="true" data-toggle="popover" data-placement="top" data-trigger="focus" data-target="#{generate-id()}" title="Apparatus">
      <span class="lem san"><xsl:apply-templates select="tei:lem"/></span> <!-- lemma reading !-->
    </a> 
    <span class="popover-content hide" id="{generate-id()}"><xsl:copy-of select="$apparatus"/></span>
  </xsl:template>

  <xsl:template name="app-witness">
    <xsl:param name="type"/>
    <xsl:param name="value"/>
    <xsl:call-template name="tokenize-witness-list">
      <xsl:with-param name="string" select="$value"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tei:choice[not(@type='chaya')]">
    <xsl:variable name="apparatus">
      <span class="app-reading san"><xsl:apply-templates select="tei:corr"/></span>
      <span> corr. for ms. reading </span>
      <span class="app-reading san"><xsl:apply-templates select="tei:sic"/></span>
    </xsl:variable>
    <a tabindex="0" href="#" class="app-note" data-html="true" data-toggle="popover" data-placement="top" data-trigger="focus" data-target="#{generate-id()}" title="Apparatus">
      <span class="lem san"><xsl:apply-templates select="tei:corr"/></span>
    </a>
    <span class="popover-content hidden" id="{generate-id()}"><xsl:copy-of select="$apparatus"/></span>
  </xsl:template>
  <xsl:template match="tei:note[@place='app'] | tei:note[@place='bottom']">
    <xsl:variable name="apparatus">
      <xsl:choose>
	<xsl:when test="@xml:lang='san-Latn'">
	  <span class="san app-reading"><xsl:apply-templates/></span>
	</xsl:when>
	<xsl:otherwise>
	  <span><xsl:apply-templates/></span>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <a tabindex="0" href="#" class="app-note" data-html="true" data-toggle="popover" data-placement="top" data-trigger="focus" data-target="#{generate-id()}" title="Apparatus">
      <xsl:text>*</xsl:text>
    </a>
    <span class="popover-content hidden" id="{generate-id()}"><xsl:copy-of select="$apparatus"/></span>
  </xsl:template>
  <xsl:template match="tei:rdg/tei:note"/>
  <xsl:template match="tei:ptr">
    <xsl:call-template name="make-bibl-link">
      <xsl:with-param name="target" select="translate(@target,'#','')"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="tei:graphic">
    <img class="center-block" src="{@url}"/>
  </xsl:template>

  <xsl:template name="string-replace">
    <xsl:param name="string" />
    <xsl:param name="replace" />
    <xsl:param name="with" />
    <xsl:choose>
      <xsl:when test="contains($string, $replace)">
        <xsl:value-of select="substring-before($string, $replace)" />
        <xsl:value-of select="$with" />
        <xsl:call-template name="string-replace">
          <xsl:with-param name="string" select="substring-after($string,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="with" select="$with" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="wrap">
    <xsl:param name="content"/>
    <div class="row">
      <div class="col-md-2"></div>
      <div class="col-md-10">
	<xsl:copy-of select="$content"/>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="tokenize-witness-list">
    <xsl:param name="string"/>
    <xsl:choose>
      <xsl:when test="contains($string,' ')"> 
	<xsl:variable name="first-item" select="translate(normalize-space(substring-before($string,' ')),'#','')"/> 
	<xsl:if test="$first-item">
	  <xsl:call-template name="make-bibl-link">
	    <xsl:with-param name="target" select="$first-item"/>
	  </xsl:call-template>
	  <xsl:call-template name="tokenize-witness-list"> 
	    <xsl:with-param name="string" select="substring-after($string,' ')"/> 
	  </xsl:call-template>    
	</xsl:if>  
      </xsl:when>
      <xsl:otherwise>
	<xsl:choose>
	  <xsl:when test="$string = ''">
	    <xsl:text/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:call-template name="make-bibl-link">
	      <xsl:with-param name="target" select="translate($string,'#','')"/>
	    </xsl:call-template>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="make-bibl-link">
    <xsl:param name="target"/>
    <xsl:variable name="description">
      <xsl:call-template name="bibl-short-title">
	<xsl:with-param name="id" select="$target"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="text">
      <xsl:call-template name="bibl-super-short-title">
	<xsl:with-param name="id" select="$target"/>
      </xsl:call-template>
    </xsl:variable>
    <a href="#modal-{$target}" class="app-wit" data-toggle="modal" data-target="#modal-{$target}" title="{$description}"><xsl:value-of  select="$text"/></a>
  </xsl:template>

  <xsl:template name="bibl-short-title">
    <xsl:param name="id"/>
    <xsl:for-each select="key('id',$id)">
      <xsl:choose>
	<!-- when it is a biblStruct element !-->
	<xsl:when test="name(.) = 'biblStruct'">
	  <xsl:value-of select=".//tei:title[@type='short'][1]"/>
	</xsl:when>
	<!-- when it is a witness element !-->
	<xsl:otherwise>
	  <xsl:value-of select=".//tei:label"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="bibl-super-short-title">
    <xsl:param name="id"/>
    <xsl:for-each select="key('id',$id)">
      <xsl:choose>
	<!-- when it is a biblStruct element !-->
	<xsl:when test="name(.) = 'biblStruct'">
	  <xsl:value-of select=".//tei:title[@type='siglum'][1]"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="@xml:id"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="bibl-full-entry">
    <xsl:param name="id"/>
    <xsl:for-each select="key('id',$id)">
      <xsl:variable name="author-block">
	<xsl:variable name="editors" select="count(.//tei:editor)"/>
	<xsl:for-each select=".//tei:editor">
	  <xsl:choose>
	    <xsl:when test="position()=1">
	      <xsl:apply-templates select="." mode="author-string">
		<xsl:with-param name="style" select="'sf'"/>
	      </xsl:apply-templates>
	    </xsl:when>	
	    <xsl:otherwise>
	      <xsl:apply-templates select="." mode="author-string">
		<xsl:with-param name="style" select="'fs'"/>
	      </xsl:apply-templates>
	    </xsl:otherwise>
	  </xsl:choose>
	  <xsl:choose>
	    <xsl:when test="position() = $editors - 1">
	      <xsl:text> and </xsl:text>
	    </xsl:when>
	    <xsl:when test="position() &lt; $editors - 1">
	      <xsl:text>, </xsl:text>
	    </xsl:when>
	    <xsl:otherwise></xsl:otherwise>
	  </xsl:choose>
	</xsl:for-each>
      </xsl:variable>
      <span><xsl:value-of select="normalize-space($author-block)"/><xsl:text>. </xsl:text></span>
      <em><xsl:value-of select=".//tei:title[@level='m']"/></em>
      <xsl:text>. </xsl:text>
      <xsl:value-of select=".//tei:pubPlace"/>
      <xsl:text>: </xsl:text>
      <xsl:value-of select=".//tei:publisher"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select=".//tei:date"/>
      <xsl:text>. </xsl:text>
    </xsl:for-each>
    
  </xsl:template>
  <xsl:template match="tei:name" mode="author-string">
    <xsl:param name="style"/>
    <xsl:variable name="author-string">
      <xsl:choose>
	<!-- if there is a surname and a forename !-->
	<xsl:when test=".//tei:surname">
	  <xsl:choose>
	    <!-- if the style is surname-forename !-->
	    <xsl:when test="$style = 'sf'">
	      <xsl:value-of select=".//tei:surname"/>
	      <xsl:text>, </xsl:text>
	      <xsl:value-of select=".//tei:forename"/>
	    </xsl:when>
	    <!-- if the style is forename-surname !-->
	    <xsl:otherwise>
	      <xsl:value-of select="normalize-space(.//tei:forename)"/>
	      <xsl:text> </xsl:text>
	      <xsl:value-of select="normalize-space(.//tei:surname)"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:when>
	<!-- if there is just one name, like jinavijaya muni !-->
	<xsl:otherwise>
	  <xsl:value-of select="."/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="normalize-space($author-string)"/>
  </xsl:template>
    
</xsl:stylesheet>
