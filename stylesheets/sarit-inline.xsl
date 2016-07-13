<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="2.0" exclude-result-prefixes="tei">
<!-- This stylesheet covers inline elements not covered
    in other stylesheets !-->
    <xsl:template match="tei:foreign">
<!-- choice of language formatting is kicked down to CSS. !-->
        <span class="{@xml:lang}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>


<!-- NAMES and TITLES will ultimately have URIs. !-->
    <xsl:template match="tei:name[not(ancestor::tei:teiHeader)]">
        <a class="name" href="javascriptei:void(0)">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <xsl:template match="tei:title[not(ancestor::tei:teiHeader)]">
        <xsl:variable name="titleno">
            <xsl:number select="." from="//tei:text" level="any"/>
        </xsl:variable>
        <a class="call-modal" href="#title-{$titleno}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <xsl:template name="title-modal">
        <xsl:variable name="titleno">
            <xsl:number select="." from="//tei:text" level="any"/>
        </xsl:variable>
        <section class="app" id="title-{$titleno}" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-inner">
                <header>
                    <h2>Title</h2>
                </header>
                <div class="modal-content">
                    <span class="appentry">
                        <xsl:value-of select="translate(@key,'#','')"/>
                    </span>
                </div>
            </div>
            <a href="#!" class="modal-close" title="Close this modal" data-dismiss="modal" data-close="Close">×</a>
        </section>
    </xsl:template>
    
    <!-- See sarit-people.xsl for the styling of persName elements. !-->

<!-- Same with TERMS. !-->
    <xsl:template match="tei:term">
        <a class="term" href="#">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <xsl:template match="tei:hi[@rend='bold']">
        <span style="font-weightei:bold">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
</xsl:stylesheet>
