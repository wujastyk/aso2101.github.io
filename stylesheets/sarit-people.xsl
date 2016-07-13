<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="2.0" exclude-result-prefixes="t xi fn">
<!-- This stylesheet covers prosopographic elements
     (mainly listPerson) !-->
     
    <!-- This just locates the local authority file. !-->
    <xsl:variable name="personAuthority" select="document('../contextual/listPerson.xml')"/>
    
    <!-- This template constructs the "People mentioned" section 
         at the bottom of the page. !-->
    <xsl:template name="personography">
        <div id="people" class="epidoc">
        <!-- Just like the bibliography,
    	 we match the in-file list of
    	 people to the list for the entire
    	 project. !-->
            <h3>People mentioned</h3>
            <!-- iterate through each UNIQUE person. !-->
            <xsl:for-each select="//t:persName[not(@key = preceding::t:persName/@key)]">
                <!-- here we should call an XQuery function, but for now it is implemented in 
                     XSLT. !-->
                <xsl:variable name="id" select="substring-after(@key,'pers:')"/>
                <div class="person" data-template="app:generate-person-entry" data-template-key="{$id}">
                    <!-- delete this stuff when the stylesheets move to XQuery !-->
                    <!-- only call if the person is actually located in the authority file !-->
                    <xsl:if test="$personAuthority//t:person[@xml:id = $id]">
                        <xsl:variable name="person" select="$personAuthority//t:person[@xml:id = $id]"/>
                        <a name="{$person/@xml:id}"/>
                        <h4>
                            <xsl:value-of select="$person/t:persName/text()"/>
                        </h4>
                        <div class="personentry">
                            <xsl:if test="$person/@sex">
                                <em>
                                    <xsl:text>Gender</xsl:text>
                                </em>
                                <xsl:text>: </xsl:text>
                                <xsl:value-of select="$person/@sex"/>
                                <br/>
                            </xsl:if>
                            <xsl:if test="$person/t:occupation">
                                <em>
                                    <xsl:text>Occupation</xsl:text>
                                </em>
                                <xsl:text>: </xsl:text>
                                <xsl:value-of select="$person/t:occupation/text()"/>
                                <br/>
                            </xsl:if>
                            <xsl:if test="$person/t:trait[@ethnicity]">
                                <em>
                                    <xsl:text>Ethnicity</xsl:text>
                                </em>
                                <xsl:text>: </xsl:text>
                                <xsl:value-of select="$person/t:trait[@ethnicity]/text()"/>
                                <br/>
                            </xsl:if>
                            <xsl:if test="$person/t:faith">
                                <em>
                                    <xsl:text>Religion</xsl:text>
                                </em>
                                <xsl:text>: </xsl:text>
                                <xsl:value-of select="$person/t:faith"/>
                                <br/>
                            </xsl:if>
                            <xsl:if test="$person/t:state[@religious]">
                                <em>
                                    <xsl:text>Religious status</xsl:text>
                                </em>
                                <xsl:text>: </xsl:text>
                                <xsl:value-of select="$person/t:state[@religious]/text()"/>
                                <br/>
                            </xsl:if>
                            <xsl:if test="$person/t:state[@political]">
                                <em>
                                    <xsl:text>Political status</xsl:text>
                                </em>
                                <xsl:text>: </xsl:text>
                                <xsl:value-of select="$person/t:state[@political]/text()"/>
                                <br/>
                            </xsl:if>
                        </div>
                    </xsl:if>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    
    <!-- The following templates match names of persons *in the text*
         and currently open up a modal, which can point down to the 
         "Persons mentioned" section. !-->
    <xsl:template match="t:persName[not(ancestor::t:div[@type='edition'])]">
        <xsl:variable name="persno">
            <xsl:number select="." from="//t:div" level="any"/>
        </xsl:variable>
        <a class="call-modal anchor" href="#pers-{$persno}" id="a-pers-{$persno}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <xsl:template match="t:persName[ancestor::t:div[@type='edition']]">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>
    <xsl:template name="persName-modal">
        <xsl:variable name="persno">
            <xsl:number select="." from="//t:div" level="any"/>
        </xsl:variable>
        <section class="app" id="pers-{$persno}" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-inner">
                <header>
                    <h2>Person</h2>
                </header>
                <div class="modal-content">
                    <xsl:choose>
                        <!-- This uses the "appentry" class to construct a short
                        entry for the person concerned. !-->
                        <xsl:when test="@key">
                            <xsl:variable name="key" select="@key"/>
                            <xsl:variable name="modkey" select="substring-after($key,'pers:')"/>
                            <span class="appentry">
                                <xsl:choose>
                                    <xsl:when test="$personAuthority//t:person[@xml:id = $modkey]">
                                        <a href="#{$modkey}">
                                            <xsl:value-of select="$personAuthority//t:person[@xml:id = $modkey]/persName/text()"/>
                                        </a>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>[No entry found in authority file.]</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
	                            <!-- <xsl:text> WHAT WILL GO HERE? </xsl:text> !-->
                            </span>
                            <!-- This is a simple navigation function for the modal. !-->
                            <xsl:if test="ancestor::div//preceding::t:persName[@key = $key] | ancestor::div//following::t:persName[@key = $key]">
                                <span class="nav">
                                    <xsl:if test="ancestor::div//preceding::t:persName[@key = $key]">
                                        <xsl:variable name="prev">
                                            <xsl:value-of select="count(ancestor::div//preceding::t:persName[@key = $key]/preceding::t:persName)"/>
                                        </xsl:variable>
                                        <a href="#pers-{$prev}" class="call-modal" onclick="return scrollTo('a-pers-{$prev}');">
                                            <xsl:text>prev</xsl:text>
                                        </a>
                                    </xsl:if>
                                    <xsl:if test="ancestor::div//preceding::t:persName[@key = $key] and ancestor::div//following::t:persName[@key = $key]">
                                        <xsl:text> | </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ancestor::div//following::t:persName[@key = $key]">
                                        <xsl:variable name="next">
                                            <xsl:value-of select="count(ancestor::div//following::t:persName[@key = $key][1]/preceding::t:persName)"/>
                                        </xsl:variable>
                                        <a href="#pers-{$next}" class="call-modal" onclick="return scrollTo('a-pers-{$next}');">
                                            <xsl:text>next</xsl:text>
                                        </a>
                                    </xsl:if>
                                </span>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="appentry">
                                <xsl:text>[No entry found in authority file.]</xsl:text>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </div>
            <a href="#!" class="modal-close" title="Close this modal" data-dismiss="modal" data-close="Close">×</a>
        </section>
    </xsl:template>

<!-- Don't know what to do with this yet. !-->
    <xsl:template name="persName-index-modal">
        <section class="app" id="{translate(@key,'#','')}" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-inner">
                <header>
                    <h2>
                        <xsl:value-of select="translate(@key,'#','')"/>
                    </h2>
                </header>
                <div class="modal-content"/>
            </div>
            <a href="#!" class="modal-close" title="Close this modal" data-dismiss="modal" data-close="Close">×</a>
        </section>
    </xsl:template>
</xsl:stylesheet>
