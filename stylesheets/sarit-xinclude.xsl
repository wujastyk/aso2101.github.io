<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:t="http://www.tei-c.org/ns/1.0"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xi="http://www.w3.org/2001/XInclude"
  exclude-result-prefixes="t xi fn xsl">
<xsl:output method="xml" indent="yes"/>
<!-- This stylesheet puts XIncludes into the result
     document. !-->

<xsl:template match="xi:include[@href][@parse='xml' or not(@parse)][fn:unparsed-text-available(@href)]">
  <xsl:apply-templates select="fn:document(@href)" />
</xsl:template>

<xsl:template match="xi:include[@href][@parse=('text','xml') or not(@parse)][not(fn:unparsed-text-available(@href))][xi:fallback]">
  <xsl:apply-templates select="xi:fallback/text()" />
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
