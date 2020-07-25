<!--
KIBI { TEI Lite → XHTML } XSL Transformation (KiT2X.xslt)

☞ Usage:

Requires both XSLT 1.0 and EXSLT Common support.
CSS features require at least Firefox 76.
Stick the following at the beginning of your XML file:

```
<?xml-stylesheet type="text/xsl" href="/path/to/KiT2X.xslt"?>
```

At time of writing, this file is available at `https://go.KIBI.family/Tools/XSLT/KiT2X.xslt`.
But you should self-host it if possible, for the sake of resilience.

☞ Notes:

†	Valid TEI Lite should produce valid HTML in ※most※ cases.
	There are doubtless edge‐cases.
	You ※can※ nest `<p>` elements in places allowed by TEI; for example, `<p><note><p>note paragraphs</p></note></p>`.
	The nested `<p>`s will be converted to HTML `<span>`s.

†	HTML is passed through unmodified; you can use HTML directly in your TEI document (although this is no longer TEI Lite).

†	Due to limitations in XSLT 1.0, if multiple pointers are provided as the `target` of an element, only the first will be processed.
	Use multiple elements when you need to specify multiple pointers.

†	Use `<pc>` to mark punctuation when multiple characters long.

†	TEI `rend` is converted to HTML `class`.
	A few `rend` values are predefined:

	‡	Use `rend="indent"` to indent a line of verse, or force indentation on a paragraph.
		Adjacent paragraphs will automatically be indented, but paragraphs will not be indented if any element comes between them.

	‡	Use `rend="unindent"` to prevent indentation, as above.

	‡	Use `rend="terminal"` on a `<pc>` element to indicate sentence‐terminal punctuation.
		Periods which are not element‐final and followed by a space will automatically be wrapped in a `<pc rend="terminal">` element; wrap non‐terminal periods in an ordinary `<pc>` element to avert this.
		For spans of text (parentheticals; quotes) which function as a sentence in the surrounding context, use an empty `<pc rend="terminal"/>` to indicate separation from the text which follows.

	‡	Use `rend="preserve"` to preserve whitespace.
		Alternatively, use `xml:space="preserve"` (which produces equivalent HTML).

†	Use `<divGen>` for automatic generation of navigational elements.
	Inside of a `<body>`, `<divGen type="toc">` will produce a slightly abridged table of contents, excluding elements from outside of the ancestor `<body>` element.
	Use `<divGen type="index" subtype="NAME">` to generate a named index (i.e., one whose index entries specify `indexName="NAME"`).

†	An `<?xml-stylesheet?>` instruction with a `type` of `"text/css"` will be converted into an HTML `<style>` element and placed in the `<head>` of the resulting HTML document.
	Use this to add custom styling without breaking TEI Lite conformance.

†	Alternatively, the contents of the `<xenoData>` element (not TEI Lite) will be inserted directly into the `<head>` of the resulting HTML document.
	You can use this to insert additional metadata or styling.

☞ Disclaimer:

To the extent possible under law, KIBI Gô has waived all copyright and related or neighboring rights to this file via a CC0 1.0 Universal Public Domain Dedication.
See `https://creativecommons.org/publicdomain/zero/1.0/` for more information.
-->
<stylesheet
	version="1.0"
	xmlns="http://www.w3.org/1999/XSL/Transform"
	xmlns:exsl="http://exslt.org/common"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:tei="http://www.tei-c.org/ns/1.0">
	<!-- Allow XHTML to be passed straight through -->
	<template match="html:*">
		<copy>
			<for-each select="@*">
				<copy/>
			</for-each>
			<apply-templates/>
		</copy>
	</template>
	<!-- Text‐Level Processing -->
	<template match="text()">
		<choose>
			<when test=".[starts-with(., ' ')]/preceding-sibling::*[1][self::tei:q]">
				<variable name="sp">
					<tei:seg rend="space">
						<text> </text>
					</tei:seg>
				</variable>
				<apply-templates select="exsl:node-set($sp)"/>
				<call-template name="process-text">
					<with-param name="text">
						<value-of select="substring-after(., ' ')"/>
					</with-param>
				</call-template>
			</when>
			<when test="ancestor-or-self::tei:abbr or ancestor-or-self::tei:code">
				<value-of select="."/>
			</when>
			<otherwise>
				<call-template name="process-text">
					<with-param name="text">
						<value-of select="."/>
					</with-param>
				</call-template>
			</otherwise>
		</choose>
	</template>
	<!-- Named Templates -->
	<template name="process-text">
		<param name="text"/>
		<choose>
			<when test="contains($text, '. ')">
				<variable name="term">
					<tei:pc rend="terminal">.</tei:pc>
				</variable>
				<call-template name="process-text">
					<with-param name="text">
						<value-of select="substring-before($text, '. ')"/>
					</with-param>
				</call-template>
				<apply-templates select="exsl:node-set($term)"/>
				<text> </text>
				<call-template name="process-text">
					<with-param name="text">
						<value-of select="substring-after($text, '. ')"/>
					</with-param>
				</call-template>
			</when>
			<otherwise>
				<value-of select="$text"/>
			</otherwise>
		</choose>
	</template>
	<template name="generate-toc">
		<param name="divs" select="ancestor::tei:TEI//tei:div[not(ancestor::tei:div or ancestor::tei:divGen or ancestor::tei:body[tei:head])]|ancestor::tei:TEI//tei:divGen[not(ancestor::tei:div or ancestor::tei:divGen or ancestor::tei:body[tei:head])]|ancestor::tei:TEI//tei:body[tei:head]"/>
		<for-each select="$divs">
			<if test="tei:head or tei:div or tei:divGen">
				<tei:item>
					<if test="tei:head">
						<apply-templates select="." mode="list"/>
					</if>
					<if test="tei:div or tei:divGen">
						<tei:list>
							<call-template name="generate-toc">
								<with-param name="divs" select="tei:div|tei:divGen"/>
							</call-template>
						</tei:list>
					</if>
				</tei:item>
			</if>
		</for-each>
	</template>
	<template name="generate-index">
		<param name="indices" select="//*[not(self::tei:index)]/tei:index"/>
		<for-each select="$indices">
			<sort select="tei:term"/>
			<if test="count(.|$indices[tei:term=current()/tei:term][1])=1">
				<tei:label>
					<copy-of select="tei:term"/>
				</tei:label>
				<tei:item>
					<tei:list type="index">
						<for-each select="$indices[tei:term=current()/tei:term][not(tei:index)]">
							<tei:item>
								<tei:ref>
									<attribute name="target">
										<choose>
											<when test="@xml:id">
												<value-of select="concat('#', @xml:id)"/>
											</when>
											<otherwise>
												<value-of select="concat('#TEI.index.', generate-id(.))"/>
											</otherwise>
										</choose>
									</attribute>
									<choose>
										<when test="ancestor-or-self::*/preceding-sibling::*/descendant-or-self::tei:pb[@n] or ancestor::tei:p[@n] or ancestor::tei:lg[@n] or ancestor::tei:div[@n]">
											<if test="ancestor-or-self::*/preceding-sibling::*/descendant-or-self::tei:pb[@n]">
												<value-of select="ancestor-or-self::*/preceding-sibling::*[descendant-or-self::tei:pb[@n]][1]/descendant-or-self::tei:pb[@n][last()]/@n"/>
												<if test="ancestor::tei:p[@n] or ancestor::tei:lg[@n] or ancestor::tei:div[@n]">
													<text> </text>
												</if>
											</if>
											<if test="ancestor::tei:div[@n]">
												<value-of select="concat('§', ancestor::tei:div[@n][1]/@n)"/>
												<if test="ancestor::tei:p[@n] or ancestor::tei:lg[@n]">
													<text> </text>
												</if>
											</if>
											<if test="ancestor::tei:p[@n] or ancestor::tei:lg[@n]">
												<value-of select="concat('¶', ancestor::*[self::tei:p or self::tei:lg][@n][1]/@n)"/>
											</if>
										</when>
										<otherwise>⁜</otherwise>
									</choose>
								</tei:ref>
							</tei:item>
						</for-each>
					</tei:list>
					<if test="$indices[tei:term=current()/tei:term]/tei:index">
						<tei:list type="gloss">
							<call-template name="generate-index">
								<with-param name="indices" select="$indices[tei:term=current()/tei:term]/tei:index"/>
							</call-template>
						</tei:list>
					</if>
				</tei:item>
			</if>
		</for-each>
	</template>
	<template name="handle-docStatus">
		<if test="@status">
			<attribute name="data--t-e-i_status">
				<value-of select="@status"/>
			</attribute>
		</if>
	</template>
	<template name="handle-editLike">
		<if test="@evidence">
			<attribute name="data--t-e-i_evidence">
				<value-of select="@evidence"/>
			</attribute>
		</if>
	</template>
	<template name="handle-fragmentable">
		<if test="@part">
			<attribute name="data--t-e-i_part">
				<value-of select="@part"/>
			</attribute>
		</if>
	</template>
	<template name="handle-id">
		<param name="force"/>
		<if test="@xml:id or $force">
			<attribute name="id">
				<choose>
					<when test="@xml:id">
						<value-of select="@xml:id"/>
					</when>
					<otherwise>
						<value-of select="concat('TEI.', $force, '.', generate-id(.))"/>
					</otherwise>
				</choose>
			</attribute>
		</if>
	</template>
	<template name="handle-placement">
		<if test="@place">
			<attribute name="data--t-e-i_place">
				<value-of select="@place"/>
			</attribute>
		</if>
	</template>
	<template name="handle-transcriptional">
		<if test="@status">
			<attribute name="data--t-e-i_status">
				<value-of select="@status"/>
			</attribute>
		</if>
	</template>
	<template name="handle-typed">
		<if test="@type">
			<attribute name="data--t-e-i_type">
				<value-of select="@type"/>
			</attribute>
		</if>
		<if test="@subtype">
			<attribute name="data--t-e-i_subtype">
				<value-of select="@subtype"/>
			</attribute>
		</if>
	</template>
	<template name="handle-tei">
		<attribute name="class">
			<text>tei </text>
			<value-of select="local-name()"/>
			<if test="@rend">
				<text> </text>
				<value-of select="@rend"/>
			</if>
			<if test="@xml:space='preserve'">
				<text> preserve</text>
			</if>
		</attribute>
		<if test="@xml:lang">
			<attribute name="lang">
				<value-of select="@xml:lang"/>
			</attribute>
			<attribute name="xml:lang">
				<value-of select="@xml:lang"/>
			</attribute>
		</if>
		<if test="@n">
			<attribute name="data--t-e-i_n">
				<value-of select="@n"/>
			</attribute>
		</if>
	</template>
	<!-- The Structure of a TEI Text -->
	<template match="/tei:TEI|/tei:teiCorpus">
		<html:html>
			<if test="@xml:lang">
				<attribute name="lang">
					<value-of select="@xml:lang"/>
				</attribute>
				<attribute name="xml:lang">
					<value-of select="@xml:lang"/>
				</attribute>
			</if>
			<html:head>
				<html:title>
					<value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
				</html:title>
				<html:style>
:Where(html,body){ Display: Block; Margin: 0; Padding: 0 }
*.tei.preserve{ White-Space: Break-Spaces }
*.tei.preserve::before,*.tei.preserve::after{ Content: "\2060" }
					<for-each select="document('')//comment()[starts-with(., ' [[ CSS: ]]&#x0A;')]">
						<value-of select="substring-after(., ' [[ CSS: ]]&#x0A;')"/>
					</for-each>
				</html:style>
				<for-each select="//processing-instruction()[name(.)='xml-stylesheet'][contains(., 'type=&#x22;text/css&#x22;') or contains(., &#x22;type='text/css';&#x22;)]">
					<html:link type="text/css">
						<attribute name="rel">
							<text>stylesheet</text>
							<if test="contains(., 'alternate=&#x22;yes&#x22;') or contains(., &#x22;alternate='yes';&#x22;)">
								<text> alternate</text>
							</if>
						</attribute>
						<if test="contains(., 'title=&#x22;')">
							<attribute name="title">
								<value-of select="substring-before(substring-after(., 'title=&#x22;'), '&#x22;')"/>
							</attribute>
						</if>
						<if test="contains(., &#x22;title='&#x22;)">
							<attribute name="title">
								<value-of select="substring-before(substring-after(., &#x22;title='&#x22;), &#x22;'&#x22;)"/>
							</attribute>
						</if>
						<if test="contains(., 'href=&#x22;')">
							<attribute name="href">
								<value-of select="substring-before(substring-after(., 'href=&#x22;'), '&#x22;')"/>
							</attribute>
						</if>
						<if test="contains(., &#x22;href='&#x22;)">
							<attribute name="href">
								<value-of select="substring-before(substring-after(., &#x22;href='&#x22;), &#x22;'&#x22;)"/>
							</attribute>
						</if>
						<if test="contains(., 'media=&#x22;')">
							<attribute name="media">
								<value-of select="substring-before(substring-after(., 'media=&#x22;'), '&#x22;')"/>
							</attribute>
						</if>
						<if test="contains(., &#x22;media='&#x22;)">
							<attribute name="media">
								<value-of select="substring-before(substring-after(., &#x22;media='&#x22;), &#x22;'&#x22;)"/>
							</attribute>
						</if>
					</html:link>
				</for-each>
				<apply-templates select="tei:teiHeader/tei:xenoData/*"/>
			</html:head>
			<html:body>
				<html:details open="">
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<call-template name="handle-typed"/>
					<apply-templates/>
				</html:details>
			</html:body>
		</html:html>
	</template>
	<template match="/*//tei:TEI|/*//tei:teiCorpus">
		<html:details>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<apply-templates/>
		</html:details>
		<!-- [[ CSS: ]]
