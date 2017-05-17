<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="1.0" exclude-result-prefixes="tei xi fn">
    <xsl:output method="html" indent="no" encoding="UTF-8" version="4.0" doctype-system="http://www.w3.org/TR/html4/strict.dtd" doctype-public="-//W3C//DTD HTML 4.01//EN"/>

  <xsl:template match="tei:lg">
    <xsl:variable name="class">lg<xsl:if test=".//tei:note[@type='commentary']"> hasModal</xsl:if></xsl:variable>
    <xsl:variable name="output">
      <span class="{$class}">
	<xsl:if test="@n">
	  <xsl:attribute name="id">
	    <xsl:variable name="parent-div"
			  select="string(./ancestor::tei:div[@type='aṅka']/@n)"/>
	    <xsl:variable name="this-ref"
			  select="string(@n)"/>
	    <xsl:value-of select="concat('MaMa.',concat(concat($parent-div,'.'),$this-ref))"/>
	  </xsl:attribute>
	</xsl:if>
	<xsl:apply-templates/>
      </span>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="./parent::tei:sp">
        <xsl:copy-of select="$output"/>
      </xsl:when>
      <xsl:when test="./ancestor::tei:note[@type='commentary']">
	<xsl:copy-of select="$output"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name="wrap">
	  <xsl:with-param name="content" select="$output"/>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- there are different types of stage directions !-->
  <!-- first are those that are contained within dialogue !-->
  <xsl:template match="tei:stage">
    <xsl:variable name="class">
      <xsl:text>stage skt</xsl:text>
      <xsl:text> </xsl:text><xsl:value-of select="./@type"/>
      <xsl:if test=".//tei:note[@type='commentary']"> hasModal</xsl:if>
      <xsl:if test="not(./ancestor::tei:sp)"> stage-center text-center</xsl:if>
      <xsl:if test="./ancestor::tei:sp"> stage-sp</xsl:if>
    </xsl:variable>
    <xsl:variable name="output">
      <span class="{$class}">
	<xsl:if test="@n">
	  <xsl:attribute name="id">
	    <xsl:variable name="parent-div"
			  select="string(./ancestor::tei:div[@type='aṅka']/@n)"/>
	    <xsl:variable name="this-ref"
			  select="string(@n)"/>
	    <xsl:value-of select="concat('MaMa.',concat(concat($parent-div,'.'),$this-ref))"/>
	  </xsl:attribute>
	</xsl:if>
	<xsl:apply-templates/>
      </span>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="./ancestor::tei:sp">
        <xsl:copy-of select="$output"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name="wrap">
	  <xsl:with-param name="content" select="$output"/>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="tei:head"/>
  <!-- remove heading in the main text !-->

  <xsl:template match="tei:sp">
    <div class="row sp">
      <div class="col-md-2">
        <xsl:apply-templates mode="bypass" select="tei:speaker"/>
      </div>
      <div class="col-md-10">
	<xsl:apply-templates/>
      </div>
    </div>
  </xsl:template>

  <!-- speaker !-->
  <xsl:template match="tei:speaker"/>
  <xsl:template mode="bypass" match="tei:speaker">
    <span class="speaker skt"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="tei:p">
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="tei:sp/tei:p">
    <p class="sp"><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="tei:s">
    <xsl:variable name="class">
      <xsl:text>skt</xsl:text>
      <xsl:if test=".//tei:choice[@type='chaya']"> prakrit</xsl:if>
      <xsl:if test=".//tei:note[@type='commentary']"> hasModal</xsl:if>
    </xsl:variable>
    <span class="{$class}">
      <xsl:if test="@n">
	<xsl:attribute name="id">
	  <xsl:variable name="parent-div"
			select="string(./ancestor::tei:div[@type='aṅka']/@n)"/>
	  <xsl:variable name="this-ref"
			select="string(@n)"/>
	  <xsl:value-of select="concat('MaMa.',concat(concat($parent-div,'.'),$this-ref))"/>
	</xsl:attribute>
	
      </xsl:if>
      <xsl:if test=".//tei:choice[@type='chaya']">
	<span class="badge chaya-toggle">c</span>
      </xsl:if>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:choice[@type='chaya']">
    <span class="prakritword skt">
      <xsl:apply-templates select="tei:orig"/>
    </span>
    <span class="sanskritword skt">
      <xsl:apply-templates select="tei:reg"/>
    </span>
  </xsl:template>

  <xsl:template match="tei:title">
    <span class="title skt"><xsl:apply-templates/></span>
  </xsl:template>
  <xsl:template match="tei:name">
    <span class="name skt"><xsl:apply-templates/></span>
  </xsl:template>
  <xsl:template match="tei:ref">
    <span class="skt reference"><xsl:apply-templates/></span>
  </xsl:template>
  <xsl:template match="tei:note[@type='reference']">
    <span class="skt ref"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="tei:foreign[@xml:lang='sa-Latn']">
    <span class="foreign"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="tei:quote">	  
    <span class="quote">
      <xsl:attribute name="class">
	<xsl:value-of select="./@rend"/>
	<xsl:text> quote</xsl:text>
	<xsl:if test="not(descendant::tei:lg)"><xsl:text> skt</xsl:text></xsl:if>
      </xsl:attribute>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:lb">
    <br></br>
  </xsl:template>

  <xsl:template match="tei:l">
    <span class="l skt">
      <xsl:apply-templates/>
      <!--
      <xsl:if test="./ancestor::tei:lg[@n] and not(following-sibling::tei:l)">
	<span class="label label-default verse-label"><xsl:value-of select="./ancestor::tei:lg/@n"/></span>
      </xsl:if> 
      !-->
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

  <xsl:template match="tei:item">
    <li><xsl:apply-templates/></li>
  </xsl:template>

  <xsl:template match="tei:term">
    <a href="" data-toggle="modal">
      <xsl:attribute name="data-target">
	<xsl:value-of select="./@key"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </a>
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

  <xsl:template match="tei:note[@type='commentary']">
    <xsl:variable name="parent-div"
		  select="string(./ancestor::tei:div[@type='aṅka']/@n)"/>
    <xsl:variable name="this-ref"
		  select="string(./ancestor::tei:*[@n][1]/@n)"/>
    <xsl:variable name="id"
		  select="concat(concat($parent-div,'.'),$this-ref)"/>
    <div class="modal fade text-left" id="modal-MaMa.{$id}" tabindex="-1" role="dialog" aria-labelledby="modal-MaMa.{$id}-label">
      <div class="modal-dialog modal-lg" role="document">
	<div class="modal-content">
	  <div class="modal-header">
	    <button type="button" class="close" data-toggle="modal" aria-label="Close"><span aria-hidden="true"><xsl:text disable-output-escaping="yes"><![CDATA[&times;]]></xsl:text></span></button>
	    <h3 id="modal-MaMa.{$id}-label"><em>Rasamañjarī</em> on <em>Mālatīmādhava</em><xsl:text> </xsl:text><xsl:value-of select="$parent-div"/>.<xsl:value-of select="$this-ref"/></h3>
	  </div>
	  <div class="modal-body">
	    <xsl:apply-templates/>
	  </div>
	  <div class="modal-footer">
	    <button type="button" class="btn btn-primary" data-toggle="modal">Close</button>
	  </div>
	</div>
      </div>
    </div>
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

</xsl:stylesheet>
