<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:str="http://exslt.org/strings"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" version="2.0" exclude-result-prefixes="tei fn str">
<!-- This stylesheet covers textual variation !-->
<!-- This version uses the Bootstrap library to create a modal for
     the apparatus. !-->

<xsl:template match="tei:app">
  <a data-toggle="modal" href="#{generate-id()}"><xsl:apply-templates select="tei:lem"/></a>
</xsl:template>

<xsl:template match="text()" mode="modal"/>

<xsl:template match="tei:app" mode="modal">
  <div id="{generate-id()}" class="modal fade" role="dialog">
    <div class="modal-dialog">
      <!-- Modal content-->
      <div class="modal-content">
	<div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">×</button>
          <h4 class="modal-title">Apparatus</h4>
	</div>
	<div class="modal-body">
	  <xsl:for-each select="tei:lem | tei:rdg | tei:note">
	    <span class="appentry">
	      <strong><xsl:value-of select="translate(translate(@wit,' ',''),'#','')"/><xsl:value-of select="translate(translate(@source,' ',''),'#','')"/></strong><xsl:text>: </xsl:text><xsl:apply-templates/>
	    </span>
	  </xsl:for-each>
	</div>
      </div>
    </div>
  </div>
</xsl:template>

</xsl:stylesheet>
