package org.unidal.maven.plugin.wizard;

import org.junit.Assert;
import org.junit.Test;
import org.unidal.helper.Files;
import org.unidal.maven.plugin.wizard.model.entity.Wizard;
import org.unidal.maven.plugin.wizard.model.transform.DefaultSaxParser;

public class WizardModelTest {
   @Test
   public void testModel() throws Exception {
      String expected = Files.forIO().readFrom(getClass().getResourceAsStream("wizard.xml"), "utf-8");
      Wizard wizard = DefaultSaxParser.parse(expected);

      Assert.assertEquals("XML is not well parsed!", expected.replace("\r", ""), wizard.toString().replace("\r", ""));
   }
}