*.tei.TEI,*.tei.TEICorpus{ Display: Flow-Root; Color: Var(\2D-PlainText); Background: Var(\2D-Background); Font: Medium / 1.5 JuniusX, Junicode, Elstob, ElstobD, Cormorant Garamond, Cormorant, Serif; Font-Variant-Numeric: Proportional-Nums Oldstyle-Nums; Text-Align: Justify; Text-Align-Last: Auto; Hyphens: Auto; \2D-Background: Canvas; \2D-EditText: ActiveText; \2D-EditorialText: LinkText; \2D-GreyText: GrayText; \2D-PlainText: CanvasText }
*.tei.teiCorpus>*.tei.TEI{ Margin-Block: 6EM }
-->
	</template>
	<template match="tei:teiHeader">
		<html:summary>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<html:table>
				<html:tbody>
					<for-each select="*[not(self::tei:xenoData)]">
						<html:tr>
							<html:th scope="row">
								<value-of select="name(.)"/>
							</html:th>
							<html:td>
								<apply-templates select="."/>
							</html:td>
						</html:tr>
					</for-each>
				</html:tbody>
			</html:table>
		</html:summary>
		<!-- [[ CSS: ]]
*.tei.teiHeader{ Display: Flow-Root; Position: Relative; Margin-Block: 0 .5EM; Border-Block: Thin Var(\2D-GreyText) Solid; Padding-Block: .5EM; Padding-Inline: 3EM; Line-Height: 1 }
*.tei.teiHeader::before,*.tei.teiHeader::after{ Display: List-Item; Position: Absolute; Inset-Block: 0; Inset-Inline-Start: 0; Margin: Auto; Block-Size: 1EM; Inline-Size: 1.5EM; List-Style: Inside Disclosure-Closed; Color: Var(\2D-GreyText); Font-Size: 2EM; Text-Align: End; Text-Align-Last: Auto; Content: "" }
*.tei.teiHeader::after{ Direction: RTL }
details[open]>summary.tei.teiHeader{ Border-Block-End: Medium Var(\2D-GreyText) Double }
details[open]>summary.tei.teiHeader::before,details[open]>summary.tei.teiHeader::after{ List-Style-Type: Disclosure-Open }
*.tei.teiHeader>table{ Direction: LTR; Margin-Block: 0; Margin-Inline: Auto; Border-Collapse: Collapse; Line-Height: 1 }
*.tei.teiHeader>table>tbody>tr>th{ Position: Relative; Padding-Block: .375EM; Padding-Inline: .375EM .75EM; Color: Var(\2D-GreyText); Font-Weight: Inherit; Text-Align: End; Text-Align-Last: Auto }
*.tei.teiHeader>table>tbody>tr:Not(:Last-Child)>th{ Border-Block-End: Thin Solid }
*.tei.teiHeader>table>tbody>tr>td{ Font-Size: Smaller }
-->
	</template>
	<template match="tei:text">
		<html:article>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<html:div><apply-templates/></html:div>
			<if test=".//*[self::tei:note|self::tei:add][@place='bottom'][ancestor::tei:p or ancestor::tei:lg][not(ancestor::tei:div or ancestor::tei:body or ancestor::tei:front or ancestor::tei:back)][count(current()|ancestor::tei:text[1])=1]">
				<html:footer>
					<html:ul>
						<for-each select=".//*[self::tei:note|self::tei:add][@place='bottom'][ancestor::tei:p or ancestor::tei:lg][not(ancestor::tei:div or ancestor::tei:body or ancestor::tei:front or ancestor::tei:back)][count(current()|ancestor::tei:text[1])=1]">
							<apply-templates select="." mode="endnotes"/>
						</for-each>
					</html:ul>
				</html:footer>
			</if>
		</html:article>
		<!-- [[ CSS: ]]
*.tei.text{ Display: Flow-Root; Position: Relative; Margin-Block: 3EM 4.5EM; Margin-Inline: Auto; Padding-Inline: 3EM; Max-Inline-Size: 37EM; Font-Size: Medium; Z-Index: 0 }
*.tei.text>footer{ Margin-Block: 1.5EM 0; Border-Block-Start: Thin Solid; Padding-Block: .75EM 0; Padding-Inline: 1.5EM 0 }
*.tei.text>footer>ul{ Margin: 0; Padding: 0 }
-->
	</template>
	<!-- Encoding the Body -->
	<template match="tei:front|tei:body|tei:back">
		<variable name="contents">
			<html:div><apply-templates/></html:div>
			<if test=".//*[self::tei:note|self::tei:add][@place='bottom'][ancestor::tei:p or ancestor::tei:lg][not(ancestor::tei:div)][count(current()|ancestor::tei:text[1])=1]">
				<html:footer>
					<html:ul>
						<for-each select=".//*[self::tei:note|self::tei:add][@place='bottom'][ancestor::tei:p or ancestor::tei:lg][not(ancestor::tei:div or ancestor::tei:body or ancestor::tei:front or ancestor::tei:back)][count(current()|ancestor::tei:text[1])=1]">
							<apply-templates select="." mode="endnotes"/>
						</for-each>
					</html:ul>
				</html:footer>
			</if>
		</variable>
		<choose>
			<when test="self::tei:front">
				<html:header>
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<copy-of select="$contents"/>
				</html:header>
			</when>
			<when test="self::tei:back">
				<html:footer>
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<copy-of select="$contents"/>
				</html:footer>
			</when>
			<otherwise>
				<html:section>
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<copy-of select="$contents"/>
				</html:section>
			</otherwise>
		</choose>
		<!-- [[ CSS: ]]
*.tei.front,*.tei.body,*.tei.back{ Display: Flow-Root; Position: Relative; Break-Before: Page; Margin-Block: 3EM }
*.tei.front,*.tei.back{ Padding-Inline: 3EM }
*.tei.front:Not(:First-Child)::before,*.tei.body:Not(:First-Child)::before,*.tei.back:Not(:First-Child)::before{ Display: Block; Margin-Block: 3EM; Margin-Inline: -1.5EM; Border-Block-Start: Thin Solid; Content: "" }
*.tei.front>footer,*.tei.body>footer,*.tei.back>footer{ Margin-Block: 1.5EM 0; Border-Block-Start: Thin Solid; Padding-Block: .75EM 0; Padding-Inline: 1.5EM 0 }
*.tei.front>footer>ul,*.tei.body>footer>ul,*.tei.back>footer>ul{ Margin: 0; Padding: 0 }
-->
	</template>
	<template match="tei:group">
		<html:section>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<apply-templates/>
		</html:section>
		<!-- [[ CSS: ]]
*.tei.group{ Display: Block; Margin-Block: 3EM }
-->
	</template>
	<template match="tei:p">
		<choose>
			<when test="ancestor::tei:p or ancestor::tei:lg">
				<html:span>
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<call-template name="handle-fragmentable"/>
					<apply-templates/>
					<html:span>
						<html:br/>
						<if test="not(@part) or @part='F'">
							<html:br/>
						</if>
					</html:span>
				</html:span>
			</when>
			<otherwise>
				<html:p>
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<call-template name="handle-fragmentable"/>
					<apply-templates/>
				</html:p>
			</otherwise>
		</choose>
		<!-- [[ CSS: ]]
*.tei.p{ Display: Block; Position: Relative; Margin: 0; Text-Align: Justify; Text-Align-Last: Auto }
*.tei.p[data\2D-t-e-i_n]::before{ Position: Absolute; Inset-Block-Start: 0; Inset-Inline-End: 100%; Margin-Inline: 0 .75EM; Min-Inline-Size: 2.5EM; Color: Var(\2D-GreyText); Font-Variant-Numeric: Tabular-Nums Lining-Nums; Text-Align: End; Text-Align-Last: Auto; Text-Align-Last: Auto; Text-Indent: 0; White-Space: Pre; Content: "¶" Attr(data\2D-t-e-i_n) }
*.tei.p+*.tei.p,*.tei.p+*.tei.pb+*.tei.p,*.tei.p.indent{ Text-Indent: 1.5EM }
*:root:root:root:root *.tei.p.unindent,*:root:root:root:root *.tei.p[data\2D-t-e-i_part=M],*:root:root:root:root *.tei.p[data\2D-t-e-i_part=F],*.tei.p>*{ Text-Indent: 0 }
span.tei.p>span:Last-Child{ Display: None }
-->
	</template>
	<template match="tei:div">
		<variable name="contents">
			<html:div><apply-templates/></html:div>
			<if test=".//*[self::tei:note|self::tei:add][@place='bottom'][ancestor::tei:p or ancestor::tei:lg][count(current()|ancestor::tei:div[1])=1]">
				<html:footer>
					<html:ul>
						<for-each select=".//*[self::tei:note|self::tei:add][@place='bottom'][ancestor::tei:p or ancestor::tei:lg][count(current()|ancestor::tei:div[1])=1]">
							<apply-templates select="." mode="endnotes"/>
						</for-each>
					</html:ul>
				</html:footer>
			</if>
		</variable>
		<choose>
			<when test="@type='contents' or @type='index'">
				<html:nav>
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<call-template name="handle-typed"/>
					<call-template name="handle-fragmentable"/>
					<copy-of select="$contents"/>
				</html:nav>
			</when>
			<otherwise>
				<html:section>
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<call-template name="handle-typed"/>
					<call-template name="handle-fragmentable"/>
					<copy-of select="$contents"/>
				</html:section>
			</otherwise>
		</choose>
		<!-- [[ CSS: ]]
*.tei.div{ Display: Flow-Root; Position: Relative; Break-Before: Page; Margin-Block: 1.5EM }
*.tei.div[data\2D-t-e-i_type=dedication]{ Font-Variant-Caps: Small-Caps; Text-Align-Last: Center }
*.tei.div[data\2D-t-e-i_n]::before{ Position: Absolute; Box-Sizing: Border-Box; Inset-Block-Start: 0; Inset-Inline-End: -3EM; Border: Thin Solid; Padding-Inline: .25EM; Min-Inline-Size: 2.5EM; Color: Var(\2D-GreyText); Background: Var(\2D-Background); Font-Variant-Numeric: Tabular-Nums Lining-Nums; Text-Align: Center; Text-Align-Last: Auto; Text-Indent: 0; White-Space: Pre; Content: "§" Attr(data\2D-t-e-i_n) }
*.tei.text>div>*>div>*.tei.div{ Margin-Block: 3EM }
*.tei.div>footer{ Margin-Block: 1.5EM 0; Border-Block-Start: Thin Solid; Padding-Block: .75EM 0; Padding-Inline: 1.5EM 0 }
*.tei.div>footer>ul{ Margin: 0; Padding: 0 }
-->
	</template>
	<template match="tei:head">
		<html:h1>
			<call-template name="handle-id">
				<with-param name="force">head</with-param>
			</call-template>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<call-template name="handle-placement"/>
			<apply-templates/>
		</html:h1>
		<!-- [[ CSS: ]]
*.tei.head{ Display: Block; Margin-Block: 1.5EM; Font-Size: Larger; Font-Weight: Inherit; Font-Variant-Numeric: Proportional-Nums Lining-Nums; Text-Align: Center; Text-Align-Last: Auto }
*.tei.head[data\2D-t-e-i_n]::before{ Display: Block; Font-Size: Smaller; Font-Weight: Lighter; Font-Variant-Caps: All-Small-Caps; Font-Variant-Numeric: Proportional-Nums Oldstyle-Nums; Line-Height: 1; Text-Decoration: Underline; Content: Attr(data\2D-t-e-i_n) }
*.tei.body>div>*.tei.head{ Font-Size: XXX-Large }
*.tei.body>div>*.tei.div>div>*.tei.head,*.tei.body>div>*.tei.divGen>div>*.tei.head{ Font-Size: XX-Large }
*.tei.body>div>*.tei.div>div>*.tei.div>div>*.tei.head,*.tei.body>div>*.tei.div>div>*.tei.divGen>div>*.tei.head{ Font-Size: X-Large }
-->
	</template>
	<template match="tei:trailer">
		<html:footer>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<call-template name="handle-placement"/>
			<html:strong><apply-templates/></html:strong>
		</html:footer>
		<!-- [[ CSS: ]]
*.tei.trailer{ Display: Block; Margin-Block: 1.5EM; Font-Weight: Bolder; Font-Variant-Caps: Small-Caps; Text-Align: End; Text-Align-Last: Auto }
			*.tei.trailer>strong{ Font-Weight: Inherit }
-->
	</template>
	<template match="tei:l">
		<html:span>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-fragmentable"/>
			<apply-templates/>
			<if test="not(@part) or @part='F'">
				<html:br/>
			</if>
		</html:span>
		<!-- [[ CSS: ]]
*.tei.l{ Display: Block; Position: Relative; Padding-Inline-Start: 3EM; Text-Align: Start; Text-Align-Last: Auto; Text-Indent: -3EM }
*.tei.l.indent{ Padding-Inline-Start: 4.5EM }
*.tei.l.indent.unindent{ Padding-Inline-Start: 3EM }
*.tei.l[data\2D-t-e-i_n]::after{ Position: Absolute; Inset-Block-End: 0; Inset-Inline-Start: 100%; Margin-Inline-Start: .5EM; Color: Var(\2D-GreyText); Font-Size: Smaller; Font-Variant-Caps: Normal; Font-Variant-Numeric: Tabular-Nums Lining-Nums; Text-Indent: 0; White-Space: Pre; Content: "[" Attr(data\2D-t-e-i_n) "]" }
*.tei.l[data\2D-t-e-i_part=M],*.tei.l[data\2D-t-e-i_part=F],*.tei.l>*{ Text-Indent: 0 }
-->
	</template>
	<template match="tei:lg">
		<choose>
			<when test="ancestor::tei:p or ancestor::tei:lg">
				<html:span>
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<call-template name="handle-typed"/>
					<call-template name="handle-fragmentable"/>
					<apply-templates/>
					<html:span>
						<html:br/>
						<if test="not(@part) or @part='F'">
								<html:br/>
						</if>
					</html:span>
				</html:span>
			</when>
			<otherwise>
				<html:p>
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<call-template name="handle-typed"/>
					<call-template name="handle-fragmentable"/>
					<apply-templates/>
				</html:p>
			</otherwise>
		</choose>
		<!-- [[ CSS: ]]
