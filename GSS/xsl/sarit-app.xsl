<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:str="http://exslt.org/strings"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" version="2.0" exclude-result-prefixes="tei fn str">
  <!-- This stylesheet covers textual variation !-->

  <!-- AT THE MOMENT, without a good way to display variants
       (jQuery tooltips are one option), everything in the <app>
       element besides the reading is just deleted. !-->
  <xsl:template match="tei:app">
    <xsl:variable name="appno">
      <xsl:number count="tei:app" level="any" from="//tei:group"/>
    </xsl:variable>
    <a href="#{generate-id()}" rel="modal:open">
      <xsl:choose>
	<!-- IF THERE IS A LEMMA, PRINT IT. !-->
        <xsl:when test="tei:lem">
          <xsl:apply-templates select="tei:lem"/>
        </xsl:when>
	<!-- OTHERWISE, PRINT AN ASTERISK. !-->
        <xsl:otherwise>
          <xsl:text>*</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>

  <xsl:template match="tei:note">
    <xsl:variable name="noteno">
      <xsl:number count="tei:note" level="any" from="//tei:group"/>
    </xsl:variable>
    <a href="#{generate-id()}" rel="modal:open"><xsl:text>*</xsl:text></a>
  </xsl:template>

  <!-- during the modal mode, disregard anything that is not 
       either an apparatus entry or a note. !-->
  <xsl:template match="text()" mode="modal"/>
  <xsl:template match="tei:app//tei:note" mode="modal"/>

  <xsl:template match="tei:note" mode="modal">
    <!-- modal for non-apparatus notes !-->
    <div id="{generate-id()}" class="modal" style="display:none;">
      <xsl:choose>
	<xsl:when test="@type='marginal'">
	  <h3>Marginal note</h3>
	</xsl:when>
	<xsl:when test="@type='interlinear'">
	  <h3>Interlinear note</h3>
	</xsl:when>
	<xsl:otherwise>
	  <h3>Note</h3>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:if test="@resp">
	<span>By </span>
	<xsl:call-template name="sigla-string">
          <xsl:with-param name="siglum" select="@resp"/>
        </xsl:call-template>
      </xsl:if>
      <div class="notecontent">
	<xsl:apply-templates/>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="tei:app" mode="modal">
    <div id="{generate-id()}" class="modal" style="display:none;">
      <h3>Apparatus</h3>
      <xsl:if test="tei:lem/@wit"><!-- if the LEM element has a WIT value,
				       put it in the pop-up apparatus !-->
        <span class="appentry">
          <xsl:call-template name="sigla-string">
            <xsl:with-param name="siglum" select="tei:lem/@wit"/>
          </xsl:call-template>
          <xsl:text>: </xsl:text>
          <xsl:apply-templates select="tei:lem"/>
        </span>
      </xsl:if>
      <xsl:for-each select="tei:rdg"><!-- ONE FOR RDG, ONE FOR NOTE !-->
        <span class="appentry">
	  <!-- if there is witness information, add it !-->
          <xsl:if test="@wit">
            <xsl:call-template name="sigla-string">
              <xsl:with-param name="siglum" select="@wit"/>
            </xsl:call-template>
	    <xsl:if test="@type='chaya'">
	      <xsl:text> (Sanskrit gloss)</xsl:text>
	    </xsl:if>
            <xsl:choose>
	      <xsl:when test="./text()">
		<xsl:text>: </xsl:text>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:text>omits</xsl:text>
	      </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
	  <!-- if the reading is attested in a sanskrit chāyā, make a 
	       note of it !-->
          <xsl:apply-templates select="."/>
        </span>
      </xsl:for-each>
      <xsl:for-each select="tei:note"><!-- NOTE !-->
        <span class="appentry">
          <span class="siglum">
            <xsl:text>Note</xsl:text>
          </span>
          <xsl:text>: </xsl:text>
          <xsl:apply-templates select="."/>
        </span>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template name="sigla-string">
    <xsl:param name="siglum"/>
    <xsl:for-each select="str:tokenize(translate($siglum,'#',''),' ')">
      <a href="#{.}">
        <xsl:value-of select="."/>
      </a>
    </xsl:for-each>
  </xsl:template>

  <!-- Right now, I am dealing with deletions this way. But
       probably I should target the subst element. !-->
  <xsl:template match="tei:del">
    <span class="deletion-overstrike"><xsl:apply-templates/></span>
  </xsl:template>
  <!-- also just read the uncorrected text in the edition
       (eventually this should go into an apparatus entry) !-->
  <xsl:template match="tei:corr"/>

  <xsl:template match="tei:supplied">
    <span class="restored"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="tei:space">
    <xsl:variable name="sp-ext">
      <xsl:number value="@quantity"/>
    </xsl:variable>
    <xsl:for-each select="1 to $sp-ext">
      <xsl:text>-</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:gap">
    <xsl:variable name="sp-ext">
      <xsl:number value="@quantity"/>
    </xsl:variable>
    <xsl:for-each select="1 to $sp-ext">
      <xsl:text>.</xsl:text>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
