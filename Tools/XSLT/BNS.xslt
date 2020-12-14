<!DOCTYPE stylesheet [
	<!ENTITY NCName "http://www.w3.org/2001/XMLSchema#NCName">
	<!ENTITY gYearMonth "http://www.w3.org/2001/XMLSchema#gYearMonth">
	<!ENTITY integer "http://www.w3.org/2001/XMLSchema#integer">
	<!ENTITY date "http://www.w3.org/2001/XMLSchema#date">
]>
<!--
Branching Notational System XSL Transformation (BNS.xslt)

§ Usage:

Requires both XSLT 1.0 and EXSLT Common support.  CSS features require at least Firefox 76.  Stick the following at the beginning of your XML file:

```
<?xml-stylesheet type="text/xsl" href="/path/to/BNS.xslt"?>
```

§§ Configuration (in the file which links to this stylesheet):

☞ The first ‹ <html:link rel="alternate" type="application/rdf+xml"> › element with an @href attribute is used to source the RDF for the corpus.
☞ The @lang attribute on the document element is used to prioritize titles from fetched resources.
☞ The @prefix attribute on the <html:html> element (with the RDFa syntax) is used for shortening of displayed links (and branch IDs).
☞ Exactly one ‹ <article id="BNS"> › must be supplied; the corpus will be placed in here!
☞ Feel free to add your own <html:style> elements or other content.

§§ Things to be sure to define:

☞ ‹ bns:fullTitle › is used for titles of branches.  ‹ bns:abbreviatedTitle › takes preference in limited situations (navigational lists).
☞ ‹ dc:abstract › is used for branch summaries.  Note that this is an object property; it should point to a thing.
☞ ‹ bns:contents › gives the contents of a thing, most importantly the thing pointed by ‹ dc:abstract ›.  XML contents are supported with ‹ rdf:parseType='Literal' ›.
☞ ‹ xml:lang › or ‹ rdf:datatype › every time you specify a literal.

§§ Things which are supported:

