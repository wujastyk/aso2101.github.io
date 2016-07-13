<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="2.0" exclude-result-prefixes="tei xi fn">
    <xsl:output method="html" indent="no" encoding="UTF-8" version="4.0" doctype-system="http://www.w3.org/TR/html4/strict.dtd" doctype-public="-//W3C//DTD HTML 4.01//EN"/>
<!-- This is the base file for SARIT's stylesheets. !-->

<!-- The file for elements in the TEI header. !-->
    <xsl:include href="sarit-header.xsl"/>

<!-- The file for bibliography-type elements. !-->
    <xsl:include href="sarit-bibl.xsl"/>

<!-- The file for prosopographic-type elements. !-->
    <xsl:include href="sarit-people.xsl"/>
    <xsl:template match="tei:TEI">
        <xsl:call-template name="maps"/>
    </xsl:template>
    <xsl:template match="tei:text">
<!-- This is for generating a table of contents. 
     The whole routine can be deleted if it's not
     needed. !-->
        <section class="toc" id="toc">
            <div class="modal-inner" tabindex="-1" role="dialog" aria-hidden="true">
                <header>
                    <h2>Table of Contents</h2>
                </header>
                <div class="modal-content">
                    <ul>
                        <xsl:for-each select="./tei:body/tei:div">
                            <li>
                                <a href="#{@type}{@n}">
                                    <xsl:call-template name="toc-heading"/>
                                </a>
                            </li>
                            <xsl:for-each select="./tei:div">
                                <li>
                                    <a href="#{@type}{@n}">
                                        <xsl:text>» </xsl:text>
                                        <xsl:call-template name="toc-heading"/>
                                    </a>
                                </li>
                                <xsl:for-each select="./tei:div">
                                    <li>
                                        <a href="#{@type}{@n}">
                                            <xsl:text>»» </xsl:text>
                                            <xsl:call-template name="toc-heading"/>
                                        </a>
                                    </li>
                                </xsl:for-each>
                            </xsl:for-each>
                        </xsl:for-each>
                        <li>
                            <a href="#teiHeader">
                                <xsl:text>Notes</xsl:text>
                            </a>
                        </li>
                        <xsl:if test="//tei:listBibl">
                            <li>
                                <a href="#bibliography">
                                    <xsl:text>» Printed sources</xsl:text>
                                </a>
                            </li>
                        </xsl:if>
                        <xsl:if test="//tei:listWit">
                            <li>
                                <a href="#manuscript">
                                    <xsl:text>» Manuscript sources</xsl:text>
                                </a>
                            </li>
                        </xsl:if>
                        <xsl:if test="//tei:listPerson">
                            <li>
                                <a href="#people">
                                    <xsl:text>» Prosopography</xsl:text>
                                </a>
                            </li>
                        </xsl:if>
                    </ul>
                </div>
            </div>
            <a href="#!" class="modal-close" title="Close this modal" data-dismiss="modal" data-close="Close">×</a>
        </section>
        <div id="toc-toggle">
            <a href="#toc">Table of Contents</a>
        </div>
<!-- End table of contents routine !-->

<!-- The main body of the document goes here !-->
        <xsl:apply-templates/>

<!-- Gather apparatus entries and other such 
     things at the bottom of the text,
     as <section>s (modals) !-->
        <xsl:apply-templates mode="modal"/>

        <xsl:for-each select=".//tei:persName">
            <xsl:call-template name="persName-modal"/>
        </xsl:for-each>
        <xsl:for-each select=".//tei:persName[not(.=preceding::tei:persName)]">
            <xsl:call-template name="persName-index-modal"/>
        </xsl:for-each>
        <xsl:for-each select=".//tei:title">
            <xsl:call-template name="title-modal"/>
        </xsl:for-each>
        <xsl:for-each select=".//tei:ref[@type='lemma']">
            <xsl:call-template name="lemma-modal"/>
        </xsl:for-each>
        <xsl:for-each select=".//tei:ref[not(@type='lemma')]">
            <xsl:call-template name="ref-modal"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="toc-heading">
        <xsl:choose>
            <xsl:when test="tei:head[@type='toc']">
                <xsl:value-of select="tei:head[@type='toc']"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="tei:head">
                        <xsl:value-of select="tei:head"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="@type='edition'">
                                <xsl:text>Edition</xsl:text>
                            </xsl:when>
                            <xsl:when test="@type='translation'">
                                <xsl:text>Translation</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@type"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="@n"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:body">
        <div class="body">
            <xsl:if test="//tei:titleStmt/tei:title">
                <h2>
                    <xsl:value-of select="//tei:titleStmt/tei:title"/>
                </h2>
            </xsl:if><!-- Call title statement first !-->
            <xsl:if test="//tei:publicationStmt">
                <span class="classifyinginfo">
                    <xsl:value-of select="//tei:idno"/>
                </span>
            </xsl:if>
            <xsl:apply-templates/>
            <xsl:call-template name="header"/>
  <!-- call the rest of the header after !-->
        </div>
    </xsl:template>

<!-- The file for elements specific to dramatic texts. !-->
    <xsl:include href="sarit-drama.xsl"/>

<!-- The file for miscellaneous inline elements. !-->
    <xsl:include href="sarit-inline.xsl"/>

<!-- The file for quotations !-->
    <xsl:include href="sarit-quotations.xsl"/>

<!-- The file for notes !-->
    <xsl:include href="sarit-note.xsl"/>

<!-- The file for textual variation !-->
    <xsl:include href="sarit-app.xsl"/>

<!-- EPIDOC is included. !-->
    <xsl:include href="sarit-epidoc.xsl"/>
    <xsl:template match="tei:pb">
        <span class="page">
            <xsl:value-of select="@n"/>
        </span>
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
    <xsl:template match="tei:caesura">
      <span class="caesura"/>
    </xsl:template>
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>

<!-- For <div>, <p>, and <lg> (at least), it might be useful to
      include labels from @n, even though most of the 
      referencing/retrieval functions will be performed
      from the XML, and not from the HTML. !-->

<!-- These are the "top-level" divisions:
     I think of these as like chapters. Each (as it were)
     begins on a new page. It might be convenient to gather
     notes at the end of these divisions. !-->
    <xsl:template match="tei:div[@type='prakāśa'] | tei:div[@type='adhyāya'] | tei:div[@type='pāda'] | tei:div[@type='parvan'] | tei:div[@type='sarga'] | tei:div[@type='aṅka'] | tei:div[@type='ucchvāsa'] | tei:div[@type='javanikāntara'] | tei:div[@type='textpart']">
        <div class="toplevel">
            <xsl:if test="@n">
                <a id="{@type}{@n}"/>
            </xsl:if>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

<!-- These are smaller divisions. !-->
    <xsl:template match="tei:div[@type='adhikaraṇa'] | tei:div[@type='section']">
        <div class="lowerlevel">
            <xsl:if test="@n">
                <a id="{@type}{@n}"/>
            </xsl:if>
            <xsl:apply-templates/>
        </div>
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
        <xsl:choose>
            <xsl:when test="self::tei:head[@type='toc']"/>
            <xsl:otherwise>
                <span class="head">
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

<!-- Trailer !-->
    <xsl:template match="tei:trailer[not(ancestor::tei:teiHeader)]">
        <span class="trailer">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
</xsl:stylesheet>
