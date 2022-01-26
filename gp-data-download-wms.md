Head Office of Geodesy and Cartography

# **Guidelines for making spatial data downloadable via WMS services**

`Version 0.02`

`The 26th of January 2022`

# Table of contents

* [References](#references)
  * [Normative references](#normativeReferences)
  * [Technical references](#technicalReferences)
* [Definitions](#definitions)
* [Introduction](#introduction)
* [Scope](#scope)
  * [Relation to INSPIRE](#relationToInspire)
* [Utilised standards](#utilisedStandards)
  * [Supported operations](#supportedOperations)
    * [GetCapabilities](#getCapabilities)
    * [GetMap](#getMap)
    * [GetFeatueInfo](#getFeatureInfo)
* [Technical solutions](#technicalSolutions)
* [Examples of implementation](#examplesOfImplementation)
  * [Poland](#poland)
    * [Bulk download](#bulkDownload)
* [Final words](#finalWords)

# References <a name="references"></a> 

This Guidance contains references to or derives concepts from the following documents:

## Normative references <a name="normativeReferences"></a> 

[INSPIRE](https://eur-lex.europa.eu/legal-content/EN/ALL/?uri=CELEX%3A32007L0002), Implementing Directive 2007/2/EC of the European Parliament and of the Council as regards interoperability of spatial data sets and service

[INSPIRE, INS NS](https://eur-lex.europa.eu/legal-content/EN/ALL/?uri=CELEX%3A32009R0976), Commission Regulation (EC) No 976/2009 of the 19th of October 2009 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards the Network Services

[INSPIRE, INS DS](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=uriserv%3AOJ.L_.2014.354.01.0008.01.ENG), Commission Regulation (EU) No 1089/2010 of the 23rd of November 2010 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards interoperability of spatial data sets and services

[OGC 06-042](https://www.ogc.org/standards/wms) OpenGIS Web Map Service (WMS) Implementation Specification

[OGC 06-121r3](https://www.ogc.org/standards/common) – OGC Web Services Common Specification (OWS) 1.1.0

## Technical references <a name="technicalReferences"></a> 

Technical Guidance for the implementation of INSPIRE View Services, version 3.11, [INS TG WMS+WMTS](https://inspire.ec.europa.eu/documents/technical-guidance-implementation-inspire-view-services-1)

# Definitions <a name="definitions"></a> 

**discovery services**

making it possible to search for spatial data sets and services on the basis of the content of the corresponding metadata and to display the content of the metadata [INSPIRE Directive]

**download services**

enabling copies of spatial data sets, or parts of such sets, to be downloaded and, where practicable, accessed directly [INSPIRE Directive]

**view services allowing download**

utilising the interface of view services and enabling copies of spatial data sets, or parts of such sets, to be downloaded and, where practicable, accessed directly

**metadata**

information describing spatial data sets and spatial

**network services**

network services should make it possible to discover, transform, view and download spatial data and to invoke spatial data and e-commerce services [INSPIRE Directive]

**spatial data**

data with a direct or indirect reference to a specific location or geographic area [INSPIRE Directive]

**spatial data set**

identifiable collection of spatial data [INSPIRE Directive]

**view service**

making it possible, as a minimum, to display, navigate, zoom in/out, pan, or overlay viewable spatial data sets and to display legend information and any relevant content of metadata [INSPIRE Directive]

# Introduction <a name="introduction"></a> 

Without a doubt, the spatial data sets are the most critical INSPIRE component in spatial data infrastructure. Nonetheless, the data are useless if they are not available to potential users, and this is the role of network services. INSPIRE legislation defines five types of network services. However, the most popular and in most cases, the most useful from the user perspective are:

- view services that allow the users to display the data and
- download services that allow downloading copy of the spatial datasets.

Within the INSPIRE framework view services are rather intended for simple data analysis and initial quality assessment of the spatial data sets. The view services are light, supported by more client applications and more intuitive from an average user's perspective. There are only two types of view services recognized by INSPIRE: Web Map Services (WMS and Web Map Tile Services (WMTS)

On the other hand, download services are rather complex. Moreover, there are different types of download services designed for sharing various types of spatial datasets: Web Feature Service (WFS), ATOM feed, Sensor Observation Service (SOS) and finally Web Coverage Service (WCS). Each of the types requires specific client software that "understands" the particular standard. It is difficult in practice to find client applications that fully support the above-mentioned standards of download services. It is similar in the case of a data publisher perspective. It is much easier to set up and publish a view service compared to the download service.

The complexity related to download services has been noticed by INSPIRE implementers and INSPIRE community adopted as good practices new, less demanding standards [OGC API – Features](https://github.com/INSPIRE-MIF/gp-ogc-api-features/blob/master/spec/oapif-inspire-download.md) and [OGC SensorThings API](https://github.com/INSPIRE-MIF/gp-ogc-sensorthings-api). However, for the time being, parrel existence and utilisations of so many download standards with similar or overlapping functionalities might be even more confusing for data providers and potential data users.

So, the question may arise if view services offer so many advantages, can they be used also for data download? In general, the answer is yes. This document explains how this can be achieved and what are the advantages and shortcomings of the proposed approach.

# Scope <a name="scope"></a> 

The document proposes the utilisation of the WMS view service as an interface for downloading spatial data sets. The paper describes how to set up WMS operations to allow users to download spatial data sets.

The solution with slight modifications could also be applied to the WMTS view service.

## Relation to INSPIRE <a name="relationToInspire"></a> 

The guidelines contain information on setting up specific WMS services created utilising OGC WMS specifications ([OGC 06-042](https://www.ogc.org/standards/wms)).

Requirements and recommendations defined in INSPIRE Technical guidelines for view services ([INS TG WMS+WMTS](https://inspire.ec.europa.eu/documents/technical-guidance-implementation-inspire-view-services-1)) extending OGC WMS specifications are transparent from this document perspective. Implementation of INS TG WMS+WMTS will not interfere with the features of WMS services proposed in this guidelines.

# Utilised standards <a name="utilisedStandards"></a> 

The view services allowing download should support at least two last and most popular versions 1.1.1 and 1.3.0 of WMS standard. At the time of creating this document, it seems that the proposed solution can also be applied for the new OGC API – Maps standard that is still under development.

## Supported operations <a name="supportedOperations"></a> 

The view services allowing download must support GetCapabilities and GetMap, GetFeatureInfo (GFI) operations.

The view services allowing download from a service's user perspective works like any other WMS service. The solution uses WMS service, so it can be utilised in any application adopting the WMS standard. In a typical use case scenario shown it Figure 1, a user via the WMS client application points out on the map location for which data should be downloaded. GetFeatureInfo request is sent to the server, and the response returns metadata and links to the dataset subset covering an indicated area. Then the user clicks on the link to an appropriate resource (spatial data set or its subset) and downloads it.

![The sequence diagram showing typical use case scenario of WMS download service](https://github.com/marcingrudzien/gp-data-download-wms/blob/main/resources/pictures/downloadDataViaWMS.png "The sequence diagram showing typical use case scenario of WMS download service")

_Figure 1 The sequence diagram showing typical use case scenario of WMS download service._

The elements of the services that need some customisations to support the data download are explained below in the following chapters:

- GetCapabilities,
- GetMap,
- GetFeatureInfo.

### GetCapabilities <a name="getCapabilities"></a> 

GetCapabilities operation works the same as in the case of standard WMS service. The service must publish at least one layer containing a spatial extent of downloadable spatial data sets. This is further explained in the next sections.

### GetMap <a name="getMap"></a> 

A minimum GetMap response should contain a map picture showing a downloadable spatial data set's spatial extent.

Spatial data sets tend to be very big in terms of disk space volume. Additionally, users of spatial data sets rarely require data covering the entire spatial extent of the data set. A combination of these two factors may lead to the situation that a user spends a lot of time downloading data from the Internet only to use a small part of a downloaded data set. Therefore, it is recommended to publish large data sets divided spatially into smaller subsets. The boundaries of subsets should be determined individually for each data set. For example, they can be based on the country's administrative unit division or adopted map index standard. If subsetting is applied, the GetMap response should contain a map picture showing the spatial extent (boundaries) of the spatial data set's downloadable subsets. Optionally, GetMap response should also present the labels containing, e.g. names of administrative units or code names of utilised map sheets which should help potential user faster identify a subset the user requires.

### GetFeatueInfo <a name="getFeatureInfo"></a> 

The main difference between a standard WMS service and view services allowing download is the specific content of GFI responses of the later. In short, such responses must contain links (URIs) allowing to download the spatial datasets or their subsets. To achieve this, the spatial datasets or their subsets have to be published on the Internet and URIs linking to these resources have to be returned in GFI responses. The next two sections explain how this can be achieved.

#### Publication of spatial datasets for the purposes of view services allowing download 

This can be done in many ways. The most straight forward way is a publication of files containing spatial data on the Internet via, e.g. FTP or HTTP protocols. This document does not explain how to do this because it is a relatively simple task that requires only basic IT skills. Secondly, it differs significantly depending on the software installed on the web servers.

As stated above, spatial data sets sizes can be relatively big. Therefore, publishers of files containing such data should consider archiving the files or using archived formats (e.g. LAZ instead of LAS for LIDAR data) to reduce unnecessary Internet traffic.

In the proposed approach, it is possible to use standard download services. In such a case, links returned by GetFeatureResponse response can contain predefined requests to standard download services, e.g. GetFeature for WFS service, GetCoverage for WCS or links embedded in ATOM feeds.

**At the end of the day, the URIs must be accessible from the Internet.**

If the published access to files containing spatial data should be limited, security layers preventing access to non-authorised people can be applied. This, again, can be done in many ways and is not covered in this document.

#### Content of GetFeatureInfo responses

By default, WMS servers can return GFI response in few formats. The most popular are:

- text (MIME type: text/plain),
- XML (MIME types: text/xml or application/xml),
- HTML (MIME type: text/html).

The most suitable for returning URIs is HTML because it returns links most easily and straightforwardly - encoded width [<a> HTML tag](https://www.w3schools.com/tags/tag_a.asp).

In the case of other formats mentioned above, returned links have to be correctly displayed by client applications and not all WMS clients support such functionality.

In addition to URIs, GFI response should return metadata describing the spatial datasets or the subset. It can contain information describing downloadable resources, e.g.:

- date of creation or last update,
- spatial resolution,
- coordinate reference system,
- format and encoding,
- file size.

This can help the user to identify than download only resources that the user requires.

# Technical solutions <a name="technicalSolutions"></a> 

The approach described in the document can be utilised by the majority of WMS server solutions delivered by major vendors, both Open Source and commercial. This is usually done by defining the GFI response templates, allowing a service provider to specify GFI's exact structure and content. This chapter contains references to documentation regarding templating published by different major GIS software vendors:

- [MapServer](https://mapserver.org/mapfile/template.html)
- [GeoServer](https://docs.geoserver.org/latest/en/user/tutorials/GetFeatureInfo/index.html)
- [ArcGIS Server](https://enterprise.arcgis.com/en/server/latest/publish-services/windows/customizing-a-wms-getfeatureinfo-response.htm)

The applications mentioned above differ in template customisation details, but eventually, they allow publication of customised GFI responses containing resolvable (dereferenceable) URIs.
Sample implementations utilising above mentioned software packages are explained in document [Description of a testbed implementations of downloadable WMS](sample-implementations.md).

# Examples of implementation <a name="examplesOfImplementation"></a> 

## Poland <a name="poland"></a> 

From the 31st of June 2020, the amendment of a Polish geodetic and cartographic law has entered into force. As a result, most of the datasets managed by geodetic and cartographic service have been opened. The newly opened datasets have been published for download via WMS services utilising MapServer software. Currently following WMS download services are available:

- orthoimagery

  - based on currency [https://mapy.geoportal.gov.pl/wss/service/PZGIK/ORTO/WMS/SkorowidzeWgAktualnosci](https://mapy.geoportal.gov.pl/wss/service/PZGIK/ORTO/WMS/SkorowidzeWgAktualnosci)
  - based on pixel size [https://mapy.geoportal.gov.pl/wss/service/PZGIK/ORTO/WMS/SkorowidzeWgRozdzielczosci](https://mapy.geoportal.gov.pl/wss/service/PZGIK/ORTO/WMS/SkorowidzeWgRozdzielczosci)
- intensity images [https://mapy.geoportal.gov.pl/wss/service/PZGIK/OI/WMS/SkorowidzeObrazowIntensywnosci](https://mapy.geoportal.gov.pl/wss/service/PZGIK/OI/WMS/SkorowidzeObrazowIntensywnosci)
- digital elevation model (DEM)
  - PL-KRON86-NH elevation system [https://mapy.geoportal.gov.pl/wss/service/PZGIK/NMT/WMS/SkorowidzeWUkladzieKRON86](https://mapy.geoportal.gov.pl/wss/service/PZGIK/NMT/WMS/SkorowidzeWUkladzieKRON86)
  - PL- EVRF2007-NH elevation system [https://mapy.geoportal.gov.pl/wss/service/PZGIK/NMT/WMS/SkorowidzeWUkladzieEVRF2007](https://mapy.geoportal.gov.pl/wss/service/PZGIK/NMT/WMS/SkorowidzeWUkladzieEVRF2007)
- digital terrain model (DTM)
  - PL-KRON86-NH elevation system [https://mapy.geoportal.gov.pl/wss/service/PZGIK/NMPT/WMS/SkorowidzeWUkladzieKRON86](https://mapy.geoportal.gov.pl/wss/service/PZGIK/NMPT/WMS/SkorowidzeWUkladzieKRON86)
  - PL- EVRF2007-NH elevation system [https://mapy.geoportal.gov.pl/wss/service/PZGIK/NMPT/WMS/SkorowidzeWUkladzieEVRF2007](https://mapy.geoportal.gov.pl/wss/service/PZGIK/NMPT/WMS/SkorowidzeWUkladzieEVRF2007)
- LIDAR data
  - PL-KRON86-NH elevation system [https://mapy.geoportal.gov.pl/wss/service/PZGIK/DanePomNMT/WMS/SkorowidzeWUkladzieKRON86](https://mapy.geoportal.gov.pl/wss/service/PZGIK/DanePomNMT/WMS/SkorowidzeWUkladzieKRON86)
  - PL- EVRF2007-NH elevation system [https://mapy.geoportal.gov.pl/wss/service/PZGIK/DanePomNMT/WMS/SkorowidzeWUkladzieEVRF2007](https://mapy.geoportal.gov.pl/wss/service/PZGIK/DanePomNMT/WMS/SkorowidzeWUkladzieEVRF2007)
- basic geodetic network points [https://integracja.gugik.gov.pl/cgi-bin/PodstawowaOsnowaGeodezyjna](https://integracja.gugik.gov.pl/cgi-bin/PodstawowaOsnowaGeodezyjna)
- register of administrative units and address [https://integracja.gugik.gov.pl/cgi-bin/PanstwowyRejestrGranic](https://integracja.gugik.gov.pl/cgi-bin/PanstwowyRejestrGranic)
- general geographic database (250k) [https://integracja.gugik.gov.pl/cgi-bin/BDOO](https://integracja.gugik.gov.pl/cgi-bin/BDOO)
- topographic database (10k) [https://integracja.gugik.gov.pl/cgi-bin/PobieranieBDOT10k](https://integracja.gugik.gov.pl/cgi-bin/PobieranieBDOT10k)
- 3D buildings models [https://integracja.gugik.gov.pl/cgi-bin/ModeleBudynkow3D](https://integracja.gugik.gov.pl/cgi-bin/ModeleBudynkow3D)
- maps for visually handicapped people [https://mapy.geoportal.gov.pl/wss/service/PZGIK/TYFLO/WMS/DaneDoPobrania](https://mapy.geoportal.gov.pl/wss/service/PZGIK/TYFLO/WMS/DaneDoPobrania)

There is also [a YouTube movie](https://youtu.be/7VsYSZxEkqE) available explaining how WMS download services work on the Polish geoportal.

## Bulk download <a name="bulkDownload"></a> 

Although the solution has been implemented in Poland just recently, it seems to be very successful. First of all, there are many custom tools available working on top of WMS services to automatise downloading the spatial data. Some of these tools are available for free as QGIS extensions, e.g. [pobieracz danych GUGiK](https://github.com/envirosolutionspl/pobieracz_danych_gugik) or [BDOT10k\_GML\_SHP](https://github.com/MarcinLebiecki/BDOT10k_GML_SHP). Some require proprietary software, e.g. [FME](https://geoforum.pl/news/29537/kolejne-dane-uwolnione-jak-je-pobrac-z-fme-). This proves that despite the WMS service interface's limits, it is possible to build custom tools working on top of the WMS service allowing the bulk download.

# Final words <a name="finalWords"></a> 

In the end, it is essential to point out that the role of view services allowing download is not to replace but to supplement existing download services. The WMS download services simplify access to spatial data to non-experienced users beginning their adventure with the GIS world.