*.tei.lg{ Display: Block; Position: Relative; Margin-Block: .75EM; Padding-Inline: .75EM; Max-Inline-Size: Max-Content; Text-Align: Start; Text-Align-Last: Auto }
*.tei.lg[data\2D-t-e-i_n]::before{ Position: Absolute; Inset-Block-Start: 0; Inset-Inline-End: 100%; Margin-Inline: 0 .75EM; Min-Inline-Size: 2.5EM; Color: Var(\2D-GreyText); Font-Variant-Numeric: Tabular-Nums Lining-Nums; Text-Align: End; Text-Align-Last: Auto; Text-Indent: 0; White-Space: Pre; Content: "¶" Attr(data\2D-t-e-i_n) }
span.tei.lg>span:Last-Child{ Display: None }
-->
	</template>
	<template match="tei:sp">
		<html:blockquote>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<apply-templates/>
		</html:blockquote>
		<!-- [[ CSS: ]]
*.tei.sp{ Display: Block; Margin-Block: 1.5EM; Margin-Inline: 0; Padding-Inline: 3EM; Text-Align-Last: Center }
*.tei.sp *.tei.p{ Margin-Inline: -3EM; Padding-Inline: 3EM }
*.tei.sp *.tei.lg{ Margin-Inline: -3EM; Padding-Inline: 3.75EM }
-->
	</template>
	<template match="tei:speaker">
		<html:strong>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<choose>
				<when test="../@who">
					<html:a href="{../@who}">
						<apply-templates/>
					</html:a>
				</when>
				<otherwise><apply-templates/></otherwise>
			</choose>
		</html:strong>
		<!-- [[ CSS: ]]
*.tei.speaker{ Display: Block; Text-Align: Center; Text-Align-Last: Auto; Text-Transform: Uppercase }
-->
	</template>
	<template match="tei:stage">
		<html:i>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-placement"/>
			<if test="@type">
				<attribute name="data--t-e-i_type">
					<value-of select="@type"/>
				</attribute>
			</if>
			<apply-templates/>
		</html:i>
		<!-- [[ CSS: ]]
*.tei.stage{ Display: Inline; Font-Style: Inherit; Font-Variant-Caps: Petite-Caps }
*.tei.p *.tei.stage::before,*.tei.lg *.tei.stage::before{ Font-Variant-Caps: Normal; Content: "⟨" }
*.tei.p *.tei.stage::after,*.tei.lg *.tei.stage::after{ Font-Variant-Caps: Normal; Content: "⟩" }
*.tei.stage[data\2D-t-e-i_type~=exit]{ Display: Block; Margin-Block: 1EM; Font-Variant-Caps: Small-Caps; Line-Height: 1; Text-Align: Justify; Text-Align-Last: End }
*.tei.stage[data\2D-t-e-i_type~=entrance]{ Display: Block; Margin-Block: 1EM; Font-Variant-Caps: Small-Caps; Line-Height: 1; Text-Align: Justify; Text-Align-Last: Start }
*.tei.stage[data\2D-t-e-i_type~=setting]{ Display: Block; Margin-Block: 1EM; Font-Weight: Bolder; Font-Variant-Caps: Normal; Line-Height: 1; Text-Align: Start; Text-Align-Last: Auto; Text-Transform: Uppercase }
*.tei.stage[data\2D-t-e-i_type~=novelistic]{ Display: Block; Margin-Block: 1.5EM; Font-Variant-Caps: Normal; Text-Align: Inherit; Text-Align-Last: Inherit }
-->
	</template>
	<!-- Page and Line Numbers -->
	<template match="tei:pb|tei:milestone">
		<html:span>
			<call-template name="handle-id">
				<with-param name="force">
					<choose>
						<when test="self::pb">page</when>
						<otherwise>milestone</otherwise>
					</choose>
				</with-param>
			</call-template>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
		</html:span>
		<!-- [[ CSS: ]]
*.tei.pb{ Position: Absolute; Inset-Inline-End: -3EM; Margin-Inline: .25EM; Min-Inline-Size: 2.5EM; Font-Size: Medium; Text-Align: End; Text-Align-Last: Auto; Text-Indent: 0; White-Space: Pre; Z-Index: -1 }
*.tei.text>div>*.tei.pb{ Inset-Inline-End: 0 }
*.tei.pb::before{ Color: Var(\2D-GreyText); Font-Size: Smaller; Font-Variant-Caps: Normal; Font-Variant-Numeric: Tabular-Nums Lining-Nums; Content: "[[ " Attr(data\2D-t-e-i_n) " ]]" }
*.tei.milestone{ Display: Inline }
-->
	</template>
	<template match="tei:lb">
		<html:br>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
		</html:br>
	</template>
	<!-- Marking Highlighted Phrases -->
	<template match="tei:hi|tei:foreign|tei:mentioned|tei:soCalled">
		<html:i>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<apply-templates/>
		</html:i>
		<!-- [[ CSS: ]]
*.tei.hi{ Display: Inline; Font-Style: Inherit; Text-Decoration: Var(\2D-EditorialText) Wavy Underline }
*.tei.foreign{ Display: Inline; Font-Style: Inherit }
*.tei.foreign::before{ Font-Variant-Caps: Normal; Content: "⸢" }
*.tei.foreign::after{ Font-Variant-Caps: Normal; Content: "⸣" }
*.tei.mentioned{ Display: Inline; Font-Style: Inherit }
*.tei.mentioned::before{ Font-Variant-Caps: Normal; Content: "‘" }
*.tei.mentioned::after{ Font-Variant-Caps: Normal; Content: "’" }
*.tei.soCalled{ Display: Inline; Font-Style: Inherit }
*.tei.soCalled::before{ Font-Variant-Caps: Normal; Content: "“" }
*.tei.soCalled::after{ Font-Variant-Caps: Normal; Content: "”" }
-->
	</template>
	<template match="tei:gloss">
		<html:i>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<apply-templates/>
		</html:i>
		<!-- [[ CSS: ]]
*.tei.gloss{ Display: Inline; Font-Style: Inherit; Font-Weight: Bolder }
-->
	</template>
	<template match="tei:emph">
		<html:em>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<apply-templates/>
		</html:em>
		<!-- [[ CSS: ]]
*.tei.emph{ Display: Inline; Font-Style: Inherit }
*.tei.emph::before,*.tei.emph::after{ Font-Size: Smaller; Vertical-Align: Middle; Content: "※" }
-->
	</template>
	<template match="tei:label">
		<html:strong>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<call-template name="handle-placement"/>
			<apply-templates/>
		</html:strong>
		<!-- [[ CSS: ]]
*.tei.label{ Display: Inline; Font-Weight: Bolder }
-->
	</template>
	<template match="tei:term">
		<variable name="contents">
			<choose>
				<when test="@ref">
					<tei:ref target="{@ref}">
						<copy-of select="@*|node()"/>
					</tei:ref>
				</when>
				<otherwise>
					<copy-of select="@*|node()"/>
				</otherwise>
			</choose>
		</variable>
		<html:b>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<apply-templates select="exsl:node-set($contents)"/>
		</html:b>
		<!-- [[ CSS: ]]
*.tei.term{ Display: Inline; Font-Weight: Bolder }
-->
	</template>
	<template match="tei:title">
		<variable name="contents">
			<choose>
				<when test="@ref">
					<tei:ref target="{@ref}">
						<copy-of select="@*|node()"/>
					</tei:ref>
				</when>
				<otherwise>
					<copy-of select="@*|node()"/>
				</otherwise>
			</choose>
		</variable>
		<html:cite>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<if test="@type">
				<attribute name="data--t-e-i_type">
					<value-of select="@type"/>
				</attribute>
			</if>
			<if test="@level">
				<attribute name="data--t-e-i_level">
					<value-of select="@level"/>
				</attribute>
			</if>
			<apply-templates select="exsl:node-set($contents)"/>
		</html:cite>
		<!-- [[ CSS: ]]
*.tei.title{ Display: Inline; Font-Style: Inherit; Font-Variant-Numeric: Proportional-Nums Lining-Nums }
*.tei.title[data\2D-t-e-i_level=j]{ Font-Variant-Caps: Petite-Caps; Text-Decoration: Underline }
*.tei.title[data\2D-t-e-i_level=m]{ Text-Decoration: Underline }
*.tei.title[data\2D-t-e-i_level=s]{ Font-Variant-Caps: Petite-Caps }
*.tei.title[data\2D-t-e-i_level=a]::before,*.tei.title[data\2D-t-e-i_level=u]::before{ Font-Variant-Caps: Normal; Content: "“" }
*.tei.title[data\2D-t-e-i_level=a]::after,*.tei.title[data\2D-t-e-i_level=u]::after{ Font-Variant-Caps: Normal; Content: "”" }
-->
	</template>
	<template match="tei:q">
		<choose>
			<when test="not(ancestor::tei:p or ancestor::tei:lg)">
				<html:blockquote>
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<if test="@type">
						<attribute name="data--t-e-i_type">
							<value-of select="@type"/>
						</attribute>
					</if>
					<apply-templates/>
				</html:blockquote>
			</when>
			<when test="@type='spoken' or @type='written'">
				<html:q data--t-e-i_type="{@type}">
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<apply-templates/>
				</html:q>
			</when>
			<when test="@type='emph'">
				<html:em data--t-e-i_type="{@type}">
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<apply-templates/>
				</html:em>
			</when>
			<otherwise>
				<html:i>
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<if test="@type">
						<attribute name="data--t-e-i_type">
							<value-of select="@type"/>
						</attribute>
					</if>
					<apply-templates/>
				</html:i>
			</otherwise>
		</choose>
		<!-- [[ CSS: ]]
*.tei.q{ Display: Inline; Font-Style: Inherit }
*.tei.q::before{ Font-Variant-Caps: Normal; Content: "⟨" }
*.tei.q::after{ Font-Variant-Caps: Normal; Content: "⟩" }
*.tei.q[data\2D-t-e-i_type=distinct]::before,*.tei.q[data\2D-t-e-i_type=distinct]::after,*.tei.q[data\2D-t-e-i_type=term]::before,*.tei.q[data\2D-t-e-i_type=term]::after{ Content: None }
*.tei.q[data\2D-t-e-i_type=distinct]{ Font-Variant-Caps: Petite-Caps }
*.tei.q[data\2D-t-e-i_type=term]{ Font-Weight: Bolder }
*.tei.q[data\2D-t-e-i_type=foreign]::before{ Font-Variant-Caps: Normal; Content: "⸢" }
*.tei.q[data\2D-t-e-i_type=foreign]::after{ Font-Variant-Caps: Normal; Content: "⸣" }
*.tei.q[data\2D-t-e-i_type=mentioned]::before{ Font-Variant-Caps: Normal; Content: "‘" }
*.tei.q[data\2D-t-e-i_type=mentioned]::after{ Font-Variant-Caps: Normal; Content: "’" }
*.tei.q[data\2D-t-e-i_type=soCalled]::before{ Font-Variant-Caps: Normal; Content: "“" }
*.tei.q[data\2D-t-e-i_type=soCalled]::after{ Font-Variant-Caps: Normal; Content: "”" }
*.tei.q[data\2D-t-e-i_type=spoken]::before{ Content: "― " }
*.tei.q[data\2D-t-e-i_type=spoken]::after{ White-Space: Pre; Content: "  \2060" }
*.tei.q[data\2D-t-e-i_type=spoken]+*.tei.seg.space{ Display: None }
*.tei.q[data\2D-t-e-i_type=written]::before{ Font-Variant-Caps: Normal; Content: "« " }
*.tei.q[data\2D-t-e-i_type=written]::after{ Font-Variant-Caps: Normal; Content: " »" }
blockquote.tei.q{ Display: Block; Position: Relative; Margin-Block: .75EM; Margin-Inline: -.5EM; Padding-Inline: 2EM; Min-Block-Size: 3EM }
blockquote.tei.q::before,blockquote.tei.q::after{ Display: Block; Position: Absolute; Min-Inline-Size: 1EM; Color: Var(\2D-GreyText); Font-Size: 2EM; Text-Align: Center; Text-Align-Last: Auto }
blockquote.tei.q::before{ Inset-Block-Start: -.25EM; Inset-Inline-End: Calc(100% - 1EM) }
blockquote.tei.q[data\2D-t-e-i_type=spoken]::before{ Content: None }
blockquote.tei.q::after{ Inset-Block-Start: Calc(100% - 1EM); Inset-Inline-Start: Calc(100% - 1EM) }
blockquote.tei.q *.tei.p::before,blockquote.tei.q *.tei.lg::before{ Margin-Inline-End: 2.25EM }
-->
	</template>
	<!-- Notes -->
	<template match="tei:note">
		<variable name="prefix">
			<tei:seg>
				<choose>
					<when test="@n">
						<value-of select="@n"/>
					</when>
					<otherwise>†</otherwise>
				</choose>
				<tei:pc rend="terminal">.</tei:pc>
				<text> </text>
			</tei:seg>
		</variable>
		<choose>
			<when test="@anchored='false' and not(ancestor::tei:p or ancestor::tei:lg)">
				<html:aside>
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<call-template name="handle-typed"/>
					<call-template name="handle-placement"/>
					<apply-templates select="exsl:node-set($prefix)"/>
					<apply-templates/>
				</html:aside>
			</when>
			<when test="ancestor::teiHeader and not(ancestor::tei:p or ancestor::tei:lg)">
				<html:div>
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<call-template name="handle-typed"/>
					<call-template name="handle-placement"/>
					<if test="@anchored">
						<attribute name="data--t-e-i_anchored">
							<value-of select="@anchored"/>
						</attribute>
					</if>
					<apply-templates select="exsl:node-set($prefix)"/>
					<apply-templates/>
				</html:div>
			</when>
			<otherwise>
				<html:span>
					<call-template name="handle-tei"/>
					<call-template name="handle-typed"/>
					<call-template name="handle-placement"/>
					<if test="@anchored">
						<attribute name="data--t-e-i_anchored">
							<value-of select="@anchored"/>
						</attribute>
					</if>
					<choose>
						<when test="@place='bottom'">
							<attribute name="id">
								<value-of select="concat('TEI.sup.', generate-id(.))"/>
							</attribute>
						</when>
						<otherwise>
							<call-template name="handle-id"/>
						</otherwise>
					</choose>
					<if test="not(@place='inline')">
						<variable name="super">
							<choose>
								<when test="@n">
									<value-of select="@n"/>
								</when>
								<otherwise>†</otherwise>
							</choose>
						</variable>
						<html:sup tabindex="0">
							<choose>
								<when test="@place='bottom'">
									<html:a id="TEI.sup.{generate-id(.)}">
										<choose>
											<when test="@xml:id">
												<attribute name="href">
													<value-of select="concat('#', @xml:id)"/>
												</attribute>
											</when>
											<otherwise>
												<attribute name="href">
													<value-of select="concat('#TEI.note.', generate-id(.))"/>
												</attribute>
											</otherwise>
										</choose>
										<copy-of select="$super"/>
									</html:a>
								</when>
								<otherwise>
									<copy-of select="$super"/>
								</otherwise>
							</choose>
						</html:sup>
					</if>
					<if test="not(@place='bottom')">
						<html:small>
							<apply-templates select="exsl:node-set($prefix)"/>
							<apply-templates/>
						</html:small>
					</if>
				</html:span>
			</otherwise>
		</choose>
		<!-- [[ CSS: ]]
