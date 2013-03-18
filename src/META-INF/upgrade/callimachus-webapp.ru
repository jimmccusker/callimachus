# callimachus-webapp.ru
#
# read by Setup.java to determine initial Callimachus webapp path
# @webapp </callimachus/1.0/>
#
PREFIX xsd:<http://www.w3.org/2001/XMLSchema#>
PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl:<http://www.w3.org/2002/07/owl#>
PREFIX skos:<http://www.w3.org/2004/02/skos/core#>
PREFIX sd:<http://www.w3.org/ns/sparql-service-description#>
PREFIX void:<http://rdfs.org/ns/void#>
PREFIX foaf:<http://xmlns.com/foaf/0.1/>
PREFIX msg:<http://www.openrdf.org/rdf/2011/messaging#>
PREFIX calli:<http://callimachusproject.org/rdf/2009/framework#>

################################################################
# Data to initialize an Callimachus store, but may be removed.
################################################################

################################
# Version Info
################################

INSERT {
<../> calli:hasComponent <../ontology>.
<../ontology> a <types/Serviceable>, owl:Ontology;
    rdfs:label "ontology";
    rdfs:comment "Vocabulary used to create local Callimachus applications";
    owl:versionInfo "1.0";
    calli:administrator </auth/groups/admin>.
} WHERE {
	FILTER NOT EXISTS { <../ontology> a owl:Ontology }
};

################################
# Stable URLs
################################

INSERT {
<../../> calli:hasComponent <../>.
} WHERE {
	FILTER (<../../> != <../>)
	FILTER NOT EXISTS { <../../> calli:hasComponent <../> }
};

INSERT {
<../> a <types/Folder>, calli:Folder;
    rdfs:label "callimachus";
    calli:reader </auth/groups/public>;
    calli:administrator </auth/groups/super>;
    calli:hasComponent
        <../profile>,
        <../changes/>,
        <../styles.css>,
        <../scripts.js>,
        <../library.xpl>,
        <../forbidden.html>,
        <../unauthorized.html>,
        <../layout-functions.xq>,
        <../default-layout.xq>,
        <../callimachus-powered.png>,
        <../document-editor.html>,
        <../css-editor.html>,
        <../html-editor.html>,
        <../javascript-editor.html>,
        <../sparql-editor.html>,
        <../text-editor.html>,
        <../xml-editor.html>,
        <../Concept>.
} WHERE {
	FILTER NOT EXISTS { <../> a calli:Folder }
};

INSERT {
<../profile> a <types/Profile>;
    rdfs:label "profile";
    calli:administrator </auth/groups/super>;
    calli:editor </auth/groups/power>,</auth/groups/admin>;
    calli:subscriber </auth/groups/staff>;
    calli:reader </auth/groups/system>.
} WHERE {
	FILTER NOT EXISTS { <../profile> a <types/Profile> }
};

INSERT {
<../changes/> a <types/Folder>, calli:Folder;
    rdfs:label "changes";
    calli:subscriber </auth/groups/power>,</auth/groups/admin>.
} WHERE {
	FILTER NOT EXISTS { <../changes/> a calli:Folder }
};

INSERT {
<../styles.css> a <types/PURL>, calli:PURL ;
	rdfs:label "styles.css";
	calli:alternate ?alternate;
	calli:administrator </auth/groups/super>;
	calli:reader </auth/groups/public> .
} WHERE {
    BIND (str(<styles/callimachus.less?less>) as ?alternate)
	FILTER NOT EXISTS { <../styles.css> a calli:PURL }
};

INSERT {
<../scripts.js> a <types/PURL>, calli:PURL ;
	rdfs:label "scripts.js";
	calli:alternate ?alternate;
	calli:administrator </auth/groups/super>;
	calli:reader </auth/groups/public> .
} WHERE {
    BIND (str(<scripts/index?source>) AS ?alternate)
	FILTER NOT EXISTS { <../scripts.js> a calli:PURL }
};

INSERT {
<../library.xpl> a <types/PURL>, calli:PURL ;
	rdfs:label "library.xpl";
	calli:alternate ?alternate;
	calli:administrator </auth/groups/super>;
	calli:reader </auth/groups/public> .
} WHERE {
    BIND (str(<pipelines/library.xpl>) as ?alternate)
	FILTER NOT EXISTS { <../library.xpl> a calli:PURL }
};

INSERT {
<../forbidden.html> a <types/PURL>, calli:PURL ;
	rdfs:label "forbidden.html";
	calli:alternate <pages/forbidden.xhtml?html>;
	calli:administrator </auth/groups/super>;
	calli:reader </auth/groups/public> .
} WHERE {
	FILTER NOT EXISTS { <../forbidden.html> a calli:PURL }
};

