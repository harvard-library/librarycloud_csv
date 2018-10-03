Librarycloud OAI-PMH Data Provider
============

Description
-----------

A tool for generating CSV delimited output by source and setSpec written in grails for the Librarycloud API.


Code Repository
---------------

[GitHub repo](https://github.com/harvard-library/librarycloud_csv).

Requirements
------------

* Grails (tested on v3.0.4)
* Groovy (tested in 2.4.4)

Setup
-----

* Create gradle.properties based in gradle.properties.example
* Edit application.yml development/test/production enviroment urls if not running csv on the same server / tomcat as librarycloud

Run
-----

As grails app:
* "./gradlew (-Dgrails.env=production) run" (if env not specified, runs in dev)

As war:
* "./gradlew (-Dgrails.env=production) war"
* deploy ./war/csv.war to tomcat