*.tei.note{ Display: Inline; Color: Var(\2D-EditorialText) }
*:not(span).tei.note{ Display: Block; Margin-Block: 1.5EM; Border-Block-Style: Solid Double; Border-Inline-Style: Solid Dashed; Border-Block-Width: Thin Medium; Border-Inline-Width: Thin; Padding-Block: .75EM; Padding-Inline: 3EM .5EM; Min-Block-Size: 3EM; Color: Inherit }
*:not(span).tei.note *:not(span).tei.note{ Font-Size: Smaller }
*:not(span).tei.note *.tei.p::before,aside.tei.note *.tei.lg::before{ Margin-Inline-End: 3.75EM }
*:not(span).tei.note>*.tei.seg:First-Child{ Display: Inline-Block; Margin-Inline-Start: -1EM; Min-Inline-Size: 1EM; Color: Var(\2D-EditorialText); Font-Size: 2EM; Text-Align: End; Text-Align-Last: Auto }
*:not(span).tei.note>*.tei.seg:First-Child,span.tei.note>sup[tabindex]+small>*.tei.seg:First-Child{ Float: Inline-Start; Font-Variant-Numeric: Tabular-Nums Lining-Nums; White-Space: Pre }
span.tei.note{ White-Space: NoWrap }
span.tei.note::before{ Content: "\2060" }
span.tei.note>sup[tabindex]{ Display: Inline-Block; Vertical-Align: Super; Margin-Inline: -.25EM; Padding-Inline: .25EM; Min-Inline-Size: .5EM; Font-Size: Smaller; Font-Variant-Numeric: Tabular-Nums Lining-Nums; Line-Height: 1; Text-Align: Center; Text-Align-Last: Auto; Text-Decoration: Dotted Underline; Cursor: Default }
span.tei.note>sup[tabindex]>a{ Display: Block; Margin-Inline: -.25EM; Padding-Inline: .25EM; Color: Inherit; Text-Decoration: Dotted Underline }
span.tei.note>sup[tabindex]+small{ Display: None; Position: Absolute; Inset-Inline: -3PX; Border-Style: Solid; Border-Color: Transparent; Border-Width: 3PX; Padding-Block: 1.5EM; Padding-Inline: 4EM; Color: Var(\2D-PlainText); Background: Var(\2D-Background); Box-Shadow: 1PX 1PX 3PX Var(\2D-GreyText); Font: Small / 1.5 JuniusX, Junicode, Elstob, ElstobD, Cormorant Garamond, Cormorant, Serif; Font-Variant-Numeric: Proportional-Nums Oldstyle-Nums; Text-Align: Justify; Text-Align-Last: Auto; White-Space: Normal; Z-Index: 1 }
*.tei.front span.tei.note>sup[tabindex]+small,*.tei.back span.tei.note>sup[tabindex]+small{ Inset-Inline: Calc(-3EM - 3PX) }
span.tei.note>sup[tabindex]:Focus+small,span.tei.note>sup[tabindex]:Hover+small,span.tei.note>sup[tabindex]+small:Focus-Within,span.tei.note>sup[tabindex]+small:Hover{ Display: Block }
span.tei.note>sup[tabindex]+small>*.tei.seg:First-Child{ Min-Inline-Size: 1.5EM; Color: Var(\2D-EditorialText); Text-Align: Start; Text-Align-Last: Auto }
-->
	</template>
	<template match="tei:note" mode="endnotes">
		<variable name="prefix">
			<choose>
				<when test="@n">
					<value-of select="@n"/>
				</when>
				<otherwise>†</otherwise>
			</choose>
			<tei:pc rend="terminal">.</tei:pc>
		</variable>
		<html:li>
			<call-template name="handle-id">
				<with-param name="force">note</with-param>
			</call-template>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<call-template name="handle-placement"/>
			<if test="@anchored">
				<attribute name="data--t-e-i_anchored">
					<value-of select="@anchored"/>
				</attribute>
			</if>
			<html:span>
				<html:a href="#TEI.sup.{generate-id(.)}">
					<apply-templates select="exsl:node-set($prefix)"/>
				</html:a>
				<text> </text>
			</html:span>
			<apply-templates/>
		</html:li>
		<!-- [[ CSS: ]]
li.tei.note{ Display: Block; Color: Inherit }
li.tei.note>span:First-Child{ Display: Inline-Block; Float: Inline-Start; Margin-Inline-Start: -1.5EM; Min-Inline-Size: 1.5EM; Color: Var(\2D-EditorialText); Font-Variant-Numeric: Tabular-Nums Lining-Nums; Text-Align: End; Text-Align-Last: Auto; White-Space: Pre }
li.tei.note>span:First-Child>a{ Color: Inherit; Text-Decoration: Dashed Underline }
-->
	</template>
	<!-- Cross References and Links -->
	<template match="tei:ref">
		<html:a>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<attribute name="href">
				<choose>
					<when test="contains(@target, ' ')">
						<value-of select="substring-before(@target, ' ')"/>
					</when>
					<otherwise>
						<value-of select="@target"/>
					</otherwise>
				</choose>
			</attribute>
			<apply-templates/>
		</html:a>
		<!-- [[ CSS: ]]
*.tei.ref{ Display: Inline; Color: Var(\2D-EditorialText); Text-Decoration: Dashed Underline }
-->
	</template>
	<template match="tei:ptr">
		<html:iframe importance="low" loading="lazy" referrerpolicy="no-referrer" sandbox="">
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<attribute name="src">
				<choose>
					<when test="contains(@target, ' ')">
						<value-of select="substring-before(@target, ' ')"/>
					</when>
					<otherwise>
						<value-of select="@target"/>
					</otherwise>
				</choose>
			</attribute>
		</html:iframe>
		<!-- [[ CSS: ]]
*.tei.ptr{ Display: Block; Margin-Block: .75EM; Margin-Inline: Auto; Border: Thin Solid; Block-Size: 10.5EM; Inline-Size: 75%; Min-Inline-Size: 17EM }
-->
	</template>
	<template match="tei:anchor">
		<html:span>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
		</html:span>
		<!-- [[ CSS: ]]
*.tei.anchor{ Display: Inline }
-->
	</template>
	<template match="tei:seg">
		<html:span>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<call-template name="handle-fragmentable"/>
			<apply-templates/>
		</html:span>
		<!-- [[ CSS: ]]
*.tei.seg{ Display: Inline }
-->
	</template>
	<!-- Editorial Interventions -->
	<template match="tei:corr|tei:reg">
		<html:ins>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<call-template name="handle-editLike"/>
			<apply-templates/>
		</html:ins>
		<!-- [[ CSS: ]]
*.tei.corr,*.tei.reg{ Display: Inline; Text-Decoration: Var(\2D-EditText) Underline; Text-Decoration-Skip-Ink: None }
*.tei.corr[data\2D-t-e-i_evidence=conjecture],*.tei.reg[data\2D-t-e-i_evidence=conjecture]{ Text-Decoration-Style: Dashed }
-->
	</template>
	<template match="tei:sic|tei:orig">
		<html:u>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<apply-templates/>
		</html:u>
		<!-- [[ CSS: ]]
*.tei.sic,*.tei.orig{ Display: Inline; Text-Decoration: Var(\2D-EditText) Wavy Underline; Text-Decoration-Skip-Ink: None }
-->
	</template>
	<template match="tei:choice">
		<html:ruby>
			<call-template name="handle-tei"/>
			<for-each select="tei:sic|tei:orig|tei:abbr|tei:unclear|tei:choice|tei:seg">
				<html:span>
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<if test="self::tei:abbr">
						<call-template name="handle-typed"/>
					</if>
					<apply-templates/>
				</html:span>
			</for-each>
			<for-each select="tei:corr|tei:reg|tei:expan">
				<html:rt>
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<call-template name="handle-editLike"/>
					<apply-templates/>
				</html:rt>
			</for-each>
		</html:ruby>
		<!-- [[ CSS: ]]
*.tei.choice{ Display: Ruby }
*.tei.choice>*.tei.corr,*.tei.choice>*.tei.reg{ Display: Ruby-Text; Font-Size: Smaller; Color: Var(\2D-EditText); Text-Decoration: None }
*.tei.choice>*.tei.expan{ Display: Ruby-Text; Font-Size: Revert }
*.tei.choice>*.tei.expan::before,*.tei.choice>*.tei.expan::after{ Content: None }
-->
	</template>
	<template match="tei:add">
		<variable name="prefix">
			<if test="@place and not(@place='inline')">
				<tei:seg>
					<choose>
						<when test="@n">
							<value-of select="@n"/>
						</when>
						<otherwise>^</otherwise>
					</choose>
					<tei:pc rend="terminal">.</tei:pc>
					<text> </text>
				</tei:seg>
			</if>
		</variable>
		<html:ins>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<call-template name="handle-placement"/>
			<call-template name="handle-transcriptional"/>
			<call-template name="handle-editLike"/>
			<choose>
				<when test="@place='bottom'">
					<attribute name="id">
						<value-of select="concat('TEI.sup.', generate-id(.))"/>
					</attribute>
				</when>
				<otherwise>
					<call-template name="handle-id"/>
				</otherwise>
			</choose>
			<if test="@place and not(@place='inline')">
				<variable name="super">
					<choose>
						<when test="@n">
							<value-of select="@n"/>
						</when>
						<otherwise>^</otherwise>
					</choose>
				</variable>
				<html:sup tabindex="0">
					<choose>
						<when test="@place='bottom'">
							<html:a id="TEI.sup.{generate-id(.)}">
								<choose>
									<when test="@xml:id">
										<attribute name="href">
											<value-of select="concat('#', @xml:id)"/>
										</attribute>
									</when>
									<otherwise>
										<attribute name="href">
											<value-of select="concat('#TEI.add.', generate-id(.))"/>
										</attribute>
									</otherwise>
								</choose>
								<copy-of select="$super"/>
							</html:a>
						</when>
						<otherwise>
							<copy-of select="$super"/>
						</otherwise>
					</choose>
				</html:sup>
			</if>
			<if test="not(@place='bottom')">
				<html:span>
					<apply-templates select="exsl:node-set($prefix)"/>
					<apply-templates/>
				</html:span>
			</if>
		</html:ins>
		<!-- [[ CSS: ]]