INSERT {
<../unauthorized.html> a <types/PURL>, calli:PURL ;
	rdfs:label "unauthorized.html";
	calli:alternate ?alternate;
	calli:administrator </auth/groups/super>;
	calli:reader </auth/groups/public> .
} WHERE {
    BIND (str(<pages/unauthorized.xhtml?element=/1>) AS ?alternate)
	FILTER NOT EXISTS { <../unauthorized.html> a calli:PURL }
};

INSERT {
<../layout-functions.xq> a <types/PURL>, calli:PURL ;
	rdfs:label "layout-functions.xq";
	calli:alternate ?alternate;
	calli:administrator </auth/groups/super>;
	calli:reader </auth/groups/public> .
} WHERE {
    BIND (str(<transforms/layout-functions.xq>) AS ?alternate)
	FILTER NOT EXISTS { <../layout-functions.xq> a calli:PURL }
};

INSERT {
<../default-layout.xq> a <types/PURL>, calli:PURL ;
	rdfs:label "default-layout.xq";
	calli:alternate ?alternate;
	calli:administrator </auth/groups/super>;
	calli:reader </auth/groups/public> .
} WHERE {
    BIND (str(<transforms/default-layout.xq>) AS ?alternate)
	FILTER NOT EXISTS { <../default-layout.xq> a calli:PURL }
};

INSERT {
<../callimachus-powered.png> a <types/PURL>, calli:PURL ;
	rdfs:label "callimachus-powered.png";
	calli:alternate ?alternate;
	calli:administrator </auth/groups/super>;
	calli:reader </auth/groups/public> .
} WHERE {
    BIND (str(<images/callimachus-powered.png>) AS ?alternate)
	FILTER NOT EXISTS { <../callimachus-powered.png> a calli:PURL }
};

INSERT {
<../document-editor.html> a <types/PURL>, calli:PURL ;
	rdfs:label "document-editor.html";
	calli:alternate ?alternate;
	calli:administrator </auth/groups/super>;
	calli:reader </auth/groups/public> .
} WHERE {
    BIND (str(<editor/ckeditor.html>) AS ?alternate)
	FILTER NOT EXISTS { <../document-editor.html> a calli:PURL }
};

