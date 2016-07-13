<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  exclude-result-prefixes="tei">
<!-- This stylesheet covers elements related to the
     TEI header. !-->

  <xsl:template match="tei:teiHeader"/>
  <xsl:template match="tei:teiHeader" mode="bypass"><xsl:apply-templates/></xsl:template>
  <!-- Bypass the header first, then read it when 
       the named template is called. !-->

  <!-- The title and affiliated information is called
       with <body>: see sarit-base and sarit-base-nostruct. !-->

  <!-- The "header" we call actually consists of a number of
       portions: the description, and a list of related
       sources, places, and people. !-->
  <xsl:template name="header">
    <div id="teiHeader" class="epidoc">
      <h2>Notes</h2>
      <xsl:apply-templates select="//tei:teiHeader" mode="bypass"/>
      <xsl:call-template name="bibliography"/>
      <xsl:call-template name="personography"/>
      <xsl:call-template name="references"/>
      <!-- These two templates are defined in sarit-bibl.xsl !-->
    </div>
  </xsl:template>

  <xsl:template match="tei:titleStmt"/>
  <xsl:template match="tei:publicationStmt"/>

  <xsl:template match="tei:physDesc">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:history">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:origPlace">
  <div class="bibentry">
    <hi>Place of origin: </hi>
    <a href="locales.html{@key}"><xsl:apply-templates/></a>
  </div>
  </xsl:template>

  <xsl:template match="tei:origDate">
  <div class="bibentry">
    <hi>Date of origin: </hi><xsl:apply-templates/>
  </div>
  </xsl:template>

  <xsl:template match="tei:listPerson"/><!-- block default processing !-->
  <xsl:template match="tei:listPerson" mode="bypass"><!-- when it is called
						      by a template !-->
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>

