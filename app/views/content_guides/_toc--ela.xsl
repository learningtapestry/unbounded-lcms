<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:outline="http://wkhtmltopdf.org/outline"
                xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
              indent="yes" />
  <xsl:template match="outline:outline">
    <html>
      <head>
        <title>Table of Contents</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <style>
        .c-pdf-toc h1 {
          font-size: 22pt;
          line-height: 24pt;
          font-family: "PF Centro Sans Condensed", "PF Centro Sans Pro", "Helvetica Neue", Helvetica, Arial, sans-serif;
          font-weight: 500;
          color: #f75b28;
        }
        .c-pdf-toc  ul { padding-left: 0; }
        .c-pdf-toc ul.c-pdf-toc__l1 {
          font-size: 14pt;
          line-height: 18pt;
          font-family: "PF Centro Sans Condensed", "PF Centro Sans Pro", "Helvetica Neue", Helvetica, Arial, sans-serif;
          font-weight: 500;
          color: #f75b28;
        }
        .c-pdf-toc .c-pdf-toc__l2  {
          margin-bottom: 30px;
          font-size: 11pt;
          line-height: 18pt;
          font-family: "PF Centro Sans Condensed", "PF Centro Sans Pro", "Helvetica Neue", Helvetica, Arial, sans-serif;
          font-weight: 500;
          color: #676767;
          text-transform: uppercase;
        }
        .c-pdf-toc ul ul ul {
          display: none;
        }
        .c-pdf-toc span {
          float: right;
        }
        .c-pdf-toc li {
          list-style: none;
        }
        .c-pdf-toc a {
          text-decoration: none;
        }
        </style>
      </head>
      <body>
        <div class="c-pdf-toc">
          <h1>Table of Contents</h1>
          <ul class="c-pdf-toc__l1" style="margin-top: 30px;"><xsl:apply-templates select="outline:item/outline:item"/></ul>
        </div>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="outline:item">
    <li>
      <xsl:if test="@title!=''">
        <div>
          <a>
            <xsl:if test="@link">
              <xsl:attribute name="href"><xsl:value-of select="@link"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@backLink">
              <xsl:attribute name="name"><xsl:value-of select="@backLink"/></xsl:attribute>
            </xsl:if>
            <xsl:value-of select="@title" />
          </a>
          <span> <xsl:value-of select="@page" /> </span>
        </div>
      </xsl:if>
      <ul class="c-pdf-toc__l2">
        <xsl:comment>added to prevent self-closing tags in QtXmlPatterns</xsl:comment>
        <xsl:apply-templates select="outline:item"/>
      </ul>
    </li>
  </xsl:template>
</xsl:stylesheet>
