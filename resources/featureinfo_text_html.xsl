<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:esri_wms="http://www.esri.com/wms" xmlns="http://www.esri.com/wms">
	
	<xsl:output method="html" indent="yes" encoding="UTF-8" version="4.01"/>
	<xsl:template match="/">
		<html>

		<head><title>ArcGIS GetFeatureInfo output</title></head>
		<body>
			<h4>Orthoimagery sheet - ArcGIS</h4>
			<xsl:for-each select="esri_wms:FeatureInfoResponse/esri_wms:FeatureInfoCollection/esri_wms:FeatureInfo">
				
					<xsl:for-each select="esri_wms:Field">
							<xsl:choose>

								<xsl:when test="esri_wms:FieldName[starts-with(., 'Download')]">
									<strong><xsl:value-of select="esri_wms:FieldName" /></strong><br /><a target='_blank'><xsl:attribute name="href"><xsl:value-of select="esri_wms:FieldValue" /></xsl:attribute>Click here to download</a>
								</xsl:when>
								
								<xsl:when test="esri_wms:FieldName[starts-with(., 'FID')]">
								</xsl:when>

								<xsl:otherwise>

									<strong><xsl:value-of select="esri_wms:FieldName" /></strong><br />
									<xsl:value-of select="esri_wms:FieldValue" /><br />
									
								</xsl:otherwise>
							</xsl:choose>
					</xsl:for-each>
			</xsl:for-each>
		</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
