<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="1.0" exclude-result-prefixes="tei xi fn">
  <xsl:output method="html" indent="no" encoding="UTF-8" version="4.0" doctype-system="http://www.w3.org/TR/html4/strict.dtd" doctype-public="-//W3C//DTD HTML 4.01//EN"/>

  <xsl:template match="tei:text">
    <xsl:apply-templates/>
    <!-- Modals for notes !-->
    <xsl:for-each select=".//tei:note[@place='app']">
      <xsl:variable name="key" select="generate-id()"/>
      <div class="modal fade" tabindex="-1" role="dialog" aria-hidden="true">
	<xsl:attribute name="id">
	  <xsl:value-of select="$key"/>
	</xsl:attribute>
	<div class="modal-dialog" role="document">
	  <div class="modal-content">
	    <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">x</span>
              </button>
              <h4 class="modal-title" data-toc-skip="">
		<xsl:text>Note</xsl:text>
	      </h4>
	    </div>
	    <div class="modal-body">
              <xsl:apply-templates/>
	    </div>
	    <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
	    </div>
	  </div>
	</div>
      </div>
    </xsl:for-each>
    <!-- Modals for referenceds !-->
    <xsl:for-each select=".//tei:note[@type='reference']">
      <xsl:variable name="key" select="generate-id()"/>
      <div class="modal fade" tabindex="-1" role="dialog" aria-hidden="true">
	<xsl:attribute name="id">
	  <xsl:value-of select="$key"/>
	</xsl:attribute>
	<div class="modal-dialog" role="document">
	  <div class="modal-content">
	    <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">x</span>
              </button>
              <h4 class="modal-title" data-toc-skip="">
		<xsl:text>Reference</xsl:text>
	      </h4>
	    </div>
	    <div class="modal-body">
              <xsl:apply-templates/>
	    </div>
	    <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
	    </div>
	  </div>
	</div>
      </div>
    </xsl:for-each>
    <!-- Modals for chaya !-->
    <xsl:for-each select=".//tei:note[@type='chaya']">
      <xsl:variable name="key" select="generate-id()"/>
      <div class="modal fade" tabindex="-1" role="dialog" aria-hidden="true">
	<xsl:attribute name="id">
	  <xsl:value-of select="$key"/>
	</xsl:attribute>
	<div class="modal-dialog" role="document">
	  <div class="modal-content">
	    <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		<span aria-hidden="true">x</span>
              </button>
              <h4 class="modal-title" data-toc-skip="">
		<xsl:text>Sanskrit translation</xsl:text>
	      </h4>
	    </div>
	    <div class="modal-body">
              <xsl:apply-templates/>
	    </div>
	    <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
	    </div>
	  </div>
	</div>
      </div>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:div[@type='structural']">
    <div class="textstructure">
      <a id="{@xml:id}"></a>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="tei:div[@type='interstitial']">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:div[@type='prakāśa']/tei:head">
    <h1 data-toc-skip=""><xsl:apply-templates/></h1>
  </xsl:template>

  <xsl:template match="tei:div[@type='structural']/tei:head">
    <xsl:variable name="toc">
      <xsl:value-of select="../tei:head[@type='toc']"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="../../tei:div[@type='prakāśa']">
	<h2 data-toc-text="{$toc}">
	  <ul class="breadcrumb">
	    <li>
	      <a href="#"><i class="glyphicon glyphicon-home"></i></a>
	    </li>
	    <xsl:for-each select="ancestor::tei:div[@type='structural']">
	      <li>
		<a href="#{./@xml:id}">
		  <xsl:value-of select="./tei:head[@type='toc']"/>
		</a>
	      </li>
	    </xsl:for-each>
	  </ul>
	</h2>
      </xsl:when>
      <xsl:when test="../../../tei:div[@type='prakāśa']">
	<h3 data-toc-text="{$toc}">
	  <ul class="breadcrumb">
	    <li>
	      <a href="#"><i class="glyphicon glyphicon-home"></i></a>
	    </li>
	    <xsl:for-each select="ancestor::tei:div[@type='structural']">
	      <li>
		<a href="#{./@xml:id}">
		  <xsl:value-of select="./tei:head[@type='toc']"/>
		</a>
	      </li>
	    </xsl:for-each>
	  </ul>
	</h3>
      </xsl:when>
      <xsl:when test="../../../../tei:div[@type='prakāśa']">
	<h4 data-toc-text="{$toc}">
	  <ul class="breadcrumb">
	    <li>
	      <a href="#"><i class="glyphicon glyphicon-home"></i></a>
	    </li>
	    <xsl:for-each select="ancestor::tei:div[@type='structural']">
	      <li>
		<a href="#{./@xml:id}">
		  <xsl:value-of select="./tei:head[@type='toc']"/>
		</a>
	      </li>
	    </xsl:for-each>
	  </ul>
	</h4>
      </xsl:when>
      <xsl:when test="../../../../../tei:div[@type='prakāśa']">
	<h5 data-toc-text="{$toc}">
	  <ul class="breadcrumb">
	    <li>
	      <a href="#"><i class="glyphicon glyphicon-home"></i></a>
	    </li>
	    <xsl:for-each select="ancestor::tei:div[@type='structural']">
	      <li>
		<a href="#{./@xml:id}">
		  <xsl:value-of select="./tei:head[@type='toc']"/>
		</a>
	      </li>
	    </xsl:for-each>
	  </ul>
	</h5>
      </xsl:when>
      <xsl:otherwise>
	<h6 data-toc-text="{$toc}">
	  <ul class="breadcrumb">
	    <li>
	      <a href="#"><i class="glyphicon glyphicon-home"></i></a>
	    </li>
	    <xsl:for-each select="ancestor::tei:div[@type='structural']">
	      <li>
		<a href="#{./@xml:id}">
		  <xsl:value-of select="./tei:head[@type='toc']"/>
		</a>
	      </li>
	    </xsl:for-each>
	  </ul>
	</h6>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="tei:head[@type='toc']"/>

  <xsl:template match="tei:lb">
    <br/>
  </xsl:template>

  <xsl:template match="tei:pb">
    <span class="page">
      <a id="{@n}"/><xsl:value-of select="@n"/>
    </span>
  </xsl:template>

  <xsl:template match="tei:cit">
    <xsl:choose>
      <xsl:when test="parent::tei:p">
	<xsl:apply-templates select="tei:quote" mode="inline"/>
	<xsl:apply-templates select="tei:ref" mode="inline"/>
      </xsl:when>
      <xsl:otherwise>
	<blockquote class="blockquote">
	  <xsl:apply-templates select="tei:quote"/>
	  <footer class="blockquote-footer"><xsl:apply-templates select="tei:ref"/></footer>
	</blockquote>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- styles for inline reference !-->
  <xsl:template match="tei:ref" mode="inline">
    <xsl:text> </xsl:text><span class="reference inline-reference"><xsl:apply-templates/></span>
  </xsl:template>

  <!--
  <xsl:template match="tei:quote">	  
    <span class="quote">
      <xsl:attribute name="class">
	<xsl:value-of select="./@rend"/>
	<xsl:text> quote</xsl:text>
      </xsl:attribute>
      <xsl:choose>
	<xsl:when test="contains(@rend, 'single')">
	  <xsl:text>‘</xsl:text><xsl:apply-templates/><xsl:text>’</xsl:text>
	</xsl:when>
	<xsl:when test="contains(@rend, 'double')">
	  <xsl:text>“</xsl:text><xsl:apply-templates/><xsl:text>”</xsl:text>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>
  !-->

  
  <xsl:template match="tei:ref[not(ancestor::tei:cit)]">
    <a href="{@target}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template match="tei:p">
    <p><xsl:if test="@n"><a id="p{@n}"/></xsl:if>
    <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="tei:lg">
    <div class="lg">
      <xsl:if test="@n">
        <a id="lg{@n}"/>
      </xsl:if>
      <xsl:if test="@xml:id">
	<a id="{@xml:id}"/>
      </xsl:if>
      <xsl:choose>
	<xsl:when test="@rend='bold'">
	  <strong><xsl:apply-templates/></strong>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:template match="tei:l">
    <span class="l">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:caesura">
    <span class="caesura"/>
  </xsl:template>

  <xsl:template match="tei:list">
    <xsl:choose>
      <xsl:when test="@rend='numbered'">
	<ol>
	  <xsl:apply-templates/>
	</ol>
      </xsl:when>
      <xsl:otherwise>
	<ul>
	  <xsl:apply-templates/>
	</ul>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:note[@place='app']">
    <xsl:variable name="key" select="generate-id()"/>
    <sup>
      <a href="" data-toggle="modal" data-target="#{$key}">
        <span class="glyphicon glyphicon-asterisk"></span>
      </a>
    </sup>
  </xsl:template>

  <xsl:template match="tei:note[@type='reference']">
    <xsl:variable name="key" select="generate-id()"/>
    <sup>
      <a href="" data-toggle="modal" data-target="#{$key}">
        <span class="glyphicon glyphicon-asterisk"></span>
      </a>
    </sup>
  </xsl:template>

  <xsl:template match="tei:note[@type='chaya']">
    <xsl:variable name="key" select="generate-id()"/>
    <sup>
      <a href="" data-toggle="modal" data-target="#{$key}">
        <span class="glyphicon glyphicon-asterisk"></span>
      </a>
    </sup>
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

</xsl:stylesheet>
