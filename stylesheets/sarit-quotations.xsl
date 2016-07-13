<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  exclude-result-prefixes="tei">
<!-- This stylesheet covers quotation and related elements 
  (<quote>, <q>, <ref>, etc.) !-->

<!-- This is for root-texts. !-->
<xsl:template match="tei:quote[@type='base-text']">
<div class="base-text">
  <xsl:apply-templates/>
</div>
</xsl:template>

<xsl:template match="tei:quote">
<xsl:choose>
<!-- QUOTES are block ('blockquote') if they contain the following elements:
  stage, sp, lg !-->
  <xsl:when test="tei:stage | tei:sp | tei:lg | tei:p">
    <div class="quote-block"><xsl:apply-templates/></div>
  </xsl:when>
<!-- Otherwise they are inline. !-->
  <xsl:otherwise><span class="quote-inline"><xsl:apply-templates/></span></xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- For pratīkas (initial sections of a text commented upon) !-->
<xsl:template match="tei:ref[@type='lemma']">
<xsl:variable name="refno"><xsl:number count="tei:ref[@type='lemma']" from="//tei:text" level="any"/></xsl:variable>
<a class="call-modal lemma" href="#lemma-{$refno}" id="a-lemma-{$refno}"><xsl:apply-templates/></a>
</xsl:template>

<!-- Other kinds of references. !-->
<xsl:template match="tei:ref[not(@type='lemma')]">
<xsl:variable name="refno"><xsl:number count="tei:ref[not(@type='lemma')]" from="//text" level="any"/></xsl:variable>
<a class="reference call-modal" href="#ref-{$refno}" id="a-ref-{$refno}"><xsl:apply-templates/></a>
</xsl:template>

<xsl:template name="ref-modal">
  <xsl:variable name="refno"><xsl:number count="tei:ref[not(@type='lemma')]" level="any" from="//tei:body"/></xsl:variable>
  <section class="app" id="ref-{$refno}" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-inner">
      <header>
        <h2>Cross-reference</h2>
      </header>
      <div class="modal-content">
        <xsl:if test="@cRef">
          <span class="appentry">
            <a href="javascriptei:void(0)"><xsl:value-of select="@cRef"/></a>
          </span>
        </xsl:if>
      </div>
    </div>
    <a href="#!" class="modal-close" title="Close this modal" data-dismiss="modal" data-close="Close">×</a>
  </section>
</xsl:template>

<xsl:template name="lemma-modal">
  <xsl:variable name="lemmano"><xsl:number count="tei:ref[@type='lemma']" level="any" from="//tei:body"/></xsl:variable>
  <section class="app" id="lemma-{$lemmano}" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-inner">
      <header>
        <h2>Lemma</h2>
      </header>
      <div class="modal-content">
        <xsl:if test="@target">
          <span class="appentry">
            <a href="javascriptei:void(0)"><xsl:value-of select="@target"/></a>
          </span>
        </xsl:if>
      </div>
    </div>
    <a href="#!" class="modal-close" title="Close this modal" data-dismiss="modal" data-close="Close">×</a>
  </section>
</xsl:template>

</xsl:stylesheet>
