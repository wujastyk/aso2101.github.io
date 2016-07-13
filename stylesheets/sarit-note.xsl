<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  exclude-result-prefixes="tei">
<!-- This stylesheet covers notes and related elements 
  (<note>, etc.) !-->
<!-- It uses the Bootstrap library for modals. !-->

<xsl:template match="tei:note[not(ancestor::tei:app)]">
  <a data-toggle="modal" href="#{generate-id()}">
    <sup>
    <xsl:choose>
      <xsl:when test="@n"><button type="button" class="btn btn-xs btn-primary popover-dismiss"><xsl:value-of select="@n"/></button></xsl:when>
      <xsl:when test="@type='footnote'"><button type="button" class="btn btn-xs btn-primary popover-dismiss">f</button></xsl:when>
      <xsl:when test="@type='reference'"><button type="button" class="btn btn-xs btn-primary popover-dismiss">r</button></xsl:when>
      <xsl:otherwise><xsl:number count="note[not(ancestor::app)]" level="any" from="//body"/></xsl:otherwise>
    </xsl:choose>
    </sup>
  </a>
</xsl:template>

<xsl:template match="tei:note" mode="modal">
  <div id="{generate-id()}" class="modal fade" role="dialog">
    <div class="modal-dialog">
      <!-- Modal content-->
      <div class="modal-content">
	<div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">×</button>
          <h4 class="modal-title">Note</h4>
	</div>
	<div class="modal-body">
	  <span class="appentry">
	    <xsl:apply-templates/>
	  </span>
	</div>
      </div>
    </div>
  </div>
</xsl:template>

</xsl:stylesheet>
