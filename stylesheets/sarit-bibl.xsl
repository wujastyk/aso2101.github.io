<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="2.0" exclude-result-prefixes="t xi fn">
<!-- This stylesheet covers bibliographic elements. !-->

    <!-- This just locates the local authority file. !-->
    <xsl:variable name="biblAuthority" select="document('../contextual/listBibl.xml')"/>
    <xsl:variable name="witAuthority" select="document('../contextual/listWit.xml')"/>
    <xsl:template match="t:listBibl"/>
    <xsl:template match="t:bibl"/>
    <xsl:template match="t:bibl[@key]">
        <xsl:variable name="key" select="substring-after(@key,'bibl:')"/>
        <a href="#{$key}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <xsl:template name="printed-sources">
        <xsl:for-each select="//t:bibl[@key] | //t:lem[@wit] | //t:rdg[@wit]">
            <xsl:variable name="key">
                <xsl:choose>
                    <xsl:when test="self::*[@wit]">
                        <xsl:for-each select="tokenize(translate(@wit,'#',''),' ')">
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="self::*[@key]">
                        <xsl:value-of select="substring-after(@key,'bibl:')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- select only if they are unique !-->
                <!-- select only if they are referenced in the biblAuthority file !-->
            <xsl:if test="$biblAuthority//bibl[@xml:id=$key]">
                <xsl:variable name="bibl" select="$biblAuthority//bibl[@xml:id=$key]"/>
                <div class="bibentry">
                    <a name="{$key}"/>
                    <xsl:value-of select="$key"/>
                    <xsl:text> = </xsl:text>
                    <xsl:call-template name="construct-full-entry">
                        <xsl:with-param name="fullentry" select="$bibl"/>
                    </xsl:call-template>
                </div>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="bibliography">
        <div id="bibliography" class="epidoc">
            <!-- Match the items that triggered this call to the corresponding
                 authority files, and create the listing at the bottom of the 
                 page !-->
            <h3>Bibliography</h3>
            <xsl:if test="//*/@wit | //t:bibl/@key">
                <!-- This collects all of the instances into a single variable. !-->
                <xsl:variable name="all-tokens">
                    <xsl:call-template name="collect-tokens"/>
                </xsl:variable>
                <!-- Now we can get distinct values. !-->
                <xsl:for-each select="distinct-values(tokenize($all-tokens,' '))">
                    <xsl:variable name="key" select="."/>
                    <xsl:variable name="fullentry" select="$biblAuthority//bibl[@xml:id = $key]"/>
                    <xsl:if test="$fullentry">
                        <div class="bibentry">
                            <xsl:call-template name="construct-full-entry">
                                <xsl:with-param name="fullentry" select="$fullentry"/>
                            </xsl:call-template>
                        </div>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </div>
    </xsl:template>
    <xsl:template name="collect-tokens">
        <xsl:for-each select="//*/@wit">
            <xsl:for-each select="tokenize(.,' ')">
                <xsl:value-of select="substring-after(.,'#')"/>
                <xsl:text> </xsl:text>
            </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="//t:bibl/@key">
            <xsl:value-of select="substring-after(.,'bibl:')"/>
            <xsl:text> </xsl:text>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="construct-full-entry">
        <xsl:param name="fullentry"/>
        <a name="{$fullentry/@xml:id}">
            <xsl:value-of select="$fullentry/@xml:id"/>
        </a>
        <xsl:text> = </xsl:text>
        <xsl:choose>
            <xsl:when test="$fullentry/title[@level='j']">
      <!-- Call JOURNAL ARTICLE template. !-->
                <xsl:call-template name="journal">
                    <xsl:with-param name="fullentry" select="$fullentry"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$fullentry/title[@level='a'] and t:bibl">
      <!-- Call IN COLLECTION template. !-->
                <xsl:call-template name="incollection">
                    <xsl:with-param name="fullentry" select="$fullentry"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
      <!-- Otherwise call BOOK template. !-->
                <xsl:call-template name="book">
                    <xsl:with-param name="fullentry" select="$fullentry"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="bibl//* | bibl//@*"/>
<!-- So these things don't get in the way of the
     templates !-->

<!-- JOURNAL ARTICLE template. !-->
    <xsl:template name="journal">
        <xsl:param name="fullentry"/>
        <xsl:call-template name="author-editor">
            <xsl:with-param name="fullentry" select="$fullentry"/>
        </xsl:call-template>
        <xsl:call-template name="article-title">
            <xsl:with-param name="fullentry" select="$fullentry"/>
        </xsl:call-template>
        <xsl:call-template name="journal-information">
            <xsl:with-param name="fullentry" select="$fullentry"/>
        </xsl:call-template>
    </xsl:template>

