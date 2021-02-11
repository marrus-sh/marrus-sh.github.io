<!--
§ Usage:

Requires both XSLT 1.0 and EXSLT Common support.  Stick the following at the beginning of your XML file:

```
<?xml-stylesheet type="text/xsl" href="/path/to/transform.xslt"?>
```

§§ Configuration (in the file which links to this stylesheet):

☞ The first ‹ <html:link rel="alternate" type="application/rdf+xml"> › element with an @href attribute is used to source the RDF for the corpus.
☞ The @base attribute on the document element must match the base URIs used in linked RDF files.
☞ The @lang attribute on the document element is used to prioritize titles.
☞ Exactly one ‹ <html:article id="content"> › must be supplied; the result of the transform will be placed in here!
☞ Feel free to add your own <html:style> elements or other content.
-->
<stylesheet
	id="transform"
	version="1.0"
	xmlns="http://www.w3.org/1999/XSL/Transform"
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:schema.org="https://schema.org/"
	xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xhv="http://www.w3.org/1999/xhtml/vocab#"
>
	<variable name="rdf" select="concat(//html:base/@href[1], //html:link[@rel='alternate'][@type='application/rdf+xml']/@href[1])"/>
	<variable name="ppd" select="document($rdf)//foaf:PersonalProfileDocument[concat(ancestor-or-self::*[@xml:base][1]/@xml:base, @rdf:about) = $rdf]"/>
	<variable name="me" select="$ppd/foaf:primaryTopic/@rdf:resource[1]"/>
	<template match="@*|node()" mode="clone">
		<copy>
			<apply-templates mode="clone" select="@*|node()"/>
		</copy>
	</template>
	<template match="*" mode="lang">
		<attribute name="lang">
			<value-of select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
		</attribute>
		<attribute name="xml:lang">
			<value-of select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
		</attribute>
	</template>
	<template match="*">
		<copy>
			<apply-templates mode="clone" select="@*"/>
			<apply-templates/>
		</copy>
	</template>
	<template match="html:head">
		<!-- the content from the head of the document is simply copied over, with an additional stylesheet added.  the original styles and scripts are moved to the end, following the added stylesheet, so that they will take precedence. -->
		<copy>
			<apply-templates mode="clone" select="@* | node()[namespace-uri() != 'http://www.w3.org/1999/xhtml'] | html:*[local-name() != 'style' and local-name() != 'script']"/>
			<html:style>
@namespace "http://www.w3.org/1999/xhtml";
@keyframes SlideIn{
	from{ Top: 1.5EM }
	to{ Top: 0 } }
@keyframes SlideOut{
	from{ Top: 0 }
	to{ Top: -1.5EM } }

#content>header{ Display: Grid; Box-Sizing: Border-Box; Margin: Auto; Border-Style: Solid Double Double Solid; Border-Width: Thin Medium Medium Thin; Border-Radius: 1REM; Padding: 1REM 1.5REM .5REM; Width: 31REM; Max-Width: 100%; Grid: Auto 1FR Max-Content / MinMax(3REM, 1FR) 4FR; Gap: 1.5EM; Box-Shadow: 3PX 3PX 0 2PX CurrentColor }
#content>header h1{ Grid-Area: 1 / 2; Margin: 0; Border-Bottom: Thin Solid; Font-Size: 3REM; Font-Style: Italic; Font-Weight: 500; Font-Variant-Caps: Titling-Caps; Letter-Spacing: Calc(1EM / 24); Text-Align: Right; Text-Transform: Uppercase }
#content>header img{ Grid-Area: 1 / 1 / Span 2; Align-Self: Center; Justify-Self: Center; Width: 100%; Height: Auto }
#content>header dl{ Display: Grid; Margin: 0 0 Auto; Max-Width: 100%; Grid: Auto-Flow / Max-Content 1FR; Gap: 0 1.5REM; Overflow: Auto }
#content>header dl>div:Not([hidden]){ Display: Contents }
#content>header dt{ All: Unset; Display: Block; Grid-Column: 1; Font-Weight: 700; Text-Align: Right; }
#content>header dd{ All: Unset; Display: Block; Grid-Column: 2; Font-Weight: 300 }
#content>header dd ul{ Margin: 0; Padding: 0; List-Style-Type: None }
#content>header dl>div.CYCLE>dd{ Position: Relative; Height: 1.5EM; Overflow: Hidden; Contain: Paint }
#content>header dl>div.CYCLE>dd>span{ Display: Block; Position: Absolute; Left: 0; Right: 0; Overflow: Hidden; White-Space: NoWrap; Text-Overflow: Ellipsis; Animation: 1.2S .8S Ease-In Both SlideIn }
#content>header dl>div.CYCLE>dd>span:Only-Of-Type{ Animation: None }
#content>header dl>div.CYCLE>dd>span:Not(:Last-Child){ Animation: 1.2S .8S Ease-Out Both SlideOut }
#content>header footer{ Grid-Area: 3 / 1 / Span 1 / Span 2; Border-Top: Thin Solid; Padding-Top: .5EM; Font-Size: .75EM; Font-Weight: 300 }
#content>header footer p{ Margin: 0; Text-Indent: 0 }
#content>header *:Any-Link{ Color: Inherit }

