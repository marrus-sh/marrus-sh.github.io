<!DOCTYPE stylesheet [
	<!ENTITY NCName "http://www.w3.org/2001/XMLSchema#NCName">
	<!ENTITY gYearMonth "http://www.w3.org/2001/XMLSchema#gYearMonth">
	<!ENTITY integer "http://www.w3.org/2001/XMLSchema#integer">
]>
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
	<variable name="prefixes">
		<html:dl>
			<call-template name="prefixes"/>
		</html:dl>
	</variable>
	<template name="shorten">
		<param name="uri"/>
		<variable name="expansion" select="exsl:node-set($prefixes)//html:dd[starts-with($uri, .)]"/>
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
		<variable name="prefix" select="exsl:node-set($prefixes)//html:dt[starts-with($pname, concat(., ':'))]"/>
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
	<template name="prefixes">
		<param name="prefix" select="normalize-space(//html:html/@prefix)"/>
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
					<with-param name="prefix" select="substring-after(substring-after($prefix, ': '), ' ')"/>
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
html{ Position: Relative; Margin: Auto; Padding: 0; Background: Black; Inline-Size: 54REM; Max-Inline-Size: 100%; Color: #333; Font-Family: Serif; Line-Height: 1.25 }
body{ Margin-Block: 0 2REM; Margin-Inline: 0; Border-End-Start-Radius: 4REM; Border-End-End-Radius: 4REM; Padding-Block: 1REM; Padding-Inline: 5REM; Background: White }
#BNS{ Writing-Mode: Horizontal-TB; Display: Flex; Flex-Direction: Column; Min-Block-Size: Calc(100VH - 4REM); Block-Size: 28REM }
#BNS>header{ Flex: None }
#BNS>header>h1{ Display: Block; Margin-Block: .5REM; Color: #111; Font-Size: XXX-Large; Font-Family: Sans-Serif; Text-Align: Center }
#BNS>header>nav{ Font-Size: Medium; Margin-Block: 1REM; Color: #333; Font-Family: Sans-Serif; Line-Height: 1.2; Text-Align: Justify; Text-Align-Last: Center }
#BNS>header>nav>ol,#BNS>header>nav>ol>li{ Display: Inline; Margin: 0; Padding: 0 }
#BNS>header>nav>ol>li+li::before{ Content: " | " }
#BNS>header>nav a{ Text-Decoration: None }
#BNS>div{ Position: Relative; Flex: Auto; Margin-Block: 0 -1REM; Margin-Inline: -5REM; Min-Block-Size: Calc(60VH - 2REM); Overflow: Hidden }
#BNS>div>span{ Display: Block; Position: Absolute; Margin: Auto; Inset-Block: 0; Inset-Inline: 0; Block-Size: 1EM; Inline-Size: Max-Content; Line-Height: 1; White-Space: Pre }
#BNS>div>section{ Display: Grid; Position: Absolute; Box-Sizing: Border-Box; Inset-Block: 0; Inset-Inline: 0 Auto; Border: .25REM Black Solid; Border-Radius: 4REM; Padding: 2REM; Inline-Size: 100%; Gap: 1REM 2REM; Grid-Template-Rows: Min-Content 1FR Min-Content; Grid-Template-Columns: 1FR 23EM; Overflow: Hidden; Background: #EEE }
#BNS>div>section[hidden]{ Display: None }
#BNS>div>section>header,#BNS>div>section>header+section,#BNS>div>section>div,#BNS>div>section>footer{ Grid-Column: 1 / Span 2 }
#BNS>div>section>header{ Display: Grid; Grid-Auto-Flow: Dense Column; Grid-Row: 1 / Span 1; Margin-Block: -1REM 0; Margin-Inline: -2REM; Border-Block-End: Thin Black Solid; Padding-Block: 0 1REM; Padding-Inline: 2REM; Grid-Template-Rows: Auto Auto Auto; Grid-Template-Columns: Auto 1EM 1EM Min-Content 1EM 1EM Auto; Gap: .3125EM .5REM; Text-Align: Center }
#BNS>div>section>header>p{ Grid-Column: 2 / Span 5; Margin-Block: 0; Min-Width: Max-Content; Color: #555; Font-Variant-Caps: Small-Caps; Text-Align: Center; Text-Decoration: Underline }
#BNS>div>section>header>hgroup>h1{ Grid-Column: 1 / Span 7 }
#BNS>div>section>header>hgroup>h2{ Grid-Column: 4 / Span 1; Margin-Block: 0; Min-Width: Max-Content; Font-Size: Inherit; Font-Weight: Inherit; Font-Variant-Caps: Small-Caps; Color: #333 }
#BNS>div>section>header>hgroup,#BNS>div>section>header>nav{ Display: Contents }
#BNS>div>section>header>nav>a{ Text-Decoration: None }
#BNS>div>section>header>nav>a[data-nav=prev]{ Grid-Column: 2 / Span 1 }
#BNS>div>section>header>nav>a[data-nav=parent]{ Grid-Column: 3 / Span 1 }
#BNS>div>section>header>nav>a[data-nav=child]{ Grid-Column: 5 / Span 1 }
#BNS>div>section>header>nav>a[data-nav=next]{ Grid-Column: 6 / Span 1 }
#BNS>div>section>section{ Display: Flex; Flex-Direction: Column; Box-Sizing: Border-Box; Grid-Row: 2 / Span 1; Margin-Inline: Auto; Border-Block: Thin Black Solid; Padding-Inline: 0 1PX; Inline-Size: 100%; Max-Inline-Size: 23EM; Overflow: Auto }
#BNS>div>section>section>*{ Flex: 1; Border-Color: Black; Margin-Block: -1PX 0; Border-Block-Style: Solid Double; Border-Block-Width: Thin Medium; Border-Inline-Style: Solid Double; Border-Inline-Width: Thin Medium; Padding-Block: 1EM; Padding-Inline: 1EM; Background: #FFF; Box-Shadow: 1PX 1PX Black }
#BNS>div>section>section>*:Not(:Empty)~*{ Margin-Block-Start: Calc(1EM + 1PX) }
#BNS>div>section>section>*:Empty:Not(:Only-Child){ Display: None }
#BNS>div>section>figure{ Display: Grid; Grid-Row: 2 / Span 1; Grid-Column: 1 / Span 1; Margin: 0; Padding: 0; Block-Size: 100%; Inline-Size: 100%; Overflow: Hidden }
#BNS>div>section>figure>*{ Border: None; Grid-Row: 1 / Span 1; Grid-Column: 1 / Span 1; Block-Size: 100%; Inline-Size: 100%; Object-Fit: Contain }
#BNS>div>section>div{ Display: Block; Margin-Block: -1REM; Margin-Inline: -2REM; Padding: 2REM; Grid-Row: 2 / Span 1; Overflow: Auto; Background: Black }
#BNS>div>section>div>iframe{ Display: Block; Margin: 0; Border: None; Block-Size: 100%; Inline-Size: 100% }
#BNS>div>section>footer{ Display: Flex; Grid-Row: 3 / Span 1; Margin-Block: 0 -2REM; Margin-Inline: -2REM; Border-Block-Start: Thin Black Solid; Padding-Block: 1EM; Padding-Inline: 3EM; Justify-Content: Space-Between; Font-Size: Smaller }
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
#BNS>div>section[data-slide=in]{ Animation: In-From-End 1S Both }
#BNS>div>section[data-direction=reverse][data-slide=in]{ Animation: In-From-Start 1S Both }
#BNS>div>section[data-slide=out]{ Animation: Out-To-Start 1S Both }
#BNS>div>section[data-direction=reverse][data-slide=out]{ Animation: Out-To-End 1S Both }
h1{ Margin-Block: 0; Color: #222; Font-Size: XX-Large; Font-Family: Sans-Serif; Line-Height: 1; Text-Align: Center }
nav>h1{ Margin-Block: 0 .5REM; Margin-Inline: Auto; Border-Width: Thin; Border-Block-Style: Dotted Solid; Border-Block-Color: #777 #111; Border-Inline-Style: Dashed; Border-Inline-Color: #333; Padding-Block: .3125EM; Padding-Inline: 1EM; Max-Inline-Size: Max-Content; Font-Size: X-Large }
p{ Margin-Block: 0; Margin-Inline: Auto; Text-Align: Justify; Text-Align-Last: Center }
p:Not(:First-Child){ Margin-Block: .625EM 0 }
ol{ Margin: 0; Padding: 0; List-Style-Type: None }
ol ol{ Margin-Inline: 1EM 0 }
dl{ Margin-Block: 1EM }
dl:First-Child{ Margin-Block-Start: 0 }
dt{ Font-Weight: Bold }
dd{ Display: List-Item; List-Style-Type: Square; Margin-Inline: 1EM 0 }
button[onclick="i(event)"]{ Margin-Inline: 0; Border-Color: #777; Border-Width: Thin; Border-Block-Style: None Dotted; Border-Inline-Style: None; Padding: 0; Vertical-Align: Super; Color: #333; Background: Transparent; Font: Smaller; Cursor: Pointer }
*:Any-Link{ Color: #333 }
*:Any-Link:Hover,button[onclick="i(event)"]:Hover{ Color: #777 }
a{ White-Space: Normal }
a[data-expanded]+small{ Display: Inline-Block; Vertical-Align: Sub; Font-Size: Smaller; Line-Height: 1 }
a[data-expanded]+small::before{ Content: "[" }
a[data-expanded]+small::after{ Content: "]" }
			</html:style>
			<html:script>
const u = s => ({
	madsrdf: `http://www.loc.gov/mads/rdf/v1#`,
	rdf: `http://www.w3.org/1999/02/22-rdf-syntax-ns#`,
	rdfs: `http://www.w3.org/2000/01/rdf-schema#`,
	skos: `http://www.w3.org/2004/02/skos/core#`,
	xml: `http://www.w3.org/XML/1998/namespace` }[s])
const o = ( { target: e } ) => {
	e.hidden = e.dataset.slide == `out`
	e.removeAttribute `data-slide`
	e.removeAttribute `data-direction`
	e.removeEventListener(`animationend`, o) }
const i = ( { target: e } ) => {
	const a = e.previousElementSibling
	if ( a.origin != location.origin || a.pathname != location.pathname || a.search != location.search ) fetch(a.href.indexOf `http://www.wikidata.org/entity/` == 0 ? `https://www.wikidata.org/wiki/Special:EntityData/${ a.href.substring(`http://www.wikidata.org/entity/`.length) }` : a.href, {
		headers: { Accept: `application/rdf+xml` },
		method: `GET`,
		mode: `cors`,
		redirect: `follow`,
		referrerPolicy: `no-referrer` }).then(r => r.text().then(t => {
			const d = (new DOMParser).parseFromString(t, `text/xml`)
			const n = d.evaluate(`//*[@rdf:about='${a.href}']/*[self::madsrdf:authoritativeLabel|self::skos:prefLabel|self::rdfs:label][@xml:lang='en' or starts-with(@xml:lang, 'en-')]`, d, u, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue ?? d.evaluate(`//*[@rdf:about='${a.href}']/*[self::madsrdf:authoritativeLabel|self::skos:prefLabel|self::rdfs:label]`, d, u, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue
			if ( n ) {
				const c = document.createElementNS(`http://www.w3.org/1999/xhtml`, `cite`)
				const s = document.createElementNS(`http://www.w3.org/1999/xhtml`, `small`)
				if ( n.hasAttributeNS(`http://www.w3.org/XML/1998/namespace`, `lang`) ) c.setAttribute(`lang`, n.getAttributeNS(`http://www.w3.org/XML/1998/namespace`, `lang`))
				c.textContent = n.textContent
				for ( const h of a.childNodes ) { s.appendChild(h) }
				a.appendChild(c)
				e.parentNode.replaceChild(s, e)
				a.dataset.expanded = "" } })).catch(( ) => e.parentNode.removeChild(e))
	else {
		let n = document.getElementById(a.hash.substring(1))?.querySelector?.(`h1`)
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
	let e = document.getElementById(location.hash.substring(1))
	if ( !e || !e.matches `#BNS>div>section` ) e = document.querySelector `#BNS>div>section`
	for ( const p of document.querySelectorAll `#BNS>div>section` ) {
		p.hidden = p != e
		if ( p == e )
			for ( f of e.querySelectorAll `iframe[data-src],audio[data-src],video[data-src],img[data-src]` ) {
				const n = f.cloneNode()
				n.src = f.dataset.src
				n.removeAttribute `data-src`
				f.parentNode.replaceChild(n, f) } } })
window.addEventListener(`hashchange`, v => {
	if ( 1 >= location.hash.length ) return
	let m = false
	let n = location.hash.substring(1)
	let c = document.querySelector `#BNS>div>section:Not([hidden])`
	let e = document.getElementById(n)
	if ( !e.matches `#BNS>div>section` ) return
	for ( const p of document.querySelectorAll `#BNS>div>section` ) {
		if ( p == e ) {
			m = true
			if ( e.hidden || p.dataset.slide == `out` ) {
				for ( f of e.querySelectorAll `iframe[data-src],audio[data-src],video[data-src],img[data-src]` ) {
					const n = f.cloneNode()
					n.src = f.dataset.src
					n.removeAttribute `data-src`
					f.parentNode.replaceChild(n, f) }
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
	const e = document.querySelector `#BNS>div>section:Not([hidden])`
	if ( v.key == `ArrowRight` || v.key == `ArrowLeft` ) v.preventDefault()
	if ( document.querySelector `#BNS>div>section[data-slide]` || !e ) return
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
					<html:button title="Attempt to fetch link metadata." onclick="i(event)">[?]</html:button>
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
							<value-of select=".//bns:Corpus/bns:fullTitle[1]"/>
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
										<value-of select="bns:identifier"/>
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
								<value-of select="number(bns:index)"/>
							</otherwise>
						</choose>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;'">
						<value-of select="bns:index"/>
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
								<value-of select="number(bns:index)"/>
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
								<value-of select="number(bns:index)"/>
							</otherwise>
						</choose>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;'">
						<value-of select="bns:index"/>
					</when>
					<otherwise>
						<text>“</text>
						<value-of select="bns:index"/>
						<text>”</text>
					</otherwise>
				</choose>
			</when>
			<when test="self::bns:Part">
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<choose>
							<when test="bns:index>49">
								<value-of select="number(bns:index)"/>
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
								<value-of select="number(bns:index)"/>
							</otherwise>
						</choose>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;'">
						<value-of select="bns:index"/>
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
								<value-of select="number(bns:index)"/>
							</otherwise>
						</choose>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;'">
						<value-of select="bns:index"/>
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
						<if test="10>$index">0</if>
						<value-of select="number(bns:index)"/>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;'">
						<value-of select="bns:index"/>
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
						<value-of select="number(bns:index)"/>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;'">
						<value-of select="bns:index"/>
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
								<value-of select="number(bns:index)"/>
							</otherwise>
						</choose>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;'">
						<value-of select="bns:index"/>
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
						<value-of select="number(bns:index)"/>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;'">
						<value-of select="bns:index"/>
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
						<value-of select="number(bns:index)"/>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;'">
						<value-of select="bns:index"/>
					</when>
					<otherwise>
						<html:sup>
							<value-of select="bns:index"/>
						</html:sup>
					</otherwise>
				</choose>
			</when>
			<when test="self::bns:Draft">
				<for-each select="ancestor::bns:Version[1]">
					<call-template name="formatted"/>
				</for-each>
				<text>d</text>
				<choose>
					<when test="bns:index/@rdf:datatype='&integer;'">
						<value-of select="number(bns:index)"/>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;'">
						<value-of select="bns:index"/>
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
						<value-of select="number(bns:index)"/>
					</when>
					<when test="bns:index/@rdf:datatype='&gYearMonth;'">
						<value-of select="bns:index"/>
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
			<for-each select="bns:fullTitle">
				<html:h1 lang="{@xml:lang}">
					<value-of select="."/>
				</html:h1>
			</for-each>
			<choose>
				<when test="self::bns:Author">
					<html:h2 lang="{@xml:lang}">
						<html:abbr title="Branching Notational System">BNS</html:abbr>
						<text>: </text>
						<value-of select="bns:fullTitle|bns:abbreviatedTitle"/>
					</html:h2>
				</when>
				<otherwise>
					<for-each select="bns:abbreviatedTitle|dc:alternate">
						<html:h2 lang="{@xml:lang}">
							<value-of select="."/>
						</html:h2>
					</for-each>
					<if test="not(bns:abbreviatedTitle|dc:alternate)">
						<html:h2 lang="{@xml:lang}">
							<choose>
								<when test="self::bns:Project">
									<value-of select="bns:identifier"/>
								</when>
								<otherwise>
									<call-template name="formatted"/>
								</otherwise>
							</choose>
						</html:h2>
					</if>
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
				<otherwise>
					<value-of select="name(.)"/>
					<text> </text>
					<call-template name="formatted"/>
				</otherwise>
			</choose>
		</html:span>
	</template>
	<template name="cover">
		<variable name="covers" select="bns:hasCover[@rdf:resource|@rdf:parseType='Resource']|bns:hasCover[not(@rdf:parseType='Resource')]/*"/>
		<if test="$covers">
			<html:figure>
				<for-each select="$covers[1]">
					<choose>
						<when test="bns:contents[@rdf:parseType='Literal']">
							<apply-templates select="bns:contents/*"/>
						</when>
						<when test="self::dcmitype:StillImage">
							<html:img alt="{dc:abstract/@contents}" data-src="{@rdf:about}"/>
						</when>
						<when test="self::dcmitype:MovingImage">
							<html:video controls="" data-src="{@rdf:about}">
								<if test="bns:hasCover/@rdf:about|bns:hasCover/*/@rdf:about">
									<attribute name="poster">
										<value-of select="bns:hasCover/@rdf:resource|bns:hasCover/*/@rdf:about"/>
									</attribute>
								</if>
							</html:video>
						</when>
						<when test="self::dcmitype:Sound">
							<html:audio controls="" data-src="{@rdf:about}"/>
						</when>
						<otherwise>
							<html:iframe data-src="{@rdf:resource|@rdf:about}"/>
						</otherwise>
					</choose>
				</for-each>
			</html:figure>
		</if>
	</template>
	<template name="navigate">
		<html:nav>
			<if test="preceding-sibling::bns:*">
				<html:a data-nav="prev">
					<attribute name="href">
						<text>#</text>
						<for-each select="preceding-sibling::*[1]">
							<call-template name="shorten">
								<with-param name="uri" select="@rdf:about"/>
							</call-template>
						</for-each>
					</attribute>
					<text>←</text>
				</html:a>
			</if>
			<if test="parent::bns:hasProjects/..|parent::bns:includes/..">
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
						<for-each select="*[self::bns:hasProjects|self::bns:includes]/*[1]">
							<call-template name="shorten">
								<with-param name="uri" select="@rdf:about"/>
							</call-template>
						</for-each>
					</attribute>
				<text>↓</text>
				</html:a>
			</if>
			<if test="following-sibling::*">
				<html:a data-nav="next">
					<attribute name="href">
						<text>#</text>
						<for-each select="following-sibling::*[1]">
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
	<template match="*[bns:hasProjects]">
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
			<call-template name="cover"/>
			<html:section>
				<html:div>
					<apply-templates select="dc:abstract"/>
					<call-template name="metadata"/>
				</html:div>
			</html:section>
			<call-template name="footer"/>
		</html:section>
		<apply-templates select="bns:hasProjects/*"/>
	</template>
	<template match="bns:Author">
		<call-template name="name"/>
	</template>
	<template match="*[parent::bns:includes|parent::bns:hasProjects]">
		<html:section hidden="">
			<attribute name="id">
				<call-template name="shorten">
					<with-param name="uri" select="@rdf:about"/>
				</call-template>
			</attribute>
			<apply-templates select="." mode="header"/>
			<choose>
				<when test="bns:isPublishedAs/*[@rdf:about]">
					<html:div>
						<for-each select="bns:isPublishedAs/*[@rdf:about][1]">
							<choose>
								<when test="self::dcmitype:StillImage">
									<html:img alt="{dc:abstract/@contents}" data-src="{@rdf:about}"/>
								</when>
								<when test="self::dcmitype:MovingImage">
									<html:video controls="" data-src="{@rdf:about}"/>
								</when>
								<when test="self::dcmitype:Sound">
									<html:audio controls="" data-src="{@rdf:about}"/>
								</when>
								<otherwise>
									<html:iframe data-src="{@rdf:about}"/>
								</otherwise>
							</choose>
						</for-each>
					</html:div>
				</when>
				<when test="bns:isPublishedAs/@rdf:resource">
					<html:div>
						<html:iframe data-src="{bns:isPublishedAs/@rdf:resource}"/>
					</html:div>
				</when>
				<otherwise>
					<call-template name="cover"/>
					<html:section>
						<html:div>
							<apply-templates select="dc:abstract"/>
							<call-template name="metadata"/>
						</html:div>
						<if test="bns:includes">
							<html:nav>
								<html:h1 lang="en">Includes</html:h1>
								<html:ol>
									<apply-templates select="bns:includes/*" mode="list"/>
								</html:ol>
							</html:nav>
						</if>
					</html:section>
				</otherwise>
			</choose>
			<call-template name="footer"/>
		</html:section>
		<apply-templates select="bns:includes/*"/>
	</template>
	<template match="*[parent::bns:includes|parent::bns:hasProjects]" mode="header">
		<html:header>
			<html:p>
				<for-each select="ancestor::*[parent::bns:includes|parent::bns:hasProjects]">
					<choose>
						<when test="self::bns:Version[descendant::bns:Draft]"/>
						<otherwise>
							<call-template name="namedformat"/>
							<text> :: </text>
						</otherwise>
					</choose>
				</for-each>
				<choose>
					<when test="self::bns:Version[child::bns:Draft]"/>
					<otherwise>
						<call-template name="namedformat"/>
					</otherwise>
				</choose>
			</html:p>
			<call-template name="name"/>
			<call-template name="navigate"/>
		</html:header>
	</template>
	<template match="*[parent::bns:includes|parent::bns:hasProjects]" mode="list">
		<html:li value="{bns:index}">
			<html:a>
				<attribute name="href">
					<text>#</text>
					<call-template name="shorten">
						<with-param name="uri" select="@rdf:about"/>
					</call-template>
				</attribute>
				<html:strong>
					<call-template name="namedformat"/>
					<if test="bns:fullTitle">
						<text>:</text>
					</if>
				</html:strong>
				<for-each select="bns:fullTitle">
					<text> </text>
					<html:cite>
						<value-of select="."/>
					</html:cite>
				</for-each>
			</html:a>
			<if test="bns:includes">
				<html:ol>
					<apply-templates select="bns:includes/*" mode="list"/>
				</html:ol>
			</if>
		</html:li>
	</template>
</stylesheet>
