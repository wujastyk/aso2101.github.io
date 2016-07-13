<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  exclude-result-prefixes="tei">
<!-- This stylesheet covers elements specific to dramatic texts:
  <speaker>, <stage>, <sp>, and so on. !-->

<!-- <sp> is a speaker's block (the label for the speaker and his/her lines). !-->
<xsl:template match="tei:sp">
  <div class="sp">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<!-- <speaker> gives the name of the speaker. !-->
<xsl:template match="tei:speaker">
  <span class="speaker">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<!-- <stage> gives stage directions !-->
<xsl:template match="tei:stage">
  <span class="stage"><xsl:apply-templates/></span>
</xsl:template>

</xsl:stylesheet>

