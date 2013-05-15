<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="../../common.xsl"/>
<xsl:output method="html" indent="no" media-type="text/plain" encoding="utf-8"/>
<xsl:param name="package"/>
<xsl:variable name="space" select="' '"/>
<xsl:variable name="empty" select="''"/>
<xsl:variable name="empty-line" select="'&#x0A;'"/>

<xsl:template match="/">
   <xsl:apply-templates select="/model"/>
</xsl:template>

<xsl:template match="model">
   <xsl:value-of select="$empty"/>package <xsl:value-of select="$package"/>;<xsl:value-of select="$empty-line"/>
   <xsl:value-of select="$empty-line"/>
   <xsl:call-template name='import-list'/>
   <xsl:value-of select="$empty"/>public class DefaultMaker implements IVisitor, IVisitorEnabled {<xsl:value-of select="$empty-line"/>
   <xsl:call-template name='method-common'/>
   <xsl:call-template name='method-visit'/>
   <xsl:value-of select="$empty"/>}<xsl:value-of select="$empty-line"/>
</xsl:template>

<xsl:template name="import-list">
   <xsl:value-of select="$empty"/>import java.util.Stack;<xsl:value-of select="$empty-line"/>
   <xsl:value-of select="$empty-line"/>
   <xsl:if test="//entity[@all-children-in-sequence='true']">
      <xsl:value-of select="$empty"/>import <xsl:value-of select="/model/@model-package"/>.BaseEntity;<xsl:value-of select="$empty-line"/>
   </xsl:if>
   <xsl:value-of select="$empty"/>import <xsl:value-of select="/model/@model-package"/>.IVisitor;<xsl:value-of select="$empty-line"/>
   <xsl:value-of select="$empty"/>import <xsl:value-of select="/model/@model-package"/>.IVisitorEnabled;<xsl:value-of select="$empty-line"/>
   <xsl:if test="entity/any">
      <xsl:value-of select="$empty"/>import <xsl:value-of select="entity/any/@entity-package"/>.Any;<xsl:value-of select="$empty-line"/>
   </xsl:if>
   <xsl:for-each select="entity">
      <xsl:sort select="@entity-class"/>

      <xsl:value-of select="$empty"/>import <xsl:value-of select="@entity-package"/>.<xsl:value-of select='@entity-class'/>;<xsl:value-of select="$empty-line"/>
   </xsl:for-each>
   <xsl:value-of select="$empty-line"/>
</xsl:template>

<xsl:template name="method-common">
   <xsl:variable name="root" select="entity[@root='true']"/>
   private <xsl:value-of select="$root/@class-name"/><xsl:value-of select="$space"/><xsl:value-of select="$root/@field-name"/>;

   private IVisitor m_visitor = this;

   private DefaultLinker m_linker = new DefaultLinker(true);

   private Stack<xsl:call-template name="lt"/>Object<xsl:call-template name="gt"/> m_objs = new Stack<xsl:call-template name="lt"/>Object<xsl:call-template name="gt"/>();

   @Override
   public void enableVisitor(IVisitor visitor) {
      m_visitor = visitor;
   }

   public <xsl:value-of select="$root/@class-name"/><xsl:value-of select="$space"/><xsl:value-of select="$root/@get-method"/>() {
      return <xsl:value-of select="$root/@field-name"/>;
   }
</xsl:template>

