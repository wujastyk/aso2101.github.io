<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="2.0" exclude-result-prefixes="tei xi fn">
    <xsl:output method="html" indent="no" encoding="UTF-8" version="4.0" doctype-system="http://www.w3.org/TR/html4/strict.dtd" doctype-public="-//W3C//DTD HTML 4.01//EN"/>
<!-- this is modified stylesheet for the sattasai experiment. !-->
    
<!-- The file for textual variation !-->
    <xsl:include href="sarit-app.xsl"/>

<!-- skip the header for now !-->
    <xsl:template match="tei:teiHeader"/>

<!-- read individual texts in the group !-->
    <xsl:template match="tei:text">
      <div class="text">
        <xsl:apply-templates/>
      </div>
      <!-- this generates the modal stuff !-->
      <xsl:apply-templates mode="modal"/>
      <!-- Now, if there is a related text in linkgroup, add the 
	   possibility to show it/load it !-->
    </xsl:template>

<!-- edition division !-->
    <xsl:template match="tei:div[@type='edition']">
      <div class="edition">
	<h2>edition</h2>
	<xsl:apply-templates/>
      </div>
    </xsl:template>

<!-- translation division !-->
    <xsl:template match="tei:div[@type='translation']">
      <div class="translation">
        <h2>translation</h2>
        <xsl:apply-templates/>
      </div>
    </xsl:template>

<!-- commentary division !-->
    <xsl:template match="tei:div[@type='commentary']">
      <div class="notes">
        <h2>notes</h2>
        <xsl:apply-templates/>
      </div>
    </xsl:template>

<!-- quotations of the base-text !-->
    <xsl:template match="tei:quote[@type='base-text']">
      <div class="base-text">
	<xsl:apply-templates/>
      </div>
    </xsl:template>

<!-- Verse !-->
    <xsl:template match="tei:lg">
        <div class="lg">
            <xsl:if test="@n">
                <a id="lg{@n}"/>
            </xsl:if>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:l">
        <span class="l">
<!-- offsets for verse fragments !-->
            <xsl:if test="@part = 'F'">
                <span class="verse_offset"/>
            </xsl:if>
<!-- In the future, it would be wise to use jQuery's position
  to deal with fragments of verses. !-->
            <xsl:apply-templates/>
        </span>
    </xsl:template>

<!-- Prose !-->
    <xsl:template match="tei:p">
        <p>
            <xsl:if test="@n">
                <a id="p{@n}"/>
            </xsl:if>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

<!-- Headers !-->
    <xsl:template match="tei:head[not(ancestor::tei:teiHeader)]">
        <h3><xsl:apply-templates/></h3>
    </xsl:template>

<!-- Trailer !-->
    <xsl:template match="tei:trailer[not(ancestor::tei:teiHeader)]">
        <span class="trailer">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

<!-- Page numbers !-->
    <xsl:template match="tei:pb">
      <span class="page">
        <xsl:value-of select="@n"/>
      </span>
    </xsl:template>

<!-- Line numbers !-->
    <xsl:template match="tei:lb">
      <!-- only put in line numbers for 5, 10, etc. !-->
      <xsl:choose>
	<xsl:when test="not(@n mod 5)">
	  <span class="lineno">
	    <xsl:value-of select="@n"/>
	  </span>
	</xsl:when>
	<xsl:otherwise/>
      </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