☞ Defining a ‹ dc:FileFormat › once and then linking to it elsewhere with ‹ dc:format`.  Use ‹ dc:identifier › to give the MIME type for the file format in its defining instance.
☞ ‹ rdf:parseType="Resource" › and ‹ rdf:parseType="Literal" › in ※most※ of the places where they would make sense.
☞ ‹ <html:a><html:code></html:code></html:a> › is a special syntax which will generate a button that will attempt to fetched the title of the linked resource when clicked.  You can use the ‹ resource › property to specify a name for the resource, if it differs from the ‹ href › (which should point to its data).  The script will automatically convert ‹ http: › to ‹ https: ›, and handles Wikidata links as a special case.
☞ The RDFa Core Initial Context (so you needn’t provide those prefixes).

§§ Things notably not supported:

☞ Relative values for ‹ rdf:about › on branches, or, similarly, any use of ‹ rdf:ID › (as in either case this requires IRI processing).
☞ Relative values ⁜in general⁜ unless the base URIs of this stylesheet and the document it is being linked from are the same (or equivalent).
☞ A non‐nested structure for branches:  This stylesheet does not attempt to resolve ‹ rdf:resource › in ⁜most⁜ cases.

§ Disclaimer:

To the extent possible under law, KIBI Gô has waived all copyright and related or neighboring rights to this file via a CC0 1.0 Universal Public Domain Dedication.  See ‹ https://creativecommons.org/publicdomain/zero/1.0/ › for more information.
-->
<stylesheet
	id="transform"
	version="1.0"
	xmlns="http://www.w3.org/1999/XSL/Transform"
	xmlns:bns="https://go.KIBI.family/Ontologies/BNS/#"
	xmlns:dc="http://purl.org/dc/terms/"
	xmlns:dcmitype="http://purl.org/dc/dcmitype/"
	xmlns:exsl="http://exslt.org/common"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:svg="http://www.w3.org/2000/svg"
>
	<variable name="rdf" select="//html:link[@rel='alternate'][@type='application/rdf+xml']/@href[1]"/>
	<variable name="defaultprefixes">
		<html:dl>
			<call-template name="prefixes">
				<with-param name="prefixlist">
					<text>
as: https://www.w3.org/ns/activitystreams#
csvw: http://www.w3.org/ns/csvw#
dcat: http://www.w3.org/ns/dcat#
dqv: http://www.w3.org/ns/dqv#
duv: https://www.w3.org/ns/duv#
grddl: http://www.w3.org/2003/g/data-view#
jsonld: http://www.w3.org/ns/json-ld#
ldp: http://www.w3.org/ns/ldp#
ma: http://www.w3.org/ns/ma-ont#
oa: http://www.w3.org/ns/oa#
odrl: http://www.w3.org/ns/odrl/2/
org: http://www.w3.org/ns/org#
owl: http://www.w3.org/2002/07/owl#
prov: http://www.w3.org/ns/prov#
qb: http://purl.org/linked-data/cube#
rdf: http://www.w3.org/1999/02/22-rdf-syntax-ns#
rdfa: http://www.w3.org/ns/rdfa#
rdfs: http://www.w3.org/2000/01/rdf-schema#
rif: http://www.w3.org/2007/rif#
rr: http://www.w3.org/ns/r2rml#
sd: http://www.w3.org/ns/sparql-service-description#
skos: http://www.w3.org/2004/02/skos/core#
skosxl: http://www.w3.org/2008/05/skos-xl#
ssn: http://www.w3.org/ns/ssn/
sosa: http://www.w3.org/ns/sosa/
time: http://www.w3.org/2006/time#
void: http://rdfs.org/ns/void#
wdr: http://www.w3.org/2007/05/powder#
wdrs: http://www.w3.org/2007/05/powder-s#
xhv: http://www.w3.org/1999/xhtml/vocab#
xml: http://www.w3.org/XML/1998/namespace
xsd: http://www.w3.org/2001/XMLSchema#
earl: http://www.w3.org/ns/earl#
cc: http://creativecommons.org/ns#
ctag: http://commontag.org/ns#
dc: http://purl.org/dc/terms/
dcterms: http://purl.org/dc/terms/
dc11: http://purl.org/dc/elements/1.1/
foaf: http://xmlns.com/foaf/0.1/
gr: http://purl.org/goodrelations/v1#
ical: http://www.w3.org/2002/12/cal/icaltzd#
og: http://ogp.me/ns#
rev: http://purl.org/stuff/rev#
sioc: http://rdfs.org/sioc/ns#
v: http://rdf.data-vocabulary.org/#
vcard: http://www.w3.org/2006/vcard/ns#
schema: http://schema.org/
					</text>
				</with-param>
			</call-template>
			<call-template name="prefixes"/>
		</html:dl>
	</variable>
	<template name="shorten">
		<param name="uri"/>
		<param name="prefixes" select="$defaultprefixes"/>
		<variable name="expansion" select="exsl:node-set($prefixes)//html:dd[starts-with($uri, .)][last()]"/>
		<variable name="prefix" select="$expansion//preceding-sibling::html:dt[1]"/>
		<choose>
			<when test="$prefix">
				<value-of select="concat($prefix, ':', substring-after($uri, $expansion))"/>
			</when>
			<otherwise>
				<value-of select="$uri"/>
			</otherwise>
		</choose>
	</template>
	<template name="expand">
		<param name="pname"/>
		<param name="prefixes" select="$defaultprefixes"/>
		<variable name="prefix" select="exsl:node-set($prefixes)//html:dt[starts-with($pname, concat(., ':'))][last()]"/>
		<variable name="expansion" select="$prefix//following-sibling::html:dd[1]"/>
		<choose>
			<when test="$prefix">
				<value-of select="concat($expansion, substring-after($pname, concat($prefix, ':')))"/>
			</when>
			<otherwise>
				<value-of select="$pname"/>
			</otherwise>
		</choose>
	</template>
	<template name="formatnumber">
		<param name="number"/>
		<variable name="num" select="number($number)"/>
		<choose>
			<when test="0>$num">
				<text>−</text>
				<value-of select="-$num"/>
			</when>
			<otherwise>
				<value-of select="$num"/>
			</otherwise>
		</choose>
	</template>
	<template name="subsuper">
		<param name="string"/>
		<choose>
			<when test="substring($string, 1, 1)='0' or substring($string, 1, 1)='1' or substring($string, 1, 1)='2' or substring($string, 1, 1)='3' or substring($string, 1, 1)='4' or substring($string, 1, 1)='5' or substring($string, 1, 1)='6' or substring($string, 1, 1)='7' or substring($string, 1, 1)='8' or substring($string, 1, 1)='9' or substring($string, 1, 1)='-'">
				<value-of select="substring($string, 1, 1)"/>
				<call-template name="subsuper">
					<with-param name="string" select="substring($string, 2)"/>
				</call-template>
			</when>
			<otherwise>
				<html:sup>
					<value-of select="$string"/>
				</html:sup>
			</otherwise>
		</choose>
	</template>
	<template name="mediatype">
		<choose>
			<when test="dc:format/dc:FileFormat/dc:identifier">
				<value-of select="dc:format/dc:FileFormat/dc:identifier"/>
			</when>
			<when test="document($rdf)//dc:FileFormat[@rdf:about=current()/dc:format/@rdf:resource or @rdf:nodeID=current()/dc:format/@rdf:nodeID]/dc:identifier">
				<value-of select="document($rdf)//dc:FileFormat[@rdf:about=current()/dc:format/@rdf:resource or @rdf:nodeID=current()/dc:format/@rdf:nodeID]/dc:identifier"/>
			</when>
		</choose>
	</template>
	<template match="*" mode="contents">
		<choose>
			<when test="@rdf:parseType='Literal'">
				<apply-templates/>
			</when>
			<when test="bns:contents">
				<apply-templates select="bns:contents" mode="contents"/>
			</when>
			<when test="@rdf:resource|@rdf:about">
				<variable name="mediatype">
					<call-template name="mediatype"/>
				</variable>
				<choose>
					<when test="@rdf:resource">
						<html:iframe data-src="{@rdf:resource}"/>
					</when>
					<when test="$mediatype='application/tei+xml'">
						<html:iframe data-src="{@rdf:about}"/>
					</when>
					<when test="$mediatype='text/html'">
						<html:iframe data-src="{@rdf:about}"/>
					</when>
					<when test="$mediatype='application/xhtml+xml'">
						<html:iframe data-src="{@rdf:about}"/>
					</when>
					<when test="starts-with($mediatype, 'video/')">
						<html:video controls="" data-src="{@rdf:about}"/>
					</when>
					<when test="starts-with($mediatype, 'audio/')">
						<html:audio controls="" data-src="{@rdf:about}"/>
					</when>
					<when test="starts-with($mediatype, 'image/')">
						<html:img alt="{@dc:abstract}" data-src="{@rdf:about}"/>
					</when>
					<when test="starts-with($mediatype, 'text/')">
						<html:iframe data-src="{@rdf:about}"/>
					</when>
					<when test="$mediatype='application/xml' or substring-after($mediatype, '+')='xml'">
						<html:iframe data-src="{@rdf:about}"/>
					</when>
					<otherwise>
						<html:iframe data-src="{@rdf:about}"/>
					</otherwise>
				</choose>
			</when>
			<otherwise>
				<html:span lang="{@xml:lang}">
					<value-of select="."/>
				</html:span>
			</otherwise>
		</choose>
	</template>
	<template name="prefixes">
		<param name="prefixlist" select="//html:html/@prefix"/>
		<variable name="prefix" select="normalize-space($prefixlist)"/>
		<if test="contains($prefix, ': ')">
			<html:div>
				<html:dt>
					<value-of select="substring-before($prefix, ': ')"/>
				</html:dt>
				<html:dd>
					<choose>
						<when test="contains(substring-after($prefix, ': '), ' ')">
							<value-of select="substring-before(substring-after($prefix, ': '), ' ')"/>
						</when>
						<otherwise>
							<value-of select="substring-after($prefix, ': ')"/>
						</otherwise>
					</choose>
				</html:dd>
			</html:div>
			<if test="contains(substring-after($prefix, ': '), ' ')">
				<call-template name="prefixes">
					<with-param name="prefixlist" select="substring-after(substring-after($prefix, ': '), ' ')"/>
				</call-template>
			</if>
		</if>
	</template>
	<template match="html:*|svg:*">
		<copy>
			<for-each select="@*">
				<copy/>
			</for-each>
			<apply-templates/>
		</copy>
	</template>
	<template match="html:head">
		<copy>
			<for-each select="@*">
				<copy/>
			</for-each>
			<html:style>
@keyframes In-From-Start{
	from{ Inset-Inline: -100%; Opacity: 0 }
	to{ Inset-Inline: 0; Opacity: 1 }
}
@keyframes In-From-End{
	from{ Inset-Inline: 100%; Opacity: 0 }
	to{ Inset-Inline: 0; Opacity: 1 }
}
@keyframes Out-To-Start{
	from{ Inset-Inline: 0; Opacity: 1 }
	to{ Inset-Inline: -100%; Opacity: 0 }
}
@keyframes Out-To-End{
	from{ Inset-Inline: 0; Opacity: 1 }
	to{ Inset-Inline: 100%; Opacity: 0 }
}
html{ Margin: 0; Padding: 0; Font-Family: Serif; Line-Height: 1.25 }
body{ Margin: 0; Padding: 0 }
#BNS{ Display: Flex; Position: Relative; Box-Sizing: Border-Box; Margin-Block: 0 2REM; Margin-Inline: Auto; Border-End-Start-Radius: 4REM; Border-End-End-Radius: 4REM; Padding-Block: 1REM; Padding-Inline: 5REM; Min-Block-Size: Calc(100VH - 2REM); Block-Size: 28REM; Inline-Size: 54REM; Max-Inline-Size: 100%; Flex-Direction: Column; Color: Var(--Text); Background: Var(--Background); Font-Family: Serif; Line-Height: 1.25; Z-Index: Auto; --Background: Canvas; --Canvas: Canvas; --Fade: GrayText; --Magic: LinkText; --Text: CanvasText; --Attn: ActiveText; --Bold: VisitedText; --Shade: CanvasText }
#BNS::after{ Display: Block; Position: Absolute; Inset-Block: Auto -2EM; Inset-Inline: 0; Block-Size: 6REM; Background: Var(--Shade); Z-Index: -1; Content: "" }
#BNS>header{ Flex: None }
#BNS>header>h1{ Display: Block; Margin-Block: .5REM; Border: None; Padding: 0; Font-Size: XX-Large; Font-Family: Sans-Serif; Text-Align: Center }
#BNS>header>h1>a{ Color: Var(--Shade) }
#BNS>header>h1>a:Hover{ Color: Var(--Attn) }
#BNS>header>nav{ Font-Size: Medium; Margin-Block: .5REM 1REM; Color: Var(--Text); Font-Family: Sans-Serif; Text-Align: Justify; Text-Align-Last: Center }
#BNS>header>nav>ol,#BNS>header>nav>ol>li{ Display: Inline; Margin: 0; Padding: 0 }
#BNS>header>nav>ol>li+li::before{ Margin-Inline-Start: .5EM; Border-Inline-Start: Thin Solid; Padding-Inline-Start: .5EM; Content: "" }
#BNS>header>nav a{ Color: Var(--Text); Text-Decoration: None }
#BNS>header>nav a:Focus,#BNS>header>nav a:Hover{ Text-Decoration: Underline }
#BNS>div{ Position: Relative; Flex: Auto; Margin-Block: 0 -1REM; Margin-Inline: -5REM; Min-Block-Size: Calc(60VH - 2REM); Overflow: Hidden }
#BNS>div>*{ Display: Grid; Position: Absolute; Box-Sizing: Border-Box; Inset-Block: 0; Inset-Inline: 0 Auto; Border: .25REM Var(--Shade) Solid; Border-Radius: 4REM; Padding: 2REM; Inline-Size: 100%; Gap: 1REM 2REM; Grid-Template-Rows: Min-Content 1FR Min-Content; Grid-Template-Columns: 1FR 23EM; Overflow: Hidden; Background: Var(--Canvas) }
#BNS>div>*[data-slide=in]{ Animation: In-From-End 1S Both }
#BNS>div>*[data-direction=reverse][data-slide=in]{ Animation: In-From-Start 1S Both }
#BNS>div>*[data-slide=out]{ Animation: Out-To-Start 1S Both }
#BNS>div>*[data-direction=reverse][data-slide=out]{ Animation: Out-To-End 1S Both }
#BNS>div>*[hidden]{ Display: None }
#BNS>div>*>header,#BNS>div>*>header+section,#BNS>div>*>div,#BNS>div>*>footer{ Grid-Column: 1 / Span 2 }
#BNS>div>*>header{ Display: Grid; Grid-Auto-Flow: Dense Column; Grid-Row: 1 / Span 1; Margin-Block: -1REM 0; Margin-Inline: -2REM; Border-Block-End: Thin Var(--Shade) Solid; Padding-Block: 0 1REM; Padding-Inline: 2REM; Grid-Template-Rows: Auto Auto Auto; Grid-Template-Columns: Auto 1EM 1EM Min-Content 1EM 1EM Auto; Gap: .3125EM .5REM; Text-Align: Center }
#BNS>div>*>header>p{ Grid-Column: 2 / Span 5; Margin-Block: 0; Min-Width: Max-Content; Color: Var(--Bold); Font-Variant-Caps: Small-Caps; Text-Align: Center; Text-Decoration: Underline }
#BNS>div>*>header>p>a{ Color: Inherit }
#BNS>div>*>header>p>a:Focus,#BNS>div>*>header>p>a:Hover{ Color: Var(--Shade); Text-Decoration: Double Underline }
#BNS>div>*>header>hgroup>h1{ Grid-Column: 1 / Span 7; Margin-Block: 0; Border: None; Padding: 0; Color: Var(--Shade) }
#BNS>div>*>header>hgroup>h2{ Grid-Column: 4 / Span 1; Margin-Block: 0; Min-Width: Max-Content; Color: Var(--Attn); Font-Size: Inherit; Font-Weight: Inherit; Font-Variant-Caps: Small-Caps }
#BNS>div>*>header>hgroup,#BNS>div>*>header>nav{ Display: Contents }
#BNS>div>*>header>nav>a{ Text-Decoration: None }
#BNS>div>*>header>nav>a[data-nav=prev]{ Grid-Column: 2 / Span 1 }
#BNS>div>*>header>nav>a[data-nav=parent]{ Grid-Column: 3 / Span 1 }
#BNS>div>*>header>nav>a[data-nav=child]{ Grid-Column: 5 / Span 1 }
#BNS>div>*>header>nav>a[data-nav=next]{ Grid-Column: 6 / Span 1 }
#BNS>div>*>section{ Display: Flex; Flex-Direction: Column; Box-Sizing: Border-Box; Grid-Row: 2 / Span 1; Margin-Inline: Auto; Border-Block: Thin Var(--Shade) Solid; Padding-Inline: 0 1PX; Inline-Size: 100%; Max-Inline-Size: 23EM; Overflow-Block: Auto; Overflow-Inline: Hidden }
#BNS>div>*>section>*{ Flex: 1; Border-Color: Var(--Shade); Margin-Block: -1PX 0; Border-Block-Style: Solid Double; Border-Block-Width: Thin Medium; Border-Inline-Style: Solid Double; Border-Inline-Width: Thin Medium; Padding-Block: 1EM; Padding-Inline: 1EM; Background: Var(--Background); Box-Shadow: 1PX 1PX Var(--Shade) }
#BNS>div>*>section>*:Not(:Empty)~*{ Margin-Block-Start: Calc(1EM + 1PX) }
#BNS>div>*>section>*:Empty:Not(:Only-Child){ Display: None }
#BNS>div>*>figure{ Display: Grid; Grid-Row: 2 / Span 1; Grid-Column: 1 / Span 1; Margin: 0; Padding: 0; Block-Size: 100%; Inline-Size: 100%; Overflow: Hidden }
#BNS>div>*>figure>*{ Border: None; Grid-Row: 1 / Span 1; Grid-Column: 1 / Span 1; Block-Size: 100%; Inline-Size: 100%; Object-Fit: Contain }
#BNS>div>*>div{ Display: Grid; Grid-Row: 2 / Span 1; Margin-Block: -1REM; Margin-Inline: -2REM; Padding-Block: 2REM 0; Padding-Inline: 2REM; Block-Size: 100%; Grid-Template-Rows: 1FR Max-Content; Grid-Auto-Flow: Row; Overflow: Auto; Background: Var(--Shade); Color: Var(--Canvas) }
#BNS>div>*>div>div{ Display: Contents }
#BNS>div>*>div>div>*{ Box-Sizing: Border-Box; Block-Size: 100%; Inline-Size: 100%; Overflow: Auto; Object-Fit: Contain }
#BNS>div>*>div>footer{ Padding-Block: .5EM }
#BNS>div>*>div>footer p{ Text-Align: Start; Text-Align-Last: Auto }
#BNS>div>*>div>footer a:Not(:Hover){ Color: Inherit }
#BNS>div>*>div>footer strong{ Color: Var(--Background) }
#BNS>div>*>footer{ Display: Flex; Grid-Row: 3 / Span 1; Margin-Block: 0 -2REM; Margin-Inline: -2REM; Border-Block-Start: Thin Var(--Shade) Solid; Padding-Block: 1EM; Padding-Inline: 3EM; Max-Inline-Size: Calc(100% + 4REM - 6EM); Justify-Content: Space-Between; Font-Size: Smaller; White-Space: NoWrap }
#BNS>div>*>footer>*:First-Child:Not(:Only-Child){ Flex: None }
#BNS>div>*>footer>*+*:Last-Child{ Display: Grid; Margin-Inline-Start: 1EM; Grid-Template-Columns: Max-Content 1FR Max-Content }
#BNS>div>*>footer>*+*:Last-Child>a{ Max-Inline-Size: 100%; Overflow: Hidden; Text-Overflow: Ellipsis }
#BNS>div>span{ Display: Block; Border: None; Padding: 0; Block-Size: 1EM; Inline-Size: Max-Content; Line-Height: 1; White-Space: Pre }
h1{ Margin-Block: 0 .5REM; Margin-Inline: Auto; Border-Width: Thin; Border-Block-Style: Dotted Solid; Border-Block-Color: Var(--Fade) Var(--Shade); Border-Inline-Style: Dashed; Border-Inline-Color: Var(--Text); Padding-Block: .3125EM; Padding-Inline: 1EM; Max-Inline-Size: Max-Content; Color: Var(--Text); Font-Size: X-Large; Font-Family: Sans-Serif; Line-Height: 1; Text-Align: Center }
blockquote,p{ Margin-Block: 0; Margin-Inline: Auto; Text-Align: Justify; Text-Align-Last: Center }
blockquote:Not(:First-Child),p:Not(:First-Child){ Margin-Block: .625EM 0 }
blockquote{ Padding-Inline: 1EM; Font-Style: Italic }
iframe{ Display: Block; Margin: 0; Border: Medium Var(--Canvas) Inset }
dl,ol,ul{ Margin-Block: 1EM; Margin-Inline: 0; Padding: 0; Text-Align: Start; Text-Align-Last: Auto }
nav ol,nav ul{ Margin-Block: .5REM; List-Style-Type: None }
nav li ol,nav li ul{ Margin-Block: 0 }
dt{ Margin-Inline: 0; Padding: 0 }
li,nav li li,dd{ Margin-Inline: 1EM 0; Padding: 0 }
nav li{ Margin-Inline: 0 }
dl{ Margin-Block: 1EM; Padding-Inline: 0 }
dl:First-Child{ Margin-Block-Start: 0 }
dt{ Font-Weight: Bold }
dd{ Display: List-Item; List-Style-Type: Square }
*:Any-Link{ Color: Var(--Text) }
*:Any-Link:Hover{ Color: Var(--Fade) }
a{ White-Space: Normal }
a[data-expanded]+small{ Display: Inline-Block; Vertical-Align: Sub; Font-Size: Smaller; Line-Height: 1 }
a[data-expanded]+small::before{ Content: "[" }
a[data-expanded]+small::after{ Content: "]" }
button,sup{ Line-Height: 1 }
button{ Margin-Inline: 0; Border-Color: CurrentColor; Border-Width: Thin; Border-Block-Style: None Dotted; Border-Inline-Style: None; Padding: 0; Vertical-Align: Super; Color: Var(--Magic); Background: Transparent; Font: Smaller; Cursor: Pointer }
strong{ Color: Var(--Attn) }
a:Hover strong{ Color: Var(--Shade) }
			</html:style>
			<html:script>
const u = s => ({
	bf: `http://id.loc.gov/ontologies/bibframe/`,
	bns: `https://go.KIBI.family/Ontologies/BNS/#`,
	dc: `http://purl.org/dc/terms/`,
	madsrdf: `http://www.loc.gov/mads/rdf/v1#`,
	owl: `http://www.w3.org/2002/07/owl#`,
	rdf: `http://www.w3.org/1999/02/22-rdf-syntax-ns#`,
	rdfs: `http://www.w3.org/2000/01/rdf-schema#`,
	skos: `http://www.w3.org/2004/02/skos/core#`,
	xml: `http://www.w3.org/XML/1998/namespace` }[s])