*.tei.add{ Display: Inline; Color: Var(\2D-EditText); White-Space: NoWrap; Text-Decoration: None }
*.tei.add::before{ Content: "\2060" }
*.tei.add>span{ Color: Var(\2D-PlainText) }
*.tei.add:Not([data\2D-t-e-i_place])>span::before,*.tei.add[data\2D-t-e-i_place=inline]>span::before{ Color: Var(\2D-EditText); Font-Variant-Caps: Normal; Content: "`" }
*.tei.add:Not([data\2D-t-e-i_place])>span::after,*.tei.add[data\2D-t-e-i_place=inline]>span::after{ Color: Var(\2D-EditText); Font-Variant-Caps: Normal; Content: "´" }
*.tei.add>sup[tabindex]{ Display: Inline-Block; Vertical-Align: Super; Margin-Inline: -.25EM; Padding-Inline: .25EM; Min-Inline-Size: .5EM; Font-Size: Smaller; Font-Variant-Numeric: Tabular-Nums Lining-Nums; Line-Height: 1; Text-Align: Center; Text-Align-Last: Auto; Text-Decoration: Dotted Underline; Cursor: Default }
*.tei.add>sup[tabindex]>a{ Display: Block; Margin-Inline: -.25EM; Padding-Inline: .25EM; Color: Inherit; Text-Decoration: Dotted Underline }
*.tei.add>sup[tabindex]+span{ Display: None; Position: Absolute; Inset-Inline: -3PX; Border-Style: Solid; Border-Color: Transparent; Border-Width: 3PX; Padding-Block: 1.5EM; Padding-Inline: 4EM; Color: Var(\2D-PlainText); Background: Var(\2D-Background); Box-Shadow: 1PX 1PX 3PX Var(\2D-GreyText); Font: Small / 1.5 JuniusX, Junicode, Elstob, ElstobD, Cormorant Garamond, Cormorant, Serif; Font-Variant-Numeric: Proportional-Nums Oldstyle-Nums; Text-Align: Justify; Text-Align-Last: Auto; White-Space: Normal; Z-Index: 1 }
*.tei.front *.tei.add>sup[tabindex]+span,*.tei.back *.tei.add>sup[tabindex]+span{ Inset-Inline: Calc(-3EM - 3PX) }
*.tei.add>sup[tabindex]:Focus+span,*.tei.add>sup[tabindex]:Hover+span,*.tei.add>sup[tabindex]+span:Focus-Within,*.tei.add>sup[tabindex]+span:Hover{ Display: Block }
*.tei.add>sup[tabindex]+span>*.tei.seg:First-Child{ Min-Inline-Size: 1.5EM; Color: Var(\2D-EditText); Text-Align: Start; Text-Align-Last: Auto }
-->
	</template>
	<template match="tei:add" mode="endnotes">
		<variable name="prefix">
			<choose>
				<when test="@n">
					<value-of select="@n"/>
				</when>
				<otherwise>^</otherwise>
			</choose>
			<tei:pc rend="terminal">.</tei:pc>
		</variable>
		<html:li>
			<call-template name="handle-id">
				<with-param name="force">add</with-param>
			</call-template>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<call-template name="handle-placement"/>
			<if test="@anchored">
				<attribute name="data--t-e-i_anchored">
					<value-of select="@anchored"/>
				</attribute>
			</if>
			<html:ins>
				<html:span>
					<html:a href="#TEI.sup.{generate-id(.)}">
						<apply-templates select="exsl:node-set($prefix)"/>
					</html:a>
					<text> </text>
				</html:span>
				<apply-templates/>
			</html:ins>
		</html:li>
		<!-- [[ CSS: ]]
li.tei.add{ Display: Block; Color: Inherit }
li.tei.add>ins{ Display: Block; Text-Decoration: None }
li.tei.add>ins>span:First-Child{ Display: Inline-Block; Float: Inline-Start; Margin-Inline-Start: -1.5EM; Min-Inline-Size: 1.5EM; Color: Var(\2D-EditText); Font-Variant-Numeric: Tabular-Nums Lining-Nums; Text-Align: End; Text-Align-Last: Auto; White-Space: Pre }
li.tei.add>ins>span:First-Child>a{ Color: Inherit; Text-Decoration: Dashed Underline }
-->
	</template>
	<template match="tei:gap">
		<html:del>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-editLike"/>
			<if test="@reason">
				<attribute name="data--t-e-i_reason">
					<value-of select="@reason"/>
				</attribute>
			</if>
			<if test="@agent">
				<attribute name="data--t-e-i_agent">
					<value-of select="@agent"/>
				</attribute>
			</if>
			<apply-templates/>
		</html:del>
		<!-- [[ CSS: ]]
*.tei.gap{ Display: Inline; Font-Size: Smaller; Text-Decoration: None }
-->
	</template>
	<template match="tei:desc">
		<html:span>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<apply-templates/>
		</html:span>
		<!-- [[ CSS: ]]
*.tei.desc{ Display: Inline }
*.tei.desc::before{ Font-Variant-Caps: Normal; Content: "[[ " }
*.tei.desc::after{ Font-Variant-Caps: Normal; Content: " ]]" }
-->
	</template>
	<template match="tei:del">
		<html:del>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<call-template name="handle-transcriptional"/>
			<call-template name="handle-editLike"/>
			<apply-templates/>
		</html:del>
		<!-- [[ CSS: ]]
*.tei.del{ Display: Inline; Text-Decoration: None }
*.tei.del::before{ Color: Var(\2D-EditText); Font-Variant-Caps: Normal; Content: "⸠" }
*.tei.del::after{ Color: Var(\2D-EditText); Font-Variant-Caps: Normal; Content: "⸡" }
*.tei.del[data\2D-t-e-i_evidence=conjecture]::after{ Content: "⸡?" }
-->
	</template>
	<template match="tei:unclear">
		<html:span>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-editLike"/>
			<if test="@reason">
				<attribute name="data--t-e-i_reason">
					<value-of select="@reason"/>
				</attribute>
			</if>
			<if test="@agent">
				<attribute name="data--t-e-i_agent">
					<value-of select="@agent"/>
				</attribute>
			</if>
			<apply-templates/>
		</html:span>
		<!-- [[ CSS: ]]
*.tei.unclear{ Display: Inline; Color: Var(\2D-GreyText) }
*.tei.unclear::before{ Font-Variant-Caps: Normal; Content: "[" }
*.tei.unclear::after{ Font-Variant-Caps: Normal; Content: "]" }
*.tei.unclear[data\2D-t-e-i_evidence=conjecture]::after{ Content: "]?" }
-->
	</template>
	<template match="tei:abbr">
		<html:abbr>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<apply-templates/>
		</html:abbr>
		<!-- [[ CSS: ]]
*.tei.abbr{ Display: Inline; Font-Variant-Caps: Petite-Caps }
*.tei.abbr[data\2D-t-e-i_type=acronym]{ Font-Variant-Caps: All-Small-Caps }
-->
	</template>
	<template match="tei:expan">
		<html:span>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-editLike"/>
			<apply-templates/>
		</html:span>
		<!-- [[ CSS: ]]
*.tei.expan{ Display: Inline; Font-Size: Smaller }
*.tei.expan::before{ Font-Variant-Caps: Normal; Content: "(" }
*.tei.expan::after{ Font-Variant-Caps: Normal; Content: ")" }
-->
	</template>
	<!-- Names, Dates, and Numbers -->
	<template match="tei:rs|tei:name">
		<html:u>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<apply-templates/>
		</html:u>
		<!-- [[ CSS: ]]
*.tei.rs,*.tei.name{ Display: Inline; Text-Decoration: None}
*.tei.rs{  Font-Weight: Bolder }
*.tei.name{ Font-Variant-Caps: Petite-Caps }
*.tei.stage *.tei.name,*.tei.sp *.tei.name{ Font-Variant-Caps: Inherit; Text-Transform: Uppercase }
-->
	</template>
	<template match="tei:date|tei:time">
		<choose>
			<when test="@when">
				<html:time>
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<call-template name="handle-typed"/>
					<call-template name="handle-editLike"/>
					<attribute name="datetime">
						<value-of select="@when"/>
					</attribute>
					<apply-templates/>
				</html:time>
			</when>
			<otherwise>
				<html:u>
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<call-template name="handle-typed"/>
					<call-template name="handle-editLike"/>
					<apply-templates/>
				</html:u>
			</otherwise>
		</choose>
		<!-- [[ CSS: ]]
*.tei.date,*.tei.time{ Display: Inline; Font-Variant-Caps: Petite-Caps; Text-Decoration: None }
-->
	</template>
	<template match="tei:num">
		<choose>
			<when test="@value">
				<html:data>
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<call-template name="handle-typed"/>
					<attribute name="value">
						<value-of select="@value"/>
					</attribute>
					<apply-templates/>
				</html:data>
			</when>
			<otherwise>
				<html:span>
					<call-template name="handle-tei"/>
					<call-template name="handle-typed"/>
					<apply-templates/>
				</html:span>
			</otherwise>
		</choose>
		<!-- [[ CSS: ]]
*.tei.num{ Display: Inline; Font-Variant-Numeric: Proportional-Nums Lining-Nums }
-->
	</template>
	<!-- Lists -->
	<template match="tei:list">
		<html:section>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<apply-templates select="tei:head"/>
			<choose>
				<when test="@type='gloss'">
					<html:dl>
						<for-each select="tei:label|tei:item">
							<choose>
								<when test="self::tei:label">
									<html:dt>
										<call-template name="handle-id"/>
										<call-template name="handle-tei"/>
										<call-template name="handle-typed"/>
										<call-template name="handle-placement"/>
										<apply-templates/>
									</html:dt>
								</when>
								<otherwise>
									<html:dd>
										<call-template name="handle-id"/>
										<call-template name="handle-tei"/>
										<apply-templates/>
									</html:dd>
								</otherwise>
							</choose>
						</for-each>
					</html:dl>
				</when>
				<when test="@type='instructions' or @type='litany' or @type='syllogism'">
					<html:ol>
						<apply-templates select="tei:item"/>
					</html:ol>
				</when>
				<otherwise>
					<html:ul>
						<apply-templates select="tei:item"/>
					</html:ul>
				</otherwise>
			</choose>
		</html:section>
		<!-- [[ CSS: ]]
*.tei.list{ Display: Block; Margin-Block: .75EM }
*.tei.list>*.tei.head{ Margin-Block: 1.5EM .75EM }
*.tei.list[data\2D-t-e-i_type=gloss]{ Columns: 17EM }
*.tei.list[data\2D-t-e-i_type=gloss]>.tei.head{ Column-Span: All }
*.tei.list>dl,*.tei.list>ol,*.tei.list>ul{ Display: Grid; Grid-Template-Columns: Auto Auto; Margin-Block: 0; Margin-Inline: Auto; Padding: 0; Max-Inline-Size: Max-Content }
*.tei.list>dl{ Gap: 0 1.5EM }
*.tei.list>dl>*.tei.label{ Grid-Column: 1 / Span 1 }
*.tei.list>dl>*.tei.item{ Grid-Column: 2 / Span 1; Margin: 0; Padding: 0 }
*.tei.list>dl>*.tei.item::before{ Content: None }
*.tei.list>ol>*.tei.item,*.tei.list>ul>*.tei.item{ Display: Contents }
*.tei.list>ol>*.tei.item::before,*.tei.list>ul>*.tei.item::before{ Display: Block; Grid-Column: 1 / Span 1; Text-Align: End; Text-Align-Last: Auto }
-->
	</template>
	<template match="tei:item">
		<html:li>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<html:div>
				<apply-templates/>
			</html:div>
		</html:li>
		<!-- [[ CSS: ]]
*.tei.item{ Display: Block }
*.tei.item::before{ Font-Weight: Bolder }
*.tei.item::before{ Content: "⁜  " }
*.tei.item[data\2D-t-e-i_n]::before{ Content: Attr(data\2D-t-e-i_n) ".  " }
-->
	</template>
	<!-- Bibliographic Citations -->
	<template match="tei:listBibl">
		<html:section>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<apply-templates select="tei:head"/>
			<html:ul>
				<for-each select="tei:bibl">
					<html:li>
						<call-template name="handle-id"/>
						<call-template name="handle-tei"/>
						<call-template name="handle-docStatus"/>
						<apply-templates/>
					</html:li>
				</for-each>
			</html:ul>
		</html:section>
		<!-- [[ CSS: ]]
*.tei.listBibl{ Display: Block; Margin-Block: 1.5EM }
*.tei.listBibl>ul{ Display: Block; Margin: 0; Padding-Inline: 3EM 0; Text-Align: Start; Text-Align-Last: Auto }
*.tei.listBibl>ul>li.tei.bibl{ Display: Block; Margin: 0; Text-Indent: -3EM }
*.tei.listBibl>ul>li.tei.bibl>*{ Text-Indent: 0 }
*.tei.listBibl>ul>li.tei.bibl>*.tei.p{ Margin-Block: 1.5EM }
*.tei.teiHeader *.tei.listBibl{ Margin-Block: 0 }
-->
	</template>
	<template match="tei:bibl|tei:biblScope">
		<html:span>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<if test="tei:bibl">
				<call-template name="handle-docStatus"/>
			</if>
			<apply-templates/>
		</html:span>
		<!-- [[ CSS: ]]
*.tei.bibl,*.tei.biblScope{ Display: Inline }
-->
	</template>
	<template match="tei:author|tei:editor|tei:publisher|tei:pubPlace">
		<html:span>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<choose>
				<when test="@ref">
					<html:a class="tei ref" href="{@ref}">
						<apply-templates/>
					</html:a>
				</when>
				<otherwise><apply-templates/></otherwise>
			</choose>
		</html:span>
		<!-- [[ CSS: ]]
*.tei.author,*.tei.editor,*.tei.publisher,*.tei.pubPlace{ Display: Inline }
-->
	</template>
	<!-- Tables -->
	<template match="tei:table">
		<html:table>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<if test="tei:head">
				<html:caption>
					<for-each select="tei:head">
						<html:span>
							<call-template name="handle-id">
								<with-param name="force">head</with-param>
							</call-template>
							<call-template name="handle-tei"/>
							<call-template name="handle-typed"/>
							<call-template name="handle-placement"/>
							<apply-templates/>
							<html:br/>
						</html:span>
					</for-each>
				</html:caption>
			</if>
			<html:tbody>
				<apply-templates select="tei:row"/>
			</html:tbody>
		</html:table>
		<!-- [[ CSS: ]]
