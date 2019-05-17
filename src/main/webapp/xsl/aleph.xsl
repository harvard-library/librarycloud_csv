<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:lc="http://api.lib.harvard.edu/v2/item"
    xmlns:HarvardDRS="http://hul.harvard.edu/ois/xml/ns/HarvardDRS"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <!-- ignore -->
    <xsl:template match="lc:pagination"/>

    <xsl:template match="lc:results">
        <alephRecs>
            <xsl:apply-templates/>
        </alephRecs>
    </xsl:template>
    <xsl:template match="mods:mods">
        <record>
            <xsl:apply-templates select="mods:recordInfo/mods:recordIdentifier"/>
            <xsl:apply-templates select="mods:titleInfo[not(@type)][1]/mods:title"/>
            <xsl:choose>
                <xsl:when test="mods:name/mods:role[1]/mods:roleTerm">
                    <xsl:apply-templates select="mods:name[mods:role[1]/mods:roleTerm]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="mods:name[1]"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="mods:originInfo"/>
            <xsl:apply-templates select="mods:location/mods:url[@access = 'raw object']"/>
            <xsl:apply-templates select="mods:location/mods:url[@access = 'preview']"/>
            <xsl:apply-templates select="mods:extension/HarvardDRS:DRSMetadata"/>
            <xsl:apply-templates select="mods:typeOfResource"/>
            <!--<xsl:apply-templates select="mods:identifier[@type='uri']"/>-->
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
        <!--<xsl:if test="mods:role[1]/mods:roleTerm eq 'creator'">-->
        <role>
            <xsl:value-of select="mods:role/mods:roleTerm"/>
        </role>
        <name>
            <xsl:value-of select="mods:namePart"/>
        </name>
        <date>
            <xsl:value-of select="mods:namePart[@type]"/>
        </date>
        <!--</xsl:if>-->
    </xsl:template>

    <xsl:template match="mods:originInfo">
        <placeCode>
            <xsl:value-of select="mods:place/mods:placeTerm[@type = 'code']"/>
        </placeCode>
        <isUS>
            <xsl:choose>
                <xsl:when test="ends-with(mods:place/mods:placeTerm[@type = 'code'], 'u')">
                    <xsl:text>United States</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text/>
                </xsl:otherwise>
            </xsl:choose>
        </isUS>
        <placeName>
            <xsl:value-of select="mods:place/mods:placeTerm[@type = 'text']"/>
        </placeName>
        <publisher>
            <xsl:value-of select="mods:publisher"/>
        </publisher>
        <dateIssued>
            <xsl:choose>
                <xsl:when test="mods:dateOther[@keyDate]">
                    <xsl:value-of select="mods:dateOther[@keyDate]"/>
                </xsl:when>
                <xsl:when test="mods:dateCreated[not(@*)]">
                    <xsl:value-of select="mods:dateCreated[not(@*)]"/>
                </xsl:when>
                <xsl:when test="mods:dateCreated[not(@point)]">
                    <xsl:value-of select="mods:dateCreated[not(@point)]"/>
                </xsl:when>
                <xsl:when test="mods:dateIssued[not(@*)]">
                    <xsl:value-of select="mods:dateIssued[not(@*)]"/>
                </xsl:when>
                <xsl:when test="mods:dateIssued[not(@point)]">
                    <xsl:value-of select="mods:dateIssued[not(@point)]"/>
                </xsl:when>
            </xsl:choose>
        </dateIssued>
        <dateStart>
            <xsl:choose>
                <xsl:when test="mods:dateIssued[@point = 'start']">
                    <xsl:value-of select="mods:dateIssued[@point = 'start']"/>
                </xsl:when>
                <xsl:when test="mods:dateCreated[@point = 'start']">
                    <xsl:value-of select="mods:dateCreated[@point = 'start']"/>
                </xsl:when>
            </xsl:choose>
        </dateStart>
        <dateEnd>
            <xsl:choose>
                <xsl:when test="mods:dateIssued[@point = 'end']">
                    <xsl:value-of select="mods:dateIssued[@point = 'end']"/>
                </xsl:when>
                <xsl:when test="mods:dateCreated[@point = 'end']">
                    <xsl:value-of select="mods:dateCreated[@point = 'end']"/>
                </xsl:when>
            </xsl:choose>
        </dateEnd>
        <issuance>
            <xsl:value-of select="mods:issuance"/>
        </issuance>
    </xsl:template>

    <xsl:template match="mods:url[@access = 'raw object']">
        <uri>
            <xsl:value-of select="."/>
        </uri>
    </xsl:template>

    <xsl:template match="mods:url[@access = 'preview']">
        <preview>
            <xsl:value-of select="."/>
        </preview>
    </xsl:template>

    <xsl:template match="HarvardDRS:DRSMetadata">
        <xsl:apply-templates select="HarvardDRS:accessFlag"/>
    </xsl:template>

    <xsl:template match="HarvardDRS:accessFlag">
        <accessFlag>
            <xsl:value-of select="."/>
        </accessFlag>
    </xsl:template>

    <xsl:template match="mods:typeOfResource">
        <isCollection>
            <xsl:choose>
                <xsl:when test="./collection = 'yes'">
                    <xsl:text>Collection record</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text/>
                </xsl:otherwise>
            </xsl:choose>
        </isCollection>
    </xsl:template>

    <!--   <xsl:template match="mods:identifier">
       <xsl:if test="not(contains(.,'XXZZ'))">
            <uri>
                <xsl:value-of select="."/>
            </uri>    
       </xsl:if>
    </xsl:template>-->

    <!--   <xsl:template match="url">
        <xsl:if test="not(contains(.,'RUMSE'))">
            <links>
            <uri>
                <xsl:value-of select="."/>
            </uri>  
           </links>
        </xsl:if>
    </xsl:template>-->
</xsl:stylesheet>
