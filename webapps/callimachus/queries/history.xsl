<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sparql="http://www.w3.org/2005/sparql-results#">
	<xsl:import href="recent-changes.xsl" />
	<xsl:output method="xml" encoding="UTF-8"/>
	<xsl:param name="this" />
	<xsl:template match="/">
		<html>
			<head>
				<base href="{$this}" />
				<title><xsl:value-of select="sparql:sparql/sparql:results/sparql:result[1]/sparql:binding[@name='label']/*" /></title>
			</head>
			<body>
				<h1><xsl:value-of select="sparql:sparql/sparql:results/sparql:result[1]/sparql:binding[@name='label']/*" /></h1>
				<xsl:if test="not(/sparql:sparql/sparql:results/sparql:result)">
					<p>No changes have ever been made.</p>
				</xsl:if>
				<xsl:if test="/sparql:sparql/sparql:results/sparql:result">
					<xsl:apply-templates />
				</xsl:if>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
