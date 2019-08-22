<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:lc="http://api.lib.harvard.edu/v2/item" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:HarvardDRS="http://hul.harvard.edu/ois/xml/ns/HarvardDRS" 
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <!-- ignore -->
    <xsl:template match="lc:pagination"/>

    <xsl:template match="lc:results">
        <viaRecs>
            <xsl:apply-templates/>
        </viaRecs>
    </xsl:template>
    <xsl:template match="mods:mods">
        <record>
            <xsl:apply-templates select="mods:recordInfo/mods:recordIdentifier"/>
            <xsl:apply-templates select="mods:titleInfo[not(@*)][1]/mods:title"/>
            <xsl:apply-templates select="mods:name"/>
            <xsl:apply-templates select="mods:originInfo"/>
            <xsl:apply-templates select=".//mods:location/mods:url[@access = 'raw object']"/>
            <xsl:apply-templates select="mods:relatedItem[1]"/>
            <xsl:apply-templates select="mods:extension/HarvardDRS:DRSMetadata"/>
            <xsl:apply-templates select=".//mods:location/mods:url[@access = 'preview']"/>
        </record>
    </xsl:template>

    <xsl:template match="mods:recordIdentifier">
        <identifier>
            <xsl:value-of select="."/>
        </identifier>
        <source>
            <xsl:value-of select="@source"/>
        </source>
    </xsl:template>

    <xsl:template match="mods:title">
        <title>
            <xsl:apply-templates/>
        </title>
    </xsl:template>

    <xsl:template match="mods:name">
        <!--<xsl:if test="mods:role/mods:roleTerm[@authority] eq 'creator'">-->
        <xsl:if test="mods:role[1]/mods:roleTerm[1] eq 'creator'">
            <role>
                <xsl:value-of select="mods:role/mods:roleTerm"/>
            </role>
            <name>
                <xsl:value-of select="mods:namePart"/>
            </name>
            <date>
                <xsl:value-of select="mods:namePart[@type]"/>
            </date>
        </xsl:if>
    </xsl:template>

    <xsl:template match="mods:originInfo">
        <placeCode>
            <xsl:value-of select="mods:place/mods:placeTerm[@type = 'code']"/>
        </placeCode>
        <placeName>
            <xsl:value-of select="mods:place/mods:placeTerm[@type = 'text']"/>
        </placeName>
        <publisher>
            <xsl:value-of select="mods:publisher"/>
        </publisher>
        <dateIssued>
            <xsl:value-of select="mods:dateOther[(@keyDate)]"/>
        </dateIssued>
        <dateStart>
            <xsl:choose>
                <xsl:when test="mods:dateCreated[not(@point = 'start')]">
                    <xsl:value-of select="mods:dateCreated[not(@point)]"/>
                </xsl:when>
                <xsl:when
                    test="mods:dateCreated[@point = 'start'] and mods:dateCreated[@point = 'end']">
                    <xsl:value-of select="mods:dateCreated[@point = 'start']"/>
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="mods:dateCreated[@point = 'end']"/>
                </xsl:when>
                <xsl:when
                    test="mods:dateCreated[@point = 'start'] and not(mods:dateCreated[@point = 'end'])">
                    <xsl:value-of select="mods:dateCreated[@point = 'start']"/>
                </xsl:when>
                <xsl:when test="mods:dateOther[@keyDate]">
                    <xsl:value-of select="mods:dateOther[@keyDate]"/>
                </xsl:when>
            </xsl:choose>
        </dateStart>
    </xsl:template>

    <xsl:template match="mods:url[@access = 'raw object']">
        <type>
            <xsl:text>still image</xsl:text>
        </type>
        <uri>
            <xsl:value-of select="."/>
        </uri>
    </xsl:template>

    <xsl:template match="mods:url[@access = 'preview']">
        <preview>
            <xsl:value-of select="."/>
        </preview>
    </xsl:template>
    
    <xsl:template match="mods:relatedItem">
        <relatedItem>
            <xsl:value-of select="mods:titleInfo/mods:title"/>
        </relatedItem>
        <relationship>
            <xsl:value-of select="@type"/>
        </relationship>
    </xsl:template>
    
    <xsl:template match="HarvardDRS:DRSMetadata">
        <xsl:apply-templates select="HarvardDRS:accessFlag"/>
    </xsl:template>
    
    <xsl:template match="HarvardDRS:accessFlag">
        <accessFlag>
            <xsl:value-of select="."/>
        </accessFlag>
    </xsl:template>

</xsl:stylesheet>