INSERT {
<../css-editor.html> a <types/PURL>, calli:PURL ;
	rdfs:label "css-editor.html";
	calli:alternate ?alternate;
	calli:administrator </auth/groups/super>;
	calli:reader </auth/groups/public> .
} WHERE {
    BIND (str(<editor/text-editor.html#css>) AS ?alternate)
	FILTER NOT EXISTS { <../css-editor.html> a calli:PURL }
};

INSERT {
<../html-editor.html> a <types/PURL>, calli:PURL ;
	rdfs:label "html-editor.html";
	calli:alternate ?alternate;
	calli:administrator </auth/groups/super>;
	calli:reader </auth/groups/public> .
} WHERE {
    BIND (str(<editor/text-editor.html#html>) AS ?alternate)
	FILTER NOT EXISTS { <../html-editor.html> a calli:PURL }
};

INSERT {
<../javascript-editor.html> a <types/PURL>, calli:PURL ;
	rdfs:label "javascript-editor.html";
	calli:alternate ?alternate;
	calli:administrator </auth/groups/super>;
	calli:reader </auth/groups/public> .
} WHERE {
    BIND (str(<editor/text-editor.html#javascript>) AS ?alternate)
	FILTER NOT EXISTS { <../javascript-editor.html> a calli:PURL }
};

INSERT {
<../sparql-editor.html> a <types/PURL>, calli:PURL ;
	rdfs:label "sparql-editor.html";
	calli:alternate ?alternate;
	calli:administrator </auth/groups/super>;
	calli:reader </auth/groups/public> .
} WHERE {
    BIND (str(<editor/text-editor.html#sparql>) AS ?alternate)
	FILTER NOT EXISTS { <../sparql-editor.html> a calli:PURL }
};

INSERT {
<../text-editor.html> a <types/PURL>, calli:PURL ;
	rdfs:label "text-editor.html";
	calli:alternate ?alternate;
	calli:administrator </auth/groups/super>;
	calli:reader </auth/groups/public> .
} WHERE {
    BIND (str(<editor/text-editor.html>) AS ?alternate)
	FILTER NOT EXISTS { <../text-editor.html> a calli:PURL }
};

INSERT {
<../xml-editor.html> a <types/PURL>, calli:PURL ;
	rdfs:label "xml-editor.html";
	calli:alternate ?alternate;
	calli:administrator </auth/groups/super>;
	calli:reader </auth/groups/public> .
} WHERE {
    BIND (str(<editor/text-editor.html#xml>) AS ?alternate)
	FILTER NOT EXISTS { <../xml-editor.html> a calli:PURL }
};

INSERT {
<../Concept> a <types/PURL>, calli:PURL ;
	rdfs:label "Concept";
	calli:canonical ?canonical;
	calli:administrator </auth/groups/super>;
	calli:reader </auth/groups/public> .
} WHERE {
    BIND (str(<types/Concept>) AS ?canonical)
	FILTER NOT EXISTS { <../Concept> a calli:PURL }
};

################################
# Authorization and Groups
################################

INSERT {
</auth/> calli:hasComponent </auth/digest-users/>.
</auth/digest-users/> a <types/Folder>, calli:Folder;
    rdfs:label "digest users";
    calli:subscriber </auth/groups/power>;
    calli:administrator </auth/groups/admin>.
} WHERE {
	FILTER NOT EXISTS { </auth/digest-users/> a calli:Folder }
};

INSERT {
</auth/> calli:hasComponent </auth/secrets/>.
</auth/secrets/> a <types/Folder>, calli:Folder;
    rdfs:label "secrets";
    calli:editor </auth/groups/admin>.
} WHERE {
	FILTER NOT EXISTS { </auth/secrets/> a calli:Folder }
};

INSERT {
</auth/> calli:hasComponent </auth/groups/>.
</auth/groups/> a <types/Folder>, calli:Folder;
    rdfs:label "groups";
    calli:subscriber </auth/groups/power>;
    calli:administrator </auth/groups/admin>;
    calli:hasComponent
        </auth/groups/super>,
        </auth/groups/admin>,
        </auth/groups/power>,
        </auth/groups/staff>,
        </auth/groups/users>,
        </auth/groups/everyone>,
        </auth/groups/system>,
        </auth/groups/public>.

</auth/groups/super> a calli:Party, calli:Group, <types/Group>;
    rdfs:label "super";
    rdfs:comment "The user accounts in this group have heightened privileges to change or patch the system itself".

</auth/groups/admin> a calli:Party, calli:Group, <types/Group>;
    rdfs:label "admin";
    rdfs:comment "Members of this grouph have the ability to edit other user accounts and access to modify the underlying data store";
    calli:subscriber </auth/groups/power>;
    calli:administrator </auth/groups/admin>;
    calli:membersFrom ".".

</auth/groups/power> a calli:Party, calli:Group, <types/Group>;
    rdfs:label "power";
    rdfs:comment "Members of this group can access all data in the underlying data store";
    calli:subscriber </auth/groups/power>;
    calli:administrator </auth/groups/admin>;
    calli:membersFrom ".".

</auth/groups/staff> a calli:Party, calli:Group, <types/Group>;
    rdfs:label "staff";
    rdfs:comment "Members of this group can design websites and develop applications";
    calli:subscriber </auth/groups/power>;
    calli:administrator </auth/groups/admin>;
    calli:membersFrom ".".

</auth/groups/users> a calli:Party, calli:Group, <types/Group>;
    rdfs:label "users";
    rdfs:comment "Members of this group can view, discuss, document, link, and upload binary resources";
    calli:subscriber </auth/groups/power>;
    calli:administrator </auth/groups/admin>;
    calli:membersFrom ".".

</auth/groups/everyone> a calli:Party, calli:Group, <types/Group>;
    rdfs:label "everyone";
    rdfs:comment "A virtual group of all authorized users";
    calli:subscriber </auth/groups/power>;
    calli:administrator </auth/groups/admin>;
    calli:everyoneFrom ".".

</auth/groups/system> a calli:Party, calli:Group, <types/Group>;
    rdfs:label "system";
    rdfs:comment "The local computer or computer systems is the member of this group";
    calli:subscriber </auth/groups/power>;
    calli:administrator </auth/groups/admin>.

</auth/groups/public> a calli:Party, calli:Group, <types/Group>;
    rdfs:label "public";
    rdfs:comment "A virtual group of all agents";
    calli:subscriber </auth/groups/power>;
    calli:administrator </auth/groups/admin>;
    calli:anonymousFrom ".".
} WHERE {
	FILTER NOT EXISTS { </auth/groups/> a calli:Folder }
};

################################
# Services
################################

INSERT {
</> calli:hasComponent </sparql>.
</sparql> a <types/SparqlService>, sd:Service;
    rdfs:label "sparql";
    calli:administrator </auth/groups/admin>;
    sd:endpoint </sparql>;
    sd:supportedLanguage sd:SPARQL11Query, sd:SPARQL11Update;
    sd:feature sd:UnionDefaultGraph, sd:BasicFederatedQuery;
    sd:inputFormat <http://www.w3.org/ns/formats/RDF_XML>, <http://www.w3.org/ns/formats/Turtle>;
    sd:resultFormat <http://www.w3.org/ns/formats/RDF_XML>, <http://www.w3.org/ns/formats/SPARQL_Results_XML>.
} WHERE {
	FILTER NOT EXISTS { </> calli:hasComponent </sparql/> }
};