#content>section{ Box-Sizing: Border-Box; Position: Relative; Margin: 3REM Auto; Border: Thin Solid; Padding: 1REM 1.5REM 1.5REM; Width: 31REM; Max-Width: 100%; Box-Shadow: 3PX 3PX 0 1PX CurrentColor; Font-Weight: 300; Text-Align: Justify }
#content>section>h2{ Margin: 0 0 1.5REM; Border-Bottom: Thin Solid; Padding-Bottom: .75REM; Font-Size: 2.25REM; Font-Style: Italic; Font-Weight: 400; Text-Align: Center; Letter-Spacing: Calc(1EM / 36) }
#content>section>section{ Margin: 1.5REM 0 0; Border-Style: Dashed Solid Solid Dotted; Border-Width: Thin; Padding: 1.5REM 2.25REM; Hyphens: Auto }
#content>section>section>h3{ Margin: 0 0 .75REM -.75REM; Font-Variant-Caps: Titling-Caps; Letter-Spacing: Calc(1EM / 24); Text-Align: Left; Text-Transform: Uppercase; Hyphens: None }
#content>section>section>h3 *:Any-Link{ Color: Inherit }
#content>section em{ Font-Style: Normal; Font-Weight: 400 }

#content>footer{ Box-Sizing: Border-Box; Margin: -1.5REM Auto 1.5REM; Border-Style: Solid None; Padding: 0 1REM; Width: 31REM; Max-Width: 100%; Text-Align: Center }
#content>footer>h2{ Margin: .75EM 0 0; Font-Size: Inherit; Font-Weight: 700; Text-Decoration: Wavy Underline }
#content>footer>ul{ Margin: 0 0 .75EM; Padding: 0; Font-Weight: 300 }
#content>footer>ul>li{ Display: Inline List-Item; List-Style-Position: Inside }
#content>footer>ul>li:Not(:Last-Child)::after{ Content: "    "  }

footer{ Text-Align: Right }

p{ Margin: 0 }
p+p{ Text-Indent: 1.5EM }
ol,
ul{ Margin: .75EM 0 }

b{ Box-Decoration-Break: Clone; Border: Thin Solid; Box-Shadow: 1PX 1PX CurrentColor; Font: Inherit }
strong{ Font-Weight: 700 }
			</html:style>
			<apply-templates mode="clone" select="html:style | html:script"/>
		</copy>
	</template>
	<template match="html:article[@id='content']">
		<html:article id="content">
			<for-each select="document($rdf)//*[@rdf:about = $me]">
				<html:header id="{rdfs:label}">
					<html:h1>
						<apply-templates select="foaf:nick[1]" mode="lang"/>
						<value-of select="foaf:nick[1]"/>
					</html:h1>
					<html:img src="{document(concat(foaf:img/ancestor-or-self::*[@xml:base][1]/@xml:base, foaf:img/@rdfs:isDefinedBy))//foaf:Image/xhv:alternate/@rdf:resource}">
					</html:img>
					<html:dl>
						<html:div class="CYCLE">
							<html:dt lang="en">name</html:dt>
							<html:dd>
								<html:div hidden="">
									<for-each select="foaf:name">
										<html:span>
											<apply-templates select="." mode="lang"/>
											<apply-templates/>
										</html:span>
									</for-each>
								</html:div>
							</html:dd>
						</html:div>
						<html:div class="CYCLE">
							<html:dt lang="en">gender</html:dt>
							<html:dd>
								<html:div hidden="">
									<for-each select="schema.org:gender">
										<html:span>
											<apply-templates select="foaf:name | ." mode="lang"/>
											<apply-templates select="foaf:name | @foaf:name"/>
										</html:span>
									</for-each>
								</html:div>
							</html:dd>
						</html:div>
						<html:div class="CYCLE">
							<html:dt lang="en">interests</html:dt>
							<html:dd>
								<html:div hidden="">
									<for-each select="foaf:topic_interest">
										<html:span>
											<apply-templates select="foaf:name | ." mode="lang"/>
											<apply-templates select="foaf:name | @foaf:name"/>
										</html:span>
									</for-each>
								</html:div>
							</html:dd>
						</html:div>
						<html:div>
							<html:dt lang="en">online</html:dt>
							<html:dd>
								<html:ul>
									<for-each select="foaf:account/foaf:OnlineAccount">
										<html:li>
											<html:a href="{@rdf:about}">
												<apply-templates select="foaf:name[1]" mode="lang"/>
												<apply-templates select="foaf:name[1]/node()"/>
											</html:a>
										</html:li>
									</for-each>
								</html:ul>
							</html:dd>
						</html:div>
					</html:dl>
					<html:script>
