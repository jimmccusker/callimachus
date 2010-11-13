<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sparql="http://www.w3.org/2005/sparql-results#">
	<xsl:param name="xslt" select="'/layout/template.xsl'" />
	<xsl:param name="this" />
	<xsl:param name="query" />
	<xsl:variable name="layout">
		<xsl:call-template name="substring-before-last">
			<xsl:with-param name="string" select="$xslt"/>
			<xsl:with-param name="delimiter" select="'/'"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="origin">
		<xsl:call-template name="substring-before-last">
			<xsl:with-param name="string" select="$layout" />
			<xsl:with-param name="delimiter" select="'/'"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="scheme" select="substring-before($xslt, '://')" />
	<xsl:variable name="host" select="substring-before(substring-after($xslt, '://'), '/')" />
	<xsl:variable name="accounts" select="concat($origin, '/accounts')" />
	<xsl:variable name="callimachus">
		<xsl:if test="$scheme and $host">
			<xsl:value-of select="concat($scheme, '://', $host, '/callimachus')" />
		</xsl:if>
		<xsl:if test="not($scheme) or not($host)">
			<xsl:value-of select="'/callimachus'" />
		</xsl:if>
	</xsl:variable>
	<xsl:template name="substring-before-last">
		<xsl:param name="string"/>
		<xsl:param name="delimiter"/>
		<xsl:if test="contains($string,$delimiter)">
			<xsl:value-of select="substring-before($string,$delimiter)"/>
			<xsl:if test="contains(substring-after($string,$delimiter),$delimiter)">
				<xsl:value-of select="$delimiter"/>
				<xsl:call-template name="substring-before-last">
					<xsl:with-param name="string" select="substring-after($string,$delimiter)"/>
					<xsl:with-param name="delimiter" select="$delimiter"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*|*|comment()|text()" />
		</xsl:copy>
	</xsl:template>
	<xsl:template match="@*">
		<xsl:attribute name="{name()}">
			<xsl:choose>
				<xsl:when test="starts-with(., '/callimachus/') and $callimachus">
					<xsl:value-of select="$callimachus"/>
					<xsl:value-of select="substring-after(., '/callimachus')" />
				</xsl:when>
				<xsl:when test="starts-with(., '/layout/') and $layout">
					<xsl:value-of select="$layout"/>
					<xsl:value-of select="substring-after(., '/layout')" />
				</xsl:when>
				<xsl:when test="starts-with(., '//') and $scheme">
					<xsl:value-of select="concat($scheme, ':')"/>
					<xsl:value-of select="." />
				</xsl:when>
				<xsl:when test="starts-with(., '/') and not(starts-with(., '//')) and $origin">
					<xsl:value-of select="$origin"/>
					<xsl:value-of select="." />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="." />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="comment()">
		<xsl:copy />
	</xsl:template>
	<xsl:template match="head">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			<meta http-equiv="X-UA-Compatible" content="IE=edge" />
			<link rel="icon" href="{$layout}/favicon.png" />
			<link rel="stylesheet" href="{$layout}/template.css" />
			<link type="text/css" href="{$layout}/jquery-ui-1.7.3.custom.css" rel="stylesheet" />
			<script type="text/javascript" src="{$callimachus}/scripts/jquery.js"></script>
			<script type="text/javascript" src="{$callimachus}/scripts/jquery-ui.js"></script>
			<script type="text/javascript" src="{$layout}/template.js"> </script>
			<xsl:if test="contains($query, 'copy') or contains($query, 'edit') ">
			<script type="text/javascript" src="{$callimachus}/scripts/jquery.qtip.js"> </script>
			<script type="text/javascript" src="{$callimachus}/scripts/jquery.rdfquery.rdfa.js"> </script>
			<script type="text/javascript" src="{$callimachus}/scripts/jquery.validate.js"> </script>
			<xsl:if test="contains($query, 'copy')">
			<script type="text/javascript" src="{$callimachus}/operations/copy.js"> </script>
			</xsl:if>
			<xsl:if test="contains($query, 'edit')">
			<script type="text/javascript" src="{$callimachus}/operations/edit.js"> </script>
			</xsl:if>
			<script type="text/javascript" src="{$callimachus}/scripts/elements.js"> </script>
			</xsl:if>
			<xsl:if test="//*[@class][contains(@class, 'wiki')]">
			<script type="text/javascript" src="{$callimachus}/scripts/creole.js"> </script>
			</xsl:if>
			<script type="text/javascript" src="{$callimachus}/scripts/enhancements.js"> </script>
			<xsl:if test="not(base) and $this">
				<base href="{$this}" />
			</xsl:if>
			<xsl:apply-templates select="*|text()|comment()" />
		</xsl:copy>
	</xsl:template>
	<xsl:template match="body">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			<div id="header">
				<div id="login-overlay" style="display:none" class="ui-widget-overlay"></div>
				<a class="ui-state-default ui-corner-all" id="login-link" href="{$accounts}/authority?login"
						style="display:none;padding: .2em 20px .2em 1em;text-decoration: none;position: relative;">
					<span>Login</span>
					<span class="ui-icon ui-icon-circle-arrow-s"
							style="margin: 0 0 0 5px;position: absolute;right: .2em;top: 50%;margin-top: -8px;">
						<xsl:text> </xsl:text>
					</span>
				</a>
				<form id="login-form" style="display:none;position:absolute;padding: 1em" class="ui-widget-content ui-corner-bottom">
					<p class="textbox">
						<label for="username">Username</label>
						<input type="text" id="login-username" name="username" size="15" />
					</p>

					<p class="textbox">
						<label for="password">Password</label>
						<input type="password" id="login-password" name="password" size="15" />
					</p>

					<p class="remember">
						<button type="submit">Login</button>
						<input type="checkbox" id="remember" name="remember" />
						<label for="remember">Remember me</label>
					</p>

					<p class="forgot">
						<a href="/accounts/unauthorized.xml">Forgot password or username?</a>
					</p>
				</form>
				<span class="authenticated" id="authenticated-links" style="display:none">
					<a id="authenticated-link" href="{$accounts}/authority?authenticated"></a>
					<a id="welcome-link" href="{$accounts}/authority?welcome"></a>
					<span> | </span>
					<a href="?edit">Settings</a>
					<span> | </span>
					<a href="?contributions">Contributions</a>
					<span> | </span>
					<a id="logout-link" href="{$accounts}/authority?logout">Logout</a>
				</span>
				<form method="GET" action="{$callimachus}/go" style="display:inline">
					<span id="search-box">
						<input id="search-box-input" type="text" size="10" name="q" title="Lookup..." />
						<button id="search-box-button" type="button" onclick="form.action='{$callimachus}/lookup';form.submit()">
							<img src="{$layout}/search.png" />
						</button>
					</span>
				</form>
			</div>
			<div id="sidebar">
				<a href="{$origin}/" id="logo"></a>
				<xsl:apply-templates mode="nav" select="document(concat($callimachus, '/menu'))" />
			</div>

			<ul id="tabs">
				<xsl:if test="contains($query, 'view')">
					<li class="authenticated">
						<span>View</span>
					</li>
					<li class="authenticated">
						<a class="diverted replace edit" href="">Edit</a>
					</li>
					<li class="authenticated">
						<a class="diverted replace describe" href="">Describe</a>
					</li>
					<li class="authenticated">
						<a class="diverted replace history" href="">History</a>
					</li>
				</xsl:if>
				<xsl:if test="contains($query, 'edit')">
					<li>
						<a class="diverted replace view" href="">View</a>
					</li>
					<li>
						<span>Edit</span>
					</li>
					<li>
						<a class="diverted replace describe" href="">Describe</a>
					</li>
					<li>
						<a class="diverted replace history" href="">History</a>
					</li>
				</xsl:if>
				<xsl:if test="contains($query, 'describe')">
					<li>
						<a class="diverted replace view" href="">View</a>
					</li>
					<li>
						<a class="diverted replace edit" href="">Edit</a>
					</li>
					<li>
						<span>Describe</span>
					</li>
					<li>
						<a class="diverted replace history" href="">History</a>
					</li>
				</xsl:if>
				<xsl:if test="contains($query, 'history')">
					<li>
						<a class="diverted replace view" href="">View</a>
					</li>
					<li>
						<a class="diverted replace edit" href="">Edit</a>
					</li>
					<li>
						<a class="diverted replace describe" href="">Describe</a>
					</li>
					<li>
						<span>History</span>
					</li>
				</xsl:if>
			</ul>
			<div id="content">
				<div id="error-widget" class="ui-state-error ui-corner-all" style="padding: 1ex; margin: 1ex; display: none">
					<div><span class="ui-icon ui-icon-alert" style="margin-right: 0.3em; float: left; "></span>
					<strong>Alert:</strong><span id="error-message" style="padding: 0px 0.7em"> Sample ui-state-error style.</span></div>
				</div>
				<xsl:apply-templates select="*|comment()|text()" />
				<div id="content-stop" />
			</div>

			<div id="footer" xmlns:audit="http://www.openrdf.org/rdf/2009/auditing#">
				<xsl:if test="contains($query, 'view')">
					<p id="footer-lastmod" rel="audit:revision" resource="?revision">This resource was last modified
						<span property="audit:committedOn" class="abbreviated datetime-locale" />.
					</p>
				</xsl:if>
				<a href="http://callimachusproject.org/" title="Callimachus">
					<img src="{$callimachus}/callimachus-powered.png" alt="Callimachus" />
				</a>
			</div>
		</xsl:copy>
	</xsl:template>
	<xsl:template mode="nav" match="sparql:sparql">
		<ul id="nav">
			<xsl:apply-templates mode="nav" select="sparql:results/sparql:result[not(sparql:binding/@name='parent')]" />
		</ul>
	</xsl:template>
	<xsl:template mode="nav" match="sparql:result[not(sparql:binding/@name='link')]">
		<li>
			<span>
				<xsl:value-of select="sparql:binding[@name='label']/*" />
			</span>
			<xsl:variable name="node" select="sparql:binding[@name='item']/*/text()" />
			<ul>
				<xsl:apply-templates mode="nav" select="../sparql:result[sparql:binding[@name='parent']/*/text()=$node]" />
			</ul>
		</li>
	</xsl:template>
	<xsl:template mode="nav" match="sparql:result[sparql:binding/@name='link']">
		<li>
			<a href="{sparql:binding[@name='link']/*}">
				<xsl:value-of select="sparql:binding[@name='label']/*" />
			</a>
			<xsl:variable name="node" select="sparql:binding[@name='item']/*/text()" />
			<ul>
				<xsl:apply-templates mode="nav" select="../sparql:result[sparql:binding[@name='parent']/*/text()=$node]" />
			</ul>
		</li>
	</xsl:template>
</xsl:stylesheet>
