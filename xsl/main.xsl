<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" omit-xml-declaration="yes"></xsl:output>
	<xsl:template match="/">
		<table width="100%" class="main_table">
			<tr>
			<td width="5%">
				<img src="{/root/title_image/@src}"/>
			</td>
			<td valign="top">
				<div class="title"><xsl:value-of select="/root/profile/name"/></div>
				<xsl:for-each select="/root/profile/subtitles/subtitle">
					<div class="subtitle"><xsl:value-of select="."/></div>
				</xsl:for-each>
			</td>
			</tr>
		</table>
		<div class="nav">
			<xsl:for-each select="/root/links/link">
				<div id="{@id}" onclick="setContentVis(this)">
					<xsl:attribute name="class">link<xsl:if test="normalize-space(@default) != ''"><xsl:text> </xsl:text>link_selected</xsl:if></xsl:attribute>
					<xsl:if test="normalize-space(@default) = ''">
						<xsl:attribute name="onmouseover">this.className='link_over'</xsl:attribute>
						<xsl:attribute name="onmouseout">this.className='link'</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="title/text()"/>
				</div>
			</xsl:for-each>
			<div style="margin-top:50">
				<img src="./images/zebrafish.jpg" width="70" height="70"/>
			</div>
		</div>
		<div class="content">
			<xsl:for-each select="/root/links/link/content">
				<div id="{@id}" class="cn">
					<xsl:attribute name="style">
						<xsl:choose>
							<xsl:when test="normalize-space(@default) != ''">display:block</xsl:when>
							<xsl:otherwise>display:none</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<ul>
					<xsl:for-each select="item">
                        <xsl:choose>
                            <xsl:when test="@type='image'">
                                <li><img src="{./text()}"/></li>
                            </xsl:when>
                            <xsl:otherwise><li><xsl:if test="normalize-space(@class) !=''"><xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute></xsl:if><xsl:value-of select="."/></li></xsl:otherwise>
                        </xsl:choose>
					</xsl:for-each>
					</ul>
				</div>
			</xsl:for-each>
		</div>
		<br class="clear"/>

	</xsl:template>

</xsl:stylesheet>