Array.prototype.forEach.call(document.body.querySelectorAll("#content>header dl>div.CYCLE"), cycle => {
	const dd = cycle.children[1]
	const hid = dd.querySelector("div[hidden]")
	Array.prototype.forEach.call(hid.children, span =>
		span.addEventListener("animationend", evt => {
			if ( evt.animationName == "SlideOut" )
				hid.appendChild(span)
			else if ( evt.animationName == "SlideIn" )
				dd.appendChild(
					hid.children[Math.floor(Math.random() * hid.children.length)]) }))
	dd.appendChild(
		hid.children[Math.floor(Math.random() * hid.children.length)])
	dd.appendChild(
		hid.children[Math.floor(Math.random() * hid.children.length)]) })
					</html:script>
					<html:footer id="plan">
						<for-each select="foaf:plan">
							<html:p hidden="">
								<apply-templates select="." mode="lang"/>
								<apply-templates/>
							</html:p>
						</for-each>
						<html:script>
const fortuneëlt = document.getElementById("plan")
const selectFortune = ( ) => {
	const
		$fortunes = fortuneëlt.querySelectorAll("p")
		, fortune = $fortunes[Math.floor(Math.random() * $fortunes.length)]
	Array.prototype.forEach.call(fortuneëlt.children, elt =>
		elt.hidden = !(elt.localName != "p" || elt == fortune)) }
document.addEventListener("visibilitychange", selectFortune)
selectFortune()
fortuneëlt.hidden = false
						</html:script>
					</html:footer>
				</html:header>
				<for-each select="foaf:currentProject/foaf:Document">
					<html:section>
						<html:h2>
							<apply-templates select="foaf:name[1]" mode="lang"/>
							<apply-templates select="foaf:name[1]/node()"/>
						</html:h2>
						<apply-templates select="rdf:value/node()"/>
						<for-each select="foaf:topic/foaf:Project">
							<html:section>
								<html:h3>
									<apply-templates select="foaf:name[1]" mode="lang"/>
									<choose>
										<when test="foaf:homepage">
											<html:a href="{foaf:homepage[1]/@rdf:resource}">
												<apply-templates select="foaf:name[1]/node()"/>
											</html:a>
										</when>
										<otherwise>
											<apply-templates select="foaf:name[1]/node()"/>
										</otherwise>
									</choose>
								</html:h3>
								<apply-templates select="rdfs:comment/node()"/>
							</html:section>
						</for-each>
					</html:section>
				</for-each>
				<if test="foaf:made/foaf:Document/@rdf:about">
					<html:footer>
						<html:h2>Additional Documents</html:h2>
						<html:ul>
							<for-each select="foaf:made/foaf:Document[@rdf:about]">
								<html:li>
									<apply-templates select="foaf:name[1]" mode="lang"/>
									<html:a href="{@rdf:about}">
										<html:cite>
											<apply-templates select="foaf:name[1]/node()"/>
										</html:cite>
									</html:a>
								</html:li>
							</for-each>
						</html:ul>
					</html:footer>
				</if>
			</for-each>
		</html:article>
	</template>
</stylesheet>
