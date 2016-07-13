<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  exclude-result-prefixes="tei">
<!-- This stylesheet ADAPTS elements of the EpiDoc
     stylesheets:
	Tom Elliott, Zaneta Au, Gabriel Bodard, Hugh Cayless, Carmen Lanz,
	Faith Lawrence, Scott Vandebilt, Raffaele Viglianti, et al.
	(2008-2013)
!-->

  <xsl:template name="maps">
    <section class="accordion">
    <xsl:if test="//tei:origPlace">
      <div id="map-container">
	<input id="ac-1" name="accordion-1" type="checkbox" />
	<label for="ac-1">Map of inscription</label>
	<article>
	  <div id="map"></div>
	</article>
      </div>
    </xsl:if>
    <xsl:if test="//tei:facsimile">
      <div id="facsimile-container">
	<input id="ac-2" name="accordion-2" type="checkbox"/>
	<label for="ac-2">Facsimiles</label>
	<article>
	</article>
      </div>
    </xsl:if>
    </section>
    <xsl:apply-templates/>
    <!-- To construct the map, we run the template construct-map,
	 which fetches the #key from origPlace, matches it
	 with a key in the list of places, and feeds that
	 data into MapBox. !-->
    <xsl:call-template name="construct-map"/>
  </xsl:template>

  <xsl:template name="construct-map">
  <!-- get the key from origPlace !-->
  <xsl:variable name="key">
    <xsl:value-of select="translate(//tei:origPlace/@key,'#','')"/>
  </xsl:variable>
  <script>
