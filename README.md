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

```smalltalk
"fichier de schéma avec compiler de class"
OpenApiClassesBuilder newClassNamed: 'CopilotsMetric' compileFromFilePath: 'schema.json'. 

OpenApiClassesBuilder newClassNamed: 'GithubIssues' inPackage: #'MyTestPackage-Github' withPrefix: 'GS' compileFromFilePath: 'shema-list-issue-event-repo-github.json'. 

"test de l'import depuis les data"
OpenApiCopilotsMetric importFromJSON: 'data/2025-04-09_2025-05-05.json' asFileReference contents.
```
