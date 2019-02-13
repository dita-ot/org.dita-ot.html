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
    <xsl:text>title: "</xsl:text>
    <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="text-only"/>
    <xsl:text>"&#xA;</xsl:text>
    <xsl:text>index: "</xsl:text>
    <xsl:value-of select="concat($PATH2PROJ, 'toc', $OUTEXT)"/>
    <xsl:text>"&#xA;</xsl:text>
    <xsl:if test="normalize-space($commit)">
      <xsl:text>commit: "</xsl:text>
      <xsl:value-of select="normalize-space($commit)"/>
      <xsl:text>"&#xA;</xsl:text>
    </xsl:if>
    <xsl:if test="(/* | /*/*[contains(@class, ' topic/title ')])[tokenize(@outputclass, '\s+') = 'generated']">
      <xsl:text>generated: true</xsl:text>
      <xsl:text>&#xA;</xsl:text>
    </xsl:if>
    <xsl:text>---&#xA;</xsl:text>
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

  <!-- Override `nav.xsl` to add Bootstrap classes -->
  <xsl:template match="*" mode="gen-user-sidetoc">
    <xsl:if test="$nav-toc = ('partial', 'full')">
      <nav xsl:use-attribute-sets="toc">
        <!-- ↓ Wrap <ul> in small well <div> & add .bs-docs-sidenav class -->
        <div class="well well-sm">
          <ul class="bs-docs-sidenav">
            <!-- ↑ End customization -->
            <xsl:choose>
              <xsl:when test="$nav-toc = 'partial'">
                <xsl:apply-templates select="$current-topicref" mode="toc-pull">
                  <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                  <xsl:with-param name="children" as="element()*">
                    <xsl:apply-templates select="$current-topicref/*[contains(@class, ' map/topicref ')]" mode="toc">
                      <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                    </xsl:apply-templates>
                  </xsl:with-param>
                </xsl:apply-templates>
              </xsl:when>
              <xsl:when test="$nav-toc = 'full'">
                <xsl:apply-templates select="$input.map" mode="toc">
                  <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                </xsl:apply-templates>
              </xsl:when>
            </xsl:choose>
          </ul>
        <!-- ↓ Close Bootstrap div -->
        </div>
        <!-- ↑ End customization -->
      </nav>
    </xsl:if>
  </xsl:template>

  <xsl:attribute-set name="nav.ul">
    <xsl:attribute name="class">nav nav-list</xsl:attribute>
  </xsl:attribute-set>

</xsl:stylesheet>
