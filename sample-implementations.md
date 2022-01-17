# **Description of a testbed implementations of downloadable WMS**
To help implement downloadable WMS services, examples of such services have been created utilising the following GIS server software:
* MapServer [https://mapy.geoportal.gov.pl/wss/testbed/wmsdownload/mapserver](https://mapy.geoportal.gov.pl/wss/testbed/wmsdownload/mapserver)
* GeoServer [https://mapy.geoportal.gov.pl/wss/testbed/wmsdownload/geoserver](https://mapy.geoportal.gov.pl/wss/testbed/wmsdownload/geoserver?SERVICE=WMS&REQUEST=GetCapabilities)
* ArcGIS Server [https://mapy.geoportal.gov.pl/wss/testbed/wmsdownload/arcgisserver](https://mapy.geoportal.gov.pl/wss/testbed/wmsdownload/arcgisserver?SERVICE=WMS&REQUEST=GetCapabilities)

Although the configuration of these services differs significantly, all WMS services look almost identical from a user perspective.
This document explains specific details regarding the development of these services.

# Sample data set
The services publish an index map with the latest orthoimagery for Poland available for December 2021. The sample data is available in shapefile format. The data contains polygon geometry covering spatial extents of each available orthoimagery sheet and, among others, includes the following key attributes:
* code – the code name of a particular orthoimagery sheet
* date_s – the date when the aerial photography was taken that was utilised in the creation of orthoimagery
* gsd – ground sample distance (GSD) in meters
* color – spectral characteristics of the orthophoto, e.g. RGB or CIR
* crs – coordinate reference system (CRS) in which the orthophotomap is available
* url – the link that allows downloading a particular orthoimagery sheet

All orthophoto sheets are published on Interned using Apache web server in the location specified in the url attribute.
The sample data geometry is stored in the Polish PUWG 1992 coordinate reference system (EPSG:2180).
The utilised data sample can be downloaded from [here](resources/data/current_ortho.zip).

# Examples of implementations
This document does not cover software installation or WMS services configuration details. These are at least sufficiently explained on the related vendors' websites. The paper only focuses on setting up services in the areas crucial to the implementation of downloadable WMS services. In particular, the document presents examples of changes that can be applied to adjust HTML GetFeatureInfo (GFI) responses of WMS services to display links to orthoimagery data set subsets (sheets).
The examples of the services are relatively simple. The documented approach can be applied to create user friendly, better looking, more complex and interactive GFI responses containing additional Cascading Style Sheets (CSS) or JavaScript code.

## Example of MapServer implementation
Details regarding the customisation of GFI responses are covered in detail in [MapServer documentation](https://mapserver.org/mapfile/template.html).
This section describes the configuration of the WMS service in MapServer published at https://mapy.geoportal.gov.pl/wss/testbed/wmsdownload/mapserver. This service uses MapServer instance in version 7.6.4 installed on Ubuntu 20.04 Linux distribution. The complete service configuration can be found in:
* [service configuration file](resources/MapServer/indexortho.map)
* [HTML template file](resources/MapServer/index.html)

To force MapServer to use a custom template, its location must be advertised in the MapServer configuration file, for example, by using the TEMPLATE parameter in the LAYER section of the configuration file. This is how it is done in the sample service.
```
TEMPLATE "index.html"
```
In this case the HTML GFI template document is located in index.html file in exactly the same folder as MapServer service configuraton file. The utilised content of index.html file looks like this:
```
<!-- MapServer Template -->
<html>
<head><title>MapServer GFI response</title></head>
<body>
<h4>Orthoimagery sheet - MapServer</h4>
<strong>Code:</strong><br>[code]<br>
<strong>Date of imagery:</strong><br>[date_s]<br>
<strong>GSD:</strong><br>[item name="gsd" precision="2" format="$value m"]<br>
<strong>Color:</strong><br>[color]<br>
<strong>CRS:</strong><br>[crs]<br>
<strong>Download link:</strong><br><a href="[url]" target="_blank">Click here to download</a><br>
</body>
</html>
```
The values of attributes are included in HTML code by providing their names in square brackets, e.g. ```[gsd]```. The link to the downloadable orthoimagery sheet has been encoded using HTML <a> element, e.g. ```<a href="[url]" target="_blank">Click here to download</a>```
The example of the GFI response utilising the template can be seen by clicking link below which is an example of a standard GFI request
https://mapy.geoportal.gov.pl/wss/testbed/wmsdownload/mapserver?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetFeatureInfo&BBOX=46.73160157058823216,13.42562750000000094,56.94499842941176126,25.14667249999999754&CRS=EPSG:4326&WIDTH=1275&HEIGHT=1111&LAYERS=OrthoimageryIndex&STYLES=&FORMAT=image/png&QUERY_LAYERS=OrthoimageryIndex&INFO_FORMAT=text/html&I=929&J=497 

## Example of GeoServer implementation
Details regarding the customisation of GFI responses are covered in detail in [GeoServer documentation](https://docs.geoserver.org/latest/en/user/tutorials/GetFeatureInfo/html.html).
This section describes the configuration of the WMS service in GeoServer published at [https://mapy.geoportal.gov.pl/wss/testbed/wmsdownload/geoserver](https://mapy.geoportal.gov.pl/wss/testbed/wmsdownload/geoserver?SERVICE=WMS&REQUEST=GetCapabilities). This service uses the GeoServer instance in version 2.20.1 installed on Ubuntu 20.04 Linux distribution. The complete service configuration can be found in the service [workspace archive file](resources/GeoServer/testbed.zip).
To utilise GeoServer, the template file has to be put in the appropriate location. In case of the sample service it is
```GEOSERVER_DATA_DIR/workspaces/<workspace>/<datastore>/<featuretype>/content.ftl```. Content.ftl file contains GFI HTML template, that looks like this:
``` 
<html>
<head><title>GeoServer GFI response</title></head>
<body>
<#list features as feature>
<h4>Orthoimagery sheet - GeoServer</h4>
<strong>Code::</strong><br>${feature.code.value}<br>
<strong>Date of imagery:</strong><br>${feature.date_s.value}<br>
<strong>GSD:</strong><br>${feature.gsd.value}<br>
<strong>Color:</strong><br>${feature.color.value}<br>
<strong>CRS:</strong><br>${feature.crs.value}<br>
<strong>Download link:</strong><br><a href="${feature.url.value}" target="_blank">Click here to download</a><br>
</#list>
</body>
</html>
```
The code 
```
<#list features as feature>
(…)
</#list>
```
iterates through all features returned by the service and executes the code inside. The values of attributes are included into HTML code using following pattern ```${feature.ATTRIBUTE_NAME.value}```, e.g. ```${feature.code.value}```. The link to the downloadable orthoimagery sheet has been encoded using HTML <a> element e.g. ```<a href="${feature.url.value}" target="_blank">Click here to download</a>```.
 GeoServer, by default adds additional HTML code at the top and the bottom of the GFI response. This code can be changed or removed by modifying files header.ftl and footer.ftl. These files are located in one of the JAR packages. For GeoServer in version 2.20.1, these files can be found in ```GEOSERVER_LOCATION/webapps/geoserver/WEB-INF/lib/gs-wms-2.20.1.jar``` and within the JAR file in ```gs-wms-2.20.1.jar/org/geoserver/wms/featureinfo/```.
The example of the GFI response utilising the template can be seen by clicking link below
https://mapy.geoportal.gov.pl/wss/testbed/wmsdownload/geoserver?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetFeatureInfo&BBOX=429994.46573283208999783,523363.40774723986396566,439650.7120681336382404,533045.03186528861988336&CRS=EPSG:2180&WIDTH=763&HEIGHT=761&LAYERS=OrthoimageryIndex&STYLES=&FORMAT=image/png&QUERY_LAYERS=OrthoimageryIndex&INFO_FORMAT=text/html&I=491&J=299

 ## Example of ArcGIS Server implementation
 
 Details regarding the customisation of GFI responses are covered in detail in [ArcGIS documentation](https://enterprise.arcgis.com/en/server/10.8/publish-services/windows/customizing-a-wms-getfeatureinfo-response.htm).
This section describes the configuration of the WMS service in ArcGIS published at https://mapy.geoportal.gov.pl/wss/testbed/wmsdownload/arcgis. This service uses ArcGIS instance in version 10.8. The complete service configuration can be found in:
* [HTML template file](resources/ArcGIS/featureinfo_text_html.xsl)

To change the ArcGIS template for text/html format, please edit the featureinfo_text_html.xsl file in location ...\ArcGIS\Server\Styles\WMS where ArcGIS Server is installed. 

The utilised content of featureinfo_text_html.xsl file looks like this:
```
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

```
In the file above there are two conditions based on XSLT according to which the fields should be presented. One condition occurs when we are dealing with a field that should be in the form of a URL link. In this case, the field has name "Download", so we filter that text from GetFeatureInfo response:

```
<xsl:when test="esri_wms:FieldName[starts-with(., 'Download')]">
	<strong>
		<xsl:value-of select="esri_wms:FieldName" /></strong><br /><a target='_blank'>
		<xsl:attribute name="href">
			<xsl:value-of select="esri_wms:FieldValue" />
		</xsl:attribute>Click here to download
	</a>
</xsl:when>

```


The second case is applied to the remaining fields and takes the value:

```
<xsl:otherwise>
	<strong>
		<xsl:value-of select="esri_wms:FieldName" /></strong><br />
	<xsl:value-of select="esri_wms:FieldValue" /><br />
</xsl:otherwise>

```


The example of the GFI response utilising the template can be seen by clicking link below which is an example of a standard GFI request
https://mapy.geoportal.gov.pl/wss/testbed/wmsdownload/arcgis?SERVICE=WMS&request=GetFeatureInfo&version=1.3.0&layers=0&styles=&crs=EPSG:2180&bbox=602820.588413512,456315.157841157,615216.3423716865,469650.18451121036&width=1008&height=937&format=image/jpeg&transparent=true&query_layers=0&i=392&j=458&INFO_FORMAT=text/html
