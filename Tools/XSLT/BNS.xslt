<stylesheet
	id="transform"
	version="1.0"
	xmlns="http://www.w3.org/1999/XSL/Transform"
	xmlns:bns="https://go.KIBI.family/Ontologies/BNS/#"
	xmlns:dc="http://purl.org/dc/terms/"
	xmlns:dcmitype="http://purl.org/dc/dcmitype/"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:svg="http://www.w3.org/2000/svg"
>
	<variable name="rdf" select="//html:link[@rel='alternate'][@type='application/rdf+xml']/@href[1]"/>
	<variable name="prefix" select="substring-before(//html:html/@prefix, ': ')"/>
	<variable name="expansion" select="substring-after(//html:html/@prefix, ': ')"/>
	<template name="shorten">
		<param name="uri"/>
		<if test="starts-with($uri, $expansion)">
			<value-of select="concat($prefix, ':', substring-after($uri, $expansion))"/>
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
			<apply-templates/>
			<html:style>
html{ Position: Relative; Margin: Auto; Padding: 0; Background: Black; Inline-Size: 54REM; Max-Inline-Size: 100%; Color: #333; Font-Family: Serif; Line-Height: 1.25 }
body{ Margin-Block: 0 2REM; Margin-Inline: 0; Border-End-Start-Radius: 4REM; Border-End-End-Radius: 4REM; Padding-Block: 1REM; Padding-Inline: 5REM; Background: White }
#BNS{ Writing-Mode: Horizontal-TB; Display: Flex; Flex-Direction: Column; Min-Block-Size: Calc(100VH - 4REM) }
#BNS>header{ Flex: None }
#BNS>header>h1{ Display: Block; Margin-Block: .5REM; Color: #111; Font-Size: XXX-Large; Font-Family: Sans-Serif; Text-Align: Center }
#BNS>header>nav{ Font-Size: Medium; Margin-Block: 1REM; Color: #333; Font-Family: Sans-Serif; Line-Height: 1.2; Text-Align: Justify; Text-Align-Last: Center }
#BNS>header>nav>ol,#BNS>header>nav>ol>li{ Display: Inline; Margin: 0; Padding: 0 }
#BNS>header>nav>ol>li+li::before{ Content: " | " }
#BNS>header>nav a{ Text-Decoration: None }
#BNS>div{ Position: Relative; Flex: Auto; Margin-Block: 0 -1REM; Margin-Inline: -5REM; Min-Block-Size: Calc(60VH - 2REM); Overflow: Hidden }
#BNS>div>span{ Display: Block; Position: Absolute; Margin: Auto; Inset-Block: 0; Inset-Inline: 0; Block-Size: 1EM; Inline-Size: Max-Content; Line-Height: 1; White-Space: Pre }
#BNS>div>section{ Display: Grid; Position: Absolute; Box-Sizing: Border-Box; Inset-Block: 0; Inset-Inline: 0 Auto; Inline-Size: 100%; Border: .25REM Black Solid; Border-Radius: 4REM; Padding: 2REM; Gap: 1REM 2REM; Grid-Template-Rows: Min-Content 1FR Min-Content; Grid-Template-Columns: 1FR 23EM; Overflow: Hidden; Background: #EEE }
#BNS>div>section[hidden]{ Display: None }
#BNS>div>section>header,#BNS>div>section>header+section,#BNS>div>section>div,#BNS>div>section>footer{ Grid-Column: 1 / Span 2 }
#BNS>div>section>header{ Grid-Row: 1 / Span 1; Margin-Block: -1REM 0; Margin-Inline: -2REM; Border-Block-End: Thin Black Solid; Padding-Block: 0 1REM; Padding-Inline: 2REM; Text-Align: Center }
#BNS>div>section>header>p{ Margin-Block: 0 .3125EM; Font-Variant-Caps: Small-Caps; Text-Align: Center }
#BNS>div>section>header>nav{ Display: Grid; Grid-Auto-Flow: Column; Grid-Auto-Columns: 1FR; Margin-Block: .3125EM 0; Margin-Inline: Auto; Max-Inline-Size: Max-Content; Gap: .5REM; Text-Align: Center }
#BNS>div>section>header>nav>a{ Text-Decoration: None }
#BNS>div>section>header>nav>a[data-nav=prev]{ Grid-Column: 1 / Span 1 }
#BNS>div>section>header>nav>a[data-nav=parent]{ Grid-Column: 2 / Span 1 }
#BNS>div>section>header>nav>a[data-nav=child]{ Grid-Column: 1 / Span 1 }
#BNS>div>section>header>nav>a+a[data-nav=child]{ Grid-Column: 4 / Span 1 }
#BNS>div>section>header>nav>a[data-nav=next]{ Grid-Column: 2 / Span 1 }
#BNS>div>section>header>nav>a:Not([data-nav=child])~a[data-nav=next]{ Grid-Column: 5 / Span 1 }
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
*:Any-Link{ Color: Inherit }
*:Any-Link:Hover{ Color: #777 }
			</html:style>
			<html:script>
const o = ( { target: e } ) => {
	e.hidden = e.dataset.slide == `out`
	e.removeAttribute `data-slide`
	e.removeAttribute `data-direction`
	e.removeEventListener(`animationend`, o) }
window.addEventListener(`load`, ( ) => {
	const d = document.querySelector `#BNS>div`
	d.removeChild(d.firstElementChild)
	let e = document.getElementById(location.hash.substring(1))
	if ( !e || !e.matches `#BNS>div>section` ) e = document.querySelector `#BNS>div>section`
	for ( const p of document.querySelectorAll `#BNS>div>section` ) { p.hidden = p != e } })
window.addEventListener(`hashchange`, v => {
	if ( 1 >= location.hash.length ) return
	let m = false
	let n = location.hash.substring(1)
	let c = document.querySelector `#BNS>div>section:Not([hidden])`
	let e = null
	while ( !(e = document.getElementById(n)) ) {
		if ( n.includes `:` ) n = n.substring(0, n.indexOf `:` )
		else return }
	if ( !e.matches `#BNS>div>section` ) return
	for ( const p of document.querySelectorAll `#BNS>div>section` ) {
		if ( p == e ) {
			m = true
			if ( e.hidden || p.dataset.slide == `out` ) {
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
		</copy>
	</template>
	<template match="html:title">
		<copy>
			<value-of select="document($rdf)//bns:Corpus/bns:fullTitle"/>
		</copy>
	</template>
	<template match="html:a[starts-with(@href, $expansion)]">
		<copy>
			<attribute name="href">
				<value-of select="concat('#', $prefix, ':', substring-after(@href, $expansion))"/>
			</attribute>
			<for-each select="@*[not(name(.)='href')]">
				<copy/>
			</for-each>
			<apply-templates/>
		</copy>
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
					<html:span>Loading...</html:span>
					<apply-templates/>
				</html:div>
			</for-each>
		</copy>
	</template>
	<template name="name">
		<if test="bns:fullTitle">
			<html:hgroup>
				<for-each select="bns:fullTitle">
					<html:h1 lang="{@xml:lang}">
						<value-of select="."/>
					</html:h1>
				</for-each>
			</html:hgroup>
		</if>
	</template>
	<template name="cover">
		<variable name="covers" select="bns:hasCover[@rdf:parseType='Resource']|bns:hasCover[not(@rdf:parseType='Resource')]/*"/>
		<if test="$covers">
			<html:figure>
				<for-each select="$covers[1]">
					<choose>
						<when test="bns:contents[@rdf:parseType='Literal']">
							<apply-templates select="bns:contents/*"/>
						</when>
						<when test="self::dcmitype:StillImage">
							<html:img alt="{dc:abstract/@contents}" src="{@rdf:about}"/>
						</when>
						<when test="self::dcmitype:MovingImage">
							<html:video controls="" src="{@rdf:about}"/>
						</when>
						<when test="self::dcmitype:Sound">
							<html:audio controls="" src="{@rdf:about}"/>
						</when>
						<otherwise>
							<html:iframe src="{@rdf:about}"/>
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
		<html:footer>
			<if test="starts-with(@rdf:about, $expansion)">
				<html:code>
					<call-template name="shorten">
						<with-param name="uri" select="@rdf:about"/>
					</call-template>
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
	<template match="bns:Corpus">
		<html:section hidden="">
			<attribute name="id">
				<call-template name="shorten">
					<with-param name="uri" select="@rdf:about"/>
				</call-template>
			</attribute>
			<html:header>
				<html:p>Corpus of</html:p>
				<apply-templates select="bns:forAuthor/*"/>
				<call-template name="navigate"/>
			</html:header>
			<call-template name="cover"/>
			<html:section>
				<html:div>
					<apply-templates select="dc:abstract"/>
				</html:div>
			</html:section>
			<call-template name="footer"/>
		</html:section>
		<apply-templates select="bns:hasProjects/*"/>
	</template>
	<template match="bns:Author">
		<call-template name="name"/>
	</template>
	<template match="bns:Project">
		<html:section hidden="">
			<attribute name="id">
				<call-template name="shorten">
					<with-param name="uri" select="@rdf:about"/>
				</call-template>
			</attribute>
			<html:header>
				<html:p>
					<text>Project </text>
					<value-of select="count(preceding-sibling::*)"/>
				</html:p>
				<call-template name="name"/>
				<call-template name="navigate"/>
			</html:header>
			<call-template name="cover"/>
			<html:section>
				<html:div>
					<apply-templates select="dc:abstract"/>
				</html:div>
				<if test="bns:includes">
					<html:nav>
						<html:h1>Volumes</html:h1>
						<html:ol>
							<apply-templates select="bns:includes/*" mode="list"/>
						</html:ol>
					</html:nav>
				</if>
			</html:section>
			<call-template name="footer"/>
		</html:section>
		<apply-templates select="bns:includes/*"/>
	</template>
	<template match="bns:Project" mode="bnspath">
		<apply-templates select="ancestor::bns:Corpus" mode="bnspath"/>
		<text>:</text>
		<value-of select="count(preceding-sibling::*)"/>
	</template>
	<template match="bns:Volume">
		<html:section hidden="">
			<attribute name="id">
				<call-template name="shorten">
					<with-param name="uri" select="@rdf:about"/>
				</call-template>
			</attribute>
			<html:header>
				<html:p>
					<text>Project </text>
					<value-of select="count(ancestor::bns:Project/preceding-sibling::*)"/>
					<text>, Volume </text>
					<value-of select="bns:index"/>
				</html:p>
				<call-template name="name"/>
				<call-template name="navigate"/>
			</html:header>
			<call-template name="cover"/>
			<html:section>
				<html:div>
					<apply-templates select="dc:abstract"/>
				</html:div>
				<if test="bns:includes">
					<html:nav>
						<html:h1>Versions</html:h1>
						<html:ol>
							<apply-templates select="bns:includes/*" mode="list"/>
						</html:ol>
					</html:nav>
				</if>
			</html:section>
			<call-template name="footer"/>
		</html:section>
		<apply-templates select="bns:includes/*"/>
	</template>
	<template match="bns:Volume" mode="list">
		<html:li value="{bns:index}">
			<html:a>
				<attribute name="href">
					<text>#</text>
					<call-template name="shorten">
						<with-param name="uri" select="@rdf:about"/>
					</call-template>
				</attribute>
				<html:strong>
					<text>Volume </text>
					<value-of select="bns:index"/>
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
	<template match="bns:Version">
		<html:section hidden="">
			<attribute name="id">
				<call-template name="shorten">
					<with-param name="uri" select="@rdf:about"/>
				</call-template>
			</attribute>
			<html:header>
				<html:p>
					<text>Project </text>
					<value-of select="count(ancestor::bns:Project/preceding-sibling::*)"/>
					<text>, Volume </text>
					<value-of select="ancestor::bns:Volume/bns:index"/>
					<text>, Version </text>
					<value-of select="bns:index"/>
				</html:p>
				<call-template name="name"/>
				<call-template name="navigate"/>
			</html:header>
			<call-template name="cover"/>
			<html:section>
				<html:div>
					<apply-templates select="dc:abstract"/>
				</html:div>
				<if test="bns:includes">
					<html:nav>
						<html:h1>Drafts</html:h1>
						<html:ol>
							<apply-templates select="bns:includes/*" mode="list"/>
						</html:ol>
					</html:nav>
				</if>
			</html:section>
			<call-template name="footer"/>
		</html:section>
		<apply-templates select="bns:includes/*"/>
	</template>
	<template match="bns:Version" mode="list">
		<html:li value="{bns:index}">
			<html:a>
				<attribute name="href">
					<text>#</text>
					<call-template name="shorten">
						<with-param name="uri" select="@rdf:about"/>
					</call-template>
				</attribute>
				<html:strong>
					<text>Version </text>
					<value-of select="bns:index"/>
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
	<template match="bns:Draft">
		<html:section hidden="">
			<attribute name="id">
				<call-template name="shorten">
					<with-param name="uri" select="@rdf:about"/>
				</call-template>
			</attribute>
			<html:header>
				<html:p>
					<text>Project </text>
					<value-of select="count(ancestor::bns:Project/preceding-sibling::*)"/>
					<text>, Volume </text>
					<value-of select="ancestor::bns:Volume/bns:index"/>
					<text>, Version </text>
					<value-of select="ancestor::bns:Version/bns:index"/>
					<text>, Draft </text>
					<value-of select="bns:index"/>
				</html:p>
				<call-template name="name"/>
				<call-template name="navigate"/>
			</html:header>
			<choose>
				<when test="bns:isPublishedAs/*[@rdf:about]">
					<html:div>
						<for-each select="bns:isPublishedAs/*[@rdf:about][1]">
							<choose>
								<when test="self::dcmitype:StillImage">
									<html:img alt="{dc:abstract/@contents}" src="{@rdf:about}"/>
								</when>
								<when test="self::dcmitype:MovingImage">
									<html:video controls="" src="{@rdf:about}"/>
								</when>
								<when test="self::dcmitype:Sound">
									<html:audio controls="" src="{@rdf:about}"/>
								</when>
								<otherwise>
									<html:iframe src="{@rdf:about}"/>
								</otherwise>
							</choose>
						</for-each>
					</html:div>
				</when>
				<when test="bns:isPublishedAs/@rdf:resource">
					<html:div>
						<html:iframe src="{bns:isPublishedAs/@rdf:resource}"/>
					</html:div>
				</when>
				<otherwise>
					<call-template name="cover"/>
					<html:section>
						<html:div>
							<apply-templates select="dc:abstract"/>
						</html:div>
					</html:section>
				</otherwise>
			</choose>
			<call-template name="footer"/>
		</html:section>
	</template>
	<template match="bns:Draft" mode="list">
		<html:li value="{bns:index}">
			<html:a>
				<attribute name="href">
					<text>#</text>
					<call-template name="shorten">
						<with-param name="uri" select="@rdf:about"/>
					</call-template>
				</attribute>
				<html:strong>
					<text>Draft </text>
					<value-of select="bns:index"/>
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
		</html:li>
	</template>
</stylesheet>
