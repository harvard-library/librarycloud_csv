package csv

class CsvController {


    def csvService

    def index () {
      def source = params.source
      def setSpec = params.setSpec
      if (source == null || setSpec == null) {
        render(text: "source and setSpec required", contentType: "text/plain", encoding: "UTF-8")
        return
      }
      if (source != "MH:OASIS" && source != "MH:ALEPH" && source != "MH:VIA" && source != "MH:ALMA") {
        render(text: "only MH:ALEPH, MH:ALMA, MH:OASIS and MH:VIA sources currently supported", contentType: "text/plain", encoding: "UTF-8")
        return
      }
      def lowersource = source.replace("MH:","").toLowerCase()
      if (lowersource.equals("alma"))
        lowersource = "aleph"
      def filelabel = ""
      if (source.equals(""))
          filelabel = "HOLLIS"
      if (source.equals("oasis"))
          filelabel = "Finding_Aids"
      if (source.equals("via"))
          filelabel = "Images"
      def xmlUrl = csvService.getItemsUrl() + "?source=" + source + "&setSpec_exact=" + setSpec + "&sort=recordIdentifier"
      def csvHeader = csvService.getHeader(lowersource)
      def xmlForParse = xmlUrl.toURL().newReader('utf-8')
      def results = new XmlSlurper().parseText(xmlForParse.text)
      def numFound = "${results.pagination.numFound}"
      if (Integer.parseInt(numFound) == 0) {
        render(text: "No results found for source: " + source + ", setSpec: " + setSpec, contentType: "text/plain", encoding: "UTF-8")
        return
      }
      int numPages = (Integer.parseInt(numFound) / 100) + 1
      def xslName = csvService.getXslDir() + "/" + lowersource + '.xsl'
      def xslCsvName = csvService.getXslDir() + "/" + "xml2csv" + '.xsl'
      def csvText = ""
      def startNum = 0
      for (int i = 0; i < numPages; i++) {
        if( i == 0)
          startNum = 0
        else
          startNum = (i * 100)
        def xmlUrlWPag = xmlUrl + "&start=" + startNum + "&limit=100"
        //println "xmlUrlWPag: " + xmlUrlWPag
        def xml = xmlUrlWPag.toURL().newReader('utf-8')
        def simpleXml = csvService.transformApiXml(xml, xslName)
        def xmlStr = simpleXml.toString()
        def xmlRdr = new StringReader(xmlStr)
        csvText += csvService.transformApiXml(xmlRdr, xslCsvName)
        //startNum = startNum * 100
      }	

      csvText = csvHeader + "\n" + csvText
      response.setHeader("Content-disposition", "attachment; filename=" + setSpec + "_" + filelabel + ".csv")
      render(text: csvText, contentType: "text/csv", encoding: "UTF-8")
    }

}
