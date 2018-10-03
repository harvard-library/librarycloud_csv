import javax.xml.transform.TransformerFactory
import javax.xml.transform.stream.StreamResult
import javax.xml.transform.stream.StreamSource
import java.text.SimpleDateFormat
import groovy.xml.StreamingMarkupBuilder;
import groovy.xml.XmlUtil;
import grails.core.GrailsApplication

class CsvService {

    GrailsApplication grailsApplication

    def getItemsUrl() {
      return grailsApplication.config.getProperty('itemsUrl') 
    }

    def getXslDir() {
      return grailsApplication.mainContext.getResource("xsl").file.absolutePath
    }

    def getHeader(source) {
      def header = ""
      if (source.equals("aleph")) 
        header = "\"HOLLIS #\",\"Title\",\"Type\",\"PlaceCode\",\"PubPlace\",\"Publisher\",\"SingleDate\",\"DateStart\",\"DateEnd\",\"Name\",\"NameRole\",\"NameDates\",\"URI\""
      if (source.equals("via")) 
        header = "\"VIA #\",\"Title\",\"Type\",\"PlaceName\",\"DateCreated\",\"Name\",\"NameRole\",\"NameDates\",\"URI\",\"RelatedItem\",\"Relationship\""
      if (source.equals("oasis")) 
        header = "\"Item - OASIS #\",\"Item - Title\",\"Item - DateCreated\",\"Collection - Title\",\"Collection - Name\",\"Collection - Date\",\"Collection - OASIS #\",\"URI\""
      return header
    }

    def transformApiXml(xml, xslName) {
      //def xml = xmlUrl.toURL().newReader('utf-8') 
      //def xsl = new File('xsl/' + xslName).text;
      def xsl = new File(xslName).text;
      def transformer = TransformerFactory.newInstance("net.sf.saxon.TransformerFactoryImpl", null).newTransformer(new StreamSource(new StringReader(xsl)))
      def StreamResult result=new StreamResult(new StringWriter());
      transformer.transform(new StreamSource(xml), result);
      def transformedXml = result.getWriter();
      return transformedXml
    }

}