const o = ( { target: e } ) => {
	e.hidden = e.dataset.slide == `out`
	e.removeAttribute `data-slide`
	e.removeAttribute `data-direction`
	e.removeEventListener(`animationend`, o) }
const f = ( a, h, w, þ ) => {
	const x = new XMLHttpRequest
	x.open(`GET`, h.indexOf `http://www.wikidata.org/entity/` == 0 ? `https://www.wikidata.org/wiki/Special:EntityData/${ h.substring(31) }` : h.indexOf `http://` == 0 ? `https${ h.substring(4) }` : h)
	x.setRequestHeader(`Accept`, `application/rdf+xml`)
	x.responseType = `document`
	x.addEventListener(`load`, g.bind(null, x, a, h, w, þ))
	x.addEventListener(`error`, þ)
	x.send() }
const g = ( { response: d }, a, h, w, þ ) => {
	let n = null
	if ( !d ) return þ()
	if ( n = d.evaluate(`//*[@rdf:about='${a}' or owl:sameAs/@rdf:resource='${a}']/*[self::madsrdf:authoritativeLabel|self::skos:prefLabel|self::dc:title|self::bns:fullTitle|self::rdfs:label][@xml:lang='${document.documentElement.lang}' or starts-with(@xml:lang, '${document.documentElement.lang}-')]|//*[@rdf:about='${a}' or owl:sameAs/@rdf:resource='${a}']/bf:title/bf:Title/bf:mainTitle[@xml:lang='${document.documentElement.lang}' or starts-with(@xml:lang, '${document.documentElement.lang}-')]`, d, u, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue ?? d.evaluate(`//*[@rdf:about='${a}' or owl:sameAs/@rdf:resource='${a}']/*[self::madsrdf:authoritativeLabel|self::skos:prefLabel|self::dc:title|self::bns:fullTitle|self::rdfs:label]|//*[@rdf:about='${a}' or owl:sameAs/@rdf:resource='${a}']/bf:title/bf:Title/bf:mainTitle`, d, u, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue ) w(n)
	else if ( n = d.querySelector `link[rel~=alternate][type="application/rdf+xml"]` ) f(a, n.href, w, þ)
	else þ() }
const i = ( { target: e } ) => {
	e.onclick = null
	const a = e.previousElementSibling
	if ( a.origin != location.origin || a.pathname != location.pathname || a.search != location.search ) f(a.hasAttribute `resource` ? a.getAttribute `resource` : a.href, a.href, n => {
		const c = document.createElementNS(`http://www.w3.org/1999/xhtml`, `cite`)
		const s = document.createElementNS(`http://www.w3.org/1999/xhtml`, `small`)
		if ( n.hasAttributeNS(`http://www.w3.org/XML/1998/namespace`, `lang`) ) c.setAttribute(`lang`, n.getAttributeNS(`http://www.w3.org/XML/1998/namespace`, `lang`))
		c.textContent = n.textContent
		for ( const h of a.childNodes ) { s.appendChild(h) }
		a.appendChild(c)
		e.parentNode.replaceChild(s, e)
		a.dataset.expanded = "" }, ( ) => e.parentNode.removeChild(e))
	else {
		let n = document.getElementById(decodeURIComponent(a.hash.substring(1)))?.querySelector?.(`h1`)
		if ( n ) {
			const c = document.createElementNS(`http://www.w3.org/1999/xhtml`, `cite`)
			const s = document.createElementNS(`http://www.w3.org/1999/xhtml`, `small`)
			c.lang = n.lang
			c.textContent = n.textContent
			for ( const h of a.childNodes ) { s.appendChild(h) }
			a.appendChild(c)
			e.parentNode.replaceChild(s, e)
			a.dataset.expanded = "" } } }
window.addEventListener(`load`, ( ) => {
	const d = document.querySelector `#BNS>div`
	d.removeChild(d.firstElementChild)
	let e = location.hash.length > 1 ? document.getElementById(decodeURIComponent(location.hash.substring(1))) : null
	if ( !e || !e.matches `#BNS>div>*` ) e = document.querySelector `#BNS>div>*`
	for ( const p of document.querySelectorAll `#BNS>div>*` ) {
		p.hidden = p != e
		if ( p == e )
			for ( const m of e.querySelectorAll `iframe[data-src],audio[data-src],video[data-src],img[data-src]` ) {
				const n = m.cloneNode()
				n.src = m.dataset.src
				n.removeAttribute `data-src`
				m.parentNode.replaceChild(n, m) } } })
window.addEventListener(`hashchange`, v => {
	if ( 1 >= location.hash.length ) return
	let m = false
	let n = decodeURIComponent(location.hash.substring(1))
	let c = document.querySelector `#BNS>div>*:Not([hidden])`
	let e = document.getElementById(n)
	if ( !e.matches `#BNS>div>*` ) return
	for ( const p of document.querySelectorAll `#BNS>div>*` ) {
		if ( p == e ) {
			m = true
			if ( e.hidden || p.dataset.slide == `out` ) {
				for ( const m of e.querySelectorAll `iframe[data-src],audio[data-src],video[data-src],img[data-src]` ) {
					const n = m.cloneNode()
					n.src = m.dataset.src
					n.removeAttribute `data-src`
					m.parentNode.replaceChild(n, m) }
				e.dataset.slide = `in`
				e.addEventListener(`animationend`, o)
				e.hidden = false } }
		else if ( !p.hidden || p.dataset.slide == `in` ) {
			p.dataset.slide = `out`
			if (m) p.dataset.direction = e.dataset.direction = `reverse`
			else p.dataset.direction = e.dataset.direction = `forward`
			p.addEventListener(`animationend`, o) } }
	v.preventDefault() })
document.addEventListener(`keydown`, v => {
	let a
	const e = document.querySelector `#BNS>div>*:Not([hidden])`
	if ( v.key == `ArrowRight` || v.key == `ArrowLeft` ) v.preventDefault()
	if ( document.querySelector `#BNS>div>*[data-slide]` || !e ) return
	if ( v.key == `ArrowLeft` ) a = e.querySelector `a[data-nav=prev]`
	else if ( v.key == `ArrowUp` ) a = e.querySelector `a[data-nav=parent]`
	else if ( v.key == `ArrowDown` ) a = e.querySelector `a[data-nav=child]`
	else if ( v.key == `ArrowRight` ) a = e.querySelector `a[data-nav=next]`
	if ( !a ) return
	location.hash = a.hash })
			</html:script>
			<apply-templates/>
		</copy>
	</template>
	<template match="html:title">
		<copy>
			<value-of select="document($rdf)//bns:Corpus/bns:fullTitle"/>
		</copy>
	</template>
	<template match="html:a">
		<variable name="short">
			<call-template name="shorten">
				<with-param name="uri" select="@href"/>
			</call-template>
		</variable>
		<variable name="target" select="document($rdf)//*[self::bns:hasProjects|self::bns:includes]/*[@rdf:about=current()/@href]"/>
		<variable name="result">
			<copy>
				<choose>
					<when test="$target">
						<attribute name="href">
							<text>#</text>
							<value-of select="$short"/>
						</attribute>
					</when>
					<otherwise>
						<for-each select="@href">
							<copy/>
						</for-each>
					</otherwise>
				</choose>
				<for-each select="@*[not(name(.)='href')]">
					<copy/>
				</for-each>
				<apply-templates/>
			</copy>
		</variable>
		<choose>
			<when test="count(*)=1 and html:code">
				<html:span style="White-Space: NoWrap">
					<copy-of select="$result"/>
					<text>&#x2060;</text>
					<html:button title="Attempt to fetch link metadata." onclick="i(event)" type="button">[?]</html:button>
				</html:span>
			</when>
			<otherwise>
				<copy-of select="$result"/>
			</otherwise>
		</choose>
	</template>
	<template match="html:article[@id='BNS']">
		<copy>
			<for-each select="@*">
				<copy/>
			</for-each>
			<for-each select="document($rdf)">
				<html:header>
					<html:h1>
						<html:a>
							<attribute name="href">
								<text>#</text>
								<call-template name="shorten">
									<with-param name="uri" select=".//bns:Corpus[1]/@rdf:about"/>
								</call-template>
							</attribute>
							<apply-templates select=".//bns:Corpus/bns:fullTitle[1]" mode="contents"/>
						</html:a>
					</html:h1>
					<html:nav>
						<html:ol>
							<for-each select=".//bns:Project">
								<html:li value="{count(preceding-sibling::*)}">
									<html:a>
										<attribute name="href">
											<text>#</text>
											<call-template name="shorten">
												<with-param name="uri" select="@rdf:about"/>
											</call-template>
										</attribute>
										<html:code style="Font-Size: 1REM">
											<value-of select="bns:identifier"/>
										</html:code>
									</html:a>
								</html:li>
							</for-each>
						</html:ol>
					</html:nav>
				</html:header>
				<html:div>
					<html:span lang="en">Loading...</html:span>
					<apply-templates/>
				</html:div>
			</for-each>
		</copy>
	</template>
	<template name="formatted">
		<choose>
			<when test="self::bns:Project|parent::bns:hasProjects">
				<variable name="index" select="count(preceding-sibling::*)"/>
				<if test="10>$index">0</if>
				<if test="100>$index">0</if>
				<value-of select="$index"/>
			</when>
			<when test="self::bns:Book">
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<choose>
							<when test="bns:index=1">Α</when>
							<when test="bns:index=2">Β</when>
							<when test="bns:index=3">Γ</when>
							<when test="bns:index=4">Δ</when>
							<when test="bns:index=5">Ε</when>
							<when test="bns:index=6">Ζ</when>
							<when test="bns:index=7">Η</when>
							<when test="bns:index=8">Θ</when>
							<when test="bns:index=9">Ι</when>
							<when test="bns:index=10">Κ</when>
							<when test="bns:index=11">Λ</when>
							<when test="bns:index=12">Μ</when>
							<when test="bns:index=13">Ν</when>
							<when test="bns:index=14">Ξ</when>
							<when test="bns:index=15">Ο</when>
							<when test="bns:index=16">Π</when>
							<when test="bns:index=17">Ρ</when>
							<when test="bns:index=18">Σ</when>
							<when test="bns:index=19">Τ</when>
							<when test="bns:index=20">Υ</when>
							<when test="bns:index=21">Φ</when>
							<when test="bns:index=22">Χ</when>
							<when test="bns:index=23">Ψ</when>
							<when test="bns:index=24">Ω</when>
							<otherwise>
								<call-template name="formatnumber">
									<with-param name="number" select="bns:index"/>
								</call-template>
							</otherwise>
						</choose>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<otherwise>
						<text>“</text>
						<value-of select="bns:index"/>
						<text>”</text>
					</otherwise>
				</choose>
			</when>
			<when test="self::bns:Volume">
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<choose>
							<when test="bns:index>49">
								<call-template name="formatnumber">
									<with-param name="number" select="bns:index"/>
								</call-template>
							</when>
							<when test="bns:index>9">
								<choose>
									<when test="substring(number(bns:index), 1, 1)='4'">XXXX</when>
									<when test="substring(number(bns:index), 1, 1)='3'">XXX</when>
									<when test="substring(number(bns:index), 1, 1)='2'">XX</when>
									<when test="substring(number(bns:index), 1, 1)='1'">X</when>
								</choose>
								<choose>
									<when test="substring(number(bns:index), 2, 1)='9'">VIV</when>
									<when test="substring(number(bns:index), 2, 1)='8'">VIII</when>
									<when test="substring(number(bns:index), 2, 1)='7'">VII</when>
									<when test="substring(number(bns:index), 2, 1)='6'">VI</when>
									<when test="substring(number(bns:index), 2, 1)='5'">V</when>
									<when test="substring(number(bns:index), 2, 1)='4'">IV</when>
									<when test="substring(number(bns:index), 2, 1)='3'">III</when>
									<when test="substring(number(bns:index), 2, 1)='2'">II</when>
									<when test="substring(number(bns:index), 2, 1)='1'">I</when>
								</choose>
							</when>
							<when test="bns:index>0">
								<choose>
									<when test="bns:index=9">VIV</when>
									<when test="bns:index=8">VIII</when>
									<when test="bns:index=7">VII</when>
									<when test="bns:index=6">VI</when>
									<when test="bns:index=5">V</when>
									<when test="bns:index=4">IV</when>
									<when test="bns:index=3">III</when>
									<when test="bns:index=2">II</when>
									<when test="bns:index=1">I</when>
								</choose>
							</when>
							<otherwise>
								<call-template name="formatnumber">
									<with-param name="number" select="bns:index"/>
								</call-template>
							</otherwise>
						</choose>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<otherwise>
						<text>“</text>
						<value-of select="bns:index"/>
						<text>”</text>
					</otherwise>
				</choose>
			</when>
			<when test="self::bns:Arc">
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<choose>
							<when test="bns:index=1">α</when>
							<when test="bns:index=2">β</when>
							<when test="bns:index=3">γ</when>
							<when test="bns:index=4">δ</when>
							<when test="bns:index=5">ε</when>
							<when test="bns:index=6">ζ</when>
							<when test="bns:index=7">η</when>
							<when test="bns:index=8">θ</when>
							<when test="bns:index=9">ι</when>
							<when test="bns:index=10">κ</when>
							<when test="bns:index=11">λ</when>
							<when test="bns:index=12">μ</when>
							<when test="bns:index=13">ν</when>
							<when test="bns:index=14">ξ</when>
							<when test="bns:index=15">ο</when>
							<when test="bns:index=16">π</when>
							<when test="bns:index=17">ρ</when>
							<when test="bns:index=18">σ</when>
							<when test="bns:index=19">τ</when>
							<when test="bns:index=20">υ</when>
							<when test="bns:index=21">φ</when>
							<when test="bns:index=22">χ</when>
							<when test="bns:index=23">ψ</when>
							<when test="bns:index=24">ω</when>
							<otherwise>
								<call-template name="formatnumber">
									<with-param name="number" select="bns:index"/>
								</call-template>
							</otherwise>
						</choose>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<otherwise>
						<text>“</text>
						<value-of select="bns:index"/>
						<text>”</text>
					</otherwise>
				</choose>
			</when>
			<when test="self::bns:Side">
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<choose>
							<when test="bns:index=1">A</when>
							<when test="bns:index=2">B</when>
							<when test="bns:index=3">C</when>
							<when test="bns:index=4">D</when>
							<when test="bns:index=5">E</when>
							<when test="bns:index=6">F</when>
							<when test="bns:index=7">G</when>
							<when test="bns:index=8">H</when>
							<when test="bns:index=9">I</when>
							<when test="bns:index=10">J</when>
							<when test="bns:index=11">K</when>
							<when test="bns:index=12">L</when>
							<when test="bns:index=13">M</when>
							<when test="bns:index=14">N</when>
							<when test="bns:index=15">O</when>
							<when test="bns:index=16">P</when>
							<when test="bns:index=17">Q</when>
							<when test="bns:index=18">R</when>
							<when test="bns:index=19">S</when>
							<when test="bns:index=20">T</when>
							<when test="bns:index=21">U</when>
							<when test="bns:index=22">V</when>
							<when test="bns:index=23">W</when>
							<when test="bns:index=24">X</when>
							<when test="bns:index=25">Y</when>
							<when test="bns:index=26">Z</when>
							<otherwise>
								<call-template name="formatnumber">
									<with-param name="number" select="bns:index"/>
								</call-template>
							</otherwise>
						</choose>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<otherwise>
						<text>“</text>
						<value-of select="bns:index"/>
						<text>”</text>
					</otherwise>
				</choose>
			</when>
			<when test="self::bns:Chapter">
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<if test="10>bns:index">0</if>
						<call-template name="formatnumber">
							<with-param name="number" select="bns:index"/>
						</call-template>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<otherwise>
						<text>“</text>
						<value-of select="bns:index"/>
						<text>”</text>
					</otherwise>
				</choose>
			</when>
			<when test="self::bns:Section">
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<call-template name="formatnumber">
							<with-param name="number" select="bns:index"/>
						</call-template>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<otherwise>
						<text>“</text>
						<value-of select="bns:index"/>
						<text>”</text>
					</otherwise>
				</choose>
			</when>
			<when test="self::bns:Verse">
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<choose>
							<when test="bns:index>49">
								<call-template name="formatnumber">
									<with-param name="number" select="bns:index"/>
								</call-template>
							</when>
							<when test="bns:index>9">
								<choose>
									<when test="substring(number(bns:index), 1, 1)='4'">xxx</when>
									<when test="substring(number(bns:index), 1, 1)='3'">xxx</when>
									<when test="substring(number(bns:index), 1, 1)='2'">xx</when>
									<when test="substring(number(bns:index), 1, 1)='1'">x</when>
								</choose>
								<choose>
									<when test="substring(number(bns:index), 2, 1)='9'">viv</when>
									<when test="substring(number(bns:index), 2, 1)='8'">viii</when>
									<when test="substring(number(bns:index), 2, 1)='7'">vii</when>
									<when test="substring(number(bns:index), 2, 1)='6'">vi</when>
									<when test="substring(number(bns:index), 2, 1)='5'">v</when>
									<when test="substring(number(bns:index), 2, 1)='4'">iv</when>
									<when test="substring(number(bns:index), 2, 1)='3'">iii</when>
									<when test="substring(number(bns:index), 2, 1)='2'">ii</when>
									<when test="substring(number(bns:index), 2, 1)='1'">i</when>
								</choose>
							</when>
							<when test="bns:index>0">
								<choose>
									<when test="bns:index=9">viv</when>
									<when test="bns:index=8">viii</when>
									<when test="bns:index=7">vii</when>
									<when test="bns:index=6">vi</when>
									<when test="bns:index=5">v</when>
									<when test="bns:index=4">iv</when>
									<when test="bns:index=3">iii</when>
									<when test="bns:index=2">ii</when>
									<when test="bns:index=1">i</when>
								</choose>
							</when>
							<otherwise>
								<call-template name="formatnumber">
									<with-param name="number" select="bns:index"/>
								</call-template>
							</otherwise>
						</choose>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<otherwise>
						<text>“</text>
						<value-of select="bns:index"/>
						<text>”</text>
					</otherwise>
				</choose>
			</when>
			<when test="self::bns:Concept">
				<text>c</text>
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<call-template name="formatnumber">
							<with-param name="number" select="bns:index"/>
						</call-template>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<when test="string-length(translate(substring-after(bns:index, '_'), '0123456789', ''))>0">
						<call-template name="subsuper">
							<with-param name="string" select="substring-after(bns:index, '_')"/>
						</call-template>
					</when>
					<otherwise>
						<html:sup>
							<value-of select="bns:index"/>
						</html:sup>
					</otherwise>
				</choose>
			</when>
			<when test="self::bns:Version">
				<text>v</text>
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<call-template name="formatnumber">
							<with-param name="number" select="bns:index"/>
						</call-template>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<when test="string-length(translate(substring-after(bns:index, '_'), '0123456789', ''))>0">
						<call-template name="subsuper">
							<with-param name="string" select="substring-after(bns:index, '_')"/>
						</call-template>
					</when>
					<otherwise>
						<html:sup>
							<value-of select="bns:index"/>
						</html:sup>
					</otherwise>
				</choose>
			</when>
			<when test="self::bns:Draft">
				<text>d</text>
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<call-template name="formatnumber">
							<with-param name="number" select="bns:index"/>
						</call-template>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<when test="string-length(translate(substring-after(bns:index, '_'), '0123456789-', ''))>0">
						<call-template name="subsuper">
							<with-param name="string" select="substring-after(bns:index, '_')"/>
						</call-template>
					</when>
					<otherwise>
						<html:sup>
							<value-of select="bns:index"/>
						</html:sup>
					</otherwise>
				</choose>
			</when>
			<otherwise>
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<call-template name="formatnumber">
							<with-param name="number" select="bns:index"/>
						</call-template>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;' or bns:index/@rdf:datatype='&date;'">
						<value-of select="translate(bns:index, '-', '–')"/>
					</when>
					<otherwise>
						<text>“</text>
						<value-of select="bns:index"/>
						<text>”</text>
					</otherwise>
				</choose>
			</otherwise>
		</choose>
	</template>
	<template name="name">
		<html:hgroup>
			<for-each select="bns:fullTitle[1]">
				<html:h1 lang="{@xml:lang}">
					<apply-templates select="." mode="contents"/>
				</html:h1>
			</for-each>
			<choose>
				<when test="self::bns:Author">
					<html:h2 lang="en">
						Branching Notational System
					</html:h2>
				</when>
				<otherwise>
					<html:h2>
						<choose>
							<when test="bns:identifier">
								<value-of select="bns:identifier"/>
							</when>
							<otherwise>
								<if test="self::bns:Draft">
									<for-each select="ancestor::bns:Version[1]">
										<call-template name="formatted"/>
									</for-each>
								</if>
								<call-template name="formatted"/>
							</otherwise>
						</choose>
					</html:h2>
				</otherwise>
			</choose>
		</html:hgroup>
	</template>
	<template name="namedformat">
		<html:span lang="en">
			<choose>
				<when test="self::bns:Project|parent::bns:hasProjects">
					<text>Project </text>
					<call-template name="formatted"/>
				</when>
				<when test="self::bns:Concept|self::bns:Version|self::bns:Draft">
					<call-template name="formatted"/>
				</when>
				<when test="self::bns:Note|parent::bns:hasNote">
					<text>Note</text>
				</when>
				<otherwise>
					<value-of select="name(.)"/>
					<text> </text>
					<call-template name="formatted"/>
				</otherwise>
			</choose>
		</html:span>
	</template>
	<template name="navigate">
		<variable name="siblings">
			<choose>
				<when test="parent::bns:hasProjects">
					<for-each select="../../bns:hasProjects/*">
						<html:span>
							<value-of select="generate-id(.)"/>
						</html:span>
					</for-each>
				</when>
				<when test="parent::bns:includes">
					<for-each select="../../bns:includes/*[bns:index/@rdf:datatype='&integer;']">
						<sort select="bns:index" data-type="number"/>
						<html:span>
							<value-of select="generate-id(.)"/>
						</html:span>
					</for-each>
					<for-each select="../../bns:includes/*[not(bns:index/@rdf:datatype='&integer;')]">
						<sort select="bns:index" lang="en" case-order="upper-first"/>
						<html:span>
							<value-of select="generate-id(.)"/>
						</html:span>
					</for-each>
				</when>
				<when test="parent::bns:hasNote">
					<for-each select="../../bns:hasNote/*">
						<sort select="self::*[bns:identifier]/bns:identifier|self::*[not(bns:identifier)]/bns:fullTitle" lang="en" case-order="upper-first"/>
						<html:span>
							<value-of select="generate-id(.)"/>
						</html:span>
					</for-each>
				</when>
			</choose>
		</variable>
		<variable name="prev" select="exsl:node-set($siblings)/*[string(.)=generate-id(current())]/preceding-sibling::*[1]"/>
		<variable name="next" select="exsl:node-set($siblings)/*[string(.)=generate-id(current())]/following-sibling::*[1]"/>
		<html:nav>
			<if test="$prev">
				<html:a data-nav="prev">
					<attribute name="href">
						<text>#</text>
						<for-each select="../../*/*[generate-id(.)=$prev]">
							<call-template name="shorten">
								<with-param name="uri" select="@rdf:about"/>
							</call-template>
						</for-each>
					</attribute>
					<text>←</text>
				</html:a>
			</if>
			<if test="parent::bns:hasProjects/..|parent::bns:includes/..|parent::bns:hasNote/..">
				<html:a data-nav="parent">
					<attribute name="href">
						<text>#</text>
						<for-each select="../..">
							<call-template name="shorten">
								<with-param name="uri" select="@rdf:about"/>
							</call-template>
						</for-each>
					</attribute>
					<text>↑</text>
				</html:a>
			</if>
			<if test="bns:hasProjects/*|bns:includes/*">
				<html:a data-nav="child">
					<attribute name="href">
						<text>#</text>
						<for-each select="*[self::bns:hasProjects|self::bns:includes][1]/*[1]">
							<call-template name="shorten">
								<with-param name="uri" select="@rdf:about"/>
							</call-template>
						</for-each>
					</attribute>
				<text>↓</text>
				</html:a>
			</if>
			<if test="$next">
				<html:a data-nav="next">
					<attribute name="href">
						<text>#</text>
						<for-each select="../../*/*[generate-id(.)=$next]">
							<call-template name="shorten">
								<with-param name="uri" select="@rdf:about"/>
							</call-template>
						</for-each>
					</attribute>
					<text>→</text>
				</html:a>
			</if>
		</html:nav>
	</template>
	<template name="footer">
		<variable name="shortened">
			<call-template name="shorten">
				<with-param name="uri" select="@rdf:about"/>
			</call-template>
		</variable>
		<html:footer>
			<if test="string($shortened)!=string(@rdf:about)">
				<html:code>
					<value-of select="$shortened"/>
				</html:code>
			</if>
			<html:code>
				<text>&lt;</text>
				<html:a href="{@rdf:about}">
					<value-of select="@rdf:about"/>
				</html:a>
				<text>></text>
			</html:code>
		</html:footer>
	</template>
	<template name="metadata">
		<variable name="contents">
			<if test="bns:inspiration/@rdf:resource">
				<html:dt>Inspiration</html:dt>
				<for-each select="bns:inspiration/@rdf:resource">
					<variable name="link">
						<html:a href="{.}">
							<html:code>
								<call-template name="shorten">
									<with-param name="uri" select="."/>
								</call-template>
							</html:code>
						</html:a>
					</variable>
					<html:dd>
						<apply-templates select="exsl:node-set($link)"/>
					</html:dd>
				</for-each>
			</if>
		</variable>
		<if test="string($contents)">
			<html:dl>
				<copy-of select="$contents"/>
			</html:dl>
		</if>
	</template>
	<template name="includes">
		<for-each select="bns:hasProjects/*">
			<apply-templates select="."/>
		</for-each>
		<for-each select="bns:includes/*[bns:index/@rdf:datatype='&integer;']">
			<sort select="bns:index" data-type="number"/>
			<apply-templates select="."/>
		</for-each>
		<for-each select="bns:includes/*[not(bns:index/@rdf:datatype='&integer;')]">
			<sort select="bns:index" lang="en" case-order="upper-first"/>
			<apply-templates select="."/>
		</for-each>
		<for-each select="bns:hasNote/*">
			<sort select="self::*[bns:identifier]/bns:identifier|self::*[not(bns:identifier)]/bns:fullTitle" lang="en" case-order="upper-first"/>
			<apply-templates select="."/>
		</for-each>
	</template>
	<template match="*[parent::rdf:RDF]" priority="-2"/>
	<template match="*[bns:hasProjects]" priority="2">
		<html:section hidden="">
			<attribute name="id">
				<call-template name="shorten">
					<with-param name="uri" select="@rdf:about"/>
				</call-template>
			</attribute>
			<html:header>
				<html:p lang="en">Corpus of</html:p>
				<apply-templates select="bns:forAuthor/*"/>
				<call-template name="navigate"/>
			</html:header>
			<if test="bns:hasCover/*">
				<html:figure>
					<choose>
						<when test="bns:hasCover/*[1][../@rdf:parseType='Resource']">
							<apply-templates select="bns:hasCover/*[1]/.." mode="contents"/>
						</when>
						<otherwise>
							<apply-templates select="bns:hasCover/*[1]" mode="contents"/>
						</otherwise>
					</choose>
				</html:figure>
			</if>
			<html:section>
				<html:div>
					<apply-templates select="dc:abstract"/>
					<call-template name="metadata"/>
				</html:div>
			</html:section>
			<call-template name="footer"/>
		</html:section>
		<call-template name="includes"/>
	</template>
	<template match="bns:Author">
		<call-template name="name"/>
	</template>
	<template match="*[parent::bns:includes|parent::bns:hasProjects|parent::bns:hasNote]">
		<variable name="contents">
			<apply-templates select="." mode="header"/>
			<choose>
				<when test="bns:isPublishedAs/*[@rdf:about]|bns:isPublishedAs/@rdf:resource">
					<variable name="documents">
						<for-each select="bns:isPublishedAs/*[@rdf:about]|bns:isPublishedAs[@rdf:resource]">
							<variable name="mediatype">
								<call-template name="mediatype"/>
							</variable>
							<html:div>
								<choose>
									<when test="@rdf:resource">
										<attribute name="data-sort">10</attribute>
									</when>
									<when test="$mediatype='application/tei+xml'">
										<attribute name="data-sort">1</attribute>
									</when>
									<when test="$mediatype='text/html'">
										<attribute name="data-sort">2</attribute>
									</when>
									<when test="$mediatype='application/xhtml+xml'">
										<attribute name="data-sort">3</attribute>
									</when>
									<when test="starts-with($mediatype, 'video/')">
										<attribute name="data-sort">4</attribute>
									</when>
									<when test="starts-with($mediatype, 'audio/')">
										<attribute name="data-sort">5</attribute>
									</when>
									<when test="starts-with($mediatype, 'image/')">
										<attribute name="data-sort">6</attribute>
									</when>
									<when test="starts-with($mediatype, 'text/')">
										<attribute name="data-sort">7</attribute>
									</when>
									<when test="$mediatype='application/xml' or substring-after($mediatype, '+')='xml'">
										<attribute name="data-sort">8</attribute>
									</when>
									<otherwise>
										<attribute name="data-sort">9</attribute>
									</otherwise>
								</choose>
								<html:div>
									<apply-templates select="." mode="contents"/>
								</html:div>
								<html:a href="{@rdf:about|@rdf:resource}" target="_blank">
									<choose>
										<when test="string($mediatype)">
											<attribute name="type">
												<value-of select="$mediatype"/>
											</attribute>
											<html:code>
												<value-of select="$mediatype"/>
											</html:code>
										</when>
										<when test="self::dcmitype:*">
											<value-of select="name(.)"/>
										</when>
										<otherwise>
											<text>???</text>
										</otherwise>
									</choose>
								</html:a>
							</html:div>
						</for-each>
					</variable>
					<variable name="sorted">
						<for-each select="exsl:node-set($documents)//*[@data-sort]">
							<sort select="@data-sort" data-type="number"/>
							<copy-of select="."/>
						</for-each>
					</variable>
					<html:div>
						<copy-of select="exsl:node-set($sorted)//*[@data-sort][1]/*[1]"/>
						<html:footer>
							<html:p>
								<html:a lang="en">
									<for-each select="exsl:node-set($sorted)//*[@data-sort][1]/*[2]">
										<for-each select="@*">
											<copy/>
										</for-each>
										<text>Open in a new window</text>
										<if test="@type">
											<text> (</text>
											<copy-of select="node()"/>
											<text>)</text>
										</if>
									</for-each>
								</html:a>
							</html:p>
							<if test="exsl:node-set($sorted)//*[@data-sort][position()!=1]/*[2]">
								<html:p>
									<html:strong lang="en">Other formats:</html:strong>
									<for-each select="exsl:node-set($sorted)//*[@data-sort][position()!=1]/*[2]">
										<text> </text>
										<copy-of select="."/>
									</for-each>
								</html:p>
							</if>
						</html:footer>
					</html:div>
				</when>
				<otherwise>
					<if test="bns:hasCover/*">
						<html:figure>
							<choose>
								<when test="bns:hasCover/*[1][../@rdf:parseType='Resource']">
									<apply-templates select="bns:hasCover/*[1]/.." mode="contents"/>
								</when>
								<otherwise>
									<apply-templates select="bns:hasCover/*[1]" mode="contents"/>
								</otherwise>
							</choose>
						</html:figure>
					</if>
					<html:section>
						<html:div>
							<apply-templates select="dc:abstract" mode="contents"/>
							<call-template name="metadata"/>
						</html:div>
						<if test="bns:includes/*|bns:hasNote/*">
							<html:nav>
								<if test="bns:includes/*">
									<html:section>
										<html:h1 lang="en">Includes</html:h1>
										<html:ol>
											<for-each select="bns:includes/*[bns:index/@rdf:datatype='&integer;']">
												<sort select="bns:index" data-type="number"/>
												<apply-templates select="." mode="list"/>
											</for-each>
											<for-each select="bns:includes/*[not(bns:index/@rdf:datatype='&integer;')]">
												<sort select="bns:index" lang="en" case-order="upper-first"/>
												<apply-templates select="." mode="list"/>
											</for-each>
										</html:ol>
									</html:section>
								</if>
								<if test="bns:hasNote/*">
									<html:section>
										<html:h1 lang="en">Notes</html:h1>
										<html:ul>
											<for-each select="bns:hasNote/*">
												<sort select="self::*[bns:identifier]/bns:identifier|self::*[not(bns:identifier)]/bns:fullTitle" lang="en" case-order="upper-first"/>
												<apply-templates select="." mode="list"/>
											</for-each>
										</html:ul>
									</html:section>
								</if>
							</html:nav>
						</if>
					</html:section>
				</otherwise>
			</choose>
			<call-template name="footer"/>
		</variable>
		<choose>
			<when test="parent::bns:hasNote">
				<html:aside hidden="">
					<attribute name="id">
						<call-template name="shorten">
							<with-param name="uri" select="@rdf:about"/>
						</call-template>
					</attribute>
					<copy-of select="$contents"/>
				</html:aside>
			</when>
			<otherwise>
				<html:section hidden="">
					<attribute name="id">
						<call-template name="shorten">
							<with-param name="uri" select="@rdf:about"/>
						</call-template>
					</attribute>
					<copy-of select="$contents"/>
				</html:section>
			</otherwise>
		</choose>
		<call-template name="includes"/>
	</template>
	<template match="*[parent::bns:includes|parent::bns:hasProjects|parent::bns:hasNote]" mode="header">
		<html:header>
			<html:p>
				<for-each select="ancestor::*[parent::bns:includes|parent::bns:hasProjects|parent::bns:hasNote]">
					<html:a>
						<attribute name="href">
							<text>#</text>
							<call-template name="shorten">
								<with-param name="uri" select="@rdf:about"/>
							</call-template>
						</attribute>
						<call-template name="namedformat"/>
					</html:a>
					<if test="not(self::bns:Version)">
						<text> :: </text>
					</if>
				</for-each>
				<if test="parent::bns:hasNote/parent::bns:Version">
					<text> :: </text>
				</if>
				<call-template name="namedformat"/>
			</html:p>
			<call-template name="name"/>
			<call-template name="navigate"/>
		</html:header>
	</template>
	<template match="*[parent::bns:includes|parent::bns:hasProjects|parent::bns:hasNote]" mode="list">
		<html:li>
			<choose>
				<when test="parent::bns:hasProjects">
					<attribute name="value">
						<value-of select="count(preceding-sibling::*)"/>
					</attribute>
				</when>
				<when test="parent::bns:includes">
					<attribute name="value">
						<choose>
							<when test="bns:index[@rdf:datatype='&integer;']">
								<value-of select="bns:index"/>
							</when>
							<otherwise>
								<text>0</text>
							</otherwise>
						</choose>
					</attribute>
				</when>
			</choose>
			<html:a>
				<attribute name="href">
					<text>#</text>
					<call-template name="shorten">
						<with-param name="uri" select="@rdf:about"/>
					</call-template>
				</attribute>
				<html:strong>
					<call-template name="namedformat"/>
					<if test="bns:fullTitle|bns:abbreviatedTitle">
						<text>:</text>
					</if>
				</html:strong>
				<choose>
					<when test="bns:abbreviatedTitle">
						<text> </text>
						<html:cite>
							<apply-templates select="bns:abbreviatedTitle[1]" mode="contents"/>
						</html:cite>
					</when>
					<when test="bns:fullTitle">
						<text> </text>
						<html:cite>
							<apply-templates select="bns:fullTitle[1]" mode="contents"/>
						</html:cite>
					</when>
				</choose>
			</html:a>
			<choose>
				<when test="bns:isPublishedAs/*">
					<text> </text>
					<html:small lang="en">(available)</html:small>
				</when>
				<when test="bns:hasNote/*">
					<text> </text>
					<html:small lang="en">(with notes)</html:small>
				</when>
			</choose>
			<if test="bns:includes/*">
				<html:ol>
					<for-each select="bns:includes/*[bns:index/@rdf:datatype='&integer;']">
						<sort select="bns:index" data-type="number"/>
						<apply-templates select="." mode="list"/>
					</for-each>
					<for-each select="bns:includes/*[not(bns:index/@rdf:datatype='&integer;')]">
						<sort select="bns:index" lang="en" case-order="upper-first"/>
						<apply-templates select="." mode="list"/>
					</for-each>
				</html:ol>
			</if>
		</html:li>
	</template>
</stylesheet>
