<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                version="2.0"
                exclude-result-prefixes="xs dita-ot">

  <xsl:import href="plugin:org.dita.html5:xsl/dita2html5Impl.xsl"/>

  <xsl:output method="html"
              encoding="UTF-8"
              indent="no"
              omit-xml-declaration="yes"/>

  <xsl:param name="commit"/>
  <xsl:param name="layout" select="'base'" as="xs:string"/>

  <xsl:template match="/">
    <xsl:apply-templates select="*" mode="jekyll-front-matter"/>
    <xsl:apply-templates select="*" mode="chapterBody"/>
  </xsl:template>

  <xsl:template match="node()" mode="jekyll-front-matter">
    <xsl:text>---&#xA;</xsl:text>
    <xsl:text># Generated from DITA source&#xA;</xsl:text>
    <xsl:text>layout: </xsl:text>
    <xsl:apply-templates select="." mode="jekyll-layout"/>
    <xsl:text>&#xA;</xsl:text>
    <xsl:text>title: '</xsl:text>
    <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="text-only"/>
    <xsl:text>'&#xA;</xsl:text>
    <xsl:variable name="shortdescs" as="element()*"
                  select="*[contains(@class, ' topic/shortdesc ')] |
                          *[contains(@class, ' topic/abstract ')]/*[contains(@class, ' topic/shortdesc ')]"/>
    <xsl:if test="exists($shortdescs)">
      <xsl:text>description: '</xsl:text>
      <xsl:for-each select="$shortdescs">
        <xsl:if test="position() ne 1">
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="." mode="text-only"/>
      </xsl:for-each>
      <xsl:text>'&#xA;</xsl:text>
    </xsl:if>
    <xsl:text>index: '</xsl:text>
    <xsl:value-of select="concat($PATH2PROJ, 'toc', $OUTEXT)"/>
    <xsl:text>'&#xA;</xsl:text>
    <xsl:if test="normalize-space($commit)">
      <xsl:text>commit: '</xsl:text>
      <xsl:value-of select="normalize-space($commit)"/>
      <xsl:text>'&#xA;</xsl:text>
    </xsl:if>
    <xsl:if test="(/* | /*/*[contains(@class, ' topic/title ')])[tokenize(@outputclass, '\s+') = 'generated']">
      <xsl:text>generated: true</xsl:text>
      <xsl:text>&#xA;</xsl:text>
    </xsl:if>
    <xsl:text>---&#xA;&#xA;</xsl:text>
  </xsl:template>

  <!-- Jekyll’s base layout adds the <body> element, so skip that (and related ID/attributes/outputclass/aname) here -->
  <xsl:template match="*" mode="chapterBody">
    <!--
    <body>
      <xsl:apply-templates select="." mode="addAttributesToHtmlBodyElement"/>
      <xsl:call-template name="setaname"/>  <!-\- For HTML4 compatibility, if needed -\-> 
      -->
      <xsl:apply-templates select="." mode="addHeaderToHtmlBodyElement"/>

      <!-- Include a user's XSL call here to generate a toc based on what's a child of topic -->
      <xsl:call-template name="gen-user-sidetoc"/>

      <xsl:apply-templates select="." mode="addContentToHtmlBodyElement"/>
      <xsl:apply-templates select="." mode="addFooterToHtmlBodyElement"/>
    <!--
    </body>
    -->
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="node()" mode="jekyll-layout" as="xs:string">
    <xsl:value-of select="$layout"/>
  </xsl:template>

  <xsl:attribute-set name="main">
    <xsl:attribute name="class">col-lg-9</xsl:attribute>
    <xsl:attribute name="role">main</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="toc">
    <xsl:attribute name="class">col-lg-3</xsl:attribute>
    <xsl:attribute name="role">toc</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="nav.ul">
    <xsl:attribute name="class">nav nav-list</xsl:attribute>
  </xsl:attribute-set>

</xsl:stylesheet>