<xsl:template name="method-visit">
   <xsl:if test="entity/any">
      <xsl:value-of select="$empty-line"/>
      <xsl:value-of select="$empty"/>   @Override<xsl:value-of select="$empty-line"/>
      <xsl:value-of select="$empty"/>   public void <xsl:value-of select="entity/any/@visit-method"/>(Any any) {<xsl:value-of select="$empty-line"/>
      <xsl:value-of select="$empty"/>   }<xsl:value-of select="$empty-line"/>
   </xsl:if>
   <xsl:for-each select="entity">
      <xsl:sort select="@visit-method"/>
      
      <xsl:variable name="entity" select="."/>
      <xsl:value-of select="$empty-line"/>
      <xsl:value-of select="$empty"/>   @Override<xsl:value-of select="$empty-line"/>
      <xsl:value-of select="$empty"/>   public void <xsl:value-of select="@visit-method"/>(<xsl:value-of select="@entity-class"/> from) {<xsl:value-of select="$empty-line"/>
      <xsl:value-of select="$empty"/>      <xsl:value-of select="'      '"/><xsl:value-of select="@entity-class"/><xsl:value-of select="$space"/><xsl:value-of select="@param-name"/> = new <xsl:value-of select="@entity-class"/>(from.<xsl:value-of select="(attribute|element)[@key='true']/@get-method"/>());<xsl:value-of select="$empty-line"/>
      <xsl:value-of select="$empty-line"/>
      <xsl:value-of select="$empty"/>      <xsl:value-of select="'      '"/><xsl:value-of select="@param-name"/>.mergeAttributes(from);<xsl:value-of select="$empty-line"/>
      <xsl:for-each select="element">
         <xsl:choose>
            <xsl:when test="@list='true' or @set='true'">
               <xsl:value-of select="$empty"/>      <xsl:value-of select="'      '"/><xsl:value-of select="$entity/@param-name"/>.<xsl:value-of select="@get-method"/>().addAll(from.<xsl:value-of select="@get-method"/>());<xsl:value-of select="$empty-line"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$empty"/>      <xsl:value-of select="'      '"/><xsl:value-of select="$entity/@param-name"/>.<xsl:value-of select="@set-method"/>(from.<xsl:value-of select="@get-method"/>());<xsl:value-of select="$empty-line"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
      <xsl:value-of select="$empty-line"/>
      <xsl:value-of select="$empty"/>      m_objs.push(<xsl:value-of select="@param-name"/>);<xsl:value-of select="$empty-line"/>
      <xsl:value-of select="$empty-line"/>
      <xsl:choose>
         <xsl:when test="@all-children-in-sequence='true'">
            <xsl:value-of select="$empty"/>      for (BaseEntity<xsl:value-of select="'&lt;?&gt;'" disable-output-escaping="yes"/> child : <xsl:value-of select="@param-name"/>.<xsl:value-of select="@method-get-all-children-in-sequence"/>()) {<xsl:value-of select="$empty-line"/>
            <xsl:value-of select="$empty"/>         child.accept(this);<xsl:value-of select="$empty-line"/>
            <xsl:value-of select="$empty"/>      }<xsl:value-of select="$empty-line"/>
            <xsl:value-of select="$empty-line"/>
         </xsl:when>
         <xsl:when test="entity-ref">
            <xsl:for-each select="entity-ref">
               <xsl:variable name="name" select="@name"/>
               <xsl:variable name="current" select="//entity[@name=$name]"/>
               <xsl:choose>
                  <xsl:when test="@list='true'">
                     <xsl:value-of select="$empty"/>      for (<xsl:value-of select="$current/@entity-class"/><xsl:value-of select="$space"/><xsl:value-of select="@local-name-element"/> : from.<xsl:value-of select="@get-method"/>()) {<xsl:value-of select="$empty-line"/>
                     <xsl:value-of select="$empty"/>         <xsl:value-of select="'         '"/><xsl:value-of select="@local-name-element"/>.accept(m_visitor);<xsl:value-of select="$empty-line"/>
                     <xsl:value-of select="$empty"/>      }<xsl:value-of select="$empty-line"/>
                  </xsl:when>
                  <xsl:when test="@map='true'">
                     <xsl:value-of select="$empty"/>      for (<xsl:value-of select="$current/@entity-class"/><xsl:value-of select="$space"/><xsl:value-of select="@local-name-element"/> : from.<xsl:value-of select="@get-method"/>().values()) {<xsl:value-of select="$empty-line"/>
                     <xsl:value-of select="$empty"/>         <xsl:value-of select="'         '"/><xsl:value-of select="@local-name-element"/>.accept(m_visitor);<xsl:value-of select="$empty-line"/>
                     <xsl:value-of select="$empty"/>      }<xsl:value-of select="$empty-line"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$empty"/>      if (from.<xsl:value-of select="@get-method"/>() != null) {<xsl:value-of select="$empty-line"/>
                     <xsl:value-of select="$empty"/>         from.<xsl:value-of select="@get-method"/>().accept(m_visitor);<xsl:value-of select="$empty-line"/>
                     <xsl:value-of select="$empty"/>      }<xsl:value-of select="$empty-line"/>
                  </xsl:otherwise>
               </xsl:choose>
               <xsl:value-of select="$empty-line"/>
            </xsl:for-each>
         </xsl:when>
      </xsl:choose>
      <xsl:value-of select="$empty"/>      m_objs.pop();<xsl:value-of select="$empty-line"/>
      <xsl:choose>
         <xsl:when test="@root='true'">
            <xsl:value-of select="$empty"/>      m_linker.finish();<xsl:value-of select="$empty-line"/>
            <xsl:value-of select="$empty"/>      <xsl:value-of select="'      '"/><xsl:value-of select="@field-name"/> = <xsl:value-of select="@param-name"/>;<xsl:value-of select="$empty-line"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$empty-line"/>
            <xsl:value-of select="$empty"/>      Object parent = m_objs.peek();<xsl:value-of select="$empty-line"/>
            <xsl:value-of select="$empty-line"/>
            <xsl:value-of select="'      '"/>
            <xsl:for-each select="//entity/entity-ref[@name=$entity/@name]">
               <xsl:value-of select="$empty"/>if (parent instanceof <xsl:value-of select="../@entity-class"/>) {<xsl:value-of select="$empty-line"/>
               <xsl:value-of select="$empty"/>         m_linker.<xsl:value-of select="@on-event-method"/>((<xsl:value-of select="../@entity-class"/>) parent, <xsl:value-of select="$entity/@param-name"/>);<xsl:value-of select="$empty-line"/>
               <xsl:value-of select="$empty"/>      }<xsl:value-of select="$empty-line"/>
               <xsl:if test="position()!=last()"> else </xsl:if>
            </xsl:for-each>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="$empty"/>   }<xsl:value-of select="$empty-line"/>
   </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
