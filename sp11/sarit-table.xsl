<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="1.0" exclude-result-prefixes="tei xi fn">
  <xsl:output method="html" indent="no" encoding="UTF-8" version="4.0" doctype-system="http://www.w3.org/TR/html4/strict.dtd" doctype-public="-//W3C//DTD HTML 4.01//EN"/>

  <xsl:template match="tei:text">
    <xsl:if test=".//tei:ref[@cRef]">
      <h4 data-toc-skip=""><a id="index-locorum"/>Index locorum</h4>
      <p>This excludes references to other sections of the <em>Śṛṅgāraprakāśa</em> and unspecified references to the <em>Sarasvatīkaṇṭhābharaṇa</em>.</p>
      <table id="indexlocorum" class="display">
	<thead>
	  <tr>
	    <th>Index</th>
	    <th>Location</th>
	    <th>Reference</th>
	  </tr>
	</thead>
	<tbody>
	  <xsl:for-each select=".//tei:cit/tei:ref[@cRef]">
	    <tr>
	      <td>
		<xsl:choose>
		  <xsl:when test="./../tei:quote/tei:lg[@n]">
		    <xsl:value-of select="./../tei:quote/tei:lg/@n"/>
		  </xsl:when>
		  <xsl:when test="./../parent::tei:p">
		    <xsl:value-of select="./../../preceding::tei:lg[1]/@n"/>
		  </xsl:when>
		  <xsl:when test="./../preceding::tei:lg[1]/@n">
		    <xsl:value-of select="./../preceding::tei:lg[1]/@n"/>
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:text>9999</xsl:text>
		  </xsl:otherwise>
		</xsl:choose>
	      </td>
	      <td>
		<xsl:choose>
		  <!-- if the reference is a verse !-->
		  <xsl:when test="./../tei:quote/tei:lg[@n]">
		    <a href="#{./../tei:quote/tei:lg/@xml:id}">
		      <xsl:value-of select=".//ancestor::tei:div[@type='prakāśa']/@n"/>
		      <xsl:text>.</xsl:text>
		      <xsl:value-of select="./../tei:quote/tei:lg/@n"/>
		    </a>
		  </xsl:when>
		  <!-- if it is prose !-->
		  <xsl:when test="./../parent::tei:p">
		    <xsl:text>prose after </xsl:text>
		    <xsl:value-of select=".//ancestor::tei:div[@type='prakāśa']/@n"/>
		    <xsl:text>.</xsl:text>
		    <a href="#{./../parent::tei:p/preceding::tei:lg[1]/@xml:id}">
		      <xsl:value-of select="./../parent::tei:p/preceding::tei:lg[1]/@n"/>
		    </a>
		  </xsl:when>
		  <xsl:when test="./../preceding::tei:lg[1]/@n">
		    <xsl:text>prose after </xsl:text>
		    <xsl:value-of select=".//ancestor::tei:div[@type='prakāśa']/@n"/>
		    <xsl:text>.</xsl:text>
		    <a href="#{./../preceding::tei:lg[1]/@xml:id}">
		      <xsl:value-of select="./../preceding::tei:lg[1]/@n"/>
		    </a>
		  </xsl:when>
		  <!-- otherwise !-->
		  <xsl:otherwise>
		    <xsl:value-of select=".."/>
		  </xsl:otherwise>
		</xsl:choose>
	      </td>
	      <td>
		<xsl:value-of select="@cRef"/>
	      </td>
	    </tr>
	  </xsl:for-each>
	</tbody>
      </table>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
