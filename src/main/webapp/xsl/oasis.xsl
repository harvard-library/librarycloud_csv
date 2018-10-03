<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:lc="http://api.lib.harvard.edu/v2/item"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <!-- ignore -->
    <xsl:template match="lc:pagination"/>

    <xsl:template match="lc:results">
        <oasisRecs>
            <xsl:apply-templates/>
        </oasisRecs>
    </xsl:template>

    <xsl:template match="mods:mods">
        <record>
            <xsl:apply-templates select="mods:recordInfo/mods:recordIdentifier"/>
            <xsl:apply-templates select="mods:titleInfo[not(@*)]/mods:title"/>
            <xsl:apply-templates select="(mods:name)[1]"/>
            <xsl:apply-templates select="mods:originInfo"/>
            <xsl:apply-templates select="mods:typeOfResource"/>
            <!--<xsl:apply-templates select="mods:location/mods:url"/>-->
            <xsl:apply-templates select="mods:location/mods:url[@access='raw object']"/>
            <xsl:apply-templates select="mods:relatedItem[@displayLabel='collection']"/>
            <xsl:apply-templates select="mods:relatedItem/mods:relatedItem[@displayLabel='collection']"/>
            <xsl:apply-templates select="mods:relatedItem/mods:relatedItem/mods:relatedItem[@displayLabel='collection']"/>
            <xsl:apply-templates select="mods:relatedItem/mods:relatedItem/mods:relatedItem/mods:relatedItem[@displayLabel='collection']"/>
        </record>
    </xsl:template>
    
    <xsl:template match="mods:recordIdentifier">
            <identifier>
             <xsl:value-of select="."/>
            </identifier> 
            <source>
                 <xsl:value-of select='@source'/>
            </source>           
    </xsl:template>
   
    <xsl:template match="mods:title">
        <title> 
            <xsl:apply-templates/>
        </title>
    </xsl:template>    
    
    <xsl:template match="mods:name">
         <name>
             <xsl:value-of select="(mods:namePart)[1]"/>
         </name>
         <date>
             <xsl:value-of select="mods:namePart[@type]"/>
         </date>
         <role>
             <xsl:value-of select="mods:role"/>  
         </role>   
    </xsl:template>
    
    <xsl:template match="mods:originInfo">
        <placeName>
            <xsl:value-of select="mods:place/mods:placeTerm"/>
        </placeName>
        <publisher>
            <xsl:value-of select="mods:publisher"/>
        </publisher>
        <dateCreated>
            <xsl:value-of select="mods:dateCreated[not(@*)]"/>
        </dateCreated>
    </xsl:template>
    
    <xsl:template match="mods:typeOfResource">
        <typeOfResource>
            <xsl:value-of select="."/>
        </typeOfResource>     
    </xsl:template>

    <xsl:template match="mods:url">
            <uri>
                <xsl:value-of select="."/>
            </uri>          
    </xsl:template>
    
    <xsl:template match="mods:relatedItem[@displayLabel='collection']">
           <coltitle>
               <xsl:value-of select="mods:titleInfo/mods:title"/>
            </coltitle>
            <colname>
                <xsl:value-of select="mods:name/mods:namePart"/>
            </colname>
            <coldate>
                <xsl:value-of select="(mods:originInfo/mods:dateCreated)[1]"/>    
            </coldate>
            <colid>
                <xsl:value-of select="mods:recordInfo/mods:recordIdentifier"/>  
            </colid>
            </xsl:template>
</xsl:stylesheet>