*.tei.table{ Display: Table; Margin-Block: .75EM; Margin-Inline: Auto; Border-Collapse: Separate; Border-Spacing: .75EM .5EM; Caption-Side: Bottom }
*.tei.table>caption{ Font-Size: Smaller; Font-Variant-Caps: Small-Caps }
*.tei.table>caption>*.tei.head{ Margin-Block: 0; Border-Block-Start: Thin Solid; Padding-Block: .5EM 0; Font-Size: Inherit; Line-Height: 1 }
*.tei.table>caption>*.tei.head::before{ Display: Inline; Margin-Inline: 0 .75EM; Font-Size: Inherit; Font-Weight: Bolder }
-->
	</template>
	<template match="tei:row">
		<html:tr>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<apply-templates/>
		</html:tr>
		<!-- [[ CSS: ]]
*.tei.row{ Display: Table-Row }
-->
	</template>
	<template match="tei:cell">
		<choose>
			<when test="@role='label' or ../@role='label'">
				<html:th data--t-e-i_role="{@role}">
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<choose>
						<when test="@rows">
							<attribute name="rowspan">
								<value-of select="@rows"/>
							</attribute>
						</when>
						<when test="../@rows">
							<attribute name="rowspan">
								<value-of select="../@rows"/>
							</attribute>
						</when>
					</choose>
					<if test="@cols">
						<attribute name="colspan">
							<value-of select="@cols"/>
						</attribute>
					</if>
					<apply-templates/>
				</html:th>
			</when>
			<otherwise>
				<html:td>
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<if test="@role">
						<attribute name="data--t-e-i_role">
							<value-of select="@role"/>
						</attribute>
					</if>
					<choose>
						<when test="@rows">
							<attribute name="rowspan">
								<value-of select="@rows"/>
							</attribute>
						</when>
						<when test="../@rows">
							<attribute name="rowspan">
								<value-of select="../@rows"/>
							</attribute>
						</when>
					</choose>
					<if test="@cols">
						<attribute name="colspan">
							<value-of select="@cols"/>
						</attribute>
					</if>
					<apply-templates/>
				</html:td>
			</otherwise>
		</choose>
		<!-- [[ CSS: ]]
*.tei.cell{ Display: Table-Cell; Padding: 0 }
*.tei.cell[data\2D-t-e-i_role=label]{ Font-Weight: Bolder; Text-Align: Center; Text-Align-Last: Auto }
-->
	</template>
	<!-- Figures and Graphics -->
	<template match="tei:graphic">
		<html:img src="{@url}">
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<attribute name="alt">
				<choose>
					<when test="tei:desc">
						<value-of select="tei:desc"/>
					</when>
					<when test="ancestor::tei:figure/tei:figDesc">
						<value-of select="ancestor::tei:figure/tei:figDesc"/>
					</when>
				</choose>
			</attribute>
			<if test="not(starts-with(@width, '-') or contains(@width, '.')) and substring(@width, string-length(@width)-1)='px'">
				<attribute name="width">
					<choose>
						<when test="starts-with(@width, '+')">
							<value-of select="substring(@width, 2, string-length(@width)-3)"/>
						</when>
						<otherwise>
							<value-of select="substring(@width, 1, string-length(@width)-2)"/>
						</otherwise>
					</choose>
				</attribute>
			</if>
			<if test="not(starts-with(@height, '-') or contains(@height, '.')) and substring(@height, string-length(@height)-1)='px'">
				<attribute name="height">
					<choose>
						<when test="starts-with(@height, '+')">
							<value-of select="substring(@height, 2, string-length(@height)-3)"/>
						</when>
						<otherwise>
							<value-of select="substring(@height, 1, string-length(@height)-2)"/>
						</otherwise>
					</choose>
				</attribute>
			</if>
		</html:img>
		<!-- [[ CSS: ]]
*.tei.graphic{ Display: Inline-Block }
*.tei.figure>*.tei.graphic{ Display: Block; Margin: Auto }
-->
	</template>
	<template match="tei:figure">
		<html:figure>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<call-template name="handle-placement"/>
			<apply-templates select="*[not(self::tei:head)]"/>
			<if test="tei:head">
				<html:figcaption>
					<for-each select="tei:head">
						<html:span>
							<call-template name="handle-id">
								<with-param name="force">head</with-param>
							</call-template>
							<call-template name="handle-tei"/>
							<call-template name="handle-typed"/>
							<call-template name="handle-placement"/>
							<apply-templates/>
							<html:br/>
						</html:span>
					</for-each>
				</html:figcaption>
			</if>
		</html:figure>
		<!-- [[ CSS: ]]
*.tei.figure{ Display: Block; Margin-Block: .75EM; Margin-Inline: Auto; Max-Inline-Size: Max-Content }
*.tei.figure>figcaption{ Margin-Block: .75EM 0; Font-Size: Inherit; Font-Variant-Caps: Small-Caps }
*.tei.figure>figcaption>*.tei.head{ Margin-Block: 0; Border-Block-Start: Thin Solid; Padding-Block: .5EM 0; Font-Size: Smaller; Line-Height: 1 }
*.tei.figure>figcaption>*.tei.head::before{ Display: Inline; Margin-Inline: 0 .75EM; Font-Size: Inherit; Font-Weight: Bolder }
-->
	</template>
	<!-- Interpretation and Analysis -->
	<template match="tei:s|tei:w|tei:pc">
		<html:span>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<call-template name="handle-fragmentable"/>
			<apply-templates/>
		</html:span>
		<!-- [[ CSS: ]]
*.tei.s,*.tei.w,*.tei.pc{ Display: Inline }
*.tei.pc{ White-Space: NoWrap }
*.tei.pc.terminal::after,*.tei.s:Not(:Last-Child)>*.tei.pc:Last-Child::after{ Display: Inline-Block; Text-Decoration: Inherit; Content: " " }
-->
	</template>
	<template match="tei:interp|tei:interpGrp">
		<html:span>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<if test="@type">
				<attribute name="data--t-e-i_type">
					<value-of select="@type"/>
				</attribute>
			</if>
			<apply-templates/>
		</html:span>
		<!-- [[ CSS: ]]
*.tei.interp,*.tei.interpGrp{ Display: Inline }
-->
	</template>
	<!-- Technical Documentation -->
	<template match="tei:eg|tei:formula">
		<html:i>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<apply-templates/>
		</html:i>
		<!-- [[ CSS: ]]
*.tei.eg{ Display: Block; Margin-Block: .75EM; Margin-Inline: Auto; Border-Inline-Start: .5CH Solid; Padding-Inline: 1.5CH 0; Max-Inline-Size: 71CH; Overflow: Auto; Font-Style: Inherit }
*.tei.p>*.tei.eg,*.tei.lg>*.tei.eg{ Display: Inline; Margin: 0; Border: 0; Padding: 0 }
*.tei.p>*.tei.eg::before,*.tei.lg>*.tei.eg::before{ Font-Variant-Caps: Normal; Content: "‹ " }
*.tei.p>*.tei.eg::after,*.tei.lg>*.tei.eg::after{ Font-Variant-Caps: Normal; Content: " ›" }
*.tei.formula{ Display: Inline }
-->
	</template>
	<template match="tei:code">
		<html:code>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<if test="@lang">
				<attribute name="data--t-e-i_lang">
					<value-of select="@lang"/>
				</attribute>
			</if>
			<apply-templates/>
		</html:code>
		<!-- [[ CSS: ]]
*.tei.code{ Display: Block; Margin-Block: .75EM; Margin-Inline: Auto; Border-Inline-Start: .5CH Solid; Padding-Inline: 1.5CH 0; Max-Inline-Size: 71CH; Overflow: Auto; Font-Family: Monospace; White-Space: Break-Spaces }
*.tei.p>*.tei.code,*.tei.lg>*.tei.code{ Display: Inline; Margin: 0; Border: 0; Padding: 0 }
-->
	</template>
	<template match="tei:ident">
		<html:var>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<apply-templates/>
		</html:var>
		<!-- [[ CSS: ]]
*.tei.ident{ Display: Inline; Font-Variant-Caps: Petite-Caps }
-->
	</template>
	<template match="tei:gi|tei:att">
		<html:var>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<if test="@scheme">
				<attribute name="data--t-e-i_scheme">
					<value-of select="@scheme"/>
				</attribute>
			</if>
			<apply-templates/>
		</html:var>
		<!-- [[ CSS: ]]
*.tei.gi{ Display: Inline; Font-Style: Inherit }
*.tei.gi::before{ Content: "\3C" }
*.tei.gi::after{ Content: ">" }
*.tei.att{ Display: Inline; Font-Family: Monospace; Font-Style: Inherit }
-->
	</template>
	<template match="tei:val">
		<html:code>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<apply-templates/>
		</html:code>
		<!-- [[ CSS: ]]
*.tei.val{ Display: Inline; Font-Family: Inherit; White-Space: Break-Spaces }
*.tei.val::before,*.tei.val::after{ Content: "\"" }
-->
	</template>
	<template match="tei:divGen">
		<variable name="contents">
			<tei:list>
				<if test="@type='index'">
					<attribute name="type">gloss</attribute>
				</if>
				<choose>
					<when test="@type='index'">
						<call-template name="generate-index">
							<with-param name="indices" select="ancestor::tei:TEI//*[not(self::tei:index)]/tei:index[string(@indexName)=string(current()/@subtype)]"/>
						</call-template>
					</when>
					<when test="@type='toc'">
						<choose>
							<when test="ancestor::tei:body">
								<call-template name="generate-toc">
									<with-param name="divs" select="ancestor::tei:body/tei:div|ancestor::tei:body/tei:divGen"/>
								</call-template>
							</when>
							<otherwise>
								<call-template name="generate-toc"/>
							</otherwise>
						</choose>
					</when>
					<when test="@type='figlist'">
						<for-each select="//tei:figure[tei:head]">
							<tei:item>
								<apply-templates select="." mode="list"/>
							</tei:item>
						</for-each>
					</when>
					<when test="@type='tablist'">
						<for-each select="//tei:table[tei:head]">
							<tei:item>
								<apply-templates select="." mode="list"/>
							</tei:item>
						</for-each>
					</when>
				</choose>
			</tei:list>
		</variable>
		<html:nav>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<html:div>
				<apply-templates select="tei:head"/>
				<apply-templates select="exsl:node-set($contents)"/>
			</html:div>
		</html:nav>
		<!-- [[ CSS: ]]