L.mapbox.accessToken = 'pk.eyJ1IjoiYXNvMjEwMSIsImEiOiJwRGcyeGJBIn0.jbSN_ypYYjlAZJgd4HqDGQ';
L.mapbox.map('map', 'examples.map-i86l3621', {
    scrollWheelZoom: false
}).setView([38.8929,-77.0252], 14);
  </script>
  </xsl:template>


  <xsl:template match="tei:div[@type='edition']">
    <div class="epidoc" id="edition">
      <h2>Edition</h2>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="tei:div[@type='translation']">
    <div class="epidoc" id="translation">
      <h2>Translation</h2>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

   <!-- Templates imported by [htm|txt]teigap.xsl -->
    
   <xsl:template match="tei:gap[@reason='omitted']">
      <xsl:text>&lt;</xsl:text>
      <xsl:call-template name="extent-string"/>
      <xsl:text>&gt;</xsl:text>
   </xsl:template>
   
   <xsl:template match="tei:gap[@reason='ellipsis']">
       <xsl:choose>
	 <xsl:when test="@quantity">
           <xsl:if test="@precision='low'">
             <xsl:text>ca.</xsl:text>
           </xsl:if>
           <xsl:value-of select="@quantity"/>
         </xsl:when>
         <xsl:when test="@atLeast and @atMost">
           <xsl:value-of select="@atLeast"/>
           <xsl:text>-</xsl:text>
           <xsl:value-of select="@atMost"/>
         </xsl:when>
         <xsl:when test="@atLeast ">
           <xsl:text>&#x2265;</xsl:text>
           <xsl:value-of select="@atLeast"/>
         </xsl:when>
         <xsl:when test="@atMost ">
           <xsl:text>&#x2264;</xsl:text>
           <xsl:value-of select="@atMost"/>
         </xsl:when>
         <xsl:otherwise>
           <xsl:text>?</xsl:text>
         </xsl:otherwise>
       </xsl:choose>
       <xsl:text> </xsl:text>
       <xsl:value-of select="@unit"/>
       <xsl:if test="@quantity &gt; 1 or @extent='unknown' or @atLeast or @atMost">
         <xsl:text>s</xsl:text>
       </xsl:if>
       <xsl:if test="string(desc) = 'non transcribed'">
         <xsl:text> untranscribed</xsl:text>
       </xsl:if>
   </xsl:template>


   <xsl:template match="tei:gap[@reason='illegible']">
      <!-- certainty -->
      <xsl:if test="child::tei:certainty[@match='..']">
         <xsl:text>?</xsl:text>
      </xsl:if>

      <xsl:if test="not(preceding::node()[1][self::text()][normalize-space(.)=''][preceding-sibling::node()[1][self::tei:gap[@reason='illegible']]])
         and not(preceding::node()[1][self::tei:gap[@reason='illegible']])">
         <xsl:call-template name="extent-string"/>
      </xsl:if>
   </xsl:template>



   <xsl:template match="tei:gap[@reason='lost']">
     <span class="epidoc"><xsl:text>[</xsl:text>

     <xsl:call-template name="extent-string"/>

      <!-- certainty -->
     <xsl:if test="child::tei:certainty[@match='..']">
       <xsl:text>?</xsl:text>
     </xsl:if>

     <xsl:text>]</xsl:text></span>

   </xsl:template>


   <xsl:template name="extent-string">
      <xsl:variable name="circa">
        <xsl:text>c. </xsl:text>
      </xsl:variable>
      <xsl:variable name="cur-dot">
        <xsl:text>.</xsl:text>
      </xsl:variable>
      <xsl:variable name="cur-max">
	<xsl:number value="40"/>
      </xsl:variable>

      <xsl:choose>
         <xsl:when test="@extent='unknown'">
           <xsl:text> - - - </xsl:text>
         </xsl:when>

         <xsl:when test="@quantity and @unit='character'">
            <xsl:choose>
               <xsl:when test="number(@quantity) &gt; $cur-max or (number(@quantity) &gt; 1 and @precision='low')">
                 <xsl:text> </xsl:text>
                 <xsl:value-of select="$cur-dot"/>
                 <xsl:text> </xsl:text>
		 <xsl:value-of select="$cur-dot"/>
                 <xsl:text> </xsl:text>
                 <xsl:value-of select="$circa"/>
		 <xsl:value-of select="@quantity"/>
                 <xsl:text> </xsl:text>
                 <xsl:value-of select="$cur-dot"/>
                 <xsl:text> </xsl:text>
                 <xsl:value-of select="$cur-dot"/>
                 <xsl:text> </xsl:text>
               </xsl:when>

               <xsl:when test="$cur-max &gt;= number(@quantity)">
                 <xsl:call-template name="dot-out">
                   <xsl:with-param name="cur-num" select="number(@quantity)"/>
                 </xsl:call-template>
               </xsl:when>

               <xsl:otherwise>
                 <xsl:text> - - - </xsl:text>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>

          <xsl:when test="@atLeast and @atMost">
            <!-- reason illegible and lost caught in the otherwise -->
            <xsl:text>c. </xsl:text>
            <xsl:value-of select="@atLeast"/>
            <xsl:text> - </xsl:text>
            <xsl:value-of select="@atMost"/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <!-- Template for lost verse, metre known -->
   <xsl:template name="verse-string">
      <xsl:choose>
         <xsl:when test="parentei::tei:seg[contains(@real,'+') or contains(@real,'-')]">
            <xsl:call-template name="scansion">
               <xsl:with-param name="met-string" select="translate(parentei::tei:seg/@real, '+-','ˉ˘')"/>
               <xsl:with-param name="string-len" select="string-length(parentei::tei:seg/@real)"/>
               <xsl:with-param name="string-pos" select="string-length(parentei::tei:seg/@real) - 1"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="parentei::tei:seg[contains(@met,'+') or contains(@met,'-')]">
            <xsl:call-template name="scansion">
               <xsl:with-param name="met-string" select="translate(parentei::tei:seg/@met, '+-','ˉ˘')"/>
               <xsl:with-param name="string-len" select="string-length(parentei::tei:seg/@met)"/>
               <xsl:with-param name="string-pos" select="string-length(parentei::tei:seg/@met) - 1"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="extent-string"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- print macron and breve with intervening hard-spaces -->
   <xsl:template name="scansion">
      <xsl:param name="met-string"/>
      <xsl:param name="string-len"/>
      <xsl:param name="string-pos"/>
      <xsl:if test="$string-pos > -1">
         <xsl:text>&#xa0;</xsl:text>
         <xsl:value-of select="substring($met-string, number($string-len - $string-pos), 1)"/>
         <xsl:text>&#xa0;</xsl:text>
         <xsl:call-template name="scansion">
            <xsl:with-param name="met-string" select="$met-string"/>
            <xsl:with-param name="string-len" select="$string-len"/>
            <xsl:with-param name="string-pos" select="$string-pos - 1"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>

   <!-- Template for vestiges -->
   <xsl:template name="tpl-vest">
      <xsl:param name="circa"/>
      <xsl:text>Traces</xsl:text>
      <xsl:choose>
         <xsl:when test="@extent = 'unknown'">
            <xsl:if test="@unit='line'">
               <xsl:text> ?  lines</xsl:text>
            </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$circa"/>
            <xsl:text> </xsl:text>
            <xsl:choose>
               <xsl:when test="string(@atLeast) and string(@atMost)">
                  <xsl:value-of select="@atLeast"/>
                  <xsl:text>-</xsl:text>
                  <xsl:value-of select="@atMost"/>
               </xsl:when>
               <xsl:when test="string(@quantity)">
                  <xsl:value-of select="@quantity"/>
               </xsl:when>
            </xsl:choose>
            <xsl:choose>
               <xsl:when test="@unit = 'line'">
                  <xsl:text> line</xsl:text>
                  <xsl:if test="number(@quantity) &gt; 1 or number(@atMost) &gt; 1">
                     <xsl:text>s</xsl:text>
                  </xsl:if>
               </xsl:when>
               <xsl:when test="@unit = 'character'">
                  <xsl:text> character</xsl:text>
                  <xsl:if test="number(@quantity) &gt; 1 or number(@atMost) &gt; 1">
                     <xsl:text>s</xsl:text>
                  </xsl:if>
               </xsl:when>
               <xsl:when test="@unit = 'cm'">
                  <xsl:text> cm</xsl:text>
               </xsl:when>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>


   <!-- Production of dots -->
   <xsl:template name="dot-out">
       <xsl:param name="cur-num"/>
       <xsl:variable name="cur-dot">.</xsl:variable>
       
      <xsl:if test="$cur-num &gt; 0">
         <xsl:value-of select="$cur-dot"/>

         <xsl:call-template name="dot-out">
            <xsl:with-param name="cur-num" select="$cur-num - 1"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>

  <!-- Imported by [htm|txt]-teilb.xsl -->

  <xsl:template match="tei:div[@type='edition']//tei:lb">
  <br/>
  <span class="lineno"><xsl:value-of select="@n"/></span>
  </xsl:template>
  
</xsl:stylesheet>