<!-- IN COLLECTION template. !-->
    <xsl:template name="incollection">
        <xsl:param name="fullentry"/>
        <xsl:call-template name="author-editor">
            <xsl:with-param name="fullentry" select="$fullentry"/>
        </xsl:call-template>
        <xsl:call-template name="article-title">
            <xsl:with-param name="fullentry" select="$fullentry"/>
        </xsl:call-template>
        <xsl:call-template name="incoll">
            <xsl:with-param name="fullentry" select="$fullentry"/>
        </xsl:call-template>
        <xsl:call-template name="pagerange">
            <xsl:with-param name="fullentry" select="$fullentry"/>
        </xsl:call-template>
    </xsl:template>

<!-- BOOK template. !-->
    <xsl:template name="book">
        <xsl:param name="fullentry"/>
        <xsl:call-template name="author-editor">
            <xsl:with-param name="fullentry" select="$fullentry"/>
        </xsl:call-template>
        <xsl:call-template name="book-title">
            <xsl:with-param name="fullentry" select="$fullentry"/>
        </xsl:call-template>
        <xsl:call-template name="book-imprint">
            <xsl:with-param name="fullentry" select="$fullentry"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="author-editor">
        <xsl:param name="fullentry"/>
        <xsl:for-each select="$fullentry/author | $fullentry/editor">
            <xsl:choose>
                <xsl:when test="not(preceding-sibling::author) or not(preceding-sibling::editor)">
                    <xsl:value-of select=".//surname"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select=".//forename"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="not(following-sibling::author) or not(following-sibling::editor)">
                            <xsl:text> and </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>, </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select=".//forename"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select=".//surname"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="self::editor">
                <xsl:text>(ed.)</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>. </xsl:text>
    </xsl:template>
    <xsl:template name="article-title">
        <xsl:param name="fullentry"/>
        <xsl:text>“</xsl:text>
        <xsl:value-of select="$fullentry/title[@level='a']/text()"/>
        <xsl:text>.” </xsl:text>
    </xsl:template>
    <xsl:template name="journal-information">
        <xsl:param name="fullentry"/>
        <em>
            <xsl:value-of select="$fullentry/title[@level='j']/text()"/>
        </em>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$fullentry/biblScope[@unit='vol']/text()"/>
        <xsl:text> </xsl:text>
        <xsl:text>(</xsl:text>
        <xsl:value-of select="$fullentry/date/text()"/>
        <xsl:text>): </xsl:text>
        <xsl:value-of select="$fullentry/biblScope[@unit='pp']/text()"/>
        <xsl:text>.</xsl:text>
    </xsl:template>
    <xsl:template name="book-title">
        <xsl:param name="fullentry"/>
        <em>
            <xsl:value-of select="$fullentry/title[@level='m']/text()"/>
        </em>
        <xsl:text>. </xsl:text>
    </xsl:template>
    <xsl:template name="incoll">
        <xsl:param name="fullentry"/>
        <xsl:text>In </xsl:text>
        <xsl:for-each select="$fullentry/bibl[@type='monogr']">
            <xsl:call-template name="author-editor">
                <xsl:with-param name="fullentry" select="$fullentry"/>
            </xsl:call-template>
            <xsl:text>, </xsl:text>
            <xsl:call-template name="book-title">
                <xsl:with-param name="fullentry" select="$fullentry"/>
            </xsl:call-template>
            <xsl:text>, pp. </xsl:text>
            <xsl:value-of select="$fullentry/biblScope[@unit='pp']/text()"/>
            <xsl:text>. </xsl:text>
            <xsl:call-template name="book-imprint">
                <xsl:with-param name="fullentry" select="$fullentry"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="book-imprint">
        <xsl:param name="fullentry"/>
        <xsl:value-of select="$fullentry/pubPlace"/>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="$fullentry/publisher"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="$fullentry/date"/>
        <xsl:text>.</xsl:text>
    </xsl:template>
    <xsl:template name="pagerange">
        <xsl:param name="fullentry"/>
    </xsl:template>

    <xsl:template name="references">
      <div id="references" class="epidoc">
      <!-- List all of the references found in the text !-->
        <h3>References</h3>
	<xsl:if test="//*/@cRef">
	  <ul>
	    <xsl:for-each select="//*/@cRef">
	      <li><xsl:value-of select="."/></li>
	    </xsl:for-each>
	  </ul>
	</xsl:if>
      </div>
    </xsl:template>

</xsl:stylesheet>