*.tei.divGen{ Display: Block; Position: Relative; Break-Before: Page; Margin-Block: 1.5EM; Font-Variant-Numeric: Tabular-Nums Lining-Nums; Text-Align: Start; Text-Align-Last: Auto }
*.tei.divGen[data\2D-t-e-i_n]::before{ Position: Absolute; Box-Sizing: Border-Box; Inset-Block-Start: 0; Inset-Inline-End: -3EM; Border: Thin Solid; Padding-Inline: .25EM; Min-Inline-Size: 2.5EM; Color: Var(\2D-GreyText); Background: Var(\2D-Background); Font-Variant-Numeric: Tabular-Nums Lining-Nums; Text-Align: Center; Text-Align-Last: Auto; Text-Indent: 0; White-Space: Pre; Content: "§" Attr(data\2D-t-e-i_n) }
*.tei.divGen *.tei.ref{ Color: Inherit; Text-Decoration: Underline }
*.tei.divGen *.tei.list *.tei.list{ Margin-Block: 0; Columns: Auto }
*.tei.divGen *.tei.list>dl{ Display: Block; Margin: 0 }
*.tei.divGen *.tei.list>ul{ Display: Block; Margin: 0; Width: 100%; Max-Inline-Size: None }
*.tei.divGen *.tei.list>dl>*.tei.label::after{ Content: ":—" }
*.tei.divGen *.tei.list>dl>*.tei.label>*.tei.term{ Font-Weight: Inherit }
*.tei.divGen *.tei.list *.tei.list>dl>*.tei.label{ Font-Weight: Inherit; Font-Variant-Caps: Small-Caps }
*.tei.divGen *.tei.list *.tei.list *.tei.list>dl>*.tei.label{ Font-Variant-Caps: Inherit }
*.tei.divGen *.tei.list>dl>*.tei.item{ Padding-Inline: 3EM 0; Text-Indent: -1.5EM }
*.tei.divGen *.tei.list>dl>*.tei.item>*{ Text-Indent: 0 }
*.tei.divGen *.tei.list>ul>*.tei.item::before{ Content: None }
*.tei.divGen *.tei.list[data\2D-t-e-i_type=gloss]{ Display: Block; Margin: 0 }
*.tei.divGen *.tei.list[data\2D-t-e-i_type=gloss] *.tei.list[data\2D-t-e-i_type=gloss]{ Margin-Inline: -1.5EM 0 }
*.tei.divGen *.tei.list[data\2D-t-e-i_type=index],*.tei.divGen *.tei.list[data\2D-t-e-i_type=index]>ul,*.tei.divGen *.tei.list[data\2D-t-e-i_type=index]>ul>*.tei.item>div{ Display: Inline; Margin: 0 }
*.tei.divGen *.tei.list[data\2D-t-e-i_type=index]>ul>*.tei.item:Not(:Last-Child)::after{ Content: ", " }
*.tei.divGen *.tei.list:Not([data\2D-t-e-i_type=index])>ul>*.tei.item>div>*{ Display: Flex }
*.tei.divGen *.tei.list:Not([data\2D-t-e-i_type=index])>ul>*.tei.item>div>*.tei.hi{ Margin-Block: .75EM 0; Font-Size: Larger; Font-Weight: Bolder; Font-Variant-Caps: Small-Caps; Text-Decoration: None }
*.tei.divGen *.tei.list:Not([data\2D-t-e-i_type=index])>ul>*.tei.item>div>*.tei.hi:Last-Child,*.tei.divGen *.tei.list:Not([data\2D-t-e-i_type=index])>ul>*.tei.item>div>*.tei.hi~*:Last-Child { Margin-Block-End: .75EM }
*.tei.divGen *.tei.list:Not([data\2D-t-e-i_type=index])>ul>*.tei.item>div>*::after{ Display: Block; Order: 2; Margin: Auto; Border-Block-End: Thin Dotted; Flex: Auto; Content: "" }
*.tei.divGen *.tei.list:Not([data\2D-t-e-i_type=index])>ul>*.tei.item>div>*.tei.hi::after{ Border-Block-End: 2PX Dotted }
*.tei.divGen *.tei.list:Not([data\2D-t-e-i_type=index])>ul>*.tei.item>div>*>*.tei.seg{ Display: Block; Order: 1; Margin-Block: 0 Auto; Margin-Inline: 0 .375EM }
*.tei.divGen *.tei.list:Not([data\2D-t-e-i_type=index])>ul>*.tei.item>div>*>*.tei.seg:First-Child{ Font-Weight: Bolder; Font-Variant-Numeric: Proportional-Nums Oldstyle-Nums }
*.tei.divGen *.tei.list:Not([data\2D-t-e-i_type=index])>ul>*.tei.item>div>*>*.tei.seg:First-Child>*.tei.ref{ Font-Weight: Lighter; Font-Variant-Numeric: Proportional-Nums Lining-Nums }
*.tei.divGen *.tei.list:Not([data\2D-t-e-i_type=index])>ul>*.tei.item>div>*>*.tei.seg+*.tei.seg{ Order: 3; Margin-Block: Auto 0; Margin-Inline: .375EM 0 }
*.tei.divGen *.tei.list:Not([data\2D-t-e-i_type=index])>ul>*.tei.item>div>*.tei.list{ Margin-Inline: 1.5EM 0 }
*.tei.divGen *.tei.list:Not([data\2D-t-e-i_type=index])>ul>*.tei.item>div>*.tei.hi~*.tei.list{ Margin-Inline: 0 }
*.tei.divGen[data\2D-t-e-i_type=figlist] *.tei.list>ul>*.tei.item>div>*>*.tei.seg:First-Child,*.tei.divGen[data\2D-t-e-i_type=tablist] *.tei.list>ul>*.tei.item>div>*>*.tei.seg:First-Child{ Font-Variant-Caps: All-Small-Caps }
*.tei.divGen[data\2D-t-e-i_type=figlist] *.tei.list>ul>*.tei.item>div>*>*.tei.seg:First-Child>*.tei.ref,*.tei.divGen[data\2D-t-e-i_type=tablist] *.tei.list>ul>*.tei.item>div>*>*.tei.seg:First-Child>*.tei.ref{ Font-Weight: Lighter; Font-Variant-Caps: Normal }
*.tei.text>div>*>div>*.tei.divGen{ Margin-Block: 3EM }
-->
	</template>
	<template match="*[tei:head]" mode="list">
		<variable name="contents">
			<tei:seg>
				<choose>
					<when test="@n">
						<value-of select="@n"/>
						<tei:pc rend="terminal">.</tei:pc>
						<text> </text>
					</when>
					<when test="tei:head/@n">
						<value-of select="tei:head/@n"/>
						<tei:pc rend="terminal">.</tei:pc>
						<text> </text>
					</when>
				</choose>
				<tei:ref>
					<attribute name="target">
						<choose>
							<when test="@xml:id">
								<value-of select="concat('#', @xml:id)"/>
							</when>
							<when test="tei:head/@xml:id">
								<value-of select="concat('#', tei:head/@xml:id)"/>
							</when>
							<otherwise>
								<value-of select="concat('#TEI.head.', generate-id(tei:head))"/>
							</otherwise>
						</choose>
					</attribute>
					<copy-of select="tei:head/node()"/>
				</tei:ref>
			</tei:seg>
			<if test="tei:head/ancestor-or-self::*/preceding-sibling::*/descendant-or-self::tei:pb[@n]">
				<tei:seg>
					<value-of select="tei:head/ancestor-or-self::*[preceding-sibling::*/descendant-or-self::tei:pb[@n]][1]/preceding-sibling::*[descendant-or-self::tei:pb[@n]][1]/descendant-or-self::tei:pb[@n][last()]/@n"/>
				</tei:seg>
			</if>
		</variable>
		<choose>
			<when test="self::tei:body">
				<tei:hi>
					<copy-of select="$contents"/>
				</tei:hi>
			</when>
			<otherwise>
				<tei:seg>
					<copy-of select="$contents"/>
				</tei:seg>
			</otherwise>
		</choose>
	</template>
	<template match="tei:index">
		<html:span>
			<call-template name="handle-id">
				<with-param name="force">index</with-param>
			</call-template>
			<call-template name="handle-tei"/>
			<if test="@indexName">
				<attribute name="data--t-e-i_index-name">
					<value-of select="@indexName"/>
				</attribute>
			</if>
		</html:span>
	</template>
	<template match="tei:address">
		<html:address>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<apply-templates/>
		</html:address>
		<!-- [[ CSS: ]]
*.tei.address{ Display: Block; Margin-Block: .75EM; Margin-Inline: Auto; Padding-Inline: .3EM; Max-Inline-Size: Max-Content; Text-Align: Start; Text-Align-Last: Auto }
-->
	</template>
	<template match="tei:addrLine">
		<html:span>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<apply-templates/>
			<html:br/>
		</html:span>
		<!-- [[ CSS: ]]
*.tei.addrLine{ Display: Block; Margin: 0 }
-->
	</template>
	<!-- Front and Back Matter -->
	<template match="tei:titlePage">
		<html:header>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<apply-templates/>
		</html:header>
		<!-- [[ CSS: ]]
*.tei.titlePage{ Display: Block; Margin-Block: 3EM; Margin-Inline: -3EM; Border: Thin Solid; Padding-Block: 1.5EM; Padding-Inline: 3EM; Text-Align: Center; Text-Align-Last: Auto }
*.tei.titlePage>*{ Display: Block; Margin-Inline: Auto; Max-Inline-Size: Max-Content }
*.tei.titlePage>*:Not(:First-Child){ Margin-Block-Start: 1.5EM }
-->
	</template>
	<template match="tei:docTitle">
		<html:hgroup>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<apply-templates/>
		</html:hgroup>
		<!-- [[ CSS: ]]
*.tei.docTitle{ Display: Block; Font-Size: Larger; Font-Weight: Bolder }
*.tei.docTitle:Not(:First-Child){ Border-Block-Start: Thin Solid }
*.tei.docTitle:Not(:Last-Child){ Border-Block-End: Thin Solid }
-->
	</template>
	<template match="tei:titlePart">
		<html:h1>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<apply-templates/>
		</html:h1>
		<!-- [[ CSS: ]]
*.tei.titlePart{ Display: Block; Margin-Block: 0 .75EM; Font-Size: Larger; Font-Weight: Bolder; Font-Variant-Caps: Small-Caps; Line-Height: 1; Text-Transform: Uppercase }
*.tei.titlePart:Not(:First-Child){ Margin-Block-Start: 1.5EM }
*.tei.titlePart[data\2D-t-e-i_type]:Not([data\2D-t-e-i_type=main]){ Font-Size: Inherit; Font-Weight: Inherit; Text-Transform: None }
*.tei.titlePart[data\2D-t-e-i_type][data\2D-t-e-i_type=sub]:Not(:First-Child){ Margin-Block-Start: .75EM }
*.tei.titlePart[data\2D-t-e-i_type][data\2D-t-e-i_type=alt]{ Font-Weight: Lighter }
*.tei.titlePart[data\2D-t-e-i_type][data\2D-t-e-i_type=short]{ Font-Size: Smaller; Text-Transform: Uppercase }
*.tei.titlePart[data\2D-t-e-i_type][data\2D-t-e-i_type=short]::before{ Font-Variant-Caps: Normal; Content: "(" }
*.tei.titlePart[data\2D-t-e-i_type][data\2D-t-e-i_type=short]::after{ Font-Variant-Caps: Normal; Content: ")" }
*.tei.titlePart[data\2D-t-e-i_type][data\2D-t-e-i_type=desc]{ Font-Size: Smaller; Font-Weight: Lighter; Line-Height: 1.5 }
-->
	</template>
	<template match="tei:byline|tei:docEdition|tei:docImprint|tei:epigraph|tei:salute|tei:signed|tei:dateline|tei:argument|tei:cit|tei:imprimatur">
		<html:div>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<apply-templates/>
		</html:div>
		<!-- [[ CSS: ]]
*.tei.byline,*.tei.docEdition,*.tei.docImprint,*.tei.epigraph,*.tei.salute,*.tei.signed,*.tei.dateline,*.tei.argument,*.tei.cit,*.tei.imprimatur{ Display: Block }
*.tei.docEdition,*.tei.epigraph,*.tei.imprimatur{ Font-Weight: Bolder; Font-Variant-Caps: Small-Caps }
*.tei.docImprint{ Font-Size: Smaller; Font-Variant-Caps: Small-Caps }
*.tei.epigraph{ Margin-Inline: Auto; Max-Inline-Size: Max-Content }
*.tei.signed,*.tei.dateline{ Text-Align: End; Text-Align-Last: Auto }
*.tei.dateline{ Font-Variant-Caps: Small-Caps }
*.tei.cit{ Margin-Block: 1.5EM; Margin-Inline: Auto; Max-Inline-Size: Max-Content }
*.tei.cit>*.tei.bibl{ Display: Block; Margin-Block: .75EM; Font-Size: Smaller; Font-Variant-Caps: Small-Caps; Text-Align: End; Text-Align-Last: Auto }
-->
	</template>
	<template match="tei:docAuthor">
		<html:span>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<choose>
				<when test="@ref">
					<html:a class="tei ref" href="{@ref}">
						<apply-templates/>
					</html:a>
				</when>
				<otherwise><apply-templates/></otherwise>
			</choose>
		</html:span>
		<!-- [[ CSS: ]]
*.tei.docAuthor{ Display: Block; Font-Size: Larger }
-->
	</template>
	<template match="tei:docDate">
		<choose>
			<when test="@when">
				<html:time>
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<attribute name="datetime">
						<value-of select="@when"/>
					</attribute>
					<apply-templates/>
				</html:time>
			</when>
			<otherwise>
				<html:u>
					<call-template name="handle-id"/>
					<call-template name="handle-tei"/>
					<apply-templates/>
				</html:u>
			</otherwise>
		</choose>
		<!-- [[ CSS: ]]
*.tei.docDate{ Font-Size: Smaller; Font-Variant-Caps: Small-Caps; Text-Decoration: None }
-->
	</template>
	<template match="tei:opener">
		<html:header>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<apply-templates/>
		</html:header>
		<!-- [[ CSS: ]]
*.tei.opener{ Display: Block; Text-Align: Start; Text-Align-Last: Auto }
-->
	</template>
	<template match="tei:closer|tei:postscript">
		<html:footer>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<apply-templates/>
		</html:footer>
		<!-- [[ CSS: ]]
*.tei.closer{ Display: Block; Text-Align: End; Text-Align-Last: Auto }
*.tei.postscript{ Display: Block }
-->
	</template>
	<!-- The Electronic Title Page -->
	<template match="tei:fileDesc|tei:encodingDesc|tei:profileDesc|tei:docStatus">
		<html:table>
			<call-template name="handle-tei"/>
			<apply-templates/>
		</html:table>
		<!-- [[ CSS: ]]
*.tei.fileDesc,*.tei.encodingDesc,*.tei.profileDesc{ Display: Table; Inline-Size: 100%; Border-Collapse: Collapse }
*.tei.fileDesc>*:Not(:Last-Child),*.tei.encodingDesc>*:Not(:Last-Child),*.tei.profileDesc>*:Not(:Last-Child){ Border-Bottom: Medium Double }
-->
	</template>
	<template match="tei:titleStmt|tei:editionStmt|tei:publicationStmt|tei:seriesStmt|tei:notesStmt|tei:langUsage|tei:textClass">
		<html:tbody>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<html:tr>
				<html:th scope="rowgroup" colspan="2">
					<value-of select="name(.)"/>
				</html:th>
			</html:tr>
			<for-each select="*">
				<html:tr>
					<choose>
						<when test=".[parent::tei:textClass][@source]">
							<variable name="source">
								<tei:ref target="{@source}">
									<value-of select="@source"/>
								</tei:ref>
							</variable>
							<html:th scope="row">
								<apply-templates select="exsl:node-set($source)"/>
							</html:th>
						</when>
						<when test="not(self::tei:p)">
							<html:th scope="row">
								<value-of select="name(.)"/>
							</html:th>
						</when>
					</choose>
					<html:td>
						<if test="self::tei:p">
							<attribute name="colspan">2</attribute>
						</if>
						<apply-templates select="."/>
					</html:td>
				</html:tr>
			</for-each>
		</html:tbody>
		<!-- [[ CSS: ]]
