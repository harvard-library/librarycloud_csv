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
        header = "\"HOLLIS ID\",\"Title\",\"Place Code\",\"United States?\",\"Place\",\"Publisher\",\"Transcribed Date\",\"Coded Date 1\",\"Coded Date 2\",\"Name\",\"Name Role\",\"Name Dates\",\"Digital Object Link\",\"Access Flag\",\"Thumbnail\",\"Collection Record?\""
      if (source.equals("via")) 
        header = "\"Image ID\",\"Title\",\"Origin Place\",\"Date Created\",\"Name\",\"Name Role\",\"Name Dates\",\"Digital Object Link\",\"Related Item\",\"Relationship\",\"Access Flag\",\"Thumbnail\""
      if (source.equals("oasis")) 
        header = "\"Finding Aid Component ID\",\"Component Title\",\"Component Date Created\",\"Collection Title\",\"Collection Name\",\"Collection Date\",\"Finding Aid ID\",\"Digital Object Link\",\"Access Flag\",\"Thumbnail\""
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
