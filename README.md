# Description

This project is a quick tool to generate Pharo classes from an OpenAPI description schema in Json, **specific to one endpoint only**. 
In its current form, you need to pass the description format as a FileReference or a String. 

Next versions will add a data loader and a retrieval of all endpoint from cURL to the API. 

# Installation

```smalltalk
Metacello new
  githubUser: 'Evref-BL' project: 'OpenAPI-Class-Builder' commitish: 'main' path: 'src';
  baseline: 'OpenAPIClassBuilder';
  load
```

# Usage

```smalltalk
OpenApiClassesBuilder newClassNamed: 'CopilotsMetric' compileFromFilePath: '<path-to-your-json>/schema.json'. 

```

# Example

extract the schema of data from the following REST API : [Github-Copilot-Metrics](https://docs.github.com/fr/enterprise-cloud@latest/rest/copilot/copilot-metrics?apiVersion=2022-11-28#get-copilot-metrics-for-an-enterprise).
place the JSON result in a local file `schema.json`.

Build another file `data.json` where you'll store the return data from the same API endpoint (or call the API from Pharo)
 
In Pharo; run: 
```smalltalk
"building class from schema file"
OpenApiClassesBuilder newClassNamed: 'CopilotsMetric' inPackage: #'Copilot-Github' withPrefix: 'CG' compileFromFilePath: 'shema.json'. 

"test data import from the same API point"
CGCopilotsMetric importFromJSON: 'data.json' asFileReference contents.
```