*.tei.titleStmt,*.tei.editionStmt,*.tei.publicationStmt,*.tei.seriesStmt,*.tei.notesStmt,*.tei.langUsage,*.tei.textClass{ Display: Table-Row-Group }
*.tei.titleStmt>tr>*,*.tei.editionStmt>tr>*,*.tei.publicationStmt>tr>*,*.tei.seriesStmt>tr>*,*.tei.notesStmt>tr>*,*.tei.langUsage>tr>*,*.tei.textClass>tr>*{ Border: Thin Var(\2D-PlainText) Solid; Padding: .25EM }
*.tei.titleStmt>tr>th,*.tei.editionStmt>tr>th,*.tei.publicationStmt>tr>th,*.tei.seriesStmt>tr>th,*.tei.notesStmt>tr>th,*.tei.langUsage>tr>th,*.tei.textClass>tr>th{ Color: Var(\2D-Background); Background: Var(\2D-PlainText); Font-Weight: Inherit; Font-Variant: Small-Caps; Text-Align: End; Text-Align-Last: Auto }
*.tei.titleStmt>tr>th[scope=rowgroup],*.tei.editionStmt>tr>th[scope=rowgroup],*.tei.publicationStmt>tr>th[scope=rowgroup],*.tei.seriesStmt>tr>th[scope=rowgroup],*.tei.notesStmt>tr>th[scope=rowgroup],*.tei.langUsage>tr>th[scope=rowgroup],*.tei.textClass>tr>th[scope=rowgroup]{ Color: Inherit; Background: Inherit; Font-Weight: Bold; Text-Align: Center; Text-Align-Last: Auto }
*.tei.titleStmt>tr>td,*.tei.editionStmt>tr>td,*.tei.publicationStmt>tr>td,*.tei.seriesStmt>tr>td,*.tei.notesStmt>tr>td,*.tei.langUsage>tr>td,*.tei.textClass>tr>td{ Text-Align: Start; Text-Align-Last: Auto }
*.tei.notesStmt>tr>td>*.tei.note{ Margin: 0; Border: None; Padding: 0; Min-Block-Size: 0 }
*.tei.notesStmt>tr>td>*.tei.note>*.tei.seg:First-Child{ Display: None }
*.tei.langUsage>tr>td>*.tei.p{ Text-Align: Justify; Text-Align-Last: Center }
*.tei.textClass>tr>th>*.tei.ref{ Color: Inherit; Overflow-Wrap: Anywhere }
-->
	</template>
	<template match="tei:sponsor|tei:funder|tei:principal|tei:respStmt|tei:resp|tei:extent|tei:distributor|tei:authority|tei:catDesc">
		<html:span>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<apply-templates/>
		</html:span>
		<!-- [[ CSS: ]]
*.tei.sponsor,*.tei.funder,*.tei.principal,*.tei.respStmt,*.tei.resp,*.tei.extent,*.tei.distributor,*.tei.authority,*.tei.catDesc{ Display: Inline }
-->
	</template>
	<template match="tei:teiHeader//tei:respStmt">
		<html:table>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<html:tbody>
				<for-each select="*">
					<html:tr>
						<html:th scope="row">
							<value-of select="name(.)"/>
						</html:th>
						<html:td><apply-templates/></html:td>
					</html:tr>
				</for-each>
			</html:tbody>
		</html:table>
		<!-- [[ CSS: ]]
*.tei.teiHeader *.tei.respStmt{ Display: Table; Inline-Size: 100%; Border-Collapse: Collapse }
*.tei.teiHeader *.tei.respStmt>tbody>tr>*{ Border: Thin Var(\2D-PlainText) Solid; Padding: .25EM }
*.tei.teiHeader *.tei.respStmt>tbody>tr>th{ Color: Var(\2D-Background); Background: Var(\2D-PlainText); Font-Weight: Inherit; Font-Variant: Small-Caps; Text-Align: End; Text-Align-Last: Auto }
*.tei.teiHeader *.tei.respStmt>tbody>tr>td{ Text-Align: Start; Text-Align-Last: Auto }
*.tei.teiHeader *.tei.respStmt>tbody>tr>td>*.tei.note{ Margin: 0; Border: None; Padding: 0; Min-Block-Size: 0 }
*.tei.teiHeader *.tei.respStmt>tbody>tr>td>*.tei.note>*.tei.seg:First-Child{ Display: None }
-->
	</template>
	<template match="tei:edition">
		<html:span>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<html:span><apply-templates/></html:span>
			<if test="self::tei:edition[@n]">
				<html:small>
					<text>(</text>
					<value-of select="@n"/>
					<text>)</text>
				</html:small>
			</if>
		</html:span>
		<!-- [[ CSS: ]]
*.tei.edition{ Display: Inline }
*.tei.edition>small{ Font-Size: Smaller }
-->
	</template>
	<template match="tei:teiHeader//tei:extent|tei:sourceDesc|tei:encodingDesc/tei:p|tei:projectDesc|tei:samplingDecl|tei:editorialDecl|tei:refsDecl|tei:classDecl|tei:creation">
		<html:tbody>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<if test="not(self::tei:p)">
				<html:tr>
					<html:th scope="rowgroup" colspan="2">
						<value-of select="name(.)"/>
					</html:th>
				</html:tr>
			</if>
			<html:tr>
				<html:td colspan="2">
					<apply-templates/>
				</html:td>
			</html:tr>
		</html:tbody>
		<!-- [[ CSS: ]]
*.tei.teiHeader *.tei.extent,*.tei.sourceDesc,*.tei.encodingDesc>*.tei.p,*.tei.projectDesc,*.tei.samplingDecl,*.tei.editorialDecl,*.tei.refsDecl,*.tei.classDecl,*.tei.creation{ Display: Table-Row-Group }
*.tei.teiHeader *.tei.extent>tr>*,*.tei.sourceDesc>tr>*,*.tei.encodingDesc>*.tei.p>tr>*,*.tei.projectDesc>tr>*,*.tei.samplingDecl>tr>*,*.tei.editorialDecl>tr>*,*.tei.refsDecl>tr>*,*.tei.classDecl>tr>*,*.tei.creation>tr>*{ Border: Thin Var(\2D-PlainText) Solid; Padding: .25EM }
*.tei.teiHeader *.tei.extent>tr>th,*.tei.sourceDesc>tr>th,*.tei.encodingDesc>*.tei.p>tr>th,*.tei.projectDesc>tr>th,*.tei.samplingDecl>tr>th,*.tei.editorialDecl>tr>th,*.tei.refsDecl>tr>th,*.tei.classDecl>tr>th,*.tei.creation>tr>th{ Font-Weight: Bold; Font-Variant: Small-Caps; Text-Align: Center; Text-Align-Last: Auto }
*.tei.teiHeader *.tei.extent>tr>td,*.tei.sourceDesc>tr>td,*.tei.encodingDesc>*.tei.p>tr>td,*.tei.projectDesc>tr>td,*.tei.samplingDecl>tr>td,*.tei.editorialDecl>tr>td,*.tei.refsDecl>tr>td,*.tei.classDecl>tr>td,*.tei.creation>tr>td{ Text-Align: Justify; Text-Align-Last: Center }
-->
	</template>
	<template match="tei:idno">
		<html:span>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-typed"/>
			<apply-templates/>
		</html:span>
		<!-- [[ CSS: ]]
*.tei.idno{ Display: Inline; Font-Variant-Numeric: Tabular-Nums Lining-Nums }
*.tei.idno[type=URI]{ Color: Var(\2D-EditorialText) }
-->
	</template>
	<template match="tei:availability">
		<html:span>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<if test="@status">
				<attribute name="data--t-e-i_status">
					<value-of select="@status"/>
				</attribute>
			</if>
			<apply-templates/>
		</html:span>
		<!-- [[ CSS: ]]
*.tei.availability{ Display: Inline }
-->
	</template>
	<template match="tei:licence">
		<html:span>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<choose>
				<when test="@target">
					<variable name="contents">
						<tei:ref target="{@target}">
							<copy-of select="node()"/>
						</tei:ref>
					</variable>
					<apply-templates select="exsl:node-set($contents)"/>
				</when>
				<otherwise><apply-templates/></otherwise>
			</choose>
		</html:span>
		<!-- [[ CSS: ]]
*.tei.licence{ Display: Inline }
-->
	</template>
	<template match="tei:taxonomy">
		<html:div>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<apply-templates select="node()[not(self::tei:category)]"/>
			<if test="tei:category">
				<html:ul>
					<apply-templates select="tei:category"/>
				</html:ul>
			</if>
		</html:div>
		<!-- [[ CSS: ]]
*.tei.taxonomy{ Display: Block; Columns: 17EM }
*.tei.taxonomy>ul{ Margin: 0; Padding: 0; }
-->
	</template>
	<template match="tei:category">
		<html:li>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<apply-templates select="node()[not(self::tei:category)]"/>
			<if test="tei:category">
				<html:ul>
					<apply-templates select="tei:category"/>
				</html:ul>
			</if>
		</html:li>
		<!-- [[ CSS: ]]
*.tei.category{ Display: Block; Margin: 0; Padding: 0 }
*.tei.category>ul{ Margin-Block-Start: 1.5EM }
-->
	</template>
	<template match="tei:language">
		<html:span>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<if test="@ident">
				<attribute name="data--t-e-i_ident">
					<value-of select="@ident"/>
				</attribute>
			</if>
			<if test="@usage">
				<attribute name="data--t-e-i_usage">
					<value-of select="@usage"/>
				</attribute>
			</if>
			<choose>
				<when test="@usage=0">
					<html:s>
						<html:u><apply-templates/></html:u>
					</html:s>
				</when>
				<when test="@usage>=80">
					<html:strong>
						<html:u><apply-templates/></html:u>
					</html:strong>
				</when>
				<when test="30>@usage">
					<html:small>
						<html:u><apply-templates/></html:u>
					</html:small>
				</when>
				<otherwise>
					<html:span>
						<html:u><apply-templates/></html:u>
					</html:span>
				</otherwise>
			</choose>
			<if test="@usage">
				<html:small>
					<text> (</text>
					<value-of select="@usage"/>
					<text>%)</text>
				</html:small>
			</if>
		</html:span>
		<!-- [[ CSS: ]]
*.tei.language{ Display: Inline }
*.tei.language>strong{ Font-Weight: Bolder }
*.tei.language>small,*.tei.language>s{ Color: Var(\2D-GreyText); Font-Size: Inherit }
*.tei.language>s{ Text-Decoration: Line-Through }
*.tei.language>*+small{ Color: Inherit; Font-Size: Smaller }
*.tei.language>*>u{ Font-Variant-Caps: Small-Caps; Text-Decoration: None }
-->
	</template>
	<template match="tei:classCode|tei:catRef">
		<html:span>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<choose>
				<when test="self::tei:catRef">
					<variable name="target">
						<tei:ref>
							<choose>
								<when test="contains(@target, ' ')">
									<attribute name="target">
										<value-of select="substring-before(@target, ' ')"/>
									</attribute>
									<value-of select="substring-before(@target, ' ')"/>
								</when>
								<otherwise>
									<attribute name="target">
										<value-of select="@target"/>
									</attribute>
									<value-of select="@target"/>
								</otherwise>
							</choose>
						</tei:ref>
					</variable>
					<apply-templates select="exsl:node-set($target)"/>
				</when>
				<otherwise><apply-templates/></otherwise>
			</choose>
		</html:span>
		<!-- [[ CSS: ]]
*.tei.classCode{ Display: Inline }
*.tei.classCode>small{ Font-Size: Smaller }
-->
	</template>
	<template match="tei:keywords|tei:revisionDesc">
		<variable name="list">
			<choose>
				<when test="tei:list">
					<copy-of select="tei:list"/>
				</when>
				<otherwise>
					<tei:list>
						<for-each select="*">
							<tei:item><copy-of select="."/></tei:item>
						</for-each>
					</tei:list>
				</otherwise>
			</choose>
		</variable>
		<html:div>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<if test="self::tei:revisionDesc">
				<call-template name="handle-docStatus"/>
				<html:table>
					<html:tbody>
						<html:tr>
							<html:th>status</html:th>
							<html:td>
								<choose>
									<when test="@status">
										<value-of select="@status"/>
									</when>
									<otherwise>draft</otherwise>
								</choose>
							</html:td>
						</html:tr>
					</html:tbody>
				</html:table>
			</if>
			<apply-templates select="exsl:node-set($list)"/>
		</html:div>
		<!-- [[ CSS: ]]
*.tei.keywords,*.tei.revisionDesc{ Display: Block }
*.tei.keywords>*.tei.list{ Margin: 0 }
*.tei.keywords>*.tei.list>ul{ Display: Block; Margin: 0 }
*.tei.keywords>*.tei.list>ul>*.tei.item{ Display: Inline Grid; Grid-Template-Columns: Auto Auto Auto }
*.tei.keywords>*.tei.list>ul>*.tei.item::before{ Content: "⁜ " }
*.tei.keywords>*.tei.list>ul>*.tei.item:Not(:Last-Child)::after{ Display: Block; White-Space: Pre; Content: ", " }
*.tei.revisionDesc>*.tei.list{ Margin: 0; Border-Block-End: Thin Solid; Border-Inline: Thin Solid; Padding: .25EM }
*.tei.revisionDesc>table{ Inline-Size: 100%; Border-Collapse: Collapse }
*.tei.revisionDesc>table>tbody>tr>*{ Width: 50%; Border: Thin Var(\2D-PlainText) Solid; Padding: .25EM }
*.tei.revisionDesc>table>tbody>tr>th{ Color: Var(\2D-Background); Background: Var(\2D-PlainText); Font-Weight: Inherit; Font-Variant: Small-Caps; Text-Align: End; Text-Align-Last: Auto }
*.tei.revisionDesc>table>tbody>tr>td{ Text-Align: Start; Text-Align-Last: Auto }
-->
	</template>
	<template match="tei:change">
		<html:div>
			<call-template name="handle-id"/>
			<call-template name="handle-tei"/>
			<call-template name="handle-docStatus"/>
			<call-template name="handle-typed"/>
			<apply-templates/>
		</html:div>
		<!-- [[ CSS: ]]
*.tei.change{ Display: Block }
-->
	</template>
</stylesheet>
